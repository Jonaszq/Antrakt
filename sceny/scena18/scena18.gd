extends ScenaGry
## Scena 18 (rozdział 4): garderoba Wolskiego, środa 21:00. Teatr pusty. Bez zapasowego
## klucza Antoni czeka godzinę na sprzątaczkę. Po trzech oględzinach albo 40 s słychać
## kroki: trzeba schować się za stojakiem z kostiumami. Kto stoi gdzie indziej, zostaje
## przyłapany (s18_przylapany) i sejf jest dostępny dopiero w czwartek (tryb s18_jutro,
## wybór w Rozdzial4.czwartek). Schowany słyszy rozmowę z Anią, ale każdy ruch to skrzypnięcie
## podłogi i wpadka; od czwartej kwestii Antoni wie o nagraniu (s18_nagranie, retrospekcja 4).
## Zeszyt w szufladzie toaletki (karta "zeszyt"), recepta w koszu (karta "recepta"),
## sejf: szyfr 1998 (rok z plakatu albo programu), w środku pendrive i, jeśli w scenie 8
## oddano mu telefon, telefon Adriana (PIN 1403 daje SMS). Teksty w Dialogi.SCENA18.

const DRZWI := Rect2(288, 318, 64, 42)
const RETRO4 := "res://sceny/retrospekcje/retro4.tscn"
const SCENA19 := "res://sceny/scena19/scena19.tscn"
const KRYJOWKA := Rect2(425, 198, 90, 64)
const TOALETKA := Vector2(300, 140)
const SZYFR := "1998"
const PIN := "1403"
const PO_ILU_KROKI := 40.0
const NA_SCHOWANIE := 7.0
const ILE_OGLEDZIN := 3
const CO_ILE_KWESTIA := 3.5

var _jutro := false
var _wolski: Node2D
var _ogledziny := 0
var _kroki := false


func _ready() -> void:
	przygotuj($GarderobaWolskiego)
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA18
	var f: Dictionary = Gra.flagi
	_jutro = f.get("s18_jutro", false)
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	miejsce(Vector2(270, 120), "Szuflada", _licz(_szuflada), 30.0)
	miejsce(Vector2(359, 124), "Kosz", _licz(_kosz), 20.0)
	miejsce(Vector2(128, 150), "Sejf", _licz(_sejf), 30.0)
	miejsce(Vector2(330, 116), "Toaletka", _licz(func() -> void: await rozmowa(t["toaletka"])), 40.0)
	miejsce(Vector2(470, 272), "Stojak", t["stojak"], 70.0)
	miejsce(Vector2(165, 104), "Plakat", t["plakat"], 70.0)
	miejsce(Vector2(76, 132), "Szafa", _licz(func() -> void: await rozmowa(t["szafa"])), 70.0)
	miejsce(Vector2(102, 262), "Kanapa", _licz(func() -> void: await rozmowa(t["kanapa"])))
	miejsce(Vector2(582, 322), "Bukiety", t["bukiety"], 50.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", SCENA19)
	if _jutro:
		Telefon.godzina = "15:00"
		f["s18_jutro"] = false
		f["s18_jutro_byl"] = true
		await plansza(t["plansza_jutro"])
		await rozmowa(t["poczatek_jutro"])
		return
	Telefon.godzina = "21:00"
	$GarderobaWolskiego/Mrok.color = Color(0.3, 0.3, 0.42)
	var stroz := Node2D.new()
	stroz.position = Vector2(320, 352)
	obiekty.add_child(stroz)
	gada_w_tle(stroz, Dialogi.SCENA18_TLO["stroz"], 16.0)
	await plansza(t["plansza"])
	if Ekwipunek.ma("klucz"):
		await rozmowa(t["poczatek_klucz"])
	else:
		await rozmowa(t["poczatek_bez_klucza"])
		Sledztwo.strata(60)
	_kroki_po_czasie()


## Oględziny liczą się do momentu, w którym przychodzi Wolski.
func _licz(co: Callable) -> Callable:
	return func() -> void:
		await co.call()
		_ogledziny += 1
		if _ogledziny >= ILE_OGLEDZIN:
			_nadchodzi()


func _kroki_po_czasie() -> void:
	await get_tree().create_timer(PO_ILU_KROKI).timeout
	_nadchodzi()


## Kroki na korytarzu: kilka sekund na schowanie się za stojakiem.
func _nadchodzi() -> void:
	if _kroki or _jutro or koniec:
		return
	_kroki = true
	while not koniec and not wolny():
		await get_tree().create_timer(0.3).timeout
	komunikat(Dialogi.SCENA18["kroki"], NA_SCHOWANIE)
	await get_tree().create_timer(NA_SCHOWANIE).timeout
	while not koniec and not wolny():
		await get_tree().create_timer(0.3).timeout
	if koniec:
		return
	await _wolski_wchodzi()


func schowany() -> bool:
	return KRYJOWKA.has_point(antoni.position)


func _wolski_wchodzi() -> void:
	var t: Dictionary = Dialogi.SCENA18
	var f: Dictionary = Gra.flagi
	_wolski = postac("wolski", Vector2(320, 360))
	if not schowany():
		antoni.sterowanie = false
		await idz(_wolski, [Vector2(320, 320)], 50.0)
		zwroc_sie(_wolski)
		await rozmowa(t["przylapany_przed"])
		f["s18_przylapany"] = true
		super.przejdz(SCENA19)
		return
	await idz(_wolski, [Vector2(320, 250), TOALETKA], 45.0)
	await dymek(_wolski, t["wolski_koniak"], 2.5)
	# rozmowa z Anią: Antoni nie może się ruszyć
	var start := antoni.position
	var kwestie: Array = t["rozmowa"]
	for i in kwestie.size():
		dymek(_wolski, kwestie[i], CO_ILE_KWESTIA - 0.3)
		if i >= 3:
			f["s18_nagranie"] = true
		var czas := 0.0
		while czas < CO_ILE_KWESTIA:
			await (Engine.get_main_loop() as SceneTree).process_frame
			czas += get_process_delta_time()
			if antoni.position.distance_to(start) > 3.0:
				await _skrzyp(i)
				return
	f["s18_podsluch"] = true
	await dymek(_wolski, t["do_lustra"], 3.0)
	await dymek(_wolski, t["wolski_wychodzi"], 2.0)
	await idz(_wolski, [Vector2(320, 250), Vector2(320, 360)], 50.0)
	_wolski.queue_free()
	_wolski = null
	antoni.sterowanie = false
	await rozmowa(t["po_podsluchu"])
	antoni.sterowanie = true


func _skrzyp(ile_slyszal: int) -> void:
	var t: Dictionary = Dialogi.SCENA18
	var f: Dictionary = Gra.flagi
	antoni.sterowanie = false
	komunikat(t["skrzyp"], 2.0)
	await dymek(_wolski, t["kto_tu"], 1.5)
	await idz(_wolski, [Vector2(440, 280)], 60.0)
	zwroc_sie(_wolski)
	await rozmowa(t["przylapany_w_trakcie"])
	f["s18_przylapany"] = true
	f["s18_podsluch_czesc"] = ile_slyszal >= 1
	super.przejdz(RETRO4 if f.get("s18_nagranie", false) else SCENA19)


func _szuflada() -> void:
	var t: Dictionary = Dialogi.SCENA18
	if is_instance_valid(_wolski):
		await rozmowa(t["szuflada_wolski"])
	elif Gra.flagi.get("s18_zeszyt", false):
		await rozmowa(t["szuflada_potem"])
	else:
		await rozmowa(t["szuflada"])
		Gra.flagi["s18_zeszyt"] = true
		Teczka.dodaj("zeszyt")


func _kosz() -> void:
	var t: Dictionary = Dialogi.SCENA18
	if Gra.flagi.get("s18_recepta", false):
		await rozmowa(t["kosz_potem"])
		return
	await rozmowa(t["kosz"])
	Gra.flagi["s18_recepta"] = true
	Teczka.dodaj("recepta")
	if Gra.flagi.get("s14_spalil", false):
		await rozmowa(t["kosz_popiol"])


## Sejf: gracz sam musi znać szyfr. Każda zła próba to chwila w plecy.
func _sejf() -> void:
	var t: Dictionary = Dialogi.SCENA18
	var f: Dictionary = Gra.flagi
	if is_instance_valid(_wolski):
		await rozmowa(t["sejf_wolski"])
		return
	if f.get("s18_sejf", false):
		await rozmowa(t["sejf_potem"])
		return
	await rozmowa(t["sejf"])
	var kod := await wpisz(t["sejf_opis"], 4)
	if kod == "":
		return
	await otworz_sejf(kod)


func otworz_sejf(kod: String) -> void:
	var t: Dictionary = Dialogi.SCENA18
	var f: Dictionary = Gra.flagi
	if kod != SZYFR:
		Sledztwo.strata(10)
		komunikat(t["sejf_zly"])
		return
	antoni.sterowanie = false
	await rozmowa(t["sejf_otwarty"])
	f["s18_sejf"] = true
	Ekwipunek.dodaj("pendrive")
	Teczka.dodaj("pendrive")
	if f.get("s8_telefon_wolski", false) and not Ekwipunek.ma("telefon_adriana"):
		await rozmowa(t["sejf_telefon"])
		Ekwipunek.dodaj("telefon_adriana")
		f["s18_telefon"] = true
		if not f.get("s17_sms", false):
			await _telefon_z_sejfu()
	antoni.sterowanie = true


## Telefon Adriana z sejfu jest naładowany: PIN ten sam, co mógł odgadnąć w mieszkaniu.
func _telefon_z_sejfu() -> void:
	var t17: Dictionary = Dialogi.SCENA17
	for proba in 3:
		await rozmowa(t17["pin_pytanie"])
		var kod := await wpisz("PIN (Enter)", 4)
		if kod == "":
			return
		if kod == PIN:
			await rozmowa(t17["pin_dobry"])
			Gra.flagi["s17_sms"] = true
			Teczka.dodaj("sms")
			return
		komunikat(t17["pin_zly"] % (2 - proba))
	await rozmowa(t17["pin_blokada"])
	Sledztwo.strata(60)


func przejdz(scena: String) -> void:
	antoni.sterowanie = false
	if _jutro:
		super.przejdz(await Rozdzial4.czwartek(self))
		return
	await rozmowa(Dialogi.SCENA18["wyjscie_noc"])
	super.przejdz(RETRO4 if Gra.flagi.get("s18_nagranie", false) else scena)
