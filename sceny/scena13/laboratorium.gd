extends ScenaGry
## Scena 13, część 2: laboratorium kryminalistyczne. Laborant przyjmuje tylko próbkę
## w woreczku z komendy. Po oddaniu wieczorem dzwoni z wynikiem, Antoni dzwoni do
## Nowickiego i zaczyna się retrospekcja 2. Teksty w Dialogi.LAB.

const DRZWI := Rect2(288, 318, 64, 42)
const RETRO := "res://sceny/retrospekcje/retro2.tscn"

var _laborant: Node2D


func _ready() -> void:
	przygotuj($Laboratorium)
	Telefon.godzina = "11:40"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.LAB
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	_laborant = postac("lekarz", Vector2(290, 146))
	dodaj_rozmowce(_laborant, _rozmowa)
	gada_w_tle(_laborant, ["(siorb)", "(siorb)", "Hm..."], 12.0)
	miejsce(Vector2(293, 214), "Mikroskop", t["mikroskop"], 50.0)
	miejsce(Vector2(65, 112), "Regał", t["regal"], 70.0)
	miejsce(Vector2(128, 112), "Lodówka", t["lodowka"], 60.0)
	miejsce(Vector2(170, 112), "Zlew", _zlew, 40.0)
	miejsce(Vector2(485, 112), "Dygestorium", t["dygestorium"], 80.0)
	miejsce(Vector2(340, 108), "Plakat", t["plakat"], 70.0)
	miejsce(Vector2(410, 108), "Tablica", t["tablica"], 70.0)
	miejsce(Vector2(575, 292), "Fartuchy", t["fartuchy"], 60.0)
	miejsce(Vector2(565, 108), "Okno", t["okno"], 70.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", "")
	dzwiek("magazyn.ogg", -24.0, true)  # szum wentylatorów
	await plansza(t["plansza"])
	await rozmowa(t["poczatek"])


func _zlew() -> void:
	var t: Dictionary = Dialogi.LAB
	var pali: bool = Gra.flagi.get("s12_dotknal", false) or Gra.flagi.get("s13_dotknal", false)
	if pali and not Gra.flagi.get("s13_umyl", false):
		await rozmowa(t["zlew_pali"])
		Gra.flagi["s13_umyl"] = true
	else:
		await rozmowa(t["zlew"])


func _rozmowa() -> void:
	var t: Dictionary = Dialogi.LAB
	if Gra.flagi.get("s13_oddana", false):
		await rozmowa(t["po_oddaniu"])
		return
	if not Gra.flagi.get("s13_lab_start", false):
		await rozmowa(t["start"])
		Gra.flagi["s13_lab_start"] = true
	var tematy := [
		["Smaczna zupa?", t["zupa"]],
		["Ile trwa badanie?", t["jak_dlugo"]],
		["Trucizna przez skórę?", temat("s13_przez_skore", t["przez_skore"])],
	]
	var dowody := {
		"probka": _oddaj,
		"zdjecie_plamy": t["zdjecie"],
		"lampa_uv": t["uv"],
		"zdjecie_pasy": t["zdjecie"],
		"termos": t["termos"],
	}
	await przesluchanie(tematy, dowody, t["nic"], t["koniec"])


func _oddaj() -> bool:
	await rozmowa(Dialogi.LAB["probka"])
	Ekwipunek.usun("probka")
	Gra.flagi["s13_oddana"] = true
	return true


## Przed oddaniem próbki wyjście prowadzi do samochodu, po oddaniu zapada wieczór.
func przejdz(_scena: String) -> void:
	antoni.sterowanie = false
	if not Gra.flagi.get("s13_oddana", false):
		var cel := await Samochod.jazda(self, Samochod.LABORATORIUM)
		if cel != "":
			super.przejdz(cel)
		return
	koniec = true
	var t: Dictionary = Dialogi.LAB
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	var napis := etykieta(24, Color8(236, 226, 200))
	napis.text = t["wieczor"]
	napis.position = Vector2(0, 110)
	napis.size = Vector2(480, 40)
	napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(napis)
	await get_tree().create_timer(2.0).timeout
	napis.queue_free()
	Telefon.godzina = "19:20"
	dzwiek("telefon.wav", -6.0)
	await get_tree().create_timer(1.5).timeout
	await rozmowa(t["telefon"])
	if Gra.flagi.get("s9_kwit_kuba", false):
		await rozmowa(t["telefon_slabszy"])
	Gra.flagi["s13_wynik"] = true
	Telefon.polaczenia.push_front(["Laboratorium", "przychodzące", "wt 19:20, 3 min"])
	await rozmowa(t["nowicki"])
	Telefon.polaczenia.push_front(["Komisarz Nowicki", "wychodzące", "wt 19:31, 2 min"])
	Gra.flagi["dni_do_pogrzebu"] = 3
	get_tree().change_scene_to_file(RETRO)
