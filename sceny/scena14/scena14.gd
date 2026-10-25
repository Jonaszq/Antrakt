extends ScenaGry
## Scena 14 (rozdział 4): garderoba Wolskiego, wtorek 19:40, przed drugim spektaklem.
## Wolski nie rozmawia, dopóki nie dostanie peruki: leży pod szalem na kanapie
## (s14_peruka). Oddana garderobianej: ta wygaduje, że w czwartek o 7 Wolski zgłosił
## chorobę (s14_chory). Że to on miał zginąć, Wolski przyjmie dopiero, gdy Antoni powie
## to wprost i pokaże dowód (s14_ostrzezony). Potem puka pani Stasia z bukietem: zapytana,
## widziała Wolskiego pod apteką (s14_apteka). Plakat "HAMLET 1998" porównany z programem
## daje s14_rok (szyfr sejfu w sc. 18). Przy wyjściu Antoni widzi przez szparę, jak Wolski
## pali kartki: wejść (s14_spalil) albo odejść. Teksty w Dialogi.SCENA14.

const NASTEPNA := "res://sceny/scena15/scena15.tscn"
const DRZWI := Rect2(288, 318, 64, 42)
const WOLSKI := Vector2(290, 132)
const GARDEROBIANA := Vector2(470, 292)
const STASIA := Vector2(548, 316)

var _wolski: Node2D
var _garderobiana: Node2D
var _stasia: Node2D


func _ready() -> void:
	przygotuj($GarderobaWolskiego)
	Telefon.godzina = "19:40"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA14
	antoni.position = Vector2(320, 296)
	antoni.stan("gora")
	_wolski = postac("wolski", WOLSKI)
	dodaj_rozmowce(_wolski, _rozmowa_z_wolskim)
	gada_w_tle(_wolski, Dialogi.SCENA14_TLO["wolski"], 10.0)
	_garderobiana = postac("garderobiana", GARDEROBIANA)
	dodaj_rozmowce(_garderobiana, _rozmowa_z_garderobiana)
	gada_w_tle(_garderobiana, Dialogi.SCENA14_TLO["garderobiana"], 8.0)
	miejsce(Vector2(102, 262), "Kanapa", _kanapa)
	miejsce(Vector2(165, 104), "Plakat", _plakat_hamlet, 70.0)
	miejsce(Vector2(211, 104), "Plakat", t["plakat_romeo"], 70.0)
	miejsce(Vector2(387, 104), "Plakat", t["plakat_akt"], 70.0)
	miejsce(Vector2(128, 150), "Sejf", _po_kolei("sejf", "s14_sejf"), 30.0)
	miejsce(Vector2(76, 132), "Szafa", t["szafa"], 70.0)
	miejsce(Vector2(575, 226), "Parawan", t["parawan"], 70.0)
	miejsce(Vector2(470, 272), "Stojak", _po_kolei("stojak", ""), 70.0)
	miejsce(Vector2(582, 322), "Bukiety", t["bukiety"], 50.0)
	miejsce(Vector2(359, 124), "Kosz", t["kosz"], 20.0)
	miejsce(Vector2(330, 116), "Toaletka", t["toaletka"], 40.0)
	miejsce(Vector2(215, 258), "Fotel", t["fotel"], 30.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", NASTEPNA)
	_glosnik()
	_za_sciana()
	await plansza("Garderoba Wolskiego, wtorek 19:40")
	await rozmowa(t["poczatek"])


## Pierwszy raz pełny opis (i flaga), potem krótka wersja "<klucz>_potem".
func _po_kolei(klucz: String, flaga: String) -> Callable:
	var stan := {"bylo": false}
	return func() -> void:
		var t: Dictionary = Dialogi.SCENA14
		await rozmowa(t[klucz + "_potem"] if stan.bylo and t.has(klucz + "_potem") else t[klucz])
		stan.bylo = true
		if flaga != "":
			Gra.flagi[flaga] = true


## Komunikaty inspicjenta przez głośnik: odliczanie do spektaklu (bez limitu czasu).
func _glosnik() -> void:
	for tekst in Dialogi.SCENA14["glosnik"]:
		await get_tree().create_timer(50.0).timeout
		if koniec:
			return
		komunikat("Głośnik: " + tekst)


func _za_sciana() -> void:
	while not koniec:
		await get_tree().create_timer(randf_range(30.0, 45.0)).timeout
		if not koniec and wolny():
			komunikat(Dialogi.SCENA14["za_sciana"])


func _kanapa() -> void:
	var t: Dictionary = Dialogi.SCENA14
	var f: Dictionary = Gra.flagi
	if f.get("s14_ma_peruke", false) or f.get("s14_peruka", false):
		await rozmowa(t["kanapa_potem"])
		return
	await rozmowa(t["kanapa"])
	f["s14_ma_peruke"] = true


func _plakat_hamlet() -> void:
	var t: Dictionary = Dialogi.SCENA14
	if Ekwipunek.ma("program"):
		await rozmowa(t["plakat_hamlet_program"])
		Gra.flagi["s14_rok"] = true
	else:
		await rozmowa(t["plakat_hamlet"])
	Gra.flagi["s14_plakat"] = true


## Peruka wraca na główkę: od teraz Wolski rozmawia.
func _oddaj_peruke() -> void:
	Gra.flagi["s14_ma_peruke"] = false
	Gra.flagi["s14_peruka"] = true
	antoni.sterowanie = false
	await idz(_garderobiana, [Vector2(340, 160)], 50.0)
	antoni.sterowanie = true


func _rozmowa_z_garderobiana() -> void:
	var t: Dictionary = Dialogi.SCENA14
	var f: Dictionary = Gra.flagi
	if f.get("s14_ma_peruke", false):
		await rozmowa(t["peruka_oddana"])
		f["s14_chory"] = true
		await _oddaj_peruke()
		return
	if not f.get("s14_peruka", false):
		await rozmowa(t["garderobiana_szuka_znowu" if f.get("s14_szukala", false) else "garderobiana_szuka"])
		f["s14_szukala"] = true
		return
	await rozmowa(t["garderobiana_potem"])
	var tematy := [
		["Pan Wolski był w czwartek chory?", temat("s14_chory", t["garderobiana_czwartek"])],
		["Adrian tu przychodził?", temat("s14_adrian_tu", t["garderobiana_adrian"])],
	]
	await przesluchanie(tematy, {}, t["garderobiana_nic"])


func _rozmowa_z_wolskim() -> void:
	var t: Dictionary = Dialogi.SCENA14
	var f: Dictionary = Gra.flagi
	if f.get("s14_ma_peruke", false):
		await rozmowa(t["wolski_peruka"])
		await _oddaj_peruke()
		await rozmowa(t["wolski_start"])
		f["s14_zagadal"] = true
	elif not f.get("s14_peruka", false):
		await rozmowa(t["wolski_bez_peruki_znowu" if f.get("s14_bez_peruki", false) else "wolski_bez_peruki"])
		f["s14_bez_peruki"] = true
		return
	elif not f.get("s14_zagadal", false):
		await rozmowa(t["wolski_start"])
		f["s14_zagadal"] = true
	else:
		await rozmowa(t["wolski_znowu"])
	var ostrzezony := func() -> bool: return f.get("s14_ostrzezony", false)
	var tematy := [
		["Jak się pan trzyma?", t["wolski_adrian"]],
		["Gdzie pan był w czwartek rano?", temat("s14_wolski_czwartek", t["wolski_czwartek"])],
		["Plama na pańskim kostiumie", t["wolski_kostium"], func() -> bool: return Ekwipunek.ma("zdjecie_plamy")],
		["To pan miał zginąć", _mial_zginac, func() -> bool: return not ostrzezony.call()],
		["Kto mógłby chcieć pana śmierci?", temat("s14_podejrzani", t["wolski_kto"]), ostrzezony],
		["Co Lis ma do pieniędzy?", temat("s14_polisa", t["wolski_ubezpieczenie"]), func() -> bool: return f.get("s14_podejrzani", false)],
	]
	var dowody := {
		"zdjecie_plamy": _dowod,
		"zdjecie_pasy": _dowod,
		"karta_podszewka": _dowod,
		"telefon_adriana": t["wolski_telefon"],
		"kwit_odbioru": t["wolski_kwit"],
		"karta_kwit": t["wolski_kwit"],
		"noz": t["wolski_noz"],
	}
	await przesluchanie(tematy, dowody, t["wolski_nic"], t["wolski_koniec"])


func _mial_zginac() -> void:
	var t: Dictionary = Dialogi.SCENA14
	await rozmowa(t["wolski_zginac_znowu" if Gra.flagi.get("s14_teoria", false) else "wolski_zginac"])
	Gra.flagi["s14_teoria"] = true


## Dowód działa dopiero po tym, jak Antoni powie wprost, że to Wolski miał zginąć.
func _dowod() -> void:
	var t: Dictionary = Dialogi.SCENA14
	var f: Dictionary = Gra.flagi
	if f.get("s14_ostrzezony", false):
		await rozmowa(t["wolski_dowod_potem"])
	elif not f.get("s14_teoria", false):
		await rozmowa(t["wolski_dowod_bez"])
	else:
		await rozmowa(t["dowod_trucizny"])
		f["s14_ostrzezony"] = true
		_stasia_puka()


## Kilka sekund po ostrzeżeniu puka pani Stasia z bukietem.
func _stasia_puka() -> void:
	await get_tree().create_timer(6.0).timeout
	while not wolny():
		await get_tree().create_timer(0.5).timeout
	if koniec:
		return
	var t: Dictionary = Dialogi.SCENA14
	antoni.sterowanie = false
	await rozmowa(t["stasia_puka"])
	_stasia = postac("stasia", Vector2(320, 350))
	await idz(_stasia, [Vector2(420, 330), STASIA], 40.0)
	await rozmowa(t["stasia_wolski"])
	dodaj_rozmowce(_stasia, _rozmowa_ze_stasia)
	antoni.sterowanie = true


func _rozmowa_ze_stasia() -> void:
	var t: Dictionary = Dialogi.SCENA14
	if Gra.flagi.get("s14_stasia", false):
		await rozmowa(t["stasia_potem"])
	else:
		await rozmowa(t["stasia_start"])
		Gra.flagi["s14_stasia"] = true
	var tematy := [
		["Często pani przynosi kwiaty?", t["stasia_bukiet"]],
		["Kiedy ostatnio widziała pani pana Wolskiego poza teatrem?", _stasia_czwartek],
	]
	await przesluchanie(tematy, {}, t["stasia_nic"], t["stasia_koniec"])


func _stasia_czwartek() -> void:
	await rozmowa(Dialogi.SCENA14["stasia_czwartek"])
	Gra.flagi["s14_apteka"] = true
	await dymek(_wolski, Dialogi.SCENA14["wolski_przerywa"], 2.5)


## Wyjście: po ostrzeżeniu Antoni widzi przez szparę w drzwiach, jak Wolski pali kartki.
func przejdz(scena: String) -> void:
	var t: Dictionary = Dialogi.SCENA14
	antoni.sterowanie = false
	if not Gra.flagi.get("s14_ostrzezony", false):
		await rozmowa(t["wyjscie_bez"])
		super.przejdz(scena)
		return
	if is_instance_valid(_stasia):
		await dymek(_stasia, t["stasia_wychodzi"], 1.5)
		_stasia.queue_free()
	_garderobiana.visible = false
	_wolski.position = Vector2(352, 140)
	await rozmowa(t["wyjscie_szpara"])
	if await wybor(t["szpara_wybor"]) == 0:
		await rozmowa(t["wchodzi"])
		Gra.flagi["s14_spalil"] = true
	else:
		await rozmowa(t["odchodzi"])
	super.przejdz(scena)
