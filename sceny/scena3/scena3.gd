extends ScenaGry
## Scena 3: widownia, sobota 19:00 do 21:30. Przerywniki filmowe, gracz tylko ogląda
## i klika dalej. Ta sama scena gra oba akty (zmienna akt):
##  akt 1 (scena3.tscn): Antoni siada, gasną światła, Wolski gra znakomicie,
##    Ania myli kwestię i zamiera, patrząc na kostium Wolskiego (najazd kamery).
##    Potem antrakt w foyer (antrakt.tscn).
##  akt 2 (scena3_akt2.tscn): finał z nożem, oklaski, potem bankiet (scena 4).
## Teksty w Dialogi.SCENA3.

const ANTRAKT := "res://sceny/scena3/antrakt.tscn"
const BANKIET := "res://sceny/scena4/scena4.tscn"
const MIEJSCE_ANTONIEGO := Vector2(488, 318)  # trzeci rząd, środkowy sektor
const SRODEK_SCENY := Vector2(480, 136)

## Który akt pokazać: 1 albo 2.
@export var akt := 1

var _kamera: Camera2D
var _wolski: Node2D
var _ania: Node2D
var _mrok: CanvasModulate


func _ready() -> void:
	przygotuj($Widownia)
	Telefon.godzina = "19:00" if akt == 1 else "20:31"
	_mrok = $Widownia/Mrok
	_wolski = obiekty.get_node("Wolski")
	_wolski.position = Vector2(400, 150)
	# dyrektor ogląda z pierwszego rzędu, widzowie wokół Antoniego
	obiekty.get_node("Bogdan").position = Vector2(560, 250)
	postac("gosc_pani", MIEJSCE_ANTONIEGO + Vector2(-34, 0))
	postac("gosc_student", MIEJSCE_ANTONIEGO + Vector2(32, 0))
	postac("gosc_pan", MIEJSCE_ANTONIEGO + Vector2(-16, -34))
	postac("stasia", MIEJSCE_ANTONIEGO + Vector2(-130, -34))
	postac("zawada", MIEJSCE_ANTONIEGO + Vector2(110, 34))
	postac("para_pan", MIEJSCE_ANTONIEGO + Vector2(-60, 136))
	postac("para_pani", MIEJSCE_ANTONIEGO + Vector2(-28, 136))
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
	if akt == 1:
		_akt_pierwszy()
	else:
		_akt_drugi()


func _gasna_swiatla() -> void:
	var tw := create_tween().set_parallel()
	tw.tween_property(_mrok, "color", Color(0.16, 0.13, 0.2), 2.5)
	tw.tween_property(_kamera, "position", SRODEK_SCENY, 3.0).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_kamera, "zoom", Vector2(2, 2), 3.0).set_trans(Tween.TRANS_SINE)
	await tw.finished


func _zapalaja_sie(znika_ania: bool) -> void:
	var jasno := create_tween().set_parallel()
	jasno.tween_property(_mrok, "color", Color(0.4, 0.36, 0.48), 2.0)
	jasno.tween_property(_kamera, "position", MIEJSCE_ANTONIEGO + Vector2(0, -60), 2.5).set_trans(Tween.TRANS_SINE)
	jasno.tween_property(_kamera, "zoom", Vector2.ONE, 2.5).set_trans(Tween.TRANS_SINE)
	if znika_ania:
		var znika := create_tween()
		znika.tween_interval(1.0)
		znika.tween_property(_ania, "modulate:a", 0.0, 0.8)
	await jasno.finished


func _akt_pierwszy() -> void:
	await plansza("Widownia, 19:00")
	antoni.sterowanie = false
	await dialog.pokaz(Dialogi.SCENA3["przed"])
	await _gasna_swiatla()

	await _napis(Dialogi.SCENA3_NAPISY["akt1"])
	przesun(_wolski, Vector2(470, 146), 2.0)
	await dialog.pokaz(Dialogi.SCENA3["akt1"])
	# wchodzi Ania i zamiera, patrząc na kostium Wolskiego
	var wejscie := create_tween().set_parallel()
	wejscie.tween_property(_ania, "modulate:a", 1.0, 0.6)
	wejscie.tween_property(_ania, "position", Vector2(530, 150), 1.6)
	await wejscie.finished
	await dialog.pokaz(Dialogi.SCENA3["akt1_ania"])
	await _najazd(_ania.position + Vector2(0, -44), 3.0, 1.2)
	await get_tree().create_timer(0.8).timeout
	await _najazd(_wolski.position + Vector2(0, -34), 4.0, 1.4)
	await get_tree().create_timer(1.4).timeout
	await _najazd(SRODEK_SCENY, 2.0, 1.0)
	await dialog.pokaz(Dialogi.SCENA3["akt1_ratunek"])

	# antrakt: światła wracają, ludzie idą do bufetu
	dzwiek("oklaski.ogg", -10.0)
	await _napis(Dialogi.SCENA3_NAPISY["antrakt"])
	await _zapalaja_sie(true)
	await dialog.pokaz(Dialogi.SCENA3["antrakt"])
	przejdz(ANTRAKT)


func _akt_drugi() -> void:
	await plansza("Widownia, 20:30")
	antoni.sterowanie = false
	await dialog.pokaz(Dialogi.SCENA3["przed_akt2"])
	await _gasna_swiatla()

	await _napis(Dialogi.SCENA3_NAPISY["akt2"])
	przesun(_wolski, Vector2(450, 146), 2.0)
	var wejscie := create_tween().set_parallel()
	wejscie.tween_property(_ania, "modulate:a", 1.0, 0.6)
	wejscie.tween_property(_ania, "position", Vector2(540, 150), 1.6)
	await dialog.pokaz(Dialogi.SCENA3["akt2"])
	# finał: Ania z nożem, ciemność na sekundę, Wolski leży
	await _najazd(Vector2(500, 120), 3.0, 1.2)
	await dialog.pokaz(Dialogi.SCENA3["final"].slice(0, 1))
	var ciemno := create_tween()
	ciemno.tween_property(_mrok, "color", Color.BLACK, 0.3)
	await ciemno.finished
	_wolski.rotation_degrees = -90.0
	_wolski.position = Vector2(470, 160)
	await get_tree().create_timer(1.0).timeout
	var swiatlo := create_tween()
	swiatlo.tween_property(_mrok, "color", Color(0.16, 0.13, 0.2), 0.6)
	await swiatlo.finished
	await dialog.pokaz(Dialogi.SCENA3["final"].slice(1))

	# koniec spektaklu: oklaski, światła wracają
	dzwiek("oklaski.ogg")
	_wolski.rotation_degrees = 0.0
	_wolski.position = Vector2(470, 146)
	await _napis(Dialogi.SCENA3_NAPISY["koniec"])
	await _zapalaja_sie(true)
	await dialog.pokaz(Dialogi.SCENA3["koniec"])
	przejdz(BANKIET)


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
