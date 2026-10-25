extends ScenaGry
## Scena 12 (rozdział 3): pralnia, poniedziałek 10:00. Plama ciemnieje, Halina ma
## poparzone dłonie. Lampa UV leży w szafce pod ladą i da się ją wziąć tylko, gdy
## Halina obsługuje klienta albo odbiera paczkę od kuriera (nikt tego nie podpowiada).
## Podszewkę można odchylić: bez rękawiczek ze sceny 9 Antoni traci siły (s12_dotknal).
## Po UV albo przy próbie wyjścia wchodzi Ania i trzeba wybrać: kostium zostaje u Haliny
## (s12_halina) albo jedzie z Anią do centrum (s12_ania_zabrala: pół dnia straty,
## plama bledsza). Gdy w sc. 9 oddał kwit Ani, Ania na początku sama oddaje kostium.
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
var _ania_bylo := false  # wersja z kwitem: kostium już po praniu w domu Ani


func _ready() -> void:
	przygotuj($Pralnia)
	Telefon.godzina = "10:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA12
	_ania_bylo = Gra.flagi.get("s9_kwit_ania", false)
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	_halina = postac("halina", HALINA)
	dodaj_rozmowce(_halina, _rozmowa_z_halina, "", 74.0)
	gada_w_tle(_halina, Dialogi.SCENA12_TLO["halina"], 11.0)
	_kostium = rekwizyt("kostium_folia", Vector2(497, 166), 10.0)
	miejsce(LAMPA, "Kostium", _ogledziny, 50.0)
	miejsce(SZAFKA, "Szafka pod ladą", _szafka, 30.0)
	miejsce(Vector2(207, 156), "Książka przyjęć", t["ksiazka"], 46.0)
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
	if _ania_bylo:
		await _ania_oddaje()
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
	if not _kostium.visible:
		await rozmowa([["", "Pusty stół. Kostium pojechał z Anią."]])
		return
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
				var bledsza: bool = _ania_bylo or Gra.flagi.get("s12_ania_zabrala", false)
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
	# po odkryciu w UV do pralni "przypadkiem" wchodzi Ania
	if Gra.flagi.get("s12_uv", false) and not _ania_bylo and not Gra.flagi.get("s12_ania_przyszla", false):
		await _ania_przychodzi()


func _rozmowa_z_halina() -> void:
	var t: Dictionary = Dialogi.SCENA12
	var tematy := [
		["Plama jest ciemniejsza", temat("s12_ciemniejsza", t["halina_plama"]), func() -> bool: return Gra.flagi.get("s12_plama", false)],
		["Co pani jest w ręce?", temat("s12_rece", t["halina_rece"])],
		["Czym pani sprawdza plamy?", t["halina_jak"]],
	]
	var dowody := {
		"lampa_uv": t["halina_uv"],
		"zdjecie_plamy": t["halina_zdjecie"],
		"nozyczki": t["halina_nozyczki"],
	}
	await przesluchanie(tematy, dowody, t["halina_nic"], t["halina_koniec"])


## Wersja z kwitem u Ani: Ania przynosi kostium z powrotem i ucieka.
func _ania_oddaje() -> void:
	var ania := postac("ania", PRZY_LADZIE + Vector2(30, 0))
	await rozmowa(Dialogi.SCENA12["ania_oddaje"])
	Sledztwo.strata(POL_DNIA)
	Gra.flagi["s12_ania_oddala"] = true
	await idz(ania, [WEJSCIE], 70.0)
	ania.queue_free()
	antoni.sterowanie = true


## Ania wchodzi i chce zabrać kostium. Najpierw można ją wypytać, potem wybór.
func _ania_przychodzi() -> void:
	var t: Dictionary = Dialogi.SCENA12
	Gra.flagi["s12_ania_przyszla"] = true
	antoni.sterowanie = false
	var ania := postac("ania", WEJSCIE)
	dzwiek("dzwonek.wav", -12.0)
	await idz(ania, [Vector2(420, 260)], 50.0)
	zwroc_sie(ania)
	await rozmowa(t["ania_wchodzi"])
	var tematy := [
		["Co tu robisz?", temat("s12_ania_przypadek", t["ania_po_co"])],
		["Gdzie byłaś w czwartek wieczorem?", temat("s12_ania_czwartek", t["ania_czwartek"])],
		["Ładny pierścionek", temat("s12_pierscionek", t["ania_pierscionek"]), func() -> bool: return Gra.flagi.get("s11_foto", false)],
	]
	var dowody := {
		"zdjecie_plamy": t["ania_zdjecie"],
		"karta_kwit": t["ania_kwit"],
		"karta_podszewka": t["ania_podszewka"],
	}
	await przesluchanie(tematy, dowody, t["ania_nic"])
	await rozmowa(t["ania_prosi"])
	var w := await wybor(t["wybor"])
	if w == 0:
		await rozmowa(t["wybor_halina"])
		Gra.flagi["s12_halina"] = true
		await idz(ania, [WEJSCIE], 70.0)
		ania.queue_free()
	else:
		await rozmowa(t["wybor_ania"])
		Gra.flagi["s12_ania_zabrala"] = true
		_kostium.visible = false
		await idz(ania, [WEJSCIE], 70.0)
		ania.visible = false
		await plansza(t["godzine_pozniej"])
		Sledztwo.strata(POL_DNIA)
		ania.visible = true
		await idz(ania, [Vector2(420, 260)], 70.0)
		await rozmowa(t["ania_wraca"])
		_kostium.visible = true
		await idz(ania, [WEJSCIE], 70.0)
		ania.queue_free()
	antoni.sterowanie = true


## Wyjście: jeśli Ania jeszcze nie przyszła, wchodzi w drzwiach.
func przejdz(scena: String) -> void:
	if not _ania_bylo and not Gra.flagi.get("s12_ania_przyszla", false):
		await _ania_przychodzi()
		return
	super.przejdz(scena)
