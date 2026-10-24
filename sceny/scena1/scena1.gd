extends ScenaGry
## Scena 1: foyer, sobota 18:30. Samouczek chodzenia i rozmów.
## Goście plotkują o zaginionym dublerze, Ania przy drzwiach służbowych dzwoni
## do Adriana. Po podsłuchaniu jej rozmowy w notesie pojawia się pierwszy wpis
## i otwierają się drzwi "PERSONEL", którymi Antoni trafia za kulisy (scena 2).

const DRZWI := Rect2(190, 106, 48, 38)

var _ania: Node2D


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "18:31"
	_ania = obiekty.get_node("Ania")
	antoni.stan("gora")
	dodaj_rozmowce(postac("gosc_pan", Vector2(560, 252)), [
		["Starszy pan", "Słyszał pan? Podobno dubler Wolskiego zniknął. Od wczoraj nikt go nie widział."],
		["Antoni", "Może po prostu ma tremę."],
		["Starszy pan", "Trema przed rolą, której może nawet nie zagra? Młodzi dziś są dziwni."],
	])
	dodaj_rozmowce(postac("gosc_pani", Vector2(694, 248)), [
		["Elegancka pani", "Wolski grał podobno generalną w gorączce. Trzydzieści dziewięć stopni!"],
		["Elegancka pani", "Prawdziwy zawodowiec. Dubler nawet nie musiał wchodzić na scenę."],
	])
	dodaj_rozmowce(postac("gosc_student", Vector2(170, 318)), [
		["Student", "Kupiłem bilet pół roku temu. Jak Wolski dziś nie zagra, to chyba umrę."],
		["Antoni", "Lepiej nie."],
	])
	gdy_blisko(_ania, 80.0, _podsluchaj_anie)
	await plansza("Foyer, 18:30")
	pomoc_klawiszy()


func _podsluchaj_anie() -> void:
	antoni.sterowanie = false
	antoni.stan("gora")
	await dialog.pokaz([
		["Ania", "(do telefonu) Adrian, odezwij się, proszę. Cokolwiek się stało, przepraszam."],
		["Ania", "...Och. Nie zauważyłam pana. Przepraszam, muszę wracać za kulisy."],
	])
	# Ania znika za drzwiami służbowymi
	await przesun(_ania, Vector2(214, 128), 0.8)
	var tw := create_tween()
	tw.tween_property(_ania, "modulate:a", 0.0, 0.4)
	await tw.finished
	_ania.queue_free()
	await dialog.pokaz([
		["Antoni", "Za co ona przeprasza? I komu?"],
		["Antoni", "Dobra. Najpierw toaleta, potem zagadki. Może tymi drzwiami?"],
	])
	Notatnik.dodaj("Dubler zaginął. Ania za coś przeprasza?")
	ustaw_wyjscie(DRZWI, "Drzwi służbowe", "res://sceny/scena2/scena2.tscn")
	antoni.sterowanie = true
