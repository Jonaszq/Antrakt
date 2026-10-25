extends CanvasLayer
## Teczka dowodów pod klawiszem F (singleton "Teczka"). Osobno od notatnika:
## notatnik to wolny tekst gracza, a teczka to karty-formularze, które gra dokłada
## sama (Teczka.dodaj("paragon")). Gracz wpisuje w puste rubryki imię albo czas,
## a gra sprawdza wpis (bez wielkości liter i polskich znaków). Dobra karta dostaje
## pieczątkę "SPRAWDZONE" (Teczka.sprawdzona(id)), zła tylko "coś się nie zgadza".
## Druga zakładka to tablica podejrzanych: gracz sam ich skreśla i przywraca.
## Dane kart w Dialogi.KARTY, podejrzani w Dialogi.PODEJRZANI.

const PAPIER := Color8(232, 222, 196)
const ATRAMENT := Color8(40, 30, 30)
const ZLOTO := Color8(242, 212, 126)
const JASNY := Color8(236, 226, 200)

## Karty w kolejności zdobycia: id -> {"wpisy": [...], "sprawdzona": bool}
var karty := {}
var _kolejnosc: Array = []
## Skreśleni na tablicy (imiona z Dialogi.PODEJRZANI).
var skresleni: Array = []

var _okno: NinePatchRect
var _zakladka := 0
var _lista: VBoxContainer
var _kartka: ColorRect
var _tablica: Control
var _pole_info: Label
var _wybrana := ""


func _ready() -> void:
	layer = 30
	scale = Gra.SKALA_UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	_okno = NinePatchRect.new()
	_okno.texture = preload("res://ui/ramka.png")
	for strona in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		_okno.set_patch_margin(strona, 6)
	_okno.position = Vector2(20, 14)
	_okno.size = Vector2(440, 242)
	_okno.visible = false
	add_child(_okno)
	for i in 2:
		var b := _przycisk(["1 Teczka dowodów", "2 Podejrzani"][i], Vector2(10 + i * 130, 6), Vector2(120, 18))
		b.pressed.connect(_pokaz_zakladke.bind(i))
		_okno.add_child(b)
	_lista = VBoxContainer.new()
	_lista.position = Vector2(10, 30)
	_lista.add_theme_constant_override("separation", 2)
	_okno.add_child(_lista)
	_kartka = ColorRect.new()
	_kartka.color = PAPIER
	_kartka.position = Vector2(166, 30)
	_kartka.size = Vector2(262, 186)
	_okno.add_child(_kartka)
	_tablica = Control.new()
	_tablica.position = Vector2(10, 30)
	_okno.add_child(_tablica)
	_pole_info = _etykieta("", JASNY)
	_pole_info.position = Vector2(10, 220)
	_okno.add_child(_pole_info)


func _etykieta(tekst: String, kolor: Color) -> Label:
	var l := Label.new()
	l.text = tekst
	l.add_theme_font_size_override("font_size", 12)
	l.add_theme_color_override("font_color", kolor)
	return l


func _przycisk(tekst: String, poz: Vector2, rozmiar: Vector2) -> Button:
	var b := Button.new()
	b.text = tekst
	b.position = poz
	b.custom_minimum_size = rozmiar
	b.size = rozmiar
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.add_theme_font_size_override("font_size", 12)
	b.add_theme_color_override("font_color", JASNY)
	b.add_theme_color_override("font_hover_color", ZLOTO)
	b.add_theme_color_override("font_focus_color", ZLOTO)
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.05, 0.03, 0.04, 0.6)
	s.content_margin_left = 6
	b.add_theme_stylebox_override("normal", s)
	var h := s.duplicate()
	h.bg_color = Color(0.2, 0.12, 0.1, 0.9)
	b.add_theme_stylebox_override("hover", h)
	b.add_theme_stylebox_override("focus", h)
	b.add_theme_stylebox_override("pressed", h)
	return b


# ---------- API dla scen ----------

## Dokłada kartę do teczki (raz).
func dodaj(id: String) -> void:
	if karty.has(id):
		return
	var rubryki: Array = Dialogi.KARTY[id][3]
	var wpisy := []
	wpisy.resize(rubryki.size())
	wpisy.fill("")
	karty[id] = {"wpisy": wpisy, "sprawdzona": false}
	_kolejnosc.append(id)


func sprawdzona(id: String) -> bool:
	return karty.has(id) and karty[id].sprawdzona


func otwarty() -> bool:
	return _okno.visible


func wyczysc() -> void:
	karty.clear()
	_kolejnosc.clear()
	skresleni.clear()


## Bez wielkości liter, polskich znaków i znaków przestankowych, pojedyncze spacje.
static func uprosc(tekst: String) -> String:
	var z := "ąćęłńóśźż"
	var na := "acelnoszz"
	var wynik := ""
	for c in tekst.to_lower().strip_edges():
		var i := z.find(c)
		if i >= 0:
			wynik += na[i]
		elif c == "." or c == "," or c == ";" or c == "\"":
			continue
		else:
			wynik += c
	while wynik.contains("  "):
		wynik = wynik.replace("  ", " ")
	return wynik


# ---------- okno ----------

func _pokaz_zakladke(nr: int) -> void:
	_zakladka = nr
	_lista.visible = nr == 0
	_kartka.visible = nr == 0
	_tablica.visible = nr == 1
	_pole_info.text = ""
	if nr == 0:
		_odswiez_liste()
	else:
		_odswiez_tablice()


func _odswiez_liste() -> void:
	for d in _lista.get_children():
		d.queue_free()
	for d in _kartka.get_children():
		d.queue_free()
	if _kolejnosc.is_empty():
		var l := _etykieta(Dialogi.TECZKA_NAPISY["pusta"], ATRAMENT)
		l.position = Vector2(8, 8)
		l.size = Vector2(246, 60)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_kartka.add_child(l)
		return
	for id in _kolejnosc:
		var nazwa: String = Dialogi.KARTY[id][0]
		var b := _przycisk(("✓ " if karty[id].sprawdzona else "") + nazwa, Vector2.ZERO, Vector2(150, 18))
		b.clip_text = true
		b.pressed.connect(_pokaz_karte.bind(id))
		_lista.add_child(b)
	_pokaz_karte(_wybrana if karty.has(_wybrana) else _kolejnosc[0])


## Papierowy formularz: nazwa, gdzie znaleziony, fakt i puste rubryki do wpisania.
func _pokaz_karte(id: String) -> void:
	_wybrana = id
	for d in _kartka.get_children():
		d.queue_free()
	var k: Array = Dialogi.KARTY[id]
	var stan: Dictionary = karty[id]
	var y := 6.0
	var tytul := _etykieta(k[0], ATRAMENT)
	tytul.add_theme_font_override("font", preload("res://fonty/AtkinsonHyperlegibleNext-Bold.ttf"))
	tytul.position = Vector2(8, y)
	_kartka.add_child(tytul)
	y += 18
	var gdzie := _etykieta("Znaleziono: " + k[1], Color8(110, 90, 70))
	gdzie.position = Vector2(8, y)
	_kartka.add_child(gdzie)
	y += 16
	var fakt := _etykieta(k[2], ATRAMENT)
	fakt.position = Vector2(8, y)
	fakt.size = Vector2(246, 34)
	fakt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_kartka.add_child(fakt)
	y += 38
	var pola: Array[LineEdit] = []
	for i in k[3].size():
		var napis := _etykieta(k[3][i][0] + ":", ATRAMENT)
		napis.position = Vector2(8, y + 2)
		_kartka.add_child(napis)
		var pole := LineEdit.new()
		pole.position = Vector2(96, y)
		pole.size = Vector2(156, 20)
		pole.add_theme_font_size_override("font_size", 12)
		pole.add_theme_color_override("font_color", Color8(30, 40, 110))  # jak długopis
		var styl := StyleBoxFlat.new()
		styl.bg_color = Color(0, 0, 0, 0)
		styl.border_color = ATRAMENT
		styl.border_width_bottom = 1
		pole.add_theme_stylebox_override("normal", styl)
		pole.add_theme_stylebox_override("focus", styl)
		pole.add_theme_stylebox_override("read_only", styl)
		pole.text = stan.wpisy[i]
		pole.editable = not stan.sprawdzona
		pole.text_changed.connect(func(t: String) -> void: stan.wpisy[i] = t)
		_kartka.add_child(pole)
		pola.append(pole)
		y += 26
	if stan.sprawdzona:
		var pieczatka := _etykieta(Dialogi.TECZKA_NAPISY["dobrze"], Color8(180, 30, 30))
		pieczatka.add_theme_font_size_override("font_size", 24)
		pieczatka.position = Vector2(110, 140)
		pieczatka.rotation_degrees = -12.0
		_kartka.add_child(pieczatka)
	else:
		var b := _przycisk("Sprawdź", Vector2(8, 160), Vector2(80, 18))
		b.pressed.connect(_sprawdz.bind(id))
		_kartka.add_child(b)


func _sprawdz(id: String) -> void:
	var rubryki: Array = Dialogi.KARTY[id][3]
	var stan: Dictionary = karty[id]
	for i in rubryki.size():
		var wpis := uprosc(stan.wpisy[i])
		var dobre: Array = rubryki[i][1].map(func(x): return uprosc(x))
		if not dobre.has(wpis):
			_pole_info.text = Dialogi.TECZKA_NAPISY["zle"]
			Gra.flagi["stracone_minuty"] = Gra.flagi.get("stracone_minuty", 0) + 10
			return
	stan.sprawdzona = true
	_pole_info.text = ""
	_odswiez_liste()


func _odswiez_tablice() -> void:
	for d in _tablica.get_children():
		d.queue_free()
	var opis := _etykieta(Dialogi.TECZKA_NAPISY["tablica"], JASNY)
	opis.position = Vector2(0, 0)
	_tablica.add_child(opis)
	var lista: Array = Dialogi.PODEJRZANI
	for i in lista.size():
		var imie: String = lista[i][0]
		var poz := Vector2(4 + (i % 4) * 104, 22 + (i / 4) * 92)
		var b := Button.new()
		b.flat = true
		b.position = poz
		b.size = Vector2(98, 86)
		b.pressed.connect(_skresl.bind(imie))
		var tlo := ColorRect.new()
		tlo.color = Color8(120, 88, 50)  # korek
		tlo.size = Vector2(98, 86)
		tlo.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(tlo)
		var klatka := AtlasTexture.new()
		klatka.atlas = load("res://postacie/%s/%s_arkusz.png" % [lista[i][1], lista[i][1]])
		klatka.region = Rect2(0, 0, 40, 40)
		var foto := TextureRect.new()
		foto.texture = klatka
		foto.position = Vector2(29, 6)
		foto.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(foto)
		var l := _etykieta(imie, PAPIER)
		l.position = Vector2(8, 54)
		l.size.x = 82
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(l)
		if skresleni.has(imie):
			for kier in [1, -1]:
				var kreska := Line2D.new()
				kreska.points = PackedVector2Array([Vector2(6, 43 - 36 * kier), Vector2(92, 43 + 36 * kier)])
				kreska.width = 3.0
				kreska.default_color = Color8(190, 30, 30)
				b.add_child(kreska)
		_tablica.add_child(b)


func _skresl(imie: String) -> void:
	if skresleni.has(imie):
		skresleni.erase(imie)
	else:
		skresleni.append(imie)
	_odswiez_tablice()


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo:
		return
	if k.physical_keycode == KEY_F:
		if not _okno.visible and Gra.okno_otwarte():
			return
		if not _okno.visible and not Notatnik.aktywny:
			return  # teczka razem z notesem, od sceny 1 po Ani
		_okno.visible = not _okno.visible
		if _okno.visible:
			_pokaz_zakladke(_zakladka)
		get_viewport().set_input_as_handled()
	elif _okno.visible:
		match k.physical_keycode:
			KEY_ESCAPE:
				_okno.visible = false
			KEY_1:
				_pokaz_zakladke(0)
			KEY_2:
				_pokaz_zakladke(1)
		get_viewport().set_input_as_handled()
