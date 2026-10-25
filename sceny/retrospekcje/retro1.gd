extends ScenaGry
## Retrospekcja 1 (po scenie 7): piątek, 21:00, magazyn dekoracji tak, jak go sobie
## wyobraża Antoni. Obraz jest wyblakły (ui/retrospekcja.gdshader). Pokazuje tylko to,
## co gracz naprawdę ustalił: Zenon wpuszcza Adriana tylko, jeśli Zenon o tym
## opowiedział; telefon wypada pod manekinem, jeśli gracz go znalazł; Adrian pisze
## na liście, jeśli gracz ją przeczytał; skarży się na skórę, jeśli Zenon o tym mówił.
## Wyjście po wodę, jeśli pytał sprzedawcę; termos i kielich, jeśli je znalazł.
## Adrian chodzi alejkami (ScenaGry.idz). Nikogo więcej tu nie ma. Teksty w Dialogi.RETRO1.

const NASTEPNA := "res://menu/menu.tscn"  # scena 8 jeszcze nie zrobiona

var _adrian: Node2D
var _kamera: Camera2D
var _sledz := false


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
	_kamera = kamera
	var r: Dictionary = Dialogi.RETRO1
	var f: Dictionary = Gra.flagi
	var przewrocona: Node2D = obiekty.get_node("skrzynia_przewrocona")
	przewrocona.visible = false  # w piątek skrzynka jeszcze stała
	_adrian = postac("adrian", Vector2(480, 640))
	var zenon: Node2D = null
	if f.get("s7_piatek", false):
		zenon = postac("zenon", Vector2(520, 640))
	await plansza(r["tytul"])
	antoni.sterowanie = false
	_sledz = true
	# 21:00, wchodzi bramą
	if zenon:
		idz(zenon, [Vector2(520, 560)], 30.0)
	await idz(_adrian, [Vector2(480, 540)], 30.0)
	if zenon:
		await dymek(zenon, r["zenon"], 2.5)
		idz(zenon, [Vector2(520, 660)], 30.0)
	if f.get("s7_wyglad", false):
		await _drapie()
		await dymek(_adrian, r["skora"], 2.5)
	# lewa alejka, między manekinami (tylko jeśli gracz znalazł tam telefon)
	if Ekwipunek.ma("telefon_adriana"):
		await idz(_adrian, [Vector2(470, 420), Vector2(260, 420), Vector2(176, 430), Vector2(172, 470)], 28.0)
		await _postoj(1.0)
		rekwizyt("telefon_podloga", Vector2(160, 480))
		dzwiek("upadek.wav", -18.0)
		await _kolysz()
		await idz(_adrian, [Vector2(176, 430), Vector2(470, 420)], 26.0)
	# ok. 22:30 wychodzi po wodę do kiosku (wie o tym tylko, kto pytał sprzedawcę)
	if f.get("s7_woda", false):
		await idz(_adrian, [Vector2(480, 540), Vector2(480, 640)], 26.0)
		await get_tree().create_timer(1.5).timeout
		await idz(_adrian, [Vector2(480, 540)], 22.0)
		await dymek(_adrian, r["woda"], 2.0)
		await _drapie()
	# salon z lat 30.: siada na sofie (lista albo termos)
	var lista := Ekwipunek.ma("lista_rekwizytow")
	var termos := Ekwipunek.ma("termos")
	if lista or termos:
		await idz(_adrian, [Vector2(470, 286), Vector2(620, 286), Vector2(700, 262)], 22.0)
		await _kolysz()
		await dymek(_adrian, r["siada"], 2.0)
		var tw := create_tween()
		tw.tween_property(_adrian, "position", Vector2(690, 214), 0.8)
		await tw.finished
		if termos:
			await dymek(_adrian, r["termos"], 2.5)
		if lista:
			await dymek(_adrian, r["lista"], 2.5)
		await _postoj(1.5)
		await idz(_adrian, [Vector2(700, 262), Vector2(790, 290)], 18.0)
	else:
		await idz(_adrian, [Vector2(470, 286), Vector2(620, 286), Vector2(790, 290)], 22.0)
	# skrzynie: pakuje rekwizyty
	await idz(_adrian, [Vector2(780, 350), Vector2(785, 430)], 16.0)
	if lista:
		await dymek(_adrian, r["kielichy"], 2.0)
	await _postoj(1.2)
	if Ekwipunek.ma("kielich"):
		# czwarty kielich wypada mu z rąk i toczy się pod skrzynię
		var kielich := rekwizyt("kielich_podloga", Vector2(780, 432))
		var tk := create_tween()
		tk.tween_property(kielich, "position", Vector2(704, 452), 1.2).set_ease(Tween.EASE_OUT)
		tk.parallel().tween_property(kielich, "rotation", -TAU, 1.2)
		await tk.finished
		await _kolysz()
		await dymek(_adrian, r["kielich_upada"], 2.0)
	await _kolysz()
	await get_tree().create_timer(0.6).timeout
	# upada razem ze skrzynką
	_sledz = false
	var tw2 := create_tween()
	tw2.tween_property(_adrian, "rotation", PI / 2.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tw2.finished
	przewrocona.visible = true
	dzwiek("upadek.wav", -4.0)
	await get_tree().create_timer(2.0).timeout
	komunikat(r["koniec"], 3.0)
	await get_tree().create_timer(4.0).timeout
	przejdz(NASTEPNA)


func _process(delta: float) -> void:
	if _sledz and _kamera and _adrian:
		_kamera.position = _kamera.position.lerp(_adrian.position + Vector2(0, -30), minf(1.0, delta * 2.0))


## Zatacza się: kilka przechyłów na boki.
func _kolysz() -> void:
	var tw := create_tween()
	for k in [0.08, -0.1, 0.06, -0.04, 0.0]:
		tw.tween_property(_adrian, "rotation", k, 0.25).set_trans(Tween.TRANS_SINE)
	await tw.finished


## Drapie się po ramionach: szybkie drżenie sprite'a.
func _drapie() -> void:
	var sprite: Node2D = _adrian.get_node("Sprite")
	var tw := create_tween()
	for i in 6:
		tw.tween_property(sprite, "position:x", 1.0, 0.07)
		tw.tween_property(sprite, "position:x", -1.0, 0.07)
	tw.tween_property(sprite, "position:x", 0.0, 0.07)
	await tw.finished


func _postoj(czas: float) -> void:
	await get_tree().create_timer(czas).timeout


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
