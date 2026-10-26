extends CanvasLayer
## Stan gry wspólny dla wszystkich scen (singleton "Gra") i okienko wyboru postaci pod Tab:
## zwykły Antoni albo Antoni z latarnią, który mocniej oświetla ciemne miejsca.
## Postać można też wybrać myszką: najechać i kliknąć.
## F11 (albo Alt+Enter) przełącza pełny ekran i okno.

signal zmieniono_postac(z_latarnia: bool)

## Gra pokazuje świat w 640x360 (kamera widzi więcej), a okienka i napisy są
## rysowane dla 480x270 i powiększane o 4/3, więc na ekranie 1920x1080 każdy
## piksel grafiki to równo 4x4 piksele, a tekst jest ostry.
const SKALA_UI := Vector2(4.0 / 3.0, 4.0 / 3.0)

var latarnia := false

## Czy Antoni ma przy sobie latarnię. Gra zaczyna się bez niej, Antoni znajduje
## ją dopiero w magazynie (scena 6), do tego czasu Tab nie pozwala jej wybrać.
var latarnia_dostepna := false

## Pieniądze Antoniego w złotych. Starczają na taksówki (TAKSOWKA), dzięki którym
## przejazd między miejscami nie zjada czasu śledztwa.
var kasa := 0
const TAKSOWKA := 15

## Stan fabuły, który musi przetrwać zmianę sceny (np. powrót z garderoby do kulis).
var flagi := {}

var _kawa_czas := 0.0

## Zapis gry: na początku każdej sceny (ScenaGry.przygotuj) cały stan trafia do PLIK_ZAPISU,
## "Kontynuuj" w menu wczytuje go i uruchamia tę scenę od początku. Start sceny z menu
## "Wybierz scenę" (testy) nie nadpisuje zapisu.
const PLIK_ZAPISU := "user://zapis.txt"
var zapisuj := true

var _okno: NinePatchRect
var _ramki: Array[ColorRect] = []
var _opis_latarni: Label
var _wybor := 0


func _ready() -> void:
	layer = 30
	scale = Gra.SKALA_UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	_okno = NinePatchRect.new()
	_okno.texture = preload("res://ui/ramka.png")
	for strona in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		_okno.set_patch_margin(strona, 6)
	_okno.position = Vector2(60, 40)
	_okno.size = Vector2(360, 190)
	_okno.visible = false
	add_child(_okno)
	var tytul := _etykieta("Wybierz postać", 12, Color8(242, 212, 126))
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
		var nazwa := _etykieta(opisy[i][0], 12, Color8(236, 226, 200))
		nazwa.position = Vector2(54, 24)
		ramka.add_child(nazwa)
		var opis := _etykieta(opisy[i][1], 12, Color8(170, 160, 140))
		opis.position = Vector2(6, 74)
		opis.size = Vector2(130, 40)
		ramka.add_child(opis)
		if i == 1:
			_opis_latarni = opis
	var pomoc := _etykieta("A/D albo mysz – wybór   E – weź   Tab – zamknij", 12, Color8(170, 160, 140))
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
	return _okno.visible or Notatnik.otwarty() or Telefon.otwarty() or Ekwipunek.otwarty() or Pauza.otwarta() or Teczka.otwarty()


## Czyści wszystko przed nową grą (wołane z menu głównego).
func nowa_gra() -> void:
	latarnia = false
	latarnia_dostepna = false
	kasa = 0
	_kawa_czas = 0.0
	flagi.clear()
	Notatnik.aktywny = false
	Ekwipunek.przedmioty.clear()
	Teczka.wyczysc()
	Telefon.sms = Dialogi.SMS.duplicate(true)
	Telefon.polaczenia = Dialogi.POLACZENIA.duplicate(true)


# ---------- ustawienia (te same w menu głównym i w pauzie) ----------

func pelny_ekran() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


func przelacz_pelny_ekran() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if pelny_ekran() else DisplayServer.WINDOW_MODE_FULLSCREEN)


func napis_ekranu() -> String:
	return "Pełny ekran: " + ("tak" if pelny_ekran() else "nie")


## Głośność całej gry w procentach, klik zmienia 100 -> 80 -> ... -> 0 -> 100.
func glosnosc() -> int:
	return roundi(db_to_linear(AudioServer.get_bus_volume_db(0)) * 100.0 / 20.0) * 20


func zmien_glosnosc() -> void:
	var nowa := glosnosc() - 20
	if nowa < 0:
		nowa = 100
	AudioServer.set_bus_volume_db(0, linear_to_db(nowa / 100.0))
	AudioServer.set_bus_mute(0, nowa == 0)


func napis_glosnosci() -> String:
	return "Głośność: %d%%" % glosnosc()


func ma_zapis() -> bool:
	return FileAccess.file_exists(PLIK_ZAPISU)


func zapisz(scena: String) -> void:
	if not zapisuj or scena == "":
		return
	var stan := {
		"scena": scena, "latarnia": latarnia, "latarnia_dostepna": latarnia_dostepna,
		"kasa": kasa, "flagi": flagi, "przedmioty": Array(Ekwipunek.przedmioty),
		"karty": Teczka.karty, "kolejnosc": Teczka._kolejnosc, "skresleni": Teczka.skresleni,
		"sms": Telefon.sms, "polaczenia": Telefon.polaczenia, "godzina": Telefon.godzina,
		"notes": Notatnik.aktywny,
	}
	var plik := FileAccess.open(PLIK_ZAPISU, FileAccess.WRITE)
	if plik:
		plik.store_string(var_to_str(stan))


## Wczytuje zapis i zwraca scenę, od której grać dalej ("" gdy zapisu nie ma).
func wczytaj() -> String:
	var plik := FileAccess.open(PLIK_ZAPISU, FileAccess.READ)
	if not plik:
		return ""
	var stan = str_to_var(plik.get_as_text())
	if not stan is Dictionary or not stan.has("scena"):
		return ""
	nowa_gra()
	latarnia = stan.latarnia
	latarnia_dostepna = stan.latarnia_dostepna
	kasa = stan.kasa
	flagi = stan.flagi
	Ekwipunek.przedmioty = PackedStringArray(stan.przedmioty)
	Teczka.karty = stan.karty
	Teczka._kolejnosc = stan.kolejnosc
	Teczka.skresleni = stan.skresleni
	Telefon.sms = stan.sms
	Telefon.polaczenia = stan.polaczenia
	Telefon.godzina = stan.godzina
	Notatnik.aktywny = stan.notes
	zapisuj = true
	return stan.scena


func dodaj_kase(ile: int) -> void:
	kasa = maxi(kasa + ile, 0)


## Po kawie Antoni przez pół minuty chodzi szybciej.
func wypij_kawe() -> void:
	_kawa_czas = 30.0


func mnoznik_predkosci() -> float:
	return 1.35 if _kawa_czas > 0.0 else 1.0


func _process(delta: float) -> void:
	_kawa_czas = maxf(0.0, _kawa_czas - delta)


func ustaw_latarnie(z: bool) -> void:
	if z and not latarnia_dostepna:
		return
	latarnia = z
	zmieniono_postac.emit(z)


func _pokaz_wybor() -> void:
	if not latarnia_dostepna:
		_wybor = 0
	for i in 2:
		_ramki[i].color = Color8(242, 212, 126) if i == _wybor else Color8(70, 56, 50)
	_ramki[1].modulate.a = 1.0 if latarnia_dostepna else 0.45
	_opis_latarni.text = "Mocno świeci\nw ciemnościach" if latarnia_dostepna else "Nie masz\nlatarki"


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo:
		return
	if k.physical_keycode == KEY_F11 or (k.physical_keycode == KEY_ENTER and k.alt_pressed):
		przelacz_pelny_ekran()
		get_viewport().set_input_as_handled()
	elif k.physical_keycode == KEY_TAB:
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


func _input(zdarzenie: InputEvent) -> void:
	if not _okno.visible or not zdarzenie is InputEventMouse:
		return
	get_viewport().set_input_as_handled()
	var poz: Vector2 = transform.affine_inverse() * (zdarzenie as InputEventMouse).position - _okno.position
	var pod := -1
	for i in 2:
		if Rect2(_ramki[i].position, _ramki[i].size).has_point(poz):
			pod = i
	if pod >= 0:
		_wybor = pod
		_pokaz_wybor()
	var m := zdarzenie as InputEventMouseButton
	if m and m.pressed and m.button_index == MOUSE_BUTTON_LEFT:
		if pod >= 0:
			ustaw_latarnie(pod == 1)
			_okno.visible = false
		elif not Rect2(Vector2.ZERO, _okno.size).has_point(poz):
			_okno.visible = false  # klik obok okienka
