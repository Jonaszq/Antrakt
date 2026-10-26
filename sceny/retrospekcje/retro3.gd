extends RetroBaza
## Retrospekcja 3 (po scenie 17): czwartek 22:10 w mieszkaniu Adriana. Pokazuje tylko to,
## co Antoni ustalił: tabletki (s17_leki), notatka na lodówce (s17_notatka), SMS (s17_sms),
## sąsiadka za ścianą (s17_sasiadka) i drzwi na klatkę (s17_goscie). Na końcu ktoś
## w mieście czyta wiadomość: czarna sylwetka do przymierzenia (kontekst "sms"),
## z pierścionkiem, jeśli Antoni widział zdjęcie z próby (s11_foto). Teksty w Dialogi.RETRO3.

const NASTEPNA := "res://sceny/scena18/scena18.tscn"
const CZYTA := Vector2(520, 190)

var _adrian: Node2D


func _ready() -> void:
	przygotuj_retro($Mieszkanie, Vector2(640, 360), Vector2(320, 180), Color(0.42, 0.44, 0.62))
	var r: Dictionary = Dialogi.RETRO3
	var f: Dictionary = Gra.flagi
	_adrian = postac("adrian", Vector2(90, 190))
	await plansza(r["tytul"])
	antoni.sterowanie = false
	await dymek(_adrian, r["kaszel"], 2.5)
	await dymek(_adrian, r["piecze"], 2.0)
	await idz(_adrian, [Vector2(180, 200), Vector2(250, 205)], 22.0)
	if f.get("s17_leki", false):
		await dymek(_adrian, r["tabletki"], 2.5)
	if f.get("s17_notatka", false):
		await idz(_adrian, [Vector2(420, 170), Vector2(580, 150)], 24.0)
		await dymek(_adrian, r["maść"], 2.5)
		await idz(_adrian, [Vector2(420, 180), Vector2(250, 205)], 24.0)
	if f.get("s17_sms", false):
		await dymek(_adrian, r["sms"], 4.0)
	else:
		await dymek(_adrian, r["telefon_bez"], 3.0)
	if f.get("s17_sasiadka", false):
		var sciana := Node2D.new()
		sciana.position = Vector2(120, 220)
		obiekty.add_child(sciana)
		await dymek(sciana, r["sciana"], 3.0)
	if f.get("s17_goscie", false):
		await idz(_adrian, [Vector2(320, 210)], 22.0)
		await dymek(_adrian, r["drzwi"], 2.5)
		await idz(_adrian, [Vector2(250, 205)], 22.0)
	await dymek(_adrian, r["czeka"], 2.5)
	if not f.get("s17_sms", false):
		await zakoncz([r["koniec_bez_sms"]], NASTEPNA)
		return
	# gdzieś w mieście ktoś czyta wiadomość
	_adrian.visible = false
	$Mieszkanie/Mrok.color = Color(0.12, 0.12, 0.2)
	var czyta := postac("sylwetka", CZYTA)
	var ekran := PointLight2D.new()
	ekran.texture = _swiatlo()
	ekran.color = Color(0.6, 0.8, 1.0)
	ekran.energy = 1.4
	ekran.position = CZYTA + Vector2(0, -30)
	obiekty.add_child(ekran)
	komunikat(r["ekran"], 4.0)
	await pauza(4.5)
	if f.get("s11_foto", false):
		komunikat(r["pierscionek"], 3.5)
		await pauza(4.0)
	await przymierz(czyta, "sms")
	await zakoncz([r["koniec"]], NASTEPNA)


func _swiatlo() -> Texture2D:
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0)])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 128
	t.height = 128
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1, 0.5)
	return t
