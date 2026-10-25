extends ScenaGry
## Scena 2: kulisy, sobota 18:50. Antoni szukał toalety i trafił za scenę.
## Dyrektor Lis panikuje, bo dubler Adrian zniknął, a Wolski żartuje i wszystkich
## uspokaja (pierwsze wrażenie: ciepły, zabawny). Inspicjentka Marta odsyła
## Antoniego na widownię. Po obu rozmowach drzwi "WIDOWNIA" na tylnej ścianie
## prowadzą do sceny 3 (spektakl). Dolne wyjście, którym przyszedł, jest zamknięte.

const WYJSCIE := Rect2(660, 104, 52, 34)  # drzwi "WIDOWNIA"
const DOL := Rect2(352, 424, 80, 50)  # korytarz do foyer
const NASTEPNA := "res://sceny/scena3/scena3.tscn"

var _lis: Node2D
var _wolski: Node2D
var _marta: Node2D
var _poznal_dyrekcje := false
var _poznal_marte := false


func _ready() -> void:
	przygotuj($Kulisy)
	Telefon.godzina = "18:51"
	antoni.stan("gora")
	_marta = obiekty.get_node("Marta")
	_lis = postac("bogdan", Vector2(560, 196))
	_wolski = postac("wolski", Vector2(604, 192))
	gdy_blisko(Vector2(582, 194), 130.0, _klotnia)
	dodaj_rozmowce(_marta, _rozmowa_z_marta)
	zamkniete_drzwi(WYJSCIE, Dialogi.DRZWI["kulisy_wyjscie"])
	zamkniete_drzwi(DOL, Dialogi.DRZWI["kulisy_dol"])
	# zapasowy klucz w skrzynce z bezpiecznikami na ścianie
	skrzynka(Vector2(612, 112), "bezpieczniki", ["klucz"], "bezpieczniki", 40.0)
	await plansza("Kulisy, 18:50")
	antoni.sterowanie = false
	await dialog.pokaz(Dialogi.SCENA2["poczatek"])
	antoni.sterowanie = true


func _klotnia() -> void:
	antoni.sterowanie = false
	zwroc_sie(_lis)
	await dialog.pokaz(Dialogi.SCENA2["klotnia"])
	_poznal_dyrekcje = true
	zamkniete_drzwi(WYJSCIE, Dialogi.DRZWI["kulisy_wyjscie_2"])
	dodaj_rozmowce(_lis, Dialogi.SCENA2["lis_potem"])
	dodaj_rozmowce(_wolski, Dialogi.SCENA2["wolski_potem"])
	_otworz_wyjscie()
	antoni.sterowanie = true


func _rozmowa_z_marta() -> void:
	if _poznal_marte:
		await rozmowa(Dialogi.SCENA2["marta_potem"])
		return
	_poznal_marte = true
	await rozmowa(Dialogi.SCENA2["marta_pierwsza"])
	_otworz_wyjscie()


func _otworz_wyjscie() -> void:
	if _poznal_dyrekcje and _poznal_marte:
		ustaw_wyjscie(WYJSCIE, "Na widownię", NASTEPNA)
