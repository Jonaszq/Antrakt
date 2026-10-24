extends ScenaGry
## Scena 2: kulisy, sobota 18:50. Antoni szukał toalety i trafił za scenę.
## Dyrektor Lis panikuje, bo dubler Adrian zniknął, a Wolski żartuje i wszystkich
## uspokaja (pierwsze wrażenie: ciepły, zabawny). Inspicjentka Marta odsyła
## Antoniego na widownię. Dalej będzie scena 3 (spektakl), na razie wyjście
## prowadzi na mapę widowni.

const WYJSCIE := Rect2(352, 424, 80, 50)
const NASTEPNA := "res://mapy/widownia/widownia.tscn"

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
	await plansza("Kulisy, 18:50")
	antoni.sterowanie = false
	await dialog.pokaz(Dialogi.SCENA2["poczatek"])
	antoni.sterowanie = true


func _klotnia() -> void:
	antoni.sterowanie = false
	zwroc_sie(_lis)
	await dialog.pokaz(Dialogi.SCENA2["klotnia"])
	Notatnik.dodaj(Dialogi.NOTES["adrian_nie_odbiera"])
	_poznal_dyrekcje = true
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
		ustaw_wyjscie(WYJSCIE, "Wróć na widownię", NASTEPNA)
		Notatnik.dodaj(Dialogi.NOTES["kostium_w_pralni"])
