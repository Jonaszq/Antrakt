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


def main():
    folder = Path("ui")
    folder.mkdir(exist_ok=True)
    for nazwa, rysuj in (("ramka", ramka_dialogu), ("imie", ramka_imienia), ("kartka", kartka_notesu),
                         ("strzalka", strzalka), ("klawisz", klawisz)):
        rysuj().save(folder / f"{nazwa}.png")


if __name__ == "__main__":
    main()
