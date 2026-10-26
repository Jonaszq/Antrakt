extends ScenaGry
## Scena 11b (rozdział 3): kulisy, niedziela 20:00, po pracowni Ireny. Teatr zamknięty
## na żałobę, ekipa jeszcze siedzi. Gracz sam chodzi i wypytuje, nikt nie mówi pierwszy:
##  sprzątaczka gada dopiero po oddaniu kluczy spod skrzyni (s11b_klucze): w czwartek
##    o 23:00 kobieta w kapturze wyniosła pokrowiec na kostium (s11b_pokrowiec),
##  maszynista o czwartku: 7:45 kostium z kartką "WOLSKI" w pustej pracowni (s11b_wieszak),
##  garderobiana Wolskiego kłamie, pęka przy zdjęciu plamy albo pasów: w środę pytała ją
##    Ania o kostium Wolskiego na próbę (s11b_ania_pytala),
##  Kuba kłamie o czwartkowej nocy, pęka przy kwicie albo słowach Haliny (s10_kuba_pytal):
##    o 23:40 kobieta w kapturze przy skrzynce nocnej (s11b_kuba_widzial).
## Marta daje pieniądze na taksówkę. Wszystko to są argumenty na finał i na tablicę.
## Wyjście korytarzem: poniedziałek, scena 12. Teksty w Dialogi.SCENA11B.

const NASTEPNA := "res://sceny/scena12/scena12.tscn"
const DOL := Rect2(352, 424, 80, 50)
const WYJSCIE := Rect2(660, 104, 52, 34)
const GARDEROBY := Rect2(56, 104, 48, 36)
const PODWORZE := Rect2(560, 104, 44, 34)
const KLUCZE := Vector2(120, 412)

var _sprzataczka: Node2D
var _kuba: Node2D


func _ready() -> void:
	przygotuj($Kulisy)
	Telefon.godzina = "20:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA11B
	$Kulisy/Mrok.color = Color(0.5, 0.46, 0.56)
	antoni.position = Vector2(392, 400)
	antoni.stan("gora")
	var marta: Node2D = obiekty.get_node("Marta")
	marta.position = Vector2(380, 200)
	dodaj_rozmowce(marta, _marta)
	var maszynista := postac("maszynista", Vector2(520, 330))
	dodaj_rozmowce(maszynista, _maszynista)
	var garderobiana := postac("garderobiana", Vector2(160, 250))
	dodaj_rozmowce(garderobiana, _garderobiana)
	_sprzataczka = postac("sprzataczka", Vector2(600, 230))
	dodaj_rozmowce(_sprzataczka, _sprzataczka_rozmowa)
	_kuba = postac("gosc_student", Vector2(470, 410))
	dodaj_rozmowce(_kuba, _kuba_rozmowa)
	miejsce(KLUCZE, "Pod skrzynią", _klucze, 24.0)
	miejsce(Vector2(96, 370), "Skrzynie", t["skrzynie"], 40.0)
	miejsce(Vector2(420, 290), "Lampa", t["ghost_light"], 60.0)
	zamkniete_drzwi(WYJSCIE, Dialogi.DRZWI["kulisy_garderoby"])
	zamkniete_drzwi(GARDEROBY, Dialogi.DRZWI["kulisy_garderoby"])
	zamkniete_drzwi(PODWORZE, Dialogi.DRZWI["kulisy_podworze"])
	ustaw_wyjscie(DOL, t["wyjscie"], NASTEPNA)
	gada_w_tle(maszynista, t["tlo"]["maszynista"], 11.0)
	gada_w_tle(_kuba, t["tlo"]["kuba"], 9.0)
	gada_w_tle(_sprzataczka, t["tlo"]["sprzataczka"], 13.0)
	spacer(_sprzataczka, [Vector2(600, 230), Vector2(700, 250), Vector2(680, 380)], 20.0, 4.0)
	await plansza(t["plansza"])
	await rozmowa(t["start"])


func _marta() -> void:
	var t: Dictionary = Dialogi.SCENA11B
	if Gra.flagi.get("s11b_marta", false):
		await rozmowa(t["marta_potem"])
		return
	await rozmowa(t["marta"])
	Gra.flagi["s11b_marta"] = true
	znajdz_kase(20)


func _klucze() -> void:
	var t: Dictionary = Dialogi.SCENA11B
	if Ekwipunek.ma("klucze_schowka") or Gra.flagi.get("s11b_klucze", false):
		await rozmowa(t["klucze_potem"])
		return
	await rozmowa(t["klucze"])
	Ekwipunek.dodaj("klucze_schowka")


func _sprzataczka_rozmowa() -> void:
	var t: Dictionary = Dialogi.SCENA11B
	var f: Dictionary = Gra.flagi
	if not f.get("s11b_klucze", false):
		if not Ekwipunek.ma("klucze_schowka"):
			await rozmowa(t["sprzataczka_bez"] if f.get("s11b_sprzataczka", false) else t["sprzataczka_start"])
			f["s11b_sprzataczka"] = true
			return
		Ekwipunek.usun("klucze_schowka")
		f["s11b_klucze"] = true
		await rozmowa(t["klucze_oddane"])
	var tematy := [
		["W czwartek wieczorem?", temat("s11b_pokrowiec", t["sprzataczka_czwartek"])],
		["Znała pani Adriana?", t["sprzataczka_adrian"]],
	]
	await przesluchanie(tematy, {}, t["sprzataczka_nic"], t["sprzataczka_koniec"])


func _maszynista() -> void:
	var t: Dictionary = Dialogi.SCENA11B
	if not Gra.flagi.get("s11b_maszynista", false):
		Gra.flagi["s11b_maszynista"] = true
		await rozmowa(t["maszynista_start"])
	var tematy := [
		["Czwartek rano", temat("s11b_wieszak", t["maszynista_czwartek"])],
		["Próba w czwartek", t["maszynista_proba"]],
		["Wolski", t["maszynista_wolski"]],
	]
	await przesluchanie(tematy, {}, t["maszynista_nic"], t["maszynista_koniec"])


func _garderobiana() -> void:
	var t: Dictionary = Dialogi.SCENA11B
	if Gra.flagi.get("s11b_ania_pytala", false):
		await rozmowa(t["garderobiana_potem"])
		return
	await rozmowa(t["garderobiana_start"])
	var tematy := [
		["Ktoś pytał o kostiumy Wolskiego?", t["garderobiana_kto"]],
	]
	var peka := func() -> bool:
		await rozmowa(t["garderobiana_peka"])
		Gra.flagi["s11b_ania_pytala"] = true
		return true
	await przesluchanie(tematy, {"zdjecie_plamy": peka, "zdjecie_pasy": peka}, t["garderobiana_nic"], t["garderobiana_koniec"])


func _kuba_rozmowa() -> void:
	var t: Dictionary = Dialogi.SCENA11B
	var f: Dictionary = Gra.flagi
	if f.get("s11b_kuba_widzial", false):
		await rozmowa(t["kuba_potem"])
		return
	await rozmowa(t["kuba_start"])
	var peka := func() -> bool:
		await rozmowa(t["kuba_peka"])
		f["s11b_kuba_widzial"] = true
		return true
	var halina := func() -> bool:
		await rozmowa(t["kuba_pralnia"])
		return await peka.call()
	var tematy := [
		["Czwartek wieczorem", t["kuba_czwartek"]],
		["Rola dublera", t["kuba_rola"]],
		["Halina mówi, że pytałeś w pralni", halina, func() -> bool: return f.get("s10_kuba_pytal", false) and not f.get("s11b_kuba_widzial", false)],
	]
	await przesluchanie(tematy, {"karta_kwit": peka}, t["kuba_nic"], t["kuba_koniec"])
