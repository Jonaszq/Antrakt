extends Node2D
## Filmik na wstęp gry. Cztery ujęcia: napis, teatr w deszczu z Antonim,
## telefon dzwoniący w magazynie przy dłoni Adriana, kurtyna z tytułem.
## Spacja przewija bieżące ujęcie, Escape pomija cały filmik.
## Grafiki rysuje tools/wstep_pixel.py.

const NASTEPNA_SCENA := "res://sceny/scena1/scena1.tscn"

var _pomin := false
var _koniec := false
var _zaslona: ColorRect
var _napis: Label
var _podpis: Label
var _dialog: Dialog
var _muzyka: AudioStreamPlayer


func _ready() -> void:
	var ui := CanvasLayer.new()
	ui.layer = 10
	add_child(ui)
	_zaslona = ColorRect.new()
	_zaslona.color = Color.BLACK
	_zaslona.size = Vector2(480, 270)
	ui.add_child(_zaslona)
	_napis = _etykieta(32, Vector2(0, 100), Vector2(480, 70))
	_napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(_napis)
	_podpis = _etykieta(16, Vector2(8, 2), Vector2(400, 20))
	ui.add_child(_podpis)
	var pomoc := _etykieta(16, Vector2(250, 250), Vector2(226, 20))
	pomoc.text = "Spacja – dalej   Esc – pomiń"
	pomoc.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	pomoc.modulate = Color(1, 1, 1, 0.45)
	ui.add_child(pomoc)
	_muzyka = AudioStreamPlayer.new()
	_muzyka.stream = preload("res://dzwieki/muzyka/wstep.ogg")
	_muzyka.volume_db = -4.0
	add_child(_muzyka)
	_muzyka.play()
	_dialog = Dialog.new()
	_dialog.auto = 1.6
	_dialog.u_gory = true
	add_child(_dialog)
	_film()


func _etykieta(rozmiar: int, poz: Vector2, wym: Vector2) -> Label:
	var l := Label.new()
	l.position = poz
	l.size = wym
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", Color8(236, 226, 200))
	l.add_theme_color_override("font_shadow_color", Color8(12, 8, 10))
	l.add_theme_constant_override("shadow_offset_x", 1)
	l.add_theme_constant_override("shadow_offset_y", 1)
	return l


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo:
		return
	if k.physical_keycode == KEY_ESCAPE:
		_zakoncz()
	elif k.physical_keycode == KEY_SPACE and not _dialog.trwa():
		_pomin = true


## Czeka podaną liczbę sekund albo do naciśnięcia spacji.
func _czekaj(sekundy: float) -> void:
	_pomin = false
	var t := 0.0
	while t < sekundy and not _pomin and not _koniec:
		await get_tree().process_frame
		t += get_process_delta_time()


## Odpala animację i czeka na jej koniec; spacja od razu ją kończy.
func _animuj(obiekt: Object, wlasciwosc: String, cel: Variant, sekundy: float) -> void:
	var tw := create_tween()
	tw.tween_property(obiekt, wlasciwosc, cel, sekundy)
	await _czekaj(sekundy)
	if tw.is_valid():
		tw.custom_step(sekundy + 1.0)


func _sprite(sciezka: String, poz := Vector2.ZERO, rodzic: Node = self) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = load(sciezka)
	s.centered = false
	s.position = poz
	rodzic.add_child(s)
	return s


func _ujecie() -> Node2D:
	var n := Node2D.new()
	add_child(n)
	move_child(n, 0)
	return n


func _film() -> void:
	# 1. Napis
	_napis.text = "Sobota, 18:20\nWieczór premiery"
	_napis.modulate.a = 0.0
	await _animuj(_napis, "modulate:a", 1.0, 1.2)
	await _czekaj(2.4)
	await _animuj(_napis, "modulate:a", 0.0, 1.0)
	if _koniec:
		return

	# 2. Teatr w deszczu
	var teatr := _ujecie()
	_sprite("res://wstep/teatr_noc.png", Vector2.ZERO, teatr)
	var antoni: CharacterBody2D = preload("res://postacie/antoni/antoni.tscn").instantiate()
	antoni.sterowanie = false
	antoni.wybor_gracza = false
	antoni.podloze = "mokry"
	antoni.position = Vector2(-24, 238)
	teatr.add_child(antoni)
	var deszcz := Node2D.new()
	deszcz.set_script(preload("res://wstep/deszcz.gd"))
	teatr.add_child(deszcz)
	antoni.get_node("Sprite").play("idzie_prawo")
	_podpis.text = "Teatr Miejski"
	await _animuj(_zaslona, "color:a", 0.0, 1.5)
	await _animuj(antoni, "position:x", 196.0, 4.5)
	antoni.stan("gora")
	await _czekaj(1.0)
	if _koniec:
		return
	_podpis.text = ""
	await _dialog.pokaz(Dialogi.WSTEP["pod_teatrem"])
	antoni.get_node("Sprite").play("idzie_gora")
	var tw := create_tween().set_parallel()
	tw.tween_property(antoni, "position", Vector2(240, 214), 2.0)
	tw.tween_property(_zaslona, "color:a", 1.0, 2.0).set_delay(0.6)
	await _czekaj(2.6)
	if tw.is_valid():
		tw.custom_step(5.0)
	teatr.queue_free()
	_podpis.text = ""
	if _koniec:
		return

	# 3. Magazyn dekoracji i telefon przy dłoni
	var magazyn := _ujecie()
	_sprite("res://wstep/magazyn.png", Vector2.ZERO, magazyn)
	var blask := _sprite("res://wstep/telefon_blask.png", Vector2(328, 204), magazyn)
	_podpis.text = "W tym samym czasie. Magazyn dekoracji."
	var miganie := create_tween().set_loops()
	miganie.tween_property(blask, "modulate:a", 0.25, 0.35)
	miganie.tween_property(blask, "modulate:a", 1.0, 0.35)
	await _animuj(_zaslona, "color:a", 0.0, 1.2)
	await _czekaj(3.4)
	miganie.kill()
	magazyn.queue_free()
	_podpis.text = ""
	if _koniec:
		return
	var blisko := _ujecie()
	_sprite("res://wstep/zblizenie.png", Vector2.ZERO, blisko)
	var ekran := _sprite("res://wstep/ekran.png", Vector2(294, 68), blisko)
	var drgania := create_tween().set_loops()
	for dx in [1, -1, 1, 0]:
		drgania.tween_property(ekran, "position:x", 294.0 + dx, 0.05)
	drgania.tween_interval(0.5)
	await _czekaj(3.6)
	drgania.kill()
	ekran.visible = false  # połączenie przepadło, ekran gaśnie
	await _czekaj(1.4)
	_zaslona.color.a = 1.0
	blisko.queue_free()
	await _czekaj(0.8)
	if _koniec:
		return

	# 4. Kurtyna i tytuł
	var kurtyna := _ujecie()
	_sprite("res://wstep/scena_tlo.png", Vector2.ZERO, kurtyna)
	var tytul := _sprite("res://wstep/tytul.png", Vector2(90, 84), kurtyna)
	tytul.modulate.a = 0.0
	var lewa := _sprite("res://wstep/kurtyna_l.png", Vector2(-10, 0), kurtyna)
	var prawa := _sprite("res://wstep/kurtyna_p.png", Vector2(240, 0), kurtyna)
	_sprite("res://wstep/lambrekin.png", Vector2.ZERO, kurtyna)
	await _animuj(_zaslona, "color:a", 0.0, 1.0)
	var rozsun := create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	rozsun.tween_property(lewa, "position:x", -190.0, 3.2)
	rozsun.tween_property(prawa, "position:x", 420.0, 3.2)
	rozsun.tween_property(tytul, "modulate:a", 1.0, 1.6).set_delay(1.8)
	await _czekaj(3.4)
	if rozsun.is_valid():
		rozsun.custom_step(5.0)
	await _czekaj(3.0)
	await _animuj(_zaslona, "color:a", 1.0, 1.5)
	_zakoncz()


func _zakoncz() -> void:
	if _koniec:
		return
	_koniec = true
	var cisza := create_tween().set_parallel()
	cisza.tween_property(_muzyka, "volume_db", -40.0, 0.6)
	cisza.tween_property(_zaslona, "color:a", 1.0, 0.6)
	await cisza.finished
	get_tree().change_scene_to_file(NASTEPNA_SCENA)
