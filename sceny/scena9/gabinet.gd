extends ScenaGry
## Scena 9, gabinet Lisa. Lis prosi o odebranie kostiumu z pralni, ale kwitu nie podaje:
## gracz szuka go sam na zawalonym biurku (leży pod popielniczką). Gdy Antoni ma kwit,
## wchodzi Ania i chce iść sama; Lis się nie zgadza. Ania zostaje na kanapie i można
## ją przesłuchać. Gracz może oddać Ani kwit (Sledztwo: kostium odbierze ona). Dolne drzwi wracają do foyer (scena9.tscn czyta Gra.flagi).

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
	miejsce(Vector2(455, 110), "Tablica", temat("s9_obsada", t["obsada"]), 50.0)
	miejsce(Vector2(525, 110), "Kalendarz", t["kalendarz_lisa"], 50.0)
	miejsce(Vector2(325, 110), "Okno", t["okno_lisa"], 50.0)
	miejsce(Vector2(595, 130), "Regał", t["regal_lisa"], 60.0)
	if f.get("s9_kwit_ania", false):
		miejsce(Vector2(82, 262), "Kanapa", t["kanapa_lisa"])  # Ania pojechała z kwitem
	elif f.get("s9_ania", false):
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
		["Adrian grał w kostiumie Wolskiego?", temat("s9_obsada", t["lis_kostium"])],
		["Kiedy pogrzeb?", t["lis_pogrzeb"]],
	]
	var koniec_rozmowy: Array = t["lis_koniec"]
	if Gra.flagi.get("s9_kwit_ania", false):
		koniec_rozmowy = t["lis_kwit_ania"]
	elif Ekwipunek.ma("kwit_odbioru"):
		koniec_rozmowy = t["lis_po_kwicie"]
	await przesluchanie(tematy, Dialogi.SCENA9_DOWODY["lis"], t["lis_nic"], koniec_rozmowy)


## Kwit leży pod popielniczką. Po jego znalezieniu wchodzi Ania.
func _popielniczka() -> void:
	var t: Dictionary = Dialogi.SCENA9
	if Ekwipunek.ma("kwit_odbioru") or Gra.flagi.get("s9_kwit_ania", false):
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
		["Czemu chce pani jechać sama?", temat("s9_ania_prosila", t["ania_czemu"])],
		["Adrian mówił coś o kostiumie?", temat("s9_ania_kostium", t["ania_kostium"])],
		["Gdzie pani była w piątek wieczorem?", t["ania_piatek"]],
	]
	var dowody: Dictionary = Dialogi.SCENA9_DOWODY["ania"].duplicate()
	dowody["kwit_odbioru"] = _ania_chce_kwit
	await przesluchanie(tematy, dowody, t["ania_nic"], t["ania_koniec"])


## Ania prosi o kwit. Oddany: Ania odbierze kostium pierwsza (plama zniknie, rozdz. 3).
## Zwraca true, gdy Ania wychodzi, żeby przesłuchanie się skończyło.
func _ania_chce_kwit() -> bool:
	var t: Dictionary = Dialogi.SCENA9
	Gra.flagi["s9_ania_prosila"] = true
	await rozmowa(t["ania_kwit"])
	var w := await wybor(Dialogi.SCENA9_KWIT_WYBOR)
	if w != 0:
		await rozmowa(t["ania_kwit_nie"])
		return false
	await rozmowa(t["ania_kwit_dal"])
	Ekwipunek.usun("kwit_odbioru")
	Gra.flagi["s9_kwit_ania"] = true
	antoni.sterowanie = false
	await idz(_ania, [Vector2(200, 300), Vector2(320, 380)], 40.0)
	_ania.queue_free()
	antoni.sterowanie = true
	return true
