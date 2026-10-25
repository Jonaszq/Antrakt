extends Node
## Menu główne (pierwsza scena gry): Nowa gra, Wybierz scenę, Ustawienia, Wyjdź.
## Tło to teatr w deszczu z filmiku wstępnego. Nowa gra zaczyna od filmiku.
## "Wybierz scenę" to skrót do testowania: od razu skacze do danej sceny.

const WSTEP := "res://wstep/wstep.tscn"
const SCENY := [
	["Scena 1: Foyer", "res://sceny/scena1/scena1.tscn"],
	["Scena 2: Kulisy", "res://sceny/scena2/scena2.tscn"],
	["Scena 3: Akt pierwszy", "res://sceny/scena3/scena3.tscn"],
	["Scena 3: Antrakt", "res://sceny/scena3/antrakt.tscn"],
	["Scena 3: Akt drugi", "res://sceny/scena3/scena3_akt2.tscn"],
	["Scena 4: Bankiet", "res://sceny/scena4/scena4.tscn"],
	["Scena 5: Telefon i jazda", "res://sceny/scena5/scena5.tscn"],
	["Scena 6: Magazyn (rozdz. 2)", "res://sceny/scena6/scena6.tscn"],
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
	_lista.ustaw([
		["Nowa gra", _nowa_gra],
		["Wybierz scenę", _sceny],
		["Ustawienia", _ustawienia],
		["Wyjdź z gry", get_tree().quit],
	])


func _sceny() -> void:
	var pozycje := []
	for i in SCENY.size():
		pozycje.append([SCENY[i][0], _start.bind(SCENY[i][1], i > 0)])
	pozycje.append(["Wróć", _glowne])
	_pokaz_naglowek(false)
	_lista.ustaw(pozycje)


## Lista scen jest długa, więc na ten czas tytuł znika, a lista idzie do góry.
func _pokaz_naglowek(widoczny: bool) -> void:
	for l in _naglowek:
		l.visible = widoczny
	_lista.position.y = 118 if widoczny else 24


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
	_start(WSTEP, false)


## Ściemnia ekran i uruchamia scenę od zera. Od sceny 2 notes jest już włączony.
func _start(scena: String, z_notesem: bool) -> void:
	Gra.nowa_gra()
	if z_notesem:
		Notatnik.wlacz()
	_lista.visible = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 0.6)
	await tw.finished
	get_tree().change_scene_to_file(scena)
