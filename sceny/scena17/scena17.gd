extends ScenaGry
## Scena 17 (rozdział 4): mieszkanie Adriana i klatka, środa 17:00.
## Ania czeka na klatce z kluczem i odda go dopiero za drugim razem, po pytaniu o ostatnią
## rozmowę z Adrianem (powtarza kłamstwo ze sceny 8), albo od razu na widok opaski.
## W mieszkaniu: zdjęcie "14.03" (PIN 1403), notatka na lodówce, leki do zabrania.
## Telefon Adriana trzeba naładować przy gniazdku: ładowarka od Zenona albo pożyczona od
## sąsiadki z jedenastki. Trzy złe PIN-y blokują telefon na godzinę gry. Dobry PIN daje
## SMS z czwartku 22:10 (karta "sms"). Kiedy Antoni wyjdzie z mieszkania, po schodach
## wbiega Kuba z kluczem i ucieka (s17_kuba). Teksty w Dialogi.SCENA17.

const NASTEPNA := "res://sceny/retrospekcje/retro3.tscn"
const SCHODY := Rect2(526, 300, 100, 46)
const DRZWI_12 := Rect2(300, 232, 40, 50)
const ANIA := Vector2(236, 312)
const PIN := "1403"
const PROBY := 3
const LADOWANIE := 25.0

var _ania: Node2D
var _sasiadka: Node2D
var _blokada: StaticBody2D
var _proby := PROBY
var _naladowany := false
var _klucz_prosby := 0


func _ready() -> void:
	przygotuj($Mieszkanie)
	Telefon.godzina = "17:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA17
	antoni.position = Vector2(400, 322)
	antoni.stan("lewo")
	_ania = postac("ania", ANIA)
	dodaj_rozmowce(_ania, _rozmowa_z_ania)
	gada_w_tle(_ania, Dialogi.SCENA17_TLO["ania"], 10.0)
	_zamknij_drzwi()
	miejsce(Vector2(320, 290), "Drzwi 12", _drzwi, 50.0)
	miejsce(Vector2(126, 290), "Drzwi 11", _sasiadka_puka, 50.0)
	miejsce(Vector2(94, 104), "Plakaty", t["plakaty"], 70.0)
	miejsce(Vector2(324, 104), "Zdjęcie", _po_kolei("zdjecie", "s17_zdjecie"), 70.0)
	miejsce(Vector2(232, 186), "Scenariusze", t["scenariusze"], 40.0)
	miejsce(Vector2(262, 186), "Leki", _leki, 40.0)
	miejsce(Vector2(602, 116), "Lodówka", _po_kolei("lodowka", "s17_notatka"), 60.0)
	miejsce(Vector2(510, 116), "Zlew", _po_kolei("zlew", "s17_kran"), 40.0)
	miejsce(Vector2(451, 104), "Okno", t["roslina"], 50.0)
	miejsce(Vector2(75, 180), "Łóżko", t["lozko"], 40.0)
	miejsce(Vector2(360, 116), "Szafa", t["szafa"], 60.0)
	miejsce(Vector2(236, 112), "Gniazdko", _gniazdko, 30.0)
	ustaw_wyjscie(SCHODY, "Na dół", NASTEPNA)
	_pilnuj_wyjscia()
	_telewizor()
	await plansza("Mieszkanie Adriana, środa 17:00")
	await rozmowa(t["poczatek"])


func _po_kolei(klucz: String, flaga: String) -> Callable:
	var stan := {"bylo": false}
	return func() -> void:
		var t: Dictionary = Dialogi.SCENA17
		await rozmowa(t[klucz + "_potem"] if stan.bylo and t.has(klucz + "_potem") else t[klucz])
		stan.bylo = true
		if flaga != "":
			Gra.flagi[flaga] = true


func _telewizor() -> void:
	while not koniec:
		await get_tree().create_timer(randf_range(35.0, 50.0)).timeout
		if not koniec and wolny():
			komunikat(Dialogi.SCENA17["tv"])


## Drzwi numer 12 zamknięte, dopóki Antoni nie ma klucza od Ani.
func _zamknij_drzwi() -> void:
	_blokada = StaticBody2D.new()
	var ksztalt := CollisionShape2D.new()
	var prost := RectangleShape2D.new()
	prost.size = DRZWI_12.size
	ksztalt.shape = prost
	ksztalt.position = DRZWI_12.get_center()
	_blokada.add_child(ksztalt)
	add_child(_blokada)


func _drzwi() -> void:
	var t: Dictionary = Dialogi.SCENA17
	if not is_instance_valid(_blokada):
		return
	if not Ekwipunek.ma("klucz_adriana"):
		await rozmowa(t["drzwi_zamkniete"])
		return
	await rozmowa(t["drzwi_otwieram"])
	_blokada.queue_free()
	var otwor := ColorRect.new()
	otwor.color = Color8(24, 20, 20)
	otwor.size = Vector2(32, 38)
	otwor.position = Vector2(304, 244)
	obiekty.add_child(otwor)


## Pierwsze wyjście z mieszkania na klatkę: wbiega Kuba i ucieka.
func _pilnuj_wyjscia() -> void:
	var w_srodku := false
	while not koniec:
		await get_tree().create_timer(0.3).timeout
		if antoni.position.y < 232.0:
			w_srodku = true
			Gra.flagi["s17_wszedl"] = true
		elif w_srodku and antoni.position.y > 290.0 and wolny():
			await _kuba()
			return


func _kuba() -> void:
	var t: Dictionary = Dialogi.SCENA17
	antoni.sterowanie = false
	var kuba := postac("gosc_student", Vector2(600, 360))
	await idz(kuba, [Vector2(560, 318)], 60.0)
	zwroc_sie(kuba)
	await dymek(kuba, t["kuba_wbiega"], 1.2)
	await rozmowa(t["kuba_ucieka"])
	await idz(kuba, [Vector2(600, 370)], 140.0)
	kuba.queue_free()
	Gra.flagi["s17_kuba"] = true
	if is_instance_valid(_ania):
		await rozmowa(t["ania_po_kubie"])
	antoni.sterowanie = true


func _rozmowa_z_ania() -> void:
	var t: Dictionary = Dialogi.SCENA17
	var f: Dictionary = Gra.flagi
	await rozmowa(t["ania_znowu" if f.get("s17_ania_zagadal", false) else "ania_start"])
	f["s17_ania_zagadal"] = true
	var tematy := [
		["Dasz mi klucz?", _prosba_o_klucz, func() -> bool: return not Ekwipunek.ma("klucz_adriana")],
		["Kiedy ostatnio rozmawiałaś z Adrianem?", temat("s17_ania_czwartek", t["ania_czwartek"])],
		["Adrian był chory w ostatnich dniach?", t["ania_choroba"]],
		["Skąd Kuba ma klucz?", temat("s17_kuba_klucz", t["ania_kuba"]), func() -> bool: return f.get("s17_kuba", false)],
	]
	var dowody := {
		"opaska": _opaska,
		"karta_sms": _sms_ani,
	}
	await przesluchanie(tematy, dowody, t["ania_nic"], t["ania_koniec"])


## Klucz za drugim razem, i tylko po pytaniu o ostatnią rozmowę.
func _prosba_o_klucz() -> void:
	var t: Dictionary = Dialogi.SCENA17
	_klucz_prosby += 1
	if _klucz_prosby < 2 or not Gra.flagi.get("s17_ania_czwartek", false):
		await rozmowa(t["ania_klucz_nie"])
		return
	await rozmowa(t["ania_klucz_tak"])
	Ekwipunek.dodaj("klucz_adriana")


func _opaska() -> void:
	var t: Dictionary = Dialogi.SCENA17
	if Ekwipunek.ma("klucz_adriana"):
		await rozmowa([t["ania_opaska"][0]])
		return
	await rozmowa(t["ania_opaska"])
	Ekwipunek.dodaj("klucz_adriana")


## SMS pokazany Ani: blednie i ucieka z klatki. Kończy rozmowę.
func _sms_ani() -> bool:
	await rozmowa(Dialogi.SCENA17["ania_sms"])
	Gra.flagi["s17_ania_sms"] = true
	antoni.sterowanie = false
	await idz(_ania, [Vector2(500, 318), Vector2(600, 370)], 70.0)
	_ania.queue_free()
	antoni.sterowanie = true
	return true


func _leki() -> void:
	var t: Dictionary = Dialogi.SCENA17
	if Gra.flagi.get("s17_leki", false):
		await rozmowa(t["leki_potem"])
		return
	await rozmowa(t["leki"])
	Ekwipunek.dodaj("tabletki")
	Gra.flagi["s17_leki"] = true


func _sasiadka_puka() -> void:
	if is_instance_valid(_sasiadka):
		return
	await rozmowa(Dialogi.SCENA17["sasiadka_puka"])
	_sasiadka = postac("gosc_pani", Vector2(126, 300))
	dodaj_rozmowce(_sasiadka, _rozmowa_z_sasiadka)
	await _rozmowa_z_sasiadka()


func _rozmowa_z_sasiadka() -> void:
	var t: Dictionary = Dialogi.SCENA17
	var f: Dictionary = Gra.flagi
	await rozmowa(t["sasiadka_znowu" if f.get("s17_sasiadka_zagadal", false) else "sasiadka_start"])
	f["s17_sasiadka_zagadal"] = true
	var tematy := [
		["Jaki był Adrian?", temat("s17_sasiadka", t["sasiadka_adrian"])],
		["Ktoś do niego przychodził?", temat("s17_goscie", t["sasiadka_goscie"])],
		["A w piątek?", t["sasiadka_piatek"]],
		["Ma pani ładowarkę do starego telefonu?", _pozycz_ladowarke,
			func() -> bool: return Ekwipunek.ma("telefon_adriana") and not Ekwipunek.ma("ladowarka")],
	]
	await przesluchanie(tematy, {}, t["sasiadka_nic"], t["sasiadka_koniec"])


func _pozycz_ladowarke() -> void:
	await rozmowa(Dialogi.SCENA17["sasiadka_ladowarka"])
	Ekwipunek.dodaj("ladowarka")
	Gra.flagi["s17_ladowarka_sasiadki"] = true


## Gniazdko: podłączenie telefonu, czekanie na ładowanie, potem PIN.
func _gniazdko() -> void:
	var t: Dictionary = Dialogi.SCENA17
	var f: Dictionary = Gra.flagi
	if f.get("s17_sms", false):
		await rozmowa(t["pin_potem"])
	elif not Ekwipunek.ma("telefon_adriana"):
		await rozmowa(t["brak_telefonu"] if f.get("s8_telefon_wolski", false) else t["gniazdko"])
	elif not f.get("s17_laduje", false):
		if not Ekwipunek.ma("ladowarka"):
			await rozmowa(t["bez_ladowarki"])
			return
		await rozmowa(t["podlaczam"])
		f["s17_laduje"] = true
		rekwizyt("telefon_podloga", Vector2(236, 120))
		get_tree().create_timer(LADOWANIE).timeout.connect(func() -> void: _naladowany = true)
	elif not _naladowany:
		await rozmowa(t["laduje"])
	else:
		await rozmowa(t["pin_pytanie"])
		var kod := await _wpisz_pin()
		if kod != "":
			await sprawdz_pin(kod)


func _wpisz_pin() -> String:
	return await wpisz("PIN (Enter)", 4)


func sprawdz_pin(kod: String) -> void:
	var t: Dictionary = Dialogi.SCENA17
	if kod == PIN:
		await rozmowa(t["pin_dobry"])
		Gra.flagi["s17_sms"] = true
		Teczka.dodaj("sms")
		return
	_proby -= 1
	if _proby > 0:
		komunikat(t["pin_zly"] % _proby)
		return
	await rozmowa(t["pin_blokada"])
	Sledztwo.strata(60)
	_proby = PROBY
