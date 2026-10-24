"""Rysuje ujęcia filmiku wstępnego w pixel arcie (każde 480x270, czyli cały ekran gry).

Użycie: python3 tools/wstep_pixel.py [folder_na_podglady]

Ujęcia:
  teatr_noc.png        teatr z zewnątrz nocą, mokry chodnik (deszcz dorysowuje Godot)
  magazyn.png          ciemny magazyn dekoracji, z zza skrzyni wystaje dłoń Adriana
  telefon_blask.png    poświata ekranu telefonu w magazynie (Godot nią miga)
  zblizenie.png        zbliżenie: dłoń i telefon na deskach
  ekran.png            świecący ekran telefonu ("Ania, 14 nieodebranych")
  scena_tlo.png        pusta scena w świetle punktowca
  kurtyna_l.png/_p.png połówki kurtyny, które Godot rozsuwa
  lambrekin.png        górny pas kurtyny
  tytul.png            napis OSTATNI AKT
Wynik trafia do wstep/.
"""
import math
import random
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

import mapa_pracownia as mp
import mapy_teatr as mt
from mapa_pracownia import (CZERWIEN, DREWNO, DREWNO_C, KAMIEN, O, PAPIER, SKORA_M, SZKLO, TKANINY, ZLOTO,
                            nowy, obrys, prost, skrzynia)

W, H = 480, 270
FONT = "fonty/PixelifySans.ttf"
CIEPLE = (255, 196, 110)
ZIMNE = (120, 150, 210)
FASADA = [(40, 36, 44), (62, 56, 62), (88, 80, 84), (116, 106, 104), (146, 134, 124)]
NOC = [(8, 9, 20), (12, 14, 28), (17, 19, 36), (22, 24, 44), (28, 29, 52)]
ASFALT = [(14, 14, 20), (20, 20, 28), (28, 28, 38), (38, 38, 50)]
CHODNIK = [(34, 32, 40), (46, 44, 52), (60, 56, 64), (76, 72, 78)]

los = random.Random(5)


def swiatlo(img, x, y, r, kolor, sila=0.5, pasma=4, rx=1.0):
    """Plama światła w pasmach (jak w pixel arcie): im bliżej środka, tym mocniej."""
    a = np.asarray(img).astype(np.float32)
    yy, xx = np.mgrid[0:img.height, 0:img.width]
    dist = np.sqrt(((xx - x) / rx) ** 2 + (yy - y) ** 2) / r
    k = np.clip(np.ceil((1 - dist) * pasma) / pasma, 0, 1) * sila
    kol = np.array(kolor, np.float32)
    a[..., :3] = a[..., :3] + (kol - a[..., :3]) * k[..., None] * (a[..., :3] / 255 * 0.6 + 0.4)
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), img.mode)


def tekst(d, xy, napis, rozmiar, kolor, cien=None, srodek=False):
    font = ImageFont.truetype(FONT, rozmiar)
    d.fontmode = "1"
    x, y = xy
    if srodek:
        x -= d.textlength(napis, font=font) // 2
    if cien:
        d.text((x + 1, y + 1), napis, font=font, fill=cien)
    d.text((x, y), napis, font=font, fill=kolor)


# ---------- ujęcie 1: teatr nocą ----------

def niebo(d):
    for i, y in enumerate(range(0, 160, 32)):
        prost(d, 0, y, W, 32, NOC[min(i, 4)])
        for x in range(0, W, 2):  # przejście pasm w szachownicę
            if y and (x // 2) % 2 == 0:
                d.point((x, y), fill=NOC[min(i - 1, 4)])
    # chmury: poziome pasma jaśniejsze od nieba
    for _ in range(14):
        cx, cy = los.randint(-40, W), los.randint(4, 70)
        dl = los.randint(40, 120)
        prost(d, cx, cy, dl, 2, NOC[4])
        prost(d, cx + 8, cy - 1, dl - 20, 1, (34, 34, 60))


def miasto(d):
    x = 0
    while x < W:
        w = los.randint(26, 54)
        top = los.randint(78, 118)
        kol = los.choice([(18, 18, 30), (22, 21, 34), (15, 15, 26)])
        prost(d, x, top, w, 160 - top, kol)
        if los.random() < 0.5:
            prost(d, x + w // 3, top - 8, 4, 8, kol)  # komin
        for wy in range(top + 6, 150, 9):
            for wx in range(x + 4, x + w - 5, 7):
                if los.random() < 0.18:
                    prost(d, wx, wy, 3, 4, los.choice([(150, 120, 60), (110, 90, 52), (60, 70, 96)]))
        x += w + los.randint(0, 4)


def kolumna(d, x, y0, y1, w=10):
    prost(d, x, y0, w, y1 - y0, FASADA[3])
    prost(d, x + 1, y0, 2, y1 - y0, FASADA[4])
    prost(d, x + w - 3, y0, 2, y1 - y0, FASADA[1])
    for fx in range(x + 4, x + w - 3, 2):
        prost(d, fx, y0 + 4, 1, y1 - y0 - 8, FASADA[2])
    prost(d, x - 2, y0, w + 4, 4, FASADA[4])
    prost(d, x - 2, y1 - 4, w + 4, 4, FASADA[2])
    obrys(d, x - 2, y0, w + 4, y1 - y0)


def okno_lukowe(d, x, y, w, h, swieci):
    szyba = [(70, 52, 34), (150, 110, 60), (230, 180, 100)] if swieci else [(16, 20, 36), (26, 34, 56), (44, 56, 84)]
    prost(d, x - 2, y - 2, w + 4, h + 4, FASADA[1])
    d.ellipse((x - 2, y - 2 - w // 2, x + w + 1, y + w // 2), fill=FASADA[1])
    prost(d, x, y, w, h, szyba[1])
    d.ellipse((x, y - w // 2, x + w - 1, y + w // 2 - 1), fill=szyba[1])
    prost(d, x + 1, y + 2, 2, h - 4, szyba[2])
    prost(d, x + w // 2, y - w // 2, 1, h + w // 2, FASADA[0])
    prost(d, x, y + h // 2, w, 1, FASADA[0])
    prost(d, x - 3, y + h, w + 6, 3, FASADA[3])
    obrys(d, x - 3, y + h, w + 6, 3)


def teatr_noc():
    img = Image.new("RGBA", (W, H), NOC[0])
    d = ImageDraw.Draw(img)
    niebo(d)
    miasto(d)
    # bryła teatru
    x0, x1 = 112, 368
    prost(d, x0, 74, x1 - x0, 140, FASADA[2])
    for y in range(78, 212, 6):  # boniowanie
        prost(d, x0, y, x1 - x0, 1, FASADA[1])
        for x in range(x0 + (y // 6 % 2) * 12, x1, 24):
            prost(d, x, y - 5, 1, 5, FASADA[1])
    obrys(d, x0, 74, x1 - x0, 140)
    # tympanon z napisem
    d.polygon([(x0 - 8, 72), (240, 26), (x1 + 8, 72)], fill=FASADA[3], outline=O)
    d.polygon([(x0 + 14, 68), (240, 38), (x1 - 14, 68)], fill=FASADA[1])
    prost(d, x0 - 10, 70, x1 - x0 + 20, 6, FASADA[4])
    obrys(d, x0 - 10, 70, x1 - x0 + 20, 6)
    d.ellipse((232, 46, 248, 62), fill=FASADA[3], outline=O)  # maska w tympanonie
    prost(d, 236, 52, 3, 2, O)
    prost(d, 242, 52, 3, 2, O)
    d.arc((236, 55, 244, 60), 200, 340, fill=O)
    tekst(d, (240, 77), "TEATR MIEJSKI", 10, ZLOTO[3], cien=O, srodek=True)
    # piętro: okna łukowe
    for i, ox in enumerate(range(130, 350, 44)):
        okno_lukowe(d, ox, 98, 16, 26, swieci=i in (1, 2, 4))
    # gzyms nad parterem
    prost(d, x0 - 4, 132, x1 - x0 + 8, 4, FASADA[4])
    obrys(d, x0 - 4, 132, x1 - x0 + 8, 4)
    # parter: kolumny i trzy drzwi
    for kx in (122, 166, 210, 260, 304, 348):
        kolumna(d, kx, 136, 208)
    for dx in (180, 228, 276):
        prost(d, dx - 2, 158, 28, 50, FASADA[0])
        d.ellipse((dx - 2, 146, dx + 25, 172), fill=FASADA[0])
        prost(d, dx, 162, 24, 46, (200, 140, 70))
        d.ellipse((dx, 150, dx + 23, 174), fill=(200, 140, 70))
        prost(d, dx + 2, 166, 9, 40, (236, 184, 104))
        prost(d, dx + 13, 166, 9, 40, (236, 184, 104))
        prost(d, dx + 11, 162, 2, 46, (120, 72, 36))
        for sy in (176, 192):
            prost(d, dx + 2, sy, 20, 1, (170, 110, 56))
    # markiza z żarówkami i napisem spektaklu
    prost(d, 160, 136, 160, 18, CZERWIEN[1])
    prost(d, 160, 136, 160, 2, CZERWIEN[3])
    obrys(d, 160, 136, 160, 18)
    for bx in range(163, 318, 5):
        d.point((bx, 139), fill=(255, 230, 150))
        d.point((bx, 151), fill=(255, 230, 150))
    tekst(d, (240, 139), "OSTATNI AKT", 10, (255, 236, 180), cien=CZERWIEN[0], srodek=True)
    # gabloty z plakatami
    mt.plakat(d, 134, 160, ["DZIŚ"], "maska")
    mt.plakat(d, 316, 160, ["OSTATNI", "AKT"], "roza")
    # schody
    for i, sy in enumerate((208, 212, 216)):
        prost(d, x0 + 40 - i * 6, sy, x1 - x0 - 80 + i * 12, 4, FASADA[3 - i % 2])
        prost(d, x0 + 40 - i * 6, sy, x1 - x0 - 80 + i * 12, 1, FASADA[4])
    # chodnik i ulica
    prost(d, 0, 220, W, 26, CHODNIK[1])
    for y in range(220, 246, 13):
        prost(d, 0, y, W, 1, CHODNIK[0])
        for x in range((y // 13 % 2) * 12, W, 24):
            prost(d, x, y, 1, 13, CHODNIK[0])
    prost(d, 0, 220, W, 1, CHODNIK[3])
    prost(d, 0, 246, W, 3, CHODNIK[3])
    prost(d, 0, 249, W, 1, O)
    prost(d, 0, 250, W, H - 250, ASFALT[1])
    for x in range(10, W, 60):  # pasy
        prost(d, x, 262, 28, 2, (70, 70, 74))
    # latarnie
    for lx in (52, 428):
        prost(d, lx, 128, 3, 112, (24, 24, 30))
        prost(d, lx - 3, 236, 9, 6, (24, 24, 30))
        d.polygon([(lx - 6, 118), (lx + 8, 118), (lx + 5, 130), (lx - 3, 130)], fill=(250, 220, 150), outline=O)
        prost(d, lx - 7, 115, 17, 3, (24, 24, 30))
    # odbicia na mokrym chodniku i ulicy
    a = np.asarray(img).astype(np.float32)
    odb = a[120:220][::-1].copy()
    for cel, start in ((slice(222, 246), 0), (slice(250, 270), 4)):
        n = cel.stop - cel.start
        kawal = odb[start:start + n]
        jasne = kawal[..., :3].max(axis=2) > 140
        for j in range(n):
            if j % 2:
                continue
            wiersz = a[cel.start + j]
            m = jasne[j]
            wiersz[m, :3] = wiersz[m, :3] * 0.55 + kawal[j][m, :3] * 0.45
    img = Image.fromarray(a.astype(np.uint8), "RGBA")
    img = swiatlo(img, 240, 186, 90, CIEPLE, 0.45, rx=1.4)
    for lx in (55, 430):
        img = swiatlo(img, lx, 124, 30, CIEPLE, 0.4, pasma=3)
        img = swiatlo(img, lx, 240, 26, CIEPLE, 0.25, pasma=2, rx=2.2)
    return img


# ---------- ujęcie 2: magazyn ----------

def magazyn():
    img = Image.new("RGBA", (W, H), O)
    d = ImageDraw.Draw(img)
    PY = 78
    # ceglana ściana
    prost(d, 0, 0, W, PY, mt.CEGLA[1])
    for j, y in enumerate(range(0, PY, 6)):
        prost(d, 0, y, W, 1, mt.CEGLA[0])
        for x in range((j % 2) * 8, W, 16):
            prost(d, x, y, 1, 6, mt.CEGLA[0])
            if los.random() < 0.15:
                prost(d, x + 2, y + 2, 10, 2, mt.CEGLA[2])
    # wysokie okno z księżycem
    prost(d, 300, 8, 48, 40, (14, 20, 38))
    for gx in range(300, 348, 12):
        prost(d, gx, 8, 1, 40, O)
    prost(d, 300, 28, 48, 1, O)
    obrys(d, 298, 6, 52, 44)
    prost(d, 330, 14, 8, 8, (200, 210, 230))
    # podłoga: deski
    for j, y in enumerate(range(PY, H, 10)):
        x = -(j * 23) % 60
        while x < W:
            dl = los.randint(50, 110)
            k = los.choice([DREWNO_C[1], DREWNO_C[2], DREWNO_C[2]])
            prost(d, x, y, dl, 10, k)
            prost(d, x, y, dl, 1, DREWNO_C[3])
            prost(d, x, y, 1, 10, DREWNO_C[0])
            x += dl
    prost(d, 0, PY, W, 3, (12, 8, 10))
    # regał z rekwizytami pod ścianą
    for rx in (20, 100):
        prost(d, rx, 10, 70, PY - 6, DREWNO[1])
        obrys(d, rx, 10, 70, PY - 6)
        for py in range(26, PY, 18):
            prost(d, rx, py, 70, 3, DREWNO[3])
            for ix in range(rx + 4, rx + 64, 12):
                if los.random() < 0.7:
                    k = los.choice([ZLOTO, CZERWIEN, KAMIEN, TKANINY[0], PAPIER])
                    h = los.randint(5, 12)
                    prost(d, ix, py - h, 8, h, k[1])
                    prost(d, ix, py - h, 8, 1, k[2])
                    obrys(d, ix, py - h, 8, h)
    # oparte o ścianę płaskie dekoracje
    for i, (fx, fk) in enumerate(((190, (40, 56, 40)), (214, (60, 46, 70)), (238, (70, 52, 36)))):
        d.polygon([(fx, PY + 4), (fx + 40, PY + 4), (fx + 44, 6 + i * 4), (fx + 4, 6 + i * 4)], fill=fk, outline=O)
        prost(d, fx + 10, 20 + i * 4, 20, 2, tuple(c + 20 for c in fk))
    # manekiny i skrzynie
    obiekty = []
    for mx, my, k in ((380, 150, TKANINY[4]), (420, 132, TKANINY[0]), (70, 170, CZERWIEN)):
        obiekty.append((my, mp.manekin(k), mx - 17, my - 70))
    for kx, ky, kw in ((140, 200, 54), (360, 240, 40)):
        kufer = nowy(kw, 34)
        skrzynia(ImageDraw.Draw(kufer), 0, 0, kw, 10, 24, DREWNO)
        obiekty.append((ky, kufer, kx, ky - 34))
    # wielka skrzynia, za którą leży Adrian
    duza = nowy(90, 56)
    skrzynia(ImageDraw.Draw(duza), 0, 0, 90, 18, 38, DREWNO_C)
    obiekty.append((206, duza, 222, 150))
    obiekty.sort(key=lambda o: o[0])
    for _, im, x, y in obiekty:
        sx, sy = x + 4, y + im.height - 6
        d.ellipse((sx, sy, sx + im.width - 8, sy + 8), fill=(10, 6, 8))
        img.alpha_composite(im, (x, y))
    d = ImageDraw.Draw(img)
    # przewrócona skrzynka z rekwizytami
    d.polygon([(190, 236), (226, 226), (234, 248), (198, 258)], fill=DREWNO[2], outline=O)
    d.polygon([(194, 240), (222, 232), (228, 246), (200, 253)], fill=DREWNO[0])
    d.polygon([(240, 244), (252, 238), (258, 244), (246, 250)], fill=ZLOTO[2], outline=O)  # korona
    d.ellipse((168, 246, 178, 254), fill=PAPIER[2], outline=O)  # czaszka
    prost(d, 170, 249, 2, 2, O)
    prost(d, 174, 249, 2, 2, O)
    prost(d, 262, 230, 14, 2, KAMIEN[3])  # szpada
    # ręka wystająca zza skrzyni: rękaw koszuli i dłoń
    d.polygon([(312, 200), (330, 204), (328, 212), (310, 208)], fill=(150, 146, 140), outline=O)
    d.polygon([(330, 204), (340, 207), (339, 213), (328, 212)], fill=(196, 170, 150), outline=O)
    for fx in (334, 337):
        prost(d, fx + 4, 211, 1, 3, (150, 120, 104))
    # telefon obok dłoni
    prost(d, 346, 214, 5, 8, (10, 10, 14))
    obrys(d, 345, 213, 7, 10)
    # zimne światło: mrok i pas księżyca przez okno
    a = np.asarray(img).astype(np.float32)
    a[..., :3] = a[..., :3] * np.array([0.42, 0.48, 0.66])
    img = Image.fromarray(a.astype(np.uint8), "RGBA")
    pas = Image.new("L", (W, H), 0)
    ImageDraw.Draw(pas).polygon([(300, 48), (348, 48), (420, H), (250, H)], fill=1)
    b = np.asarray(img).astype(np.float32)
    m = np.asarray(pas).astype(bool)
    b[m, :3] = b[m, :3] * 1.5 + np.array([12, 16, 26])
    return Image.fromarray(np.clip(b, 0, 255).astype(np.uint8), "RGBA")


def telefon_blask():
    img = nowy(40, 28)
    d = ImageDraw.Draw(img)
    for r, a in ((19, 40), (13, 70), (7, 120)):
        d.ellipse((20 - r, 14 - r * 0.7, 20 + r, 14 + r * 0.7), fill=(170, 200, 255, a))
    prost(d, 18, 10, 5, 8, (210, 230, 255, 255))
    return img


# ---------- ujęcie 3: zbliżenie dłoni i telefonu ----------

def zblizenie():
    img = Image.new("RGBA", (W, H), O)
    d = ImageDraw.Draw(img)
    for j, y in enumerate(range(0, H, 36)):
        x = -(j * 140) % 300
        while x < W:
            dl = los.randint(220, 340)
            prost(d, x, y, dl, 36, DREWNO_C[2])
            prost(d, x, y, dl, 3, DREWNO_C[3])
            prost(d, x, y + 33, dl, 3, DREWNO_C[0])
            prost(d, x, y, 3, 36, DREWNO_C[0])
            for _ in range(5):
                sx, sy = x + los.randint(10, dl - 30), y + los.randint(8, 28)
                prost(d, sx, sy, los.randint(12, 40), 2, DREWNO_C[1])
            prost(d, x + 8, y + 15, 4, 4, DREWNO_C[0])  # gwoździe
            x += dl
    # rękaw i dłoń (od lewej krawędzi)
    rekaw = [(206, 202, 194), (170, 166, 158), (128, 124, 118)]
    d.polygon([(0, 120), (120, 132), (122, 200), (0, 214)], fill=rekaw[1], outline=O)
    d.polygon([(0, 124), (118, 136), (118, 150), (0, 140)], fill=rekaw[0])
    d.polygon([(0, 196), (120, 186), (122, 200), (0, 214)], fill=rekaw[2])
    prost(d, 112, 132, 10, 68, rekaw[2])  # mankiet
    obrys(d, 112, 132, 10, 68)
    skora = [(120, 92, 84), (170, 140, 126), (204, 178, 162), (226, 204, 190)]
    # dłoń wierzchem do góry, palce bezwładnie rozluźnione
    d.ellipse((150, 186, 184, 214), fill=skora[1], outline=O)  # kciuk pod spodem
    d.polygon([(120, 138), (176, 142), (196, 156), (198, 182), (178, 198), (120, 196)], fill=skora[2], outline=O)
    for i, (fy, dl, x0) in enumerate(((144, 34, 188), (157, 42, 192), (170, 38, 192), (183, 26, 186))):
        d.rounded_rectangle((x0, fy, x0 + dl, fy + 11), radius=5, fill=skora[2], outline=O)
        prost(d, x0 + 4, fy + 2, dl - 12, 2, skora[3])
        prost(d, x0 + dl - 14, fy + 1, 1, 9, skora[1])  # zgięcie palca
        prost(d, x0 + 2, fy + 9, dl - 4, 2, skora[1])
        d.rounded_rectangle((x0 + dl - 8, fy + 2, x0 + dl - 2, fy + 8), radius=2, fill=skora[3])  # paznokieć
    for kx in (180, 186):  # kostki
        prost(d, kx, 150, 2, 40, skora[1])
    prost(d, 128, 146, 46, 4, skora[3])
    # czerwone pręgi na nadgarstku (trop: kostium parzył)
    for py in (154, 168, 182):
        prost(d, 124, py, 22, 2, (176, 70, 70))
    # telefon na deskach
    tx, ty = 288, 54
    prost(d, tx, ty, 92, 164, (14, 14, 18))
    obrys(d, tx - 1, ty - 1, 94, 166)
    prost(d, tx + 2, ty + 2, 88, 2, (40, 40, 48))
    prost(d, tx + 6, ty + 14, 80, 136, (8, 8, 12))  # zgaszony ekran
    prost(d, tx + 38, ty + 6, 16, 2, (40, 40, 48))
    # cień telefonu
    prost(d, tx + 4, ty + 165, 92, 4, (20, 12, 12))
    a = np.asarray(img).astype(np.float32)
    a[..., :3] = a[..., :3] * np.array([0.5, 0.55, 0.72])
    return Image.fromarray(a.astype(np.uint8), "RGBA")


def ekran():
    """Ekran telefonu (80x136), kładziony w Godocie na zgaszony ekran ze zbliżenia."""
    img = Image.new("RGBA", (80, 136), (26, 34, 58, 255))
    d = ImageDraw.Draw(img)
    for y in range(0, 136, 8):
        prost(d, 0, y, 80, 4, (30, 40, 68))
    tekst(d, (40, 6), "18:29", 10, (200, 214, 240), srodek=True)
    # serce i imię
    d.ellipse((30, 36, 39, 45), fill=(220, 70, 90))
    d.ellipse((41, 36, 50, 45), fill=(220, 70, 90))
    d.polygon([(30, 42), (50, 42), (40, 54)], fill=(220, 70, 90))
    tekst(d, (40, 58), "Ania", 20, (255, 255, 255), srodek=True)
    tekst(d, (40, 82), "14 połączeń", 10, (240, 180, 180), srodek=True)
    tekst(d, (40, 92), "nieodebranych", 10, (240, 180, 180), srodek=True)
    # słuchawka
    d.ellipse((28, 106, 52, 130), fill=(70, 180, 100))
    d.arc((33, 111, 47, 125), 120, 330, fill=(240, 255, 240), width=3)
    return img


# ---------- ujęcie 4: kurtyna i tytuł ----------

def scena_tlo():
    img = Image.new("RGBA", (W, H), (6, 5, 8, 255))
    d = ImageDraw.Draw(img)
    for j, y in enumerate(range(196, H, 9)):  # deski sceny
        prost(d, 0, y, W, 9, DREWNO[1] if j % 2 else DREWNO[2])
        prost(d, 0, y, W, 1, DREWNO[0])
        for x in range((j * 37) % 70, W, 70):
            prost(d, x, y, 1, 9, DREWNO[0])
    prost(d, 0, 196, W, 2, O)
    # stożek punktowca i plama na deskach
    a = np.asarray(img).astype(np.float32)
    yy, xx = np.mgrid[0:H, 0:W]
    szer = 30 + (yy / H) * 110
    stozek = (np.abs(xx - 240) < szer) & (yy < 230)
    a[stozek, :3] = a[stozek, :3] * 0.6 + np.array([60, 52, 40]) * 0.4 + 8
    plama = ((xx - 240) / 150) ** 2 + ((yy - 236) / 26) ** 2
    for prog, dod in ((1.0, 40), (0.6, 30), (0.3, 30)):
        m = plama < prog
        a[m, :3] += dod
    img = Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")
    d = ImageDraw.Draw(img)
    for _ in range(40):  # kurz w świetle
        y = los.randint(10, 228)
        x = 240 + los.randint(-int(30 + y / H * 100), int(30 + y / H * 100))
        d.point((x, y), fill=(200, 186, 150))
    return img


def kurtyna(w=250):
    img = nowy(w, H)
    d = ImageDraw.Draw(img)
    for x in range(w):
        f = math.sin(x / 9.0) * 0.5 + math.sin(x / 3.7 + 1) * 0.15
        i = 1 + int(round((f + 0.65) * 1.9))
        prost(d, x, 0, 1, H - 10, CZERWIEN[max(0, min(4, i))])
    for x in range(0, w, 6):  # frędzle
        prost(d, x, H - 10, 4, 8, ZLOTO[2])
        prost(d, x, H - 10, 4, 1, ZLOTO[3])
        d.point((x + 1, H - 2), fill=ZLOTO[1])
    prost(d, 0, H - 12, w, 2, ZLOTO[1])
    return img


def lambrekin():
    img = nowy(W, 40)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, W, 24, CZERWIEN[1])
    for x in range(0, W, 40):
        d.ellipse((x - 4, 8, x + 44, 38), fill=CZERWIEN[2], outline=O)
        d.arc((x + 2, 12, x + 38, 32), 20, 160, fill=CZERWIEN[3])
    prost(d, 0, 0, W, 6, ZLOTO[1])
    prost(d, 0, 6, W, 1, O)
    for x in range(0, W, 40):
        prost(d, x + 19, 30, 3, 8, ZLOTO[2])
    return img


def tytul():
    img = nowy(300, 64)
    d = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT, 40)
    d.fontmode = "1"
    x = (300 - d.textlength("OSTATNI AKT", font=font)) // 2
    maska = Image.new("L", img.size, 0)
    dm = ImageDraw.Draw(maska)
    dm.fontmode = "1"
    dm.text((x, 6), "OSTATNI AKT", font=font, fill=255)
    m = np.asarray(maska) > 0
    a = np.zeros((64, 300, 4), np.uint8)
    # kontur i cień
    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1), (2, 2), (1, 2), (2, 1)):
        s = np.roll(np.roll(m, dy, 0), dx, 1)
        a[s] = (12, 8, 10, 255)
    # złoty gradient w pasmach od góry
    ys = np.nonzero(m.any(axis=1))[0]
    y0, y1 = ys.min(), ys.max()
    for y in range(y0, y1 + 1):
        t = (y - y0) / max(1, y1 - y0)
        kol = ZLOTO[4] if t < 0.2 else ZLOTO[3] if t < 0.5 else ZLOTO[2] if t < 0.8 else ZLOTO[1]
        a[y, m[y]] = (*kol, 255)
    return Image.fromarray(a, "RGBA")


def main(podglad=None):
    folder = Path("wstep")
    folder.mkdir(exist_ok=True)
    obrazy = {
        "teatr_noc": teatr_noc(), "magazyn": magazyn(), "telefon_blask": telefon_blask(),
        "zblizenie": zblizenie(), "ekran": ekran(), "scena_tlo": scena_tlo(),
        "kurtyna_l": kurtyna(), "kurtyna_p": kurtyna().transpose(Image.FLIP_LEFT_RIGHT),
        "lambrekin": lambrekin(), "tytul": tytul(),
    }
    for nazwa, im in obrazy.items():
        im.save(folder / f"{nazwa}.png")
    if podglad:
        p = Path(podglad)
        for nazwa in ("teatr_noc", "magazyn", "zblizenie"):
            im = obrazy[nazwa].copy()
            if nazwa == "zblizenie":
                im.alpha_composite(obrazy["ekran"], (294, 68))
            if nazwa == "magazyn":
                im.alpha_composite(obrazy["telefon_blask"], (328, 204))
            im.resize((W * 3, H * 3), Image.NEAREST).save(p / f"wstep_{nazwa}.png")
        sc = obrazy["scena_tlo"].copy()
        sc.alpha_composite(obrazy["kurtyna_l"], (-150, 0))
        sc.alpha_composite(obrazy["kurtyna_p"], (380, 0))
        sc.alpha_composite(obrazy["lambrekin"], (0, 0))
        sc.alpha_composite(obrazy["tytul"], (90, 90))
        sc.resize((W * 3, H * 3), Image.NEAREST).save(p / "wstep_tytul.png")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else None)
