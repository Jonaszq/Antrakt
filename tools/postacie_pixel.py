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


# ---------- goście premiery (tło foyer) ----------

def gosc_pan(faza):
    """Starszy pan w smokingu z wąsem, przyszedł na każdą premierę od trzydziestu lat."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    wl = material("pan_wlosy", [(110, 106, 104), (160, 156, 150), (204, 200, 192)])
    smok = material("pan_smoking", [(8, 8, 12), (16, 16, 22), (28, 28, 36), (44, 44, 54)])
    buty = material("bogdan_buty", [(12, 8, 8), (30, 22, 20), (60, 48, 44)])
    skora = material("skora_starsza", SKORA_STARSZA)
    usta = material("usta_meskie", [(120, 70, 60), (150, 92, 78)])
    nogi(p, 48, smok, buty, rozstaw=4, szer=5)
    rece(p, b, smok, skora, 20, 16, rozstaw=11)
    p.wielokat([(10, 19 + b), (30, 19 + b), (31, 36 + b), (30, 49), (10, 49), (9, 36 + b)], smok)
    p.elipsa(9, 17 + b, 31, 23 + b, smok)
    p.wielokat([(17, 19 + b), (23, 19 + b), (21, 32 + b), (19, 32 + b)], "koszula")
    p.prost(18, 19 + b, 22, 20 + b, smok, 0)  # muszka
    p.wielokat([(14, 18 + b), (17, 19 + b), (19, 33 + b), (15, 26 + b)], smok, 3)
    p.wielokat([(26, 18 + b), (23, 19 + b), (21, 33 + b), (25, 26 + b)], smok, 3)
    kwiat = material("czerwien_kwiat", [(110, 20, 30), (170, 36, 44), (220, 70, 70)])
    p.prost(26, 26 + b, 27, 27 + b, kwiat, 2)  # goździk w butonierce
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 0), brwi=wl, szer=5)
    p.prost(17, 14 + b, 23, 15 + b, wl, 1)  # wąs
    p.elipsa(14, 2 + b, 26, 9 + b, wl)
    p.prost(14, 6 + b, 14, 11 + b, wl, 1)
    p.prost(26, 6 + b, 26, 11 + b, wl, 1)
    return ap.pokoloruj(p, None)


def gosc_pani(faza):
    """Elegancka pani w granatowej sukni wieczorowej, perły, upięte włosy."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    wl = material("pani_wlosy", [(20, 14, 14), (40, 28, 26), (64, 44, 38)])
    su = material("pani_suknia", [(12, 14, 40), (22, 26, 66), (36, 42, 98), (56, 64, 136), (84, 94, 170)])
    perly = material("perly", [(190, 186, 176), (236, 232, 222)])
    skora = material("skora_jasna", SKORA_JASNA)
    usta = material("usta_czerwone", [(110, 28, 36), (150, 40, 46)])
    # suknia do ziemi
    p.wielokat([(14, 20 + b), (26, 20 + b), (25, 32 + b), (30, ZIEMIA), (10, ZIEMIA), (15, 32 + b)], su)
    p.linia([(17, 34 + b), (14, ZIEMIA - 1)], su, 1)
    p.linia([(23, 34 + b), (26, ZIEMIA - 1)], su, 1)
    p.prost(15, 31 + b, 25, 31 + b, su, 4)
    rece(p, b, skora, skora, 21, 14, rozstaw=8, odcien=2)
    p.prost(16, 17 + b, 24, 21 + b, skora, 2)  # dekolt
    for px in range(16, 25, 2):
        p.piksel(px, 20 + b, perly, 1)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 1), brwi=wl, szer=5)
    p.elipsa(14, 2 + b, 26, 9 + b, wl)
    p.elipsa(17, 0 + b, 23, 5 + b, wl)  # kok
    p.piksel(22, 1 + b, perly, 1)
    return ap.pokoloruj(p, None)


def gosc_student(faza):
    """Student w swetrze i szaliku, kupił bilet pół roku temu."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    wl = material("student_wlosy", [(60, 40, 20), (96, 66, 34), (130, 94, 52)])
    sw = material("student_sweter", [(24, 46, 34), (36, 70, 48), (56, 100, 66), (86, 134, 90)])
    sz = material("student_szal", [(110, 70, 20), (170, 118, 40), (214, 166, 70)])
    sp = material("student_spodnie", [(30, 32, 48), (44, 48, 70), (62, 68, 96)])
    buty = material("ania_buty", [(16, 10, 10), (34, 20, 18), (56, 34, 28)])
    skora = material("skora_jasna", SKORA_JASNA)
    usta = material("usta_meskie", [(120, 70, 60), (150, 92, 78)])
    okul = material("okulary", [(30, 24, 22)])
    nogi(p, 46, sp, buty, rozstaw=4, szer=4)
    rece(p, b, sw, skora, 20, 15, rozstaw=10)
    p.wielokat([(11, 19 + b), (29, 19 + b), (29, 46), (11, 46)], sw)
    p.elipsa(10, 17 + b, 30, 23 + b, sw)
    for ry in range(26, 44, 4):
        p.prost(12, ry + b, 28, ry + b, sw, 1)
    p.elipsa(13, 16 + b, 27, 22 + b, sz)
    p.wielokat([(23, 20 + b), (26, 20 + b), (26, 36 + b), (23, 35 + b)], sz, 1)
    for fy in (30, 33):
        p.prost(23, fy + b, 26, fy + b, sz, 2)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=(usta, 0), brwi=wl, okulary=okul, szer=5)
    for lx, ly in ((15, 3), (19, 1), (24, 2), (27, 6), (13, 7)):  # rozczochrane
        p.elipsa(lx - 3, ly - 2 + b, lx + 3, ly + 3 + b, wl)
    return ap.pokoloruj(p, None)


# ---------- ludzie w tle (rozdział 1) ----------
# Składani z tych samych części, żeby było ich dużo: fryzura, góra, dół, dodatki.

def fryzura(p, b, wl, styl):
    if styl == "krotkie":
        p.elipsa(14, 2 + b, 26, 9 + b, wl)
        p.prost(14, 6 + b, 14, 11 + b, wl, 1)
        p.prost(26, 6 + b, 26, 11 + b, wl, 1)
    elif styl == "lysy":
        p.prost(13, 6 + b, 14, 12 + b, wl)
        p.prost(26, 6 + b, 27, 12 + b, wl)
    elif styl == "kok":
        p.elipsa(14, 2 + b, 26, 9 + b, wl)
        p.elipsa(17, -1 + b, 23, 4 + b, wl, 2)
    elif styl == "trwala":
        for lx, ly in ((14, 4), (18, 1), (22, 1), (26, 4), (13, 9), (27, 9), (13, 13), (27, 13)):
            p.elipsa(lx - 3, ly - 2 + b, lx + 3, ly + 3 + b, wl)
        for lx, ly in ((16, 2), (21, 1), (25, 6)):
            p.piksel(lx, ly + b, wl, 3)
    elif styl == "kucyk":
        p.elipsa(14, 2 + b, 26, 9 + b, wl)
        p.prost(25, 6 + b, 28, 20 + b, wl, 1)
        p.prost(26, 8 + b, 27, 18 + b, wl, 2)
    elif styl == "dlugie":
        p.elipsa(13, 1 + b, 27, 9 + b, wl)
        p.prost(12, 7 + b, 14, 24 + b, wl)
        p.prost(26, 7 + b, 28, 24 + b, wl)
    elif styl == "czapka":
        p.elipsa(13, 1 + b, 27, 8 + b, wl)
        p.prost(13, 6 + b, 27, 7 + b, wl, 0)
        p.piksel(20, 0 + b, wl, 3)


def gora(p, b, kolor, styl, koszula=None, ozdoba=None):
    """Tułów od ramion do pasa (y 17-46). Zwraca pozycje dłoni."""
    if styl == "marynarka":
        dlonie = rece(p, b, kolor, ozdoba or "skora", 20, 15, rozstaw=11)
        p.wielokat([(10, 19 + b), (30, 19 + b), (31, 36 + b), (30, 48), (10, 48), (9, 36 + b)], kolor)
        p.elipsa(9, 17 + b, 31, 23 + b, kolor)
        p.wielokat([(17, 19 + b), (23, 19 + b), (21, 32 + b), (19, 32 + b)], koszula or "koszula")
        p.wielokat([(14, 18 + b), (17, 19 + b), (19, 33 + b), (15, 26 + b)], kolor, 3)
        p.wielokat([(26, 18 + b), (23, 19 + b), (21, 33 + b), (25, 26 + b)], kolor, 3)
        p.piksel(20, 36 + b, kolor, 0)
    elif styl == "kamizelka":
        dlonie = rece(p, b, koszula or "koszula", ozdoba or "skora", 20, 15, rozstaw=10)
        p.wielokat([(11, 19 + b), (29, 19 + b), (29, 46), (11, 46)], koszula or "koszula")
        p.elipsa(10, 17 + b, 30, 23 + b, koszula or "koszula")
        p.wielokat([(12, 21 + b), (18, 21 + b), (20, 32 + b), (20, 46), (12, 46)], kolor)
        p.wielokat([(28, 21 + b), (22, 21 + b), (20, 32 + b), (20, 46), (28, 46)], kolor)
        for gy in (35, 39, 43):
            p.piksel(19, gy + b, "mosiadz", 2)
    elif styl == "sweter":
        dlonie = rece(p, b, kolor, ozdoba or "skora", 20, 15, rozstaw=10)
        p.wielokat([(11, 19 + b), (29, 19 + b), (29, 46), (11, 46)], kolor)
        p.elipsa(10, 17 + b, 30, 23 + b, kolor)
        p.prost(11, 44, 29, 46, kolor, 0)
    elif styl == "kombinezon":
        dlonie = rece(p, b, kolor, ozdoba or "skora", 20, 15, rozstaw=11)
        p.wielokat([(10, 19 + b), (30, 19 + b), (30, 48), (10, 48)], kolor)
        p.elipsa(9, 17 + b, 31, 23 + b, kolor)
        p.prost(14, 26 + b, 26, 40 + b, kolor, 1)  # śliniak
        p.prost(14, 19 + b, 15, 26 + b, kolor, 3)
        p.prost(25, 19 + b, 26, 26 + b, kolor, 3)
        p.prost(17, 30 + b, 22, 33 + b, kolor, 0)  # kieszeń
    elif styl == "sukienka":
        dlonie = rece(p, b, kolor, ozdoba or "skora", 21, 14, rozstaw=8)
        p.wielokat([(14, 20 + b), (26, 20 + b), (25, 32 + b), (29, 50), (11, 50), (15, 32 + b)], kolor)
        p.prost(15, 31 + b, 25, 31 + b, kolor, 0)
        p.linia([(18, 34 + b), (16, 49)], kolor, 1)
    return dlonie


def czlowiek(faza, *, skora, wlosy, fryz, ubranie, styl, dol, buty, koszula=None, usta=None, okulary=None,
             zarost=None, nizej=0, nogi_od=48, rozstaw_nog=4, dodatki=None, muszka=None, szer_twarzy=5):
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    b += nizej
    if dol:
        nogi(p, nogi_od, dol, buty, rozstaw=rozstaw_nog, szer=4)
    dlonie = gora(p, b, ubranie, styl, koszula, skora)
    if muszka:
        p.prost(18, 19 + b, 22, 20 + b, muszka)
        p.piksel(20, 19 + b, muszka, 0)
    twarz(p, SRODEK, 8 + b, skora, mrug, usta=usta, brwi=wlosy, okulary=okulary, zarost=zarost, szer=szer_twarzy)
    fryzura(p, b, wlosy, fryz)
    if dodatki:
        dodatki(p, b, dlonie)
    return ap.pokoloruj(p, None)


def _skora(stara=False):
    return material("skora_starsza", SKORA_STARSZA) if stara else material("skora_jasna", SKORA_JASNA)


def _usta():
    return (material("usta_meskie", [(120, 70, 60), (150, 92, 78)]), 0)


def _szminka():
    return (material("usta_czerwone", [(110, 28, 36), (150, 40, 46)]), 1)


def _buty():
    return material("bogdan_buty", [(12, 8, 8), (30, 22, 20), (60, 48, 44)])


def zawada(faza):
    """Krytyk Zawada. Tweedowa marynarka, okulary, siwa kozia bródka, notes i ołówek."""
    tweed = material("tweed", [(52, 40, 26), (82, 66, 42), (112, 94, 62), (140, 120, 82), (160, 140, 100)])
    wl = material("zawada_wlosy", [(96, 92, 90), (150, 146, 140), (196, 192, 184)])
    pap = material("papier", [(150, 140, 120), (206, 198, 178), (236, 230, 214)])

    def notes(p, b, dl):
        x, y = dl[1]
        p.prost(x - 3, y - 7, x + 1, y - 1, pap)
        p.prost(x - 2, y - 5, x, y - 5, pap, 0)
        x, y = dl[0]
        p.linia([(x, y - 6), (x + 2, y)], "mosiadz", 2)
        p.prost(17, 14, 23, 17, wl, 1)  # bródka (bez oddechu, bo i tak drobna)
    return czlowiek(faza, skora=_skora(True), wlosy=wl, fryz="lysy", ubranie=tweed, styl="marynarka",
                    dol=material("pan_smoking", [(8, 8, 12), (16, 16, 22), (28, 28, 36), (44, 44, 54)]),
                    buty=_buty(), usta=_usta(), okulary=material("okulary", [(30, 24, 22)]),
                    koszula=material("koszula_ciemna", [(60, 30, 34), (90, 46, 50), (120, 66, 66)]),
                    dodatki=notes, szer_twarzy=6)


def stasia(faza):
    """Pani Stasia, wierna fanka Wolskiego. Fioletowa trwała, futrzana etola, album z autografami."""
    wl = material("stasia_wlosy", [(70, 40, 80), (106, 66, 118), (140, 96, 150), (176, 130, 180)])
    su = material("stasia_suknia", [(40, 24, 18), (66, 40, 30), (96, 60, 44), (124, 84, 60)])
    fu = material("futro", [(90, 78, 66), (140, 126, 108), (186, 172, 150), (220, 210, 190)])
    al = material("album", [(80, 14, 22), (130, 26, 36), (176, 48, 52)])

    def etola(p, b, dl):
        p.elipsa(11, 17 + b, 29, 24 + b, fu)
        for fx in range(12, 29, 3):
            p.piksel(fx, 22 + b, fu, 3)
        x, y = dl[0]
        p.prost(x - 2, y - 9, x + 5, y + 1, al)
        p.prost(x - 1, y - 8, x + 4, y - 8, al, 2)
        p.piksel(x + 1, y - 5, "mosiadz", 3)
    return czlowiek(faza, skora=_skora(True), wlosy=wl, fryz="trwala", ubranie=su, styl="sukienka", dol=None,
                    buty=None, usta=_szminka(), nizej=2, dodatki=_nogi_pod_suknia(su, etola),
                    okulary=material("okulary", [(30, 24, 22)]))


def _nogi_pod_suknia(suknia, dalej=None, rajstopy=None):
    def f(p, b, dl):
        r = rajstopy or material("pani_rajstopy", [(70, 54, 50), (110, 88, 80), (140, 116, 104)])
        for x0 in (16, 22):
            p.prost(x0, 50, x0 + 2, ZIEMIA - 3, r)
            p.prost(x0 - 1, ZIEMIA - 2, x0 + 2, ZIEMIA, _buty())
        if dalej:
            dalej(p, b, dl)
    return f


def bileterka(faza):
    """Bileterka. Bordowa kamizelka z plakietką, biała bluzka, kok, czytnik biletów."""
    ka = material("bordo", [(50, 10, 20), (84, 18, 30), (120, 30, 42), (156, 52, 58)])

    def dodatki(p, b, dl):
        p.prost(23, 25 + b, 26, 26 + b, "mosiadz", 3)  # plakietka
        x, y = dl[1]
        p.prost(x - 1, y - 5, x + 2, y, material("czytnik", [(20, 20, 24), (40, 40, 48), (90, 170, 120)]))
        p.piksel(x, y - 4, "czytnik", 2)
    return czlowiek(faza, skora=_skora(), wlosy=material("pani_wlosy", [(20, 14, 14), (40, 28, 26), (64, 44, 38)]),
                    fryz="kok", ubranie=ka, styl="kamizelka", koszula="koszula",
                    dol=material("marta_spodnie", [(14, 14, 20), (26, 26, 34), (40, 40, 50)]), buty=_buty(),
                    usta=_szminka(), nogi_od=46, rozstaw_nog=3, dodatki=dodatki)


def szatniarz(faza):
    """Szatniarz. Starszy pan w szarej kamizelce, wąsy, numerki na kółku."""
    ka = material("szara_kamizelka", [(34, 34, 40), (54, 54, 62), (76, 76, 84), (100, 100, 108)])
    wl = material("pan_wlosy", [(110, 106, 104), (160, 156, 150), (204, 200, 192)])

    def dodatki(p, b, dl):
        p.prost(17, 14 + b, 23, 15 + b, wl, 1)  # wąs
        x, y = dl[0]
        for nx in (-2, 0, 2):
            p.piksel(x + nx, y + 2, "mosiadz", 3)
        p.linia([(x - 2, y + 1), (x + 2, y + 1)], "mosiadz", 1)
    return czlowiek(faza, skora=_skora(True), wlosy=wl, fryz="krotkie", ubranie=ka, styl="kamizelka",
                    dol=material("pan_smoking", [(8, 8, 12), (16, 16, 22), (28, 28, 36), (44, 44, 54)]),
                    buty=_buty(), usta=_usta(), muszka=material("bogdan_muszka", [(70, 12, 20), (120, 24, 32), (164, 42, 44)]),
                    dodatki=dodatki, nizej=1)


def bufetowa(faza):
    """Bufetowa. Biały fartuch, czepek, rumiane policzki, ścierka przez ramię."""
    fa = material("fartuch_bialy", [(150, 146, 140), (200, 196, 188), (236, 232, 224)])
    su = material("bufetowa_sukienka", [(30, 50, 80), (46, 74, 116), (70, 104, 150)])
    wl = material("bufetowa_wlosy", [(110, 60, 20), (160, 96, 40), (200, 136, 66)])

    def dodatki(p, b, dl):
        p.wielokat([(13, 24 + b), (27, 24 + b), (28, 50), (12, 50)], fa)
        p.prost(15, 34 + b, 25, 34 + b, fa, 0)
        p.prost(14, 3 + b, 26, 5 + b, fa, 2)  # czepek
        p.prost(26, 19 + b, 28, 30 + b, material("scierka", [(110, 30, 30), (170, 60, 50), (220, 200, 180)]), 1)
        p.piksel(16, 12 + b, "usta_czerwone", 1)
        p.piksel(24, 12 + b, "usta_czerwone", 1)
    return czlowiek(faza, skora=_skora(True), wlosy=wl, fryz="kok", ubranie=su, styl="sukienka", dol=None, buty=None,
                    usta=_szminka(), nizej=1, szer_twarzy=6, dodatki=_nogi_pod_suknia(su, dodatki))


def _taca(p, dl, kieliszki=True):
    x, y = dl[1]
    tac = material("taca", [(90, 90, 96), (160, 160, 166), (210, 210, 214)])
    p.prost(x - 6, y - 10, x + 5, y - 9, tac)
    p.prost(x - 1, y - 9, x + 1, y - 1, "skora", 2)
    if kieliszki:
        sz = material("szampan", [(140, 110, 40), (220, 190, 90), (250, 236, 170)])
        for kx in (-4, 0, 3):
            p.prost(x + kx, y - 14, x + kx + 1, y - 11, sz, 1)
            p.piksel(x + kx, y - 15, sz, 2)


def kelner(faza):
    """Kelner. Czarna kamizelka, biała koszula, muszka, taca z kieliszkami szampana."""
    ka = material("pan_smoking", [(8, 8, 12), (16, 16, 22), (28, 28, 36), (44, 44, 54)])
    return czlowiek(faza, skora=_skora(), wlosy=material("wlosy_czarne", [(14, 10, 10), (30, 22, 20), (48, 36, 30)]),
                    fryz="krotkie", ubranie=ka, styl="kamizelka", dol=ka, buty=_buty(), usta=_usta(),
                    muszka=ka, dodatki=lambda p, b, dl: _taca(p, dl))


def kelnerka(faza):
    """Kelnerka. Czarna sukienka, biały fartuszek, kucyk, taca z pustymi kieliszkami."""
    su = material("pan_smoking", [(8, 8, 12), (16, 16, 22), (28, 28, 36), (44, 44, 54)])
    fa = material("fartuch_bialy", [(150, 146, 140), (200, 196, 188), (236, 232, 224)])

    def dodatki(p, b, dl):
        p.wielokat([(14, 32 + b), (26, 32 + b), (27, 44), (13, 44)], fa)
        _taca(p, dl)
    return czlowiek(faza, skora=_skora(), wlosy=material("bufetowa_wlosy", [(110, 60, 20), (160, 96, 40), (200, 136, 66)]),
                    fryz="kucyk", ubranie=su, styl="sukienka", dol=None, buty=None, usta=_szminka(), nizej=2,
                    dodatki=_nogi_pod_suknia(su, dodatki))


def fotograf(faza):
    """Fotograf lokalnej gazety. Kurtka z kieszeniami, czapka z daszkiem, aparat z fleszem."""
    ku = material("kurtka_oliwka", [(34, 40, 22), (54, 62, 34), (78, 88, 50), (104, 114, 70)])
    ap_ = material("aparat", [(14, 14, 18), (34, 34, 40), (70, 70, 80), (200, 220, 240)])

    def dodatki(p, b, dl):
        p.prost(14, 30 + b, 18, 34 + b, ku, 3)
        p.prost(22, 30 + b, 26, 34 + b, ku, 3)
        p.linia([(14, 18 + b), (24, 30 + b)], ap_, 1)  # pasek
        p.prost(16, 25 + b, 24, 31 + b, ap_, 1)
        p.prost(18, 26 + b, 21, 29 + b, ap_, 0)
        p.piksel(19, 27 + b, ap_, 3)
        p.prost(17, 23 + b, 20, 24 + b, ap_, 2)  # flesz
    return czlowiek(faza, skora=_skora(), wlosy=material("czapka_czerwona", [(70, 14, 18), (120, 26, 30), (170, 50, 50), (210, 90, 80)]),
                    fryz="czapka", ubranie=ku, styl="sweter",
                    dol=material("dzinsy", [(20, 28, 50), (34, 46, 78), (52, 68, 106)]), buty=_buty(), usta=_usta(),
                    zarost=material("zarost_jasny", [(110, 80, 60), (140, 104, 80)]), dodatki=dodatki)


def para_pan(faza):
    """Mąż z kłócącej się pary. Brązowy garnitur, bilety w ręku, czerwony z nerwów."""
    gar = material("garnitur_braz", [(36, 24, 18), (58, 40, 28), (84, 60, 42), (110, 82, 58)])
    pap = material("papier", [(150, 140, 120), (206, 198, 178), (236, 230, 214)])

    def bilety(p, b, dl):
        x, y = dl[1]
        p.prost(x - 1, y - 6, x + 3, y - 3, pap, 2)
        p.prost(x, y - 5, x + 2, y - 5, "bordo", 2)
    return czlowiek(faza, skora=_skora(), wlosy=material("wlosy_czarne", [(14, 10, 10), (30, 22, 20), (48, 36, 30)]),
                    fryz="krotkie", ubranie=gar, styl="marynarka", dol=gar, buty=_buty(), usta=_usta(),
                    koszula="koszula", dodatki=bilety, szer_twarzy=6,
                    zarost=material("zarost_ciemny", [(70, 50, 44), (96, 70, 60)]))


def para_pani(faza):
    """Żona z kłócącej się pary. Zielona sukienka, blond loki, torebka."""
    su = material("suknia_zielona", [(16, 48, 36), (26, 76, 56), (40, 106, 78), (64, 140, 104)])
    wl = material("wlosy_blond", [(150, 110, 50), (200, 160, 80), (232, 200, 120), (248, 230, 170)])

    def torebka(p, b, dl):
        x, y = dl[0]
        p.prost(x - 3, y - 1, x + 2, y + 4, "bordo", 1)
        p.linia([(x - 2, y - 1), (x, y - 4), (x + 1, y - 1)], "mosiadz", 2)
    return czlowiek(faza, skora=_skora(), wlosy=wl, fryz="dlugie", ubranie=su, styl="sukienka", dol=None, buty=None,
                    usta=_szminka(), nizej=2, dodatki=_nogi_pod_suknia(su, torebka))


def dziecko(faza):
    """Dziecko (ok. 7 lat) w odświętnym ubranku, biega wokół kolumn."""
    p = ap.Plotno()
    b, mrug = oddech_mrug(faza)
    sw = material("dziecko_sweter", [(30, 50, 110), (46, 76, 150), (70, 110, 190), (110, 150, 220)])
    sp = material("dziecko_spodenki", [(30, 30, 36), (50, 50, 58), (70, 70, 80)])
    skora = _skora()
    wl = material("wlosy_blond", [(150, 110, 50), (200, 160, 80), (232, 200, 120), (248, 230, 170)])
    for x0 in (16, 22):
        p.prost(x0, 52, x0 + 2, ZIEMIA - 3, skora, 2)
        p.prost(x0 - 1, ZIEMIA - 2, x0 + 2, ZIEMIA, _buty())
    p.prost(14, 47, 26, 53, sp)
    for strona in (-1, 1):
        x = SRODEK + strona * 7
        p.prost(x - 1, 36 + b, x + 1, 46 + b, sw)
        p.prost(x - 1, 46 + b, x + 1, 48 + b, skora)
    p.wielokat([(14, 35 + b), (26, 35 + b), (26, 48), (14, 48)], sw)
    p.prost(17, 34 + b, 23, 36 + b, "koszula")
    p.prost(18, 35 + b, 22, 35 + b, "krawat")
    twarz(p, SRODEK, 24 + b, skora, mrug, usta=_usta(), brwi=wl, szer=6)
    p.elipsa(13, 17 + b, 27, 26 + b, wl)
    p.prost(13, 22 + b, 14, 29 + b, wl, 1)
    p.prost(26, 22 + b, 27, 29 + b, wl, 1)
    p.piksel(18, 18 + b, wl, 3)
    return ap.pokoloruj(p, None)


def maszynista(faza):
    """Maszynista sceny. Granatowy kombinezon, rękawice robocze, broda."""
    ko = material("kombinezon", [(20, 26, 44), (30, 40, 66), (44, 58, 92), (64, 82, 122)])
    rek = material("rekawice", [(90, 70, 30), (140, 112, 52), (180, 150, 80)])

    def dodatki(p, b, dl):
        for x, y in dl:
            p.prost(x - 2, y - 1, x + 2, y + 2, rek)
    return czlowiek(faza, skora=_skora(), wlosy=material("wlosy_rude", [(90, 34, 14), (140, 60, 24), (180, 90, 40)]),
                    fryz="krotkie", ubranie=ko, styl="kombinezon", dol=ko, buty=material("ania_buty", [(16, 10, 10), (34, 20, 18), (56, 34, 28)]),
                    usta=_usta(), zarost=material("broda_ruda", [(110, 46, 20), (150, 70, 30)]), dodatki=dodatki,
                    szer_twarzy=6)


def maszynista2(faza):
    """Drugi maszynista. Czarny podkoszulek, czapka, papieros za uchem."""
    ko = material("marta_ubranie", [(12, 12, 16), (22, 22, 28), (36, 36, 44), (52, 52, 62)])

    def dodatki(p, b, dl):
        p.prost(27, 6 + b, 28, 6 + b, "koszula", 2)
    return czlowiek(faza, skora=_skora(True), wlosy=material("czapka_szara", [(40, 40, 44), (64, 64, 70), (90, 90, 96), (120, 120, 126)]),
                    fryz="czapka", ubranie=ko, styl="sweter",
                    dol=material("dzinsy", [(20, 28, 50), (34, 46, 78), (52, 68, 106)]),
                    buty=material("ania_buty", [(16, 10, 10), (34, 20, 18), (56, 34, 28)]), usta=_usta(),
                    zarost=material("zarost_ciemny", [(70, 50, 44), (96, 70, 60)]), dodatki=dodatki)


def garderobiana(faza):
    """Garderobiana. Fartuch w kratkę, krótkie siwe włosy, żelazko w ręku."""
    su = material("garderobiana_sukienka", [(50, 30, 50), (80, 50, 80), (110, 76, 110)])
    fa = material("fartuch_krata", [(60, 80, 90), (100, 130, 140), (160, 190, 196)])

    def dodatki(p, b, dl):
        p.wielokat([(13, 24 + b), (27, 24 + b), (28, 50), (12, 50)], fa)
        for ky in range(27, 49, 4):
            p.prost(13, ky + b, 27, ky + b, fa, 0)
        x, y = dl[1]
        z = material("zelazko", [(30, 30, 34), (90, 90, 96), (170, 170, 176)])
        p.wielokat([(x - 4, y), (x + 3, y), (x + 4, y + 4), (x - 4, y + 4)], z, 1)
        p.prost(x - 2, y - 2, x + 1, y - 1, z, 0)
    return czlowiek(faza, skora=_skora(True), wlosy=material("pan_wlosy", [(110, 106, 104), (160, 156, 150), (204, 200, 192)]),
                    fryz="krotkie", ubranie=su, styl="sukienka", dol=None, buty=None, usta=_usta(), nizej=3,
                    dodatki=_nogi_pod_suknia(su, dodatki))


def aktor(faza):
    """Aktor drugoplanowy w kostiumie: kubrak z bufiastymi rękawami i kryza."""
    ku = material("kubrak", [(40, 50, 20), (64, 78, 32), (92, 108, 48), (124, 140, 70)])
    kr = material("kryza", [(170, 166, 156), (220, 216, 206), (246, 244, 236)])

    def dodatki(p, b, dl):
        p.elipsa(13, 16 + b, 27, 21 + b, kr)
        for kx in range(14, 27, 2):
            p.piksel(kx, 20 + b, kr, 0)
        for gy in (26, 31, 36, 41):
            p.piksel(20, gy + b, "mosiadz", 3)
    return czlowiek(faza, skora=_skora(), wlosy=material("wlosy_czarne", [(14, 10, 10), (30, 22, 20), (48, 36, 30)]),
                    fryz="dlugie", ubranie=ku, styl="sweter",
                    dol=material("rajstopy_czerwone", [(70, 14, 20), (110, 24, 30), (150, 40, 44)]),
                    buty=_buty(), usta=_usta(), zarost=material("zarost_ciemny", [(70, 50, 44), (96, 70, 60)]),
                    dodatki=dodatki)


def aktorka(faza):
    """Aktorka drugoplanowa w kostiumie: suknia z gorsetem, peruka z lokami."""
    su = material("suknia_kostium", [(60, 20, 60), (96, 34, 96), (136, 56, 130), (176, 90, 166)])
    wl = material("peruka", [(150, 140, 120), (196, 186, 164), (226, 218, 198), (244, 240, 226)])

    def dodatki(p, b, dl):
        for gy in range(23, 32, 3):
            p.prost(18, gy + b, 22, gy + b, "mosiadz", 2)
    return czlowiek(faza, skora=_skora(), wlosy=wl, fryz="trwala", ubranie=su, styl="sukienka", dol=None, buty=None,
                    usta=_szminka(), nizej=1, dodatki=_nogi_pod_suknia(su, dodatki))


def sprzataczka(faza):
    """Sprzątaczka w teatrze. Niebieski fartuch, chustka na głowie, mop w ręku."""
    su = material("sprzataczka_sukienka", [(40, 40, 46), (66, 66, 74), (92, 92, 100)])
    fa = material("fartuch_niebieski", [(30, 60, 110), (50, 90, 150), (90, 130, 190)])
    ch = material("chustka", [(110, 30, 40), (160, 50, 60), (200, 90, 90)])

    def dodatki(p, b, dl):
        p.wielokat([(13, 24 + b), (27, 24 + b), (28, 50), (12, 50)], fa)
        p.prost(16, 32 + b, 24, 37 + b, fa, 2)  # kieszeń
        p.wielokat([(12, 6 + b), (28, 6 + b), (27, 11 + b), (13, 11 + b)], ch, 1)  # chustka
        p.prost(14, 5 + b, 26, 6 + b, ch, 2)
        x, y = dl[1]
        kij = material("kij_mopa", [(70, 50, 30), (110, 80, 50)])
        p.prost(x, y - 18, x, y + 14, kij, 1)
        mop = material("mop", [(150, 146, 130), (190, 186, 170)])
        p.prost(x - 3, y + 14, x + 3, y + 18, mop, 1)
    return czlowiek(faza, skora=_skora(True), wlosy=material("pani_wlosy_siwe", [(90, 86, 84), (140, 136, 130), (180, 176, 170)]),
                    fryz="krotkie", ubranie=su, styl="sukienka", dol=None, buty=None, usta=_usta(), nizej=3,
                    dodatki=_nogi_pod_suknia(su, dodatki))


def lekarz(faza):
    """Lekarz pogotowia. Czerwona kurtka z odblaskami, stetoskop, siwiejące skronie, zmęczony."""
    ku = material("kurtka_pogotowie", [(80, 14, 14), (130, 26, 24), (176, 46, 36), (214, 80, 60)])
    odb = material("odblask", [(150, 150, 140), (210, 210, 196), (250, 250, 236)])
    st = material("stetoskop", [(20, 20, 24), (50, 50, 56), (150, 150, 160)])

    def dodatki(p, b, dl):
        for oy in (30, 40):
            p.prost(10, oy + b, 30, oy + b, odb, 2)
        p.linia([(16, 19 + b), (17, 27 + b), (20, 30 + b), (23, 27 + b), (24, 19 + b)], st, 0)
        p.prost(19, 30 + b, 21, 32 + b, st, 2)
    return czlowiek(faza, skora=_skora(True), wlosy=material("pan_wlosy", [(110, 106, 104), (160, 156, 150), (204, 200, 192)]),
                    fryz="krotkie", ubranie=ku, styl="sweter",
                    dol=material("spodnie_pogotowie", [(40, 12, 14), (70, 22, 22), (100, 34, 32)]), buty=_buty(),
                    usta=_usta(), okulary=material("okulary", [(30, 24, 22)]), dodatki=dodatki, szer_twarzy=6)


def nowicki(faza):
    """Komisarz Nowicki, przełożony Antoniego. Beżowy prochowiec, wąsy, podkrążone oczy."""
    pr = material("prochowiec", [(70, 58, 36), (110, 92, 60), (150, 128, 86), (186, 164, 116), (210, 190, 140)])
    wl = material("nowicki_wlosy", [(40, 32, 28), (66, 54, 46), (92, 78, 66)])

    def dodatki(p, b, dl):
        p.prost(17, 16 + b, 23, 16 + b, wl, 0)  # wąsy
        p.piksel(16, 17 + b, wl, 0)
        p.piksel(24, 17 + b, wl, 0)
        p.prost(16, 13 + b, 17, 13 + b, "skora_starsza", 0)  # podkrążone oczy
        p.prost(23, 13 + b, 24, 13 + b, "skora_starsza", 0)
        p.prost(14, 30 + b, 26, 31 + b, pr, 1)  # pasek prochowca
        p.piksel(20, 30 + b, "mosiadz", 2)
    return czlowiek(faza, skora=_skora(True), wlosy=wl, fryz="krotkie", ubranie=pr, styl="marynarka",
                    dol=material("pan_smoking", [(8, 8, 12), (16, 16, 22), (28, 28, 36), (44, 44, 54)]),
                    buty=_buty(), koszula=material("koszula_ciemna", [(60, 30, 34), (90, 46, 50), (120, 66, 66)]),
                    dodatki=dodatki, szer_twarzy=6)


def policjant(faza):
    """Policjant z aparatem. Granatowy mundur, czapka z daszkiem."""
    mu = material("mundur", [(14, 20, 38), (22, 32, 58), (34, 48, 84), (52, 70, 114)])
    ap_ = material("aparat", [(14, 14, 18), (34, 34, 40), (70, 70, 80), (200, 220, 240)])

    def dodatki(p, b, dl):
        p.prost(14, 3 + b, 26, 4 + b, mu, 3)
        p.piksel(20, 2 + b, "mosiadz", 3)  # orzełek
        p.prost(23, 23 + b, 26, 25 + b, "mosiadz", 2)  # odznaka
        x, y = dl[1]
        p.prost(x - 4, y - 6, x + 2, y - 1, ap_, 1)
        p.prost(x - 2, y - 5, x, y - 3, ap_, 0)
        p.piksel(x - 1, y - 4, ap_, 3)
    return czlowiek(faza, skora=_skora(), wlosy=mu, fryz="czapka", ubranie=mu, styl="sweter", dol=mu,
                    buty=_buty(), usta=_usta(), dodatki=dodatki)


def _adrian(faza, martwy=False):
    """Adrian, dubler Wolskiego. Ciemne potargane włosy, rozpięta biała koszula."""
    skora = material("skora_blada", [(110, 96, 96), (156, 140, 136), (196, 182, 176), (220, 210, 204)]) if martwy else _skora()
    ko = material("koszula_adriana", [(150, 146, 140), (196, 192, 184), (230, 226, 218), (246, 244, 238)])
    wl = material("adrian_wlosy", [(16, 12, 12), (34, 24, 22), (56, 40, 34)])

    def dodatki(p, b, dl):
        p.wielokat([(18, 19 + b), (22, 19 + b), (20, 27 + b)], skora, 2)  # rozpięty kołnierz
        p.piksel(15, 3 + b, wl, 2)
        p.piksel(24, 2 + b, wl, 2)
        if martwy:
            # czerwone pasy na ramionach, tam gdzie przylegała podszewka kostiumu
            for x0, x1 in ((9, 14), (26, 31)):
                for py in (19, 22):
                    p.prost(x0, py + b, x1, py + b, "pasy_czerwone", 1)
    material("pasy_czerwone", [(110, 20, 24), (180, 40, 40), (220, 80, 70)])
    # martwy: zawsze ta sama klatka z zamkniętymi oczami (faza mrugnięcia), bez ust
    return czlowiek(0.7 if martwy else faza, skora=skora, wlosy=wl, fryz="krotkie", ubranie=ko, styl="sweter",
                    dol=material("dzinsy", [(20, 28, 50), (34, 46, 78), (52, 68, 106)]), buty=_buty(),
                    usta=None if martwy else _usta(), dodatki=dodatki)


def adrian(faza):
    return _adrian(faza)


POSTACIE = {
    "ania": ("Ania", ania),
    "wolski": ("Wolski", wolski),
    "irena": ("Irena", irena),
    "bogdan": ("Bogdan", bogdan),
    "marta": ("Marta", marta),
    "zenon": ("Zenon", zenon),
    "halina": ("Halina", halina),
    "gosc_pan": ("GoscPan", gosc_pan),
    "gosc_pani": ("GoscPani", gosc_pani),
    "gosc_student": ("GoscStudent", gosc_student),
    "zawada": ("Zawada", zawada),
    "stasia": ("Stasia", stasia),
    "bileterka": ("Bileterka", bileterka),
    "szatniarz": ("Szatniarz", szatniarz),
    "bufetowa": ("Bufetowa", bufetowa),
    "kelner": ("Kelner", kelner),
    "kelnerka": ("Kelnerka", kelnerka),
    "fotograf": ("Fotograf", fotograf),
    "para_pan": ("ParaPan", para_pan),
    "para_pani": ("ParaPani", para_pani),
    "dziecko": ("Dziecko", dziecko),
    "maszynista": ("Maszynista", maszynista),
    "maszynista2": ("Maszynista2", maszynista2),
    "garderobiana": ("Garderobiana", garderobiana),
    "aktor": ("Aktor", aktor),
    "aktorka": ("Aktorka", aktorka),
    "lekarz": ("Lekarz", lekarz),
    "sprzataczka": ("Sprzataczka", sprzataczka),
    "nowicki": ("Nowicki", nowicki),
    "policjant": ("Policjant", policjant),
    "adrian": ("Adrian", adrian),
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
    # ciało Adriana w magazynie (scena 6): leży na boku, obrócone o 90 stopni
    cialo = _adrian(0.0, martwy=True).rotate(90, expand=True)
    cialo = cialo.crop(cialo.getbbox())
    cialo.save(Path("rekwizyty") / "cialo_adriana.png")
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
