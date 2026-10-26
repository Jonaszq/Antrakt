extends CanvasLayer
## Notes Antoniego pod klawiszem T (singleton "Notatnik").
## Gracz sam wpisuje w nim notatki, gra niczego tu nie dopisuje.
## Escape albo klik obok kartki zamyka notes. Tekst zostaje między scenami
## (Notatnik.tekst) i zapisuje się na dysku przy każdej zmianie (PLIK), więc
## przetrwa zamknięcie gry i start sceny z menu. Czyści go tylko "Nowa gra".

const PLIK := "user://notes.txt"

## Notes jest wyłączony, dopóki scena nie zawoła Notatnik.wlacz()
## (w scenie 1 po podsłuchaniu Ani, razem z samouczkiem).
var aktywny := false

var _kartka: NinePatchRect
var _pole: TextEdit
var _rada: PanelContainer
var _rada_tekst: Label


## Wszystko, co gracz zapisał.
var tekst: String:
	get:
		return _pole.text
	set(wartosc):
		_pole.text = wartosc
		_zapisz()


func _ready() -> void:
	layer = 30
	scale = Gra.SKALA_UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	_kartka = NinePatchRect.new()
	_kartka.texture = preload("res://ui/kartka.png")
	for strona in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		_kartka.set_patch_margin(strona, 6)
	_kartka.position = Vector2(80, 30)
	_kartka.size = Vector2(320, 230)
	_kartka.visible = false
	add_child(_kartka)
	var tytul := _etykieta("Notes", 24, Color8(60, 40, 32))
	tytul.add_theme_font_override("font", preload("res://fonty/AtkinsonHyperlegibleNext-Bold.ttf"))
	tytul.position = Vector2(18, 2)
	_kartka.add_child(tytul)
	var margines := ColorRect.new()
	margines.color = Color8(196, 78, 66)
	margines.position = Vector2(12, 34)
	margines.size = Vector2(1, 180)
	_kartka.add_child(margines)
	_pole = TextEdit.new()
	_pole.position = Vector2(14, 34)
	_pole.size = Vector2(298, 176)
	_pole.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	_pole.placeholder_text = "Pisz tutaj. Notuj wszystko, co może się przydać: kto co powiedział, gdzie i kiedy."
	_pole.add_theme_font_size_override("font_size", 12)
	_pole.add_theme_color_override("font_color", Color8(40, 34, 60))
	_pole.add_theme_color_override("font_placeholder_color", Color8(150, 132, 108))
	_pole.add_theme_color_override("caret_color", Color8(40, 34, 60))
	_pole.add_theme_color_override("selection_color", Color8(220, 196, 140))
	for styl in ["normal", "focus", "read_only"]:
		_pole.add_theme_stylebox_override(styl, StyleBoxEmpty.new())
	_kartka.add_child(_pole)
	_pole.text = _wczytaj()
	_pole.text_changed.connect(_zapisz)
	var podpis := _etykieta("Esc – zamknij", 12, Color8(150, 132, 108))
	podpis.position = Vector2(226, 210)
	_kartka.add_child(podpis)

	# żółta karteczka z radą nad notesem (samouczek)
	_rada = PanelContainer.new()
	var styl := StyleBoxFlat.new()
	styl.bg_color = Color8(242, 212, 126)
	styl.border_color = Color8(20, 12, 14)
	styl.set_border_width_all(1)
	styl.set_content_margin_all(4)
	_rada.add_theme_stylebox_override("panel", styl)
	_rada.position = Vector2(348, 40)
	_rada.rotation = deg_to_rad(2.0)
	_rada_tekst = _etykieta("", 12, Color8(40, 30, 30))
	_rada_tekst.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_rada_tekst.custom_minimum_size.x = 118
	_rada_tekst.add_theme_constant_override("line_spacing", -3)
	_rada.add_child(_rada_tekst)
	_rada.visible = false
	add_child(_rada)


func _etykieta(napis: String, rozmiar: int, kolor: Color) -> Label:
	var l := Label.new()
	l.text = napis
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", kolor)
	return l


func _wczytaj() -> String:
	var plik := FileAccess.open(PLIK, FileAccess.READ)
	return plik.get_as_text() if plik else ""


func _zapisz() -> void:
	var plik := FileAccess.open(PLIK, FileAccess.WRITE)
	if plik:
		plik.store_string(_pole.text)


func wlacz() -> void:
	aktywny = true


func otwarty() -> bool:
	return _kartka.visible


## Otwiera notes z karteczką z radą (samouczek). Czeka, aż gracz go zamknie.
func samouczek(rada: String) -> void:
	_rada_tekst.text = rada
	_rada.reset_size()
	_rada.visible = true
	_kartka.position.x = 20  # notes w lewo, karteczka obok po prawej
	_otworz()
	while _kartka.visible:
		await (Engine.get_main_loop() as SceneTree).process_frame
	_rada.visible = false
	_kartka.position.x = 80


func _otworz() -> void:
	_kartka.visible = true
	_pole.grab_focus()
	_pole.set_caret_line(_pole.get_line_count() - 1)
	_pole.set_caret_column(_pole.get_line(_pole.get_line_count() - 1).length())


func _zamknij() -> void:
	_zapisz()
	_pole.release_focus()
	_kartka.visible = false


func _input(zdarzenie: InputEvent) -> void:
	if not _kartka.visible:
		return
	# Escape zamyka, zanim pole tekstowe go zje
	var k := zdarzenie as InputEventKey
	if k and k.pressed and k.physical_keycode == KEY_ESCAPE:
		_zamknij()
		get_viewport().set_input_as_handled()
		return
	var m := zdarzenie as InputEventMouseButton
	if m and m.pressed and m.button_index == MOUSE_BUTTON_LEFT:
		var poz: Vector2 = transform.affine_inverse() * m.position
		if not Rect2(_kartka.position, _kartka.size).has_point(poz):
			_zamknij()  # klik obok kartki
			get_viewport().set_input_as_handled()


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if k and k.pressed and not k.echo and k.physical_keycode == KEY_T and aktywny:
		if Gra.okno_otwarte():
			return  # przy otwartym notesie T to zwykła litera w polu tekstowym
		_otworz()
		get_viewport().set_input_as_handled()
