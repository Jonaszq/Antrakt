extends ScenaGry
## Retrospekcja 1 (po scenie 7): piątek, 21:00, magazyn dekoracji tak, jak go sobie
## wyobraża Antoni. Obraz jest wyblakły (ui/retrospekcja.gdshader). Pokazuje tylko to,
## co gracz naprawdę ustalił: Zenon wpuszcza Adriana tylko, jeśli Zenon o tym
## opowiedział; telefon wypada pod manekinem, jeśli gracz go znalazł; Adrian pisze
## na liście, jeśli gracz ją przeczytał; skarży się na skórę, jeśli Zenon o tym mówił.
## Nikogo więcej tu nie ma. Teksty w Dialogi.RETRO1.

const NASTEPNA := "res://menu/menu.tscn"  # scena 8 jeszcze nie zrobiona

var _adrian: Node2D


func _ready() -> void:
	przygotuj($Magazyn)
	antoni.visible = false
	antoni.sterowanie = false
	antoni.wybor_gracza = false
	$Magazyn/Mrok.color = Color(0.5, 0.48, 0.44)  # w piątek w hali paliło się światło
	obiekty.get_node("manekin_upadek").visible = true
	var filtr := CanvasLayer.new()
	filtr.layer = 5
	var obraz := ColorRect.new()
	obraz.size = Vector2(1920, 1080)
	obraz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://ui/retrospekcja.gdshader")
	obraz.material = mat
	filtr.add_child(obraz)
	add_child(filtr)
	var kamera := Camera2D.new()
	kamera.limit_right = 960
	kamera.limit_bottom = 600
	kamera.position = Vector2(480, 420)
	obiekty.add_child(kamera)
	kamera.make_current()
	dzwiek("magazyn.ogg", -14.0, true)
	var r: Dictionary = Dialogi.RETRO1
	var f: Dictionary = Gra.flagi
	_adrian = postac("adrian", Vector2(480, 640))
	var zenon: Node2D = null
	if f.get("s7_piatek", false):
		zenon = postac("zenon", Vector2(520, 640))
	await plansza(r["tytul"])
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(kamera, "position", Vector2(480, 470), 2.0)
	if zenon:
		przesun(zenon, Vector2(520, 560), 1.5)
	await przesun(_adrian, Vector2(480, 540), 2.0)
	if zenon:
		await dymek(zenon, r["zenon"], 2.5)
		przesun(zenon, Vector2(520, 660), 1.5)
	if f.get("s7_wyglad", false):
		await dymek(_adrian, r["skora"], 2.5)
	if Ekwipunek.ma("telefon_adriana"):
		_jedz_kamera(kamera, Vector2(240, 430))
		await przesun(_adrian, Vector2(170, 486), 4.0)
		rekwizyt("telefon_podloga", Vector2(160, 480))
		await get_tree().create_timer(0.8).timeout
	if Ekwipunek.ma("lista_rekwizytow"):
		_jedz_kamera(kamera, Vector2(700, 300))
		await przesun(_adrian, Vector2(714, 262), 4.0)
		await dymek(_adrian, r["lista"], 2.5)
	_jedz_kamera(kamera, Vector2(780, 400))
	await przesun(_adrian, Vector2(785, 440), 3.0)
	await get_tree().create_timer(0.8).timeout
	# upada wśród skrzyń
	tw = create_tween()
	tw.tween_property(_adrian, "rotation", PI / 2.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tw.finished
	dzwiek("upadek.wav", -4.0)
	await get_tree().create_timer(2.0).timeout
	komunikat(r["koniec"], 3.0)
	await get_tree().create_timer(4.0).timeout
	przejdz(NASTEPNA)


func _jedz_kamera(kamera: Camera2D, cel: Vector2) -> void:
	var tw := create_tween()
	tw.tween_property(kamera, "position", cel, 2.5).set_trans(Tween.TRANS_SINE)


## Scena 8 jeszcze nie istnieje: plansza i powrót do menu.
func przejdz(scena: String) -> void:
	koniec = true
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	var napis := etykieta(12, Color8(170, 160, 140))
	napis.text = Dialogi.RETRO1["dalej"]
	napis.position = Vector2(0, 124)
	napis.size = Vector2(480, 20)
	napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(napis)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file(scena)
