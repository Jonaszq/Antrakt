extends ScenaGry
## Scena 9, gabinet Lisa. Lis prosi o odebranie kostiumu z pralni, ale kwitu nie podaje:
## gracz szuka go sam na zawalonym biurku (leży pod popielniczką). Gdy Antoni ma kwit,
## wchodzi Ania i chce iść sama; Lis się nie zgadza. Ania zostaje na kanapie i można
## ją przesłuchać. Dolne drzwi wracają do foyer (scena9.tscn czyta Gra.flagi).

const FOYER := "res://sceny/scena9/scena9.tscn"
const DRZWI := Rect2(288, 318, 64, 42)

var _lis: Node2D
var _ania: Node2D


func _ready() -> void:
	przygotuj($Gabinet)
	Telefon.godzina = "11:10"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA9
	var f: Dictionary = Gra.flagi
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	_lis = postac("bogdan", Vector2(320, 180))
	dodaj_rozmowce(_lis, _rozmowa_z_lisem)
	gada_w_tle(_lis, Dialogi.SCENA9_TLO["lis"], 12.0)
	miejsce(Vector2(272, 212), "Stos papierów", _kolejne("papiery"))
	miejsce(Vector2(318, 212), "Teczki", _kolejne("teczki"))
	miejsce(Vector2(355, 212), "Popielniczka", _popielniczka)
	miejsce(Vector2(375, 212), "Telefon", t["telefon_lisa"])
	miejsce(Vector2(390, 220), "Szuflada", t["szuflada_lisa"], 20.0)
	miejsce(Vector2(455, 110), "Tablica", t["obsada"], 50.0)
	miejsce(Vector2(525, 110), "Kalendarz", t["kalendarz_lisa"], 50.0)
	miejsce(Vector2(325, 110), "Okno", t["okno_lisa"], 50.0)
	miejsce(Vector2(595, 130), "Regał", t["regal_lisa"], 60.0)
	if f.get("s9_ania", false):
		_posadz_anie()
	else:
		miejsce(Vector2(82, 262), "Kanapa", t["kanapa_lisa"])
	ustaw_wyjscie(DRZWI, "Do foyer", FOYER)
	Gra.flagi["s9_z_gabinetu"] = true
	await rozjasnij()
	if not f.get("s9_prosba", false):
		f["s9_prosba"] = true
		await rozmowa(t["gabinet_wejscie"])
		await rozmowa(t["lis_prosba"])


func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		var klucz := kto if stan.pierwsza or not Dialogi.SCENA9.has(kto + "_potem") else kto + "_potem"
		await rozmowa(Dialogi.SCENA9[klucz])
		stan.pierwsza = false


func _rozmowa_z_lisem() -> void:
	var t: Dictionary = Dialogi.SCENA9
	var tematy := [
		["Kto oddał kostium do pralni?", t["lis_kto"]],
		["Adrian grał w kostiumie Wolskiego?", t["lis_kostium"]],
		["Kiedy pogrzeb?", t["lis_pogrzeb"]],
	]
	var koniec_rozmowy: Array = t["lis_po_kwicie"] if Ekwipunek.ma("kwit_odbioru") else t["lis_koniec"]
	await przesluchanie(tematy, Dialogi.SCENA9_DOWODY["lis"], t["lis_nic"], koniec_rozmowy)


## Kwit leży pod popielniczką. Po jego znalezieniu wchodzi Ania.
func _popielniczka() -> void:
	var t: Dictionary = Dialogi.SCENA9
	if Ekwipunek.ma("kwit_odbioru"):
		await rozmowa(t["popielniczka_potem"])
		return
	await rozmowa(t["popielniczka"])
	Ekwipunek.dodaj("kwit_odbioru")
	await _ania_wchodzi()


func _ania_wchodzi() -> void:
	antoni.sterowanie = false
	Gra.flagi["s9_ania"] = true
	_ania = postac("ania", Vector2(320, 370))
	await idz(_ania, [Vector2(320, 270)], 34.0)
	zwroc_sie(_ania)
	await rozmowa(Dialogi.SCENA9["ania_wchodzi"])
	antoni.sterowanie = false
	await idz(_ania, [Vector2(200, 290), Vector2(96, 276)], 30.0)
	antoni.sterowanie = true
	dodaj_rozmowce(_ania, _rozmowa_z_ania)
	gada_w_tle(_ania, [Dialogi.SCENA9["ania_kanapa"][0][1]], 15.0)


func _posadz_anie() -> void:
	_ania = postac("ania", Vector2(96, 276))
	dodaj_rozmowce(_ania, _rozmowa_z_ania)


func _rozmowa_z_ania() -> void:
	var t: Dictionary = Dialogi.SCENA9
	var tematy := [
		["Czemu chce pani jechać sama?", t["ania_czemu"]],
		["Adrian mówił coś o kostiumie?", t["ania_kostium"]],
		["Gdzie pani była w piątek wieczorem?", t["ania_piatek"]],
	]
	await przesluchanie(tematy, Dialogi.SCENA9_DOWODY["ania"], t["ania_nic"], t["ania_koniec"])
