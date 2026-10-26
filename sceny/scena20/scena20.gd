extends ScenaGry
## Scena 20 (rozdział 4, opcjonalna): garderoba Ani, czwartek 16:00, Ania na próbie.
## Bez zapasowego klucza Antoni czeka godzinę na garderobianą. W koszu gumowe rękawiczki:
## świecą w UV tylko z lampą ze sceny 12 (karta "rekawiczki"); bez własnych lateksowych
## rękawiczek Antoni sparzy palce (s20_dotknal, pół godziny w plecy). Spinka z pudełka z charakteryzacją
## otwiera szufladę z wydrukami przelewów (karta "przelewy"). Kartka od Adriana na lustrze.
## Kto siedzi za długo, słyszy kroki, a za drugim razem wchodzi Ania (s20_przylapany).
## Wyjście: wybór w Rozdzial4.czwartek. Teksty w Dialogi.SCENA20.

const DRZWI := Rect2(288, 318, 64, 42)
const PIERWSZE_KROKI := 100.0
const ANIA_WCHODZI := 70.0
const PARZY := 30  # minut na mycie palców

var _ania: Node2D


func _ready() -> void:
	przygotuj($Garderoba)
	Telefon.godzina = "16:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA20
	Gra.flagi["s20_byl"] = true
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	var scena := Node2D.new()
	scena.position = Vector2(320, 352)
	obiekty.add_child(scena)
	gada_w_tle(scena, t["proba"], 12.0)
	miejsce(Vector2(359, 124), "Kosz", _kosz, 20.0)
	miejsce(Vector2(256, 120), "Pudełko z charakteryzacją", _pudelko, 30.0)
	miejsce(Vector2(318, 124), "Szuflada", _szuflada, 20.0)
	miejsce(Vector2(290, 108), "Lustro", _lustro, 60.0)
	miejsce(Vector2(309, 104), "Zdjęcie", t["zdjecie"], 40.0)
	miejsce(Vector2(440, 126), "Wieszak", t["wieszak"], 60.0)
	miejsce(Vector2(80, 280), "Kanapa", t["kanapa"])
	miejsce(Vector2(76, 130), "Szafa", t["szafa"], 70.0)
	miejsce(Vector2(191, 292), "Kwiaty", t["kwiaty"])
	miejsce(Vector2(575, 228), "Parawan", t["parawan"], 70.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", "")
	await plansza(t["plansza"])
	if Ekwipunek.ma("klucz"):
		await rozmowa(t["poczatek_klucz"])
	else:
		await rozmowa(t["poczatek_bez_klucza"])
		Sledztwo.strata(60)
	_kroki()


## Za długo w środku: najpierw kroki mijają drzwi, potem wchodzi Ania.
func _kroki() -> void:
	var t: Dictionary = Dialogi.SCENA20
	await get_tree().create_timer(PIERWSZE_KROKI).timeout
	if koniec:
		return
	komunikat(t["kroki"], 4.0)
	await get_tree().create_timer(5.0).timeout
	if koniec:
		return
	komunikat(t["kroki_mijaja"], 3.0)
	await get_tree().create_timer(ANIA_WCHODZI).timeout
	if koniec:
		return
	komunikat(t["kroki"], 3.0)
	await get_tree().create_timer(3.0).timeout
	while not koniec and not wolny():
		await get_tree().create_timer(0.3).timeout
	if koniec:
		return
	antoni.sterowanie = false
	_ania = postac("ania", Vector2(320, 360))
	await idz(_ania, [Vector2(320, 320)], 50.0)
	zwroc_sie(_ania)
	await rozmowa(t["ania_wchodzi"])
	Gra.flagi["s20_przylapany"] = true
	przejdz("")


func _kosz() -> void:
	var t: Dictionary = Dialogi.SCENA20
	var f: Dictionary = Gra.flagi
	if f.get("s20_kosz", false):
		await rozmowa(t["kosz_potem"])
		return
	f["s20_kosz"] = true
	await rozmowa(t["kosz"])
	if Ekwipunek.ma("rekawiczki"):
		await rozmowa(t["kosz_rekawiczki"])
	else:
		await rozmowa(t["kosz_reka"])
		Sledztwo.strata(PARZY)
		f["s20_dotknal"] = true
	if Ekwipunek.ma("lampa_uv"):
		await rozmowa(t["kosz_uv"])
		f["s20_uv"] = true
		Teczka.dodaj("rekawiczki")
	else:
		await rozmowa(t["kosz_bez_uv"])


func _pudelko() -> void:
	var t: Dictionary = Dialogi.SCENA20
	if Ekwipunek.ma("spinka") or Gra.flagi.get("s20_przelewy", false):
		await rozmowa(t["pudelko_potem"])
		return
	await rozmowa(t["pudelko"])
	Ekwipunek.dodaj("spinka")


func _szuflada() -> void:
	var t: Dictionary = Dialogi.SCENA20
	var f: Dictionary = Gra.flagi
	if f.get("s20_przelewy", false):
		await rozmowa(t["szuflada_potem"])
	elif not Ekwipunek.ma("spinka"):
		await rozmowa(t["szuflada_zamknieta"])
	else:
		await rozmowa(t["szuflada_otwieram"])
		Sledztwo.strata(5)
		f["s20_przelewy"] = true
		Teczka.dodaj("przelewy")


func _lustro() -> void:
	await rozmowa(Dialogi.SCENA20["lustro"])
	Gra.flagi["s20_lustro"] = true


func przejdz(_scena: String) -> void:
	if koniec:
		return
	antoni.sterowanie = false
	if not Gra.flagi.get("s20_przylapany", false):
		await rozmowa(Dialogi.SCENA20["wyjscie"])
	super.przejdz(await Rozdzial4.czwartek(self))
