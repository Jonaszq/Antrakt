extends RetroBaza
## Retrospekcja 4 (po scenie 18, tylko gdy Antoni słyszał o nagraniu): rok temu, nocna
## droga. Auto potrąca rowerzystę i odjeżdża, za kierownicą czarna sylwetka (przymierzanie,
## kontekst "droga"). Za nim drugie auto: Wolski z kamerą. Z pendrive'em (s18_sejf)
## Antoni widział nagranie, więc wie, że da się rozpoznać kierowcę. Teksty w Dialogi.RETRO4.

const NASTEPNA := "res://sceny/scena19/scena19.tscn"
const DROGA_Y := 300.0


func _ready() -> void:
	przygotuj_retro($Plac, Vector2(800, 450), Vector2(400, 260), Color(0.5, 0.5, 0.64))
	obiekty.get_node("radiowoz").visible = false
	var r: Dictionary = Dialogi.RETRO4
	var f: Dictionary = Gra.flagi
	var rowerzysta := postac("gosc_pan", Vector2(120, DROGA_Y - 6))
	var rower := Sprite2D.new()
	rower.texture = load("res://mapy/mieszkanie_adriana/rower.png")
	rower.position = Vector2(0, -10)
	rowerzysta.add_child(rower)
	# samochody bez napisów: kopie auta z mapy placu
	var auto: Sprite2D = obiekty.get_node("auto_antoniego")
	auto.position = Vector2(900, DROGA_Y + 12)
	auto.modulate = Color(1.0, 0.45, 0.45)
	var drugie: Sprite2D = auto.duplicate()
	obiekty.add_child(drugie)
	drugie.position = Vector2(1100, DROGA_Y + 12)
	drugie.modulate = Color(0.3, 0.3, 0.36)
	await plansza(r["tytul"])
	antoni.sterowanie = false
	dymek(rowerzysta, r["rower"], 2.0)
	var jedzie := create_tween()
	jedzie.tween_property(rowerzysta, "position:x", 330.0, 4.0)
	var tw := create_tween()
	tw.tween_property(auto, "position:x", 350.0, 3.6)
	await tw.finished
	dymek(auto, r["hamulce"], 1.5)
	await get_tree().create_timer(0.5).timeout
	dzwiek("upadek.wav", -4.0)
	komunikat(r["uderzenie"], 2.0)
	jedzie.kill()
	rowerzysta.rotation = PI / 2
	await get_tree().create_timer(1.5).timeout
	# kierowca wysiada i patrzy
	var kierowca := postac("sylwetka", Vector2(400, DROGA_Y - 30))
	await idz(kierowca, [Vector2(350, DROGA_Y - 24)], 30.0)
	await get_tree().create_timer(1.0).timeout
	# drugie auto staje w oddali, czerwona lampka kamery
	var tw2 := create_tween()
	tw2.tween_property(drugie, "position:x", 600.0, 2.5)
	await tw2.finished
	var wolski := postac("wolski", Vector2(640, DROGA_Y - 34))
	komunikat(r["kamera"], 3.0)
	await dymek(wolski, r["wolski"], 2.5)
	if f.get("s18_sejf", false):
		komunikat(r["pendrive"], 4.0)
		await pauza(4.5)
	await przymierz(kierowca, "droga")
	await idz(kierowca, [Vector2(400, DROGA_Y - 30)], 40.0)
	kierowca.visible = false
	dymek(auto, r["odjezdza"], 2.0)
	var tw3 := create_tween()
	tw3.tween_property(auto, "position:x", -160.0, 2.5)
	await tw3.finished
	await zakoncz([r["koniec"]], NASTEPNA)
