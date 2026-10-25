"""Rysuje trzy mapy teatru w pixel arcie: foyer, kulisy i widownię.

Użycie: python3 tools/mapy_teatr.py [folder_na_podglady]

Korzysta z narzędzi i palety pracowni (tools/mapa_pracownia.py), więc wszystkie
mapy mają ten sam klimat i skalę pod Antoniego. Każda mapa trafia do
mapy/<nazwa>/ jako tło, meble (osobne obrazki z sortowaniem po Y) i scena .tscn.
"""
import math
import random
import sys
from pathlib import Path

from PIL import ImageDraw

import mapa_pracownia as mp
from mapa_pracownia import (CZERWIEN, DREWNO, DREWNO_C, KAMIEN, O, PAPIER, SZKLO, TAPETA, TKANINY, ZLOTO,
                            nowy, obrys, prost, skrzynia, swieca, swiecznik)

MARMUR_J = [(108, 100, 92), (138, 128, 116), (162, 152, 136)]
MARMUR_C = [(22, 20, 26), (34, 30, 38), (50, 46, 54)]
CEGLA = [(34, 18, 18), (52, 28, 26), (70, 38, 34), (90, 50, 42)]
SCENA_C = [(18, 16, 18), (26, 23, 26), (36, 32, 36), (48, 44, 48)]
ZIELEN = [(20, 60, 30), (34, 96, 46), (60, 150, 70), (130, 220, 130)]
WELUR = [(10, 10, 14), (18, 18, 24), (28, 28, 36), (40, 40, 50)]
METAL = [(30, 30, 34), (56, 56, 62), (90, 90, 96), (140, 140, 146)]
NIEBO = [(20, 30, 60), (36, 54, 96), (60, 90, 140)]


# ---------- napisy ----------

FONT = {
    "A": ["010", "101", "111", "101", "101"], "B": ["110", "101", "110", "101", "110"],
    "G": ["011", "100", "101", "101", "011"], "C": ["011", "100", "100", "100", "011"], "D": ["110", "101", "101", "101", "110"],
    "E": ["111", "100", "110", "100", "111"], "F": ["111", "100", "110", "100", "100"],
    "H": ["101", "101", "111", "101", "101"], "M": ["101", "111", "111", "101", "101"],
    "I": ["111", "010", "010", "010", "111"], "J": ["001", "001", "001", "101", "010"],
    "K": ["101", "101", "110", "101", "101"], "L": ["100", "100", "100", "100", "111"],
    "N": ["110", "101", "101", "101", "101"], "O": ["010", "101", "101", "101", "010"],
    "P": ["110", "101", "110", "100", "100"], "R": ["110", "101", "110", "101", "101"],
    "S": ["011", "100", "010", "001", "110"], "T": ["111", "010", "010", "010", "010"],
    "U": ["101", "101", "101", "101", "111"], "W": ["101", "101", "111", "111", "101"],
    "Y": ["101", "101", "010", "010", "010"], "X": ["101", "101", "010", "101", "101"], "Z": ["111", "001", "010", "100", "111"],
    "Ś": ["011", "100", "010", "001", "110"], "Ł": ["100", "110", "100", "100", "111"],
    " ": ["000"] * 5,
}


def napis(d, x, y, tekst, kolor):
    """Napis czcionką 3x5. Zwraca szerokość w pikselach."""
    for i, z in enumerate(tekst):
        wzor = FONT[z]
        for wy, wiersz in enumerate(wzor):
            for wx, c in enumerate(wiersz):
                if c == "1":
                    d.point((x + i * 4 + wx, y + wy), fill=kolor)
        if z in "ŚĆ":
            d.point((x + i * 4 + 2, y - 2), fill=kolor)
    return len(tekst) * 4 - 1


def szyld(d, x, y, tekst, tlo=DREWNO_C, kolor=ZLOTO[3]):
    w = len(tekst) * 4 + 5
    prost(d, x, y, w, 11, tlo[1])
    obrys(d, x, y, w, 11)
    prost(d, x + 1, y + 1, w - 2, 1, ZLOTO[1])
    napis(d, x + 3, y + 3, tekst, kolor)
    return w


# ---------- wspólne elementy teatru ----------

def pilaster(d, x, y0, y1):
    prost(d, x, y0, 14, y1 - y0, MARMUR_J[1])
    prost(d, x + 2, y0, 2, y1 - y0, MARMUR_J[2])
    prost(d, x + 10, y0, 2, y1 - y0, MARMUR_J[0])
    for fx in (x + 5, x + 8):
        prost(d, fx, y0 + 8, 1, y1 - y0 - 16, MARMUR_J[0])
    prost(d, x - 2, y0, 18, 6, ZLOTO[2])
    prost(d, x - 2, y1 - 6, 18, 6, ZLOTO[1])
    obrys(d, x - 2, y0, 18, y1 - y0)


def plakat(d, x, y, tytul, motyw):
    w, h = 30, 44
    prost(d, x - 2, y - 2, w + 4, h + 4, ZLOTO[1])
    obrys(d, x - 2, y - 2, w + 4, h + 4)
    tlo = {"maska": (24, 16, 22), "roza": (30, 10, 16), "korona": (16, 20, 34)}[motyw]
    prost(d, x, y, w, h, tlo)
    cx = x + w // 2
    if motyw == "maska":
        d.ellipse((cx - 7, y + 8, cx + 7, y + 24), fill=PAPIER[2])
        prost(d, cx - 4, y + 13, 3, 2, O)
        prost(d, cx + 2, y + 13, 3, 2, O)
        d.arc((cx - 4, y + 16, cx + 4, y + 22), 200, 340, fill=O)
        d.point((cx + 4, y + 17), fill=CZERWIEN[3])
    elif motyw == "roza":
        d.ellipse((cx - 6, y + 8, cx + 6, y + 18), fill=CZERWIEN[2])
        d.ellipse((cx - 3, y + 10, cx + 3, y + 15), fill=CZERWIEN[3])
        d.line([(cx, y + 18), (cx - 2, y + 28)], fill=ZIELEN[1])
    else:
        d.polygon([(cx - 8, y + 20), (cx - 8, y + 10), (cx - 4, y + 15), (cx, y + 8), (cx + 4, y + 15),
                   (cx + 8, y + 10), (cx + 8, y + 20)], fill=ZLOTO[2], outline=O)
    for i, linia in enumerate(tytul):
        napis(d, x + (w - len(linia) * 4 + 1) // 2, y + 30 + i * 7, linia, ZLOTO[3])


def drzwi_dwuskrzydlowe(d, x, y, w, h, napis_nad=None):
    prost(d, x - 6, y - 6, w + 12, h + 6, ZLOTO[1])
    obrys(d, x - 6, y - 6, w + 12, h + 6)
    prost(d, x, y, w, h, CZERWIEN[1])
    for sx in (x, x + w // 2):
        obrys(d, sx + 3, y + 6, w // 2 - 6, h // 2 - 8, ZLOTO[1])
        obrys(d, sx + 3, y + h // 2 + 2, w // 2 - 6, h // 2 - 8, ZLOTO[1])
        for py in range(y + 10, y + h - 6, 8):
            d.point((sx + w // 4, py), fill=ZLOTO[2])
    prost(d, x + w // 2, y, 1, h, O)
    prost(d, x + w // 2 - 4, y + h // 2, 2, 6, ZLOTO[3])
    prost(d, x + w // 2 + 3, y + h // 2, 2, 6, ZLOTO[3])
    if napis_nad:
        sw = len(napis_nad) * 4 + 5
        szyld(d, x + (w - sw) // 2, y - 20, napis_nad)


def podloga_marmur(d, x0, y0, x1, y1, bok=16):
    for j, y in enumerate(range(y0, y1, bok)):
        for i, x in enumerate(range(x0, x1, bok)):
            r = MARMUR_J if (i + j) % 2 == 0 else MARMUR_C
            prost(d, x, y, bok, bok, r[1])
            prost(d, x, y, bok, 1, r[2])
            prost(d, x, y, 1, bok, r[2])
            prost(d, x, y + bok - 1, bok, 1, r[0])
            if mp.los.random() < 0.5:  # żyłki
                sx, sy = x + mp.los.randint(2, bok - 6), y + mp.los.randint(2, bok - 4)
                d.line([(sx, sy), (sx + 4, sy + 2)], fill=r[0] if r is MARMUR_J else r[2])


def chodnik(d, x, y0, y1, w):
    prost(d, x, y0, w, y1 - y0, CZERWIEN[0])
    prost(d, x + 2, y0, w - 4, y1 - y0, CZERWIEN[2])
    prost(d, x + 5, y0, 2, y1 - y0, ZLOTO[1])
    prost(d, x + w - 7, y0, 2, y1 - y0, ZLOTO[1])
    for y in range(y0 + 6, y1, 10):
        d.point((x + w // 2, y), fill=CZERWIEN[3])
        d.point((x + w // 2 - 1, y + 1), fill=CZERWIEN[1])
        d.point((x + w // 2 + 1, y + 1), fill=CZERWIEN[1])
    for _ in range((y1 - y0) // 3):
        d.point((mp.los.randint(x + 8, x + w - 9), mp.los.randint(y0, y1 - 1)), fill=CZERWIEN[1])


def slupek_sznur(dlugosc):
    """Dwa mosiężne słupki z aksamitnym sznurem (poziomo)."""
    img = nowy(dlugosc + 8, 24)
    d = ImageDraw.Draw(img)
    for x in (0, dlugosc):
        d.ellipse((x, 18, x + 7, 23), fill=ZLOTO[1], outline=O)
        prost(d, x + 2, 4, 3, 16, ZLOTO[2])
        obrys(d, x + 2, 4, 3, 16)
        d.ellipse((x + 1, 1, x + 6, 6), fill=ZLOTO[3], outline=O)
    pkt = [(4 + i, 7 + round(math.sin(i / dlugosc * math.pi) * 5)) for i in range(0, dlugosc + 1, 2)]
    d.line(pkt, fill=CZERWIEN[3], width=2)
    d.line([(px, py + 1) for px, py in pkt], fill=CZERWIEN[1])
    return img


def palma():
    img = nowy(40, 56)
    d = ImageDraw.Draw(img)
    skrzynia(d, 10, 36, 20, 6, 14, [(40, 34, 30), (70, 60, 52), (110, 96, 84), (150, 136, 120), (180, 168, 150)])
    prost(d, 12, 38, 16, 3, (34, 24, 18))
    for kat in range(0, 360, 40):
        a = math.radians(kat)
        ex, ey = 20 + math.cos(a) * 18, 22 + math.sin(a) * 12 - 8
        d.line([(20, 34), (ex, ey)], fill=ZIELEN[1], width=3)
        d.line([(20, 34), (ex, ey)], fill=ZIELEN[2])
        d.point((round(ex), round(ey)), fill=ZIELEN[3])
    d.ellipse((16, 26, 24, 34), fill=ZIELEN[1], outline=O)
    return img


def lawka():
    img = nowy(64, 30)
    d = ImageDraw.Draw(img)
    for lx in (4, 56):
        prost(d, lx, 20, 4, 9, DREWNO[1])
    skrzynia(d, 0, 2, 64, 8, 4, DREWNO)
    prost(d, 2, 12, 60, 10, CZERWIEN[2])
    prost(d, 2, 12, 60, 2, CZERWIEN[3])
    for bx in range(8, 60, 10):
        d.point((bx, 17), fill=ZLOTO[2])
    obrys(d, 2, 12, 60, 10)
    return img


def popiersie():
    img = nowy(26, 60)
    d = ImageDraw.Draw(img)
    skrzynia(d, 3, 28, 20, 5, 26, [(70, 64, 60)] + MARMUR_J)
    d.ellipse((6, 16, 20, 30), fill=MARMUR_J[1], outline=O)
    d.ellipse((8, 2, 18, 16), fill=MARMUR_J[2], outline=O)
    prost(d, 10, 8, 2, 1, MARMUR_J[0])
    prost(d, 14, 8, 2, 1, MARMUR_J[0])
    d.arc((7, 0, 19, 8), 180, 360, fill=ZIELEN[1])  # wieniec laurowy
    return img


def stolik_okragly():
    img = nowy(30, 36)
    d = ImageDraw.Draw(img)
    prost(d, 13, 12, 4, 20, ZLOTO[0])
    d.ellipse((7, 30, 23, 35), fill=ZLOTO[1], outline=O)
    d.ellipse((0, 4, 29, 16), fill=MARMUR_J[1], outline=O)
    d.ellipse((3, 6, 26, 12), fill=MARMUR_J[2])
    swieca(d, 15, 4, 4)
    prost(d, 6, 8, 3, 3, PAPIER[2])  # filiżanka
    return img


def ramy_z_wejsciem(d, x_wej, w_wej):
    """Ramy ścian z otworem drzwi w dolnej ścianie."""
    mp.ramy_scian(d)
    y = mp.WYS - mp.SCIANA
    prost(d, x_wej, y, w_wej, mp.SCIANA, (20, 16, 22))
    for px in range(x_wej + 2, x_wej + w_wej - 2, 4):
        prost(d, px, y + 2, 2, mp.SCIANA - 3, (40, 36, 46))
    prost(d, x_wej - 4, y - 2, 4, mp.SCIANA + 2, ZLOTO[1])
    prost(d, x_wej + w_wej, y - 2, 4, mp.SCIANA + 2, ZLOTO[1])


def drzwi_zwykle(d, x, py, tekst=None, uchylone=False):
    """Zwykłe drewniane drzwi w tylnej ścianie (36x66), z szyldem nad nimi."""
    prost(d, x, py - 66, 36, 66, DREWNO_C[1])
    obrys(d, x, py - 66, 36, 66)
    if uchylone:
        # szpara na noc: zimne światło z podwórza i skrzydło odchylone do środka
        prost(d, x + 4, py - 62, 28, 62, NIEBO[0])
        for ky in range(py - 58, py - 4, 9):
            prost(d, x + 6 + (ky % 5), ky, 1, 4, NIEBO[2])
        d.polygon([(x + 4, py - 62), (x + 14, py - 58), (x + 14, py + 4), (x + 4, py)], fill=DREWNO[2], outline=O)
    else:
        prost(d, x + 4, py - 62, 28, 62, DREWNO[2])
        prost(d, x + 4, py - 62, 28, 1, DREWNO[4])
        obrys(d, x + 8, py - 56, 20, 20, DREWNO[1])
        obrys(d, x + 8, py - 30, 20, 24, DREWNO[1])
        prost(d, x + 26, py - 34, 3, 2, ZLOTO[3])
    if tekst:
        sw = len(tekst) * 4 + 5
        szyld(d, x + 18 - sw // 2, py - 80, tekst)


# ---------- FOYER ----------

def foyer():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 880, 512, 116
    mp.los = random.Random(11)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    prost(d, 0, 0, W, H, O)
    podloga_marmur(d, mp.SCIANA, PY, W - mp.SCIANA, H - mp.SCIANA)
    mp.sciana_tylna(d)
    # chodnik od wejścia do drzwi widowni i podest przed drzwiami
    chodnik(d, 396, PY, H - mp.SCIANA, 88)
    prost(d, 340, PY, 200, 40, CZERWIEN[0])
    prost(d, 342, PY, 196, 38, CZERWIEN[2])
    obrys(d, 346, PY, 188, 34, ZLOTO[1])

    # tylna ściana
    drzwi_dwuskrzydlowe(d, 400, PY - 80, 80, 80, "WIDOWNIA")
    for px in (240, 360, 506, 626):
        pilaster(d, px, mp.SCIANA, PY - 3)
    plakat(d, 318, 26, ["OSTATNI", "AKT"], "maska")
    plakat(d, 556, 26, ["HAMLET"], "korona")
    plakat(d, 674, 30, ["ROMEO"], "roza")
    for kx in (386, 540, 720):
        mp.kinkiet(d, kx, 52)
        m.swiatla.append((kx, 46, 0.7))

    # drzwi służbowe do kulis (tędy Antoni trafia za scenę)
    drzwi_zwykle(d, 196, PY, "PERSONEL")
    m.swiatla.append((214, 70, 0.5))
    # toalety dla widzów: awaria, kartka na drzwiach (dlatego Antoni szuka innej)
    drzwi_zwykle(d, 264, PY, "TOALETY")
    prost(d, 272, PY - 50, 14, 10, PAPIER[2])
    obrys(d, 272, PY - 50, 14, 10, PAPIER[0])
    for ly in (PY - 47, PY - 44):
        prost(d, 274, ly, 10, 1, CZERWIEN[2])

    # kasa biletowa (lewa strona tylnej ściany)
    prost(d, 40, 24, 150, PY - 24, DREWNO_C[2])
    obrys(d, 40, 24, 150, PY - 24)
    szyld(d, 96, 30, "KASA")
    for ox in (52, 122):
        prost(d, ox, 46, 56, 34, SZKLO[1])
        prost(d, ox + 4, 50, 2, 20, SZKLO[3])
        prost(d, ox + 20, 72, 16, 8, SZKLO[0])  # okienko
        obrys(d, ox, 46, 56, 34, ZLOTO[1])
    skrzynia(d, 36, PY - 30, 158, 10, 22, DREWNO)
    prost(d, 60, PY - 28, 10, 6, PAPIER[2])  # bilety
    prost(d, 150, PY - 28, 8, 5, ZLOTO[2])  # dzwonek
    m.kolizje.append((36, PY, 194, PY + 4))
    m.swiatla.append((115, 60, 0.6))

    # bufet (prawa strona tylnej ściany) z dostawą mleka
    prost(d, 690, 80, 160, 24, DREWNO_C[2])  # półka na ścianie
    for i, bx in enumerate(range(696, 846, 12)):
        prost(d, bx, 82 - (i % 3) * 2, 6, 16 + (i % 3) * 2, [SZKLO[2], ZIELEN[1], CZERWIEN[2]][i % 3])
        prost(d, bx + 1, 83 - (i % 3) * 2, 1, 10, SZKLO[4])
    szyld(d, 742, 62, "BUFET")
    skrzynia(d, 684, PY - 28, 172, 12, 24, DREWNO)
    for cx in (704, 744):  # klosze z ciastami
        d.ellipse((cx - 9, PY - 38, cx + 9, PY - 20), fill=SZKLO[3], outline=O)
        d.ellipse((cx - 6, PY - 30, cx + 6, PY - 22), fill=(170, 110, 70))
        prost(d, cx - 6, PY - 27, 12, 2, PAPIER[2])
    prost(d, 790, PY - 44, 14, 20, METAL[2])  # ekspres do kawy
    obrys(d, 790, PY - 44, 14, 20)
    prost(d, 793, PY - 48, 8, 4, ZLOTO[2])
    for fx in (812, 820, 828):
        prost(d, fx, PY - 26, 5, 5, PAPIER[2])  # filiżanki
    m.kolizje.append((684, PY, 856, PY + 8))
    m.swiatla.append((770, 70, 0.8))

    # szatnia przy prawej ścianie: lada i wieszaki z płaszczami
    for y in range(160, 420, 14):
        k = mp.los.choice([WELUR, TKANINY[0], DREWNO_C, TKANINY[3], CZERWIEN])
        d.ellipse((W - mp.SCIANA - 36, y, W - mp.SCIANA - 4, y + 18), fill=k[2], outline=O)
        prost(d, W - mp.SCIANA - 30, y + 3, 20, 2, k[3])
    prost(d, W - mp.SCIANA - 42, 150, 3, 280, ZLOTO[1])
    szyld(d, W - mp.SCIANA - 96, 130, "SZATNIA")
    skrzynia(d, W - mp.SCIANA - 70, 170, 26, 230, 14, DREWNO)
    for ny in range(180, 390, 22):
        prost(d, W - mp.SCIANA - 64, ny, 6, 4, PAPIER[1])  # numerki
    m.kolizje.append((W - mp.SCIANA - 72, 168, W - mp.SCIANA, 416))
    m.swiatla.append((W - 60, 280, 0.6))

    # meble wolnostojące
    m.obiekt("sznur_l1", slupek_sznur(70), 320, 210, 6)
    m.obiekt("sznur_l2", slupek_sznur(70), 320, 330, 6)
    m.obiekt("sznur_p1", slupek_sznur(70), 486, 210, 6)
    m.obiekt("sznur_p2", slupek_sznur(70), 486, 330, 6)
    m.obiekt("palma_1", palma(), 40, 150, 10)
    m.obiekt("palma_2", palma(), 320, 120, 10)
    m.obiekt("palma_3", palma(), 520, 120, 10)
    m.obiekt("lawka_1", lawka(), 90, 260, 10)
    m.obiekt("lawka_2", lawka(), 90, 380, 10)
    m.obiekt("lawka_3", lawka(), 640, 420, 10)
    m.obiekt("popiersie", popiersie(), 150, 196, 10)
    m.obiekt("stolik_1", stolik_okragly(), 640, 160, 8)
    m.obiekt("stolik_2", stolik_okragly(), 700, 200, 8)
    m.obiekt("stolik_3", stolik_okragly(), 600, 230, 8)
    for sx, sy in ((655, 164), (715, 204), (615, 234)):
        m.swiatla.append((sx, sy, 0.5))
    # skrzynka z butelkami mleka przy bufecie (trop: dostawa tylko w czwartki)
    mleko = nowy(26, 22)
    dm = ImageDraw.Draw(mleko)
    skrzynia(dm, 0, 8, 26, 4, 10, DREWNO)
    for bx in range(3, 23, 5):
        prost(dm, bx, 2, 4, 8, PAPIER[2])
        prost(dm, bx + 1, 0, 2, 2, SZKLO[3])
        obrys(dm, bx, 2, 4, 8)
    m.obiekt("mleko", mleko, 662, PY + 6, 6)

    # żyrandole: światło z góry nad chodnikiem
    m.swiatla.append((440, 200, 1.0))
    m.swiatla.append((440, 380, 1.0))
    ramy_z_wejsciem(d, 404, 72)
    # wycieraczka przy wejściu
    prost(d, 400, H - mp.SCIANA - 22, 80, 18, (60, 50, 40))
    for wx in range(402, 478, 3):
        prost(d, wx, H - mp.SCIANA - 20, 1, 14, (46, 38, 30))
    return m, dict(korzen="Foyer", start=(440, 470), postacie=(("Ania", "ania", (230, 142)),),
                   podloze="marmur", strefy=((396, PY, 484, H, "dywan"), (340, PY, 540, PY + 40, "dywan")),
                   mrok=(0.5, 0.45, 0.56))


# ---------- KULISY ----------

def kulisy():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 800, 480, 104
    mp.los = random.Random(23)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    prost(d, 0, 0, W, H, O)
    # czarna podłoga sceniczna
    for rzad, y in enumerate(range(PY, H - mp.SCIANA, 8)):
        x = mp.SCIANA - (rzad * 29) % 70
        while x < W - mp.SCIANA:
            dl = mp.los.randint(80, 160)
            k = mp.los.choice([1, 1, 2])
            prost(d, x, y, dl, 8, SCENA_C[k])
            prost(d, x, y, dl, 1, SCENA_C[k + 1])
            prost(d, x, y + 7, dl, 1, SCENA_C[0])
            prost(d, x, y, 1, 8, SCENA_C[0])
            x += dl
    # znaczniki z taśmy na podłodze
    for tx, ty, k in ((300, 240, (200, 190, 80)), (420, 300, (220, 220, 220)), (560, 200, (200, 190, 80)),
                      (360, 380, (180, 60, 60))):
        prost(d, tx, ty, 8, 2, k)
        prost(d, tx, ty, 2, 6, k)
    # ceglana tylna ściana
    prost(d, 0, 0, W, PY, CEGLA[1])
    for j, y in enumerate(range(mp.SCIANA, PY, 6)):
        for x in range(mp.SCIANA - (j % 2) * 8, W, 16):
            k = mp.los.choice([1, 2, 2, 3])
            prost(d, x, y, 15, 5, CEGLA[k])
            prost(d, x, y, 15, 1, CEGLA[min(k + 1, 3)])
    prost(d, 0, PY - 3, W, 3, CEGLA[0])
    prost(d, 0, PY - 1, W, 1, O)
    prost(d, mp.SCIANA, PY, W - 2 * mp.SCIANA, 3, (8, 6, 8))

    # dekoracje oparte o ścianę: mur zamku i las
    prost(d, 160, 20, 90, PY - 16, KAMIEN[2])
    for j, y in enumerate(range(24, PY, 12)):
        for x in range(160 + (j % 2) * 10, 250, 20):
            obrys(d, x, y, 20, 12, KAMIEN[1])
    prost(d, 180, 30, 14, 20, NIEBO[0])  # okienko w murze
    obrys(d, 160, 20, 90, PY - 16)
    prost(d, 256, 30, 80, PY - 26, NIEBO[1])
    for tx in range(260, 336, 14):
        d.polygon([(tx, PY - 4), (tx + 7, 36 + (tx % 3) * 6), (tx + 14, PY - 4)], fill=ZIELEN[0], outline=O)
        prost(d, tx + 6, PY - 10, 2, 6, DREWNO[1])
    obrys(d, 256, 30, 80, PY - 26)
    for lx in (164, 246, 262, 330):
        prost(d, lx, PY - 6, 2, 6, DREWNO[2])  # podpórki
    # drabina
    for lx in (360, 376):
        prost(d, lx, 14, 3, PY - 10, DREWNO[3])
    for ly in range(20, PY, 10):
        prost(d, 360, ly, 19, 2, DREWNO[2])
    # tablica z ogłoszeniami i znak CISZA
    prost(d, 420, 30, 70, 50, (120, 88, 50))
    obrys(d, 420, 30, 70, 50)
    for i, (px, py) in enumerate(((426, 36), (446, 40), (466, 34), (430, 58), (456, 60))):
        prost(d, px, py, 16, 14, PAPIER[2 - i % 2])
        d.point((px + 7, py + 1), fill=CZERWIEN[3])
    prost(d, 520, 30, 40, 16, (60, 10, 14))
    obrys(d, 520, 30, 40, 16)
    napis(d, 530, 36, "CISZA", (255, 90, 80))
    m.swiatla.append((540, 38, 0.3))
    # drzwi do garderób aktorów (zamknięte, klucz jest w skrzynce z bezpiecznikami)
    drzwi_zwykle(d, 62, PY, "GARDEROBY")
    m.swiatla.append((80, 40, 0.5))
    # uchylone drzwi na podwórze, tu palą maszyniści
    drzwi_zwykle(d, 564, PY, uchylone=True)
    m.swiatla.append((582, 90, 0.3))
    # skrzynka z bezpiecznikami i kable
    prost(d, 600, 40, 24, 32, METAL[1])
    obrys(d, 600, 40, 24, 32)
    d.line([(612, 72), (612, 96), (640, PY - 2)], fill=WELUR[0], width=2)
    # drzwi na widownię (tędy Antoni idzie na spektakl, scena 3)
    prost(d, 668, PY - 66, 36, 66, DREWNO_C[1])
    obrys(d, 668, PY - 66, 36, 66)
    prost(d, 672, PY - 62, 28, 62, DREWNO[2])
    prost(d, 672, PY - 62, 28, 1, DREWNO[4])
    obrys(d, 676, PY - 56, 20, 20, DREWNO[1])
    obrys(d, 676, PY - 30, 20, 24, DREWNO[1])
    prost(d, 694, PY - 34, 3, 2, ZLOTO[3])
    szyld(d, 666, PY - 80, "WIDOWNIA")
    m.swiatla.append((686, 30, 0.4))

    # sznurownia przy lewej ścianie: liny, kołki, worki z piaskiem
    prost(d, mp.SCIANA, 0, 40, H, DREWNO_C[1])
    prost(d, mp.SCIANA + 32, 0, 6, H, DREWNO_C[3])
    obrys(d, mp.SCIANA + 32, 0, 6, H)
    for y in range(40, H - 40, 18):
        prost(d, mp.SCIANA + 30, y, 10, 3, DREWNO[4])  # kołek
        d.line([(mp.SCIANA + 6 + (y % 4), 0), (mp.SCIANA + 34, y + 1)], fill=PAPIER[0])
    for y in (90, 210, 330):
        d.ellipse((mp.SCIANA + 6, y, mp.SCIANA + 26, y + 16), fill=(120, 100, 70), outline=O)
        prost(d, mp.SCIANA + 14, y - 8, 2, 8, PAPIER[0])
    m.kolizje.append((0, 0, mp.SCIANA + 40, H))

    # kurtyny boczne (horyzonty) po prawej: przez szpary bije zimne światło sceny
    for i, ky in enumerate((PY + 10, PY + 130, PY + 250)):
        kurtyna = nowy(28, 96)
        dk = ImageDraw.Draw(kurtyna)
        prost(dk, 0, 0, 28, 96, WELUR[1])
        for fx in range(2, 28, 5):
            prost(dk, fx, 0, 2, 96, WELUR[2])
            prost(dk, fx + 2, 0, 1, 96, WELUR[0])
        prost(dk, 0, 0, 28, 3, WELUR[3])
        obrys(dk, 0, 0, 28, 96)
        m.obiekt(f"kurtyna_{i}", kurtyna, W - mp.SCIANA - 44, ky, 10)
        m.swiatla.append((W - mp.SCIANA - 30, ky + 110, 0.35))
    prost(d, W - mp.SCIANA - 16, PY, 16, H - PY - mp.SCIANA, NIEBO[0])  # skrawek sceny za kurtynami
    m.kolizje.append((W - mp.SCIANA - 44, PY, W, H))

    # stół z rekwizytami
    stol = nowy(110, 50)
    ds = ImageDraw.Draw(stol)
    for lx in (4, 100):
        prost(ds, lx, 34, 5, 15, DREWNO[1])
    skrzynia(ds, 0, 4, 110, 26, 8, DREWNO)
    for ox in range(4, 108, 26):  # obrysy z taśmy dla każdego rekwizytu
        obrys(ds, ox, 7, 22, 20, (200, 200, 200))
    ds.polygon([(9, 20), (9, 12), (13, 16), (16, 10), (19, 16), (23, 12), (23, 20)], fill=ZLOTO[2], outline=O)
    prost(ds, 38, 10, 6, 10, ZLOTO[2])  # kielich
    prost(ds, 36, 10, 10, 3, ZLOTO[3])
    obrys(ds, 36, 10, 10, 10)
    ds.line([(56, 24), (74, 10)], fill=METAL[3], width=2)  # sztylet
    prost(ds, 57, 20, 5, 2, ZLOTO[1])
    ds.ellipse((84, 10, 98, 22), fill=PAPIER[2], outline=O)  # czaszka
    prost(ds, 87, 14, 3, 3, O)
    prost(ds, 93, 14, 3, 3, O)
    m.obiekt("stol_rekwizytow", stol, 200, 170, 20)

    # pulpit inspicjenta (Marty) z lampką i scenariuszem
    pulpit = nowy(56, 54)
    dp = ImageDraw.Draw(pulpit)
    skrzynia(dp, 0, 14, 56, 12, 26, DREWNO_C)
    prost(dp, 6, 16, 22, 8, PAPIER[2])  # scenariusz
    prost(dp, 16, 16, 1, 8, PAPIER[0])
    prost(dp, 34, 4, 2, 12, METAL[2])  # lampka
    prost(dp, 30, 2, 12, 4, NIEBO[2])
    obrys(dp, 30, 2, 12, 4)
    prost(dp, 46, 8, 2, 10, METAL[1])  # mikrofon
    prost(dp, 45, 6, 4, 3, METAL[3])
    for bx in range(8, 50, 6):
        prost(dp, bx, 32, 3, 3, [ZIELEN[2], CZERWIEN[3], (230, 200, 80)][bx % 3])  # przyciski sygnałów
    m.obiekt("pulpit", pulpit, 560, 250, 18)
    m.swiatla.append((596, 254, 0.3))

    # "ghost light": goła żarówka na statywie, zostawiana na noc na scenie
    ghost = nowy(20, 76)
    dg = ImageDraw.Draw(ghost)
    for x0, x1 in ((2, 10), (18, 10), (10, 10)):
        dg.line([(x0, 74), (x1, 56)], fill=METAL[1], width=2)
    prost(dg, 9, 10, 3, 48, METAL[2])
    dg.polygon([(4, 2), (16, 2), (14, 12), (6, 12)], outline=METAL[1])  # koszyk
    dg.ellipse((6, 3, 14, 11), fill=(255, 236, 170), outline=O)
    prost(dg, 9, 5, 2, 3, (255, 252, 230))
    m.obiekt("ghost_light", ghost, 420, 210, 6)
    m.swiatla.append((430, 216, 1.2))

    # skrzynie transportowe, reflektor, tron, wieszak
    for i, (cx, cy) in enumerate(((80, 360), (120, 368), (96, 330))):
        case = nowy(40, 34)
        dc = ImageDraw.Draw(case)
        skrzynia(dc, 0, 2, 40, 10, 20, WELUR)
        for kx in (2, 34):
            prost(dc, kx, 2, 4, 30, METAL[2])
        prost(dc, 16, 16, 8, 4, METAL[3])
        m.obiekt(f"skrzynia_{i}", case, cx, cy, 16)
    refl = nowy(30, 56)
    dr = ImageDraw.Draw(refl)
    for x0 in (2, 26, 14):
        dr.line([(x0, 54), (15, 34)], fill=METAL[1], width=2)
    prost(dr, 14, 16, 3, 20, METAL[2])
    prost(dr, 6, 2, 18, 14, WELUR[3])
    dr.ellipse((8, 4, 22, 14), fill=(255, 230, 160), outline=O)
    obrys(dr, 6, 2, 18, 14)
    m.obiekt("reflektor", refl, 640, 380, 6)
    tron = nowy(34, 56)
    dt = ImageDraw.Draw(tron)
    dt.polygon([(4, 8), (8, 3), (17, 0), (26, 3), (30, 8)], fill=ZLOTO[2], outline=O)
    prost(dt, 4, 6, 26, 30, CZERWIEN[2])
    prost(dt, 8, 10, 18, 22, CZERWIEN[3])
    obrys(dt, 4, 6, 26, 30, ZLOTO[2])
    skrzynia(dt, 0, 32, 34, 8, 14, [ZLOTO[0], ZLOTO[1], CZERWIEN[2], CZERWIEN[3], CZERWIEN[4]])
    m.obiekt("tron", tron, 480, 380, 12)
    m.obiekt("wieszak", mp.stojak_kostiumy(), 120, 140, 8)
    # wycięte z dykty drzewo do spektaklu i puszki farby
    drzewo = nowy(48, 90)
    dd = ImageDraw.Draw(drzewo)
    prost(dd, 20, 50, 8, 36, DREWNO[2])
    for cx, cy, r in ((24, 30, 20), (12, 40, 12), (36, 40, 12), (24, 14, 13)):
        dd.ellipse((cx - r, cy - r, cx + r, cy + r), fill=ZIELEN[1], outline=O)
        dd.ellipse((cx - r + 4, cy - r + 3, cx, cy - r + 8), fill=ZIELEN[2])
    prost(dd, 14, 84, 20, 4, DREWNO[1])  # podpórka
    m.obiekt("drzewo", drzewo, 300, 300, 6)
    farby = nowy(36, 20)
    df = ImageDraw.Draw(farby)
    for i, (fx, k) in enumerate(((0, CZERWIEN), (12, TKANINY[0]), (24, TKANINY[2]))):
        skrzynia(df, fx, 4 + (i % 2) * 2, 11, 4, 9, [METAL[0], METAL[1], k[2], k[3], k[3]])
    df.line([(26, 2), (34, 0)], fill=DREWNO[3], width=2)  # pędzel
    m.obiekt("farby", farby, 240, 420, 10)
    ramy_z_wejsciem(d, 360, 64)
    return m, dict(korzen="Kulisy", start=(392, 440), postacie=(("Marta", "marta", (620, 320)),),
                   mrok=(0.34, 0.32, 0.44))


# ---------- WIDOWNIA ----------

def rzad_foteli(n):
    """Rząd foteli widziany od tyłu z góry."""
    img = nowy(n * 16 + 4, 26)
    d = ImageDraw.Draw(img)
    prost(d, 0, 18, n * 16 + 4, 7, DREWNO_C[2])  # podest rzędu
    obrys(d, 0, 18, n * 16 + 4, 7)
    for i in range(n):
        x = 2 + i * 16
        d.rounded_rectangle((x + 1, 2, x + 14, 20), radius=4, fill=CZERWIEN[2], outline=O)
        prost(d, x + 3, 4, 10, 2, CZERWIEN[3])
        prost(d, x + 3, 14, 10, 4, CZERWIEN[1])
        prost(d, x, 10, 2, 10, ZLOTO[1])  # podłokietnik
        d.point((x + 7, 7), fill=ZLOTO[3])  # numerek
    prost(d, n * 16 + 1, 10, 2, 10, ZLOTO[1])
    return img


def widownia():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 960, 640, 40
    mp.los = random.Random(31)
    m = mp.Mapa()
    d = m.d
    W, H = mp.SZER, mp.WYS
    S = mp.SCIANA
    SCENA_Y0, SCENA_Y1 = 40, 210   # deski sceny
    prost(d, 0, 0, W, H, O)
    # sala: ciemnoczerwona wykładzina
    prost(d, S, SCENA_Y1, W - 2 * S, H - SCENA_Y1 - S, CZERWIEN[0])
    for _ in range(3000):
        d.point((mp.los.randint(S, W - S), mp.los.randint(SCENA_Y1, H - S)), fill=CZERWIEN[1])
    # przejścia między sektorami: chodnik ze złotą lamówką
    for ax in (300, 620):
        chodnik(d, ax, SCENA_Y1 + 20, H - S, 40)
    # scena: deski, kurtyna, portal
    for rzad, y in enumerate(range(SCENA_Y0, SCENA_Y1, 8)):
        x = 100 - (rzad * 31) % 80
        while x < W - 100:
            dl = mp.los.randint(90, 150)
            k = mp.los.choice([2, 3, 3])
            prost(d, x, y, dl, 8, DREWNO[k])
            prost(d, x, y, dl, 1, DREWNO[k + 1])
            prost(d, x, y + 7, dl, 1, DREWNO[1])
            prost(d, x, y, 1, 8, DREWNO[1])
            x += dl
    prost(d, 0, 0, 120, SCENA_Y1, TAPETA[1])
    prost(d, W - 120, 0, 120, SCENA_Y1, TAPETA[1])
    # kurtyna główna (rozsunięta) i paludament
    prost(d, 120, 0, W - 240, 30, CZERWIEN[1])
    for fx in range(120, W - 120, 6):
        prost(d, fx, 0, 3, 30, CZERWIEN[2])
    for kx, kw in ((120, 120), (W - 240, 120)):
        prost(d, kx, 0, kw, 80, CZERWIEN[2])
        for fx in range(kx, kx + kw, 8):
            prost(d, fx, 0, 3, 80, CZERWIEN[3])
            prost(d, fx + 5, 0, 2, 80, CZERWIEN[1])
        obrys(d, kx, 0, kw, 80)
    prost(d, 120, 0, W - 240, 6, ZLOTO[2])
    for fx in range(124, W - 124, 10):
        d.polygon([(fx, 6), (fx + 8, 6), (fx + 4, 14)], fill=ZLOTO[2], outline=ZLOTO[0])
    # portal sceny: złote kolumny
    for px in (104, W - 120):
        prost(d, px, 0, 16, SCENA_Y1 + 16, ZLOTO[1])
        prost(d, px + 3, 0, 3, SCENA_Y1 + 16, ZLOTO[3])
        prost(d, px + 11, 0, 2, SCENA_Y1 + 16, ZLOTO[0])
        obrys(d, px, 0, 16, SCENA_Y1 + 16)
    # przód sceny z rampą świateł
    prost(d, 120, SCENA_Y1, W - 240, 20, DREWNO_C[2])
    prost(d, 120, SCENA_Y1, W - 240, 2, DREWNO[4])
    obrys(d, 120, SCENA_Y1, W - 240, 20)
    for lx in range(140, W - 140, 40):
        prost(d, lx, SCENA_Y1 - 4, 8, 4, METAL[1])
        prost(d, lx + 2, SCENA_Y1 - 3, 4, 2, (255, 226, 150))
    for lx in range(140, W - 140, 120):
        m.swiatla.append((lx + 4, SCENA_Y1 - 6, 0.55))
    # schody na scenę po obu stronach
    for sx in (120, W - 170):
        for i in range(4):
            prost(d, sx, SCENA_Y1 + i * 5, 50, 5, DREWNO[3 - i % 2])
            prost(d, sx, SCENA_Y1 + i * 5, 50, 1, DREWNO[4])
        obrys(d, sx, SCENA_Y1, 50, 20)
    m.swiatla.append((480, 120, 1.4))  # punktowiec na środku sceny
    # dekoracja ostatniego aktu: stół nakryty obrusem, dwa krzesła, kandelabr
    stol = nowy(70, 40)
    ds = ImageDraw.Draw(stol)
    skrzynia(ds, 0, 2, 70, 16, 4, DREWNO)
    ds.polygon([(2, 4), (68, 4), (70, 34), (0, 34)], fill=PAPIER[1], outline=O)
    prost(ds, 2, 4, 66, 14, PAPIER[2])
    prost(ds, 30, 6, 4, 8, CZERWIEN[2])  # kielich wina
    swiecznik(ds, 50, 16)
    m.obiekt("stol_scena", stol, 420, 120, 14)
    for i, kx in enumerate((396, 494)):
        krzeslo = nowy(20, 34)
        dk = ImageDraw.Draw(krzeslo)
        prost(dk, 3, 0, 14, 16, DREWNO[2])
        obrys(dk, 3, 0, 14, 16)
        prost(dk, 6, 3, 8, 10, CZERWIEN[2])
        skrzynia(dk, 1, 16, 18, 6, 10, DREWNO)
        m.obiekt(f"krzeslo_{i}", krzeslo, kx, 124, 10)
    # loże na bocznych ścianach
    for strona, x in ((-1, S), (1, W - S - 36)):
        for ly in (260, 400, 520):
            prost(d, x, ly, 36, 70, CZERWIEN[1])
            for fy in range(ly, ly + 70, 6):
                prost(d, x, fy, 36, 2, CZERWIEN[2])
            bx = x + 30 if strona < 0 else x
            prost(d, bx, ly - 4, 6, 78, ZLOTO[1])
            for by in range(ly, ly + 70, 6):
                prost(d, bx + 1, by, 4, 2, ZLOTO[3])
            obrys(d, x, ly - 4, 36, 78)
            mp.kinkiet(d, x + 18, ly - 14)
            m.swiatla.append((x + 18, ly - 20, 0.5))
        m.kolizje.append((x, 250, x + 36, 600))
    # wyjścia ewakuacyjne przy dolnej ścianie
    for ex in (60, W - 120):
        prost(d, ex, H - S - 4, 60, S + 4, (24, 20, 26))
        szyld(d, ex + 6, H - S - 20, "WYJŚCIE", tlo=[ZIELEN[0], ZIELEN[0]], kolor=ZIELEN[3])
        m.swiatla.append((ex + 30, H - S - 16, 0.25))
    # rzędy foteli w trzech sektorach
    nr = 0
    for ry in range(252, 560, 34):
        for sx, n in ((64, 14), (346, 17), (666, 14)):
            img = rzad_foteli(n)
            m.obiekt(f"rzad_{nr}", img, sx, ry, 20)
            nr += 1
    mp.ramy_scian(d)
    # krawędź sceny jako ściana poza schodami
    m.kolizje.append((120 + 50, SCENA_Y1 + 2, W - 170, SCENA_Y1 + 20))
    m.kolizje.append((0, 0, 120, SCENA_Y1 + 20))
    m.kolizje.append((W - 120, 0, W, SCENA_Y1 + 20))
    m.kolizje.append((120, 0, W - 120, 60))
    return m, dict(korzen="Widownia", start=(320, 610),
                   postacie=(("Wolski", "wolski", (480, 140)), ("Bogdan", "bogdan", (640, 236))),
                   mrok=(0.4, 0.36, 0.48), podloze="dywan", strefy=((0, 0, W, SCENA_Y1 + 20, "drewno"),))


# ---------- GARDEROBA ANI ----------

def kanapa():
    img = nowy(84, 44)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 0, 84, 6, 22, CZERWIEN)  # oparcie
    skrzynia(d, 0, 18, 84, 8, 16, CZERWIEN)  # siedzisko
    for px in (2, 42):
        obrys(d, px, 20, 40, 6, CZERWIEN[1])
    skrzynia(d, 0, 10, 10, 4, 26, CZERWIEN)  # podłokietniki
    skrzynia(d, 74, 10, 10, 4, 26, CZERWIEN)
    d.polygon([(52, 14), (66, 12), (68, 22), (54, 24)], fill=PAPIER[2], outline=O)  # rzucony szal
    for nx in (4, 78):
        prost(d, nx, 40, 3, 4, DREWNO[1])
    return img


def stolik_kwiaty():
    img = nowy(30, 50)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 24, 30, 6, 6, DREWNO)
    for lx in (3, 25):
        prost(d, lx, 36, 2, 14, DREWNO[1])
    prost(d, 11, 14, 8, 12, SZKLO[3])  # wazon
    obrys(d, 11, 14, 8, 12)
    for i, (kx, ky) in enumerate(((8, 6), (15, 2), (21, 7), (12, 10), (19, 11))):
        d.line([(15, 14), (kx + 2, ky + 3)], fill=ZIELEN[1])
        d.ellipse((kx, ky, kx + 5, ky + 5), fill=CZERWIEN[3] if i % 2 else CZERWIEN[4], outline=O)
    prost(d, 20, 22, 6, 4, PAPIER[2])  # bilecik
    return img


def garderoba():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 640, 360, 104
    mp.los = random.Random(31)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    prost(d, 0, 0, W, H, O)
    mp.podloga(d)
    mp.sciana_tylna(d)
    # chodniczek przed toaletką
    prost(d, 236, PY + 30, 110, 40, TKANINY[0][1])
    obrys(d, 236, PY + 30, 110, 40, TKANINY[0][3])
    obrys(d, 240, PY + 34, 102, 32, TKANINY[0][2])

    # toaletka Ani: lustro w żarówkach, zdjęcie, kosmetyki
    prost(d, 252, 26, 76, 56, DREWNO_C[2])
    obrys(d, 252, 26, 76, 56)
    prost(d, 258, 32, 64, 44, SZKLO[2])
    prost(d, 262, 36, 3, 24, SZKLO[4])
    prost(d, 268, 34, 2, 12, SZKLO[3])
    for bx in range(256, 328, 9):
        d.ellipse((bx, 22, bx + 5, 27), fill=(255, 236, 170), outline=O)
    for by in range(32, 80, 9):
        for bx in (247, 328):
            d.ellipse((bx, by, bx + 5, by + 5), fill=(255, 236, 170), outline=O)
    for lx in (270, 310):
        m.swiatla.append((lx, 40, 0.9))
    # karteczki za ramą lustra
    prost(d, 312, 30, 10, 12, PAPIER[2])
    prost(d, 258, 64, 8, 10, (230, 200, 120))
    skrzynia(d, 240, PY - 22, 100, 10, 30, DREWNO)
    for sx in (246, 296):
        obrys(d, sx, PY - 6, 38, 10, DREWNO[1])
        prost(d, sx + 17, PY - 2, 4, 2, ZLOTO[2])
    # zdjęcie w ramce (Ania i Adrian), puderniczka, szminka, szczotka
    prost(d, 302, PY - 36, 14, 16, ZLOTO[1])
    obrys(d, 302, PY - 36, 14, 16)
    prost(d, 304, PY - 34, 10, 12, NIEBO[2])
    prost(d, 304, PY - 26, 10, 4, (200, 180, 130))  # plaża
    prost(d, 306, PY - 31, 2, 5, (60, 40, 30))  # dwie postacie
    prost(d, 310, PY - 31, 2, 5, (120, 60, 40))
    d.ellipse((248, PY - 22, 258, PY - 17), fill=PAPIER[2], outline=O)
    prost(d, 262, PY - 24, 3, 6, CZERWIEN[3])
    prost(d, 322, PY - 22, 12, 3, DREWNO[3])
    m.kolizje.append((240, PY, 340, PY + 10))

    # kostiumy Ani na drążku
    mp.wieszak_scienny(d, 380, PY - 58, 120)
    m.kolizje.append((378, PY, 502, PY + 18))
    # szafa i plakat
    mp.szafa(d, 40, PY - 74)
    m.kolizje.append((40, PY, 112, PY + 22))
    plakat(d, 170, 30, ["OSTATNI", "AKT"], "maska")
    mp.kinkiet(d, 140, 50)
    m.swiatla.append((140, 44, 0.7))
    mp.kinkiet(d, 540, 50)
    m.swiatla.append((540, 44, 0.7))

    m.obiekt("kanapa", kanapa(), 60, 230, 22)
    m.obiekt("kwiaty", stolik_kwiaty(), 176, 236, 8)
    m.obiekt("parawan", mp.parawan(), 540, 150, 8)
    kosz = nowy(14, 16)
    dk = ImageDraw.Draw(kosz)
    skrzynia(dk, 0, 2, 14, 3, 11, METAL)
    d2 = (PAPIER[2])
    prost(dk, 3, 0, 5, 3, d2)
    m.obiekt("kosz", kosz, 352, PY + 4, 6)
    ramy_z_wejsciem(d, 288, 64)
    return m, dict(korzen="Garderoba", start=(320, 320), postacie=(), mrok=(0.55, 0.5, 0.6))


# ---------- MAGAZYN DEKORACJI (rozdział 2, scena 6) ----------

BETON = [(30, 30, 34), (40, 40, 44), (52, 52, 56), (66, 66, 70)]
BLACHA = [(22, 26, 30), (34, 40, 46), (48, 56, 62), (66, 74, 80)]


def regal_magazyn(h=70):
    """Wysoki metalowy regał z kartonami i skrzyniami, widziany od frontu."""
    img = nowy(96, h + 10)
    d = ImageDraw.Draw(img)
    for sx in (2, 90):
        prost(d, sx, 0, 4, h + 10, METAL[1])
        obrys(d, sx, 0, 4, h + 10)
    for py in range(6, h + 4, 22):
        prost(d, 2, py + 16, 92, 3, METAL[2])
        obrys(d, 2, py + 16, 92, 3)
        bx = 7
        while bx < 84:
            bw = mp.los.randint(12, 24)
            bh = mp.los.randint(10, 16)
            k = mp.los.choice([DREWNO, DREWNO_C, [(70, 56, 36), (100, 80, 50), (130, 106, 70), (160, 136, 96), (180, 156, 110)]])
            if bx + bw > 88:
                break
            skrzynia(d, bx, py + 16 - bh, bw, 3, bh - 3, k)
            if mp.los.random() < 0.3:
                prost(d, bx + 3, py + 16 - bh + 5, bw - 6, 3, PAPIER[1])  # etykieta
            bx += bw + 2
    return img


def zamek_dekoracja():
    """Ściana zamku ze sklejki z blankami i wieżyczką, oparta o regał."""
    img = nowy(120, 96)
    d = ImageDraw.Draw(img)
    prost(d, 0, 30, 120, 60, KAMIEN[2])
    for x in range(0, 120, 16):
        prost(d, x, 22, 10, 10, KAMIEN[2])
        obrys(d, x, 22, 10, 10)
    for j, y in enumerate(range(32, 90, 10)):
        for x in range((j % 2) * 8, 120, 16):
            obrys(d, x, y, 16, 10, KAMIEN[1])
    prost(d, 80, 0, 30, 90, KAMIEN[3])  # wieżyczka
    d.polygon([(76, 4), (95, -14), (114, 4)], fill=CZERWIEN[1], outline=O)
    prost(d, 90, 20, 8, 14, (14, 14, 22))
    d.arc((90, 16, 98, 24), 180, 360, fill=O)
    obrys(d, 80, 0, 30, 90)
    obrys(d, 0, 30, 120, 60)
    prost(d, 20, 50, 30, 40, DREWNO[1])  # brama zamku
    for x in range(22, 50, 6):
        prost(d, x, 50, 2, 40, DREWNO[0])
    # zaciek i odpryśnięta farba: dekoracja stoi tu od lat
    prost(d, 60, 40, 8, 6, (110, 100, 80))
    prost(d, 4, 86, 116, 4, DREWNO_C[1])
    return img


def statek_dekoracja():
    """Dziób statku pirackiego z masztem i zwiniętym żaglem."""
    img = nowy(140, 110)
    d = ImageDraw.Draw(img)
    prost(d, 66, 0, 6, 70, DREWNO[2])  # maszt
    obrys(d, 66, 0, 6, 70)
    d.polygon([(40, 10), (98, 10), (92, 18), (46, 18)], fill=PAPIER[1], outline=O)  # zwinięty żagiel
    prost(d, 40, 8, 58, 2, DREWNO[3])
    d.polygon([(0, 60), (110, 56), (140, 70), (110, 104), (6, 104)], fill=DREWNO[2], outline=O)
    for y in range(64, 104, 7):
        d.line([(4, y), (118, y - 2)], fill=DREWNO[1])
    prost(d, 6, 56, 104, 6, DREWNO[3])
    obrys(d, 6, 56, 104, 6)
    for x in (24, 50, 76):
        d.ellipse((x, 72, x + 8, 80), fill=(16, 14, 18), outline=O)  # bulaje
    d.polygon([(120, 66), (138, 60), (134, 72)], fill=ZLOTO[1], outline=O)  # galion
    for x in range(10, 104, 12):
        prost(d, x, 48, 2, 10, DREWNO[3])  # reling
    return img


def sofa_lata30():
    """Sofa z dekoracji salonu z lat 30., wytarta zieleń z frędzlami."""
    img = nowy(80, 40)
    d = ImageDraw.Draw(img)
    zielen = [(16, 34, 24), (26, 52, 36), (38, 70, 48), (56, 92, 64), (74, 112, 80)]
    skrzynia(d, 0, 0, 80, 6, 18, zielen)
    skrzynia(d, 2, 16, 76, 8, 12, zielen)
    for x in range(4, 76, 4):
        d.point((x, 36), fill=ZLOTO[2])
    for x in (2, 74):
        prost(d, x, 36, 4, 4, DREWNO[1])
    prost(d, 14, 18, 18, 5, zielen[1])  # wgniecenie, ktoś tu siedział
    return img


def fotel_lata30():
    img = nowy(30, 36)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 0, 30, 6, 16, CZERWIEN)
    skrzynia(d, 2, 14, 26, 8, 10, CZERWIEN)
    for x in (2, 24):
        prost(d, x, 32, 4, 4, DREWNO[1])
    return img


def lampa_stojaca():
    img = nowy(20, 64)
    d = ImageDraw.Draw(img)
    d.polygon([(2, 14), (18, 14), (14, 0), (6, 0)], fill=ZLOTO[2], outline=O)
    prost(d, 6, 10, 8, 2, ZLOTO[1])
    prost(d, 9, 14, 2, 46, ZLOTO[0])
    d.ellipse((3, 58, 17, 63), fill=ZLOTO[1], outline=O)
    return img


def stolik_salon():
    """Niski stolik z salonu, na nim gramofon-rekwizyt i papiery."""
    img = nowy(40, 26)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 4, 40, 10, 4, DREWNO)
    for x in (2, 34):
        prost(d, x, 18, 4, 8, DREWNO[1])
    prost(d, 22, 0, 12, 8, DREWNO_C[3])  # gramofon-atrapa
    d.ellipse((23, 1, 31, 6), fill=(20, 18, 22))
    prost(d, 4, 5, 12, 8, PAPIER[2])  # lista rekwizytów
    obrys(d, 4, 5, 12, 8, PAPIER[0])
    return img


def skrzynia_magazyn(w=40, h=28, kolor=DREWNO):
    img = nowy(w, h)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 0, w, 8, h - 8, kolor)
    prost(d, 3, 12, w - 6, 2, kolor[1])
    prost(d, 3, h - 8, w - 6, 2, kolor[1])
    d.line([(4, 12), (w - 4, h - 6)], fill=kolor[1])
    napis(d, 4, 2, "TM", kolor[4] if len(kolor) > 4 else PAPIER[1])
    return img


def skrzynia_przewrocona():
    """Przewrócona skrzynka z rekwizytami obok ciała: kielichy, korona, sztuczne owoce."""
    img = nowy(54, 30)
    d = ImageDraw.Draw(img)
    d.polygon([(2, 8), (30, 2), (36, 20), (8, 26)], fill=DREWNO[2], outline=O)
    d.polygon([(30, 2), (36, 20), (40, 18), (34, 2)], fill=DREWNO[1], outline=O)
    prost(d, 34, 20, 6, 6, ZLOTO[2])  # kielich
    prost(d, 36, 26, 2, 3, ZLOTO[1])
    d.polygon([(42, 14), (44, 10), (46, 13), (48, 9), (50, 13), (52, 10), (52, 17), (42, 17)], fill=ZLOTO[2], outline=O)  # korona
    for x, y, k in ((40, 24, CZERWIEN[3]), (46, 22, ZIELEN[2]), (48, 26, (200, 160, 60))):
        d.ellipse((x, y, x + 4, y + 4), fill=k, outline=O)
    return img


def zarowka_wiszaca(dl=150, nad=56):
    """Goła żarówka na kablu. Dolna krawędź obrazka to punkt na podłodze pod żarówką (do sortowania)."""
    img = nowy(9, dl + nad)
    d = ImageDraw.Draw(img)
    prost(d, 4, 0, 1, dl - 4, (14, 14, 16))
    prost(d, 3, dl - 5, 3, 3, METAL[1])
    d.ellipse((1, dl - 3, 7, dl + 4), fill=(255, 240, 180), outline=(120, 100, 60))
    prost(d, 3, dl - 1, 2, 2, (255, 255, 230))
    return img


def wiadro():
    img = nowy(14, 14)
    d = ImageDraw.Draw(img)
    d.polygon([(1, 3), (13, 3), (11, 13), (3, 13)], fill=METAL[2], outline=O)
    d.ellipse((1, 1, 13, 5), fill=(20, 26, 36), outline=O)
    d.arc((3, -4, 11, 6), 180, 360, fill=METAL[3])
    return img


def magazyn():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 960, 600, 110
    mp.los = random.Random(61)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    S = mp.SCIANA
    prost(d, 0, 0, W, H, O)
    # betonowa posadzka w płytach, pęknięcia, plamy oleju
    for y in range(PY, H, 40):
        for x in range(0, W, 60):
            k = mp.los.choice([1, 1, 2, 2, 0])
            prost(d, x, y, 60, 40, BETON[k])
            prost(d, x, y, 60, 1, BETON[min(k + 1, 3)])
            prost(d, x, y, 1, 40, BETON[0])
            for _ in range(10):
                d.point((x + mp.los.randint(2, 57), y + mp.los.randint(2, 37)), fill=BETON[mp.los.choice([0, 3])])
    for _ in range(14):
        x, y = mp.los.randint(40, W - 60), mp.los.randint(PY + 20, H - 40)
        dl = [(x, y)]
        for _ in range(4):
            x += mp.los.randint(-8, 14)
            y += mp.los.randint(-4, 8)
            dl.append((x, y))
        d.line(dl, fill=BETON[0])
    for x, y, r in ((300, 420, 14), (640, 300, 10), (180, 520, 18), (860, 520, 12)):
        d.ellipse((x - r, y - r // 2, x + r, y + r // 2), fill=(18, 16, 20))
        d.ellipse((x - r + 4, y - r // 2 + 2, x - r + 10, y - r // 2 + 4), fill=(46, 40, 60))
    # kałuże pod przeciekającym dachem
    for x, y in ((520, 230), (220, 470), (740, 160)):
        d.ellipse((x - 16, y - 6, x + 16, y + 6), fill=(28, 34, 48))
        d.ellipse((x - 10, y - 3, x - 2, y), fill=(60, 74, 96))
    # tylna ściana z blachy falistej, wysokie okna z deszczem
    prost(d, 0, 0, W, PY, BLACHA[1])
    for x in range(S, W - S, 6):
        prost(d, x, S, 3, PY - S, BLACHA[2])
        prost(d, x, S, 1, PY - S, BLACHA[3])
    for x in (140, 400, 660):
        prost(d, x, 22, 120, 34, (12, 16, 30))
        for kx in range(x, x + 120, 30):
            obrys(d, kx, 22, 30, 34, BLACHA[0])
        for _ in range(16):
            rx, ry = x + mp.los.randint(2, 116), 24 + mp.los.randint(0, 28)
            prost(d, rx, ry, 1, 3, (70, 90, 130))
    # zbita szyba, stąd kapie woda
    d.polygon([(700, 26), (712, 40), (704, 52), (718, 46), (724, 54)], fill=(30, 40, 70))
    prost(d, 0, PY - 4, W, 4, BLACHA[0])
    prost(d, 0, PY - 1, W, 1, O)
    szyld(d, 380, 70, "MAGAZYN DEKORACJI TM", tlo=[BLACHA[0], BLACHA[0]], kolor=PAPIER[1])
    # ściany boczne i dolna z bramą
    k = BLACHA
    prost(d, 0, 0, S, H, k[2])
    prost(d, W - S, 0, S, H, k[2])
    prost(d, 0, H - S, W, S, k[2])
    prost(d, S - 2, 0, 2, H, k[3])
    prost(d, W - S, 0, 2, H, k[0])
    obrys(d, 0, 0, W, H)
    # brama wjazdowa na dole, uchylona: za nią deszcz i światło radiowozu
    prost(d, 440, H - S - 2, 80, S + 2, (8, 10, 18))
    for x in range(442, 518, 5):
        prost(d, x, H - S, 1, S, (40, 50, 80))
    prost(d, 436, H - S - 4, 4, S + 4, METAL[2])
    prost(d, 520, H - S - 4, 4, S + 4, METAL[2])
    m.swiatla.append((480, H - 10, 0.35))

    # dwie żarówki, które jeszcze działają: przy bramie i nad miejscem, gdzie leży Adrian
    for i, (zx, zy) in enumerate(((470, 470), (790, 380))):
        img = zarowka_wiszaca()
        m.obiekty.append((f"zarowka_{i}", img, zx - 4, zy - img.height))
        for r, kol in ((56, BETON[1]), (42, BETON[2]), (24, BETON[3])):
            d.ellipse((zx - r, zy - r * 4 // 9, zx + r, zy + r * 4 // 9), fill=kol)
        m.swiatla.append((zx, zy - 40, 1.0))

    # alejki ze starymi scenografiami
    m.obiekt("zamek", zamek_dekoracja(), 40, PY + 6, 10)
    m.obiekt("regal_1", regal_magazyn(), 180, PY + 2, 10)
    m.obiekt("regal_2", regal_magazyn(), 290, PY + 2, 10)
    m.obiekt("regal_3", regal_magazyn(), 540, PY + 2, 10)
    m.obiekt("statek", statek_dekoracja(), 780, PY - 8, 30)
    # środkowe rzędy regałów tworzą alejki
    for i, (rx, ry) in enumerate(((330, 230), (330, 340), (560, 230), (560, 340))):
        m.obiekt(f"regal_s{i}", regal_magazyn(56), rx, ry, 12)
    # manekiny w kostiumach w lewej alejce (jeden się przewróci, scena dodaje go sama)
    for i, (mx, my, kol) in enumerate(((60, 280, TKANINY[0]), (104, 290, TKANINY[4]), (190, 300, TKANINY[2]),
                                       (60, 380, CZERWIEN[:4] + [CZERWIEN[4]]), (236, 380, TKANINY[1]))):
        m.obiekt(f"manekin_{i}", mp.manekin(kol), mx, my, 8)
    m.obiekt("manekin_upadek", mp.manekin(TKANINY[3]), 140, 410, 8)  # pod nim leży telefon Adriana
    # salon z lat 30.
    prost(d, 650, 200, 120, 70, CZERWIEN[1])
    obrys(d, 654, 204, 112, 62, ZLOTO[1])
    m.obiekt("sofa", sofa_lata30(), 670, 196, 20)
    m.obiekt("fotel", fotel_lata30(), 640, 238, 14)
    m.obiekt("stolik", stolik_salon(), 694, 242, 8)
    m.obiekt("lampa", lampa_stojaca(), 760, 200, 6)
    # skrzynie wokół miejsca, gdzie leży Adrian
    for i, (sx, sy, kol) in enumerate(((700, 330, DREWNO), (720, 362, DREWNO_C), (880, 330, DREWNO),
                                        (860, 420, DREWNO_C), (680, 440, DREWNO))):
        m.obiekt(f"skrzynia_{i}", skrzynia_magazyn(kolor=kol), sx, sy, 16)
    m.obiekt("skrzynia_przewrocona", skrzynia_przewrocona(), 818, 382, 10)
    # przy bramie: stół warsztatowy i skrzynka z rekwizytami (tu leży latarka)
    m.obiekt("skrzynia_rekwizyty", skrzynia_magazyn(46, 30, DREWNO), 330, 470, 16)
    m.obiekt("skrzynia_lis", skrzynia_magazyn(34, 22, DREWNO_C), 580, 500, 12)
    m.obiekt("wiadro", wiadro(), 513, 222, 6)
    return m, dict(korzen="Magazyn", start=(480, H - 40), postacie=(), mrok=(0.13, 0.13, 0.19), podloze="marmur")


# ---------- BUDKA STRÓŻA (rozdział 2, scena 7) ----------

ASFALT_B = [(14, 14, 20), (20, 20, 28), (28, 28, 38), (38, 38, 50)]
LINO = [(54, 60, 52), (70, 78, 66), (86, 96, 80)]
FARBA = [(56, 70, 62), (76, 94, 82), (150, 146, 126), (178, 172, 150)]


def stol_zenona():
    """Stolik z mini-telewizorem i szklanką herbaty w koszyczku."""
    img = nowy(64, 46)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 18, 64, 12, 6, DREWNO)
    for x in (2, 58):
        prost(d, x, 36, 4, 10, DREWNO[1])
    skrzynia(d, 6, 0, 26, 4, 16, [(20, 20, 24), (34, 34, 40), (52, 52, 60), (70, 70, 80), (90, 90, 100)])
    prost(d, 9, 6, 20, 10, (60, 90, 120))  # ekran z meczem
    prost(d, 12, 12, 14, 2, ZIELEN[2])
    prost(d, 40, 14, 6, 8, (200, 140, 80))  # herbata w szklance
    obrys(d, 40, 14, 6, 8, METAL[3])
    prost(d, 50, 18, 10, 3, PAPIER[2])  # gazeta
    return img


def biurko_szuflada():
    """Biurko z wysuniętą szufladą pełną kabli."""
    img = nowy(60, 40)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 4, 60, 10, 22, DREWNO_C)
    prost(d, 6, 24, 24, 10, DREWNO_C[3])  # wysunięta szuflada
    obrys(d, 6, 24, 24, 10)
    for i in range(6):
        d.line([(8 + i * 3, 26), (12 + i * 2, 32)], fill=mp.los.choice([(20, 20, 20), (200, 200, 200), (180, 40, 40)]))
    prost(d, 40, 0, 14, 8, (30, 30, 34))  # radio
    prost(d, 42, 2, 6, 4, (120, 230, 140))
    return img


def kiosk_paczki():
    """Całodobowa budka z pączkami: świecące okienko i szyld."""
    img = nowy(90, 80)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 10, 90, 8, 60, [(70, 30, 30), (110, 46, 40), (150, 70, 56), (190, 110, 80), (214, 140, 100)])
    prost(d, 14, 30, 62, 26, (255, 220, 150))  # okienko
    obrys(d, 14, 30, 62, 26)
    for x in (20, 34, 48, 62):
        d.ellipse((x, 46, x + 9, 53), fill=(200, 130, 60), outline=O)
        prost(d, x + 2, 47, 5, 2, (240, 230, 220))
    prost(d, 6, 0, 78, 12, (40, 20, 30))
    napis(d, 26, 4, "PACZKI", (255, 200, 120))
    prost(d, 10, 56, 70, 4, DREWNO[2])  # parapet
    return img


def buda_psa():
    img = nowy(30, 26)
    d = ImageDraw.Draw(img)
    d.polygon([(2, 10), (15, 0), (28, 10)], fill=DREWNO[1], outline=O)
    skrzynia(d, 3, 10, 24, 2, 14, DREWNO)
    d.ellipse((10, 14, 20, 26), fill=(10, 8, 10))
    return img


def budka():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 640, 360, 104
    mp.los = random.Random(71)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    S = mp.SCIANA
    SC = 400  # ściana budki: po lewej wnętrze, po prawej plac przed bramą
    prost(d, 0, 0, W, H, O)
    # wnętrze: linoleum w kratę, ściany w olejnej farbie
    for y in range(PY, H, 16):
        for x in range(0, SC, 16):
            prost(d, x, y, 16, 16, LINO[(x // 16 + y // 16) % 2 + 1])
    prost(d, 0, 0, SC, PY, FARBA[3])
    prost(d, 0, PY - 44, SC, 44, FARBA[1])
    prost(d, 0, PY - 44, SC, 2, FARBA[0])
    prost(d, 0, PY - 1, SC, 1, O)
    # okno na deszcz
    prost(d, 60, 20, 70, 40, (14, 18, 34))
    obrys(d, 60, 20, 70, 40, DREWNO[1])
    prost(d, 94, 20, 2, 40, DREWNO[1])
    for _ in range(14):
        prost(d, mp.los.randint(62, 126), mp.los.randint(22, 54), 1, 3, (70, 90, 130))
    # kalendarz z 1999 roku i półka
    prost(d, 180, 20, 26, 34, PAPIER[2])
    obrys(d, 180, 20, 26, 34)
    prost(d, 182, 22, 22, 12, (60, 110, 170))
    for i in range(4):  # kartka z rokiem: cztery czerwone kreski cyfr
        prost(d, 184 + i * 5, 38, 3, 7, CZERWIEN[2])
    prost(d, 240, 40, 80, 3, DREWNO[2])
    for i, x in enumerate(range(244, 316, 10)):
        prost(d, x, 28, 7, 12, TKANINY[i % len(TKANINY)][2])  # segregatory
    # klucze na tablicy
    prost(d, 340, 24, 40, 30, DREWNO[2])
    obrys(d, 340, 24, 40, 30)
    for kx in range(344, 378, 6):
        prost(d, kx, 28, 1, 6, ZLOTO[2])
    m.swiatla.append((200, 70, 0.9))
    m.obiekt("stol", stol_zenona(), 150, 160, 14)
    m.obiekt("biurko", biurko_szuflada(), 290, PY - 2, 16)
    # na zewnątrz: mokry asfalt, siatka, buda psa, kiosk z pączkami
    prost(d, SC, 0, W - SC, H, ASFALT_B[1])
    for y in range(PY, H, 5):
        for _ in range(4):
            prost(d, mp.los.randint(SC, W), y, mp.los.randint(4, 12), 1, ASFALT_B[2])
    prost(d, SC, 0, W - SC, PY, (14, 16, 26))
    for x in range(SC, W, 8):  # siatka ogrodzenia
        d.line([(x, 30), (x + 8, PY)], fill=METAL[1])
        d.line([(x + 8, 30), (x, PY)], fill=METAL[1])
    prost(d, SC, 28, W - SC, 3, METAL[2])
    m.obiekt("kiosk", kiosk_paczki(), 470, 120, 20)
    m.swiatla.append((515, 160, 0.8))
    m.obiekt("buda", buda_psa(), 590, 80, 10)
    # latarnia przy bramie
    prost(d, 612, 150, 4, 120, (36, 36, 42))
    m.swiatla.append((614, 150, 0.7))
    # dolna siatka z furtką na plac (przejście x 566-624)
    FY = 322
    for x0, x1 in ((SC + 12, 560),):
        for x in range(x0, x1, 8):
            d.line([(x, FY), (min(x + 8, x1), H - S)], fill=METAL[1])
            d.line([(min(x + 8, x1), FY), (x, H - S)], fill=METAL[1])
        prost(d, x0, FY - 2, x1 - x0, 3, METAL[2])
        m.kolizje.append((x0, FY + 4, x1, H))
    for sx in (558, 626):  # słupki furtki
        prost(d, sx, FY - 10, 5, H - S - FY + 10, (40, 40, 48))
        prost(d, sx, FY - 10, 5, 2, METAL[3])
        m.kolizje.append((sx, FY + 4, sx + 5, H))
    # skrzydło furtki otwarte do góry, na plac
    prost(d, 619, FY - 44, 7, 44, (14, 16, 26))
    d.rectangle((619, FY - 44, 625, FY - 1), outline=METAL[2])
    for y in range(FY - 40, FY, 6):
        d.line([(620, y), (624, y + 5)], fill=METAL[1])
    prost(d, 566, H - S - 3, 58, 3, ASFALT_B[2])  # wydeptany próg
    # ściana budki z drzwiami (przejście y 220-280)
    for y0, y1 in ((0, 220), (280, H)):
        prost(d, SC - 4, y0, 16, y1 - y0, FARBA[0])
        prost(d, SC - 4, y0, 2, y1 - y0, FARBA[1])
        m.kolizje.append((SC - 4, y0, SC + 12, y1))
    prost(d, SC - 4, 220, 16, 3, DREWNO[2])
    prost(d, SC - 4, 277, 16, 3, DREWNO[2])
    k = FARBA
    prost(d, 0, 0, S, H, k[0])
    prost(d, W - S, 0, S, H, METAL[1])
    prost(d, 0, H - S, W, S, k[0])
    obrys(d, 0, 0, W, H)
    return m, dict(korzen="Budka", start=(440, 250), postacie=(), mrok=(0.42, 0.4, 0.5), podloze="drewno",
                   strefy=((SC, 0, W, H, "mokry"),))


def auto_bok(nadwozie, napis_dach=None, kogut=False):
    """Samochód z boku pod skosem (ok. 104x48): nadwozie, szyby, koła, opcjonalnie
    podświetlany napis na dachu (taksówka) albo kogut (radiowóz)."""
    img = nowy(104, 50)
    d = ImageDraw.Draw(img)
    c0, c1, c2, c3 = nadwozie
    d.polygon([(4, 24), (22, 22), (34, 10), (72, 10), (86, 22), (100, 26), (100, 40), (4, 40)], fill=c1, outline=O)
    prost(d, 5, 26, 94, 4, c2)
    prost(d, 5, 34, 94, 6, c0)
    d.polygon([(26, 22), (37, 12), (52, 12), (52, 22)], fill=(30, 40, 60))
    d.polygon([(55, 22), (55, 12), (70, 12), (80, 22)], fill=(30, 40, 60))
    d.line([(38, 13), (44, 13)], fill=(80, 100, 130))
    prost(d, 96, 27, 4, 3, (255, 230, 150))  # przedni reflektor
    prost(d, 4, 27, 3, 3, (180, 30, 30))      # tylne światło
    for kx in (14, 74):
        d.ellipse((kx, 33, kx + 16, 49), fill=(14, 14, 16), outline=O)
        d.ellipse((kx + 5, 38, kx + 11, 44), fill=METAL[2])
    prost(d, 52, 24, 2, 1, c3)  # klamki
    prost(d, 84, 24, 2, 1, c3)
    if napis_dach:
        prost(d, 42, 3, 22, 8, (240, 200, 60))
        obrys(d, 42, 3, 22, 8)
        napis(d, 45, 5, napis_dach, O)
    if kogut:
        prost(d, 46, 5, 6, 5, (60, 90, 220))
        prost(d, 52, 5, 6, 5, (220, 40, 40))
        obrys(d, 46, 5, 12, 5)
    return img


def latarnia_uliczna():
    img = nowy(24, 130)
    d = ImageDraw.Draw(img)
    prost(d, 10, 10, 4, 118, (36, 36, 42))
    prost(d, 8, 124, 8, 6, (28, 28, 34))
    prost(d, 4, 4, 16, 8, (50, 50, 56))
    prost(d, 6, 11, 12, 3, (255, 230, 160))
    return img


def plac():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 800, 450, 110
    mp.los = random.Random(81)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    S = mp.SCIANA
    prost(d, 0, 0, W, H, O)
    # mokry asfalt z kałużami, w których odbija się latarnia
    prost(d, 0, PY, W, H - PY, ASFALT_B[1])
    for y in range(PY, H, 4):
        for _ in range(6):
            prost(d, mp.los.randint(0, W), y, mp.los.randint(4, 14), 1, ASFALT_B[2])
    for kx, ky, kr in ((300, 250, 40), (470, 380, 30), (130, 220, 26), (640, 250, 34), (560, 420, 22)):
        d.ellipse((kx - kr, ky - kr // 3, kx + kr, ky + kr // 3), fill=(24, 30, 48))
        d.ellipse((kx - kr // 2, ky - kr // 8, kx + kr // 3, ky + kr // 10), fill=(44, 52, 76))
    # pasy parkingowe i krawężnik ulicy na dole
    for x in range(40, W - 40, 120):
        prost(d, x, 320, 3, 50, (70, 70, 80))
    prost(d, 0, H - 40, W, 4, KAMIEN[1])
    prost(d, 0, H - 36, W, 36 - S, (12, 12, 18))
    # fasada magazynu (blacha falista) z zaplombowaną bramą
    prost(d, 0, 0, 540, PY, BLACHA[1])
    for x in range(0, 540, 6):
        prost(d, x, 0, 2, PY, BLACHA[2])
        prost(d, x + 2, 0, 1, PY, BLACHA[0])
    prost(d, 0, PY - 4, 540, 4, BLACHA[0])
    szyld(d, 300, 12, "MAGAZYN DEKORACJI TM", tlo=[BLACHA[0], BLACHA[0]], kolor=PAPIER[1])
    prost(d, 200, 28, 90, PY - 28, (16, 18, 22))
    obrys(d, 200, 28, 90, PY - 28, METAL[2])
    prost(d, 244, 28, 2, PY - 28, METAL[2])
    d.line([(204, 60), (286, 90)], fill=(220, 200, 40), width=2)  # taśma policyjna
    d.line([(204, 90), (286, 60)], fill=(220, 200, 40), width=2)
    m.kolizje.append((0, 0, 540, PY))
    # budka stróża od frontu: oświetlone okno i drzwi
    prost(d, 540, 0, W - 540, PY, FARBA[1])
    prost(d, 540, 0, W - 540, 10, FARBA[0])
    prost(d, 560, 36, 60, 40, (240, 210, 140))
    obrys(d, 560, 36, 60, 40, DREWNO[1])
    prost(d, 589, 36, 2, 40, DREWNO[1])
    prost(d, 650, 40, 30, PY - 40, DREWNO[1])
    obrys(d, 650, 40, 30, PY - 40)
    prost(d, 674, 74, 3, 3, ZLOTO[2])
    m.swiatla.append((590, 90, 0.8))
    m.kolizje.append((540, 0, W, PY))
    m.obiekt("kiosk", kiosk_paczki(), 700, PY - 60, 20)
    m.swiatla.append((745, PY + 10, 0.6))
    # latarnia uliczna na środku placu (miga, skrypt sceny steruje światłem S3)
    m.obiekt("latarnia", latarnia_uliczna(), 408, 160, 6)
    m.swiatla.append((420, 190, 1.0))
    # samochody: radiowóz Nowickiego, taksówka (podjeżdża w scenie), auto Antoniego
    m.obiekt("radiowoz", auto_bok([(150, 160, 170), (210, 216, 222), (40, 70, 160), (250, 250, 250)], kogut=True), 80, 300, 16)
    m.obiekt("auto_antoniego", auto_bok([(30, 34, 50), (50, 56, 80), (70, 78, 106), (140, 150, 170)]), 640, 330, 16)
    # taksówka podjeżdża w trakcie sceny, więc jest osobnym rekwizytem
    auto_bok([(150, 120, 30), (220, 180, 50), (240, 210, 90), (60, 40, 10)], napis_dach="TAXI").save("rekwizyty/taksowka.png")
    # krawędzie
    prost(d, 0, 0, S, H, BLACHA[2])
    prost(d, W - S, 0, S, H, BLACHA[2])
    obrys(d, 0, 0, W, H)
    return m, dict(korzen="Plac", start=(260, 200), postacie=(), mrok=(0.38, 0.38, 0.5), podloze="mokry",
                   strefy=((0, PY, W, H, "mokry"),))


def biurko_dyrektora():
    """Duże biurko Lisa zawalone papierami: stosy, teczki, popielniczka, telefon, lampka."""
    img = nowy(150, 56)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 4, 150, 26, 24, DREWNO)
    for dx in (8, 112):  # szuflady
        obrys(d, dx, 34, 30, 10, DREWNO[1])
        prost(d, dx + 13, 38, 4, 2, ZLOTO[2])
    for nx in (2, 144):
        prost(d, nx, 52, 4, 4, DREWNO[1])
    # stos papierów (lewo)
    for i in range(5):
        prost(d, 10 + i % 2, 12 - i * 2, 26, 12, PAPIER[2 - i % 2])
        obrys(d, 10 + i % 2, 12 - i * 2, 26, 12, PAPIER[0])
    # teczki (środek)
    for i, kol in enumerate(((60, 90, 140), (150, 60, 50), (70, 110, 70))):
        prost(d, 50 + i * 3, 14 - i * 2, 30, 10, kol)
        obrys(d, 50 + i * 3, 14 - i * 2, 30, 10)
    # popielniczka z petami (prawo)
    d.ellipse((96, 14, 112, 22), fill=SZKLO[3], outline=O)
    d.ellipse((99, 16, 109, 20), fill=KAMIEN[1])
    for px in (101, 105):
        prost(d, px, 16, 3, 1, PAPIER[2])
    # telefon i lampka
    prost(d, 118, 12, 14, 8, (30, 30, 34))
    obrys(d, 118, 12, 14, 8)
    prost(d, 120, 9, 10, 3, (44, 44, 50))
    prost(d, 140, 2, 2, 16, METAL[2])
    d.polygon([(134, 2), (146, 2), (144, -2), (136, -2)], fill=ZIELEN[1])
    prost(d, 134, 0, 12, 3, ZIELEN[1])
    obrys(d, 134, 0, 12, 3)
    return img


def fotel_skorzany():
    img = nowy(40, 46)
    d = ImageDraw.Draw(img)
    skrzynia(d, 2, 0, 36, 6, 26, DREWNO_C)
    skrzynia(d, 0, 22, 40, 8, 12, DREWNO_C)
    prost(d, 18, 42, 4, 4, METAL[1])
    return img


def krzeslo():
    img = nowy(22, 34)
    d = ImageDraw.Draw(img)
    skrzynia(d, 2, 0, 18, 4, 16, DREWNO)
    skrzynia(d, 0, 16, 22, 6, 6, DREWNO)
    for nx in (1, 19):
        prost(d, nx, 28, 2, 6, DREWNO[1])
    return img


def regal_segregatory():
    img = nowy(70, 86)
    d = ImageDraw.Draw(img)
    skrzynia(d, 0, 0, 70, 6, 80, DREWNO_C)
    for py in (10, 36, 62):
        prost(d, 3, py + 22, 64, 2, DREWNO_C[3])
        for i, sx in enumerate(range(5, 64, 7)):
            kol = [(60, 90, 140), (150, 60, 50), (70, 110, 70), PAPIER[1]][(i + py) % 4]
            prost(d, sx, py + 2, 6, 20, kol)
            prost(d, sx + 2, py + 6, 2, 4, PAPIER[2])
    return img


def gabinet():
    mp.SZER, mp.WYS, mp.PODLOGA_Y = 640, 360, 104
    mp.los = random.Random(91)
    m = mp.Mapa()
    d = m.d
    W, H, PY = mp.SZER, mp.WYS, mp.PODLOGA_Y
    prost(d, 0, 0, W, H, O)
    mp.podloga(d)
    mp.sciana_tylna(d)
    # dywan pod biurkiem
    prost(d, 200, 150, 250, 110, CZERWIEN[0])
    obrys(d, 204, 154, 242, 102, ZLOTO[1])
    obrys(d, 210, 160, 230, 90, CZERWIEN[2])
    # okno na podwórze, szare niedzielne światło
    prost(d, 280, 18, 90, 60, (110, 120, 136))
    for ry in range(22, 74, 6):
        prost(d, 284, ry, 82, 1, (140, 150, 164))
    obrys(d, 280, 18, 90, 60, DREWNO[2])
    prost(d, 324, 18, 2, 60, DREWNO[2])
    m.swiatla.append((325, 80, 0.9))
    # plakaty dawnych premier
    plakat(d, 60, 24, ["HAMLET"], "korona")
    plakat(d, 150, 24, ["ROMEO"], "roza")
    # tablica korkowa z obsadą i kalendarz
    prost(d, 420, 24, 70, 50, (150, 110, 70))
    obrys(d, 420, 24, 70, 50, DREWNO[1])
    for i, (kx, ky) in enumerate(((426, 30), (452, 28), (470, 44), (430, 52))):
        prost(d, kx, ky, 16, 18, PAPIER[2 - i % 2])
        prost(d, kx + 7, ky + 1, 2, 2, CZERWIEN[2])
    prost(d, 510, 26, 30, 40, PAPIER[2])
    obrys(d, 510, 26, 30, 40)
    prost(d, 510, 26, 30, 8, CZERWIEN[1])
    for ky in range(38, 64, 6):
        for kx in range(513, 538, 5):
            prost(d, kx, ky, 3, 3, PAPIER[0])
    prost(d, 523, 56, 4, 4, CZERWIEN[2])  # zakreślony wtorek
    mp.kinkiet(d, 250, 50)
    m.swiatla.append((250, 44, 0.6))
    mp.kinkiet(d, 400, 50)
    m.swiatla.append((400, 44, 0.6))
    m.obiekt("regal", regal_segregatory(), 560, PY - 70, 14)
    m.obiekt("fotel_lisa", fotel_skorzany(), 300, 126, 10)
    m.obiekt("biurko", biurko_dyrektora(), 250, 150, 20)
    m.obiekt("krzeslo_1", krzeslo(), 270, 222, 6)
    m.obiekt("krzeslo_2", krzeslo(), 360, 222, 6)
    m.obiekt("kanapa", kanapa(), 40, 220, 22)
    m.obiekt("kwiaty", stolik_kwiaty(), 140, 230, 8)
    m.swiatla.append((390, 150, 0.6))  # lampka na biurku
    ramy_z_wejsciem(d, 288, 64)
    return m, dict(korzen="Gabinet", start=(320, 320), postacie=(), mrok=(0.6, 0.58, 0.62))


MAPY = {"foyer": foyer, "kulisy": kulisy, "widownia": widownia, "garderoba": garderoba, "magazyn": magazyn, "budka": budka, "plac": plac, "gabinet": gabinet}


def main(folder_podgladu=None):
    for klucz, buduj in MAPY.items():
        m, scena = buduj()
        pod = mp.zapisz(m, klucz, **scena)
        if folder_podgladu:
            pod.save(Path(folder_podgladu) / f"{klucz}.png")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else None)
