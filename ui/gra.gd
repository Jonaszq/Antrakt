extends CanvasLayer
## Stan gry wspólny dla wszystkich scen (singleton "Gra") i okienko wyboru postaci pod Tab:
## zwykły Antoni albo Antoni z latarnią, który mocniej oświetla ciemne miejsca.

signal zmieniono_postac(z_latarnia: bool)

var latarnia := false

var _okno: NinePatchRect
var _ramki: Array[ColorRect] = []
var _wybor := 0


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	_okno = NinePatchRect.new()
	_okno.texture = preload("res://ui/ramka.png")
	for strona in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		_okno.set_patch_margin(strona, 6)
	_okno.position = Vector2(60, 40)
	_okno.size = Vector2(360, 190)
	_okno.visible = false
	add_child(_okno)
	var tytul := _etykieta("Wybierz postać", 16, Color8(242, 212, 126))
	tytul.position = Vector2(0, 4)
	tytul.size = Vector2(360, 20)
	tytul.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_okno.add_child(tytul)
	var opisy := [["Antoni", "Zwykłe światło"], ["Z latarnią", "Mocno świeci\nw ciemnościach"]]
	var arkusze := ["res://postacie/antoni/antoni_arkusz.png", "res://postacie/antoni/antoni_latarnia_arkusz.png"]
	for i in 2:
		var x := 30 + i * 160
		var ramka := ColorRect.new()
		ramka.color = Color8(242, 212, 126)
		ramka.position = Vector2(x, 28)
		ramka.size = Vector2(140, 120)
		_okno.add_child(ramka)
		var tlo := ColorRect.new()
		tlo.color = Color8(30, 22, 26)
		tlo.position = Vector2(1, 1)
		tlo.size = Vector2(138, 118)
		ramka.add_child(tlo)
		_ramki.append(ramka)
		var klatka := AtlasTexture.new()
		klatka.atlas = load(arkusze[i])
		klatka.region = Rect2(0, 0, 40, 68)
		var obraz := TextureRect.new()
		obraz.texture = klatka
		obraz.position = Vector2(8, 4)
		ramka.add_child(obraz)
		var nazwa := _etykieta(opisy[i][0], 16, Color8(236, 226, 200))
		nazwa.position = Vector2(54, 24)
		ramka.add_child(nazwa)
		var opis := _etykieta(opisy[i][1], 16, Color8(170, 160, 140))
		opis.position = Vector2(6, 74)
		opis.size = Vector2(130, 40)
		ramka.add_child(opis)
	var pomoc := _etykieta("A/D – wybór   E – zatwierdź   Tab – zamknij", 16, Color8(170, 160, 140))
	pomoc.position = Vector2(0, 160)
	pomoc.size = Vector2(360, 20)
	pomoc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_okno.add_child(pomoc)


func _etykieta(tekst: String, rozmiar: int, kolor: Color) -> Label:
	var l := Label.new()
	l.text = tekst
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", kolor)
	return l


## Czy jest otwarte jakieś okno (notes, telefon, wybór postaci). Antoni wtedy stoi.
func okno_otwarte() -> bool:
	return _okno.visible or Notatnik.otwarty() or Telefon.otwarty()


func ustaw_latarnie(z: bool) -> void:
	latarnia = z
	zmieniono_postac.emit(z)


func _pokaz_wybor() -> void:
	for i in 2:
		_ramki[i].color = Color8(242, 212, 126) if i == _wybor else Color8(70, 56, 50)


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo:
		return
	if k.physical_keycode == KEY_TAB:
		if not _okno.visible and okno_otwarte():
			return
		_okno.visible = not _okno.visible
		_wybor = 1 if latarnia else 0
		_pokaz_wybor()
		get_viewport().set_input_as_handled()
	elif _okno.visible:
		match k.physical_keycode:
			KEY_A, KEY_LEFT:
				_wybor = 0
			KEY_D, KEY_RIGHT:
				_wybor = 1
			KEY_E, KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
				ustaw_latarnie(_wybor == 1)
				_okno.visible = false
			KEY_ESCAPE:
				_okno.visible = false
		_pokaz_wybor()
		get_viewport().set_input_as_handled()
