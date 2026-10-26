"""Czarna sylwetka do retrospekcji: jedna, taka sama dla każdego nieznanego, bez
obrysu i bez szczegółów (fryzury, sukienki), żeby nie zdradzała, kto to jest.
Dwie klatki (oddech). Zapisuje postacie/sylwetka/sylwetka.png (80x68)."""
from PIL import Image, ImageDraw

CZARNY = (6, 6, 9, 255)


def klatka(d: ImageDraw.ImageDraw, x0: int, wdech: int) -> None:
    y = -wdech
    d.ellipse((x0 + 14, 5 + y, x0 + 25, 17 + y), fill=CZARNY)          # głowa
    d.rectangle((x0 + 17, 16 + y, x0 + 22, 21 + y), fill=CZARNY)       # szyja
    # płaszcz do kolan: ramiona i lekko rozszerzony dół, jednakowy dla wszystkich
    d.polygon([(x0 + 9, 23 + y), (x0 + 13, 20 + y), (x0 + 26, 20 + y), (x0 + 30, 23 + y),
               (x0 + 31, 56), (x0 + 8, 56)], fill=CZARNY)
    d.rectangle((x0 + 13, 56, x0 + 18, 65), fill=CZARNY)               # nogi
    d.rectangle((x0 + 21, 56, x0 + 26, 65), fill=CZARNY)
    d.rectangle((x0 + 12, 64, x0 + 18, 66), fill=CZARNY)               # buty
    d.rectangle((x0 + 21, 64, x0 + 27, 66), fill=CZARNY)


im = Image.new("RGBA", (80, 68), (0, 0, 0, 0))
d = ImageDraw.Draw(im)
klatka(d, 0, 0)
klatka(d, 40, 1)
im.save("postacie/sylwetka/sylwetka.png")
