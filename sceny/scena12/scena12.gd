extends ScenaGry
## Scena 12 (rozdział 3): pralnia, poniedziałek 10:00. Plama ciemnieje, Halina ma
## poparzone dłonie. Lampa UV leży w szafce pod ladą i da się ją wziąć tylko, gdy
## Halina obsługuje klienta albo odbiera paczkę od kuriera (nikt tego nie podpowiada).
## Podszewkę można odchylić: bez rękawiczek ze sceny 9 Antoni traci siły (s12_dotknal).
## Halina mówi, że rano dzwoniła "jakaś pani" i chciała odebrać kostium bez kwitu; numer
## leży przy książce przyjęć (s12_numer, porówna się go z kontaktami Adriana w sc. 17).
## Gdy w sc. 9 oddał kwit Kubie, Kuba na początku oddaje kostium (pół dnia straty,
## plama bledsza).
## Teksty w Dialogi.SCENA12.

const NASTEPNA := "res://sceny/scena13/scena13.tscn"
const DRZWI := Rect2(288, 318, 64, 42)
const WEJSCIE := Vector2(320, 350)
const LAMPA := Vector2(511, 200)
const SZAFKA := Vector2(292, 140)
const PRZY_LADZIE := Vector2(230, 170)
const HALINA := Vector2(205, 112)
const POL_DNIA := 360

var _halina: Node2D
var _kostium: Sprite2D
var _zajeta := false
var _kuba_bylo := false  # wersja z kwitem u Kuby: kostium mokry, plama bledsza


func _ready() -> void:
	przygotuj($Pralnia)
	Telefon.godzina = "10:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA12
	_kuba_bylo = Gra.flagi.get("s9_kwit_kuba", false)
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	_halina = postac("halina", HALINA)
	dodaj_rozmowce(_halina, _rozmowa_z_halina, "", 74.0)
	gada_w_tle(_halina, Dialogi.SCENA12_TLO["halina"], 11.0)
	_kostium = rekwizyt("kostium_folia", Vector2(497, 166), 10.0)
	miejsce(LAMPA, "Kostium", _ogledziny, 50.0)
	miejsce(SZAFKA, "Szafka pod ladą", _szafka, 30.0)
	miejsce(Vector2(207, 156), "Książka przyjęć", _ksiazka, 46.0)
	miejsce(Vector2(357, 128), "Kot", t["kot"], 76.0)
	miejsce(Vector2(540, 334), "Skrzynka nocna", t["skrzynka_nocna"], 40.0)
	miejsce(Vector2(78, 112), "Zaplecze", t["zaplecze"], 60.0)
	miejsce(Vector2(161, 112), "Zegar", t["zegar"], 80.0)
	for p in [Vector2(215, 232), Vector2(375, 232), Vector2(215, 310), Vector2(375, 310)]:
		miejsce(p, "Stojak", t["stojaki"], 60.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", NASTEPNA)
	dzwiek("gramofon.ogg", -26.0, true)
	await plansza("Pralnia \"Perła\", poniedziałek 10:00")
	await rozmowa(t["poczatek"])
	if _kuba_bylo:
		await _kuba_oddaje()
	else:
		await rozmowa(t["halina_start"])
	_kolejka()


## Co jakiś czas Halina jest zajęta: klient przy ladzie albo kurier z paczką.
## Tylko wtedy da się zajrzeć do szafki pod ladą.
func _kolejka() -> void:
	var t: Dictionary = Dialogi.SCENA12
	var nr := 0
	while not koniec:
		await get_tree().create_timer(16.0).timeout
		if koniec or not is_inside_tree():
			return
		nr += 1
		if nr % 2 == 1:
			var klient := postac("gosc_pan", WEJSCIE)
			dzwiek("dzwonek.wav", -12.0)
			await idz(klient, [PRZY_LADZIE], 50.0)
			_zajeta = true
			dymek(klient, t["klient_lada"][0], 3.0)
			await get_tree().create_timer(3.5).timeout
			dymek(_halina, t["klient_lada"][1], 3.0)
			await get_tree().create_timer(6.0).timeout
			_zajeta = false
			await idz(klient, [WEJSCIE], 50.0)
			klient.queue_free()
		else:
			var kurier := postac("maszynista", WEJSCIE)
			dzwiek("dzwonek.wav", -12.0)
			await idz(kurier, [PRZY_LADZIE], 60.0)
			dymek(kurier, t["kurier"][0], 2.5)
			dymek(_halina, t["kurier"][1], 2.5)
			_zajeta = true
			await idz(_halina, [Vector2(80, 112)], 40.0)
			_halina.visible = false
			await idz(kurier, [WEJSCIE], 60.0)
			kurier.queue_free()
			await get_tree().create_timer(6.0).timeout
			_halina.visible = true
			await idz(_halina, [HALINA], 40.0)
			_zajeta = false


func _szafka() -> void:
	var t: Dictionary = Dialogi.SCENA12
	if Ekwipunek.ma("lampa_uv"):
		await rozmowa(t["szafka_potem"])
	elif not _zajeta:
		await rozmowa(t["szafka_halina"])
	else:
		await rozmowa(t["szafka"])
		Ekwipunek.dodaj("lampa_uv")
		Gra.flagi["s12_lampa"] = true


func _ogledziny() -> void:
	var t: Dictionary = Dialogi.SCENA12
	await rozmowa(t["kostium"])
	while true:
		var opcje := ["Obejrzyj plamę", "Odchyl podszewkę"]
		if Ekwipunek.ma("lampa_uv"):
			opcje.append("Poświeć lampą UV")
		opcje.append("Zostaw")
		var w := await wybor(opcje)
		if opcje[w] == "Zostaw":
			break
		match opcje[w]:
			"Obejrzyj plamę":
				var bledsza: bool = _kuba_bylo
				await rozmowa(t["plama_bledsza" if bledsza else "plama_ciemniejsza"])
				Gra.flagi["s12_plama"] = true
			"Odchyl podszewkę":
				if Gra.flagi.get("s12_podszewka", false) or Gra.flagi.get("s12_dotknal", false):
					await rozmowa(t["podszewka_potem"])
				elif Ekwipunek.ma("rekawiczki"):
					await rozmowa(t["podszewka_rekawiczki"])
					Gra.flagi["s12_podszewka"] = true
				else:
					await rozmowa(t["podszewka_bez"])
					Gra.dodaj_sily(-20)
					Gra.flagi["s12_dotknal"] = true
			"Poświeć lampą UV":
				if Gra.flagi.get("s12_uv", false):
					await rozmowa(t["uv_potem"])
				else:
					await rozmowa(t["uv"])
					Gra.flagi["s12_uv"] = true
	antoni.sterowanie = true


func _ksiazka() -> void:
	var t: Dictionary = Dialogi.SCENA12
	await rozmowa(t["ksiazka"])
	if Gra.flagi.get("s12_pani", false):
		await rozmowa(t["ksiazka_numer"])
		Gra.flagi["s12_numer"] = true


func _rozmowa_z_halina() -> void:
	var t: Dictionary = Dialogi.SCENA12
	var tematy := [
		["Plama jest ciemniejsza", temat("s12_ciemniejsza", t["halina_plama"]), func() -> bool: return Gra.flagi.get("s12_plama", false)],
		["Co pani jest w ręce?", temat("s12_rece", t["halina_rece"])],
		["Czym pani sprawdza plamy?", t["halina_jak"]],
		["Ktoś jeszcze pytał o ten kostium?", temat("s12_pani", t["halina_pani"])],
	]
	var dowody := {
		"lampa_uv": t["halina_uv"],
		"zdjecie_plamy": t["halina_zdjecie"],
		"nozyczki": t["halina_nozyczki"],
	}
	await przesluchanie(tematy, dowody, t["halina_nic"], t["halina_koniec"])


## Wersja z kwitem u Kuby: Kuba przynosi kostium z powrotem i ucieka na próbę.
func _kuba_oddaje() -> void:
	var kuba := postac("gosc_student", PRZY_LADZIE + Vector2(30, 0))
	await rozmowa(Dialogi.SCENA12["kuba_oddaje"])
	Sledztwo.strata(POL_DNIA)
	Gra.flagi["s12_kuba_oddal"] = true
	await idz(kuba, [WEJSCIE], 70.0)
	kuba.queue_free()
	antoni.sterowanie = true
