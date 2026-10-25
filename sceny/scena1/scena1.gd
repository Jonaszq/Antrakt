extends ScenaGry
## Scena 1: foyer, sobota 18:30. Samouczek chodzenia i rozmów.
## Na początku Antoniemu chce się siku i szuka toalety.
## Goście plotkują o zaginionym dublerze, Ania przy drzwiach służbowych dzwoni
## do Adriana. Po podsłuchaniu jej rozmowy włącza się notes z samouczkiem
## (gracz sam wpisuje notatki) i otwierają się drzwi "PERSONEL", którymi Antoni
## trafia za kulisy (scena 2).

const DRZWI := Rect2(190, 106, 48, 38)

var _ania: Node2D


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "18:31"
	_ania = obiekty.get_node("Ania")
	antoni.stan("gora")
	dodaj_rozmowce(postac("gosc_pan", Vector2(560, 252)), Dialogi.SCENA1["starszy_pan"])
	dodaj_rozmowce(postac("gosc_pani", Vector2(694, 248)), Dialogi.SCENA1["elegancka_pani"])
	dodaj_rozmowce(postac("gosc_student", Vector2(170, 318)), Dialogi.SCENA1["student"])
	gdy_blisko(_ania, 80.0, _podsluchaj_anie)
	# przedmioty ze scenariusza i jedzenie (teksty w Dialogi.SKRZYNKI)
	skrzynka(Vector2(372, 470), "stojak_programy", ["program"], "stojak_programy")
	skrzynka(Vector2(740, 132), "bufet", ["kanapka", "kawa"])
	skrzynka(Vector2(600, 126), "apteczka", ["tabletki"], "apteczka", 46.0)
	skrzynka(Vector2(774, 290), "szatnia", ["monety"])
	zamkniete_drzwi(Rect2(392, 108, 96, 34), Dialogi.DRZWI["foyer_widownia"])
	zamkniete_drzwi(Rect2(396, 470, 88, 40), Dialogi.DRZWI["foyer_wyjscie"])
	await plansza("Foyer, 18:30")
	await rozmowa(Dialogi.SCENA1["poczatek"])
	pomoc_klawiszy()


func _podsluchaj_anie() -> void:
	antoni.sterowanie = false
	antoni.stan("gora")
	await dialog.pokaz(Dialogi.SCENA1["ania_telefon"])
	# Ania znika za drzwiami służbowymi
	await przesun(_ania, Vector2(214, 128), 0.8)
	var tw := create_tween()
	tw.tween_property(_ania, "modulate:a", 0.0, 0.4)
	await tw.finished
	_ania.queue_free()
	await dialog.pokaz(Dialogi.SCENA1["antoni_po_ani"])
	# samouczek notesu: gracz sam zapisuje, co usłyszał
	Notatnik.wlacz()
	await Notatnik.samouczek(Dialogi.NOTES["samouczek"])
	await dialog.pokaz(Dialogi.SCENA1["antoni_po_notesie"])
	ustaw_wyjscie(DRZWI, "Drzwi służbowe", "res://sceny/scena2/scena2.tscn")
	antoni.sterowanie = true
