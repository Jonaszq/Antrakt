class_name MenuLista
extends VBoxContainer
## Pionowa lista przycisków dla menu głównego i pauzy.
## W/S albo strzałki wybierają, E albo Enter klika, działa też myszka.
##
## Użycie: var lista := MenuLista.new(); lista.ustaw([["Nowa gra", funkcja], ...])

const ZLOTO := Color8(242, 212, 126)
const JASNY := Color8(236, 226, 200)

var _przyciski: Array[Button] = []


func _init() -> void:
	add_theme_constant_override("separation", 4)
	process_mode = Node.PROCESS_MODE_ALWAYS


## Pozycje: lista [napis, Callable]. Pierwszy przycisk dostaje fokus.
func ustaw(pozycje: Array) -> void:
	for p in _przyciski:
		p.queue_free()
	_przyciski.clear()
	for poz in pozycje:
		var b := Button.new()
		b.text = poz[0]
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.custom_minimum_size = Vector2(150, 20)
		b.add_theme_font_size_override("font_size", 12)
		b.add_theme_color_override("font_color", JASNY)
		b.add_theme_color_override("font_hover_color", ZLOTO)
		b.add_theme_color_override("font_focus_color", ZLOTO)
		b.add_theme_color_override("font_pressed_color", ZLOTO)
		b.add_theme_stylebox_override("normal", _styl(Color(0.05, 0.03, 0.04, 0.6), Color(0, 0, 0, 0)))
		b.add_theme_stylebox_override("hover", _styl(Color(0.16, 0.1, 0.1, 0.85), ZLOTO))
		b.add_theme_stylebox_override("focus", _styl(Color(0.16, 0.1, 0.1, 0.85), ZLOTO))
		b.add_theme_stylebox_override("pressed", _styl(Color(0.24, 0.14, 0.12, 0.9), ZLOTO))
		b.pressed.connect(poz[1])
		b.mouse_entered.connect(b.grab_focus)
		add_child(b)
		_przyciski.append(b)
	if not _przyciski.is_empty():
		_przyciski[0].call_deferred("grab_focus")


## Zmienia napis na przycisku (np. "Pełny ekran: tak").
func zmien_napis(nr: int, napis: String) -> void:
	_przyciski[nr].text = napis


func _styl(tlo: Color, ramka: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = tlo
	s.border_color = ramka
	s.border_width_left = 2
	s.content_margin_left = 8
	s.content_margin_right = 8
	return s


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not is_visible_in_tree() or not k or not k.pressed or _przyciski.is_empty():
		return
	var teraz := _przyciski.find(get_viewport().gui_get_focus_owner())
	match k.physical_keycode:
		KEY_W:
			_przyciski[maxi(teraz - 1, 0)].grab_focus()
		KEY_S:
			_przyciski[mini(teraz + 1, _przyciski.size() - 1)].grab_focus()
		KEY_E:
			if teraz >= 0:
				_przyciski[teraz].pressed.emit()
		_:
			return
	get_viewport().set_input_as_handled()
