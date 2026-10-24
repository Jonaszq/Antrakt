"""Rysuje pracownię kostiumów w pixel arcie i składa z niej scenę Godota.

Użycie: python3 tools/mapa_pracownia.py [podglad.png]

Widok z góry pod skosem (jak w Stardew Valley): tylna ściana widoczna od frontu,
boczne ściany jako grube krawędzie. Skala pod Antoniego (ok. 64 px wzrostu):
drzwi 44x76, stół do krojenia 112 px, szafa 72x96.

Wynik:
  mapy/pracownia/tlo.png          podłoga, ściany i wszystko przy ścianie
  mapy/pracownia/<obiekt>.png     meble wolnostojące (Antoni może za nie wejść)
  mapy/pracownia/pracownia.tscn   scena: tło, meble z sortowaniem po Y, kolizje,
                                  światła świec i Antoni z kamerą
"""
import math
import random
import sys
from pathlib import Path

from PIL import Image, ImageDraw

SZER, WYS = 800, 480
SCIANA = 12          # grubość krawędzi ścian z góry
PODLOGA_Y = 104      # gdzie kończy się tylna ściana i zaczyna podłoga

O = (20, 12, 14)  # kontur
DREWNO = [(34, 20, 17), (54, 32, 23), (80, 48, 31), (108, 68, 41), (138, 90, 54), (166, 116, 72)]
DREWNO_C = [(22, 14, 13), (36, 22, 18), (52, 32, 24), (72, 45, 31), (96, 62, 40)]
CZERWIEN = [(46, 10, 18), (78, 18, 28), (116, 30, 38), (156, 48, 48), (196, 78, 66)]
ZLOTO = [(90, 60, 22), (146, 104, 38), (202, 156, 66), (242, 212, 126), (255, 240, 190)]
TAPETA = [(36, 16, 24), (52, 22, 32), (68, 30, 40)]
SZKLO = [(16, 24, 44), (30, 46, 76), (54, 82, 120), (104, 140, 180), (176, 204, 226)]
KAMIEN = [(42, 38, 44), (62, 56, 62), (86, 80, 84), (116, 108, 108)]
PAPIER = [(150, 132, 108), (198, 182, 150), (232, 222, 196)]
SKORA_M = [(120, 88, 70), (176, 140, 110), (214, 186, 152)]  # manekin
TKANINY = [
    [(30, 26, 56), (48, 42, 90), (72, 66, 128), (104, 98, 164)],    # granat
    [(24, 46, 34), (36, 70, 48), (56, 100, 66), (86, 134, 90)],     # zieleń
    [(70, 52, 24), (112, 84, 34), (160, 126, 54), (204, 172, 90)],  # musztarda
    [(92, 86, 80), (140, 132, 122), (190, 182, 168), (226, 220, 206)],  # len
    [(48, 22, 52), (76, 36, 82), (110, 58, 116), (146, 92, 150)],   # fiolet
    CZERWIEN[:4],
]
PLOMIEN = [(255, 168, 52), (255, 220, 128), (255, 250, 220)]

los = random.Random(7)


# ---------- podstawowe narzędzia ----------

def nowy(w, h):
    return Image.new("RGBA", (w, h), (0, 0, 0, 0))


def prost(d, x, y, w, h, kolor):
    if w > 0 and h > 0:
        d.rectangle((x, y, x + w - 1, y + h - 1), fill=kolor)


def obrys(d, x, y, w, h, kolor=O):
    d.rectangle((x, y, x + w - 1, y + h - 1), outline=kolor)


def skrzynia(d, x, y, w, gora, przod, rampa, kontur=True):
    """Bryła widziana z góry pod skosem: jaśniejszy wierzch i ciemniejszy front."""
    prost(d, x, y, w, gora, rampa[3])
    prost(d, x + 1, y + 1, w - 2, 1, rampa[4] if len(rampa) > 4 else rampa[3])
    prost(d, x, y + gora, w, przod, rampa[2])
    prost(d, x, y + gora, w, 1, rampa[1])
    prost(d, x, y + gora + przod - 2, w, 2, rampa[1])
    if kontur:
        obrys(d, x, y, w, gora + przod)


def plomyk(d, x, y):
    d.point((x, y - 2), fill=PLOMIEN[0])
    prost(d, x, y - 1, 1, 2, PLOMIEN[2])
    d.point((x - 1, y), fill=PLOMIEN[0])
    d.point((x + 1, y), fill=PLOMIEN[0])


def swieca(d, x, y, h=5):
    prost(d, x - 1, y, 3, h, PAPIER[2])
    d.point((x + 1, y + 1), fill=PAPIER[1])
    d.point((x + 1, y + 2), fill=PAPIER[1])
    plomyk(d, x, y - 1)


def swiecznik(d, x, y):
    """Trójramienny świecznik; (x, y) to podstawa."""
    prost(d, x - 3, y, 7, 2, ZLOTO[1])
    prost(d, x, y - 6, 1, 6, ZLOTO[2])
    prost(d, x - 5, y - 7, 11, 1, ZLOTO[2])
    for dx in (-5, 0, 5):
        swieca(d, x + dx, y - 12, 5)


# ---------- tło: podłoga i ściany ----------

def podloga(d):
    deska = 8
    for rzad, y in enumerate(range(PODLOGA_Y, WYS - SCIANA, deska)):
        x = SCIANA - (rzad * 37) % 90
        while x < SZER - SCIANA:
            dl = los.randint(70, 130)
            odc = los.choice([2, 2, 2, 2, 3])
            prost(d, x, y, dl, deska, DREWNO[odc])
            prost(d, x, y, dl, 1, DREWNO[odc + 1] if odc < 3 else DREWNO[3])
            prost(d, x, y + deska - 1, dl, 1, DREWNO[1])
            prost(d, x, y, 1, deska, DREWNO[1])
            d.point((x + 2, y + 3), fill=DREWNO[1])  # gwoździe
            d.point((x + 2, y + 5), fill=DREWNO[1])
            # słoje i sęki
            for _ in range(dl // 30):
                sx = x + los.randint(4, max(5, dl - 6))
                sy = y + los.randint(2, deska - 3)
                prost(d, sx, sy, los.randint(4, 10), 1, DREWNO[max(odc - 1, 1)])
            x += dl


def dywan(d, x, y, w, h):
    prost(d, x, y, w, h, CZERWIEN[0])
    prost(d, x + 1, y + 1, w - 2, h - 2, CZERWIEN[2])
    prost(d, x + 4, y + 4, w - 8, h - 8, ZLOTO[1])
    prost(d, x + 5, y + 5, w - 10, h - 10, CZERWIEN[1])
    prost(d, x + 10, y + 10, w - 20, h - 20, CZERWIEN[2])
    obrys(d, x + 12, y + 12, w - 24, h - 24, ZLOTO[1])
    # ornament na brzegu
    for i in range(x + 8, x + w - 8, 6):
        d.point((i, y + 7), fill=ZLOTO[2])
        d.point((i, y + h - 8), fill=ZLOTO[2])
    for j in range(y + 8, y + h - 8, 6):
        d.point((x + 7, j), fill=ZLOTO[2])
        d.point((x + w - 8, j), fill=ZLOTO[2])
    # romby w polu dywanu
    for j in range(y + 18, y + h - 16, 12):
        for i in range(x + 18 + (j // 12 % 2) * 6, x + w - 16, 12):
            d.point((i, j), fill=CZERWIEN[3])
            d.point((i - 1, j + 1), fill=CZERWIEN[1])
            d.point((i + 1, j + 1), fill=CZERWIEN[1])
    # medalion w środku
    cx, cy = x + w // 2, y + h // 2
    for r, k in ((26, ZLOTO[1]), (24, CZERWIEN[3]), (18, CZERWIEN[1]), (10, ZLOTO[2]), (7, CZERWIEN[2])):
        d.ellipse((cx - r, cy - r * 2 // 3, cx + r, cy + r * 2 // 3), fill=k)
    for a in range(0, 360, 45):
        px = cx + round(math.cos(math.radians(a)) * 36)
        py = cy + round(math.sin(math.radians(a)) * 24)
        d.ellipse((px - 2, py - 2, px + 2, py + 2), fill=ZLOTO[2])
    # przetarcia
    for _ in range(140):
        px, py = los.randint(x + 13, x + w - 14), los.randint(y + 13, y + h - 14)
        d.point((px, py), fill=CZERWIEN[1] if los.random() < 0.7 else CZERWIEN[3])


def sciana_tylna(d):
    # tapeta
    prost(d, 0, 0, SZER, PODLOGA_Y, TAPETA[1])
    for x in range(SCIANA, SZER - SCIANA, 16):
        prost(d, x, SCIANA, 1, PODLOGA_Y - SCIANA, TAPETA[0])
        for y in range(SCIANA + 6, PODLOGA_Y - 36, 12):
            d.point((x + 8, y), fill=ZLOTO[0])
            d.point((x + 7, y + 1), fill=TAPETA[2])
            d.point((x + 9, y + 1), fill=TAPETA[2])
            d.point((x + 8, y + 2), fill=ZLOTO[0])
    # boazeria
    by = PODLOGA_Y - 34
    prost(d, 0, by, SZER, 34, DREWNO_C[2])
    prost(d, 0, by, SZER, 3, DREWNO_C[4])
    prost(d, 0, by + 3, SZER, 1, DREWNO_C[0])
    for x in range(SCIANA + 4, SZER - SCIANA - 20, 28):
        obrys(d, x, by + 8, 22, 20, DREWNO_C[1])
        prost(d, x + 1, by + 9, 20, 1, DREWNO_C[3])
    prost(d, 0, PODLOGA_Y - 3, SZER, 3, DREWNO_C[1])
    prost(d, 0, PODLOGA_Y - 1, SZER, 1, O)
    # cień przy ścianie na podłodze
    prost(d, SCIANA, PODLOGA_Y, SZER - 2 * SCIANA, 3, (24, 14, 12))


def ramy_scian(d):
    k = [DREWNO_C[0], DREWNO_C[2], DREWNO_C[3]]
    prost(d, 0, 0, SZER, SCIANA, k[1])
    prost(d, 0, 0, SCIANA, WYS, k[1])
    prost(d, SZER - SCIANA, 0, SCIANA, WYS, k[1])
    prost(d, 0, WYS - SCIANA, SZER, SCIANA, k[1])
    prost(d, 0, SCIANA - 2, SZER, 2, k[2])
    prost(d, SCIANA - 2, SCIANA, 2, WYS - 2 * SCIANA, k[2])
    prost(d, SZER - SCIANA, SCIANA, 2, WYS - 2 * SCIANA, k[0])
    prost(d, 0, WYS - SCIANA, SZER, 2, k[2])
    obrys(d, 0, 0, SZER, WYS)
    obrys(d, SCIANA - 1, SCIANA - 1, SZER - 2 * SCIANA + 2, WYS - 2 * SCIANA + 2)
    # belki co kawałek
    for y in range(SCIANA + 80, WYS - SCIANA, 120):
        prost(d, 0, y, SCIANA, 4, k[2])
        prost(d, SZER - SCIANA, y, SCIANA, 4, k[2])


def okno(d, x, y, w, h):
    """Wysokie okno z łukiem, za nim deszczowa noc i wieże miasta."""
    prost(d, x - 3, y - 3, w + 6, h + 6, DREWNO_C[1])
    d.ellipse((x - 3, y - 3 - w // 2, x + w + 2, y + w // 2), fill=DREWNO_C[1])
    prost(d, x, y, w, h, SZKLO[1])
    d.ellipse((x, y - w // 2, x + w - 1, y + w // 2 - 1), fill=SZKLO[1])
    for i in range(h):
        if i % 3 == 0:
            prost(d, x, y + i, w, 1, SZKLO[0])
    # sylwetki miasta
    for bx, bh in ((x + 2, 18), (x + 9, 30), (x + 18, 14), (x + 24, 24)):
        prost(d, bx, y + h - bh, 6, bh, SZKLO[0])
        d.point((bx + 2, y + h - bh + 4), fill=ZLOTO[3])
    # deszcz
    for _ in range(w * h // 18):
        rx, ry = los.randint(x, x + w - 1), los.randint(y - w // 3, y + h - 3)
        prost(d, rx, ry, 1, 2, SZKLO[3])
    prost(d, x + w // 2, y - w // 2, 1, h + w // 2, DREWNO_C[2])
    prost(d, x, y + h // 2, w, 1, DREWNO_C[2])
    prost(d, x - 5, y + h + 2, w + 10, 4, DREWNO_C[3])
    obrys(d, x - 5, y + h + 2, w + 10, 4)
    # zasłony
    for zx in (x - 12, x + w + 3):
        prost(d, zx, y - 22, 10, h + 30, CZERWIEN[2])
        for fx in range(zx + 2, zx + 10, 3):
            prost(d, fx, y - 22, 1, h + 30, CZERWIEN[1])
        prost(d, zx, y - 22, 10, 2, ZLOTO[2])
        obrys(d, zx, y - 22, 10, h + 30)
    prost(d, x - 14, y - 25, w + 28, 3, ZLOTO[1])


def obraz(d, x, y, w, h, tresc):
    prost(d, x, y, w, h, ZLOTO[1])
    obrys(d, x, y, w, h)
    prost(d, x + 1, y + 1, w - 2, 1, ZLOTO[3])
    prost(d, x + 2, y + 2, w - 4, h - 4, PAPIER[1] if tresc == "szkic" else (30, 20, 26))
    if tresc == "szkic":
        # szkic sukni
        cx = x + w // 2
        prost(d, cx - 1, y + 4, 2, 2, PAPIER[0])
        d.polygon([(cx - 2, y + 7), (cx + 2, y + 7), (cx + 5, y + h - 4), (cx - 5, y + h - 4)], outline=PAPIER[0])
    else:
        # maska teatralna
        cx, cy = x + w // 2, y + h // 2
        d.ellipse((cx - 5, cy - 6, cx + 5, cy + 6), fill=PAPIER[2])
        prost(d, cx - 3, cy - 2, 2, 1, O)
        prost(d, cx + 1, cy - 2, 2, 1, O)
        d.arc((cx - 3, cy + 1, cx + 3, cy + 5), 200, 340, fill=O)


def kinkiet(d, x, y):
    prost(d, x - 1, y, 3, 6, ZLOTO[1])
    prost(d, x - 3, y + 6, 7, 2, ZLOTO[2])
    obrys(d, x - 3, y + 6, 7, 2)
    swieca(d, x, y - 6, 6)


def drzwi(d, x, y, w, h):
    prost(d, x - 4, y - 4, w + 8, h + 4, KAMIEN[1])
    d.ellipse((x - 4, y - 4 - w // 2, x + w + 3, y + w // 2), fill=KAMIEN[1])
    obrys(d, x - 4, y - 4, w + 8, h + 4)
    prost(d, x, y, w, h, DREWNO[1])
    d.ellipse((x, y - w // 2, x + w - 1, y + w // 2 - 1), fill=DREWNO[1])
    for px in range(x + 5, x + w - 2, 7):
        prost(d, px, y - w // 3, 1, h + w // 3, DREWNO[0])
    prost(d, x, y + 14, w, 3, KAMIEN[0])
    prost(d, x, y + h - 20, w, 3, KAMIEN[0])
    prost(d, x + w - 8, y + h // 2, 3, 3, ZLOTO[2])
    obrys(d, x + w - 8, y + h // 2, 3, 3)


# ---------- meble przy ścianie (w tle) ----------

def szafa(d, x, y, w=72, h=96):
    skrzynia(d, x, y, w, 8, h - 8, DREWNO)
    prost(d, x + w // 2, y + 10, 1, h - 22, DREWNO[0])
    for sx in (x + 5, x + w // 2 + 4):
        obrys(d, sx, y + 14, w // 2 - 9, h - 40, DREWNO[1])
        prost(d, sx + 2, y + 16, w // 2 - 13, 1, DREWNO[4])
    prost(d, x + w // 2 - 4, y + h // 2, 2, 5, ZLOTO[2])
    prost(d, x + w // 2 + 3, y + h // 2, 2, 5, ZLOTO[2])
    prost(d, x + 4, y + h - 18, w - 8, 10, DREWNO[2])
    obrys(d, x + 4, y + h - 18, w - 8, 10, DREWNO[0])
    prost(d, x + w // 2 - 3, y + h - 14, 6, 2, ZLOTO[1])
    # pudła na kapelusze na górze
    for i, (bx, k) in enumerate(((x + 4, TKANINY[2]), (x + 26, TKANINY[0]), (x + 46, CZERWIEN))):
        skrzynia(d, bx, y - 12 + (i % 2) * 2, 20, 4, 10, k)


def toaletka(d, x, y):
    """Toaletka z lustrem i świecami."""
    # lustro na ścianie
    d.ellipse((x + 10, y - 44, x + 50, y + 4), fill=ZLOTO[1])
    d.ellipse((x + 13, y - 41, x + 47, y + 1), fill=SZKLO[2])
    d.ellipse((x + 16, y - 38, x + 44, y - 2), fill=SZKLO[1])
    prost(d, x + 20, y - 34, 2, 10, SZKLO[4])
    prost(d, x + 23, y - 36, 1, 6, SZKLO[3])
    d.ellipse((x + 10, y - 44, x + 50, y + 4), outline=O)
    skrzynia(d, x, y, 60, 10, 26, DREWNO)
    for sx in (x + 4, x + 32):
        obrys(d, sx, y + 14, 24, 8, DREWNO[1])
        prost(d, sx + 10, y + 17, 4, 2, ZLOTO[2])
    # puder, flakony, świece
    d.ellipse((x + 6, y + 2, x + 12, y + 6), fill=PAPIER[2])
    prost(d, x + 44, y, 3, 5, SZKLO[3])
    prost(d, x + 48, y + 1, 3, 4, CZERWIEN[3])
    swiecznik(d, x + 30, y + 6)


def wieszak_scienny(d, x, y, w):
    """Długi drążek z kostiumami pod ścianą."""
    prost(d, x, y, w, 3, ZLOTO[1])
    obrys(d, x, y, w, 3)
    prost(d, x + 2, y + 3, 2, 70, DREWNO[1])
    prost(d, x + w - 4, y + 3, 2, 70, DREWNO[1])
    cx = x + 6
    while cx < x + w - 14:
        k = los.choice(TKANINY)
        szer = los.randint(9, 14)
        dl = los.randint(40, 62)
        d.polygon([(cx + 1, y + 4), (cx + szer - 1, y + 4), (cx + szer + 1, y + 4 + dl), (cx - 1, y + 4 + dl)],
                  fill=k[2], outline=O)
        prost(d, cx + szer // 2, y + 6, 1, dl - 4, k[1])
        prost(d, cx + 1, y + 5, szer - 2, 2, k[3])
        d.arc((cx + szer // 2 - 2, y - 2, cx + szer // 2 + 2, y + 4), 180, 360, fill=ZLOTO[2])
        if los.random() < 0.4:
            prost(d, cx + 2, y + 18, szer - 3, 2, ZLOTO[2])
        cx += szer - 2
    prost(d, x - 2, y + 72, w + 4, 4, DREWNO[0])


def regal(d, x, y, w=64, h=92):
    """Regał z belami materiałów i pudełkami."""
    skrzynia(d, x, y, w, 6, h - 6, DREWNO_C)
    for i, py in enumerate(range(y + 10, y + h - 10, 20)):
        prost(d, x + 3, py, w - 6, 17, DREWNO_C[0])
        prost(d, x + 3, py + 17, w - 6, 2, DREWNO_C[3])
        bx = x + 4
        while bx < x + w - 10:
            k = los.choice(TKANINY)
            if i % 2 == 0:
                # bele materiału widziane z boku
                d.ellipse((bx, py + 5, bx + 10, py + 16), fill=k[2], outline=O)
                d.ellipse((bx + 3, py + 8, bx + 7, py + 12), fill=k[1])
                bx += 11
            else:
                # książki i pudełka
                bw = los.randint(3, 7)
                bh = los.randint(10, 15)
                prost(d, bx, py + 17 - bh, bw, bh, k[2])
                prost(d, bx, py + 17 - bh, 1, bh, k[3])
                bx += bw + 1


# ---------- meble wolnostojące (osobne obrazki) ----------

def stol_krawiecki():
    img = nowy(116, 60)
    d = ImageDraw.Draw(img)
    # nogi
    for lx in (4, 104):
        prost(d, lx, 40, 6, 18, DREWNO[1])
        obrys(d, lx, 40, 6, 18)
    skrzynia(d, 0, 4, 116, 30, 10, DREWNO)
    # materiał przewieszony przez stół
    d.polygon([(70, 6), (98, 6), (100, 52), (92, 55), (86, 50), (78, 54), (70, 44)], fill=CZERWIEN[2], outline=O)
    for fx in (76, 84, 92):
        prost(d, fx, 34, 1, 18, CZERWIEN[1])
    prost(d, 70, 6, 28, 2, ZLOTO[2])
    # wykroje
    prost(d, 8, 9, 26, 18, PAPIER[2])
    obrys(d, 8, 9, 26, 18, PAPIER[0])
    d.polygon([(18, 11), (24, 11), (28, 24), (14, 24)], outline=PAPIER[0])
    prost(d, 36, 12, 22, 14, PAPIER[1])
    obrys(d, 36, 12, 22, 14, PAPIER[0])
    # nożyce
    d.line([(40, 26), (52, 16)], fill=KAMIEN[3])
    d.line([(42, 16), (52, 26)], fill=KAMIEN[3])
    d.ellipse((38, 25, 41, 28), outline=KAMIEN[2])
    # rolka materiału
    prost(d, 102, 2, 10, 30, TKANINY[0][2])
    prost(d, 102, 2, 10, 2, TKANINY[0][3])
    obrys(d, 102, 2, 10, 30)
    # świecznik
    swiecznik(d, 62, 20)
    return img


def manekin(suknia):
    img = nowy(34, 72)
    d = ImageDraw.Draw(img)
    prost(d, 15, 60, 4, 8, DREWNO[1])
    d.ellipse((9, 64, 25, 70), fill=DREWNO[1], outline=O)
    k = suknia
    # spódnica
    d.polygon([(10, 30), (24, 30), (32, 62), (2, 62)], fill=k[2], outline=O)
    for fx in (8, 13, 18, 23, 27):
        prost(d, fx, 38, 1, 22, k[1])
    prost(d, 3, 60, 28, 2, ZLOTO[2])
    # gorset
    d.polygon([(9, 10), (25, 10), (23, 31), (11, 31)], fill=k[3], outline=O)
    prost(d, 16, 12, 2, 18, ZLOTO[2])
    for gy in range(14, 30, 4):
        d.point((14, gy), fill=ZLOTO[3])
        d.point((19, gy), fill=ZLOTO[3])
    # rękawy bufki
    d.ellipse((4, 9, 12, 19), fill=k[2], outline=O)
    d.ellipse((22, 9, 30, 19), fill=k[2], outline=O)
    # szyja manekina
    prost(d, 14, 3, 6, 8, SKORA_M[1])
    d.ellipse((12, 0, 21, 5), fill=SKORA_M[2], outline=O)
    obrys(d, 14, 3, 6, 8)
    return img


def manekin_plama():
    """Kostium Wolskiego z ciemną plamą, która nie schodzi w praniu."""
    img = nowy(34, 72)
    d = ImageDraw.Draw(img)
    prost(d, 15, 50, 4, 16, DREWNO[1])
    d.ellipse((9, 64, 25, 70), fill=DREWNO[1], outline=O)
    k = CZERWIEN
    # kaftan z peleryną
    d.polygon([(7, 8), (27, 8), (31, 52), (3, 52)], fill=k[2], outline=O)
    prost(d, 16, 10, 2, 40, ZLOTO[2])
    for by in range(14, 48, 6):
        prost(d, 13, by, 2, 2, ZLOTO[3])
        prost(d, 19, by, 2, 2, ZLOTO[3])
    prost(d, 4, 48, 26, 3, ZLOTO[1])
    # kryza
    d.ellipse((8, 3, 26, 11), fill=PAPIER[2], outline=O)
    for kx in range(10, 25, 3):
        d.point((kx, 7), fill=PAPIER[0])
    # plama
    d.polygon([(19, 26), (24, 24), (27, 30), (24, 36), (20, 34), (18, 30)], fill=(40, 18, 30))
    d.point((22, 38), fill=(40, 18, 30))
    d.point((25, 37), fill=(40, 18, 30))
    prost(d, 15, 0, 4, 4, SKORA_M[1])
    return img


def stojak_kostiumy():
    """Wolnostojący wieszak na kółkach z kostiumami."""
    img = nowy(76, 78)
    d = ImageDraw.Draw(img)
    prost(d, 2, 4, 72, 3, ZLOTO[1])
    obrys(d, 2, 4, 72, 3)
    for sx in (4, 70):
        prost(d, sx, 7, 2, 64, ZLOTO[0])
    prost(d, 0, 70, 76, 3, ZLOTO[0])
    obrys(d, 0, 70, 76, 3)
    for kx in (0, 72):
        d.ellipse((kx, 72, kx + 4, 76), fill=O)
    cx = 8
    while cx < 62:
        k = los.choice(TKANINY)
        szer = los.randint(10, 13)
        dl = los.randint(38, 56)
        d.polygon([(cx + 1, 8), (cx + szer - 1, 8), (cx + szer + 1, 8 + dl), (cx - 1, 8 + dl)],
                  fill=k[2], outline=O)
        prost(d, cx + 1, 9, szer - 2, 2, k[3])
        prost(d, cx + szer // 2, 11, 1, dl - 6, k[1])
        cx += szer - 1
    return img


def skrzynia_kufer(kolor=DREWNO):
    img = nowy(40, 30)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 2, 40, 10, 16, kolor)
    for bx in (4, 33):
        prost(d, bx, 2, 3, 26, ZLOTO[1])
    prost(d, 17, 13, 6, 5, ZLOTO[2])
    obrys(d, 17, 13, 6, 5)
    prost(d, 19, 15, 2, 2, O)
    return img


def taboret():
    img = nowy(18, 20)
    d = ImageDraw.Draw(img)
    for lx in (2, 13):
        prost(d, lx, 8, 3, 11, DREWNO[1])
    d.ellipse((0, 1, 17, 11), fill=CZERWIEN[2], outline=O)
    d.ellipse((3, 3, 12, 7), fill=CZERWIEN[3])
    return img


def parawan():
    img = nowy(70, 72)
    d = ImageDraw.Draw(img)
    for i, px in enumerate(range(0, 70, 23)):
        skrzynia(d, px, 0, 24, 3, 66, DREWNO)
        prost(d, px + 3, 6, 18, 56, TKANINY[i % 2 + 3][2] if i != 1 else CZERWIEN[2])
        obrys(d, px + 3, 6, 18, 56, DREWNO[0])
        d.ellipse((px + 7, 20, px + 17, 40), outline=ZLOTO[2])
        prost(d, px + 11, 24, 2, 12, ZLOTO[2])
    # coś przewieszone przez parawan
    d.polygon([(26, 0), (40, 0), (38, 22), (28, 18)], fill=PAPIER[2], outline=O)
    return img


def maszyna_do_szycia():
    img = nowy(52, 46)
    d = ImageDraw.Draw(img)
    # stolik z żeliwną podstawą
    prost(d, 4, 26, 4, 18, KAMIEN[0])
    prost(d, 44, 26, 4, 18, KAMIEN[0])
    d.line([(6, 40), (46, 30)], fill=KAMIEN[1])
    d.line([(6, 30), (46, 40)], fill=KAMIEN[1])
    skrzynia(d, 0, 14, 52, 8, 6, DREWNO)
    # maszyna
    prost(d, 10, 2, 30, 6, (24, 22, 26))
    prost(d, 34, 2, 6, 16, (24, 22, 26))
    prost(d, 10, 8, 6, 10, (24, 22, 26))
    prost(d, 12, 3, 20, 1, ZLOTO[2])
    obrys(d, 10, 2, 31, 16)
    d.ellipse((38, 6, 46, 14), fill=KAMIEN[2], outline=O)
    prost(d, 12, 16, 2, 4, KAMIEN[3])
    # szpulka
    prost(d, 22, 0, 3, 3, CZERWIEN[3])
    return img


def kosz_pranie():
    img = nowy(30, 28)
    d = ImageDraw.Draw(img)
    d.ellipse((1, 2, 28, 12), fill=(150, 112, 62), outline=O)
    prost(d, 2, 7, 26, 18, (126, 92, 50))
    for wx in range(4, 28, 3):
        prost(d, wx, 8, 1, 16, (98, 70, 38))
    obrys(d, 2, 7, 26, 19)
    d.ellipse((4, 0, 26, 10), fill=PAPIER[2], outline=O)
    d.ellipse((12, 2, 22, 7), fill=TKANINY[0][2])
    return img


# ---------- składanie ----------

class Mapa:
    def __init__(self):
        self.tlo = nowy(SZER, WYS)
        self.d = ImageDraw.Draw(self.tlo)
        self.obiekty = []   # (nazwa, obraz, x, y, kolizja)
        self.kolizje = []   # prostokąty (x0, y0, x1, y1)
        self.swiatla = []   # (x, y, sila)

    def obiekt(self, nazwa, img, x, y, stopa):
        """stopa: wysokość w pikselach dolnej części obiektu, która stoi na podłodze."""
        self.obiekty.append((nazwa, img, x, y))
        cien = nowy(SZER, WYS)
        ImageDraw.Draw(cien).ellipse((x - 2, y + img.height - stopa // 2 - 4, x + img.width + 1,
                                      y + img.height + 3), fill=(10, 4, 6, 90))
        self.tlo.alpha_composite(cien)
        self.kolizje.append((x + 1, y + img.height - stopa, x + img.width - 1, y + img.height))


def deska_do_prasowania():
    img = nowy(64, 34)
    d = ImageDraw.Draw(img)
    d.line([(14, 12), (48, 32)], fill=KAMIEN[2])
    d.line([(48, 12), (14, 32)], fill=KAMIEN[2])
    d.polygon([(2, 8), (54, 6), (62, 10), (54, 14), (2, 14)], fill=PAPIER[1], outline=O)
    prost(d, 4, 9, 48, 1, PAPIER[2])
    # żelazko na duszę
    d.polygon([(30, 2), (44, 2), (46, 9), (28, 9)], fill=(30, 28, 34), outline=O)
    prost(d, 34, 0, 6, 2, DREWNO[2])
    return img


def bele():
    """Stos bel materiału."""
    img = nowy(54, 34)
    d = ImageDraw.Draw(img)
    for i, (bx, by) in enumerate(((0, 18), (17, 18), (34, 18), (8, 6), (25, 6))):
        k = TKANINY[(i * 2 + 1) % len(TKANINY)]
        prost(d, bx, by + 2, 20, 12, k[2])
        prost(d, bx, by + 2, 20, 2, k[3])
        prost(d, bx, by + 12, 20, 2, k[1])
        obrys(d, bx, by + 2, 20, 12)
        d.ellipse((bx + 14, by + 2, bx + 22, by + 13), fill=k[3], outline=O)
        d.ellipse((bx + 17, by + 6, bx + 19, by + 9), fill=k[1])
    return img


def zbuduj():
    m = Mapa()
    d = m.d
    prost(d, 0, 0, SZER, WYS, O)
    podloga(d)
    sciana_tylna(d)
    dywan(d, 250, 220, 270, 160)

    # tylna ściana: drzwi, okno, obrazy, kinkiety
    drzwi(d, 30, PODLOGA_Y - 76, 44, 76)
    okno(d, 506, 30, 30, 52)
    obraz(d, 408, 28, 18, 24, "szkic")
    obraz(d, 432, 34, 16, 20, "szkic")
    obraz(d, 566, 26, 24, 26, "maska")
    for kx, ky in ((86, 50), (398, 50), (612, 50)):
        kinkiet(d, kx, ky)
        m.swiatla.append((kx, ky - 6, 0.7))
    m.swiatla.append((521, 60, 0.35))  # zimne światło z okna

    # meble przy ścianie
    szafa(d, 98, PODLOGA_Y - 74)
    m.kolizje.append((98, PODLOGA_Y, 170, PODLOGA_Y + 22))
    toaletka(d, 182, PODLOGA_Y - 8)
    m.kolizje.append((182, PODLOGA_Y, 242, PODLOGA_Y + 28))
    m.swiatla.append((212, PODLOGA_Y - 6, 0.8))
    wieszak_scienny(d, 256, PODLOGA_Y - 58, 130)
    m.kolizje.append((254, PODLOGA_Y, 388, PODLOGA_Y + 18))
    regal(d, 636, PODLOGA_Y - 72)
    m.kolizje.append((636, PODLOGA_Y, 700, PODLOGA_Y + 20))
    szafa(d, 712, PODLOGA_Y - 74, 72, 96)
    m.kolizje.append((712, PODLOGA_Y, 784, PODLOGA_Y + 22))

    # lustro wolnostojące przy oknie
    lustro = nowy(26, 64)
    dl = ImageDraw.Draw(lustro)
    dl.ellipse((1, 0, 24, 54), fill=ZLOTO[1], outline=O)
    dl.ellipse((4, 3, 21, 51), fill=SZKLO[2])
    prost(dl, 8, 10, 2, 16, SZKLO[4])
    prost(dl, 11, 52, 4, 8, ZLOTO[0])
    prost(dl, 5, 60, 16, 3, ZLOTO[1])
    obrys(dl, 5, 60, 16, 3)
    m.obiekt("lustro", lustro, 590, PODLOGA_Y - 28, 8)

    # meble wolnostojące
    m.obiekt("stol", stol_krawiecki(), 560, 196, 22)
    m.swiatla.append((622, 208, 1.0))
    m.obiekt("taboret_1", taboret(), 590, 262, 8)
    m.obiekt("taboret_2", taboret(), 646, 264, 8)
    m.obiekt("manekin_1", manekin(TKANINY[0]), 418, 116, 8)
    m.obiekt("manekin_2", manekin(TKANINY[4]), 460, 124, 8)
    m.obiekt("manekin_wolski", manekin_plama(), 190, 240, 8)
    m.obiekt("stojak", stojak_kostiumy(), 36, 170, 8)
    m.obiekt("parawan", parawan(), 704, 270, 8)
    m.obiekt("maszyna", maszyna_do_szycia(), 52, 318, 12)
    m.obiekt("taboret_3", taboret(), 108, 350, 8)
    m.obiekt("kufer_1", skrzynia_kufer(), 22, 410, 20)
    m.obiekt("kufer_2", skrzynia_kufer(DREWNO_C), 64, 418, 20)
    m.obiekt("kufer_3", skrzynia_kufer(), 742, 412, 20)
    m.obiekt("kosz", kosz_pranie(), 560, 408, 14)
    m.obiekt("deska", deska_do_prasowania(), 400, 404, 8)
    m.obiekt("bele", bele(), 640, 400, 14)
    # drobiazgi na podłodze: szpulki, wykroje, szpilki
    for sx, sy, k in ((300, 410, CZERWIEN), (316, 416, TKANINY[0]), (470, 190, TKANINY[2]), (150, 300, TKANINY[3])):
        prost(d, sx, sy, 4, 5, k[2])
        prost(d, sx - 1, sy, 6, 1, DREWNO[3])
        prost(d, sx - 1, sy + 5, 6, 1, DREWNO[3])
        d.line([(sx + 4, sy + 3), (sx + 12, sy + 6)], fill=k[3])
    for px, py in ((540, 300), (548, 306)):
        prost(d, px, py, 14, 10, PAPIER[1])
        obrys(d, px, py, 14, 10, PAPIER[0])
        d.line([(px + 3, py + 3), (px + 10, py + 6)], fill=PAPIER[0])
    for _ in range(12):
        d.point((los.randint(520, 700), los.randint(280, 330)), fill=KAMIEN[3])
    ramy_scian(d)
    return m


IRENA_PRZY_STOLE = (("Irena", "irena", (536, 262)),)


def scena_godot(m, folder_res, korzen="Pracownia", start=(390, 300), postacie=IRENA_PRZY_STOLE,
                mrok=(0.42, 0.38, 0.5), podloze="drewno", strefy=()):
    """Składa plik .tscn z tłem, meblami, kolizjami i światłami.

    postacie: krotki (nazwa węzła, folder postaci, pozycja stóp).
    """
    ext = [f'[ext_resource type="Texture2D" path="{folder_res}tlo.png" id="tlo"]',
           '[ext_resource type="PackedScene" path="res://postacie/antoni/antoni.tscn" id="antoni"]']
    for klucz in sorted({k for _, k, _ in postacie}):
        ext.append(f'[ext_resource type="PackedScene" path="res://postacie/{klucz}/{klucz}.tscn" id="{klucz}"]')
    for nazwa, *_ in m.obiekty:
        ext.append(f'[ext_resource type="Texture2D" path="{folder_res}{nazwa}.png" id="{nazwa}"]')
    sub = ['''[sub_resource type="Gradient" id="grad"]
offsets = PackedFloat32Array(0, 0.55, 1)
colors = PackedColorArray(1, 1, 1, 1, 1, 1, 1, 0.35, 1, 1, 1, 0)''',
           '''[sub_resource type="GradientTexture2D" id="swiatlo"]
gradient = SubResource("grad")
width = 256
height = 256
fill = 1
fill_from = Vector2(0.5, 0.5)
fill_to = Vector2(1, 0.5)''']
    wezly = [f'''[node name="{korzen}" type="Node2D"]''',
             f'''[node name="Mrok" type="CanvasModulate" parent="."]
color = Color({mrok[0]}, {mrok[1]}, {mrok[2]}, 1)''',
             '''[node name="Tlo" type="Sprite2D" parent="."]
texture = ExtResource("tlo")
centered = false''',
             '''[node name="Kolizje" type="StaticBody2D" parent="."]''']
    for i, (x0, y0, x1, y1) in enumerate(m.kolizje):
        sub.append(f'''[sub_resource type="RectangleShape2D" id="k{i}"]
size = Vector2({x1 - x0}, {y1 - y0})''')
        wezly.append(f'''[node name="K{i}" type="CollisionShape2D" parent="Kolizje"]
position = Vector2({(x0 + x1) / 2}, {(y0 + y1) / 2})
shape = SubResource("k{i}")''')
    # granice pokoju
    granice = [(0, 0, SZER, PODLOGA_Y + 4), (0, 0, SCIANA + 2, WYS), (SZER - SCIANA - 2, 0, SZER, WYS),
               (0, WYS - SCIANA - 2, SZER, WYS)]
    for i, (x0, y0, x1, y1) in enumerate(granice):
        sub.append(f'''[sub_resource type="RectangleShape2D" id="g{i}"]
size = Vector2({x1 - x0}, {y1 - y0})''')
        wezly.append(f'''[node name="G{i}" type="CollisionShape2D" parent="Kolizje"]
position = Vector2({(x0 + x1) / 2}, {(y0 + y1) / 2})
shape = SubResource("g{i}")''')
    wezly.append('''[node name="Obiekty" type="Node2D" parent="."]
y_sort_enabled = true''')
    for nazwa, img, x, y in m.obiekty:
        # punkt zaczepienia u dołu obrazka, żeby sortowanie po Y działało ze stopami Antoniego
        wezly.append(f'''[node name="{nazwa}" type="Sprite2D" parent="Obiekty"]
position = Vector2({x}, {y + img.height})
texture = ExtResource("{nazwa}")
centered = false
offset = Vector2(0, {-img.height})''')
    for wezel, klucz, (px, py) in postacie:
        wezly.append(f'''[node name="{wezel}" parent="Obiekty" instance=ExtResource("{klucz}")]
position = Vector2({px}, {py})''')
    strefy_txt = ", ".join(f'[Rect2({x0}, {y0}, {x1 - x0}, {y1 - y0}), "{p}"]' for x0, y0, x1, y1, p in strefy)
    wezly.append(f'''[node name="Antoni" parent="Obiekty" instance=ExtResource("antoni")]
position = Vector2({start[0]}, {start[1]})
podloze = "{podloze}"
strefy_podloza = [{strefy_txt}]''')
    # miękkie światło "od gracza", żeby Antoni był widoczny w ciemnych miejscach
    wezly.append('''[node name="Swiatlo" type="PointLight2D" parent="Obiekty/Antoni"]
position = Vector2(0, -22)
color = Color(1, 0.9, 0.78, 1)
energy = 0.7
texture = SubResource("swiatlo")
texture_scale = 1.0''')
    wezly.append(f'''[node name="Kamera" type="Camera2D" parent="Obiekty/Antoni"]
limit_left = 0
limit_top = 0
limit_right = {SZER}
limit_bottom = {WYS}
position_smoothing_enabled = true
position_smoothing_speed = 6.0''')
    wezly.append('''[node name="Swiatla" type="Node2D" parent="."]''')
    for i, (x, y, sila) in enumerate(m.swiatla):
        zimne = sila < 0.5
        kolor = "Color(0.55, 0.7, 1, 1)" if zimne else "Color(1, 0.7, 0.38, 1)"
        skala = 1.6 if zimne else 0.7 + sila * 0.5
        wezly.append(f'''[node name="S{i}" type="PointLight2D" parent="Swiatla"]
position = Vector2({x}, {y})
color = {kolor}
energy = {0.7 if zimne else sila}
texture = SubResource("swiatlo")
texture_scale = {skala:.2f}''')
    n = len(ext) + len(sub) + 1
    return (f'[gd_scene load_steps={n} format=3]\n\n' + "\n".join(ext) + "\n\n" + "\n\n".join(sub) + "\n\n"
            + "\n\n".join(wezly) + "\n")


def zapisz(m, klucz, **scena):
    """Zapisuje tło, meble i scenę mapy do mapy/<klucz>/ i zwraca podgląd bez oświetlenia."""
    folder = Path("mapy") / klucz
    folder.mkdir(parents=True, exist_ok=True)
    m.tlo.save(folder / "tlo.png")
    for nazwa, img, *_ in m.obiekty:
        img.save(folder / f"{nazwa}.png")
    (folder / f"{klucz}.tscn").write_text(scena_godot(m, f"res://mapy/{klucz}/", **scena), encoding="utf-8")
    pod = m.tlo.copy()
    for nazwa, img, x, y in sorted(m.obiekty, key=lambda o: o[3] + o[1].height):
        pod.alpha_composite(img, (x, y))
    return pod


def main():
    return zapisz(zbuduj(), "pracownia")


if __name__ == "__main__":
    podglad = main()
    if len(sys.argv) > 1:
        podglad.save(sys.argv[1])
