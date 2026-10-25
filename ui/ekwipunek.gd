extends CanvasLayer
## Ekwipunek Antoniego pod klawiszem I (singleton "Ekwipunek").
## Sceny dają przedmioty przez Ekwipunek.dodaj("kanapka"); nazwy, opisy i siły są
## w dialogi/dialogi.gd (PRZEDMIOTY), ikonki w ui/przedmioty/.
## W okienku: WASD albo mysz wybiera, E (albo klik w "zjedz") zjada jedzenie,
## I, Escape albo klik obok zamyka. Na dole pasek sił (Gra.sily).

const KOLUMNY := 6
const RZEDY := 4
const POLE := 26  # rozmiar kratki w pikselach gry
const SIATKA := Vector2(12, 30)  # lewy górny róg siatki w okienku

## Przedmioty w kolejności zdobycia (identyfikatory z Dialogi.PRZEDMIOTY).
var przedmioty: PackedStringArray = []

var _okno: NinePatchRect
var _siatka: Control
var _nazwa: Label
var _opis: Label
var _akcja: Label
var _pasek: ColorRect
var _sily_napis: Label
var _dymek: PanelContainer
var _dymek_tekst: Label
var _dymek_czas := 0.0
var _wybor := 0


func _ready() -> void:
	layer = 30
	scale = Gra.SKALA_UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	_okno = NinePatchRect.new()
	_okno.texture = preload("res://ui/ramka.png")
	for strona in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		_okno.set_patch_margin(strona, 6)
	_okno.position = Vector2(40, 30)
	_okno.size = Vector2(400, 210)
	_okno.visible = false
	add_child(_okno)
	var tytul := _etykieta("Ekwipunek", 12, Color8(242, 212, 126))
	tytul.position = Vector2(12, 6)
	_okno.add_child(tytul)
	_siatka = Control.new()
	_siatka.position = SIATKA
	_okno.add_child(_siatka)
	_nazwa = _etykieta("", 12, Color8(242, 212, 126))
	_nazwa.add_theme_font_override("font", preload("res://fonty/AtkinsonHyperlegibleNext-Bold.ttf"))
	_nazwa.position = Vector2(180, 28)
	_nazwa.custom_minimum_size.x = 208
	_nazwa.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_okno.add_child(_nazwa)
	_opis = _etykieta("", 12, Color8(236, 226, 200))
	_opis.position = Vector2(180, 48)
	_opis.custom_minimum_size.x = 208
	_opis.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_opis.add_theme_constant_override("line_spacing", -2)
	_okno.add_child(_opis)
	_akcja = _etykieta("", 12, Color8(150, 220, 140))
	_akcja.position = Vector2(180, 148)
	_okno.add_child(_akcja)
	_sily_napis = _etykieta("Siły", 12, Color8(170, 160, 140))
	_sily_napis.position = Vector2(12, 172)
	_okno.add_child(_sily_napis)
	var tlo_paska := ColorRect.new()
	tlo_paska.color = Color8(40, 30, 34)
	tlo_paska.position = Vector2(48, 178)
	tlo_paska.size = Vector2(122, 8)
	_okno.add_child(tlo_paska)
	_pasek = ColorRect.new()
	_pasek.color = Color8(110, 190, 90)
	_pasek.position = Vector2(49, 179)
	_pasek.size = Vector2(120, 6)
	_okno.add_child(_pasek)
	var pomoc := _etykieta("I albo Esc – zamknij", 12, Color8(170, 160, 140))
	pomoc.position = Vector2(270, 186)
	_okno.add_child(pomoc)

	_dymek = PanelContainer.new()
	var styl := StyleBoxFlat.new()
	styl.bg_color = Color8(232, 222, 196)
	styl.border_color = Color8(20, 12, 14)
	styl.set_border_width_all(1)
	styl.set_content_margin_all(3)
	_dymek.add_theme_stylebox_override("panel", styl)
	_dymek_tekst = _etykieta("", 12, Color8(40, 34, 60))
	_dymek.add_child(_dymek_tekst)
	_dymek.position = Vector2(6, 6)
	_dymek.visible = false
	add_child(_dymek)


func _etykieta(napis: String, rozmiar: int, kolor: Color) -> Label:
	var l := Label.new()
	l.text = napis
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", kolor)
	return l


func otwarty() -> bool:
	return _okno.visible


func ma(id: String) -> bool:
	return id in przedmioty


## Daje Antoniemu przedmiot i na chwilę pokazuje dymek w rogu ekranu.
func dodaj(id: String) -> void:
	if not Dialogi.PRZEDMIOTY.has(id):
		push_error("Nie ma przedmiotu \"%s\" w Dialogi.PRZEDMIOTY" % id)
		return
	przedmioty.append(id)
	_dymek_tekst.text = "Nowy przedmiot: %s   [I]" % Dialogi.PRZEDMIOTY[id][0]
	_dymek.reset_size()
	_dymek.visible = true
	_dymek_czas = 3.5
	if _okno.visible:
		_rysuj()


func usun(id: String) -> void:
	var i := przedmioty.find(id)
	if i >= 0:
		przedmioty.remove_at(i)


func _process(delta: float) -> void:
	if _dymek_czas > 0.0:
		_dymek_czas -= delta
		_dymek.visible = _dymek_czas > 0.0


func _rysuj() -> void:
	for dziecko in _siatka.get_children():
		dziecko.queue_free()
	_wybor = clampi(_wybor, 0, KOLUMNY * RZEDY - 1)
	for i in KOLUMNY * RZEDY:
		var kratka := ColorRect.new()
		kratka.position = Vector2(i % KOLUMNY, i / KOLUMNY) * POLE
		kratka.size = Vector2(POLE - 2, POLE - 2)
		kratka.color = Color8(242, 212, 126) if i == _wybor else Color8(70, 56, 50)
		_siatka.add_child(kratka)
		var wnetrze := ColorRect.new()
		wnetrze.position = Vector2.ONE
		wnetrze.size = kratka.size - Vector2(2, 2)
		wnetrze.color = Color8(30, 22, 26)
		kratka.add_child(wnetrze)
		if i < przedmioty.size():
			var ikona := TextureRect.new()
			ikona.texture = load("res://ui/przedmioty/%s.png" % przedmioty[i])
			ikona.position = Vector2(2, 2)
			wnetrze.add_child(ikona)
	if _wybor < przedmioty.size():
		var p: Array = Dialogi.PRZEDMIOTY[przedmioty[_wybor]]
		_nazwa.text = p[0]
		_opis.text = p[1]
		_akcja.text = {"jedzenie": "E – zjedz", "picie": "E – wypij"}.get(p[2], "")
	else:
		_nazwa.text = ""
		_opis.text = "Pusto." if przedmioty.is_empty() else ""
		_akcja.text = ""
	_pasek.size.x = 120.0 * Gra.sily / 100.0
	_sily_napis.text = "Siły"


func _uzyj() -> void:
	if _wybor >= przedmioty.size():
		return
	var id := przedmioty[_wybor]
	var p: Array = Dialogi.PRZEDMIOTY[id]
	if p[2] not in ["jedzenie", "picie"]:
		return
	Gra.dodaj_sily(p[3])
	if id == "kawa":
		Gra.wypij_kawe()
	przedmioty.remove_at(_wybor)
	_rysuj()


func _przelacz() -> void:
	_okno.visible = not _okno.visible
	if _okno.visible:
		_rysuj()


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo:
		return
	if not _okno.visible:
		if k.physical_keycode == KEY_I and not Gra.okno_otwarte():
			_przelacz()
			get_viewport().set_input_as_handled()
		return
	get_viewport().set_input_as_handled()
	match k.physical_keycode:
		KEY_I, KEY_ESCAPE:
			_okno.visible = false
			return
		KEY_A, KEY_LEFT:
			_wybor -= 1
		KEY_D, KEY_RIGHT:
			_wybor += 1
		KEY_W, KEY_UP:
			_wybor -= KOLUMNY
		KEY_S, KEY_DOWN:
			_wybor += KOLUMNY
		KEY_E, KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
			_uzyj()
	_rysuj()


func _input(zdarzenie: InputEvent) -> void:
	if not _okno.visible or not zdarzenie is InputEventMouse:
		return
	get_viewport().set_input_as_handled()
	var poz: Vector2 = transform.affine_inverse() * (zdarzenie as InputEventMouse).position - _okno.position
	var w := poz - SIATKA
	var pod := -1
	if w.x >= 0 and w.y >= 0 and w.x < KOLUMNY * POLE and w.y < RZEDY * POLE:
		pod = int(w.y / POLE) * KOLUMNY + int(w.x / POLE)
	var m := zdarzenie as InputEventMouseButton
	if not m:
		if pod >= 0 and pod != _wybor:
			_wybor = pod
			_rysuj()
		return
	if not m.pressed or m.button_index != MOUSE_BUTTON_LEFT:
		return
	if not Rect2(Vector2.ZERO, _okno.size).has_point(poz):
		_okno.visible = false  # klik obok okienka
	elif pod >= 0:
		_wybor = pod
		_rysuj()
	elif _akcja.text != "" and Rect2(_akcja.position, _akcja.size).has_point(poz):
		_uzyj()
