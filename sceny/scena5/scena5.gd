extends ScenaGry
## Scena 5: foyer po bankiecie, sobota 23:30, potem jazda autem dyrektora.
## Do Lisa dzwoni stróż magazynu: znalazł Adriana, nie oddycha. Ania mdleje,
## Wolski ją łapie. Lis prosi Antoniego, żeby z nim pojechał. Jazda w deszczu to
## rozmowa: gracz wybiera dwa z trzech tematów (Adrian, teatr, Wolski), a na koniec
## Lis zawsze mówi o długach i o tym, że sam wysłał Adriana do magazynu.
## Bez przerywników: do Lisa przy telefonie i potem z prośbą Antoni podchodzi sam.
## Po jeździe koniec rozdziału i licznik "5 dni do pogrzebu".
## Obrazy auta i bramy rysuje tools/jazda_pixel.py, teksty w Dialogi.SCENA5.
## Ujęcia leżą w warstwie _kino pod warstwą ui, więc czarna zasłona ScenaGry je przykrywa.

const NASTEPNA := "res://sceny/scena6/scena6.tscn"  # rozdział 2: magazyn
const SZYBA := Rect2(12, 34, 456, 134)  # przednia szyba na obrazku wnetrze.png

var _uslyszal := false
var _lis: Node2D
var _wolski: Node2D
var _ania: Node2D
var _kino: CanvasLayer  # pełnoekranowe ujęcia (auto, plansza końcowa)
var _swiatla: Array[ColorRect] = []
var _wycieraczki: Array[Sprite2D] = []


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "23:30"
	Notatnik.wlacz()
	antoni.position = Vector2(500, 236)
	antoni.stan("lewo")
	_ania = obiekty.get_node("Ania")
	_ania.position = Vector2(470, 300)
	_wolski = postac("wolski", Vector2(430, 290))
	_lis = postac("bogdan", Vector2(560, 196))
	postac("marta", Vector2(262, 172))
	postac("gosc_pan", Vector2(700, 330))
	var kelnerka := postac("kelnerka", Vector2(620, 300))
	spacer(kelnerka, [Vector2(700, 240), Vector2(620, 300)], 30.0, 3.0)
	rekwizyt("gramofon", Vector2(615, 267), 22.0)
	dzwiek("gramofon.ogg", -14.0, true)
	await plansza("Foyer, 23:30")
	# bez przerywnika: telefon dzwoni, a Antoni sam decyduje, czy podejść do dyrektora
	await get_tree().create_timer(3.0).timeout
	dzwiek("telefon.wav", -6.0)
	await get_tree().create_timer(2.2).timeout
	dymek(_lis, "Tak, Zenon, słucham... Co?!", 3.5)
	gdy_blisko(_lis, 90.0, _telefon)
	dodaj_rozmowce(_lis, _telefon)


## Antoni podchodzi do Lisa: wiadomość od stróża, Ania mdleje, Lis prosi o pomoc.
func _telefon() -> void:
	if _uslyszal:
		return
	_uslyszal = true
	antoni.sterowanie = false
	zwroc_sie(_lis)
	await dialog.pokaz(Dialogi.SCENA5["telefon"])
	# Ania mdleje, Wolski ją łapie
	var upadek := create_tween().set_parallel()
	upadek.tween_property(_ania, "rotation_degrees", 80.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	upadek.tween_property(_wolski, "position", _ania.position + Vector2(-22, 2), 0.4)
	await upadek.finished
	await dialog.pokaz(Dialogi.SCENA5["omdlenie"])
	antoni.sterowanie = true
	dodaj_rozmowce(_lis, _jedziemy)


func _jedziemy() -> void:
	await rozmowa(Dialogi.SCENA5["prosba"])
	antoni.sterowanie = false
	await _sciemnij()
	await _jazda()
	await _koniec_rozdzialu()


func _sciemnij(czas := 1.0) -> void:
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, czas)
	await tw.finished


func _rozjasnij(czas := 1.0) -> void:
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 0.0, czas)
	await tw.finished


func _ujecie(plik: String) -> TextureRect:
	var obraz := TextureRect.new()
	obraz.texture = load("res://sceny/scena5/" + plik)
	_kino.add_child(obraz)
	return obraz


func _jazda() -> void:
	_kino = CanvasLayer.new()
	_kino.layer = 9
	_kino.scale = Gra.SKALA_UI
	add_child(_kino)
	_ujecie("droga.png")
	# mijane latarnie i światła z okien przesuwają się po bokach
	for i in 6:
		var s := ColorRect.new()
		s.size = Vector2(3, 6)
		s.color = Color8(255, 200, 120, 200) if i % 2 == 0 else Color8(140, 160, 220, 160)
		_kino.add_child(s)
		_swiatla.append(s)
		_nowe_swiatlo(s, randf())
	var deszcz := Node2D.new()
	deszcz.set_script(preload("res://wstep/deszcz.gd"))
	deszcz.set("ziemia", 400.0)
	_kino.add_child(deszcz)
	for x in [150.0, 330.0]:
		var w := Sprite2D.new()
		w.texture = preload("res://sceny/scena5/wycieraczka.png")
		w.centered = false
		w.offset = Vector2(-3, -120)
		w.position = Vector2(x, 168)
		w.rotation_degrees = -70.0
		_kino.add_child(w)
		_wycieraczki.append(w)
	_ujecie("wnetrze.png")
	var silnik := dzwiek("auto.ogg", -4.0, true)
	_wycieraj()
	await _rozjasnij()
	await dialog.pokaz(Dialogi.SCENA5["auto"])
	# dwa pytania z trzech
	var pytania: Array = Dialogi.SCENA5_PYTANIA.duplicate()
	for i in 2:
		var napisy := []
		for p in pytania:
			napisy.append(p[0])
		var nr := await wybor(napisy)
		await dialog.pokaz(Dialogi.SCENA5[pytania[nr][1]])
		pytania.remove_at(nr)
	await dialog.pokaz(Dialogi.SCENA5["auto_koniec"])
	await _sciemnij()
	silnik.queue_free()
	for dziecko in _kino.get_children():
		dziecko.queue_free()
	_swiatla.clear()
	_wycieraczki.clear()


func _process(delta: float) -> void:
	super(delta)
	for s in _swiatla:
		# światło jedzie od punktu zbiegu (240, 112) na bok, coraz szybciej
		var t: float = s.get_meta("t") + delta * 0.35
		if t > 1.0:
			_nowe_swiatlo(s, 0.0)
			continue
		s.set_meta("t", t)
		var kier: float = s.get_meta("kier")
		var droga := t * t
		s.position = Vector2(240 + kier * (12 + 300 * droga), 108 - 70 * droga * s.get_meta("wys"))
		s.size = Vector2(2 + 4 * droga, 3 + 10 * droga)
		s.visible = SZYBA.has_point(s.position)


func _nowe_swiatlo(s: ColorRect, t: float) -> void:
	s.set_meta("t", t)
	s.set_meta("kier", -1.0 if randf() < 0.5 else 1.0)
	s.set_meta("wys", randf_range(-0.6, 1.0))


func _wycieraj() -> void:
	while not _wycieraczki.is_empty():
		var tw := create_tween().set_parallel()
		for w in _wycieraczki:
			tw.tween_property(w, "rotation_degrees", 20.0, 0.5).set_trans(Tween.TRANS_SINE)
		await tw.finished
		if _wycieraczki.is_empty():
			return
		var wroc := create_tween().set_parallel()
		for w in _wycieraczki:
			wroc.tween_property(w, "rotation_degrees", -70.0, 0.5).set_trans(Tween.TRANS_SINE)
		await wroc.finished
		await get_tree().create_timer(0.4).timeout


## Plansza końcowa rozdziału i licznik dni do pogrzebu, potem rozdział 2.
func _koniec_rozdzialu() -> void:
	for dziecko in _kino.get_children():
		dziecko.queue_free()
	var tlo := ColorRect.new()
	tlo.color = Color.BLACK
	tlo.size = Vector2(480, 270)
	_kino.add_child(tlo)
	Gra.flagi["dni_do_pogrzebu"] = 5
	Notatnik.wlacz()
	_zaslona.color.a = 0.0
	var n: Dictionary = Dialogi.SCENA5_NAPISY
	await _napis(n["koniec"], 24, Color8(236, 226, 200), 100, 2.4)
	dzwiek("dzwonek.wav", -12.0)
	await _napis(n["licznik"], 24, Color8(220, 80, 70), 110, 3.0)
	await _napis(n["dalej"], 12, Color8(170, 160, 140), 124, 3.0)
	await _sciemnij(0.6)
	get_tree().change_scene_to_file(NASTEPNA)


func _napis(tekst: String, rozmiar: int, kolor: Color, y: float, czas: float) -> void:
	var l := etykieta(rozmiar, kolor)
	l.text = tekst
	l.position = Vector2(0, y)
	l.size = Vector2(480, 40)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.modulate.a = 0.0
	_kino.add_child(l)
	var tw := create_tween()
	tw.tween_property(l, "modulate:a", 1.0, 0.8)
	tw.tween_interval(czas)
	tw.tween_property(l, "modulate:a", 0.0, 0.8)
	await tw.finished
	l.queue_free()
