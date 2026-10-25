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
	var tematy := []
	for x in Dialogi.SCENA7_TEMATY:
		tematy.append([x[0], _temat.bind(x[1])])
	await przesluchanie(tematy, {"telefon_adriana": _ladowarka}, t["pokaz_inne"], t["koniec_rozmowy"])


func _temat(klucz: String) -> void:
	await rozmowa(Dialogi.SCENA7[klucz])
	Gra.flagi["s7_" + klucz] = true
	if not _papierosy:
		_papierosy = true
		await rozmowa(Dialogi.SCENA7["papierosy"])
		Ekwipunek.dodaj("papierosy")


## Rozładowany telefon Adriana: Zenon szuka w szufladzie kabla.
func _ladowarka() -> void:
	var t: Dictionary = Dialogi.SCENA7
	await rozmowa(t["pokaz_inne"] if Ekwipunek.ma("ladowarka") else t["pokaz_telefon"])
	Ekwipunek.dodaj("ladowarka")


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
