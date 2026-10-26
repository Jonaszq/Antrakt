extends ScenaGry
## Scena 21 (rozdział 5): pokój Antoniego, piątek rano, pogrzeb o 12:00.
## Zegar idzie tylko od tego, co Antoni robi (tablica, telefony). Kto w śledztwie
## zmarnował dużo czasu (Sledztwo.stracone), zasypia nad notatkami i zaczyna później.
## Tablica: dwa pytania (jak zginął, kto miał zginąć) trzeba przypiąć argumentem
## (s21_jak, s21_kto_mial); każde niezamknięte zabiera jedną szansę w konfrontacji.
## Ola dzwoni po pierwszym podejściu do tablicy, Nowicki po zamknięciu jej albo przy
## telefonie (zaproszony na scenę: s21_nowicki). SMS z telefonu na stole wybiera
## oskarżoną osobę (Gra.flagi["oskarzony"]) i przechodzi do sceny 22. Po 9:00 za późno:
## zakończenie D. Teksty w Dialogi.SCENA21.

const KONFRONTACJA := "res://sceny/scena22/scena22.tscn"
const ZAKONCZENIE := "res://sceny/zakonczenia/zakonczenie.tscn"
const START := 6 * 60
const TERMIN := 9 * 60
const ZA_DUZO_STRACONE := 180  # powyżej tego Antoni zaspał
const ZLE_PRZYPIECIE := 20
const PRZYPIECIE := 10
const DRZWI := Rect2(288, 318, 64, 42)

var _minuty := START
var _zegar: Label


func _ready() -> void:
	przygotuj($Pokoj)
	Notatnik.wlacz()
	Gra.flagi["dni_do_pogrzebu"] = 0
	var t: Dictionary = Dialogi.SCENA21
	_minuty = START + clampi((Sledztwo.stracone() - ZA_DUZO_STRACONE) / 2, 0, 120)
	_zegar = etykieta(12, Color8(236, 226, 200))
	_zegar.position = Vector2(400, 4)
	ui.add_child(_zegar)
	_czas(0)
	antoni.position = Vector2(320, 240)
	antoni.stan("gora")
	miejsce(Vector2(311, 112), t["tablica_napis"], _tablica, 40.0)
	miejsce(Vector2(330, 196), t["stol_napis"], _telefon, 40.0)
	miejsce(Vector2(556, 120), "Czajnik", _czajnik, 40.0)
	miejsce(Vector2(598, 120), "Lodówka", _lodowka, 46.0)
	miejsce(Vector2(76, 205), "Łóżko", _lozko, 40.0)
	miejsce(Vector2(500, 110), "Okno", t["okno"], 60.0)
	miejsce(Vector2(151, 110), "Zegar", func() -> void: await rozmowa([["", t["zegar"] % _godzina()]]), 70.0)
	zamkniete_drzwi(DRZWI, t["wyjscie"])
	var pokoj := Node2D.new()
	pokoj.position = Vector2(320, 150)
	obiekty.add_child(pokoj)
	gada_w_tle(pokoj, t["tlo"], 14.0)
	await plansza(t["plansza"] % _godzina())
	if _minuty > START:
		await rozmowa([["", t["start_zaspal"][0][1] % _godzina()]])
	else:
		await rozmowa(t["start"])
	komunikat(t["pogrzeb"], 3.0)


func _godzina() -> String:
	return "%d:%02d" % [_minuty / 60, _minuty % 60]


## Upływ czasu. Po dziewiątej za późno na SMS-a.
func _czas(ile: int) -> void:
	_minuty += ile
	Telefon.godzina = _godzina()
	_zegar.text = _godzina()
	if _minuty >= TERMIN and not koniec:
		await rozmowa(Dialogi.SCENA21["za_pozno"])
		Gra.flagi["zakonczenie"] = "D"
		Gra.flagi["powod"] = "powod_czas"
		przejdz(ZAKONCZENIE)


func _tablica() -> void:
	var t: Dictionary = Dialogi.SCENA21
	var f: Dictionary = Gra.flagi
	if not f.get("s21_tablica", false):
		f["s21_tablica"] = true
		await rozmowa(t["tablica_start"])
		await _monolog()
	while not koniec:
		var nr := await wybor(t["pytania"])
		if nr == 0:
			await _przypnij("s21_jak", t["jak_odp"], 1, Dialogi.TABLICA_JAK, t["jak_dobrze"])
		elif nr == 1:
			await _przypnij("s21_kto_mial", t["kto_odp"], 1, Dialogi.TABLICA_KTO_MIAL, t["kto_dobrze"])
		else:
			break
	antoni.sterowanie = true
	if not koniec and not f.get("s21_ola", false):
		_ola()
	elif not koniec and f.get("s21_jak", false) and f.get("s21_kto_mial", false) and not f.get("s21_nowicki_dzwonil", false):
		await _nowicki()


## Monolog Antoniego złożony z tego, co naprawdę ma.
func _monolog() -> void:
	var t: Dictionary = Dialogi.SCENA21
	var zdania: Array = []
	for m in t["monolog"]:
		if Sledztwo.jest(m[0]):
			zdania.append(m[1])
	var tekst: String = t["monolog_pusto"] if zdania.size() < 3 else " ".join(zdania)
	await rozmowa([["Antoni", t["monolog_start"]], ["Antoni", tekst]])


## Pytanie z tablicy: odpowiedź, potem argument, który ją przypina.
func _przypnij(flaga: String, odpowiedzi: Array, dobra: int, dowody: Array, dobrze: Array) -> void:
	var t: Dictionary = Dialogi.SCENA21
	if Gra.flagi.get(flaga, false):
		await rozmowa(t["juz_jest"])
		return
	var nr := await wybor(odpowiedzi + [t["bez_dowodu"]])
	if nr == odpowiedzi.size():
		await rozmowa(t["zostawiam"])
		return
	var arg := await wybierz_argument(t["czym_przypiac"], t["bez_dowodu"])
	if arg == "":
		await rozmowa(t["zostawiam"])
		return
	if nr != dobra:
		await rozmowa(t["zla_odp"])
		await _czas(ZLE_PRZYPIECIE)
	elif not arg in dowody:
		await rozmowa(t["zly_dowod"])
		await _czas(ZLE_PRZYPIECIE)
	else:
		await rozmowa(dobrze)
		Gra.flagi[flaga] = true
		await _czas(PRZYPIECIE)


func _ola() -> void:
	var t: Dictionary = Dialogi.SCENA21
	Gra.flagi["s21_ola"] = true
	await get_tree().create_timer(3.0).timeout
	while not koniec and not wolny():
		await get_tree().create_timer(0.3).timeout
	if koniec:
		return
	komunikat(t["ola_dzwoni"], 2.5)
	dzwiek("telefon.wav", -6.0)
	await rozmowa(t["ola"])
	if await wybor(t["ola_wybor"]) == 0:
		await rozmowa(t["ola_jadl_slaby"] if Sledztwo.stracone() > 200 else t["ola_jadl"])
	else:
		await rozmowa(t["ola_nie"])
	await rozmowa(t["ola_koniec"])
	await _czas(5)


func _nowicki() -> void:
	var t: Dictionary = Dialogi.SCENA21
	Gra.flagi["s21_nowicki_dzwonil"] = true
	komunikat(t["nowicki_dzwoni"], 2.5)
	dzwiek("telefon.wav", -6.0)
	await rozmowa(t["nowicki"])
	if await wybor(t["nowicki_wybor"]) == 0:
		await rozmowa(t["nowicki_tak"])
		Gra.flagi["s21_nowicki"] = true
	else:
		await rozmowa(t["nowicki_nie"])
	await _czas(5)


func _czajnik() -> void:
	await rozmowa(Dialogi.SCENA21["czajnik"])


func _lodowka() -> void:
	await rozmowa(Dialogi.SCENA21["lodowka"])


func _lozko() -> void:
	await rozmowa(Dialogi.SCENA21["lozko"])


## Telefon na stole: SMS do oskarżonej osoby.
func _telefon() -> void:
	var t: Dictionary = Dialogi.SCENA21
	var f: Dictionary = Gra.flagi
	if not f.get("s21_nowicki_dzwonil", false):
		await _nowicki()
		if koniec:
			return
	await rozmowa(t["stol"])
	var imiona: Array = Dialogi.PODEJRZANI.map(func(p): return p[0])
	var nr := await wybor(imiona + [t["stol_wybor_nikt"]])
	if nr == imiona.size():
		if await wybor(t["stol_nikt_na_pewno"]) == 1:
			await rozmowa(t["nikt"])
			f["zakonczenie"] = "D"
			f["powod"] = "powod_nikt"
			przejdz(ZAKONCZENIE)
			return
		antoni.sterowanie = true
		return
	var kto: String = imiona[nr]
	if Teczka.skresleni.has(kto):
		await rozmowa(t["skreslony"])
	if await wybor(t["potwierdz"]) != 0:
		antoni.sterowanie = true
		return
	Telefon.dodaj_sms(kto, t["sms"], _godzina(), true)
	f["oskarzony"] = kto
	await rozmowa(t["wyslane"])
	przejdz(KONFRONTACJA)
