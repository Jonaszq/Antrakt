extends ScenaGry
## Retrospekcja 2 (po scenie 13): czwartkowa próba generalna w kulisach, tak jak ją
## sobie wyobraża Antoni. Pokazuje tylko to, co gracz ustalił; kogo nie zna, ten jest
## czarną sylwetką. Irena tylko, jeśli z nią rozmawiał (s11_*), "piecze" i jej
## odpowiedź tylko po zeznaniu o podszewce, dłoń na ramieniu po zdjęciu z próby
## (s11_foto); kto to był, na razie nie wiadomo, więc to zawsze czarna sylwetka.
## Na koniec SMS 22:10 (sprawdzona karta "sms") i skrzynka nocna 23:40 (książka przyjęć
## albo karta "kwit"). Teksty w Dialogi.RETRO2.

const NASTEPNA := "res://sceny/scena14/scena14.tscn"
const SYLWETKA := Color(0.02, 0.02, 0.03)

var _adrian: Node2D
var _kamera: Camera2D
var _sledz := false


func _ready() -> void:
	przygotuj($Kulisy)
	antoni.visible = false
	antoni.sterowanie = false
	antoni.wybor_gracza = false
	var marta := obiekty.get_node_or_null("Marta")
	if marta:
		marta.visible = false
	$Kulisy/Mrok.color = Color(0.56, 0.52, 0.5)  # na próbie wszystkie światła zapalone
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
	_kamera = Camera2D.new()
	_kamera.limit_right = 800
	_kamera.limit_bottom = 480
	_kamera.position = Vector2(200, 200)
	obiekty.add_child(_kamera)
	_kamera.make_current()
	dzwiek("gwar.ogg", -22.0, true)
	var r: Dictionary = Dialogi.RETRO2
	var f: Dictionary = Gra.flagi
	var zna_irene: bool = f.get("s11_kostium", false) or f.get("s11_podszewka", false) or f.get("s11_zeszyt", false)
	var irena := postac("irena", Vector2(255, 236))
	if not zna_irene:
		irena.modulate = SYLWETKA
	_adrian = postac("adrian", Vector2(80, 150))
	await plansza(r["tytul"])
	antoni.sterowanie = false
	_sledz = true
	await idz(_adrian, [Vector2(150, 250), Vector2(235, 262)], 26.0)
	await dymek(_adrian, r["adrian_kostium"], 2.5)
	if f.get("s11_podszewka", false):
		await _drapie()
		await dymek(_adrian, r["piecze"], 2.5)
		await dymek(irena, r["irena"], 3.0)
	if f.get("s9_bufetowa_czwartek", false):
		await dymek(_adrian, r["blady"], 2.0)
		await _drapie()
	await idz(_adrian, [Vector2(330, 320), Vector2(450, 330)], 24.0)
	if f.get("s11_foto", false):
		# ktoś staje obok i kładzie mu dłoń na ramieniu; fotograf robi zdjęcie
		var obok := postac("ania", Vector2(330, 330))
		obok.modulate = SYLWETKA
		postac("fotograf", Vector2(520, 400))
		await idz(obok, [Vector2(472, 330)], 34.0)
		await dymek(obok, r["dlon"], 2.5)
		await get_tree().create_timer(0.6).timeout
		await blysk()
	await _drapie()
	await idz(_adrian, [Vector2(600, 320), Vector2(720, 300)], 22.0)
	await get_tree().create_timer(1.0).timeout
	_sledz = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.2)
	await tw.finished
	if Teczka.sprawdzona("sms"):
		komunikat(r["sms"], 3.5)
		await pauza(4.0)
	if f.get("s10_ksiazka", false) or Teczka.karty.has("kwit"):
		komunikat(r["skrzynka"], 4.0)
		await pauza(4.5)
	komunikat(r["koniec"], 3.0)
	await pauza(3.5)
	komunikat(r["rozdzial"], 3.0)
	await pauza(3.5)
	get_tree().change_scene_to_file(NASTEPNA)


func _process(delta: float) -> void:
	if _sledz and _kamera and _adrian:
		_kamera.position = _kamera.position.lerp(_adrian.position + Vector2(0, -30), minf(1.0, delta * 2.0))


## Drapie się po karku: szybkie drżenie sprite'a.
func _drapie() -> void:
	var sprite: Node2D = _adrian.get_node("Sprite")
	var tw := create_tween()
	for i in 6:
		tw.tween_property(sprite, "position:x", 1.0, 0.07)
		tw.tween_property(sprite, "position:x", -1.0, 0.07)
	tw.tween_property(sprite, "position:x", 0.0, 0.07)
	await tw.finished
