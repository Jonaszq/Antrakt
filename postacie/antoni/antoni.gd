extends CharacterBody2D
## Antoni, postać gracza. Ruch na WASD albo strzałkach, w czterech kierunkach
## (lewo to odbicie prawej strony). Animacje nazywają się "stoi_<kierunek>"
## i "idzie_<kierunek>", gdzie kierunek to dol, gora albo prawo.

@export var predkosc := 260.0

## Kamera pod skosem skraca pion, więc ruch w górę i w dół jest trochę wolniejszy.
@export var skrot_pionu := 0.75

var kierunek := "dol"

## Tymczasowy ruch "na sznurkach": dopóki animacja ma jedną klatkę,
## postać podskakuje i kołysze się w kodzie. Gdy dojdą prawdziwe klatki,
## to wyłącza się samo.
@export var krokow_na_sekunde := 4.0
@export var wysokosc_podskoku := 5.0
@export var kolysanie_stopni := 2.5

var _czas := 0.0
var _skala_sprite: Vector2

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var cien: Sprite2D = $Cien
@onready var _skala_cienia := cien.scale


func _ready() -> void:
	_skala_sprite = sprite.scale


func _physics_process(_delta: float) -> void:
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


func _process(delta: float) -> void:
	if sprite.sprite_frames.get_frame_count(sprite.animation) > 1:
		_ustaw_poze(0.0, 0.0, 1.0, 1.0)
		return
	_czas += delta
	if velocity.length() > 1.0:
		# każdy krok to pół okresu sinusa: w górę, w dół, przechył na drugą nogę
		var faza := _czas * krokow_na_sekunde * PI
		var podskok := absf(sin(faza))
		_ustaw_poze(podskok * wysokosc_podskoku, sin(faza) * kolysanie_stopni, 1.0, 1.0 - podskok * 0.12)
	else:
		# spokojny oddech: rośnie tylko wysokość, stopy zostają na miejscu
		_ustaw_poze(0.0, 0.0, 1.0 + sin(_czas * 2.2) * 0.008, 1.0)


func _ustaw_poze(podskok: float, przechyl: float, oddech: float, cien_mnoznik: float) -> void:
	sprite.position.y = -podskok
	sprite.rotation_degrees = przechyl
	sprite.scale = Vector2(_skala_sprite.x, _skala_sprite.y * oddech)
	cien.scale = _skala_cienia * cien_mnoznik


func _klawisz(a: Key, b: Key) -> float:
	return 1.0 if Input.is_physical_key_pressed(a) or Input.is_physical_key_pressed(b) else 0.0


func _graj(nazwa: String) -> void:
	if sprite.animation != nazwa:
		sprite.play(nazwa)
