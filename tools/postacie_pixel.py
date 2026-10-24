"""Rysuje postacie niezależne (NPC) w pixel arcie tą samą metodą co Antoniego.

Użycie: python3 tools/postacie_pixel.py

Każda postać to funkcja, która układa kształty w materiałach na płótnie 40x68
(stopy w wierszu 65, jak u Antoniego). Na razie każdy ma animację "stoi_dol":
6 klatek oddechu z mrugnięciem. Wynik trafia do postacie/<imie>/: arkusz
<imie>_arkusz.png, scena <imie>.tscn (StaticBody2D z kolizją stóp) i podgląd.
"""
import math
from pathlib import Path

from PIL import Image

import antoni_pixel as ap

SRODEK, ZIEMIA = ap.SRODEK, ap.ZIEMIA
KLATKI = 6

SKORA_JASNA = [(110, 66, 58), (170, 116, 92), (220, 168, 134), (244, 206, 172)]
SKORA_STARSZA = [(102, 62, 54), (160, 110, 88), (206, 158, 128), (232, 194, 164)]


def material(nazwa, rampa):
    """Dopisuje rampę do wspólnej listy materiałów generatora Antoniego."""
    if nazwa not in ap.RAMPY:
        ap.RAMPY[nazwa] = rampa
        ap.NAZWY.append(nazwa)
    return nazwa


# ---------- wspólne części ----------

def oddech_mrug(faza):
    b = -1 if 0.25 <= faza < 0.75 else 0
    mrug = 4 / KLATKI <= faza < 5 / KLATKI
    return b, mrug


def twarz(p, cx, y, skora, mrug, oczy="oczy", usta=None, brwi=None, zarost=None, okulary=None, szer=5):
    """Twarz od przodu: (cx, y) to środek czoła. Głowa ma ok. 12 px wysokości."""
    p.elipsa(cx - szer, y - 2, cx + szer, y + 10, skora)
    p.prost(cx - szer + 1, y + 2, cx + szer - 1, y + 5, skora, 2)
    if zarost:
        p.prost(cx - szer + 1, y + 6, cx + szer - 1, y + 9, zarost, 1)
    if brwi:
        p.prost(cx - 3, y + 2, cx - 2, y + 2, brwi, 0)
        p.prost(cx + 2, y + 2, cx + 3, y + 2, brwi, 0)
    if mrug:
        p.prost(cx - 3, y + 4, cx - 2, y + 4, skora, 0)
        p.prost(cx + 2, y + 4, cx + 3, y + 4, skora, 0)
    else:
        p.prost(cx - 3, y + 3, cx - 2, y + 3, oczy, 0)
        p.prost(cx + 2, y + 3, cx + 3, y + 3, oczy, 0)
    if okulary:
        for ox in (cx - 4, cx + 1):
            p.prost(ox, y + 2, ox + 3, y + 2, okulary, 0)
            p.prost(ox, y + 5, ox + 3, y + 5, okulary, 0)
            p.prost(ox, y + 2, ox, y + 5, okulary, 0)
            p.prost(ox + 3, y + 2, ox + 3, y + 5, okulary, 0)
        p.piksel(cx, y + 3, okulary, 0)
    p.prost(cx, y + 4, cx, y + 5, skora, 3)
    p.piksel(cx, y + 6, skora, 1)
    if usta:
        p.prost(cx - 1, y + 8, cx + 1, y + 8, usta[0], usta[1])


def rece(p, b, kolor, skora, y0, dl, rozstaw=10, odcien=1):
    """Ręce wzdłuż tułowia, zwraca pozycje dłoni (lewa, prawa)."""
    dlonie = []
    for strona in (-1, 1):
        x = SRODEK + strona * rozstaw
        p.wielokat([(x - 2, y0 + b), (x + 2, y0 + b), (x + strona * 2 + 2, y0 + dl + b),
                    (x + strona * 2 - 2, y0 + dl + b)], kolor, odcien)
        dx = x + strona * 2
        p.prost(dx - 1, y0 + dl + 1 + b, dx + 1, y0 + dl + 3 + b, skora)
        dlonie.append((dx, y0 + dl + 2 + b))
    return dlonie


def nogi(p, y0, kolor, buty, rozstaw=4, szer=4):
    for x0 in (SRODEK - rozstaw - szer // 2, SRODEK + rozstaw - szer // 2):
        p.prost(x0, y0, x0 + szer - 1, ZIEMIA - 3, kolor)
        p.prost(x0 - 1, ZIEMIA - 2, x0 + szer - 1, ZIEMIA, buty)


# ---------- postacie ----------

def ania(faza):
    """Ania Wrzos, 26 lat, aktorka. Długie kasztanowe włosy, zielony płaszczyk, kremowy szal."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    wl = material("ania_wlosy", [(40, 14, 12), (74, 28, 20), (112, 48, 30), (150, 72, 42)])
    pl = material("ania_plaszcz", [(18, 34, 28), (28, 54, 42), (42, 78, 58), (62, 104, 76), (88, 132, 98)])
    sz = material("ania_szal", [(150, 132, 108), (196, 180, 150), (228, 218, 192)])
    rajst = material("ania_rajstopy", [(14, 12, 16), (26, 22, 28), (40, 34, 42)])
    buty = material("ania_buty", [(16, 10, 10), (34, 20, 18), (56, 34, 28)])
    skora = material("skora_jasna", SKORA_JASNA)
    usta = material("usta_czerwone", [(110, 28, 36), (150, 40, 46)])
    nogi(p, 46, rajst, buty, rozstaw=3, szer=3)
    # włosy za plecami
    p.wielokat([(13, 12 + b), (27, 12 + b), (28, 32 + b), (12, 32 + b)], wl, 1)
    rece(p, b, pl, skora, 21, 15, rozstaw=8)
    # płaszczyk taliowany z rozkloszowanym dołem
    p.wielokat([(13, 20 + b), (27, 20 + b), (25, 33 + b), (29, 48), (11, 48), (15, 33 + b)], pl)
    p.prost(15, 32 + b, 25, 33 + b, pl, 1)  # pasek
    p.piksel(20, 32 + b, "mosiadz", 2)
    p.linia([(20, 34 + b), (20, 47)], pl, 1)
    for gy in (25, 29):
        p.piksel(18, gy + b, "mosiadz", 2)
        p.piksel(22, gy + b, "mosiadz", 2)
    # szal
    p.elipsa(14, 17 + b, 26, 23 + b, sz)
    p.wielokat([(22, 21 + b), (25, 21 + b), (25, 31 + b), (22, 30 + b)], sz, 1)
    p.prost(17, 16 + b, 23, 18 + b, skora, 1)  # szyja
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 1), brwi=wl, szer=5)
    # grzywka i przedziałek
    p.elipsa(14, 2 + b, 26, 9 + b, wl)
    p.wielokat([(15, 7 + b), (19, 6 + b), (16, 9 + b), (15, 13 + b)], wl, 2)
    p.wielokat([(25, 7 + b), (21, 6 + b), (24, 9 + b), (25, 14 + b)], wl, 2)
    p.prost(13, 9 + b, 14, 22 + b, wl, 1)
    p.prost(26, 9 + b, 27, 22 + b, wl, 1)
    return ap.pokoloruj(p, None)


def wolski(faza):
    """Adam Wolski, 55 lat, gwiazdor. Siwe zaczesane włosy, bródka, bordowa aksamitna bonżurka."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    wl = material("wolski_wlosy", [(96, 92, 94), (146, 142, 140), (192, 188, 182), (228, 224, 216)])
    ak = material("wolski_aksamit", [(44, 10, 20), (72, 18, 30), (104, 30, 42), (138, 46, 54), (168, 70, 70)])
    zl = material("wolski_zloto", [(110, 76, 28), (170, 126, 50), (226, 186, 92)])
    fular = material("wolski_fular", [(120, 92, 30), (176, 140, 54), (220, 190, 96)])
    sp = material("wolski_spodnie", [(16, 16, 20), (28, 28, 34), (44, 44, 52)])
    buty = material("wolski_buty", [(10, 8, 8), (28, 22, 20), (70, 60, 56)])
    skora = material("skora_starsza", SKORA_STARSZA)
    usta = material("usta_meskie", [(120, 70, 60), (150, 92, 78)])
    nogi(p, 48, sp, buty, rozstaw=4, szer=5)
    rece(p, b, ak, skora, 20, 16, rozstaw=11)
    # bonżurka
    p.wielokat([(10, 19 + b), (30, 19 + b), (31, 36 + b), (30, 50), (10, 50), (9, 36 + b)], ak)
    p.elipsa(9, 17 + b, 31, 23 + b, ak)
    p.wielokat([(13, 18 + b), (18, 19 + b), (19, 34 + b), (15, 26 + b)], zl, 1)  # szalowe klapy
    p.wielokat([(27, 18 + b), (22, 19 + b), (21, 34 + b), (25, 26 + b)], zl, 1)
    p.wielokat([(18, 19 + b), (22, 19 + b), (20, 30 + b)], "koszula")
    p.wielokat([(18, 19 + b), (22, 19 + b), (21, 24 + b), (19, 24 + b)], fular)
    p.piksel(20, 21 + b, fular, 2)
    p.prost(10, 35 + b, 30, 35 + b, zl, 0)  # pasek bonżurki
    p.prost(18, 34 + b, 22, 36 + b, zl, 1)  # węzeł paska
    p.linia([(20, 31 + b), (20, 49)], ak, 1)
    p.linia([(13, 38 + b), (12, 49)], ak, 1)
    p.linia([(27, 38 + b), (28, 49)], ak, 1)
    p.prost(26, 27 + b, 28, 28 + b, "koszula", 2)  # chusteczka w kieszonce
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 1), brwi=wl, zarost=wl, szer=5)
    p.prost(18, 16 + b, 22, 18 + b, wl, 1)  # bródka
    p.prost(19, 15 + b, 21, 15 + b, usta, 1)  # uśmiech
    # zaczesane do tyłu włosy
    p.elipsa(14, 2 + b, 26, 10 + b, wl)
    p.prost(15, 4 + b, 25, 5 + b, wl, 3)
    p.prost(14, 7 + b, 14, 12 + b, wl, 1)
    p.prost(26, 7 + b, 26, 12 + b, wl, 1)
    return ap.pokoloruj(p, None)


def irena(faza):
    """Irena Mróz, kostiumolożka. Siwy kok, okulary, centymetr na szyi, fartuch ze szpilkami."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    b += 2  # niższa
    wl = material("irena_wlosy", [(92, 88, 92), (136, 132, 134), (178, 174, 172), (214, 210, 204)])
    sw = material("irena_sweter", [(18, 44, 50), (28, 66, 72), (42, 92, 96), (62, 120, 120)])
    fa = material("irena_fartuch", [(98, 84, 70), (140, 124, 104), (182, 168, 146)])
    sp = material("irena_spodnica", [(24, 20, 30), (38, 32, 46), (56, 48, 66)])
    cm = material("irena_centymetr", [(170, 136, 40), (226, 196, 80)])
    buty = material("irena_buty", [(18, 12, 12), (40, 26, 22), (64, 42, 34)])
    skora = material("skora_starsza", SKORA_STARSZA)
    okul = material("okulary", [(30, 24, 22)])
    usta = material("usta_meskie", [(120, 70, 60), (150, 92, 78)])
    nogi(p, 52, sp, buty, rozstaw=3, szer=4)
    rece(p, b, sw, skora, 21, 15, rozstaw=11)
    # sweter i długa spódnica
    p.wielokat([(10, 20 + b), (30, 20 + b), (31, 34 + b), (9, 34 + b)], sw)
    p.elipsa(9, 18 + b, 31, 24 + b, sw)
    p.wielokat([(9, 34 + b), (31, 34 + b), (32, 56), (8, 56)], sp)
    # fartuch z kieszenią i szpilkami
    p.wielokat([(13, 26 + b), (27, 26 + b), (28, 52), (12, 52)], fa)
    p.prost(15, 38 + b, 25, 43 + b, fa, 0)
    for sx in (16, 18, 23):
        p.piksel(sx, 30 + b, "mosiadz", 3)
    p.prost(12, 34 + b, 28, 34 + b, fa, 0)
    # centymetr krawiecki
    p.linia([(15, 19 + b), (14, 32 + b)], cm, 1)
    p.linia([(25, 19 + b), (26, 30 + b)], cm, 1)
    p.prost(16, 18 + b, 24, 18 + b, cm, 1)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 0), brwi=wl, okulary=okul, szer=5)
    # kok
    p.elipsa(14, 3 + b, 26, 10 + b, wl)
    p.elipsa(17, -1 + b, 23, 4 + b, wl, 2)
    p.prost(14, 8 + b, 14, 11 + b, wl, 1)
    p.prost(26, 8 + b, 26, 11 + b, wl, 1)
    return ap.pokoloruj(p, None)


def bogdan(faza):
    """Bogdan Lis, dyrektor teatru. Łysina z wiankiem włosów, szary garnitur, muszka, papiery w ręku."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    b += 1
    wl = material("bogdan_wlosy", [(54, 40, 34), (84, 64, 52), (112, 88, 70)])
    gar = material("bogdan_garnitur", [(30, 30, 34), (46, 46, 52), (66, 66, 72), (90, 90, 96), (112, 112, 118)])
    mu = material("bogdan_muszka", [(70, 12, 20), (120, 24, 32), (164, 42, 44)])
    buty = material("bogdan_buty", [(12, 8, 8), (30, 22, 20), (60, 48, 44)])
    skora = material("skora_starsza", SKORA_STARSZA)
    okul = material("okulary", [(30, 24, 22)])
    usta = material("usta_meskie", [(120, 70, 60), (150, 92, 78)])
    pap = material("papier", [(150, 140, 120), (206, 198, 178), (236, 230, 214)])
    nogi(p, 48, gar, buty, rozstaw=4, szer=5)
    dlonie = rece(p, b, gar, skora, 20, 15, rozstaw=12, odcien=2)
    # marynarka z brzuszkiem
    p.wielokat([(10, 19 + b), (30, 19 + b), (32, 38 + b), (30, 48), (10, 48), (8, 38 + b)], gar)
    p.elipsa(9, 17 + b, 31, 23 + b, gar)
    p.wielokat([(18, 19 + b), (22, 19 + b), (21, 30 + b), (19, 30 + b)], "koszula")
    p.wielokat([(14, 18 + b), (18, 19 + b), (20, 32 + b), (16, 26 + b)], gar, 4)
    p.wielokat([(26, 18 + b), (22, 19 + b), (20, 32 + b), (24, 26 + b)], gar, 4)
    p.prost(17, 19 + b, 23, 20 + b, mu)
    p.piksel(20, 19 + b, mu, 0)
    for gy in (33, 38):
        p.piksel(20, gy + b, gar, 0)
    p.linia([(20, 32 + b), (17, 47)], gar, 1)
    p.linia([(20, 32 + b), (23, 47)], gar, 1)
    # plik papierów w lewej ręce
    x, y = dlonie[0]
    p.prost(x - 3, y - 6, x + 2, y + 2, pap)
    p.prost(x - 2, y - 4, x + 1, y - 4, pap, 0)
    p.prost(x - 2, y - 2, x + 1, y - 2, pap, 0)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 0), brwi=wl, okulary=okul, szer=6)
    # łysina i wianek włosów
    p.elipsa(14, 2 + b, 26, 10 + b, skora)
    p.prost(17, 3 + b, 20, 4 + b, skora, 3)
    p.prost(13, 6 + b, 14, 12 + b, wl)
    p.prost(26, 6 + b, 27, 12 + b, wl)
    return ap.pokoloruj(p, None)


def marta(faza):
    """Marta, inspicjentka. Czarny bob, słuchawki z mikrofonem, czarne ubranie ekipy, podkładka z kartkami."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    b += 2
    wl = material("marta_wlosy", [(10, 8, 12), (22, 18, 26), (38, 32, 44), (58, 52, 66)])
    ub = material("marta_ubranie", [(12, 12, 16), (22, 22, 28), (36, 36, 44), (52, 52, 62)])
    sp = material("marta_spodnie", [(14, 14, 20), (26, 26, 34), (40, 40, 50)])
    trampki = material("marta_trampki", [(60, 60, 64), (150, 150, 150), (220, 220, 216)])
    sl = material("sluchawki", [(20, 20, 24), (50, 50, 56), (90, 90, 96)])
    pod = material("podkladka", [(80, 56, 30), (120, 88, 48), (156, 118, 66)])
    pap = material("papier", [(150, 140, 120), (206, 198, 178), (236, 230, 214)])
    skora = material("skora_jasna", SKORA_JASNA)
    usta = material("usta_meskie", [(120, 70, 60), (150, 92, 78)])
    nogi(p, 42, sp, trampki, rozstaw=3, szer=4)
    dlonie = rece(p, b, ub, skora, 21, 14, rozstaw=9)
    # golf i bojówki
    p.wielokat([(12, 20 + b), (28, 20 + b), (28, 38 + b), (12, 38 + b)], ub)
    p.elipsa(11, 18 + b, 29, 24 + b, ub)
    p.prost(17, 17 + b, 23, 20 + b, ub, 2)  # golf
    p.wielokat([(12, 38 + b), (28, 38 + b), (27, 46), (13, 46)], sp)
    p.prost(12, 38 + b, 28, 38 + b, "buty", 1)
    # krótkofalówka przy pasku
    p.prost(25, 35 + b, 27, 40 + b, sl, 1)
    p.piksel(26, 34 + b, sl, 2)
    # podkładka z kartkami w prawej ręce, przyciśnięta do boku
    x, y = dlonie[1]
    p.prost(x - 4, y - 12, x + 1, y - 1, pod)
    p.prost(x - 3, y - 10, x, y - 2, pap)
    p.prost(x - 3, y - 8, x, y - 8, pap, 0)
    p.prost(x - 3, y - 5, x, y - 5, pap, 0)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 0), brwi=wl, szer=5)
    # bob z grzywką
    p.elipsa(13, 2 + b, 27, 9 + b, wl)
    p.prost(13, 7 + b, 15, 17 + b, wl)
    p.prost(25, 7 + b, 27, 17 + b, wl)
    p.prost(15, 8 + b, 25, 9 + b, wl, 1)
    # słuchawki z mikrofonem
    p.linia([(13, 5 + b), (16, 1 + b), (24, 1 + b), (27, 5 + b)], sl, 1)
    p.prost(11, 9 + b, 13, 13 + b, sl)
    p.linia([(13, 13 + b), (17, 16 + b)], sl, 2)
    return ap.pokoloruj(p, None)


def zenon(faza):
    """Pan Zenon, stróż magazynu. Kaszkiet, siwe wąsy, granatowa kurtka robocza, latarka."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    b += 2
    ka = material("zenon_kaszkiet", [(30, 28, 26), (52, 48, 42), (76, 70, 60), (100, 92, 80)])
    ku = material("zenon_kurtka", [(16, 22, 36), (26, 34, 54), (40, 50, 76), (58, 70, 98)])
    sp = material("zenon_spodnie", [(34, 32, 26), (52, 48, 38), (72, 66, 52)])
    gum = material("zenon_gumiaki", [(14, 18, 14), (24, 32, 24), (40, 52, 40)])
    wasy = material("zenon_wasy", [(130, 126, 120), (180, 176, 168), (214, 210, 202)])
    lat = material("latarka", [(30, 30, 34), (70, 70, 76), (120, 120, 126)])
    skora = material("skora_starsza", SKORA_STARSZA)
    nogi(p, 46, sp, gum, rozstaw=4, szer=5)
    # gumiaki do pół łydki
    for x0 in (14, 22):
        p.prost(x0 - 1, 56, x0 + 4, ZIEMIA, gum)
    dlonie = rece(p, b, ku, skora, 21, 15, rozstaw=11)
    # kurtka robocza
    p.wielokat([(10, 20 + b), (30, 20 + b), (31, 46), (9, 46)], ku)
    p.elipsa(9, 18 + b, 31, 24 + b, ku)
    p.prost(20, 21 + b, 20, 45, ku, 0)  # zamek
    for kx in (12, 23):
        p.prost(kx, 33 + b, kx + 5, 37 + b, ku, 1)  # kieszenie
        p.prost(kx, 33 + b, kx + 5, 33 + b, ku, 3)
    p.elipsa(14, 17 + b, 26, 22 + b, ku, 3)  # kołnierz
    # latarka w prawej ręce
    x, y = dlonie[1]
    p.prost(x - 1, y, x + 1, y + 7, lat)
    p.prost(x - 2, y + 7, x + 2, y + 9, lat, 2)
    twarz(p, SRODEK, 10 + b, skora, mrug, szer=5)
    p.prost(17, 16 + b, 23, 17 + b, wasy)  # wąsy
    p.piksel(16, 17 + b, wasy, 0)
    p.piksel(24, 17 + b, wasy, 0)
    p.prost(14, 10 + b, 14, 13 + b, wasy, 1)  # siwe skronie
    p.prost(26, 10 + b, 26, 13 + b, wasy, 1)
    # kaszkiet z daszkiem
    p.elipsa(13, 3 + b, 27, 10 + b, ka)
    p.elipsa(14, 8 + b, 26, 11 + b, ka, 1)
    p.prost(15, 4 + b, 25, 4 + b, ka, 3)
    return ap.pokoloruj(p, None)


def halina(faza):
    """Pani Halina, właścicielka pralni. Rudofioletowa trwała, kwiecista bluzka, błękitny fartuch."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    b += 3
    wl = material("halina_wlosy", [(70, 20, 36), (110, 34, 52), (150, 52, 70), (186, 80, 92)])
    bl = material("halina_bluzka", [(110, 70, 90), (160, 108, 130), (204, 150, 168)])
    kw = material("halina_kwiaty", [(220, 220, 150), (250, 236, 180)])
    fa = material("halina_fartuch", [(70, 104, 130), (100, 140, 168), (140, 180, 204), (186, 214, 230)])
    sp = material("halina_spodnica", [(40, 36, 44), (60, 54, 64), (82, 74, 86)])
    kap = material("halina_kapcie", [(90, 30, 40), (130, 48, 58), (170, 72, 80)])
    skora = material("skora_starsza", SKORA_STARSZA)
    usta = material("usta_czerwone", [(110, 28, 36), (150, 40, 46)])
    rum = material("rumience", [(214, 132, 120)])
    nogi(p, 52, skora, kap, rozstaw=4, szer=4)
    rece(p, b, bl, skora, 21, 13, rozstaw=12)
    # tęga sylwetka: bluzka, spódnica, fartuch
    p.wielokat([(10, 20 + b), (30, 20 + b), (32, 36 + b), (8, 36 + b)], bl)
    p.elipsa(9, 18 + b, 31, 25 + b, bl)
    p.wielokat([(8, 36 + b), (32, 36 + b), (31, 55), (9, 55)], sp)
    for kx, ky in ((12, 22), (17, 27), (26, 23), (28, 31), (11, 31), (22, 21)):
        p.piksel(kx, ky + b, kw, 1)
    p.wielokat([(12, 28 + b), (28, 28 + b), (30, 54), (10, 54)], fa)
    p.prost(14, 40 + b, 26, 45 + b, fa, 1)  # kieszeń
    p.prost(15, 41 + b, 17, 41 + b, "papier" if "papier" in ap.RAMPY else fa, 2)  # kwitek w kieszeni
    p.linia([(14, 28 + b), (16, 20 + b)], fa, 2)
    p.linia([(26, 28 + b), (24, 20 + b)], fa, 2)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 1), brwi=wl, szer=6)
    p.piksel(15, 13 + b, rum, 0)
    p.piksel(25, 13 + b, rum, 0)
    # trwała ondulacja: kółka loków
    for lx, ly in ((13, 4), (17, 1), (22, 1), (26, 4), (12, 9), (28, 9), (15, 3), (24, 3)):
        p.elipsa(lx - 3, ly - 3 + b, lx + 3, ly + 3 + b, wl)
    for lx, ly in ((14, 3), (19, 1), (24, 2), (27, 7)):
        p.piksel(lx, ly + b, wl, 3)
    return ap.pokoloruj(p, None)


POSTACIE = {
    "ania": ("Ania", ania),
    "wolski": ("Wolski", wolski),
    "irena": ("Irena", irena),
    "bogdan": ("Bogdan", bogdan),
    "marta": ("Marta", marta),
    "zenon": ("Zenon", zenon),
    "halina": ("Halina", halina),
}


def scena(nazwa_wezla, res_arkusz):
    sub = []
    klatki = []
    for k in range(KLATKI):
        sub.append(f'''[sub_resource type="AtlasTexture" id="k{k}"]
atlas = ExtResource("arkusz")
region = Rect2({k * ap.SZER}, 0, {ap.SZER}, {ap.WYS})
''')
        klatki.append(f'{{\n"duration": 1.0,\n"texture": SubResource("k{k}")\n}}')
    return f'''[gd_scene load_steps={KLATKI + 5} format=3]

[ext_resource type="Texture2D" path="{res_arkusz}" id="arkusz"]
[ext_resource type="Texture2D" path="res://postacie/antoni/cien.png" id="cien"]

{"".join(s + chr(10) for s in sub)}[sub_resource type="SpriteFrames" id="klatki"]
animations = [{{
"frames": [{", ".join(klatki)}],
"loop": true,
"name": &"stoi_dol",
"speed": 5.0
}}]

[sub_resource type="CapsuleShape2D" id="stopy"]
radius = 6.0
height = 20.0

[node name="{nazwa_wezla}" type="StaticBody2D"]

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


def main():
    podglad = []
    for klucz, (nazwa, rysuj) in POSTACIE.items():
        folder = Path("postacie") / klucz
        folder.mkdir(parents=True, exist_ok=True)
        arkusz = Image.new("RGBA", (ap.SZER * KLATKI, ap.WYS), (0, 0, 0, 0))
        for k in range(KLATKI):
            arkusz.alpha_composite(rysuj(k / KLATKI), (k * ap.SZER, 0))
        arkusz.save(folder / f"{klucz}_arkusz.png")
        (folder / f"{klucz}.tscn").write_text(scena(nazwa, f"res://postacie/{klucz}/{klucz}_arkusz.png"),
                                              encoding="utf-8")
        podglad.append(arkusz.crop((0, 0, ap.SZER, ap.WYS)))
    return podglad


if __name__ == "__main__":
    import sys
    obrazy = main()
    if len(sys.argv) > 1:
        antoni = Image.open("postacie/antoni/antoni_arkusz.png").crop((0, 0, ap.SZER, ap.WYS))
        obrazy = [antoni] + obrazy
        tlo = Image.new("RGBA", (ap.SZER * len(obrazy), ap.WYS), (58, 52, 60, 255))
        for i, o in enumerate(obrazy):
            tlo.alpha_composite(o, (i * ap.SZER, 0))
        tlo.resize((tlo.width * 6, tlo.height * 6), Image.NEAREST).save(sys.argv[1])
