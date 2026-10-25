# Antrakt

Gra „Ostatni akt”: kryminał w teatrze, Godot 4.4, pixel art 480×270 powiększony ×4.

## Jak otworzyć projekt

1. Zainstaluj [GitHub Desktop](https://desktop.github.com/) i zaloguj się na swoje konto GitHub.
2. File → Clone repository → wybierz `Jonaszq/Antrakt` → wskaż folder na dysku → Clone.
3. W Godocie: Import → wskaż plik `project.godot` z tego folderu → Import & Edit.

## Jak pobrać nowe zmiany

1. W GitHub Desktop kliknij **Fetch origin**, a potem **Pull origin**.
2. Wróć do Godota. Sam przeładuje zmienione pliki (jeśli zapyta, wybierz „Reload”).

Nie trzeba niczego rozpakowywać ani podmieniać ręcznie.

## Co jest w grze

- **F5** uruchamia grę od menu głównego (`menu/menu.tscn`): Nowa gra (filmik wstępny, `wstep/wstep.tscn`), Wybierz scenę (skrót do testów), Ustawienia, Wyjdź. W filmiku Spacja przewija ujęcie, Escape pomija filmik. W grze Escape to pauza z wyjściem do menu.
- Rozdział 1 (około 25 do 30 minut): scena 1 w foyer, zgubiony bilet, szatnia i plotki (`sceny/scena1/scena1.tscn`), scena 2 w kulisach z szukaniem noża i garderobą Ani (`sceny/scena2/scena2.tscn`, `garderoba.tscn`), scena 3: akt pierwszy na widowni, antrakt w foyer i akt drugi (`sceny/scena3/scena3.tscn`, `antrakt.tscn`, `scena3_akt2.tscn`), scena 4, bankiet z toastem i awanturą Ireny (`sceny/scena4/scena4.tscn`), scena 5, telefon, jazda autem w deszczu i brama magazynu (`sceny/scena5/scena5.tscn`). Na końcu licznik "5 dni do pogrzebu".
- Rozdział 2: scena 6 w ciemnym magazynie dekoracji (`sceny/scena6`, mapa `mapy/magazyn`), scena 7 w budce stróża (`sceny/scena7`), pierwsza retrospekcja (`sceny/retrospekcje/retro1.tscn`) i scena 8 na placu przed magazynem (`sceny/scena8`, mapa `mapy/plac`): taksówka z Anią i Wolskim, koniec rozdziału.
- Teczka dowodów i tablica podejrzanych pod F (`ui/teczka.gd`, karty w `Dialogi.KARTY`). Rozmowy jak przesłuchanie: `ScenaGry.przesluchanie()` (tematy i pokazywanie dowodów).
- Ludzie w tle i odgłosy: postacie rysuje `tools/postacie_pixel.py`, dźwięki tła (gwar, dzwonek, telefon, flesz, oklaski, gramofon, auto) `tools/dzwieki_tla.py`, ujęcia auta i bramy `tools/jazda_pixel.py`.
- Klawisze: WASD chodzenie, E rozmowa i przeszukiwanie, I ekwipunek, T notes (gracz pisze sam, Esc zamyka), Q telefon, Tab wybór postaci (Antoni albo Antoni z latarnią). Telefon, wybór postaci i dialogi działają też myszką (klik, w telefonie prawy klik cofa, kółko przewija).
- Mapy do swobodnego chodzenia: `mapy/<nazwa>/<nazwa>.tscn` (otwórz i naciśnij F6).
- Grafiki rysują skrypty w `tools/`, czcionka to Atkinson Hyperlegible Next (licencja OFL, `fonty/OFL.txt`); Jersey 10 zostaje tylko do napisów rysowanych na obrazkach.
- Przedmioty: nazwy i opisy w `dialogi/dialogi.gd` (PRZEDMIOTY, SKRZYNKI), ikonki w `ui/przedmioty/` z `tools/przedmioty_pixel.py`.
- Dialogi: popiersia nad ramką (Antoni po lewej, rozmówca po prawej), lista mówców w `ui/dialog.gd` (PORTRETY). Własny portret: wrzuć `postacie/<postać>/portret.png`, gra weźmie go zamiast powiększonego sprite'a.
- Obraz: świat 640x360, okienka rysowane w 480x270 i powiększane o 4/3 (`Gra.SKALA_UI`).
