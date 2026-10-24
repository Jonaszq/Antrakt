extends Node2D
## Deszcz w pixel arcie: ukośne kreski spadające na cały ekran 480x270
## i krótkie rozbryzgi na chodniku.

@export var krople := 140
@export var ziemia := 222.0

var _krople: Array[Vector3] = []  # x, y, prędkość
var _bryzgi: Array[Vector3] = []  # x, y, pozostały czas


func _ready() -> void:
	for i in krople:
		_krople.append(Vector3(randf_range(-40, 480), randf_range(-270, 270), randf_range(260, 340)))


func _process(delta: float) -> void:
	for i in _krople.size():
		var k := _krople[i]
		k.y += k.z * delta
		k.x -= k.z * 0.25 * delta
		if k.y > ziemia + randf_range(0, 48):
			if randf() < 0.4:
				_bryzgi.append(Vector3(k.x, k.y, 0.15))
			k = Vector3(randf_range(0, 520), randf_range(-60, -4), k.z)
		_krople[i] = k
	for i in range(_bryzgi.size() - 1, -1, -1):
		_bryzgi[i].z -= delta
		if _bryzgi[i].z <= 0.0:
			_bryzgi.remove_at(i)
	queue_redraw()


func _draw() -> void:
	var kolor := Color(0.62, 0.7, 0.9, 0.45)
	for k in _krople:
		var p := Vector2(roundf(k.x), roundf(k.y))
		draw_line(p, p + Vector2(-2, 7), kolor, 1.0)
	for b in _bryzgi:
		var p := Vector2(roundf(b.x), roundf(b.y))
		draw_rect(Rect2(p + Vector2(-2, -1), Vector2(1, 1)), kolor)
		draw_rect(Rect2(p + Vector2(2, -1), Vector2(1, 1)), kolor)
		draw_rect(Rect2(p + Vector2(0, -2), Vector2(1, 1)), kolor)
