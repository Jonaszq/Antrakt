extends CharacterBody2D
## Antoni, postać gracza. Ruch na WASD albo strzałkach, w czterech kierunkach
## (lewo to odbicie prawej strony). Animacje nazywają się "stoi_<kierunek>"
## i "idzie_<kierunek>", gdzie kierunek to dol, gora albo prawo.

@export var predkosc := 260.0

## Kamera pod skosem skraca pion, więc ruch w górę i w dół jest trochę wolniejszy.
@export var skrot_pionu := 0.75

var kierunek := "dol"

@onready var sprite: AnimatedSprite2D = $Sprite


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


func _klawisz(a: Key, b: Key) -> float:
	return 1.0 if Input.is_physical_key_pressed(a) or Input.is_physical_key_pressed(b) else 0.0


func _graj(nazwa: String) -> void:
	if sprite.animation != nazwa:
		sprite.play(nazwa)
