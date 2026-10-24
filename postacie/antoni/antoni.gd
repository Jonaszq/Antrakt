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

var kierunek := "dol"

var _kroki: AudioStreamPlayer
var _odglosy := {}

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	_kroki = AudioStreamPlayer.new()
	_kroki.volume_db = -8.0
	add_child(_kroki)
	sprite.frame_changed.connect(_krok)


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
	if not sterowanie:
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
	velocity = Vector2(wejscie.x, wejscie.y * skrot_pionu) * predkosc
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
