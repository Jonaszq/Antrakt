"""Syntezuje odgłosy tła do rozdziału 1: gwar, dzwonek teatralny, telefon, flesz,
oklaski, gramofon na bankiecie i jazdę autem w deszczu.

Użycie: python3 tools/dzwieki_tla.py

Korzysta z instrumentów i filtrów z tools/dzwieki.py. Pętle (gwar, gramofon, auto)
są tak zrobione, że koniec przechodzi płynnie w początek.

Wynik (dzwieki/tlo/):
  gwar.ogg       12 s pętla: rozmowy w tłumie, brzęk kieliszków
  dzwonek.wav    elektryczny dzwonek przed spektaklem
  telefon.wav    dwa sygnały starego telefonu komórkowego
  flesz.wav      ładowanie i błysk lampy fotografa
  oklaski.ogg    burza oklasków po spektaklu
  gramofon.ogg   16 s pętla: walc na pianinie z trzaskami płyty
  auto.ogg       8 s pętla: deszcz o dach, silnik, wycieraczki
  magazyn.ogg    14 s pętla: deszcz o blaszany dach, wiatr, kapanie do wiadra (rozdział 2)
  blacha.wav     skrzypienie i łomot blachy na wietrze
  upadek.wav     głuchy łomot przewracającego się manekina
  szczur.wav     szczur: drobne kroki i pisk
  trop.wav       dwie ciche nuty fortepianu, gdy Antoni wpadnie na nowy trop
"""
import subprocess
from pathlib import Path

import numpy as np

import dzwieki as dz
from dzwieki import SR, czas, dolny, fortepian, gorny, pasmo, sylaba, wstaw, zapisz_wav

los = np.random.default_rng(11)
FOLDER = Path("dzwieki/tlo")


def zapetl(x, zakladka=0.5):
    """Pętla bez trzasku: końcówka przenika się z początkiem."""
    n = int(zakladka * SR)
    wynik = x[:-n].copy()
    wynik[:n] = wynik[:n] * np.linspace(0, 1, n) + x[-n:] * np.linspace(1, 0, n)
    return wynik


def ogg(nazwa, x):
    tymczasowy = FOLDER / f"{nazwa}_tmp.wav"
    zapisz_wav(tymczasowy, x)
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(tymczasowy), "-c:a", "libvorbis",
                    "-q:a", "4", str(FOLDER / f"{nazwa}.ogg")], check=True)
    tymczasowy.unlink()


def gwar():
    dl = 12.5
    x = np.zeros(int(dl * SR))
    # dziesiątki zdań z mamroczących sylab, każde w innym miejscu i wysokości
    for _ in range(170):
        start = los.uniform(0, dl - 1.5)
        plec = los.choice(["k", "m"])
        zdanie = np.concatenate([sylaba(plec, int(los.integers(1, 9))) for _ in range(int(los.integers(3, 8)))])
        wstaw(x, dolny(zdanie, 2200), start, los.uniform(0.08, 0.25))
    for _ in range(8):  # śmiech: kilka szybkich "ha"
        start = los.uniform(0, dl - 1.5)
        for k in range(4):
            wstaw(x, sylaba("k" if los.random() < 0.5 else "m", 0) * 0.5, start + k * 0.13, 0.2)
    for _ in range(6):  # brzęk kieliszków
        t = czas(0.6)
        f = los.uniform(2600, 3400)
        brzek = (np.sin(2 * np.pi * f * t) + 0.5 * np.sin(2 * np.pi * f * 1.51 * t)) * np.exp(-t * 9)
        wstaw(x, brzek, los.uniform(0, dl - 1), 0.05)
    szum = dolny(los.standard_normal(len(x)), 700) * 0.04  # pogłos dużej sali
    x = dz.poglos(x + szum, mokry=0.4)
    x = zapetl(x)
    return x / np.max(np.abs(x)) * 0.6


def dzwonek():
    t = czas(2.6)
    # młoteczek bije w czaszę ok. 30 razy na sekundę
    mlotek = (np.sin(2 * np.pi * 30 * t) > 0.6).astype(float)
    czasza = sum(np.sin(2 * np.pi * f * t) * a for f, a in ((1460, 1.0), (2930, 0.4), (3810, 0.25)))
    x = czasza * dolny(mlotek, 300) * 3
    x *= np.minimum(1, t / 0.01) * np.clip((2.4 - t) / 0.2, 0, 1)
    x = dz.poglos(x, mokry=0.3)
    return x / np.max(np.abs(x)) * 0.5


def telefon():
    x = np.zeros(int(4.2 * SR))
    for start in (0.0, 2.1):
        for k, nuta in enumerate(["E6", "C6", "E6", "C6", "E6", "C6"]):
            t = czas(0.13)
            ton = np.sign(np.sin(2 * np.pi * dz.hz(nuta) * t)) * 0.3 + np.sin(2 * np.pi * dz.hz(nuta) * t)
            ton *= np.minimum(1, t / 0.005) * np.minimum(1, (0.13 - t) / 0.01)
            wstaw(x, dolny(ton, 5000), start + k * 0.15, 0.4)
    return x


def flesz():
    t = czas(1.3)
    f = 2000 + 5500 * np.clip(t / 0.9, 0, 1)  # ładowanie kondensatora: rosnący pisk
    pisk = np.sin(2 * np.pi * np.cumsum(f) / SR) * 0.05 * (t < 0.9)
    klik = gorny(los.standard_normal(len(t)), 2000) * np.exp(-np.clip(t - 0.95, 0, None) * 80) * (t >= 0.95)
    x = pisk + klik * 0.8
    return x / np.max(np.abs(x)) * 0.5


def oklaski():
    dl = 7.0
    x = np.zeros(int(dl * SR))
    for _ in range(140):  # każdy widz klaszcze w swoim tempie
        tempo = los.uniform(3.5, 6.0)
        jasnosc = los.uniform(1200, 3500)
        t0 = los.uniform(0, 0.6)
        for s in np.arange(t0, dl, 1 / tempo):
            tt = czas(0.03)
            klask = pasmo(los.standard_normal(len(tt)), jasnosc * 0.5, jasnosc) * np.exp(-tt * 180)
            wstaw(x, klask, max(0.0, s + los.uniform(-0.01, 0.01)), los.uniform(0.2, 0.5))
    t = czas(dl)
    x *= np.minimum(1, t / 0.8) * np.clip((dl - t) / 2.5, 0, 1)
    x = dz.poglos(x, mokry=0.35)
    return x / np.max(np.abs(x)) * 0.55


def gramofon():
    tempo = 0.5  # sekund na ćwierćnutę, walc 3/4
    dl = 16 * 3 * tempo + 0.6
    x = np.zeros(int(dl * SR))
    akordy = [("F2", ["A3", "C4", "F4"]), ("C2", ["G3", "Bb3", "E4"]), ("C2", ["G3", "Bb3", "E4"]),
              ("F2", ["A3", "C4", "F4"]), ("Bb1", ["Bb3", "D4", "F4"]), ("F2", ["A3", "C4", "F4"]),
              ("C2", ["G3", "Bb3", "E4"]), ("F2", ["A3", "C4", "F4"])] * 2
    melodia = ["C5", "A4", "F5", "E5", "G5", "C5", "Bb4", "E5", "D5", "C5", "A4", "F4",
               "D5", "F5", "Bb5", "A5", "F5", "C5", "G5", "E5", "Bb4", "A4", "F4", "F4"] * 2
    for i, (bas, akord) in enumerate(akordy):
        s = i * 3 * tempo
        wstaw(x, fortepian(bas, tempo * 0.9, 0.7), s)
        for k in (1, 2):
            for nuta in akord:
                wstaw(x, fortepian(nuta, tempo * 0.6, 0.3), s + k * tempo)
        for k in range(3):
            nuta = melodia[(i * 3 + k) % len(melodia)]
            if k == 0 or i % 2 == 0:
                wstaw(x, fortepian(nuta, tempo * (0.9 if k else 1.4), 0.6), s + k * tempo)
    # stara płyta: wąskie pasmo i trzaski
    x = pasmo(x, 250, 3800)
    for s in los.uniform(0, dl, 90):
        wstaw(x, np.array([1.0, -0.6, 0.3]) * los.uniform(0.05, 0.25), s)
    x += dolny(los.standard_normal(len(x)), 3000) * 0.006
    x = dz.poglos(x, mokry=0.25)
    x = zapetl(x, 0.6)
    return x / np.max(np.abs(x)) * 0.5


def auto():
    dl = 8.4
    t = czas(dl)
    # deszcz o dach i szyby: szum i pojedyncze krople
    x = pasmo(los.standard_normal(len(t)), 900, 7000) * 0.12
    for s in los.uniform(0, dl, 900):
        kt = czas(0.02)
        wstaw(x, gorny(los.standard_normal(len(kt)), 2500) * np.exp(-kt * 300), s, los.uniform(0.05, 0.2))
    # silnik na wolnych obrotach: niski pomruk, który lekko faluje
    f = 38 + 2 * np.sin(2 * np.pi * t / dl * 2)
    faza = 2 * np.pi * np.cumsum(f) / SR
    silnik = sum(np.sin(k * faza) / k for k in range(1, 8))
    x += dolny(silnik, 180) * 0.35
    # wycieraczki: gumowe szurnięcie i stuknięcie co 1.4 s
    for s in np.arange(0.2, dl - 0.3, 1.4):
        wt = czas(0.45)
        szur = pasmo(los.standard_normal(len(wt)), 300, 1600) * np.sin(np.pi * wt / 0.45) * 0.25
        wstaw(x, szur, s)
        wstaw(x, np.sin(2 * np.pi * 90 * czas(0.06)) * np.exp(-czas(0.06) * 60) * 0.4, s + 0.45)
    x = zapetl(x)
    return x / np.max(np.abs(x)) * 0.6


def kapniecie(f=1400):
    t = czas(0.25)
    ton = np.sin(2 * np.pi * (f + 900 * np.exp(-t * 40)) * t) * np.exp(-t * 22)
    return ton


def magazyn():
    dl = 14.4
    t = czas(dl)
    # deszcz bębniący o blaszany dach hali: szum i gęste, metaliczne krople
    x = pasmo(los.standard_normal(len(t)), 500, 5000) * 0.10
    for s in los.uniform(0, dl, 2200):
        kt = czas(0.03)
        f = los.uniform(1800, 3800)
        wstaw(x, np.sin(2 * np.pi * f * kt) * np.exp(-kt * 160), s, los.uniform(0.01, 0.05))
    # wiatr: niski, falujący szum
    wiatr = dolny(los.standard_normal(len(t)), 260) * (0.6 + 0.4 * np.sin(2 * np.pi * t / dl * 2))
    x += wiatr * 0.5
    # kapanie z dziury w dachu do wiadra, nierówno
    s = 0.4
    while s < dl - 0.4:
        wstaw(x, kapniecie(los.uniform(1200, 1500)), s, 0.25)
        s += los.uniform(0.9, 1.6)
    x = dz.poglos(x, mokry=0.45)
    x = zapetl(x)
    return x / np.max(np.abs(x)) * 0.6


def blacha():
    t = czas(2.2)
    # skrzypienie: pisk o drżącej wysokości
    f = 380 + 60 * np.sin(2 * np.pi * 3 * t) + 120 * t
    skrzyp = np.sign(np.sin(2 * np.pi * np.cumsum(f) / SR)) * np.sin(np.pi * np.clip(t / 1.3, 0, 1)) * 0.15
    skrzyp = pasmo(skrzyp, 300, 2500)
    # łomot luźnego arkusza
    x = skrzyp
    for s, a in ((1.35, 1.0), (1.55, 0.6), (1.7, 0.3)):
        lt = czas(0.5)
        lomot = sum(np.sin(2 * np.pi * fr * lt) for fr in (90, 143, 231, 387)) * np.exp(-lt * 9)
        lomot += pasmo(los.standard_normal(len(lt)), 200, 3000) * np.exp(-lt * 30) * 0.8
        wstaw(x, lomot * 0.3, s, a)
    x = dz.poglos(x, mokry=0.5)
    return x / np.max(np.abs(x)) * 0.5


def upadek():
    t = czas(1.2)
    x = np.zeros(len(t))
    for s, a in ((0.0, 1.0), (0.18, 0.4)):
        lt = czas(0.6)
        luk = dolny(los.standard_normal(len(lt)), 400) * np.exp(-lt * 14)
        luk += np.sin(2 * np.pi * 70 * lt) * np.exp(-lt * 10) * 0.6
        wstaw(x, luk, s, a)
    x = dz.poglos(x, mokry=0.5)
    return x / np.max(np.abs(x)) * 0.6


def szczur():
    x = np.zeros(int(1.0 * SR))
    for s in np.arange(0.0, 0.6, 0.045):  # drobne kroki
        kt = czas(0.015)
        wstaw(x, gorny(los.standard_normal(len(kt)), 3000) * np.exp(-kt * 300), s + los.uniform(0, 0.01), 0.15)
    pt = czas(0.12)
    pisk = np.sin(2 * np.pi * (4200 + 800 * np.sin(2 * np.pi * 25 * pt)) * pt) * np.sin(np.pi * pt / 0.12)
    wstaw(x, pisk, 0.65, 0.2)
    return x / np.max(np.abs(x)) * 0.4


def trop():
    x = np.zeros(int(2.4 * SR))
    wstaw(x, fortepian("A4", 0.25, 0.6), 0.0, 0.5)
    wstaw(x, fortepian("E5", 0.6, 0.6), 0.16, 0.5)
    x = dz.poglos(x, mokry=0.25)
    return x / np.max(np.abs(x)) * 0.35


def main():
    FOLDER.mkdir(parents=True, exist_ok=True)
    zapisz_wav(FOLDER / "dzwonek.wav", dzwonek())
    zapisz_wav(FOLDER / "telefon.wav", telefon())
    zapisz_wav(FOLDER / "flesz.wav", flesz())
    ogg("gwar", gwar())
    ogg("oklaski", oklaski())
    ogg("gramofon", gramofon())
    ogg("auto", auto())
    ogg("magazyn", magazyn())
    zapisz_wav(FOLDER / "blacha.wav", blacha())
    zapisz_wav(FOLDER / "upadek.wav", upadek())
    zapisz_wav(FOLDER / "szczur.wav", szczur())
    zapisz_wav(FOLDER / "trop.wav", trop())


if __name__ == "__main__":
    main()
