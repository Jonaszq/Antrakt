extends Node2D
## Koniec rozdziału 4: czwartek wieczorem, do pogrzebu jedna noc. Potem menu
## (rozdział 5 jeszcze nie zrobiony). Teksty w Dialogi.SCENA20.

const NASTEPNA := "res://menu/menu.tscn"


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
	for tekst in teksty:
		napis.text = tekst
		napis.modulate.a = 0.0
		var tw := create_tween()
		tw.tween_property(napis, "modulate:a", 1.0, 0.8)
		await get_tree().create_timer(4.5).timeout
	get_tree().change_scene_to_file(NASTEPNA)
