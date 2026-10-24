extends Node2D
## Scena 1: foyer, sobota 18:30. Samouczek chodzenia i rozmów.
## Goście plotkują o zaginionym dublerze, Ania przy drzwiach służbowych dzwoni
## do Adriana. Po podsłuchaniu jej rozmowy w notesie pojawia się pierwszy wpis
## i otwierają się drzwi "PERSONEL", którymi Antoni trafia za kulisy (scena 2).

const NASTEPNA_SCENA := "res://mapy/kulisy/kulisy.tscn"
const ZASIEG := 26.0  # jak blisko trzeba podejść, żeby porozmawiać
const DRZWI := Rect2(196, 112, 36, 26)

## Goście w foyer: plik postaci, pozycja i ich kwestie.
const GOSCIE := [
	["gosc_pan", Vector2(560, 252), [
		["Starszy pan", "Słyszał pan? Podobno dubler Wolskiego zniknął. Od wczoraj nikt go nie widział."],
		["Antoni", "Może po prostu ma tremę."],
		["Starszy pan", "Trema przed rolą, której może nawet nie zagra? Młodzi dziś są dziwni."],
	]],
	["gosc_pani", Vector2(694, 248), [
		["Elegancka pani", "Wolski grał podobno generalną w gorączce. Trzydzieści dziewięć stopni!"],
		["Elegancka pani", "Prawdziwy zawodowiec. Dubler nawet nie musiał wchodzić na scenę."],
	]],
	["gosc_student", Vector2(170, 318), [
		["Student", "Kupiłem bilet pół roku temu. Jak Wolski dziś nie zagra, to chyba umrę."],
		["Antoni", "Lepiej nie."],
	]],
]

var _antoni: CharacterBody2D
var _ania: Node2D
var _dialog: Dialog
var _rozmowcy: Array = []  # [węzeł, kwestie]
var _podpowiedz: PanelContainer
var _podpowiedz_tekst: Label
var _ania_podsluchana := false
var _koniec := false
var _zaslona: ColorRect


func _ready() -> void:
	var foyer := $Foyer
	_antoni = foyer.get_node("Obiekty/Antoni")
	_ania = foyer.get_node("Obiekty/Ania")
	_antoni.stan("gora")
	for g in GOSCIE:
		var postac: Node2D = load("res://postacie/%s/%s.tscn" % [g[0], g[0]]).instantiate()
		postac.position = g[1]
		foyer.get_node("Obiekty").add_child(postac)
		_rozmowcy.append([postac, g[2]])

	var ui := CanvasLayer.new()
	ui.layer = 10
	add_child(ui)
	_podpowiedz = PanelContainer.new()
	var styl := StyleBoxTexture.new()
	styl.texture = preload("res://ui/klawisz.png")
	styl.set_texture_margin_all(3)
	styl.content_margin_left = 3
	styl.content_margin_right = 3
	styl.content_margin_bottom = 0
	_podpowiedz.add_theme_stylebox_override("panel", styl)
	_podpowiedz_tekst = _etykieta(16, Color8(40, 30, 30))
	_podpowiedz.add_child(_podpowiedz_tekst)
	_podpowiedz.visible = false
	ui.add_child(_podpowiedz)
	_zaslona = ColorRect.new()
	_zaslona.color = Color.BLACK
	_zaslona.size = Vector2(480, 270)
	_zaslona.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(_zaslona)
	_dialog = Dialog.new()
	add_child(_dialog)
	_poczatek(ui)


func _etykieta(rozmiar: int, kolor: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", kolor)
	return l


func _poczatek(ui: CanvasLayer) -> void:
	var miejsce := _etykieta(32, Color8(236, 226, 200))
	miejsce.text = "Foyer, 18:30"
	miejsce.position = Vector2(0, 110)
	miejsce.size = Vector2(480, 40)
	miejsce.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(miejsce)
	_antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_interval(1.4)
	tw.tween_property(miejsce, "modulate:a", 0.0, 0.8)
	tw.tween_property(_zaslona, "color:a", 0.0, 1.0)
	await tw.finished
	miejsce.queue_free()
	_antoni.sterowanie = true
	var pomoc := _etykieta(16, Color8(236, 226, 200))
	pomoc.text = "WASD – chodzenie    E – rozmowa    Tab – notes"
	pomoc.position = Vector2(8, 250)
	pomoc.add_theme_color_override("font_shadow_color", Color8(12, 8, 10))
	ui.add_child(pomoc)
	var znik := create_tween()
	znik.tween_interval(8.0)
	znik.tween_property(pomoc, "modulate:a", 0.0, 1.0)
	znik.tween_callback(pomoc.queue_free)


func _odleglosc(a: Vector2, b: Vector2) -> float:
	# z góry pod skosem pion jest skrócony, więc liczy się trochę mocniej
	return Vector2(a.x - b.x, (a.y - b.y) * 1.4).length()


func _process(_delta: float) -> void:
	_podpowiedz.visible = false
	if _koniec or _dialog.trwa() or not _antoni.sterowanie:
		return
	if not _ania_podsluchana and _odleglosc(_antoni.position, _ania.position) < 80.0:
		_podsluchaj_anie()
		return
	if _ania_podsluchana and DRZWI.grow(6).has_point(_antoni.position):
		_pokaz_podpowiedz("E  Drzwi służbowe", Vector2(DRZWI.get_center().x, DRZWI.position.y - 40))
		return
	var r = _najblizszy()
	if r:
		_pokaz_podpowiedz("E", r[0].position + Vector2(0, -74))


func _najblizszy() -> Variant:
	var naj: Variant = null
	var odl := ZASIEG
	for r in _rozmowcy:
		var d := _odleglosc(_antoni.position, r[0].position)
		if d < odl:
			odl = d
			naj = r
	return naj


func _pokaz_podpowiedz(tekst: String, swiat: Vector2) -> void:
	_podpowiedz_tekst.text = tekst
	_podpowiedz.reset_size()
	var ekran := get_viewport().get_canvas_transform() * swiat
	_podpowiedz.position = (ekran - Vector2(_podpowiedz.size.x / 2, 0)).round()
	_podpowiedz.visible = true


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo or k.physical_keycode != KEY_E:
		return
	if _koniec or _dialog.trwa() or not _antoni.sterowanie:
		return
	get_viewport().set_input_as_handled()
	if _ania_podsluchana and DRZWI.grow(6).has_point(_antoni.position):
		_za_kulisy()
		return
	var r = _najblizszy()
	if r:
		_rozmowa(r[0], r[1])


func _rozmowa(kto: Node2D, kwestie: Array) -> void:
	_antoni.sterowanie = false
	var dx: float = kto.position.x - _antoni.position.x
	var dy: float = kto.position.y - _antoni.position.y
	if absf(dx) > absf(dy):
		_antoni.stan("prawo" if dx > 0 else "lewo")
	else:
		_antoni.stan("dol" if dy > 0 else "gora")
	await _dialog.pokaz(kwestie)
	_antoni.sterowanie = true


func _podsluchaj_anie() -> void:
	_ania_podsluchana = true
	_antoni.sterowanie = false
	_antoni.stan("gora")
	await _dialog.pokaz([
		["Ania", "(do telefonu) Adrian, odezwij się, proszę. Cokolwiek się stało, przepraszam."],
		["Ania", "...Och. Nie zauważyłam pana. Przepraszam, muszę wracać za kulisy."],
	])
	# Ania znika za drzwiami służbowymi
	var tw := create_tween()
	tw.tween_property(_ania, "position", Vector2(214, 128), 0.8)
	tw.tween_property(_ania, "modulate:a", 0.0, 0.4)
	await tw.finished
	_ania.queue_free()
	await _dialog.pokaz([
		["Antoni", "Za co ona przeprasza? I komu?"],
		["Antoni", "Dobra. Najpierw toaleta, potem zagadki. Może tymi drzwiami?"],
	])
	Notatnik.dodaj("Dubler zaginął. Ania za coś przeprasza?")
	_antoni.sterowanie = true


func _za_kulisy() -> void:
	_koniec = true
	_antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	get_tree().change_scene_to_file(NASTEPNA_SCENA)
