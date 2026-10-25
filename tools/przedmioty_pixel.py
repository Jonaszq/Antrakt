"""Ikonki przedmiotów (20x20) i rekwizyty-skrzynki na mapy, w pixel arcie.

Ikonki trafiają do ui/przedmioty/<id>.png, rekwizyty do rekwizyty/<nazwa>.png.
Kontur dorysowuje się sam wokół kształtu (funkcja kontur).
Uruchom z katalogu projektu: python3 tools/przedmioty_pixel.py [katalog_podglądu]
"""
import os
import sys

from PIL import Image, ImageDraw

O = (12, 8, 10, 255)
PAPIER = [(150, 132, 108), (196, 180, 150), (232, 222, 196), (250, 244, 228)]
ZLOTO = [(120, 84, 30), (176, 128, 46), (226, 182, 80), (250, 226, 140)]
METAL = [(60, 64, 76), (100, 106, 120), (150, 156, 170), (210, 214, 224)]
CZERWIEN = [(90, 20, 30), (150, 34, 44), (200, 60, 64), (236, 120, 110)]
DREWNO = [(60, 36, 24), (96, 60, 36), (136, 90, 52), (176, 126, 76)]
CHLEB = [(120, 70, 30), (176, 112, 52), (220, 160, 86), (244, 206, 140)]
ZIELEN = [(30, 70, 40), (50, 110, 60), (90, 160, 80), (150, 210, 120)]
FIOLET = [(50, 30, 90), (90, 50, 160), (140, 90, 230), (200, 170, 255)]
NIEBIESKI = [(24, 40, 80), (40, 70, 130), (70, 120, 190), (150, 190, 240)]
BIEL = [(170, 174, 184), (210, 214, 222), (236, 238, 244), (255, 255, 255)]


def nowy(w=20, h=20):
    return Image.new("RGBA", (w, h), (0, 0, 0, 0))


def prost(d, x, y, w, h, k):
    d.rectangle((x, y, x + w - 1, y + h - 1), fill=k)


def kontur(img):
    """Ciemny kontur 1 px wokół wszystkiego, co nie jest przezroczyste."""
    w, h = img.size
    src = img.load()
    wynik = img.copy()
    dst = wynik.load()
    for y in range(h):
        for x in range(w):
            if src[x, y][3]:
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < w and 0 <= ny < h and src[nx, ny][3] and src[nx, ny] != O:
                    dst[x, y] = O
                    break
    return wynik


# ---------- PRZEDMIOTY FABULARNE ----------

def program():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 4, 2, 12, 16, CZERWIEN[1])
    prost(d, 5, 3, 10, 14, CZERWIEN[2])
    prost(d, 6, 5, 8, 1, ZLOTO[2])
    d.ellipse((7, 7, 12, 12), fill=PAPIER[2])  # maska teatralna
    prost(d, 8, 9, 1, 1, O); prost(d, 11, 9, 1, 1, O); prost(d, 9, 11, 2, 1, O)
    prost(d, 6, 14, 8, 1, ZLOTO[2])
    prost(d, 15, 3, 1, 15, CZERWIEN[0])  # grzbiet
    return img


def klucz():
    img = nowy(); d = ImageDraw.Draw(img)
    d.ellipse((2, 3, 9, 10), fill=ZLOTO[2])
    d.ellipse((4, 5, 7, 8), fill=(0, 0, 0, 0))
    prost(d, 8, 6, 9, 2, ZLOTO[2])
    prost(d, 14, 8, 2, 3, ZLOTO[2]); prost(d, 11, 8, 2, 2, ZLOTO[2])
    prost(d, 3, 4, 2, 1, ZLOTO[3]); prost(d, 9, 6, 7, 1, ZLOTO[3])
    prost(d, 6, 14, 6, 3, PAPIER[2])  # zawieszka
    prost(d, 7, 15, 4, 1, PAPIER[0])
    prost(d, 8, 11, 1, 3, PAPIER[1])
    return img


def latarka():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 2, 8, 11, 5, METAL[1])
    prost(d, 2, 8, 11, 1, METAL[3])
    prost(d, 12, 6, 4, 9, METAL[2])
    prost(d, 16, 7, 1, 7, (255, 240, 170))
    prost(d, 6, 11, 3, 1, CZERWIEN[2])  # włącznik
    for i, a in enumerate((140, 90, 50)):
        prost(d, 17 + i, 7 - i, 1, 7 + 2 * i, (255, 236, 150, a))
    return img


def ladowarka():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 3, 3, 7, 8, BIEL[2])
    prost(d, 3, 3, 7, 1, BIEL[3]); prost(d, 3, 10, 7, 1, BIEL[0])
    prost(d, 4, 1, 1, 2, METAL[2]); prost(d, 8, 1, 1, 2, METAL[2])
    d.line([(6, 11), (6, 14), (10, 16), (15, 15), (16, 12)], fill=BIEL[1], width=1)
    prost(d, 15, 10, 3, 3, BIEL[2])
    return img


def rekawiczki():
    img = nowy(); d = ImageDraw.Draw(img)
    k = [(120, 170, 200), (160, 210, 230), (200, 236, 246), (240, 252, 255)]
    prost(d, 5, 9, 8, 9, k[1])
    for i, x in enumerate((5, 7, 9, 11)):
        prost(d, x, 3 + (1 if i in (0, 3) else 0), 2, 7, k[1])
        prost(d, x, 3 + (1 if i in (0, 3) else 0), 1, 6, k[2])
    prost(d, 13, 9, 3, 2, k[1]); prost(d, 14, 7, 2, 3, k[1])  # kciuk
    prost(d, 5, 16, 8, 2, k[0])
    return img


def lampa_uv():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 4, 4, 12, 6, METAL[0])
    prost(d, 5, 5, 10, 4, FIOLET[3])
    prost(d, 6, 6, 8, 1, (255, 255, 255))
    prost(d, 8, 10, 4, 8, METAL[1])
    prost(d, 8, 10, 1, 8, METAL[2])
    prost(d, 9, 13, 2, 1, FIOLET[2])
    return img


def nozyczki():
    img = nowy(); d = ImageDraw.Draw(img)
    d.line([(4, 3), (13, 12)], fill=METAL[3], width=2)
    d.line([(15, 3), (6, 12)], fill=METAL[2], width=2)
    d.ellipse((2, 12, 8, 18), outline=CZERWIEN[2], width=2)
    d.ellipse((11, 12, 17, 18), outline=CZERWIEN[2], width=2)
    prost(d, 9, 7, 2, 2, ZLOTO[2])
    return img


def woreczek():
    img = nowy(); d = ImageDraw.Draw(img)
    k = (210, 230, 240, 200)
    prost(d, 3, 4, 14, 14, k)
    prost(d, 3, 4, 14, 2, CZERWIEN[2])  # zamknięcie strunowe
    prost(d, 5, 8, 10, 4, PAPIER[3])
    prost(d, 6, 9, 6, 1, O); prost(d, 6, 11, 4, 1, PAPIER[0])
    prost(d, 15, 7, 1, 9, (255, 255, 255, 220))
    return img


def paragon():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 5, 2, 10, 16, PAPIER[3])
    for x in range(5, 15, 2):
        prost(d, x, 17, 1, 1, (0, 0, 0, 0))  # ząbki na dole
    for y in (4, 6, 8, 10):
        prost(d, 6, y, 6 if y % 4 else 8, 1, PAPIER[0])
    prost(d, 6, 13, 8, 1, O)
    prost(d, 11, 14, 3, 1, O)
    return img


def grafik():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 3, 2, 14, 16, PAPIER[2])
    prost(d, 3, 2, 14, 3, NIEBIESKI[2])
    for r in range(3):
        for c in range(4):
            prost(d, 4 + c * 3, 7 + r * 3, 2, 2, PAPIER[1])
    prost(d, 13, 7, 2, 2, CZERWIEN[2])  # czwartek zakreślony
    prost(d, 13, 10, 2, 2, CZERWIEN[2])
    prost(d, 13, 13, 2, 2, CZERWIEN[2])
    prost(d, 9, 1, 2, 2, METAL[2])  # pinezka
    return img


def spinka():
    img = nowy(); d = ImageDraw.Draw(img)
    d.line([(3, 15), (16, 4)], fill=METAL[0], width=2)
    d.line([(5, 16), (17, 6)], fill=METAL[1], width=1)
    d.ellipse((12, 2, 18, 8), fill=CZERWIEN[2])  # ozdoba
    prost(d, 14, 3, 2, 2, CZERWIEN[3])
    return img


def pendrive():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 4, 7, 10, 7, (40, 40, 48))
    prost(d, 4, 7, 10, 1, (80, 80, 96))
    prost(d, 14, 8, 4, 5, METAL[3])
    prost(d, 15, 9, 1, 1, METAL[0]); prost(d, 15, 11, 1, 1, METAL[0])
    prost(d, 6, 10, 2, 1, CZERWIEN[2])  # dioda
    prost(d, 2, 9, 2, 3, PAPIER[2])  # smycz
    return img


# ---------- ZWYKŁE PRZEDMIOTY ----------

def bulka():
    img = nowy(); d = ImageDraw.Draw(img)
    d.ellipse((2, 6, 17, 16), fill=CHLEB[2])
    d.ellipse((3, 6, 16, 12), fill=CHLEB[3])
    d.line([(7, 8), (9, 13)], fill=CHLEB[1]); d.line([(11, 8), (13, 13)], fill=CHLEB[1])
    for x, y in ((6, 9), (12, 8), (14, 11)):
        prost(d, x, y, 1, 1, PAPIER[3])  # cukier
    return img


def kanapka():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 2, 11, 16, 4, CHLEB[2])
    prost(d, 2, 9, 16, 2, ZIELEN[2])  # sałata
    prost(d, 3, 8, 14, 1, CZERWIEN[2])  # pomidor
    prost(d, 2, 5, 16, 3, CHLEB[3])
    prost(d, 2, 5, 16, 1, CHLEB[1])
    prost(d, 4, 10, 2, 1, (240, 200, 90))
    return img


def paczek():
    img = nowy(); d = ImageDraw.Draw(img)
    d.ellipse((3, 5, 16, 16), fill=CHLEB[2])
    d.ellipse((4, 5, 15, 11), fill=(240, 236, 228))  # lukier
    for x, y in ((6, 7), (10, 6), (12, 8), (8, 9)):
        prost(d, x, y, 1, 1, CZERWIEN[2])  # skórka pomarańczowa
    prost(d, 9, 13, 2, 1, CHLEB[1])
    return img


def kawa():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 5, 6, 10, 11, BIEL[3])
    prost(d, 5, 6, 10, 1, BIEL[1])
    prost(d, 6, 7, 8, 2, (90, 54, 30))
    d.ellipse((14, 9, 18, 14), outline=BIEL[2], width=1)
    prost(d, 5, 16, 10, 1, BIEL[0])
    for x in (7, 11):
        prost(d, x, 2 + (x % 3), 1, 3, (220, 220, 230, 140))  # para
    return img


def herbata():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 6, 3, 8, 15, (60, 90, 70))  # termos
    prost(d, 6, 3, 8, 3, METAL[2])
    prost(d, 6, 3, 2, 15, (90, 130, 100))
    prost(d, 6, 3, 2, 3, METAL[3])
    prost(d, 8, 9, 4, 3, PAPIER[2])  # naklejka
    prost(d, 14, 8, 2, 6, (60, 90, 70))
    return img


def tabletki():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 3, 5, 14, 10, BIEL[2])
    prost(d, 3, 5, 14, 1, BIEL[3])
    for r in range(2):
        for c in range(4):
            d.ellipse((4 + c * 3, 7 + r * 4, 6 + c * 3, 9 + r * 4), fill=CZERWIEN[3])
    prost(d, 3, 14, 14, 1, BIEL[0])
    return img


def papierosy():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 5, 5, 10, 13, CZERWIEN[1])
    prost(d, 5, 5, 10, 4, BIEL[2])
    prost(d, 6, 2, 2, 4, BIEL[3]); prost(d, 6, 2, 2, 1, (230, 140, 60))
    prost(d, 9, 3, 2, 3, BIEL[3]); prost(d, 9, 3, 2, 1, (230, 140, 60))
    prost(d, 7, 11, 6, 3, ZLOTO[2])
    prost(d, 5, 5, 1, 13, CZERWIEN[2])
    return img


def monety():
    img = nowy(); d = ImageDraw.Draw(img)
    for x, y, k in ((2, 9, METAL), (8, 10, ZLOTO), (6, 5, METAL), (11, 4, ZLOTO)):
        d.ellipse((x, y, x + 7, y + 6), fill=k[1])
        d.ellipse((x, y, x + 7, y + 5), fill=k[2])
        prost(d, x + 2, y + 1, 2, 1, k[3])
    return img


def bilet():
    img = nowy(); d = ImageDraw.Draw(img)
    d.polygon([(2, 7), (17, 4), (18, 12), (3, 15)], fill=PAPIER[2])
    d.line([(7, 6), (8, 14)], fill=PAPIER[0])  # perforacja
    prost(d, 10, 7, 6, 1, CZERWIEN[2])
    prost(d, 10, 9, 5, 1, PAPIER[1])
    prost(d, 10, 11, 4, 1, PAPIER[1])
    prost(d, 4, 9, 2, 3, ZLOTO[2])
    return img


def numerek():
    img = nowy(); d = ImageDraw.Draw(img)
    d.ellipse((4, 2, 15, 17), fill=ZLOTO[2])
    d.ellipse((5, 3, 14, 16), fill=ZLOTO[3])
    d.ellipse((8, 4, 11, 7), fill=(0, 0, 0, 0))
    d.ellipse((8, 4, 11, 7), outline=ZLOTO[0])
    prost(d, 7, 10, 2, 4, O)  # 47
    prost(d, 7, 11, 3, 1, O)
    prost(d, 11, 10, 2, 1, O)
    prost(d, 12, 11, 1, 3, O)
    return img


def noz():
    img = nowy(); d = ImageDraw.Draw(img)
    d.polygon([(4, 16), (13, 5), (15, 4), (15, 7), (6, 17)], fill=METAL[2])
    d.line([(5, 15), (13, 6)], fill=METAL[3])
    prost(d, 3, 15, 4, 3, DREWNO[1])
    d.line([(2, 13), (7, 18)], fill=ZLOTO[2], width=2)  # jelec
    return img


def telefon_adriana():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 6, 2, 9, 16, (24, 24, 30))
    prost(d, 7, 4, 7, 10, (30, 40, 56))
    d.line([(8, 5), (13, 12)], fill=(90, 100, 120))  # pęknięta szybka
    d.line([(12, 5), (9, 9)], fill=(90, 100, 120))
    prost(d, 9, 15, 3, 1, METAL[1])
    return img


def lista_rekwizytow():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 4, 2, 12, 16, PAPIER[2])
    for y in (5, 8, 11):
        prost(d, 6, y, 8, 1, PAPIER[0])
    d.line([(6, 14), (9, 15), (12, 13), (14, 15)], fill=CZERWIEN[1])  # dopisek krzywym pismem
    prost(d, 4, 2, 12, 1, PAPIER[3])
    return img


def zdjecie_pasy():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 3, 3, 14, 14, BIEL[2])
    prost(d, 4, 4, 12, 10, (200, 168, 150))
    for y in (6, 9):
        prost(d, 5, y, 10, 1, CZERWIEN[2])
    prost(d, 3, 16, 14, 1, BIEL[0])
    return img


def termos():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 7, 4, 7, 13, CZERWIEN[2])
    for y in (6, 10, 14):
        prost(d, 7, y, 7, 1, CZERWIEN[0])
    prost(d, 9, 4, 1, 13, CZERWIEN[3])
    prost(d, 6, 1, 9, 3, METAL[2])
    prost(d, 7, 1, 7, 1, METAL[3])
    return img


def kwit_odbioru():
    img = nowy(); d = ImageDraw.Draw(img)
    prost(d, 5, 3, 10, 14, PAPIER[2])
    prost(d, 5, 3, 10, 3, (60, 90, 140))
    for y in (8, 11, 14):
        prost(d, 7, y, 6, 1, PAPIER[0])
    for x in range(5, 15, 2):
        prost(d, x, 17, 1, 1, PAPIER[2])  # perforacja
    return img


def kielich():
    img = nowy(); d = ImageDraw.Draw(img)
    d.polygon([(5, 3), (15, 3), (13, 9), (7, 9)], fill=ZLOTO[2])
    prost(d, 6, 3, 8, 1, ZLOTO[3])
    prost(d, 9, 9, 2, 5, ZLOTO[1])
    prost(d, 6, 14, 8, 2, ZLOTO[1])
    prost(d, 7, 14, 4, 1, ZLOTO[2])
    return img


IKONY = {
    "program": program, "klucz": klucz, "latarka": latarka, "ladowarka": ladowarka,
    "rekawiczki": rekawiczki, "lampa_uv": lampa_uv, "nozyczki": nozyczki,
    "woreczek": woreczek, "paragon": paragon, "grafik": grafik, "spinka": spinka,
    "pendrive": pendrive, "bulka": bulka, "kanapka": kanapka, "paczek": paczek,
    "kawa": kawa, "herbata": herbata, "tabletki": tabletki, "papierosy": papierosy,
    "monety": monety, "bilet": bilet, "numerek": numerek, "noz": noz,
    "telefon_adriana": telefon_adriana, "lista_rekwizytow": lista_rekwizytow, "zdjecie_pasy": zdjecie_pasy,
    "kielich": kielich, "termos": termos, "kwit_odbioru": kwit_odbioru,
}


# ---------- REKWIZYTY NA MAPY (skrzynki do przeszukania) ----------

def stojak_programy():
    """Stojak z programami premiery (foyer)."""
    img = nowy(28, 44); d = ImageDraw.Draw(img)
    prost(d, 12, 20, 4, 22, DREWNO[2])
    prost(d, 6, 40, 16, 3, DREWNO[1])
    prost(d, 2, 4, 24, 18, DREWNO[1])
    prost(d, 3, 5, 22, 16, DREWNO[2])
    for i, x in enumerate((4, 11, 18)):
        prost(d, x, 3 + i % 2, 6, 10, CZERWIEN[2] if i != 1 else CZERWIEN[1])
        prost(d, x + 1, 6 + i % 2, 4, 1, ZLOTO[2])
    prost(d, 3, 15, 22, 2, DREWNO[3])
    return kontur(img)


def bezpieczniki():
    """Skrzynka z bezpiecznikami na ścianie (kulisy)."""
    img = nowy(20, 26); d = ImageDraw.Draw(img)
    prost(d, 1, 1, 18, 24, METAL[1])
    prost(d, 1, 1, 18, 1, METAL[3])
    prost(d, 3, 4, 14, 18, METAL[0])
    for r in range(3):
        prost(d, 5, 6 + r * 5, 10, 3, METAL[2])
        prost(d, 6 + r * 2, 7 + r * 5, 2, 1, CZERWIEN[2])
    d.polygon([(10, 1), (13, 1), (9, 6), (12, 6), (8, 11)], fill=(240, 200, 60))  # piorun
    return kontur(img)


def apteczka():
    """Biała apteczka z czerwonym krzyżem (na ścianie przy bufecie)."""
    img = nowy(16, 14); d = ImageDraw.Draw(img)
    prost(d, 1, 1, 14, 12, BIEL[2])
    prost(d, 1, 1, 14, 1, BIEL[3])
    prost(d, 1, 12, 14, 1, BIEL[0])
    prost(d, 7, 3, 2, 8, CZERWIEN[2])
    prost(d, 4, 6, 8, 2, CZERWIEN[2])
    return kontur(img)


def noz_maly():
    """Rekwizytowy nóż leżący na toaletce Ani (garderoba)."""
    img = nowy(14, 6); d = ImageDraw.Draw(img)
    d.polygon([(1, 3), (9, 1), (12, 2), (9, 4)], fill=METAL[3])
    prost(d, 9, 1, 2, 4, ZLOTO[2])
    prost(d, 11, 2, 3, 2, DREWNO[1])
    return kontur(img)


def koszula_stol():
    """Zmięta koszula Adriana rzucona przez Irenę na stół bankietowy."""
    img = nowy(22, 10); d = ImageDraw.Draw(img)
    d.polygon([(1, 6), (5, 2), (12, 1), (20, 3), (21, 8), (14, 9), (3, 9)], fill=BIEL[1])
    d.line([(5, 4), (12, 6), (18, 4)], fill=BIEL[0])
    d.ellipse((9, 3, 14, 7), fill=(160, 158, 104))
    prost(d, 15, 6, 4, 2, PAPIER[1])  # rękawiczki
    return kontur(img)


def kosz_wiklinowy():
    """Wiklinowy kosz na pranie, który Irena przynosi na bankiet."""
    img = nowy(20, 16); d = ImageDraw.Draw(img)
    d.polygon([(1, 5), (19, 5), (17, 15), (3, 15)], fill=CHLEB[1])
    for y in (7, 10, 13):
        prost(d, 3, y, 15, 1, CHLEB[0])
    for x in (5, 9, 13):
        prost(d, x, 6, 1, 9, CHLEB[2])
    d.arc((5, 0, 15, 10), 180, 360, fill=CHLEB[0])
    prost(d, 4, 3, 10, 3, BIEL[1])  # wystający rękaw
    return kontur(img)


def taca_kieliszki():
    """Kieliszki i butelka na stole przy bufecie (bankiet)."""
    img = nowy(20, 14); d = ImageDraw.Draw(img)
    for x in (2, 7, 12):
        prost(d, x, 3, 3, 5, (230, 200, 110))
        prost(d, x + 1, 8, 1, 4, BIEL[1])
        prost(d, x, 12, 3, 1, BIEL[1])
    prost(d, 16, 1, 3, 12, ZIELEN[0])
    prost(d, 16, 0, 3, 2, ZLOTO[2])
    return kontur(img)


def gramofon():
    """Gramofon z tubą (bankiet, gra walca)."""
    img = nowy(22, 26); d = ImageDraw.Draw(img)
    prost(d, 2, 16, 18, 9, DREWNO[2])
    prost(d, 2, 16, 18, 2, DREWNO[3])
    d.ellipse((4, 13, 18, 18), fill=(20, 18, 22))
    d.polygon([(10, 14), (8, 6), (4, 1), (20, 0), (14, 6), (12, 14)], fill=ZLOTO[2])
    d.ellipse((4, 0, 20, 5), fill=ZLOTO[3])
    d.ellipse((7, 1, 17, 4), fill=ZLOTO[0])
    return kontur(img)


def plama_wina():
    """Plama rozlanego wina na marmurze (antrakt)."""
    img = nowy(18, 8); d = ImageDraw.Draw(img)
    d.ellipse((0, 1, 12, 7), fill=(110, 20, 36, 200))
    d.ellipse((9, 3, 17, 7), fill=(110, 20, 36, 200))
    prost(d, 3, 2, 3, 1, (170, 50, 66, 220))
    return img


def szczur():
    """Szczur przebiegający między skrzyniami w magazynie (biegnie w prawo)."""
    img = nowy(14, 6); d = ImageDraw.Draw(img)
    d.ellipse((3, 1, 11, 6), fill=(60, 52, 50))
    d.ellipse((9, 1, 13, 5), fill=(70, 62, 58))
    prost(d, 12, 2, 1, 1, (10, 8, 8))
    prost(d, 11, 0, 2, 2, (110, 90, 90))  # ucho
    d.line([(0, 2), (3, 4)], fill=(120, 96, 96))  # ogon
    return kontur(img)


def zdjecie_zalobne():
    """Zdjęcie Adriana z czarną wstążką na stoliku, świeczka, kwiaty i kartki kondolencyjne."""
    img = nowy(44, 46); d = ImageDraw.Draw(img)
    prost(d, 2, 30, 40, 6, DREWNO[2])
    prost(d, 2, 36, 40, 8, DREWNO[0])
    prost(d, 14, 4, 16, 22, ZLOTO[1])
    d.rectangle((14, 4, 14+16-1, 4+22-1), outline=O)
    prost(d, 16, 6, 12, 18, (120, 116, 110))
    d.ellipse((18, 8, 26, 16), fill=(196, 170, 150))
    prost(d, 18, 16, 8, 8, (60, 60, 70))
    prost(d, 6, 0, 2, 1, O)
    d.line([(14, 4), (20, 12)], fill=(10, 10, 12), width=2)  # czarna wstążka przez róg
    prost(d, 34, 22, 3, 8, PAPIER[2])  # świeczka
    prost(d, 35, 19, 1, 3, (255, 210, 110))
    for fx, kol in ((6, CZERWIEN[2]), (9, (240, 240, 230)), (4, CZERWIEN[3])):
        d.ellipse((fx, 22, fx + 5, 27), fill=kol, outline=O)
    prost(d, 8, 27, 1, 4, ZIELEN[1])
    for kx in (12, 24):
        prost(d, kx, 32, 8, 5, PAPIER[2])  # kartki
        d.rectangle((kx, 32, kx + 7, 36), outline=PAPIER[0])
    return img


def wstazka_czarna():
    img = nowy(14, 18); d = ImageDraw.Draw(img)
    d.polygon([(7, 6), (2, 17), (5, 17), (7, 10), (9, 17), (12, 17)], fill=(14, 14, 18), outline=O)
    d.ellipse((3, 1, 11, 8), fill=(20, 20, 24), outline=O)
    return img


def kielich_podloga():
    """Czwarty kielich leżący na boku pod skrzynią w magazynie."""
    img = nowy(10, 5); d = ImageDraw.Draw(img)
    d.polygon([(0, 0), (5, 1), (5, 4), (0, 5)], fill=ZLOTO[2])
    prost(d, 5, 2, 3, 1, ZLOTO[1])
    prost(d, 8, 0, 2, 5, ZLOTO[1])
    prost(d, 1, 1, 2, 1, ZLOTO[3])
    return img


def telefon_podloga():
    """Telefon Adriana leżący ekranem w dół pod manekinem."""
    img = nowy(8, 5); d = ImageDraw.Draw(img)
    prost(d, 0, 0, 8, 5, (24, 24, 30))
    prost(d, 1, 1, 2, 1, METAL[1])
    return kontur(img)


REKWIZYTY = {"stojak_programy": stojak_programy, "bezpieczniki": bezpieczniki, "apteczka": apteczka,
             "noz_maly": noz_maly, "koszula_stol": koszula_stol, "kosz_wiklinowy": kosz_wiklinowy,
             "taca_kieliszki": taca_kieliszki, "gramofon": gramofon, "plama_wina": plama_wina,
             "szczur": szczur, "telefon_podloga": telefon_podloga,
             "kielich_podloga": kielich_podloga, "zdjecie_zalobne": zdjecie_zalobne,
             "wstazka_czarna": wstazka_czarna}


def main():
    os.makedirs("ui/przedmioty", exist_ok=True)
    os.makedirs("rekwizyty", exist_ok=True)
    ikony = {}
    for nazwa, f in IKONY.items():
        ikony[nazwa] = kontur(f())
        ikony[nazwa].save(f"ui/przedmioty/{nazwa}.png")
    for nazwa, f in REKWIZYTY.items():
        f().save(f"rekwizyty/{nazwa}.png")
    if len(sys.argv) > 1:
        # podgląd wszystkich ikonek x4 w siatce
        kol = 10
        pod = Image.new("RGBA", (kol * 24, ((len(ikony) + kol - 1) // kol) * 24), (30, 22, 26, 255))
        for i, im in enumerate(ikony.values()):
            pod.alpha_composite(im, ((i % kol) * 24 + 2, (i // kol) * 24 + 2))
        pod.resize((pod.width * 4, pod.height * 4), Image.NEAREST).save(os.path.join(sys.argv[1], "przedmioty.png"))


if __name__ == "__main__":
    main()
