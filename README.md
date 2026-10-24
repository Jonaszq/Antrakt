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

- **F5** uruchamia grę od filmiku wstępnego (`wstep/wstep.tscn`). Spacja przewija ujęcie, Escape pomija filmik.
- Po filmiku startuje scena 1 w foyer (`sceny/scena1/scena1.tscn`), potem scena 2 w kulisach (`sceny/scena2/scena2.tscn`).
- Klawisze: WASD chodzenie, E rozmowa, T notes, Q telefon, Tab wybór postaci (Antoni albo Antoni z latarnią).
- Mapy do swobodnego chodzenia: `mapy/<nazwa>/<nazwa>.tscn` (otwórz i naciśnij F6).
- Grafiki rysują skrypty w `tools/`, czcionka to Pixelify Sans (licencja OFL, `fonty/OFL.txt`).
