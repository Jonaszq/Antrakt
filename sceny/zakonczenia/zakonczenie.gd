extends Node2D
## Zakończenie gry: Gra.flagi["zakonczenie"] (A pełne, B połowiczne, C złe, D czas minął)
## i Gra.flagi["powod"] (dlaczego D). Najpierw scenka zakończenia (film_a..d), potem tu
## tytuł, powód, epilog z tego, co gracz odkrył i przeoczył (Sledztwo.epilog), stracony
## czas, KONIEC, podziękowanie i powrót do menu. E, Enter albo spacja przewija dalej.

const MENU := "res://menu/menu.tscn"
const FILM := "res://sceny/zakonczenia/film_%s.tscn"
const CZAS := 4.5

var _dalej := false


func _ready() -> void:
	var z: Dictionary = Dialogi.ZAKONCZENIA
	var f: Dictionary = Gra.flagi
	var litera: String = f.get("zakonczenie", "D")
	if not f.get("film_konca", false):
		f["film_konca"] = true
		get_tree().change_scene_to_file.call_deferred(FILM % litera.to_lower())
		return
	var warstwa := CanvasLayer.new()
	add_child(warstwa)
	var tlo := ColorRect.new()
	tlo.color = Color.BLACK
	tlo.size = Vector2(1920, 1080)
	warstwa.add_child(tlo)
	var tytul := Label.new()
	tytul.add_theme_font_size_override("font_size", 28)
	tytul.add_theme_color_override("font_color", MenuLista.ZLOTO)
	tytul.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tytul.position = Vector2(0, 160)
	tytul.size = Vector2(1920, 60)
	warstwa.add_child(tytul)
	var napis := Label.new()
	napis.add_theme_font_size_override("font_size", 40)
	napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	napis.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	napis.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	napis.position = Vector2(240, 300)
	napis.size = Vector2(1440, 480)
	warstwa.add_child(napis)
	var teksty: Array = []
	var powod: String = f.get("powod", "")
	if powod != "":
		teksty.append(z[powod])
	tytul.text = z[litera][0]
	if teksty.is_empty():
		teksty.append("")
	for tekst in teksty:
		await _pokaz(napis, tekst)
	tytul.text = ""
	for tekst in Sledztwo.epilog():
		await _pokaz(napis, tekst)
	await _pokaz(napis, z["stracone"] % Sledztwo.stracone())
	await _pokaz(napis, z["koniec"])
	await _pokaz(napis, z["dziekuje"])
	if is_inside_tree():
		get_tree().change_scene_to_file(MENU)


func _pokaz(napis: Label, tekst: String) -> void:
	napis.text = tekst
	napis.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(napis, "modulate:a", 1.0, 0.6)
	_dalej = false
	var czas := 0.0
	while czas < CZAS and not _dalej and is_inside_tree():
		await (Engine.get_main_loop() as SceneTree).process_frame
		czas += get_process_delta_time()


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if k and k.pressed and not k.echo and k.physical_keycode in [KEY_E, KEY_ENTER, KEY_SPACE]:
		_dalej = true
