extends CanvasLayer
## Telefon Antoniego pod klawiszem Q (singleton "Telefon"): ekran główny z aplikacjami
## Telefon (historia połączeń), Wiadomości, Pogoda i Muzyka.
## W/S albo strzałki wybierają, E otwiera, Q lub Escape cofa i chowa telefon.
## Sceny mogą dopisywać SMS-y przez Telefon.dodaj_sms(kto, tekst, godzina, od_antoniego).

const EKRAN := Rect2(10, 22, 150, 214)
const BIALY := Color8(236, 238, 246)
const SZARY := Color8(140, 146, 166)

## Rozmowy: kontakt -> lista [godzina, tekst, czy napisał Antoni].
var sms := {
	"Ola (siostra)": [
		["14:02", "Siema braciszku! Masz tu bilet na premierę \"Ostatniego aktu\". Dziś 19:00, Teatr Miejski.", false],
		["14:03", "Tylko się nie spóźnij! Długo na niego pracowałam.", false],
		["14:03", "Miłego spektaklu. I choć raz nie myśl o pracy :)", false],
		["14:20", "Dzięki, Ola. Będę na czas.", true],
	],
	"Komisarz Nowicki": [
		["pt 17:45", "Urlop to urlop, Antoni. Nie chcę cię widzieć na komendzie do poniedziałku.", false],
		["pt 17:51", "Tak jest, szefie.", true],
	],
	"Mama": [
		["pt 19:10", "Jadłeś coś dzisiaj?", false],
		["pt 21:30", "Antoś?", false],
	],
}
## Historia połączeń: [kto, rodzaj, kiedy].
var polaczenia := [
	["Ola (siostra)", "przychodzące", "dziś 14:05, 2 min"],
	["Mama", "nieodebrane", "pt 21:31"],
	["Pizzeria Roma", "wychodzące", "pt 20:12, 1 min"],
	["Komisarz Nowicki", "przychodzące", "pt 17:40, 4 min"],
	["Nieznany numer", "odrzucone", "czw 09:12"],
	["Mama", "wychodzące", "śr 18:30, 12 min"],
]

## Godzina na pasku telefonu; sceny ustawiają ją przy starcie.
var godzina := "18:30"

var _korpus: TextureRect
var _ekran: Control
var _widok := "start"
var _wybor := 0
var _rozmowa := ""
var _przewiniecie := 0


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	_korpus = TextureRect.new()
	_korpus.texture = preload("res://ui/telefon.png")
	_korpus.position = Vector2(296, 10)
	_korpus.visible = false
	add_child(_korpus)
	_ekran = Control.new()
	_ekran.position = EKRAN.position
	_ekran.size = EKRAN.size
	_ekran.clip_contents = true
	_korpus.add_child(_ekran)


func otwarty() -> bool:
	return _korpus.visible


func dodaj_sms(kto: String, tekst: String, godzina: String, od_antoniego := false) -> void:
	if not sms.has(kto):
		sms[kto] = []
	sms[kto].append([godzina, tekst, od_antoniego])


func _etykieta(tekst: String, kolor := BIALY, poz := Vector2.ZERO, szer := 0.0) -> Label:
	var l := Label.new()
	l.text = tekst
	l.position = poz
	l.add_theme_font_size_override("font_size", 16)
	l.add_theme_color_override("font_color", kolor)
	l.add_theme_constant_override("line_spacing", -6)
	_ekran.add_child(l)
	if szer > 0.0:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = szer
		l.size = Vector2(szer, 0)
	return l


func _prost(poz: Vector2, wym: Vector2, kolor: Color) -> ColorRect:
	var r := ColorRect.new()
	r.position = poz
	r.size = wym
	r.color = kolor
	_ekran.add_child(r)
	return r


func _rysuj() -> void:
	for dziecko in _ekran.get_children():
		dziecko.queue_free()
	_prost(Vector2.ZERO, EKRAN.size, Color8(18, 24, 44))
	_etykieta(godzina, SZARY, Vector2(4, -2))
	_etykieta("sob", SZARY, Vector2(118, -2))
	match _widok:
		"start":
			_ekran_glowny()
		"telefon":
			_lista_polaczen()
		"wiadomosci":
			_lista_rozmow()
		"rozmowa":
			_pokaz_rozmowe()
		"pogoda":
			_naglowek("Pogoda")
			_etykieta("Teatr Miejski\nsobota\n\nDeszcz, 9°C\nWieczorem ulewa.\n\nNiedziela:\npochmurno, 7°C", BIALY, Vector2(8, 26), 136)
		"muzyka":
			_naglowek("Muzyka")
			_etykieta("Brak pobranych utworów.\n\nOla poleca:\n\"Sonata\nksiężycowa\"", SZARY, Vector2(8, 26), 136)


func _naglowek(tekst: String) -> void:
	_prost(Vector2(0, 16), Vector2(150, 1), Color8(60, 70, 100))
	_etykieta(tekst, Color8(242, 212, 126), Vector2(6, 16))
	_etykieta("Q – wróć", SZARY, Vector2(82, 196))


const APLIKACJE := [["telefon", "Telefon"], ["wiadomosci", "Wiadomości"], ["pogoda", "Pogoda"], ["muzyka", "Muzyka"]]


func _ekran_glowny() -> void:
	for i in APLIKACJE.size():
		var y := 24 + i * 40
		if i == _wybor:
			_prost(Vector2(4, y - 2), Vector2(142, 34), Color8(50, 62, 100))
		var ik := TextureRect.new()
		ik.texture = load("res://ui/ikona_%s.png" % APLIKACJE[i][0])
		ik.position = Vector2(10, y + 1)
		_ekran.add_child(ik)
		_etykieta(APLIKACJE[i][1], BIALY, Vector2(44, y + 4))
		if APLIKACJE[i][0] == "wiadomosci":
			_prost(Vector2(132, y + 2), Vector2(8, 8), Color8(220, 70, 80))  # nieprzeczytane
	_etykieta("W/S  E – otwórz", SZARY, Vector2(8, 196))


func _lista_polaczen() -> void:
	_naglowek("Połączenia")
	var skroty := {"przychodzące": "przych.", "wychodzące": "wych.", "nieodebrane": "nieodebr.", "odrzucone": "odrzuc."}
	var y := 34
	for p in polaczenia:
		var kolor := Color8(230, 110, 110) if p[1] in ["nieodebrane", "odrzucone"] else BIALY
		_etykieta(p[0], kolor, Vector2(6, y - 4))
		_etykieta("%s %s" % [skroty[p[1]], p[2].get_slice(",", 0)], SZARY, Vector2(6, y + 9))
		y += 32
		if y > 180:
			break


func _lista_rozmow() -> void:
	_naglowek("Wiadomości")
	var kontakty := sms.keys()
	for i in kontakty.size():
		var y := 38 + i * 40
		if i == _wybor:
			_prost(Vector2(2, y - 1), Vector2(146, 38), Color8(50, 62, 100))
		_etykieta(kontakty[i], BIALY, Vector2(6, y - 2))
		var ostatnia: Array = sms[kontakty[i]][-1]
		var skrot: String = ostatnia[1]
		if skrot.length() > 18:
			skrot = skrot.substr(0, 17) + "…"
		_etykieta(skrot, SZARY, Vector2(6, y + 14))


func _pokaz_rozmowe() -> void:
	_naglowek(_rozmowa)
	var y := 36 - _przewiniecie
	for w in sms[_rozmowa]:
		var od_niego: bool = w[2]
		var l := _etykieta(w[1], BIALY if od_niego else Color8(24, 24, 32), Vector2.ZERO, 128)
		var wys := l.get_line_count() * (l.get_line_height() - 6.0) + 6.0
		var x := 18.0 if od_niego else 4.0
		var dymek := _prost(Vector2(x - 2, y), Vector2(132, wys + 2), Color8(60, 110, 200) if od_niego else Color8(214, 218, 230))
		_ekran.move_child(dymek, l.get_index())
		l.position = Vector2(x, y - 1)
		_etykieta(w[0], SZARY, Vector2(x, y + wys - 2))
		y += wys + 18


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo:
		return
	if not _korpus.visible:
		if k.physical_keycode == KEY_Q and not Gra.okno_otwarte():
			_korpus.visible = true
			_widok = "start"
			_wybor = 0
			_rysuj()
			get_viewport().set_input_as_handled()
		return
	get_viewport().set_input_as_handled()
	match k.physical_keycode:
		KEY_Q, KEY_ESCAPE, KEY_BACKSPACE:
			if _widok == "start":
				_korpus.visible = false
				return
			_widok = "wiadomosci" if _widok == "rozmowa" else "start"
			_wybor = 0
		KEY_W, KEY_UP:
			if _widok == "rozmowa":
				_przewiniecie = maxi(0, _przewiniecie - 20)
			else:
				_wybor = maxi(0, _wybor - 1)
		KEY_S, KEY_DOWN:
			if _widok == "rozmowa":
				_przewiniecie += 20
			else:
				var ile := APLIKACJE.size() if _widok == "start" else sms.size()
				_wybor = mini(ile - 1, _wybor + 1)
		KEY_E, KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
			if _widok == "start":
				_widok = APLIKACJE[_wybor][0]
				_wybor = 0
			elif _widok == "wiadomosci":
				_rozmowa = sms.keys()[_wybor]
				_widok = "rozmowa"
				_przewiniecie = 0
	_rysuj()
