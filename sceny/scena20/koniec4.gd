extends Node2D
## Koniec rozdziału 4: czwartek wieczorem, do pogrzebu jedna noc. Potem rozdział 5
## (scena 21). Teksty w Dialogi.SCENA20.

const NASTEPNA := "res://sceny/scena21/scena21.tscn"

## E, spacja albo Enter przeskakuje do następnego napisu.
var _dalej := false


func _ready() -> void:
	Gra.flagi["dni_do_pogrzebu"] = 1
	var warstwa := CanvasLayer.new()
	add_child(warstwa)
	var tlo := ColorRect.new()
	tlo.color = Color.BLACK
	tlo.size = Vector2(1920, 1080)
	warstwa.add_child(tlo)
	var napis := Label.new()
	napis.add_theme_font_size_override("font_size", 40)
	napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	napis.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	napis.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	napis.position = Vector2(240, 300)
	napis.size = Vector2(1440, 480)
	warstwa.add_child(napis)
	var t: Dictionary = Dialogi.SCENA20
	var teksty: Array = t["koniec_dnia"].map(func(k): return k[1])
	teksty.append(t["rozdzial"])
	teksty.append(t["rozdzial5"])
	for tekst in teksty:
		napis.text = tekst
		napis.modulate.a = 0.0
		var tw := create_tween()
		tw.tween_property(napis, "modulate:a", 1.0, 0.8)
		_dalej = false
		var czas := 0.0
		while czas < 4.5 and not _dalej:
			await get_tree().process_frame
			czas += get_process_delta_time()
	get_tree().change_scene_to_file(NASTEPNA)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo \
			and event.physical_keycode in [KEY_E, KEY_SPACE, KEY_ENTER]:
		_dalej = true
