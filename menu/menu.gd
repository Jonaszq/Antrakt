extends Node
## Menu główne (pierwsza scena gry): Nowa gra, Wybierz scenę, Ustawienia, Wyjdź.
## Tło to teatr w deszczu z filmiku wstępnego. Nowa gra zaczyna od filmiku.
## "Wybierz scenę" to skrót do testowania: od razu skacze do danej sceny.

const WSTEP := "res://wstep/wstep.tscn"
## Scena, w której Antoni znajduje latarkę; w późniejszych już ją ma.
const SCENA_LATARKI := ["Scena 6: Magazyn (rozdz. 2)", "res://sceny/scena6/scena6.tscn"]
## Przy starcie od rozdziału 4 z menu Antoni dostaje dowody z poprzednich rozdziałów.
const DOWODY_ROZDZ4 := ["program", "zdjecie_pasy", "zdjecie_plamy", "papierosy", "rekawiczki", "lampa_uv", "telefon_adriana", "ladowarka", "opaska", "klucz", "kwit_odbioru"]
const SCENY_ROZDZ4 := ["res://sceny/scena14/scena14.tscn", "res://sceny/scena15/scena15.tscn",
	"res://sceny/scena16/scena16.tscn", "res://sceny/scena17/scena17.tscn", "res://sceny/retrospekcje/retro3.tscn",
	"res://sceny/scena18/scena18.tscn", "res://sceny/retrospekcje/retro4.tscn", "res://sceny/scena19/scena19.tscn",
	"res://sceny/retrospekcje/retro5.tscn", "res://sceny/scena20/scena20.tscn"]

## Przy starcie od rozdziału 5 z menu: dowody pełnego śledztwa (żeby dało się sprawdzić finał).
const SCENY_ROZDZ5 := ["res://sceny/scena21/scena21.tscn", "res://sceny/scena22/scena22.tscn",
	"res://sceny/retrospekcje/retro6.tscn", "res://sceny/scena23/scena23.tscn"]
const KARTY_ROZDZ5 := ["kwit", "podpis", "sms", "marta_grafik", "rekawiczki", "przelewy", "recepta", "garnitur", "zeszyt"]
const FLAGI_ROZDZ5 := ["s9_obsada", "s11_szwy", "s11_podszewka", "s12_uv", "s14_chory", "s18_podsluch", "s19_szczegoly", "s20_lustro"]

const SCENY := [
	["Scena 1: Foyer", "res://sceny/scena1/scena1.tscn"],
	["Scena 2: Kulisy", "res://sceny/scena2/scena2.tscn"],
	["Scena 3: Akt pierwszy", "res://sceny/scena3/scena3.tscn"],
	["Scena 3: Antrakt", "res://sceny/scena3/antrakt.tscn"],
	["Scena 3: Akt drugi", "res://sceny/scena3/scena3_akt2.tscn"],
	["Scena 4: Bankiet", "res://sceny/scena4/scena4.tscn"],
	["Scena 5: Telefon i jazda", "res://sceny/scena5/scena5.tscn"],
	["Scena 6: Magazyn (rozdz. 2)", "res://sceny/scena6/scena6.tscn"],
	["Scena 7: Stróż", "res://sceny/scena7/scena7.tscn"],
	["Retrospekcja 1: Piątek w magazynie", "res://sceny/retrospekcje/retro1.tscn"],
	["Scena 8: Ania i Wolski", "res://sceny/scena8/scena8.tscn"],
	["Scena 9: Prośba dyrektora", "res://sceny/scena9/scena9.tscn"],
	["Scena 10: Pralnia", "res://sceny/scena10/scena10.tscn"],
	["Scena 11: Pracownia kostiumów", "res://sceny/scena11/scena11.tscn"],
	["Scena 11b: Kulisy w niedzielę wieczorem", "res://sceny/scena11b/scena11b.tscn"],
	["Scena 12: Pralnia, poniedziałek", "res://sceny/scena12/scena12.tscn"],
	["Scena 13: Pralnia, wtorek i laboratorium", "res://sceny/scena13/scena13.tscn"],
	["Retrospekcja 2: Czwartkowa próba", "res://sceny/retrospekcje/retro2.tscn"],
	["Scena 14: Garderoba Wolskiego (rozdz. 4)", "res://sceny/scena14/scena14.tscn"],
	["Scena 15: Irena, środa", "res://sceny/scena15/scena15.tscn"],
	["Scena 16: Gabinet Lisa", "res://sceny/scena16/scena16.tscn"],
	["Scena 17: Mieszkanie Adriana", "res://sceny/scena17/scena17.tscn"],
	["Retrospekcja 3: Czwartek wieczorem", "res://sceny/retrospekcje/retro3.tscn"],
	["Scena 18: Podsłuch w garderobie", "res://sceny/scena18/scena18.tscn"],
	["Retrospekcja 4: Wypadek", "res://sceny/retrospekcje/retro4.tscn"],
	["Scena 19: Marta i skrzynki", "res://sceny/scena19/scena19.tscn"],
	["Retrospekcja 5: Czwartek rano", "res://sceny/retrospekcje/retro5.tscn"],
	["Scena 20: Garderoba Ani", "res://sceny/scena20/scena20.tscn"],
	["Scena 21: Tablica (rozdz. 5)", "res://sceny/scena21/scena21.tscn"],
	["Scena 22: Pusta scena", "res://sceny/scena22/scena22.tscn"],
	["Retrospekcja 6: Pracownia", "res://sceny/retrospekcje/retro6.tscn"],
	["Scena 23: Brawa", "res://sceny/scena23/scena23.tscn"],
]

## Rozdziały w "Wybierz scenę": [napis, pierwszy indeks w SCENY, indeks za ostatnim].
const ROZDZIALY := [
	["Rozdział 1: Premiera", 0, 7], ["Rozdział 2: Magazyn", 7, 11],
	["Rozdział 3: Plama", 11, 18], ["Rozdział 4: Kto miał zginąć?", 18, 28],
	["Rozdział 5: Ostatni akt", 28, 32],
]

var _lista: MenuLista
var _zaslona: ColorRect
var _naglowek: Array[Label] = []  # tytuł i podtytuł, chowane przy długiej liście scen


func _ready() -> void:
	get_tree().paused = false
	var ui := CanvasLayer.new()
	ui.scale = Gra.SKALA_UI
	add_child(ui)
	var tlo := TextureRect.new()
	tlo.texture = preload("res://wstep/teatr_noc.png")
	ui.add_child(tlo)
	var deszcz := Node2D.new()
	deszcz.set_script(preload("res://wstep/deszcz.gd"))
	ui.add_child(deszcz)
	var cien := ColorRect.new()
	cien.color = Color(0.03, 0.02, 0.04, 0.72)
	cien.size = Vector2(176, 270)
	ui.add_child(cien)
	var tytul := Label.new()
	tytul.text = "Ostatni akt"
	tytul.position = Vector2(20, 44)
	tytul.add_theme_font_size_override("font_size", 32)
	tytul.add_theme_font_override("font", preload("res://fonty/AtkinsonHyperlegibleNext-Bold.ttf"))
	tytul.add_theme_color_override("font_color", MenuLista.ZLOTO)
	tytul.add_theme_constant_override("outline_size", 6)
	tytul.add_theme_color_override("font_outline_color", Color8(12, 8, 10))
	ui.add_child(tytul)
	var podtytul := Label.new()
	podtytul.text = "kryminał w teatrze"
	podtytul.position = Vector2(22, 84)
	podtytul.add_theme_font_size_override("font_size", 12)
	podtytul.add_theme_color_override("font_color", Color8(170, 160, 140))
	ui.add_child(podtytul)
	_naglowek = [tytul, podtytul]
	_lista = MenuLista.new()
	_lista.position = Vector2(20, 118)
	ui.add_child(_lista)
	var pomoc := Label.new()
	pomoc.text = "W/S albo mysz – wybór   E albo Enter – zatwierdź"
	pomoc.position = Vector2(20, 248)
	pomoc.add_theme_font_size_override("font_size", 12)
	pomoc.add_theme_color_override("font_color", Color8(150, 140, 124))
	ui.add_child(pomoc)
	_zaslona = ColorRect.new()
	_zaslona.color = Color(0, 0, 0, 0)
	_zaslona.size = Vector2(480, 270)
	_zaslona.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(_zaslona)
	var muzyka := AudioStreamPlayer.new()
	muzyka.stream = preload("res://dzwieki/muzyka/wstep.ogg")
	muzyka.volume_db = -8.0
	add_child(muzyka)
	muzyka.play()
	_glowne()


func _glowne() -> void:
	_pokaz_naglowek(true)
	var pozycje := [
		["Nowa gra", _nowa_gra],
		["Wybierz scenę", _sceny],
		["Ustawienia", _ustawienia],
		["Wyjdź z gry", get_tree().quit],
	]
	if Gra.ma_zapis():
		pozycje.push_front(["Kontynuuj", _kontynuuj])
	_lista.ustaw(pozycje)


## Wczytuje zapis i wraca na początek sceny, w której gracz skończył.
func _kontynuuj() -> void:
	var scena := Gra.wczytaj()
	if scena == "" or not ResourceLoader.exists(scena):
		return
	_lista.visible = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 0.6)
	await tw.finished
	get_tree().change_scene_to_file(scena)


func _sceny() -> void:
	var pozycje := []
	for r in ROZDZIALY:
		pozycje.append([r[0], _rozdzial.bind(r[1], r[2])])
	pozycje.append(["Wróć", _glowne])
	_pokaz_naglowek(false)
	_lista.ustaw(pozycje)


func _rozdzial(od: int, do_: int) -> void:
	var pozycje := []
	for i in range(od, mini(do_, SCENY.size())):
		pozycje.append([SCENY[i][0], _start.bind(SCENY[i][1], i > 0, i > SCENY.find(SCENA_LATARKI))])
	pozycje.append(["Wróć", _sceny])
	_pokaz_naglowek(false)
	_lista.ustaw(pozycje)


## Lista scen jest długa, więc na ten czas tytuł znika, a lista idzie do góry.
func _pokaz_naglowek(widoczny: bool) -> void:
	for l in _naglowek:
		l.visible = widoczny
	_lista.position.y = 118 if widoczny else 4
	_lista.add_theme_constant_override("separation", 4 if widoczny else 1)


func _ustawienia() -> void:
	_lista.ustaw([
		[Gra.napis_ekranu(), func() -> void:
			Gra.przelacz_pelny_ekran()
			_lista.zmien_napis(0, Gra.napis_ekranu())],
		[Gra.napis_glosnosci(), func() -> void:
			Gra.zmien_glosnosc()
			_lista.zmien_napis(1, Gra.napis_glosnosci())],
		["Wróć", _glowne],
	])


func _nowa_gra() -> void:
	Notatnik.tekst = ""  # nowa gra = czysty notes; start sceny z menu go nie rusza
	_start(WSTEP, false)
	Gra.zapisuj = true


## Ściemnia ekran i uruchamia scenę od zera. Od sceny 2 notes jest już włączony,
## a po magazynie (scena 6) Antoni ma już latarkę.
func _start(scena: String, z_notesem: bool, z_latarka := false) -> void:
	Gra.nowa_gra()
	Gra.zapisuj = false  # skok do sceny z menu to test, nie nadpisuje zapisu
	if z_notesem:
		Notatnik.wlacz()
	if z_latarka:
		Gra.latarnia_dostepna = true
		if not Ekwipunek.ma("latarka"):
			Ekwipunek.dodaj("latarka")
	if scena in SCENY_ROZDZ4 or scena in SCENY_ROZDZ5:
		for p in DOWODY_ROZDZ4:
			Ekwipunek.dodaj(p)
		Gra.flagi["s13_wynik"] = true
		Teczka.dodaj("podszewka")
	if scena in SCENY_ROZDZ5:
		Ekwipunek.dodaj("pendrive")
		for k in KARTY_ROZDZ5:
			Teczka.dodaj(k)
			Teczka.karty[k].sprawdzona = true
		for fl in FLAGI_ROZDZ5:
			Gra.flagi[fl] = true
		Gra.flagi["oskarzony"] = "Ania"
	_lista.visible = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 0.6)
	await tw.finished
	get_tree().change_scene_to_file(scena)
