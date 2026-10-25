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
	dodaj_rozmowce(sprzedawca, _rozmowa_ze_sprzedawca)
	gada_w_tle(sprzedawca, tlo["sprzedawca"], 14.0)
	var pies := miejsce(Vector2(605, 112), "", t["pies"], 40.0)
	gada_w_tle(pies, tlo["pies"], 8.0)
	miejsce(Vector2(170, 176), "Telewizor", t["telewizor"])
	miejsce(Vector2(193, 108), "Kalendarz", t["kalendarz"], 60.0)
	miejsce(Vector2(305, 140), "Szuflada", _szuflada)
	miejsce(Vector2(345, 108), "Radio", _po_kolei(["radio", "radio_potem"]), 40.0)
	miejsce(Vector2(272, 140), "Zeszyt", _po_kolei(["dziennik", "dziennik_potem"]))
	miejsce(Vector2(128, 176), "Gazeta", _po_kolei(["gazeta", "gazeta_potem"]))
	miejsce(Vector2(360, 108), "Klucze", t["klucze"], 60.0)
	miejsce(Vector2(95, 108), "Okno", t["okno"], 50.0)
	ustaw_wyjscie(FURTKA, "Na plac", NASTEPNA)
	dzwiek("magazyn.ogg", -16.0, true)
	await plansza("Budka stróża, 0:40")
	await rozmowa(t["zenon_start"])
	_smieciarka(pies)


## Po chwili za siatką przejeżdża śmieciarka, pies ujada.
func _smieciarka(pies: Node2D) -> void:
	await get_tree().create_timer(45.0).timeout
	if koniec:
		return
	komunikat(Dialogi.SCENA7["smieciarka"], 3.0)
	for i in 3:
		dymek(pies, "Hau! Hau! Hau!", 1.2)
		await get_tree().create_timer(1.4).timeout


func _po_kolei(klucze: Array) -> Callable:
	var stan := {"i": 0}
	return func() -> void:
		await rozmowa(Dialogi.SCENA7[klucze[mini(stan.i, klucze.size() - 1)]])
		stan.i += 1


func _rozmowa_ze_sprzedawca() -> void:
	var t: Dictionary = Dialogi.SCENA7
	if not Gra.flagi.get("s7_sprzedawca", false):
		Gra.flagi["s7_sprzedawca"] = true
		await rozmowa(t["sprzedawca_start"])
	var tematy := [
		["Stał pan tu w piątek?", t["sprzedawca_piatek"]],
		["Widział pan kogoś z hali?", func() -> void:
			await rozmowa(t["sprzedawca_widzial"])
			Gra.flagi["s7_woda"] = true],
		["Poproszę pączka.", _paczki],
	]
	await przesluchanie(tematy, Dialogi.SCENA7_DOWODY_SPRZEDAWCA, t["sprzedawca_nic"], t["sprzedawca_koniec"])


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
