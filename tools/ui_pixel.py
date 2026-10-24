"""Rysuje elementy interfejsu w pixel arcie: ramki okienek dialogu i notesu.

Użycie: python3 tools/ui_pixel.py

Ramki są kafelkami 9-patch (NinePatchRect w Godocie, marginesy 6 px), więc
rozciągają się do dowolnego rozmiaru bez rozmycia. Wynik trafia do ui/.
"""
from pathlib import Path

from PIL import Image, ImageDraw

from mapa_pracownia import DREWNO_C, O, PAPIER, ZLOTO, nowy, obrys, prost


def ramka_dialogu():
    """Ciemne drewno ze złotą listwą, jak boazeria w foyer."""
    img = nowy(24, 24)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, 24, 24, O)
    prost(d, 1, 1, 22, 22, ZLOTO[1])
    prost(d, 1, 1, 22, 1, ZLOTO[3])
    prost(d, 2, 2, 20, 20, DREWNO_C[0])
    prost(d, 3, 3, 18, 18, (18, 12, 14))
    for x in (2, 21):
        for y in (2, 21):
            d.point((x, y), fill=ZLOTO[2])
    return img


def ramka_imienia():
    img = nowy(16, 16)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, 16, 16, O)
    prost(d, 1, 1, 14, 14, ZLOTO[2])
    prost(d, 2, 2, 12, 12, (52, 14, 22))
    prost(d, 2, 2, 12, 1, (90, 28, 36))
    return img


def kartka_notesu():
    """Kartka w kratkę z czerwonym marginesem i grzbietem."""
    img = nowy(24, 24)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, 24, 24, O)
    prost(d, 1, 1, 22, 22, PAPIER[2])
    prost(d, 1, 21, 22, 2, PAPIER[1])
    prost(d, 1, 1, 22, 2, (60, 40, 32))  # grzbiet
    obrys(d, 0, 0, 24, 24)
    return img


def strzalka():
    img = nowy(7, 4)
    d = ImageDraw.Draw(img)
    d.polygon([(0, 0), (6, 0), (3, 3)], fill=ZLOTO[3])
    return img


def klawisz():
    """Tło podpowiedzi klawisza (np. "E"), 9-patch z marginesem 4."""
    img = nowy(12, 12)
    d = ImageDraw.Draw(img)
    prost(d, 0, 0, 12, 12, O)
    prost(d, 1, 1, 10, 9, PAPIER[2])
    prost(d, 1, 10, 10, 1, PAPIER[0])
    return img


def telefon():
    """Obudowa telefonu 170x252; ekran 150x214 zaczyna się w (10, 22)."""
    img = nowy(170, 252)
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((0, 0, 169, 251), radius=12, fill=(14, 14, 18), outline=O)
    d.rounded_rectangle((2, 2, 167, 249), radius=11, outline=(48, 48, 58))
    prost(d, 10, 22, 150, 214, (8, 10, 18))
    prost(d, 72, 10, 26, 3, (40, 40, 48))  # głośnik
    d.ellipse((104, 8, 109, 13), fill=(30, 30, 40))  # aparat
    prost(d, 66, 241, 38, 3, (60, 60, 70))  # pasek domu
    return img


def ikona(rodzaj):
    """Ikony aplikacji 28x28."""
    kolory = {"telefon": (60, 170, 90), "wiadomosci": (70, 120, 210), "pogoda": (230, 160, 50),
              "muzyka": (200, 70, 110)}
    img = nowy(28, 28)
    d = ImageDraw.Draw(img)
    k = kolory[rodzaj]
    d.rounded_rectangle((0, 0, 27, 27), radius=6, fill=k, outline=O)
    prost(d, 3, 2, 22, 2, tuple(min(255, c + 50) for c in k))
    b = (250, 250, 250)
    if rodzaj == "telefon":
        d.arc((6, 6, 22, 22), 100, 260, fill=b, width=4)
        prost(d, 9, 5, 5, 4, b)
        prost(d, 9, 19, 5, 4, b)
    elif rodzaj == "wiadomosci":
        d.rounded_rectangle((5, 6, 22, 18), radius=4, fill=b)
        d.polygon([(8, 17), (8, 23), (13, 17)], fill=b)
        for x in (9, 13, 17):
            prost(d, x, 11, 2, 2, k)
    elif rodzaj == "pogoda":
        d.ellipse((5, 5, 15, 15), fill=(255, 236, 120))
        d.ellipse((9, 12, 23, 22), fill=b)
        d.ellipse((6, 15, 14, 22), fill=b)
        for x in (10, 15, 20):
            prost(d, x, 23, 1, 2, (120, 170, 255))
    else:
        prost(d, 17, 5, 2, 14, b)
        prost(d, 17, 5, 6, 3, b)
        d.ellipse((10, 15, 18, 22), fill=b)
    return img


def main():
    folder = Path("ui")
    folder.mkdir(exist_ok=True)
    for nazwa, rysuj in (("ramka", ramka_dialogu), ("imie", ramka_imienia), ("kartka", kartka_notesu),
                         ("strzalka", strzalka), ("klawisz", klawisz), ("telefon", telefon)):
        rysuj().save(folder / f"{nazwa}.png")
    for rodzaj in ("telefon", "wiadomosci", "pogoda", "muzyka"):
        ikona(rodzaj).save(folder / f"ikona_{rodzaj}.png")


if __name__ == "__main__":
    main()
