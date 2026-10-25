extends ScenaGry
## Scena 15 (rozdział 4): pracownia kostiumów, środa 9:00. Irena jest wroga: bez papierosa
## (s15_zapalila) odpowiada półsłówkami. Co jakiś czas na korytarzu dzwoni telefon i Irena
## wychodzi: tylko wtedy da się wziąć klucze przy maszynie i otworzyć szafę z belami jedwabiu
## (s15_bele). Gdy Irena wraca, a szafa nie jest otwarta, Antoni odkłada klucze. W spisie
## tkanin na regale (s15_spis) jedwabiu nie ma. Dopiero bele i spis razem łamią Irenę
## (s15_przyznala): kradnie materiały, w czwartek rano była w hurtowni. Paragon (karta
## "paragon") leży w skrzynce pod stołem, ale Antoni go tam zauważy dopiero, kiedy wie,
## czego szuka. Gracz sam decyduje, czy skreślić Irenę. Przy wyjściu wybór: gabinet Lisa
## (opcjonalna sc. 16) albo od razu mieszkanie Adriana. Teksty w Dialogi.SCENA15.

const NASTEPNA := "res://sceny/scena17/scena17.tscn"
const DRZWI := Rect2(26, 104, 52, 36)
const MIEJSCE_IRENY := Vector2(132, 372)
const PRZY_DRZWIACH := Vector2(52, 170)
const CO_ILE_TELEFON := 40.0
const NA_KORYTARZU := 15.0

var _irena: Node2D
var _proba: Node2D
var _nieobecna := false
var _klucze := false  # Antoni trzyma klucze Ireny


func _ready() -> void:
	przygotuj($Pracownia)
	Telefon.godzina = "9:00"
	Gra.flagi["dni_do_pogrzebu"] = 2
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA15
	antoni.position = Vector2(52, 156)
	antoni.stan("dol")
	_irena = postac("irena", MIEJSCE_IRENY)
	dodaj_rozmowce(_irena, _rozmowa_z_irena)
	gada_w_tle(_irena, Dialogi.SCENA15_TLO["irena"], 9.0)
	# próba muzyczna na korytarzu: głosy zza drzwi
	_proba = Node2D.new()
	_proba.position = Vector2(52, 112)
	obiekty.add_child(_proba)
	gada_w_tle(_proba, Dialogi.SCENA15_TLO["proba"], 14.0)
	rekwizyt("opaski_stos", Vector2(86, 352), 22.0)
	miejsce(Vector2(84, 330), "Klucze", _wez_klucze, 40.0)
	miejsce(Vector2(134, 126), "Szafa", _szafa, 70.0)
	miejsce(Vector2(668, 128), "Regał", _regal, 70.0)
	miejsce(Vector2(622, 288), "Skrzynka pod stołem", _skrzynka, 24.0)
	miejsce(Vector2(52, 300), "Maszyna", t["maszyna"], 40.0)
	miejsce(Vector2(521, 112), "Okno", t["okno"], 70.0)
	miejsce(Vector2(231, 138), "Radio", t["radio"], 40.0)
	miejsce(Vector2(667, 438), "Bele", t["bele_podloga"], 30.0)
	var t11: Dictionary = Dialogi.SCENA11
	miejsce(Vector2(472, 112), "Zdjęcie", t11["foto_potem"], 76.0)
	miejsce(Vector2(207, 318), "Kostium", t11["manekin_wolski_potem"], 60.0)
	miejsce(Vector2(748, 130), "Szafa", t11["szafa"], 70.0)
	miejsce(Vector2(762, 446), "Kufer", t11["kufer"], 30.0)
	miejsce(Vector2(575, 440), "Kosz", t11["kosz"], 30.0)
	miejsce(Vector2(739, 348), "Parawan", t11["parawan"], 60.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", NASTEPNA)
	_telefon_na_korytarzu()
	await plansza("Pracownia kostiumów, środa 9:00")
	await rozmowa(t["poczatek"])


## Telefon na korytarzu wyciąga Irenę z pracowni na kilkanaście sekund.
func _telefon_na_korytarzu() -> void:
	var t: Dictionary = Dialogi.SCENA15
	while not koniec:
		await get_tree().create_timer(CO_ILE_TELEFON).timeout
		while not koniec and not wolny():
			await get_tree().create_timer(0.5).timeout
		if koniec or Gra.flagi.get("s15_bele", false):
			return
		dzwiek("telefon.wav", -10.0)
		komunikat(t["telefon_dzwoni"], 2.0)
		await dymek(_irena, t["irena_idzie"], 1.5)
		await idz(_irena, [Vector2(132, 250), PRZY_DRZWIACH, Vector2(52, 120)], 60.0)
		_irena.visible = false
		_irena.position = Vector2(-400, -400)  # poza zasięgiem E
		_nieobecna = true
		await get_tree().create_timer(NA_KORYTARZU).timeout
		while not koniec and not wolny():
			await get_tree().create_timer(0.5).timeout
		if koniec:
			return
		var odlozyl := _klucze
		if odlozyl:
			antoni.sterowanie = false
			await rozmowa(t["klucze_odkladam"])
			_klucze = false
		_nieobecna = false
		_irena.position = Vector2(52, 120)
		_irena.visible = true
		await idz(_irena, [PRZY_DRZWIACH, Vector2(132, 250), MIEJSCE_IRENY], 60.0)
		if odlozyl:
			antoni.sterowanie = true
		dymek(_irena, t["irena_wraca"], 2.5)


func _wez_klucze() -> void:
	var t: Dictionary = Dialogi.SCENA15
	if Gra.flagi.get("s15_bele", false):
		await rozmowa(t["maszyna"])
	elif _klucze:
		await rozmowa(t["szafa_zamknieta"])
	elif not _nieobecna:
		await rozmowa(t["klucze_przy_irenie"])
	else:
		await rozmowa(t["klucze"])
		_klucze = true


func _szafa() -> void:
	var t: Dictionary = Dialogi.SCENA15
	if Gra.flagi.get("s15_bele", false):
		await rozmowa(t["szafa_potem"])
	elif not _klucze:
		await rozmowa(t["szafa_zamknieta"])
	else:
		await rozmowa(t["szafa_otwieram"])
		_klucze = false
		Gra.flagi["s15_bele"] = true


func _regal() -> void:
	var t: Dictionary = Dialogi.SCENA15
	await rozmowa(t["regal_potem" if Gra.flagi.get("s15_spis", false) else "regal"])
	Gra.flagi["s15_spis"] = true


## Paragon leży w ścinkach. Antoni go wyłowi, dopiero gdy wie o hurtowni.
func _skrzynka() -> void:
	var t: Dictionary = Dialogi.SCENA15
	var f: Dictionary = Gra.flagi
	if Ekwipunek.ma("paragon"):
		await rozmowa(t["skrzynka_potem"])
	elif not f.get("s15_hurtownia", false):
		await rozmowa(t["skrzynka_bez"])
	else:
		await rozmowa(t["skrzynka_paragon"])
		Ekwipunek.dodaj("paragon")
		Teczka.dodaj("paragon")


func _rozmowa_z_irena() -> void:
	var t: Dictionary = Dialogi.SCENA15
	var f: Dictionary = Gra.flagi
	if f.get("s15_zagadal", false):
		await rozmowa(t["irena_znowu"])
	else:
		await rozmowa(t["irena_start_wolski" if f.get("s14_podejrzani", false) else "irena_start"])
		f["s15_zagadal"] = true
	# bez papierosa Irena odpowiada półsłówkami
	var mila := func() -> bool: return f.get("s15_zapalila", false) or f.get("s15_przyznala", false)
	var przyznala := func() -> bool: return f.get("s15_przyznala", false)
	var tematy := [
		["Zapali pani?", _papieros, func() -> bool: return Ekwipunek.ma("papierosy") and not f.get("s15_zapalila", false)],
		["Maszyna stoi. Nie szyje pani?", temat("s15_pensja", t["irena_wolna"]), mila],
		["Wolski mówi, że pani go nienawidzi", _zalezy("irena_nienawidzi", mila), func() -> bool: return f.get("s14_podejrzani", false)],
		["Gdzie pani była w czwartek rano?", _czwartek],
		["Kto jeszcze ma klucz do pracowni?", _klucz],
		["Bele w szafie", _bele, func() -> bool: return f.get("s15_bele", false) and not przyznala.call()],
	]
	var dowody := {
		"paragon": _paragon,
		"karta_paragon": _paragon,
		"zdjecie_plamy": t["irena_podszewka"],
		"zdjecie_pasy": t["irena_podszewka"],
		"karta_podszewka": t["irena_podszewka"],
	}
	var koniec_rozmowy: Array = t["irena_koniec_papieros"] if f.get("s15_zapalila", false) else t["irena_koniec"]
	await przesluchanie(tematy, dowody, t["irena_nic"], koniec_rozmowy)


## Odpowiedź zależna od humoru Ireny: "<klucz>" albo "<klucz>_zla".
func _zalezy(klucz: String, mila: Callable) -> Callable:
	return func() -> void:
		await rozmowa(Dialogi.SCENA15[klucz if mila.call() else klucz + "_zla"])


func _papieros() -> void:
	await rozmowa(Dialogi.SCENA15["irena_papieros"])
	Ekwipunek.usun("papierosy")
	Gra.flagi["s15_zapalila"] = true


func _czwartek() -> void:
	var t: Dictionary = Dialogi.SCENA15
	var f: Dictionary = Gra.flagi
	if f.get("s15_przyznala", false):
		await rozmowa(t["irena_hurtownia"])
		f["s15_hurtownia"] = true
	elif f.get("s15_zapalila", false):
		await rozmowa(t["irena_czwartek"])
		f["s15_klamala"] = true
	else:
		await rozmowa(t["irena_czwartek_zla"])


func _klucz() -> void:
	var t: Dictionary = Dialogi.SCENA15
	if Gra.flagi.get("s15_przyznala", false) or Gra.flagi.get("s15_zapalila", false):
		await rozmowa(t["irena_klucz"])
		Gra.flagi["s15_klucz_ania"] = true
	else:
		await rozmowa(t["irena_klucz_zla"])


## Bele bez spisu Irena zbywa. Bele i spis razem: przyznaje się do kradzieży.
func _bele() -> void:
	var t: Dictionary = Dialogi.SCENA15
	if not Gra.flagi.get("s15_spis", false):
		await rozmowa(t["irena_bele_bez"])
		return
	await rozmowa(t["irena_bele_przyznanie"])
	Gra.flagi["s15_przyznala"] = true


func _paragon() -> void:
	await rozmowa(Dialogi.SCENA15["irena_paragon"])
	Gra.flagi["s15_alibi"] = true


## Wyjście: opcjonalnie gabinet Lisa (sc. 16) i obiad u Oli, potem mieszkanie Adriana.
func przejdz(scena: String) -> void:
	antoni.sterowanie = false
	super.przejdz(await Rozdzial4.sroda(self, false))
