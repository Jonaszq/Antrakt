extends CanvasLayer
## Notes Antoniego, dostępny w całej grze pod klawiszem T (singleton "Notatnik").
## Sceny dopisują tropy przez Notatnik.dodaj("..."). Na razie to prosta lista
## wpisów; łączenie tropów dorobi wątek mechaniki gry.

signal dodano(wpis: String)

var wpisy: PackedStringArray = []

var _kartka: NinePatchRect
var _lista: Label
var _dymek: PanelContainer
var _dymek_tekst: Label
var _dymek_czas := 0.0


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	_kartka = NinePatchRect.new()
	_kartka.texture = preload("res://ui/kartka.png")
	for strona in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		_kartka.set_patch_margin(strona, 6)
	_kartka.position = Vector2(80, 16)
	_kartka.size = Vector2(320, 238)
	_kartka.visible = false
	add_child(_kartka)
	var tytul := _etykieta("Notes", 32, Color8(60, 40, 32))
	tytul.position = Vector2(16, 2)
	_kartka.add_child(tytul)
	var margines := ColorRect.new()
	margines.color = Color8(196, 78, 66)
	margines.position = Vector2(12, 36)
	margines.size = Vector2(1, 196)
	_kartka.add_child(margines)
	_lista = _etykieta("", 16, Color8(40, 34, 60))
	_lista.position = Vector2(18, 36)
	_lista.size = Vector2(292, 176)
	_lista.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_kartka.add_child(_lista)
	var podpis := _etykieta("T – zamknij", 16, Color8(150, 132, 108))
	podpis.position = Vector2(206, 214)
	_kartka.add_child(podpis)

	_dymek = PanelContainer.new()
	var styl := StyleBoxFlat.new()
	styl.bg_color = Color8(232, 222, 196)
	styl.border_color = Color8(20, 12, 14)
	styl.set_border_width_all(1)
	styl.content_margin_left = 4
	styl.content_margin_right = 4
	styl.content_margin_top = -1
	styl.content_margin_bottom = 0
	_dymek.add_theme_stylebox_override("panel", styl)
	_dymek_tekst = _etykieta("", 16, Color8(40, 34, 60))
	_dymek.add_child(_dymek_tekst)
	_dymek.position = Vector2(6, 6)
	_dymek.visible = false
	add_child(_dymek)


func _etykieta(tekst: String, rozmiar: int, kolor: Color) -> Label:
	var l := Label.new()
	l.text = tekst
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", kolor)
	return l


## Dopisuje trop do notesu i na chwilę pokazuje dymek w rogu ekranu.
func dodaj(wpis: String) -> void:
	if wpis in wpisy:
		return
	wpisy.append(wpis)
	_odswiez()
	_dymek_tekst.text = "Nowy wpis w notesie  [T]"
	_dymek.reset_size()
	_dymek.visible = true
	_dymek_czas = 4.0
	dodano.emit(wpis)


func otwarty() -> bool:
	return _kartka.visible


func _odswiez() -> void:
	var tekst := ""
	for w in wpisy:
		tekst += "• " + w + "\n"
	_lista.text = tekst if tekst != "" else "Na razie pusto."


func _process(delta: float) -> void:
	if _dymek_czas > 0.0:
		_dymek_czas -= delta
		_dymek.visible = _dymek_czas > 0.0


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if k and k.pressed and not k.echo and k.physical_keycode == KEY_T:
		if not _kartka.visible and Gra.okno_otwarte():
			return
		_odswiez()
		_kartka.visible = not _kartka.visible
		_dymek.visible = false
		get_viewport().set_input_as_handled()
