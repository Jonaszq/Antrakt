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
- Rozdział 3 (w budowie): scena 9 w foyer w żałobie i w gabinecie Lisa (`sceny/scena9`, nowa mapa `mapy/gabinet`): kwit z pralni pod popielniczką, Ania chce sama odebrać kostium, bufetowa, rękawiczki w apteczce.
- Scena 10 w pralni pani Haliny (`sceny/scena10`, mapa `mapy/pralnia`): gracz sam szuka kostiumu 0412 na stojakach, fotografuje plamę pod lampą, książka przyjęć daje kartę "kwit". Jeśli w scenie 9 oddał kwit Ani, kostiumu już nie ma.
- Scena 11 w pracowni kostiumów (`sceny/scena11`, mapa `mapy/pracownia` z `tools/mapy_teatr.py`): Irena mówi o podszewce dopiero po zdjęciu plamy albo pasów, nożyczki można wziąć, gdy stoi przy oknie, karta "podszewka", zdjęcie z próby, opaska.
- Scena 12 w pralni, poniedziałek (`sceny/scena12`): lampa UV z szafki pod ladą tylko, gdy Halina obsługuje klienta albo kuriera, podszewka bez rękawiczek parzy, Ania chce zabrać kostium (wybór: Halina albo Ania, pół dnia straty).
- Scena 13 (`sceny/scena13`): pralnia we wtorek (wycięcie próbki nożyczkami do woreczka), samochód z planem miasta (`samochod.gd`, `ui/plan_miasta.png`, zła jazda kosztuje czas), laboratorium (nowa mapa `mapy/laboratorium`), telefon z wynikiem i Nowicki. Potem retrospekcja 2 (`sceny/retrospekcje/retro2`): czwartkowa próba, nieznani jako czarne sylwetki.
- Scena 14 (`sceny/scena14`, nowa mapa `mapy/garderoba_wolskiego`): garderoba Wolskiego we wtorek przed spektaklem. Najpierw trzeba znaleźć perukę, potem powiedzieć Wolskiemu wprost, że to on miał zginąć, i pokazać dowód. Pani Stasia z bukietem, plakat "HAMLET 1998", szpara w drzwiach przy wyjściu.
- Scena 15 (`sceny/scena15`): Irena w pracowni w środę. Papierosy ją uspokajają, telefon na korytarzu wyciąga ją z pracowni (wtedy klucze do szafy z belami), spis tkanin na regale, paragon w skrzynce pod stołem. Na tablicy podejrzanych jest teraz też Kuba.
- Scena 16 (`sceny/scena16`, opcjonalna, wybór przy wyjściu ze sceny 15): gabinet Lisa pod jego nieobecność. Kluczyk za kalendarzem, polisa w szufladzie, telefon od wierzyciela, Lis wraca. Potwierdzenie z banku w teczkach dopiero, gdy Lis o nim powie.
- Scena 17 (`sceny/scena17`, nowa mapa `mapy/mieszkanie_adriana` z klatką): klucz od Ani, ładowanie telefonu (ładowarka od Zenona albo od sąsiadki), PIN do odgadnięcia (3 złe próby = godzina straty), SMS z czwartku, sąsiadka, Kuba ucieka po schodach.
- Teczka dowodów i tablica podejrzanych pod F (`ui/teczka.gd`, karty w `Dialogi.KARTY`). Rozmowy jak przesłuchanie: `ScenaGry.przesluchanie()` (tematy i pokazywanie dowodów).
- Ludzie w tle i odgłosy: postacie rysuje `tools/postacie_pixel.py`, dźwięki tła (gwar, dzwonek, telefon, flesz, oklaski, gramofon, auto) `tools/dzwieki_tla.py`, ujęcia auta i bramy `tools/jazda_pixel.py`.
- Klawisze: WASD chodzenie, E rozmowa i przeszukiwanie, I ekwipunek, T notes (gracz pisze sam, Esc zamyka), Q telefon, Tab wybór postaci (Antoni albo Antoni z latarnią). Telefon, wybór postaci i dialogi działają też myszką (klik, w telefonie prawy klik cofa, kółko przewija).
- Mapy do swobodnego chodzenia: `mapy/<nazwa>/<nazwa>.tscn` (otwórz i naciśnij F6).
- Grafiki rysują skrypty w `tools/`, czcionka to Atkinson Hyperlegible Next (licencja OFL, `fonty/OFL.txt`); Jersey 10 zostaje tylko do napisów rysowanych na obrazkach.
- Przedmioty: nazwy i opisy w `dialogi/dialogi.gd` (PRZEDMIOTY, SKRZYNKI), ikonki w `ui/przedmioty/` z `tools/przedmioty_pixel.py`.
- Dialogi: popiersia nad ramką (Antoni po lewej, rozmówca po prawej), lista mówców w `ui/dialog.gd` (PORTRETY). Własny portret: wrzuć `postacie/<postać>/portret.png`, gra weźmie go zamiast powiększonego sprite'a.
- Obraz: świat 640x360, okienka rysowane w 480x270 i powiększane o 4/3 (`Gra.SKALA_UI`).
