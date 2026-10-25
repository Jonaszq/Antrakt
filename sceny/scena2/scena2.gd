extends ScenaGry
## Scena 2: kulisy, sobota 18:50. Antoni szukał toalety i trafił za scenę.
## Dyrektor Lis panikuje, bo dubler Adrian zniknął, a Wolski żartuje i wszystkich
## uspokaja (pierwsze wrażenie: ciepły, zabawny). Zaraz potem inspicjentka Marta
## łapie Antoniego: zginął rekwizytowy nóż z finału. Antoni szuka na stole
## z rekwizytami i w skrzyniach, w skrzynce z bezpiecznikami znajduje zapasowy klucz
## do garderób, a nóż leży w torbie Kuby w garderobie (osobna scena, garderoba.tscn).
## Po oddaniu noża drzwi "WIDOWNIA" prowadzą do sceny 3. W tle maszyniści,
## garderobiana z żelazkiem, aktorzy rozgrzewają głos, głośnik odlicza czas.
## Stan zadania trzyma Gra.flagi, bo wyjście do garderoby przeładowuje scenę.

const WYJSCIE := Rect2(660, 104, 52, 34)  # drzwi "WIDOWNIA"
const DOL := Rect2(352, 424, 80, 50)  # korytarz do foyer
const GARDEROBY := Rect2(56, 104, 48, 36)
const PODWORZE := Rect2(560, 104, 44, 34)
const NASTEPNA := "res://sceny/scena3/scena3.tscn"
const GARDEROBA := "res://sceny/scena2/garderoba.tscn"

var _lis: Node2D
var _wolski: Node2D
var _marta: Node2D


func _ready() -> void:
	przygotuj($Kulisy)
	var f := Gra.flagi
	var powrot: bool = f.get("s2_z_garderoby", false)
	f.erase("s2_z_garderoby")
	Telefon.godzina = "18:57" if powrot else "18:51"
	antoni.stan("dol" if powrot else "gora")
	if powrot:
		antoni.position = Vector2(80, 150)
	_marta = obiekty.get_node("Marta")
	_lis = postac("bogdan", Vector2(560, 196))
	_wolski = postac("wolski", Vector2(604, 192))
	dodaj_rozmowce(_marta, _rozmowa_z_marta)
	zamkniete_drzwi(WYJSCIE, Dialogi.DRZWI["kulisy_wyjscie_2" if f.get("s2_klotnia") else "kulisy_wyjscie"])
	zamkniete_drzwi(DOL, Dialogi.DRZWI["kulisy_dol"])
	zamkniete_drzwi(GARDEROBY, Dialogi.DRZWI["kulisy_garderoby"])
	zamkniete_drzwi(PODWORZE, Dialogi.DRZWI["kulisy_podworze"])
	if f.get("s2_klotnia"):
		_po_klotni()
	else:
		gdy_blisko(Vector2(582, 194), 130.0, _klotnia)
	if Ekwipunek.ma("klucz"):
		ustaw_wyjscie(GARDEROBY, "Garderoby", GARDEROBA)
	if f.get("s2_oddal"):
		ustaw_wyjscie(WYJSCIE, "Na widownię", NASTEPNA)
	# zapasowy klucz w skrzynce z bezpiecznikami na ścianie
	var bezpieczniki := rekwizyt("bezpieczniki", Vector2(612, 112), 40.0)
	dodaj_rozmowce(bezpieczniki, _bezpieczniki, Dialogi.SKRZYNKI["bezpieczniki"][0], 72.0)
	_miejsca()
	_tlo()
	if powrot:
		await rozjasnij()
		return
	await plansza("Kulisy, 18:50")
	antoni.sterowanie = false
	await dialog.pokaz(Dialogi.SCENA2["poczatek"])
	antoni.sterowanie = true
	await get_tree().create_timer(20.0).timeout
	komunikat(Dialogi.SCENA2_TLO["glosnik_1"])
	await get_tree().create_timer(60.0).timeout
	komunikat(Dialogi.SCENA2_TLO["glosnik_2"])


## Miejsca do obejrzenia: stół z rekwizytami i skrzynie są częścią szukania noża.
func _miejsca() -> void:
	var t: Dictionary = Dialogi.SCENA2
	miejsce(Vector2(255, 228), "Rekwizyty", func() -> void:
		await rozmowa(t["stol"] if Gra.flagi.get("s2_szuka") else t["stol_przed"]))
	miejsce(Vector2(100, 408), "Skrzynie", func() -> void:
		await rozmowa(t["skrzynie"] if Gra.flagi.get("s2_szuka") else t["skrzynie"].slice(0, 1)))
	miejsce(Vector2(455, 112), "Tablica", t["tablica"])
	miejsce(Vector2(497, 444), "", t["tron"])
	miejsce(Vector2(430, 292), "", t["zarowka"])
	miejsce(Vector2(572, 310), "", t["pulpit"])
	miejsce(Vector2(158, 224), "", t["wieszak"])


## Życie za kulisami: maszyniści, garderobiana, aktorzy.
func _tlo() -> void:
	var t: Dictionary = Dialogi.SCENA2
	var tlo: Dictionary = Dialogi.SCENA2_TLO
	var maszynista := postac("maszynista", Vector2(300, 250))
	dodaj_rozmowce(maszynista, t["maszynista"])
	spacer(maszynista, [Vector2(470, 250), Vector2(300, 250)], 30.0, 2.5)
	gada_w_tle(maszynista, tlo["maszynista"], 7.0)
	var palacz := postac("maszynista2", Vector2(582, 130))
	var stan := {"pierwsza": true}
	dodaj_rozmowce(palacz, func() -> void:
		await rozmowa(t["palacz"] if stan.pierwsza else t["palacz_potem"])
		stan.pierwsza = false)
	gada_w_tle(palacz, tlo["palacz"], 9.0)
	var garderobiana := postac("garderobiana", Vector2(200, 300))
	dodaj_rozmowce(garderobiana, t["garderobiana"])
	spacer(garderobiana, [Vector2(650, 340), Vector2(380, 450), Vector2(200, 300)], 85.0, 1.2)
	gada_w_tle(garderobiana, tlo["garderobiana"], 6.0)
	var aktor := postac("aktor", Vector2(448, 420))
	dodaj_rozmowce(aktor, t["aktor"])
	gada_w_tle(aktor, tlo["aktor"], 5.0)
	var aktorka := postac("aktorka", Vector2(552, 424))
	dodaj_rozmowce(aktorka, t["aktorka"])
	gada_w_tle(aktorka, tlo["aktorka"], 7.0)


func _klotnia() -> void:
	antoni.sterowanie = false
	zwroc_sie(_lis)
	await dialog.pokaz(Dialogi.SCENA2["klotnia"])
	Gra.flagi["s2_klotnia"] = true
	_po_klotni()
	if Gra.flagi.get("s2_szuka"):
		antoni.sterowanie = true
		return
	# Marta podbiega i łapie Antoniego za rękaw
	var gdzie := _marta.position
	await przesun(_marta, antoni.position + Vector2(28, 14), 0.9)
	zwroc_sie(_marta)
	await dialog.pokaz(Dialogi.SCENA2["marta_noz"])
	Gra.flagi["s2_szuka"] = true
	zamkniete_drzwi(WYJSCIE, Dialogi.DRZWI["kulisy_wyjscie_2"])
	antoni.sterowanie = true
	await przesun(_marta, gdzie, 1.2)


func _po_klotni() -> void:
	dodaj_rozmowce(_lis, Dialogi.SCENA2["lis_potem"])
	dodaj_rozmowce(_wolski, Dialogi.SCENA2["wolski_potem"])


func _rozmowa_z_marta() -> void:
	var f := Gra.flagi
	if f.get("s2_oddal"):
		await rozmowa(Dialogi.SCENA2["marta_potem"])
	elif Ekwipunek.ma("noz"):
		await rozmowa(Dialogi.SCENA2["marta_oddaje"])
		Ekwipunek.usun("noz")
		f["s2_oddal"] = true
		ustaw_wyjscie(WYJSCIE, "Na widownię", NASTEPNA)
	elif f.get("s2_szuka"):
		await rozmowa(Dialogi.SCENA2["marta_czeka"])
	else:
		# Antoni zagadał Martę, zanim podszedł do dyrektora: ona i tak ma do niego sprawę
		await rozmowa(Dialogi.SCENA2["marta_noz"])
		f["s2_szuka"] = true


func _bezpieczniki() -> void:
	var teksty: Array = Dialogi.SKRZYNKI["bezpieczniki"]
	if Ekwipunek.ma("klucz"):
		await rozmowa([["", teksty[2]]])
		return
	await rozmowa([["", teksty[1]]])
	Ekwipunek.dodaj("klucz")
	ustaw_wyjscie(GARDEROBY, "Garderoby", GARDEROBA)
