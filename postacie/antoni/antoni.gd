extends CharacterBody2D
## Antoni, postać gracza. Ruch na WASD albo strzałkach, w czterech kierunkach
## (lewo to odbicie prawej strony). Animacje nazywają się "stoi_<kierunek>"
## i "idzie_<kierunek>", gdzie kierunek to dol, gora albo prawo.
## Klatki rysuje tools/antoni_pixel.py.

## Prędkość w pikselach gry (480x270), na ekranie wychodzi x4.
@export var predkosc := 80.0

## Kamera pod skosem skraca pion, więc ruch w górę i w dół jest trochę wolniejszy.
@export var skrot_pionu := 0.75

## Wyłączone w filmikach i podczas rozmów: Antoni stoi, a animacją steruje scena.
@export var sterowanie := true

## Po czym chodzi Antoni: drewno, marmur, dywan albo mokry (dźwięki w dzwieki/kroki/).
@export var podloze := "drewno"

## Miejsca z innym podłożem niż reszta mapy, np. chodnik w foyer: [[Rect2, "dywan"], ...].
@export var strefy_podloza: Array = []

## Czy Antoni słucha wyboru gracza (Tab: zwykły albo z latarnią). W filmikach wyłączone.
@export var wybor_gracza := true

var kierunek := "dol"
var _latarnia: PointLight2D

var _kroki: AudioStreamPlayer
var _odglosy := {}

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	_kroki = AudioStreamPlayer.new()
	_kroki.volume_db = -8.0
	add_child(_kroki)
	sprite.frame_changed.connect(_krok)
	if wybor_gracza:
		ustaw_latarnie(Gra.latarnia)
		Gra.zmieniono_postac.connect(ustaw_latarnie)


## Podmienia klatki na Antoniego z latarnią (albo bez) i włącza mocne, ciepłe światło.
func ustaw_latarnie(z: bool) -> void:
	var wzor: Node = load("res://postacie/antoni/antoni_latarnia.tscn" if z else "res://postacie/antoni/antoni.tscn").instantiate()
	var animacja := sprite.animation
	var klatka := sprite.frame
	sprite.sprite_frames = wzor.get_node("Sprite").sprite_frames
	wzor.free()
	sprite.play(animacja)
	sprite.frame = klatka
	if z and not _latarnia:
		_latarnia = PointLight2D.new()
		var g := Gradient.new()
		g.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
		g.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0.4), Color(1, 1, 1, 0)])
		var t := GradientTexture2D.new()
		t.gradient = g
		t.width = 256
		t.height = 256
		t.fill = GradientTexture2D.FILL_RADIAL
		t.fill_from = Vector2(0.5, 0.5)
		t.fill_to = Vector2(1, 0.5)
		_latarnia.texture = t
		_latarnia.color = Color(1, 0.74, 0.42)
		_latarnia.energy = 2.0
		_latarnia.texture_scale = 3.2
		_latarnia.position = Vector2(0, -20)
		add_child(_latarnia)
	if _latarnia:
		_latarnia.visible = z


func _odglos(nazwa: String) -> AudioStreamRandomizer:
	if not _odglosy.has(nazwa):
		var r := AudioStreamRandomizer.new()
		r.random_pitch = 1.08
		r.random_volume_offset_db = 2.0
		for i in range(1, 5):
			r.add_stream(-1, load("res://dzwieki/kroki/%s_%d.wav" % [nazwa, i]))
		_odglosy[nazwa] = r
	return _odglosy[nazwa]


## Stopa dotyka ziemi w klatkach 0 i 4 animacji chodu.
func _krok() -> void:
	if not sprite.animation.begins_with("idzie_") or sprite.frame % 4 != 0:
		return
	var nazwa := podloze
	for s in strefy_podloza:
		if (s[0] as Rect2).has_point(position):
			nazwa = s[1]
	_kroki.stream = _odglos(nazwa)
	_kroki.play()


func _physics_process(_delta: float) -> void:
	if not sterowanie or Gra.okno_otwarte():
		velocity = Vector2.ZERO
		if sterowanie:
			_graj("stoi_" + kierunek)
		return
	var wejscie := Vector2(
		_klawisz(KEY_D, KEY_RIGHT) - _klawisz(KEY_A, KEY_LEFT),
		_klawisz(KEY_S, KEY_DOWN) - _klawisz(KEY_W, KEY_UP)
	)
	if wejscie != Vector2.ZERO:
		wejscie = wejscie.normalized()
		# przy ukosie wygrywa oś pozioma, tak jak w większości gier z góry
		if wejscie.x != 0.0:
			kierunek = "prawo"
			sprite.flip_h = wejscie.x < 0.0
		else:
			kierunek = "dol" if wejscie.y > 0.0 else "gora"
			sprite.flip_h = false
	velocity = Vector2(wejscie.x, wejscie.y * skrot_pionu) * predkosc * Gra.mnoznik_predkosci()
	move_and_slide()
	_graj(("idzie_" if wejscie != Vector2.ZERO else "stoi_") + kierunek)


func _klawisz(a: Key, b: Key) -> float:
	return 1.0 if Input.is_physical_key_pressed(a) or Input.is_physical_key_pressed(b) else 0.0


## Ustawia postawę "stoi" w danym kierunku (dol, gora, prawo, lewo).
func stan(kier: String) -> void:
	sprite.flip_h = kier == "lewo"
	kierunek = "prawo" if kier == "lewo" else kier
	_graj("stoi_" + kierunek)


func _graj(nazwa: String) -> void:
	if sprite.animation != nazwa:
		sprite.play(nazwa)
