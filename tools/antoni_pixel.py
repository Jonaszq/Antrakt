"""Rysuje Antoniego jako pixel art, klatka po klatce, i zapisuje arkusze do Godota.

Użycie: python3 tools/antoni_pixel.py [folder_wyjsciowy]

Postać składa się z prostych kształtów w "materiałach" (płaszcz, kapelusz, skóra...).
Każdy materiał ma rampę kolorów, a cieniowanie liczy się samo: krawędzie od strony
światła są jaśniejsze, od strony cienia ciemniejsze, a wszystko blisko latarni łapie
ciepły blask. Na końcu dochodzi ciemny kontur. Animacje (stanie 6 klatek, chód 8)
powstają przez przesuwanie nóg, rąk i latarni zależnie od fazy kroku.
"""
import math
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

SZER, WYS = 40, 68
ZIEMIA = 65  # wiersz, na którym stoją stopy
SRODEK = 20

KONTUR = (12, 8, 10)

# Czy Antoni trzyma latarnię. Na co dzień nie; wersja z latarnią
# (postacie/antoni/antoni_latarnia.tscn) czeka na scenę, w której będzie potrzebna.
Z_LATARNIA = False

# rampy od najciemniejszego do najjaśniejszego
RAMPY = {
    "plaszcz": [(24, 17, 18), (40, 28, 26), (60, 42, 34), (86, 61, 45), (112, 82, 58)],
    "kapelusz": [(18, 16, 20), (30, 27, 33), (46, 41, 48), (68, 61, 66)],
    "opaska": [(56, 37, 24), (92, 63, 36), (128, 90, 50)],
    "skora": [(96, 54, 46), (152, 98, 74), (204, 148, 112), (234, 188, 150)],
    "zarost": [(70, 44, 38), (104, 70, 56)],
    "wlosy": [(20, 14, 14), (36, 25, 22), (54, 38, 30)],
    "koszula": [(112, 104, 104), (168, 162, 154), (216, 210, 198)],
    "krawat": [(66, 12, 20), (114, 24, 32), (164, 42, 44)],
    "kamizelka": [(20, 18, 24), (32, 30, 38), (48, 46, 56)],
    "spodnie": [(18, 18, 24), (30, 30, 38), (46, 46, 56)],
    "buty": [(16, 11, 11), (32, 22, 19), (54, 37, 30), (80, 57, 42)],
    "mosiadz": [(84, 52, 22), (142, 98, 38), (200, 152, 62), (244, 206, 116)],
    "plomien": [(255, 170, 56), (255, 222, 132), (255, 251, 222)],
    "oczy": [(14, 10, 12)],
}
NAZWY = list(RAMPY)


class Plotno:
    """Warstwa materiałów: w każdym pikselu numer materiału i ewentualny wymuszony odcień."""

    def __init__(self):
        self.mat = Image.new("L", (SZER, WYS), 0)
        self.wym = Image.new("L", (SZER, WYS), 255)  # 255 = cieniuj automatycznie
        self.dm = ImageDraw.Draw(self.mat)
        self.dw = ImageDraw.Draw(self.wym)

    def _id(self, nazwa):
        return NAZWY.index(nazwa) + 1

    def wielokat(self, pkt, nazwa, odcien=255):
        self.dm.polygon(pkt, fill=self._id(nazwa))
        self.dw.polygon(pkt, fill=odcien)

    def prost(self, x0, y0, x1, y1, nazwa, odcien=255):
        self.dm.rectangle((x0, y0, x1, y1), fill=self._id(nazwa))
        self.dw.rectangle((x0, y0, x1, y1), fill=odcien)

    def elipsa(self, x0, y0, x1, y1, nazwa, odcien=255):
        self.dm.ellipse((x0, y0, x1, y1), fill=self._id(nazwa))
        self.dw.ellipse((x0, y0, x1, y1), fill=odcien)

    def linia(self, pkt, nazwa, odcien=255):
        self.dm.line(pkt, fill=self._id(nazwa))
        self.dw.line(pkt, fill=odcien)

    def piksel(self, x, y, nazwa, odcien=255):
        self.prost(x, y, x, y, nazwa, odcien)


def pokoloruj(p: Plotno, latarnia, swiatlo=(-1, -1)):
    """Zamienia materiały na kolory z automatycznym cieniowaniem i konturem."""
    mat = np.asarray(p.mat).astype(int)
    wym = np.asarray(p.wym).astype(int)
    out = np.zeros((WYS, SZER, 4), np.uint8)
    lx, ly = swiatlo
    for y in range(WYS):
        for x in range(SZER):
            m = mat[y, x]
            if not m:
                continue
            nazwa = NAZWY[m - 1]
            rampa = RAMPY[nazwa]
            n = len(rampa)
            if wym[y, x] != 255:
                i = wym[y, x]
            else:
                i = max(0, n // 2 - (1 if n >= 4 else 0))

                def inny(dx, dy):
                    xx, yy = x + dx, y + dy
                    if not (0 <= xx < SZER and 0 <= yy < WYS):
                        return True
                    return mat[yy, xx] != m

                if inny(lx, 0) or inny(0, ly):
                    i += 1
                if inny(-lx, 0) or inny(0, -ly):
                    i -= 1
                if latarnia is not None:
                    d = math.hypot(x - latarnia[0], (y - latarnia[1]) * 1.3)
                    if d < 5:
                        i += 2
                    elif d < 10:
                        i += 1
            i = min(max(i, 0), n - 1)
            out[y, x, :3] = rampa[i]
            out[y, x, 3] = 255
    # kontur dookoła sylwetki
    pelne = out[:, :, 3] > 0
    sasiad = np.zeros_like(pelne)
    sasiad[1:, :] |= pelne[:-1, :]
    sasiad[:-1, :] |= pelne[1:, :]
    sasiad[:, 1:] |= pelne[:, :-1]
    sasiad[:, :-1] |= pelne[:, 1:]
    kontur = sasiad & ~pelne
    out[kontur, :3] = KONTUR
    out[kontur, 3] = 255
    return Image.fromarray(out, "RGBA")


def latarnia(p: Plotno, x, y, plomien):
    """Latarnia wisząca na dłoni; (x, y) to miejsce chwytu. Zwraca środek światła."""
    p.linia([(x, y), (x, y + 1)], "mosiadz", 1)
    p.prost(x - 2, y + 2, x + 2, y + 2, "mosiadz", 2)
    p.prost(x - 3, y + 3, x + 3, y + 8, "mosiadz", 1)
    p.prost(x - 2, y + 4, x + 2, y + 7, "plomien", 0)
    p.prost(x - 1, y + 5, x + 1, y + 6, "plomien", 1 + plomien)
    p.piksel(x, y + 5 - plomien, "plomien", 2)
    p.prost(x - 3, y + 9, x + 3, y + 9, "mosiadz", 2)
    p.linia([(x - 3, y + 3), (x - 3, y + 8)], "mosiadz", 0)
    return (x, y + 5)


def nogi_przod(p, faza, chod):
    """Nogi widziane z przodu lub z tyłu. Zwraca podskok tułowia."""
    s = math.sin(faza * 2 * math.pi) if chod else 0.0
    unies_l = round(max(0.0, s) * 2)
    unies_p = round(max(0.0, -s) * 2)
    for x0, u in ((14, unies_l), (22, unies_p)):
        dol = ZIEMIA - 3 - u
        p.prost(x0, 50, x0 + 4, dol, "spodnie")
        p.prost(x0 - 1, dol + 1, x0 + 4, dol + 3, "buty")
    return -1 if chod and abs(s) < 0.5 else 0


def antoni_przod(faza, chod, plomien, tyl=False):
    p = Plotno()
    bob = nogi_przod(p, faza, chod)
    s = math.sin(faza * 2 * math.pi) if chod else 0.0
    oddech = 0 if chod else (-1 if 0.25 <= faza < 0.75 else 0)
    b = bob + oddech
    sway = round(s)

    # ręce za płaszczem: rękaw + dłoń, ręka z latarnią po stronie ekranu "lewej" od przodu
    lat = None
    reka_lat = 1 if tyl else -1  # -1 = lewa strona ekranu
    for strona in (-1, 1):
        x_reka = SRODEK + strona * 11
        machniecie = round(s * 1.5) * (1 if strona == reka_lat else -1)
        p.wielokat([(x_reka - 2, 19 + b), (x_reka + 2, 19 + b), (x_reka + 2 * strona + 2, 36 + b + machniecie),
                    (x_reka + 2 * strona - 2, 36 + b + machniecie)], "plaszcz", 1)
        p.prost(x_reka + 2 * strona - 2, 35 + b + machniecie, x_reka + 2 * strona + 2, 36 + b + machniecie,
                "plaszcz", 2)  # mankiet
        dlon_x = x_reka + 2 * strona
        p.prost(dlon_x - 1, 37 + b + machniecie, dlon_x + 1, 39 + b + machniecie, "skora")
        if strona == reka_lat and Z_LATARNIA:
            lat = latarnia(p, dlon_x, 40 + b + machniecie, plomien)

    # płaszcz
    p.wielokat([(11, 19 + b), (29, 19 + b), (30, 34 + b), (32 + sway, 54), (8 + sway, 54), (10, 34 + b)], "plaszcz")
    p.elipsa(10, 17 + b, 30, 23 + b, "plaszcz")
    p.linia([(8 + sway, 54), (32 + sway, 54)], "plaszcz", 1)
    # fałdy płaszcza
    p.linia([(13, 38 + b), (12 + sway, 53)], "plaszcz", 1)
    p.linia([(27, 38 + b), (28 + sway, 53)], "plaszcz", 1)

    if tyl:
        # karczek, pas z tyłu i rozcięcie
        p.wielokat([(11, 19 + b), (29, 19 + b), (29, 27 + b), (11, 27 + b)], "plaszcz", 2)
        p.linia([(10, 28 + b), (30, 28 + b)], "plaszcz", 0)
        p.prost(10, 34 + b, 30, 35 + b, "plaszcz", 1)
        p.prost(19, 34 + b, 21, 35 + b, "mosiadz", 1)
        p.linia([(20, 37 + b), (20 + sway, 53)], "plaszcz", 0)
        # kołnierz i włosy na karku
        p.elipsa(13, 15 + b, 27, 21 + b, "plaszcz", 2)
        p.elipsa(15, 7 + b, 25, 17 + b, "wlosy")
    else:
        # rozpięty przód: kamizelka, spodnie, pasek
        p.wielokat([(17, 20 + b), (23, 20 + b), (23, 36 + b), (17, 36 + b)], "kamizelka")
        p.wielokat([(19, 36 + b), (21, 36 + b), (22 + sway, 54), (18 + sway, 54)], "spodnie")
        p.linia([(18 + sway, 37 + b), (17 + sway, 53)], "plaszcz", 3)  # krawędź poły
        p.linia([(22 + sway, 37 + b), (23 + sway, 53)], "plaszcz", 3)
        p.prost(17, 34 + b, 23, 35 + b, "buty", 1)
        p.piksel(20, 34 + b, "mosiadz", 2)
        p.piksel(18, 26 + b, "mosiadz", 2)
        p.piksel(18, 30 + b, "mosiadz", 2)
        # klapy płaszcza
        p.wielokat([(13, 18 + b), (17, 19 + b), (17, 31 + b), (15, 24 + b)], "plaszcz", 3)
        p.wielokat([(27, 18 + b), (23, 19 + b), (23, 31 + b), (25, 24 + b)], "plaszcz", 3)
        # koszula i krawat
        p.wielokat([(17, 18 + b), (23, 18 + b), (20, 24 + b)], "koszula")
        p.prost(19, 19 + b, 20, 20 + b, "krawat", 2)
        p.wielokat([(19, 21 + b), (20, 21 + b), (21, 27 + b), (19, 28 + b), (18, 27 + b)], "krawat")
        # głowa
        p.elipsa(15, 7 + b, 25, 19 + b, "skora")
        p.prost(16, 10 + b, 24, 10 + b, "skora", 0)  # cień ronda
        p.prost(16, 11 + b, 24, 14 + b, "skora", 2)
        p.prost(16, 15 + b, 24, 18 + b, "zarost", 1)
        p.prost(15, 10 + b, 15, 14 + b, "wlosy")
        p.prost(25, 10 + b, 25, 14 + b, "wlosy")
        p.prost(17, 11 + b, 18, 11 + b, "wlosy", 0)  # brwi
        p.prost(22, 11 + b, 23, 11 + b, "wlosy", 0)
        p.prost(17, 12 + b, 18, 12 + b, "oczy", 0)
        p.prost(22, 12 + b, 23, 12 + b, "oczy", 0)
        p.prost(20, 13 + b, 20, 14 + b, "skora", 3)
        p.prost(19, 15 + b, 21, 15 + b, "skora", 1)  # nos od dołu
        p.prost(18, 16 + b, 22, 16 + b, "zarost", 0)  # usta

    # kapelusz
    p.elipsa(9, 5 + b, 31, 10 + b, "kapelusz")
    p.wielokat([(14, 7 + b), (14, 2 + b), (17, 0 + b), (23, 0 + b), (26, 2 + b), (26, 7 + b)], "kapelusz")
    p.prost(14, 6 + b, 26, 7 + b, "opaska")
    p.linia([(20, 1 + b), (20, 3 + b)], "kapelusz", 0)
    p.linia([(10, 9 + b), (30, 9 + b)], "kapelusz", 0)

    return pokoloruj(p, lat)


def antoni_bok(faza, chod, plomien):
    """Antoni idący w prawo (lewo to odbicie)."""
    p = Plotno()
    s = math.sin(faza * 2 * math.pi) if chod else 0.0
    c = math.cos(faza * 2 * math.pi) if chod else 0.0
    oddech = 0 if chod else (-1 if 0.25 <= faza < 0.75 else 0)
    b = (-1 if chod and abs(s) > 0.7 else 0) + oddech

    # dalsza noga (ciemniej), potem bliższa
    for strona, odcien in ((-1, 0), (1, 255)):
        krok = round(s * 5) * strona
        unies = round(max(0.0, c * strona) * 2) if chod else 0
        stopa_x = SRODEK + krok
        dol = ZIEMIA - 3 - unies
        p.wielokat([(SRODEK - 2, 48), (SRODEK + 2, 48), (stopa_x + 2, dol), (stopa_x - 2, dol)], "spodnie",
                   odcien if odcien != 255 else 255)
        p.prost(stopa_x - 2, dol + 1, stopa_x + 3, dol + 3, "buty", 0 if odcien == 0 else 255)

    # dalsza ręka
    mach = round(-s * 3)
    p.wielokat([(SRODEK - 1, 21 + b), (SRODEK + 2, 21 + b), (SRODEK + 1 - mach, 35 + b), (SRODEK - 2 - mach, 35 + b)],
               "plaszcz", 0)

    # płaszcz z profilu
    hem = round(-s * 1)
    p.wielokat([(14, 19 + b), (25, 19 + b), (27, 30 + b), (28 + hem, 54), (10 + hem, 54), (13, 30 + b)], "plaszcz")
    p.elipsa(13, 17 + b, 26, 23 + b, "plaszcz")
    p.linia([(12 + hem, 54), (28 + hem, 54)], "plaszcz", 1)
    p.linia([(25, 22 + b), (26 + hem, 53)], "plaszcz", 3)  # krawędź poły
    p.prost(13, 34 + b, 26, 35 + b, "plaszcz", 1)  # pasek
    p.wielokat([(23, 19 + b), (26, 19 + b), (25, 26 + b)], "koszula")
    p.linia([(25, 20 + b), (25, 25 + b)], "krawat", 1)
    p.elipsa(14, 14 + b, 22, 20 + b, "plaszcz", 2)  # postawiony kołnierz

    # głowa z profilu
    p.elipsa(16, 7 + b, 25, 19 + b, "skora")
    p.prost(20, 11 + b, 25, 14 + b, "skora", 2)
    p.prost(16, 9 + b, 19, 16 + b, "wlosy")
    p.prost(20, 10 + b, 25, 10 + b, "skora", 0)
    p.piksel(26, 13 + b, "skora", 2)  # nos
    p.piksel(26, 14 + b, "skora", 1)
    p.prost(21, 15 + b, 25, 18 + b, "zarost", 1)
    p.piksel(25, 16 + b, "zarost", 0)  # usta
    p.piksel(23, 11 + b, "wlosy", 0)  # brew
    p.piksel(23, 12 + b, "oczy", 0)
    p.prost(19, 12 + b, 19, 13 + b, "skora", 1)  # ucho

    # bliższa ręka z latarnią
    mach = round(s * 3)
    p.wielokat([(SRODEK - 2, 21 + b), (SRODEK + 2, 21 + b), (SRODEK + 2 + mach, 36 + b), (SRODEK - 1 + mach, 36 + b)],
               "plaszcz", 3)
    p.prost(SRODEK + mach, 37 + b, SRODEK + 2 + mach, 39 + b, "skora")
    lat = latarnia(p, SRODEK + 1 + mach, 40 + b, plomien) if Z_LATARNIA else None

    # kapelusz z profilu
    p.elipsa(10, 6 + b, 30, 10 + b, "kapelusz")
    p.wielokat([(14, 7 + b), (15, 2 + b), (18, 0 + b), (23, 0 + b), (25, 2 + b), (25, 7 + b)], "kapelusz")
    p.prost(14, 6 + b, 25, 7 + b, "opaska")
    p.linia([(11, 9 + b), (29, 9 + b)], "kapelusz", 0)

    return pokoloruj(p, lat, swiatlo=(1, -1))


KLATKI = {"stoi": 6, "idzie": 8}


def wszystkie_klatki():
    """Zwraca {(stan, kierunek): [obrazy]}."""
    wynik = {}
    for stan, n in KLATKI.items():
        chod = stan == "idzie"
        for kierunek in ("dol", "gora", "prawo"):
            klatki = []
            for i in range(n):
                faza = i / n
                plomien = (i * 7 // 3) % 2  # migotanie płomienia
                if kierunek == "prawo":
                    klatki.append(antoni_bok(faza, chod, plomien))
                else:
                    klatki.append(antoni_przod(faza, chod, plomien, tyl=kierunek == "gora"))
            wynik[(stan, kierunek)] = klatki
    return wynik


def scena(wiersze, res_arkusz, res_skrypt, res_cien):
    """Scena Godota: AnimatedSprite2D z klatkami wyciętymi z arkusza."""
    sub = []
    anims = []
    nr = 0
    for r, (stan, kierunek) in enumerate(wiersze):
        n = KLATKI[stan]
        klatki = []
        for k in range(n):
            nr += 1
            sub.append(f'''[sub_resource type="AtlasTexture" id="k{nr}"]
atlas = ExtResource("arkusz")
region = Rect2({k * SZER}, {r * WYS}, {SZER}, {WYS})
''')
            klatki.append(f'{{\n"duration": 1.0,\n"texture": SubResource("k{nr}")\n}}')
        fps = 10.0 if stan == "idzie" else 5.0
        anims.append(f'{{\n"frames": [{", ".join(klatki)}],\n"loop": true,\n"name": &"{stan}_{kierunek}",\n"speed": {fps}\n}}')
    return f'''[gd_scene load_steps={nr + 6} format=3]

[ext_resource type="Script" path="{res_skrypt}" id="skrypt"]
[ext_resource type="Texture2D" path="{res_arkusz}" id="arkusz"]
[ext_resource type="Texture2D" path="{res_cien}" id="cien"]

{"".join(s + chr(10) for s in sub)}[sub_resource type="SpriteFrames" id="klatki"]
animations = [{", ".join(anims)}]

[sub_resource type="CapsuleShape2D" id="stopy"]
radius = 6.0
height = 20.0

[node name="Antoni" type="CharacterBody2D"]
motion_mode = 1
script = ExtResource("skrypt")

[node name="Cien" type="Sprite2D" parent="."]
texture = ExtResource("cien")

[node name="Sprite" type="AnimatedSprite2D" parent="."]
sprite_frames = SubResource("klatki")
animation = &"stoi_dol"
autoplay = "stoi_dol"
centered = false
offset = Vector2({-SRODEK}, {-ZIEMIA})

[node name="Stopy" type="CollisionShape2D" parent="."]
rotation = 1.5707964
shape = SubResource("stopy")
'''


def cien():
    """Mały owalny cień pod stopami, środek obrazka to punkt styku z ziemią."""
    img = Image.new("RGBA", (21, 7), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse((0, 0, 20, 6), fill=(0, 0, 0, 90))
    d.ellipse((4, 1, 16, 5), fill=(0, 0, 0, 130))
    return img


def main(folder):
    """Rysuje Antoniego bez latarni (antoni.tscn) i z latarnią (antoni_latarnia.tscn)."""
    global Z_LATARNIA
    for Z_LATARNIA, nazwa in ((False, "antoni"), (True, "antoni_latarnia")):
        wiersze = zapisz(folder, nazwa)
    Z_LATARNIA = False
    return wiersze


def zapisz(folder, nazwa):
    folder = Path(folder)
    folder.mkdir(parents=True, exist_ok=True)
    klatki = wszystkie_klatki()
    # jeden arkusz: wiersz = animacja, kolumna = klatka
    wiersze = list(klatki)
    arkusz = Image.new("RGBA", (SZER * 8, WYS * len(wiersze)), (0, 0, 0, 0))
    for r, klucz in enumerate(wiersze):
        for k, img in enumerate(klatki[klucz]):
            arkusz.alpha_composite(img, (k * SZER, r * WYS))
    arkusz.save(folder / f"{nazwa}_arkusz.png")
    cien().save(folder / "cien.png")
    res = "res://postacie/antoni/"
    (folder / f"{nazwa}.tscn").write_text(
        scena(wiersze, res + f"{nazwa}_arkusz.png", res + "antoni.gd", res + "cien.png"), encoding="utf-8")
    return wiersze


if __name__ == "__main__":
    print(main(sys.argv[1] if len(sys.argv) > 1 else "postacie/antoni"))
