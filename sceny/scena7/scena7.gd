extends ScenaGry
## Scena 7 (rozdział 2): budka stróża przy bramie magazynu, niedziela 0:40.
## Zenon parzy herbatę i odpowiada na pytania, które gracz sam wybiera. Ładowarki
## nikt nie proponuje: trzeba pokazać Zenonowi rozładowany telefon Adriana.
## Papierosy Zenon daje sam po pierwszej rozmowie. Przed budką kiosk z pączkami
## (za drobne) i pies za siatką. Furtka na dole prowadzi na plac, przed nią
## retrospekcja: piątek w magazynie tak, jak go sobie wyobraża Antoni.
## Teksty w Dialogi.SCENA7.

const NASTEPNA := "res://sceny/retrospekcje/retro1.tscn"
const FURTKA := Rect2(560, 300, 70, 46)

var _zenon: Node2D
var _papierosy := false


func _ready() -> void:
	przygotuj($Budka)
	Telefon.godzina = "0:40"
	Notatnik.wlacz()
	Gra.latarnia_dostepna = Ekwipunek.ma("latarka") or Gra.latarnia_dostepna
	var t: Dictionary = Dialogi.SCENA7
	var tlo: Dictionary = Dialogi.SCENA7_TLO
	antoni.position = Vector2(440, 250)
	antoni.stan("lewo")
	_zenon = postac("zenon", Vector2(200, 214))
	dodaj_rozmowce(_zenon, _rozmowa_z_zenonem)
	gada_w_tle(_zenon, tlo["zenon"], 10.0)
	var sprzedawca := postac("maszynista2", Vector2(515, 214))
	dodaj_rozmowce(sprzedawca, _paczki)
	gada_w_tle(sprzedawca, tlo["sprzedawca"], 14.0)
	var pies := miejsce(Vector2(605, 112), "", t["pies"], 40.0)
	gada_w_tle(pies, tlo["pies"], 8.0)
	miejsce(Vector2(170, 176), "Telewizor", t["telewizor"])
	miejsce(Vector2(193, 108), "Kalendarz", t["kalendarz"], 60.0)
	miejsce(Vector2(305, 140), "Szuflada", _szuflada)
	miejsce(Vector2(345, 108), "Radio", t["radio"], 40.0)
	miejsce(Vector2(360, 108), "Klucze", t["klucze"], 60.0)
	miejsce(Vector2(95, 108), "Okno", t["okno"], 50.0)
	ustaw_wyjscie(FURTKA, "Na plac", NASTEPNA)
	dzwiek("magazyn.ogg", -16.0, true)
	await plansza("Budka stróża, 0:40")
	await rozmowa(t["zenon_start"])


func _rozmowa_z_zenonem() -> void:
	var t: Dictionary = Dialogi.SCENA7
	var tematy: Array = Dialogi.SCENA7_TEMATY
	while true:
		var nr := await wybor(tematy.map(func(x): return x[0]))
		var klucz: String = tematy[nr][1]
		if klucz == "koniec":
			await rozmowa(t["koniec_rozmowy"])
			break
		if klucz == "pokaz":
			await _pokaz_przedmiot()
			continue
		await rozmowa(t[klucz])
		Gra.flagi["s7_" + klucz] = true
		if not _papierosy:
			_papierosy = true
			await rozmowa(t["papierosy"])
			Ekwipunek.dodaj("papierosy")


## Gracz wybiera przedmiot fabularny z ekwipunku i pokazuje go Zenonowi.
func _pokaz_przedmiot() -> void:
	var t: Dictionary = Dialogi.SCENA7
	var ids: Array = []
	for id in Ekwipunek.przedmioty:
		if Dialogi.PRZEDMIOTY[id][2] == "fabularny":
			ids.append(id)
	ids = ids.slice(maxi(0, ids.size() - 7))  # najnowsze 7, żeby lista zmieściła się na ekranie
	if ids.is_empty():
		await rozmowa(t["pokaz_inne"])
		return
	var nazwy: Array = ids.map(func(id): return Dialogi.PRZEDMIOTY[id][0])
	nazwy.append("Wróć")
	var nr := await wybor(nazwy)
	if nr >= ids.size():
		return
	if ids[nr] == "telefon_adriana" and not Ekwipunek.ma("ladowarka"):
		await rozmowa(t["pokaz_telefon"])
		Ekwipunek.dodaj("ladowarka")
	else:
		await rozmowa(t["pokaz_inne"])


func _szuflada() -> void:
	await rozmowa(Dialogi.SCENA7["szuflada_potem" if Ekwipunek.ma("ladowarka") else "szuflada"])


func _paczki() -> void:
	var t: Dictionary = Dialogi.SCENA7
	if Gra.flagi.get("s7_paczek", false):
		await rozmowa(t["paczki_potem"])
	elif Ekwipunek.ma("monety"):
		await rozmowa(t["paczki_kupuje"])
		Ekwipunek.usun("monety")
		Ekwipunek.dodaj("paczek")
		Gra.flagi["s7_paczek"] = true
	else:
		await rozmowa(t["paczki_bez"])
