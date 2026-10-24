class_name Dialog
extends CanvasLayer
## Okienko rozmowy na dole ekranu. Tekst pojawia się litera po literze,
## E, spacja albo Enter pokazuje całą kwestię, a potem przechodzi do następnej.
##
## Użycie w scenie:
##     var dialog := Dialog.new()
##     add_child(dialog)
##     await dialog.pokaz([["Ania", "Adrian, odezwij się."], ["Antoni", "Hm."]])
## Pusty mówca ("") to narracja bez ramki z imieniem.

signal skonczony

const LITER_NA_SEKUNDE := 40.0

## Większe od zera: kwestie przechodzą same po tylu sekundach (w filmikach).
var auto := 0.0

## Okienko u góry ekranu, gdy na dole dzieje się coś ważnego.
var u_gory := false

var _kwestie: Array = []
var _numer := 0
var _czas := 0.0
var _okno: NinePatchRect
var _tekst: Label
var _imie_tlo: NinePatchRect
var _imie: Label
var _strzalka: TextureRect


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_okno = _ramka(preload("res://ui/ramka.png"), 6, Rect2(8, 192, 464, 72))
	_tekst = Label.new()
	_tekst.position = Vector2(10, 5)
	_tekst.size = Vector2(444, 62)
	_tekst.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tekst.add_theme_font_size_override("font_size", 16)
	_tekst.add_theme_color_override("font_color", Color8(236, 226, 200))
	_tekst.add_theme_constant_override("line_spacing", -2)
	_okno.add_child(_tekst)
	_strzalka = TextureRect.new()
	_strzalka.texture = preload("res://ui/strzalka.png")
	_strzalka.position = Vector2(450, 62)
	_okno.add_child(_strzalka)
	_imie_tlo = _ramka(preload("res://ui/imie.png"), 4, Rect2(14, 174, 60, 20))
	_imie = Label.new()
	_imie.position = Vector2(6, -1)
	_imie.add_theme_font_size_override("font_size", 16)
	_imie.add_theme_color_override("font_color", Color8(242, 212, 126))
	_imie_tlo.add_child(_imie)
	visible = false


func _ramka(tekstura: Texture2D, margines: int, prost: Rect2) -> NinePatchRect:
	var r := NinePatchRect.new()
	r.texture = tekstura
	r.patch_margin_left = margines
	r.patch_margin_right = margines
	r.patch_margin_top = margines
	r.patch_margin_bottom = margines
	r.position = prost.position
	r.size = prost.size
	add_child(r)
	return r


## Pokazuje listę kwestii [mówca, tekst] i czeka, aż gracz je przeczyta.
func pokaz(kwestie: Array) -> void:
	_kwestie = kwestie
	_numer = 0
	_okno.position.y = 22 if u_gory else 192
	_imie_tlo.position.y = _okno.position.y - 18
	visible = true
	_ustaw()
	await skonczony


func trwa() -> bool:
	return visible


func _ustaw() -> void:
	var kto: String = _kwestie[_numer][0]
	_tekst.text = _kwestie[_numer][1]
	_tekst.visible_characters = 0
	_czas = 0.0
	_imie_tlo.visible = kto != ""
	_imie.text = kto
	_imie_tlo.size.x = _imie.get_minimum_size().x + 12


func _process(delta: float) -> void:
	if not visible:
		return
	_czas += delta
	var ile := int(_czas * LITER_NA_SEKUNDE)
	var wszystkie := _tekst.get_total_character_count()
	_tekst.visible_characters = mini(ile, wszystkie)
	var gotowe := ile >= wszystkie
	_strzalka.visible = gotowe and fmod(_czas, 0.8) < 0.5
	if auto > 0.0 and gotowe and _czas > wszystkie / LITER_NA_SEKUNDE + auto:
		_dalej()


func _unhandled_input(zdarzenie: InputEvent) -> void:
	if not visible or not zdarzenie is InputEventKey:
		return
	var k := zdarzenie as InputEventKey
	if not k.pressed or k.echo:
		return
	if k.physical_keycode in [KEY_E, KEY_SPACE, KEY_ENTER, KEY_KP_ENTER]:
		get_viewport().set_input_as_handled()
		if _tekst.visible_characters < _tekst.get_total_character_count():
			_czas = 1000.0  # pokaż od razu całą kwestię
		else:
			_dalej()


func _dalej() -> void:
	_numer += 1
	if _numer >= _kwestie.size():
		visible = false
		skonczony.emit()
	else:
		_ustaw()
