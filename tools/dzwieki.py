"""Syntezuje dźwięki gry od zera: muzykę do filmiku wstępnego i odgłosy kroków.

Użycie: python3 tools/dzwieki.py [--bez-muzyki]

Bez sampli i płatnych narzędzi: wszystko powstaje z sinusów i szumu
(numpy + scipy), a muzyka jest kodowana do OGG przez ffmpeg.

Wynik:
  dzwieki/muzyka/wstep.ogg          ok. 44 s, d-moll, 70 BPM, pod ujęcia filmiku:
                                    0-5 s napis, 5-19 s teatr (temat na fortepianie),
                                    19-30 s magazyn (napięcie, bicie serca),
                                    30-44 s kurtyna i tytuł (narastanie i akord)
  dzwieki/kroki/<podłoże>_<n>.wav   po 4 warianty: drewno, marmur, dywan, mokry
  dzwieki/glosy/<kobieta|mezczyzna>_<n>.wav
                                    8 sylab "blabla" na głos w okienku dialogu
"""
import subprocess
import sys
import wave
from pathlib import Path

import numpy as np
from scipy import signal

SR = 44100
los = np.random.default_rng(3)


def czas(sek):
    return np.arange(int(sek * SR)) / SR


def hz(nuta):
    """Nazwa nuty, np. "D3", "C#5", "Bb4", na częstotliwość."""
    nazwy = {"C": 0, "D": 2, "E": 4, "F": 5, "G": 7, "A": 9, "B": 11}
    p = nazwy[nuta[0]]
    reszta = nuta[1:]
    if reszta[0] == "#":
        p, reszta = p + 1, reszta[1:]
    elif reszta[0] == "b":
        p, reszta = p - 1, reszta[1:]
    midi = 12 * (int(reszta) + 1) + p
    return 440.0 * 2 ** ((midi - 69) / 12)


def wstaw(cel, dzwiek, start, glosnosc=1.0):
    i = int(start * SR)
    n = min(len(dzwiek), len(cel) - i)
    if n > 0:
        cel[i:i + n] += dzwiek[:n] * glosnosc


def dolny(x, f, rzad=2):
    b, a = signal.butter(rzad, f / (SR / 2), "low")
    return signal.lfilter(b, a, x)


def pasmo(x, f0, f1, rzad=2):
    b, a = signal.butter(rzad, [f0 / (SR / 2), f1 / (SR / 2)], "band")
    return signal.lfilter(b, a, x)


def gorny(x, f, rzad=2):
    b, a = signal.butter(rzad, f / (SR / 2), "high")
    return signal.lfilter(b, a, x)


# ---------- instrumenty ----------

def fortepian(nuta, dl, sila=1.0):
    """Struna uderzona młoteczkiem: alikwoty z lekką nieharmonicznością i szybszym gaśnięciem góry."""
    f = hz(nuta)
    t = czas(dl + 2.5)
    x = np.zeros_like(t)
    for k in range(1, 10):
        fk = k * f * np.sqrt(1 + 0.0004 * k * k)
        if fk > SR / 2.2:
            break
        x += np.sin(2 * np.pi * fk * t) * np.exp(-t * (0.9 + 0.55 * k)) / k ** 1.25
    x *= np.minimum(1, t / 0.004)
    # puszczenie klawisza: struna gaśnie szybciej
    x *= np.where(t < dl, 1.0, np.exp(-(t - dl) * 4.0))
    mlotek = gorny(los.standard_normal(len(t)), 2000) * np.exp(-t * 120) * 0.06
    return (x + mlotek) * sila * 0.35


def pila(f, t, alikwoty=14):
    x = np.zeros_like(t)
    for k in range(1, alikwoty + 1):
        if k * f > SR / 2.5:
            break
        x += np.sin(2 * np.pi * k * f * t) / k
    return x


def plama(nuty, dl, jasnosc=900, atak=1.5, wybrzmienie=1.8):
    """Smyczkowa plama: trzy rozstrojone piły na nutę, przez filtr dolnoprzepustowy."""
    t = czas(dl + wybrzmienie)
    x = np.zeros_like(t)
    for nuta in nuty:
        f = hz(nuta)
        for cent in (-7, 0, 6):
            x += pila(f * 2 ** (cent / 1200), t + los.random())
    x = dolny(x, jasnosc)
    obw = np.minimum(1, t / atak) * np.where(t < dl, 1.0, np.exp(-(t - dl) * 3 / wybrzmienie))
    return x * obw * 0.05 / max(1, len(nuty)) ** 0.5


def bas(nuta, dl, atak=2.0):
    t = czas(dl + 1.5)
    f = hz(nuta) * (1 + 0.003 * np.sin(2 * np.pi * 5 * t))  # wibrato wiolonczeli
    faza = 2 * np.pi * np.cumsum(f) / SR
    x = sum(np.sin(k * faza) / k for k in range(1, 8))
    x = dolny(x, 380)
    obw = np.minimum(1, t / atak) * np.where(t < dl, 1.0, np.exp(-(t - dl) * 2))
    return x * obw * 0.18


def serce(sila=1.0):
    """Dwa głuche uderzenia: lub-dub."""
    t = czas(0.6)
    x = np.zeros_like(t)
    for start, glos in ((0.0, 1.0), (0.22, 0.7)):
        tt = np.clip(t - start, 0, None)
        f = 48 + 30 * np.exp(-tt * 30)
        x += np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-tt * 14) * (t >= start) * glos
    return x * 0.5 * sila


def tremolo(nuty, dl):
    """Drżące, zbyt bliskie siebie wysokie skrzypce: niepokój."""
    t = czas(dl)
    x = sum(np.sin(2 * np.pi * hz(n) * t) + 0.3 * np.sin(4 * np.pi * hz(n) * t) for n in nuty)
    tr = 0.6 + 0.4 * np.sin(2 * np.pi * 7.5 * t)
    obw = np.minimum(1, t / 3.0) * np.minimum(1, (dl - t) / 1.0)
    return x * tr * obw * 0.025


def kocioł_tremolo(dl):
    t = czas(dl)
    szum = dolny(los.standard_normal(len(t)), 160, 3)
    ton = np.sin(2 * np.pi * 73.4 * t)
    obw = (t / dl) ** 2
    return (szum * 2.5 + ton * 0.4) * obw * 0.35


def uderzenie():
    t = czas(3.0)
    f = 70 + 40 * np.exp(-t * 20)
    x = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-t * 2.2)
    x += dolny(los.standard_normal(len(t)), 300) * np.exp(-t * 6) * 0.8
    return x * 0.5


def poglos(x, mokry=0.28, przesuniecie=0):
    """Pogłos Schroedera: grzebienie równolegle i dwa filtry wszechprzepustowe."""
    y = np.zeros_like(x)
    for d in (1116, 1188, 1277, 1356, 1422, 1491, 1557, 1617):
        d += przesuniecie
        a = np.zeros(d + 1)
        a[0], a[d] = 1, -0.86
        y += signal.lfilter([1], a, x)
    y = dolny(y / 8, 4500)
    for d in (556, 441, 341, 225):
        d += przesuniecie // 2
        b = np.zeros(d + 1)
        a = np.zeros(d + 1)
        b[0], b[d] = -0.5, 1
        a[0], a[d] = 1, -0.5
        y = signal.lfilter(b, a, y)
    return x * (1 - mokry) + y * mokry


# ---------- muzyka do filmiku ----------

BEAT = 60 / 70


def muzyka():
    dl = 44.0
    m = np.zeros(int(dl * SR))

    # 0-5 s: napis. Ciemna plama d-moll i bas.
    wstaw(m, plama(["D3", "F3", "A3"], 4.6, jasnosc=600, atak=2.5), 0.0)
    wstaw(m, bas("D2", 4.8), 0.3)

    # 5-19 s: teatr w deszczu. Akordy i - VI - iv - V, temat na fortepianie.
    akordy = [(["D3", "F3", "A3"], "D2"), (["Bb2", "D3", "F3"], "Bb1"),
              (["G2", "Bb2", "D3"], "G1"), (["A2", "C#3", "E3"], "A1")]
    for i, (nuty, b) in enumerate(akordy):
        start = 5.0 + i * 4 * BEAT
        wstaw(m, plama(nuty, 4 * BEAT + 0.4, jasnosc=1100, atak=0.8), start)
        wstaw(m, bas(b, 4 * BEAT, atak=0.6), start)
    temat = [("A4", 1), ("D5", 1), ("F5", 1), ("E5", 0.5), ("D5", 0.5),
             ("C#5", 1.5), ("A4", 0.5), ("Bb4", 1), ("A4", 1),
             ("G4", 1), ("Bb4", 0.5), ("A4", 0.5), ("G4", 1), ("F4", 1),
             ("E4", 1.5), ("F4", 0.5), ("E4", 1), ("C#4", 1)]
    t = 5.0 + BEAT
    for nuta, ile in temat:
        wstaw(m, fortepian(nuta, ile * BEAT * 0.95, sila=0.9), t)
        t += ile * BEAT
    for i, nuta in enumerate(["D3", "A3", "Bb2", "F3", "G2", "D3", "A2", "E3"]):  # lewa ręka
        wstaw(m, fortepian(nuta, 2 * BEAT, sila=0.45), 5.0 + i * 2 * BEAT)

    # 19-30 s: magazyn. Bas trzyma D, wysokie skrzypce się ocierają, bije serce.
    wstaw(m, bas("D2", 10.5, atak=1.5), 19.2)
    wstaw(m, plama(["D2", "A2", "Eb3"], 10.0, jasnosc=500, atak=2.0), 19.2)
    wstaw(m, tremolo(["A5", "Bb5"], 10.8), 19.4)
    for i, s in enumerate(np.arange(20.0, 29.6, 1.05)):
        wstaw(m, serce(0.6 + 0.04 * i), s)
    for s, nuta in ((21.5, "D6"), (24.1, "C#6"), (26.6, "D6"), (28.4, "Eb6")):  # jak dzwonek telefonu
        wstaw(m, fortepian(nuta, 0.4, sila=0.35), s)

    # 30-44 s: kurtyna. Narastanie na dominancie, potem uderzenie i pełny akord d-moll.
    wstaw(m, plama(["Bb2", "D3", "F3", "A3"], 1.9, jasnosc=900, atak=1.2), 30.0)
    wstaw(m, plama(["A2", "C#3", "E3", "G3"], 1.8, jasnosc=1400, atak=0.6), 31.9)
    wstaw(m, kocioł_tremolo(3.6), 30.0)
    kulm = 33.6
    wstaw(m, uderzenie(), kulm)
    wstaw(m, plama(["D2", "A2", "D3", "F3", "A3", "D4"], 6.5, jasnosc=1800, atak=0.15, wybrzmienie=3.5), kulm)
    wstaw(m, bas("D1", 7.0, atak=0.1), kulm)
    for nuta, s in (("D4", 0), ("F4", 0), ("A4", 0), ("D5", 0), ("A5", 1.0), ("F5", 1.5),
                    ("E5", 2.0), ("D5", 2.6)):
        wstaw(m, fortepian(nuta, 3.0, sila=0.8), kulm + s * BEAT)
    wstaw(m, fortepian("D3", 5.0, sila=0.6), kulm)

    lewy = poglos(m, przesuniecie=0)
    prawy = poglos(m, przesuniecie=23)
    st = np.stack([lewy, prawy], axis=1)
    st[-int(2 * SR):] *= np.linspace(1, 0, int(2 * SR))[:, None]
    return st / np.max(np.abs(st)) * 0.85


# ---------- kroki ----------

def krok(podloze, n):
    g = np.random.default_rng(100 * ["drewno", "marmur", "dywan", "mokry"].index(podloze) + n)
    t = czas(0.35)
    szum = g.standard_normal(len(t))
    p = 1 + g.uniform(-0.06, 0.06)  # każdy krok trochę inny
    if podloze == "drewno":
        # obcas, potem czubek buta; ciepłe pudło desek
        x = np.zeros_like(t)
        for start, glos in ((0.0, 1.0), (0.035 + g.uniform(0, 0.01), 0.55)):
            tt = np.clip(t - start, 0, None)
            puk = pasmo(szum, 180 * p, 1400 * p) * np.exp(-tt * 55)
            pudlo = np.sin(2 * np.pi * 120 * p * tt) * np.exp(-tt * 40)
            x += (puk + pudlo * 0.8) * glos * (t >= start)
        if n == 2:  # skrzypnięcie deski
            tt = np.clip(t - 0.06, 0, None)
            f = 620 + 90 * np.sin(2 * np.pi * 9 * tt)
            x += np.sign(np.sin(2 * np.pi * np.cumsum(f) / SR)) * np.exp(-tt * 18) * 0.05 * (t >= 0.06)
    elif podloze == "marmur":
        # twardy obcas na kamieniu i krótkie dzwonienie posadzki
        x = np.zeros_like(t)
        for start, glos in ((0.0, 1.0), (0.03 + g.uniform(0, 0.01), 0.45)):
            tt = np.clip(t - start, 0, None)
            klik = pasmo(szum, 1500 * p, 7000) * np.exp(-tt * 140)
            ton = np.sin(2 * np.pi * 2300 * p * tt) * np.exp(-tt * 70) * 0.15
            x += (klik + ton) * glos * (t >= start)
        x = poglos(x, mokry=0.35)
    elif podloze == "dywan":
        # stłumione stąpnięcie
        x = dolny(szum, 500 * p, 3) * np.exp(-t * 25) * np.minimum(1, t / 0.01) * 1.6
    else:  # mokry chodnik: krok i chlupnięcie
        tt = t
        klik = pasmo(szum, 300 * p, 3000) * np.exp(-tt * 60)
        chlup = gorny(szum, 2500) * np.exp(-np.clip(tt - 0.02, 0, None) * 18) * (tt >= 0.02) * 0.35
        x = klik + chlup
    x *= np.minimum(1, t / 0.002)
    return x / np.max(np.abs(x)) * 0.7


# ---------- głosy postaci ("blablabla") ----------

SAMOGLOSKI = {"a": (800, 1200, 2500), "e": (500, 1800, 2500), "o": (500, 900, 2400),
              "i": (320, 2300, 3000), "u": (350, 800, 2300), "y": (420, 1500, 2400)}
GLOSKI = ["ba", "la", "ble", "da", "bo", "li", "du", "me", "ny", "wa"]


def sylaba(plec, n):
    """Krótka mamrocząca sylaba: impulsy krtani przez formanty samogłoski, z lekkim spółgłoskowym początkiem."""
    g = np.random.default_rng(500 + n + (0 if plec == "k" else 50))
    gloska = GLOSKI[n % len(GLOSKI)]
    dl = 0.085 + g.uniform(0, 0.025)
    t = czas(dl)
    f0 = (225 if plec == "k" else 118) * (1 + g.uniform(-0.05, 0.05))
    f = f0 * (1 + 0.06 * np.exp(-t * 30)) * (1 - 0.05 * t / dl)  # lekki spadek intonacji
    faza = 2 * np.pi * np.cumsum(f) / SR
    krtan = sum(np.sin(k * faza) / k ** 1.2 for k in range(1, 30) if k * f0 < SR / 2.5)
    f1, f2, f3 = SAMOGLOSKI[gloska[-1]]
    skala = 1.12 if plec == "k" else 1.0
    x = (pasmo(krtan, f1 * skala * 0.8, f1 * skala * 1.25) * 1.0
         + pasmo(krtan, f2 * skala * 0.88, f2 * skala * 1.12) * 0.6
         + pasmo(krtan, f3 * skala * 0.92, f3 * skala * 1.08) * 0.25)
    obw = np.minimum(1, t / 0.012) * np.minimum(1, (dl - t) / 0.025)
    if gloska[0] in "bd":  # zwarcie: najpierw cisza, potem plask
        obw *= np.minimum(1, t / 0.02)
        x += gorny(g.standard_normal(len(t)), 1500) * np.exp(-t * 200) * 0.08
    elif gloska[0] in "lmnw":  # miękki, nosowy początek
        x = x * np.minimum(1, t / 0.03) + np.sin(faza) * np.exp(-t * 40) * 0.3
    x *= obw
    return x / np.max(np.abs(x)) * 0.6


def zapisz_wav(sciezka, x):
    dane = (np.clip(x, -1, 1) * 32767).astype(np.int16)
    with wave.open(str(sciezka), "wb") as w:
        w.setnchannels(1 if dane.ndim == 1 else dane.shape[1])
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(dane.tobytes())


def main():
    kroki = Path("dzwieki/kroki")
    kroki.mkdir(parents=True, exist_ok=True)
    for podloze in ("drewno", "marmur", "dywan", "mokry"):
        for n in range(1, 5):
            x = krok(podloze, n)
            koniec = np.nonzero(np.abs(x) > 0.002)[0].max() + 200
            zapisz_wav(kroki / f"{podloze}_{n}.wav", x[:koniec])
    glosy = Path("dzwieki/glosy")
    glosy.mkdir(parents=True, exist_ok=True)
    for plec, nazwa in (("k", "kobieta"), ("m", "mezczyzna")):
        for n in range(1, 9):
            zapisz_wav(glosy / f"{nazwa}_{n}.wav", sylaba(plec, n))
    if "--bez-muzyki" in sys.argv:
        return
    folder = Path("dzwieki/muzyka")
    folder.mkdir(parents=True, exist_ok=True)
    tymczasowy = folder / "wstep_tmp.wav"
    zapisz_wav(tymczasowy, muzyka())
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(tymczasowy), "-c:a", "libvorbis",
                    "-q:a", "5", str(folder / "wstep.ogg")], check=True)
    tymczasowy.unlink()


if __name__ == "__main__":
    main()
