extends CanvasLayer
## Pauza pod Escape (singleton "Pauza"), działa w scenach na mapach.
## Wróć do gry, Ustawienia, Wyjdź do menu, Wyjdź z gry. Escape zamyka pauzę.

const MENU := "res://menu/menu.tscn"

var _tlo: ColorRect
var _lista: MenuLista


func _ready() -> void:
	layer = 40
	scale = Gra.SKALA_UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	_tlo = ColorRect.new()
	_tlo.color = Color(0.03, 0.02, 0.04, 0.78)
	_tlo.size = Vector2(480, 270)
	_tlo.visible = false
	add_child(_tlo)
	var tytul := Label.new()
	tytul.text = "Pauza"
	tytul.position = Vector2(166, 60)
	tytul.add_theme_font_size_override("font_size", 24)
	tytul.add_theme_font_override("font", preload("res://fonty/AtkinsonHyperlegibleNext-Bold.ttf"))
	tytul.add_theme_color_override("font_color", MenuLista.ZLOTO)
	_tlo.add_child(tytul)
	_lista = MenuLista.new()
	_lista.position = Vector2(166, 100)
	_tlo.add_child(_lista)


func otwarta() -> bool:
	return _tlo.visible


func otworz() -> void:
	_tlo.visible = true
	get_tree().paused = true
	_glowne()


func zamknij() -> void:
	_tlo.visible = false
	get_tree().paused = false


func _glowne() -> void:
	_lista.ustaw([
		["Wróć do gry", zamknij],
		["Ustawienia", _ustawienia],
		["Wyjdź do menu", _do_menu],
		["Wyjdź z gry", get_tree().quit],
	])


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


func _do_menu() -> void:
	zamknij()
	get_tree().change_scene_to_file(MENU)


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo or k.physical_keycode != KEY_ESCAPE:
		return
	if _tlo.visible:
		zamknij()
	elif get_tree().current_scene is ScenaGry and not Gra.okno_otwarte():
		otworz()
	else:
		return
	get_viewport().set_input_as_handled()
