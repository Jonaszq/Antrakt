class_name ScenaGry
extends Node2D
## Wspólna podstawa scen fabularnych na mapach: Antoni, okienko dialogu, podpowiedź "E"
## nad rozmówcą, wydarzenia uruchamiane po podejściu, wyjście do następnej sceny
## i plansza z miejscem i godziną na początku.
##
## Scena dziedziczy po tej klasie, w _ready() woła przygotuj($Mapa) i dodaje
## rozmówców (dodaj_rozmowce), wydarzenia (gdy_blisko) i wyjście (ustaw_wyjscie).

const ZASIEG := 26.0  # jak blisko trzeba podejść, żeby porozmawiać

var antoni: CharacterBody2D
var dialog: Dialog
var obiekty: Node2D
var ui: CanvasLayer
var koniec := false

var _rozmowcy: Array = []  # [węzeł, kwestie albo Callable]
var _wydarzenia: Array = []  # [węzeł albo Vector2, odległość, Callable]
var _wyjscie := {}
var _podpowiedz: PanelContainer
var _podpowiedz_tekst: Label
var _zaslona: ColorRect


func przygotuj(mapa: Node) -> void:
	obiekty = mapa.get_node("Obiekty")
	antoni = obiekty.get_node("Antoni")
	ui = CanvasLayer.new()
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
	_podpowiedz_tekst = etykieta(16, Color8(40, 30, 30))
	_podpowiedz.add_child(_podpowiedz_tekst)
	_podpowiedz.visible = false
	ui.add_child(_podpowiedz)
	_zaslona = ColorRect.new()
	_zaslona.color = Color.BLACK
	_zaslona.size = Vector2(480, 270)
	_zaslona.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(_zaslona)
	dialog = Dialog.new()
	add_child(dialog)


func etykieta(rozmiar: int, kolor: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", rozmiar)
	l.add_theme_color_override("font_color", kolor)
	l.add_theme_color_override("font_shadow_color", Color8(12, 8, 10, 160))
	return l


## Czarna plansza z miejscem i godziną, potem rozjaśnienie. Antoni czeka.
func plansza(tekst: String) -> void:
	var miejsce := etykieta(32, Color8(236, 226, 200))
	miejsce.text = tekst
	miejsce.position = Vector2(0, 110)
	miejsce.size = Vector2(480, 40)
	miejsce.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(miejsce)
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_interval(1.4)
	tw.tween_property(miejsce, "modulate:a", 0.0, 0.8)
	tw.tween_property(_zaslona, "color:a", 0.0, 1.0)
	await tw.finished
	miejsce.queue_free()
	antoni.sterowanie = true


## Na kilka sekund pokazuje na dole listę klawiszy.
func pomoc_klawiszy() -> void:
	var pomoc := etykieta(16, Color8(236, 226, 200))
	pomoc.text = "WASD chodzenie  E rozmowa  T notes  Q telefon  Tab postać"
	pomoc.position = Vector2(8, 250)
	ui.add_child(pomoc)
	var znik := create_tween()
	znik.tween_interval(8.0)
	znik.tween_property(pomoc, "modulate:a", 0.0, 1.0)
	znik.tween_callback(pomoc.queue_free)


## Wstawia postać z postacie/<plik>/ na mapę.
func postac(plik: String, poz: Vector2) -> Node2D:
	var p: Node2D = load("res://postacie/%s/%s.tscn" % [plik, plik]).instantiate()
	p.position = poz
	obiekty.add_child(p)
	return p


## Postać, z którą można pogadać pod E. Kwestie to lista [kto, tekst] albo funkcja.
func dodaj_rozmowce(kto: Node2D, kwestie: Variant) -> void:
	for r in _rozmowcy:
		if r[0] == kto:
			r[1] = kwestie
			return
	_rozmowcy.append([kto, kwestie])


## Jednorazowe wydarzenie, gdy Antoni podejdzie na podaną odległość do węzła albo punktu.
func gdy_blisko(cel: Variant, odleglosc: float, co: Callable) -> void:
	_wydarzenia.append([cel, odleglosc, co])


## Prostokąt, w którym E przenosi do następnej sceny.
func ustaw_wyjscie(obszar: Rect2, napis: String, scena: String) -> void:
	_wyjscie = {"obszar": obszar, "napis": napis, "scena": scena}


func odleglosc(a: Vector2, b: Vector2) -> float:
	# z góry pod skosem pion jest skrócony, więc liczy się trochę mocniej
	return Vector2(a.x - b.x, (a.y - b.y) * 1.4).length()


func wolny() -> bool:
	return not koniec and not dialog.trwa() and antoni.sterowanie and not Gra.okno_otwarte()


func _process(_delta: float) -> void:
	_podpowiedz.visible = false
	if not wolny():
		return
	for w in _wydarzenia:
		var poz: Vector2 = w[0] if w[0] is Vector2 else (w[0] as Node2D).position
		if odleglosc(antoni.position, poz) < w[1]:
			_wydarzenia.erase(w)
			w[2].call()
			return
	if _w_wyjsciu():
		_pokaz_podpowiedz("E  " + _wyjscie.napis, _wyjscie.obszar.get_center() + Vector2(0, -50))
		return
	var r = _najblizszy()
	if r:
		_pokaz_podpowiedz("E", r[0].position + Vector2(0, -74))


func _w_wyjsciu() -> bool:
	return not _wyjscie.is_empty() and _wyjscie.obszar.has_point(antoni.position)


func _najblizszy() -> Variant:
	var naj: Variant = null
	var odl := ZASIEG
	for r in _rozmowcy:
		if not is_instance_valid(r[0]):
			continue
		var d := odleglosc(antoni.position, r[0].position)
		if d < odl:
			odl = d
			naj = r
	return naj


func _pokaz_podpowiedz(tekst: String, swiat: Vector2) -> void:
	_podpowiedz_tekst.text = tekst
	_podpowiedz.reset_size()
	var ekran := get_viewport().get_canvas_transform() * swiat
	ekran.x = clampf(ekran.x, _podpowiedz.size.x / 2 + 2, 478 - _podpowiedz.size.x / 2)
	_podpowiedz.position = (ekran - Vector2(_podpowiedz.size.x / 2, 0)).round()
	_podpowiedz.visible = true


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo or k.physical_keycode != KEY_E or not wolny():
		return
	get_viewport().set_input_as_handled()
	if _w_wyjsciu():
		przejdz(_wyjscie.scena)
		return
	var r = _najblizszy()
	if r:
		zwroc_sie(r[0])
		if r[1] is Callable:
			r[1].call()
		else:
			rozmowa(r[1])


## Antoni odwraca się w stronę postaci.
func zwroc_sie(kto: Node2D) -> void:
	var dx: float = kto.position.x - antoni.position.x
	var dy: float = kto.position.y - antoni.position.y
	if absf(dx) > absf(dy):
		antoni.stan("prawo" if dx > 0 else "lewo")
	else:
		antoni.stan("dol" if dy > 0 else "gora")


## Rozmowa, podczas której Antoni stoi.
func rozmowa(kwestie: Array) -> void:
	antoni.sterowanie = false
	await dialog.pokaz(kwestie)
	antoni.sterowanie = true


## Postać idzie do punktu (bez animacji chodu, NPC mają tylko oddech).
func przesun(kto: Node2D, cel: Vector2, czas: float) -> void:
	var tw := create_tween()
	tw.tween_property(kto, "position", cel, czas)
	await tw.finished


func przejdz(scena: String) -> void:
	koniec = true
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	get_tree().change_scene_to_file(scena)
