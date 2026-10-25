extends ScenaGry
## Scena 16 (rozdział 4, opcjonalna): gabinet Lisa, środa 13:00. Lis jest u księgowej.
## Szuflada biurka: kluczyk wisi za kalendarzem (s16_kluczyk), w środku polisa na Wolskiego.
## Telefon na biurku dzwoni raz: odebrany daje wierzyciela (s16_wierzyciel). Po wzięciu
## polisy wraca Lis i przyłapuje Antoniego. Przyznaje się do myśli, nie do czynu; o banku
## powie dopiero po polisie (s16_bank), a potwierdzenie (karta "bank") Antoni musi sam
## znaleźć w teczkach. Teksty w Dialogi.SCENA16.

const NASTEPNA := "res://sceny/scena17/scena17.tscn"
const DRZWI := Rect2(288, 318, 64, 42)
const FOTEL := Vector2(320, 180)
const PO_ILU_TELEFON := 25.0
const JAK_DLUGO_DZWONI := 10.0

var _lis: Node2D
var _dzwoni := false


func _ready() -> void:
	przygotuj($Gabinet)
	Telefon.godzina = "13:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA16
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	# sekretarka za ścianą
	var sekretarka := Node2D.new()
	sekretarka.position = Vector2(200, 352)
	obiekty.add_child(sekretarka)
	gada_w_tle(sekretarka, Dialogi.SCENA16_TLO["sekretarka"], 11.0)
	miejsce(Vector2(272, 212), "Stos papierów", _po_kolei("papiery", "s16_rachunki"))
	miejsce(Vector2(318, 212), "Teczki", _teczki)
	miejsce(Vector2(375, 212), "Telefon", _telefon)
	miejsce(Vector2(390, 220), "Szuflada", _szuflada, 20.0)
	miejsce(Vector2(525, 110), "Kalendarz", _kalendarz, 50.0)
	miejsce(Vector2(455, 110), "Tablica", t["tablica"], 50.0)
	miejsce(Vector2(325, 110), "Okno", t["okno"], 50.0)
	miejsce(Vector2(595, 130), "Regał", t["regal"], 60.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", NASTEPNA)
	_telefon_dzwoni()
	await plansza("Gabinet dyrektora, środa 13:00")
	await rozmowa(t["poczatek"])


func _po_kolei(klucz: String, flaga: String) -> Callable:
	var stan := {"bylo": false}
	return func() -> void:
		var t: Dictionary = Dialogi.SCENA16
		await rozmowa(t[klucz + "_potem"] if stan.bylo and t.has(klucz + "_potem") else t[klucz])
		stan.bylo = true
		if flaga != "":
			Gra.flagi[flaga] = true


## Telefon dzwoni raz, przez chwilę. Kto zdąży odebrać, usłyszy wierzyciela.
func _telefon_dzwoni() -> void:
	await get_tree().create_timer(PO_ILU_TELEFON).timeout
	while not koniec and not wolny():
		await get_tree().create_timer(0.5).timeout
	if koniec or is_instance_valid(_lis):
		return
	_dzwoni = true
	komunikat(Dialogi.SCENA16["telefon_dzwoni"], 2.5)
	for i in 3:
		dzwiek("telefon.wav", -6.0)
		await get_tree().create_timer(JAK_DLUGO_DZWONI / 3.0).timeout
		if not _dzwoni:
			return
	_dzwoni = false


func _telefon() -> void:
	var t: Dictionary = Dialogi.SCENA16
	if _dzwoni:
		_dzwoni = false
		await rozmowa(t["telefon_odbieram"])
		Gra.flagi["s16_wierzyciel"] = true
	else:
		await rozmowa(t["telefon_cicho"])


func _kalendarz() -> void:
	var t: Dictionary = Dialogi.SCENA16
	if Gra.flagi.get("s16_kluczyk", false):
		await rozmowa(t["kalendarz_potem"])
		return
	await rozmowa(t["kalendarz"])
	Gra.flagi["s16_kluczyk"] = true


func _szuflada() -> void:
	var t: Dictionary = Dialogi.SCENA16
	var f: Dictionary = Gra.flagi
	if Ekwipunek.ma("polisa"):
		await rozmowa(t["szuflada_potem"])
	elif not f.get("s16_kluczyk", false):
		await rozmowa(t["szuflada_zamknieta"])
		if Ekwipunek.ma("klucz"):
			await rozmowa(t["szuflada_klucz"])
	else:
		await rozmowa(t["szuflada_otwieram"])
		await rozmowa(t["polisa"])
		Ekwipunek.dodaj("polisa")
		f["s16_polisa"] = true
		await _lis_wraca()


func _teczki() -> void:
	var t: Dictionary = Dialogi.SCENA16
	var f: Dictionary = Gra.flagi
	if not f.get("s16_bank", false):
		await rozmowa(t["teczki"])
	elif Teczka.karty.has("bank"):
		await rozmowa(t["teczki_bank_potem"])
	else:
		await rozmowa(t["teczki_bank"])
		Teczka.dodaj("bank")


func _lis_wraca() -> void:
	var t: Dictionary = Dialogi.SCENA16
	antoni.sterowanie = false
	_dzwoni = false
	await rozmowa(t["kroki"])
	_lis = postac("bogdan", Vector2(320, 370))
	await idz(_lis, [Vector2(320, 330), Vector2(250, 260), Vector2(250, 200), FOTEL], 55.0)
	zwroc_sie(_lis)
	await rozmowa(t["lis_wchodzi"])
	dodaj_rozmowce(_lis, _rozmowa_z_lisem)
	gada_w_tle(_lis, Dialogi.SCENA16_TLO["lis"], 12.0)
	antoni.sterowanie = true


func _rozmowa_z_lisem() -> void:
	var t: Dictionary = Dialogi.SCENA16
	var f: Dictionary = Gra.flagi
	await rozmowa(t["lis_znowu"])
	var tematy := [
		["Teatr bankrutuje?", temat("s16_bankrut", t["lis_bankrut"]), func() -> bool: return f.get("s16_rachunki", false)],
		["Polisa na Wolskiego", _polisa],
		["Gdzie był pan w czwartek rano?", _czwartek],
		["Ktoś dzwonił o pieniądze z ubezpieczenia", t["lis_wierzyciel"], func() -> bool: return f.get("s16_wierzyciel", false)],
		["Wolski mówi, że pan liczy pieniądze", t["lis_wolski"], func() -> bool: return f.get("s14_podejrzani", false)],
		["Kuba dostał rolę dublera", t["lis_kuba"], func() -> bool: return f.get("s9_kuba_dubler", false)],
	]
	await przesluchanie(tematy, {"polisa": _polisa}, t["lis_nic"], t["lis_koniec"])


func _polisa() -> void:
	await rozmowa(Dialogi.SCENA16["lis_polisa"])
	Gra.flagi["s16_przyznal"] = true


func _czwartek() -> void:
	var t: Dictionary = Dialogi.SCENA16
	if Gra.flagi.get("s16_przyznal", false):
		await rozmowa(t["lis_czwartek"])
		Gra.flagi["s16_bank"] = true
	else:
		await rozmowa(t["lis_czwartek_zly"])


func przejdz(scena: String) -> void:
	if not is_instance_valid(_lis):
		antoni.sterowanie = false
		await rozmowa(Dialogi.SCENA16["wyjscie_przed"])
	super.przejdz(scena)
