extends ScenaGry
## Scena 3: widownia, sobota 19:00 do 21:30. Przerywnik filmowy, gracz tylko ogląda
## i klika dalej. Antoni siedzi wśród widzów, gasną światła, Wolski gra znakomicie.
## W drugim akcie Ania myli kwestię i zamiera, patrząc na kostium Wolskiego
## (kamera najeżdża na nią, a potem na kostium). Teksty w Dialogi.SCENA3.
## Potem scena 4 (bankiet w foyer).

const NASTEPNA := "res://sceny/scena4/scena4.tscn"
const MIEJSCE_ANTONIEGO := Vector2(488, 318)  # trzeci rząd, środkowy sektor
const SRODEK_SCENY := Vector2(480, 136)

var _kamera: Camera2D
var _wolski: Node2D
var _ania: Node2D
var _mrok: CanvasModulate


func _ready() -> void:
	przygotuj($Widownia)
	Telefon.godzina = "19:00"
	_mrok = $Widownia/Mrok
	_wolski = obiekty.get_node("Wolski")
	_wolski.position = Vector2(400, 150)
	# dyrektor ogląda z pierwszego rzędu, widzowie wokół Antoniego
	obiekty.get_node("Bogdan").position = Vector2(560, 250)
	postac("gosc_pani", MIEJSCE_ANTONIEGO + Vector2(-34, 0))
	postac("gosc_student", MIEJSCE_ANTONIEGO + Vector2(32, 0))
	postac("gosc_pan", MIEJSCE_ANTONIEGO + Vector2(-16, -34))
	_ania = postac("ania", Vector2(660, 150))
	_ania.modulate.a = 0.0
	antoni.position = MIEJSCE_ANTONIEGO
	antoni.stan("gora")
	# własna kamera filmowa zamiast tej, która chodzi za Antonim
	_kamera = Camera2D.new()
	_kamera.limit_right = 960
	_kamera.limit_bottom = 640
	_kamera.position = MIEJSCE_ANTONIEGO + Vector2(0, -40)
	obiekty.add_child(_kamera)
	_kamera.make_current()
	_film()


func _film() -> void:
	await plansza("Widownia, 19:00")
	antoni.sterowanie = false
	await dialog.pokaz(Dialogi.SCENA3["przed"])
	# gasną światła, kamera jedzie na scenę
	var tw := create_tween().set_parallel()
	tw.tween_property(_mrok, "color", Color(0.16, 0.13, 0.2), 2.5)
	tw.tween_property(_kamera, "position", SRODEK_SCENY, 3.0).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_kamera, "zoom", Vector2(2, 2), 3.0).set_trans(Tween.TRANS_SINE)
	await tw.finished

	await _napis(Dialogi.SCENA3_NAPISY["akt1"])
	przesun(_wolski, Vector2(470, 146), 2.0)
	await dialog.pokaz(Dialogi.SCENA3["akt1"])

	await _napis(Dialogi.SCENA3_NAPISY["akt2"])
	var wejscie := create_tween().set_parallel()
	wejscie.tween_property(_ania, "modulate:a", 1.0, 0.6)
	wejscie.tween_property(_ania, "position", Vector2(530, 150), 1.6)
	await wejscie.finished
	await dialog.pokaz(Dialogi.SCENA3["akt2"])
	# najazd na Anię, potem na kostium Wolskiego
	await _najazd(_ania.position + Vector2(0, -44), 3.0, 1.2)
	await get_tree().create_timer(0.8).timeout
	await _najazd(_wolski.position + Vector2(0, -34), 4.0, 1.4)
	await get_tree().create_timer(1.4).timeout
	await _najazd(SRODEK_SCENY, 2.0, 1.0)
	await dialog.pokaz(Dialogi.SCENA3["akt2_ratunek"])

	# koniec spektaklu: światła wracają
	await _napis(Dialogi.SCENA3_NAPISY["koniec"])
	var jasno := create_tween().set_parallel()
	jasno.tween_property(_mrok, "color", Color(0.4, 0.36, 0.48), 2.0)
	jasno.tween_property(_kamera, "position", MIEJSCE_ANTONIEGO + Vector2(0, -60), 2.5).set_trans(Tween.TRANS_SINE)
	jasno.tween_property(_kamera, "zoom", Vector2.ONE, 2.5).set_trans(Tween.TRANS_SINE)
	var znika := create_tween()
	znika.tween_interval(1.0)
	znika.tween_property(_ania, "modulate:a", 0.0, 0.8)
	await jasno.finished
	await dialog.pokaz(Dialogi.SCENA3["koniec"])
	przejdz(NASTEPNA)


## Płynny ruch kamery do punktu z danym przybliżeniem.
func _najazd(cel: Vector2, przyblizenie: float, czas: float) -> void:
	var tw := create_tween().set_parallel()
	tw.tween_property(_kamera, "position", cel, czas).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_kamera, "zoom", Vector2.ONE * przyblizenie, czas).set_trans(Tween.TRANS_SINE)
	await tw.finished


## Duży napis na środku ekranu (np. "Akt drugi"), pojawia się i znika.
func _napis(tekst: String) -> void:
	var l := etykieta(24, Color8(236, 226, 200))
	l.text = tekst
	l.position = Vector2(0, 110)
	l.size = Vector2(480, 40)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_constant_override("outline_size", 6)
	l.add_theme_color_override("font_outline_color", Color8(12, 8, 10))
	l.modulate.a = 0.0
	ui.add_child(l)
	var tw := create_tween()
	tw.tween_property(l, "modulate:a", 1.0, 0.6)
	tw.tween_interval(1.4)
	tw.tween_property(l, "modulate:a", 0.0, 0.6)
	await tw.finished
	l.queue_free()
