"""Rysuje ujęcia sceny 5 (jazda autem dyrektora i brama magazynu) w pixel arcie, 480x270.

Użycie: python3 tools/jazda_pixel.py [folder_na_podglady]

Ujęcia (sceny/scena5/):
  droga.png        nocna ulica za przednią szybą (Godot dorysowuje deszcz i mijane światła)
  wnetrze.png      wnętrze auta z tylnego siedzenia: Lis za kierownicą, Antoni obok,
                   przezroczysta przednia szyba
  wycieraczka.png  pióro wycieraczki (Godot je obraca, punkt obrotu na dole)
  brama.png        brama magazynu dekoracji, latarnia, stróż w płaszczu przeciwdeszczowym
"""
import random
import sys
from pathlib import Path

from PIL import Image, ImageDraw

import wstep_pixel as wp
from mapa_pracownia import O, nowy, obrys, prost
from wstep_pixel import ASFALT, CIEPLE, NOC, W, H, swiatlo, tekst

los = random.Random(17)
SZYBA = [(40, 34), (440, 34), (468, 168), (12, 168)]  # przednia szyba widziana z tyłu auta
TAPICERKA = [(14, 12, 16), (22, 20, 26), (32, 30, 38), (44, 42, 52)]
DESKA = [(10, 10, 12), (18, 18, 22), (28, 28, 34)]


def droga():
    img = nowy(W, H)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, W, H, NOC[0])
    wp.los.seed(23)
    wp.niebo(d)
    wp.miasto(d)
    # ulica z perspektywą do punktu zbiegu
    zbieg = (240, 112)
    d.polygon([(zbieg[0] - 6, zbieg[1]), (zbieg[0] + 6, zbieg[1]), (W + 120, H), (-120, H)], fill=ASFALT[1])
    for i in range(1, 7):  # przerywana linia środkowa
        t0, t1 = (i / 7) ** 2, ((i + 0.45) / 7) ** 2
        y0, y1 = zbieg[1] + (H - zbieg[1]) * t0, zbieg[1] + (H - zbieg[1]) * t1
        w0, w1 = 0.5 + 3 * t0, 0.5 + 3 * t1
        d.polygon([(240 - w0, y0), (240 + w0, y0), (240 + w1, y1), (240 - w1, y1)], fill=(150, 140, 110))
    # chodniki i kamienice po bokach, schodzące do punktu zbiegu
    for strona in (-1, 1):
        for k in range(7):
            t = (k / 7) ** 1.6
            x = 240 + strona * (14 + 300 * t)
            gora = 112 - 10 - 120 * t
            szer = 8 + 40 * t
            x0, x1 = (x, x + strona * szer)
            d.polygon([(x0, gora), (x1, gora - 4 * t), (x1, 112 + (H - 112) * t * 0.5), (x0, 112 + 4)],
                      fill=los.choice([(20, 19, 30), (24, 22, 34), (17, 17, 28)]))
            for o in range(3):
                wy = gora + 6 + o * (10 + 10 * t)
                if los.random() < 0.5 and wy < 112:
                    prost(d, int(min(x0, x1) + szer * 0.3), int(wy), max(2, int(3 * (1 + t))), max(2, int(4 * (1 + t))),
                          los.choice([(150, 120, 60), (110, 90, 52)]))
    # mokre odbicia świateł na asfalcie
    for x, kol in ((150, CIEPLE), (330, CIEPLE)):
        for y in range(130, H, 6):
            if los.random() < 0.6:
                prost(d, x + los.randint(-3, 3), y, 2 + (y - 130) // 30, 1, tuple(c // 2 for c in kol))
    img = swiatlo(img, 240, 190, 90, (180, 170, 140), 0.12, pasma=3, rx=2.0)  # reflektory auta na mokrej jezdni
    return img


def wnetrze():
    img = nowy(W, H)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, W, H, TAPICERKA[1])
    # podsufitka i słupki
    prost(d, 0, 0, W, 30, TAPICERKA[2])
    prost(d, 0, 28, W, 2, TAPICERKA[0])
    d.polygon(SZYBA, fill=(0, 0, 0, 0))
    d.line(SZYBA + [SZYBA[0]], fill=O, width=2)
    # deska rozdzielcza
    d.polygon([(0, 168), (W, 168), (W, H), (0, H)], fill=DESKA[1])
    prost(d, 0, 168, W, 4, DESKA[2])
    prost(d, 0, 172, W, 1, O)
    # zegary za kierownicą i radio na środku
    for cx in (124, 160):
        d.ellipse((cx - 13, 178, cx + 13, 204), fill=DESKA[0], outline=(60, 60, 70))
        d.line([(cx, 191), (cx - 7, 184)], fill=(230, 120, 60))
    prost(d, 214, 182, 52, 16, DESKA[0])
    obrys(d, 214, 182, 52, 16, (60, 60, 70))
    prost(d, 218, 186, 30, 8, (30, 60, 40))
    tekst(d, (220, 183), "FM 98.4", 10, (120, 230, 140))
    for bx in (252, 258):
        d.ellipse((bx, 186, bx + 4, 190), fill=(80, 80, 90))
    img = swiatlo(img, 233, 190, 30, (120, 230, 140), 0.25)
    img = swiatlo(img, 142, 191, 40, (230, 140, 70), 0.18)
    d = ImageDraw.Draw(img)
    # kierownica (Lis prowadzi z lewej)
    d.ellipse((92, 190, 192, 290), outline=(8, 8, 10), width=7)
    prost(d, 136, 230, 12, 40, (8, 8, 10))
    # fotele i sylwetki od tyłu
    for x0 in (70, 290):
        d.rounded_rectangle((x0, 150, x0 + 120, H + 10), 14, fill=TAPICERKA[2], outline=O)
        prost(d, x0 + 10, 160, 100, 2, TAPICERKA[3])
    # Lis: łysina z wiankiem włosów, szary garnitur
    d.ellipse((112, 128, 148, 168), fill=(150, 104, 84))
    d.ellipse((118, 130, 134, 142), fill=(176, 128, 104))  # połysk łysiny
    d.chord((110, 140, 150, 172), 0, 180, fill=(84, 64, 52))
    prost(d, 110, 152, 4, 8, (150, 104, 84))
    prost(d, 146, 152, 4, 8, (150, 104, 84))
    # Antoni: kapelusz i płaszcz
    d.ellipse((332, 132, 368, 172), fill=(54, 38, 30))
    d.ellipse((322, 136, 378, 150), fill=(30, 27, 33))  # rondo
    d.rounded_rectangle((334, 118, 366, 144), 6, fill=(46, 41, 48))
    prost(d, 334, 136, 32, 3, (92, 63, 36))  # opaska
    # lusterko wsteczne i zapach-choinka
    d.rounded_rectangle((206, 32, 274, 46), 4, fill=TAPICERKA[0], outline=O)
    prost(d, 210, 35, 60, 8, (40, 46, 70))
    prost(d, 238, 46, 2, 18, (40, 40, 44))
    d.polygon([(239, 64), (231, 82), (247, 82)], fill=(40, 120, 60), outline=O)
    prost(d, 238, 82, 2, 4, (90, 60, 40))
    # krople na szybie od środka: nie, szyba jest przezroczysta, deszcz rysuje Godot
    return img


def wycieraczka():
    img = nowy(6, 120)
    d = ImageDraw.Draw(img)
    prost(d, 2, 0, 2, 120, (14, 14, 16))
    prost(d, 1, 0, 4, 80, (24, 24, 28))
    prost(d, 2, 116, 2, 4, (60, 60, 64))
    return img


def brama():
    img = nowy(W, H)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, W, H, NOC[0])
    wp.los.seed(41)
    wp.niebo(d)
    # mur z cegły i hala magazynu za nim
    prost(d, 60, 40, 380, 120, (26, 26, 34))
    d.polygon([(60, 40), (250, 14), (440, 40)], fill=(30, 30, 40))
    for x in range(70, 440, 22):
        prost(d, x, 46, 1, 110, (20, 20, 28))
    tekst(d, (152, 56), "MAGAZYN DEKORACJI", 16, (110, 100, 90))
    prost(d, 0, 150, W, 50, (40, 26, 26))
    for j, y in enumerate(range(150, 200, 6)):
        for x in range(-(j % 2) * 8, W, 16):
            prost(d, x, y, 15, 5, los.choice([(52, 30, 28), (60, 34, 30), (46, 28, 26)]))
    # brama z prętów, uchylona
    prost(d, 180, 112, 130, 88, (12, 12, 16))
    for x in range(184, 306, 8):
        prost(d, x, 110, 3, 90, (50, 54, 60))
        d.polygon([(x - 1, 110), (x + 1, 104), (x + 4, 110)], fill=(70, 74, 80))
    prost(d, 180, 128, 130, 3, (60, 64, 70))
    prost(d, 180, 180, 130, 3, (60, 64, 70))
    prost(d, 176, 104, 6, 96, (40, 40, 46))
    prost(d, 308, 104, 6, 96, (40, 40, 46))
    # mokry chodnik i ulica
    prost(d, 0, 200, W, 70, ASFALT[1])
    for y in range(204, H, 5):
        for _ in range(5):
            prost(d, los.randint(0, W), y, los.randint(4, 14), 1, ASFALT[2])
    # latarnia
    prost(d, 360, 60, 4, 140, (36, 36, 42))
    prost(d, 346, 56, 26, 6, (36, 36, 42))
    prost(d, 344, 62, 16, 4, (255, 236, 170))
    img = swiatlo(img, 352, 120, 80, CIEPLE, 0.4, rx=0.8)
    img = swiatlo(img, 352, 230, 50, CIEPLE, 0.25, rx=2.0)  # plama światła na mokrym chodniku
    # reflektory auta z lewej
    img = swiatlo(img, 40, 245, 70, (220, 220, 200), 0.2, rx=2.2)
    d = ImageDraw.Draw(img)
    # stróż w żółtym płaszczu przeciwdeszczowym pod latarnią
    zx, zy = 330, 214
    d.polygon([(zx - 9, zy - 34), (zx + 9, zy - 34), (zx + 12, zy), (zx - 12, zy)], fill=(196, 160, 40), outline=O)
    prost(d, zx - 1, zy - 32, 2, 30, (150, 120, 30))
    d.ellipse((zx - 7, zy - 48, zx + 7, zy - 34), fill=(200, 150, 120), outline=O)
    d.polygon([(zx - 9, zy - 42), (zx, zy - 52), (zx + 9, zy - 42)], fill=(196, 160, 40), outline=O)  # kaptur
    prost(d, zx - 4, zy - 40, 8, 1, (60, 40, 30))  # wąsy
    prost(d, zx + 10, zy - 20, 3, 6, (60, 60, 70))  # latarka
    prost(d, zx - 8, zy, 6, 3, (20, 16, 16))
    prost(d, zx + 2, zy, 6, 3, (20, 16, 16))
    # maska auta dyrektora w dolnym rogu
    d.polygon([(0, 236), (90, 230), (120, 270), (0, 270)], fill=(40, 44, 56), outline=O)
    prost(d, 60, 240, 22, 6, (250, 240, 200))
    return img


def main(podglad=None):
    folder = Path("sceny/scena5")
    folder.mkdir(parents=True, exist_ok=True)
    obrazy = {"droga": droga(), "wnetrze": wnetrze(), "wycieraczka": wycieraczka(), "brama": brama()}
    for nazwa, im in obrazy.items():
        im.save(folder / f"{nazwa}.png")
    if podglad:
        auto = obrazy["droga"].copy()
        auto.alpha_composite(obrazy["wnetrze"])
        auto.resize((W * 3, H * 3), Image.NEAREST).save(Path(podglad) / "scena5_auto.png")
        obrazy["brama"].resize((W * 3, H * 3), Image.NEAREST).save(Path(podglad) / "scena5_brama.png")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else None)
