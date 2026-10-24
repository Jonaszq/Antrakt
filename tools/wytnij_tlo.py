"""Wycina jednolite szare tło z wygenerowanej grafiki postaci.

Użycie: python3 tools/wytnij_tlo.py wejscie.png wyjscie.png [tolerancja]
Tło jest wypełniane od krawędzi obrazu (flood fill), więc szare elementy
wewnątrz postaci zostają nietknięte.
"""
import sys
from collections import deque

import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage


def wytnij(src, dst, tol=34):
    im = Image.open(src).convert("RGB")
    a = np.asarray(im).astype(np.int16)
    h, w, _ = a.shape
    # kolor tła = mediana pikseli z ramki
    ramka = np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]])
    tlo = np.median(ramka, axis=0)
    dist = np.abs(a - tlo).max(axis=2)
    sat = a.max(axis=2) - a.min(axis=2)
    podobne = (dist < tol) & (sat < 20)
    maska = np.zeros((h, w), bool)
    q = deque()
    for x in range(w):
        for y in (0, h - 1):
            if podobne[y, x] and not maska[y, x]:
                maska[y, x] = True
                q.append((y, x))
    for y in range(h):
        for x in (0, w - 1):
            if podobne[y, x] and not maska[y, x]:
                maska[y, x] = True
                q.append((y, x))
    while q:
        y, x = q.popleft()
        for ny, nx in ((y + 1, x), (y - 1, x), (y, x + 1), (y, x - 1)):
            if 0 <= ny < h and 0 <= nx < w and podobne[ny, nx] and not maska[ny, nx]:
                maska[ny, nx] = True
                q.append((ny, nx))
    # zamknięte "dziury" tła (np. między ręką a płaszczem) też usuwamy,
    # jeśli są na tyle duże, że to nie szary detal stroju
    etykiety, n = ndimage.label(podobne & ~maska)
    if n:
        rozmiary = ndimage.sum(np.ones_like(etykiety), etykiety, range(1, n + 1))
        duze = np.nonzero(rozmiary > 150)[0] + 1
        maska |= np.isin(etykiety, duze)
    alfa = Image.fromarray(np.where(maska, 0, 255).astype(np.uint8))
    # lekkie zmiękczenie krawędzi, żeby nie było szarej obwódki
    alfa = alfa.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(0.8))
    out = im.convert("RGBA")
    out.putalpha(alfa)
    out.save(dst)


if __name__ == "__main__":
    wytnij(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 34)
