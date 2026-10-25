class_name ScenaGry
extends Node2D
## Wspólna podstawa scen fabularnych na mapach: Antoni, okienko dialogu, podpowiedź "E"
## nad rozmówcą, wydarzenia uruchamiane po podejściu, wyjście do następnej sceny
## i plansza z miejscem i godziną na początku.
##
## Scena dziedziczy po tej klasie, w _ready() woła przygotuj($Mapa) i dodaje
## rozmówców (dodaj_rozmowce), wydarzenia (gdy_blisko), wyjście (ustaw_wyjscie)
## drzwi, którymi nie da się przejść (zamkniete_drzwi), i miejsca do przeszukania
## z przedmiotami (skrzynka).

const ZASIEG := 26.0  # jak blisko trzeba podejść, żeby porozmawiać

var antoni: CharacterBody2D
var dialog: Dialog
var obiekty: Node2D
var ui: CanvasLayer
var koniec := false

var _rozmowcy: Array = []  # [węzeł, kwestie albo Callable, napis przy E, wysokość podpowiedzi]
var _wydarzenia: Array = []  # [węzeł albo Vector2, odległość, Callable]
var _wyjscia: Array = []  # {obszar, napis, scena}
var _zamkniete: Array = []  # [prostokąt, napis, czy Antoni już z niego wyszedł]
var _podpowiedz: PanelContainer
var _podpowiedz_tekst: Label
var _zaslona: ColorRect
var _dymki: Array = []  # [węzeł, etykieta]
var _komunikat: Label


func przygotuj(mapa: Node) -> void:
	obiekty = mapa.get_node("Obiekty")
	antoni = obiekty.get_node("Antoni")
	ui = CanvasLayer.new()
	ui.layer = 10
	ui.scale = Gra.SKALA_UI
	add_child(ui)
	_podpowiedz = PanelContainer.new()
	var styl := StyleBoxTexture.new()
	styl.texture = preload("res://ui/klawisz.png")
	styl.set_texture_margin_all(3)
	styl.content_margin_left = 3
	styl.content_margin_right = 3
	styl.content_margin_bottom = 0
	_podpowiedz.add_theme_stylebox_override("panel", styl)
	_podpowiedz_tekst = etykieta(12, Color8(40, 30, 30))
	_podpowiedz.add_child(_podpowiedz_tekst)
	_podpowiedz.visible = false
	ui.add_child(_podpowiedz)
	_zaslona = ColorRect.new()
	_zaslona.color = Color.BLACK
	_zaslona.size = Vector2(480, 270)
	_zaslona.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(_zaslona)
	_komunikat = etykieta(12, Color8(236, 226, 200))
	_komunikat.position = Vector2(0, 6)
	_komunikat.size = Vector2(480, 20)
	_komunikat.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_komunikat.add_theme_constant_override("outline_size", 4)
	_komunikat.add_theme_color_override("font_outline_color", Color8(12, 8, 10))
	_komunikat.modulate.a = 0.0
	ui.add_child(_komunikat)
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
	var miejsce := etykieta(24, Color8(236, 226, 200))
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


## Szybkie rozjaśnienie bez planszy (powrót do miejsca, w którym już się było).
func rozjasnij() -> void:
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 0.0, 0.6)
	await tw.finished
	antoni.sterowanie = true


## Na kilka sekund pokazuje na dole listę klawiszy.
func pomoc_klawiszy() -> void:
	var pomoc := etykieta(12, Color8(236, 226, 200))
	pomoc.text = "WASD chodzenie  E rozmowa  I ekwipunek  Q telefon  Tab postać"
	if Notatnik.aktywny:
		pomoc.text += "  T notes"
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
## Napis to tekst obok "E" (pusty dla ludzi), wysokość: jak wysoko nad węzłem pokazać "E".
func dodaj_rozmowce(kto: Node2D, kwestie: Variant, napis := "", wysokosc := 74.0) -> void:
	for r in _rozmowcy:
		if r[0] == kto:
			r[1] = kwestie
			return
	_rozmowcy.append([kto, kwestie, napis, wysokosc])


## Miejsce do przeszukania pod E. Teksty są w Dialogi.SKRZYNKI[id], przedmioty
## (identyfikatory z Dialogi.PRZEDMIOTY) trafiają do ekwipunku przy pierwszym
## przeszukaniu. Rekwizyt to opcjonalny obrazek z rekwizyty/<nazwa>.png, stojący
## dolną krawędzią na punkcie miejsce (uniesienie przesuwa go w górę, np. na ścianę).
func skrzynka(miejsce: Vector2, id: String, przedmioty: Array, rekwizyt := "", uniesienie := 0.0) -> Node2D:
	var wezel: Node2D
	var wysokosc := 30.0
	if rekwizyt != "":
		var obraz := Sprite2D.new()
		obraz.texture = load("res://rekwizyty/%s.png" % rekwizyt)
		obraz.centered = false
		var rozmiar := obraz.texture.get_size()
		obraz.offset = Vector2(-rozmiar.x / 2.0, -rozmiar.y - uniesienie)
		wysokosc = rozmiar.y + uniesienie + 6.0
		wezel = obraz
	else:
		wezel = Node2D.new()
	wezel.name = "Skrzynka_" + id
	wezel.position = miejsce
	obiekty.add_child(wezel)
	var teksty: Array = Dialogi.SKRZYNKI[id]
	var stan := {"pelna": true}
	var przeszukaj := func() -> void:
		if not stan.pelna:
			await rozmowa([["", teksty[2]]])
			return
		stan.pelna = false
		await rozmowa([["", teksty[1]]])
		for p in przedmioty:
			Ekwipunek.dodaj(p)
	dodaj_rozmowce(wezel, przeszukaj, teksty[0], wysokosc)
	return wezel


## Obrazek z rekwizyty/<nazwa>.png postawiony dolną krawędzią na punkcie (bez interakcji).
func rekwizyt(nazwa: String, poz: Vector2, uniesienie := 0.0) -> Sprite2D:
	var obraz := Sprite2D.new()
	obraz.texture = load("res://rekwizyty/%s.png" % nazwa)
	obraz.centered = false
	var rozmiar := obraz.texture.get_size()
	obraz.offset = Vector2(-rozmiar.x / 2.0, -rozmiar.y - uniesienie)
	obraz.position = poz
	obiekty.add_child(obraz)
	return obraz


## Jednorazowe wydarzenie, gdy Antoni podejdzie na podaną odległość do węzła albo punktu.
func gdy_blisko(cel: Variant, odleglosc: float, co: Callable) -> void:
	_wydarzenia.append([cel, odleglosc, co])


## Prostokąt, w którym E przenosi do innej sceny. Wyjść może być kilka.
func ustaw_wyjscie(obszar: Rect2, napis: String, scena: String) -> void:
	for w in _wyjscia:
		if w.obszar == obszar:
			w.napis = napis
			w.scena = scena
			return
	_wyjscia.append({"obszar": obszar, "napis": napis, "scena": scena})


## Drzwi, przy których pokazuje się napis, że nie da się tam wejść.
## Jeśli w tym samym miejscu jest wyjście (ustaw_wyjscie), wygrywa wyjście.
## Ponowne wywołanie dla tego samego prostokąta zmienia tylko napis.
func zamkniete_drzwi(obszar: Rect2, napis: String) -> void:
	for z in _zamkniete:
		if z[0] == obszar:
			z[1] = napis
			return
	# gdy Antoni zaczyna scenę w drzwiach, napis pojawi się dopiero po powrocie
	_zamkniete.append([obszar, napis, not obszar.has_point(antoni.position)])


func odleglosc(a: Vector2, b: Vector2) -> float:
	# z góry pod skosem pion jest skrócony, więc liczy się trochę mocniej
	return Vector2(a.x - b.x, (a.y - b.y) * 1.4).length()


func wolny() -> bool:
	return not koniec and not dialog.trwa() and antoni.sterowanie and not Gra.okno_otwarte()


func _process(_delta: float) -> void:
	_podpowiedz.visible = false
	for para in _dymki:
		_ustaw_dymek(para)
	if not wolny():
		return
	for w in _wydarzenia:
		var poz: Vector2 = w[0] if w[0] is Vector2 else (w[0] as Node2D).position
		if odleglosc(antoni.position, poz) < w[1]:
			_wydarzenia.erase(w)
			w[2].call()
			return
	var w := _w_wyjsciu()
	if not w.is_empty():
		_pokaz_podpowiedz("E  " + w.napis, w.obszar.get_center() + Vector2(0, -50))
		return
	for z in _zamkniete:
		if not z[0].has_point(antoni.position):
			z[2] = true
		elif z[2]:
			_pokaz_podpowiedz(z[1], antoni.position + Vector2(0, -92))
			return
	var r = _najblizszy()
	if r:
		_pokaz_podpowiedz("E  " + r[2] if r[2] != "" else "E", r[0].position + Vector2(0, -r[3]))


func _w_wyjsciu() -> Dictionary:
	for w in _wyjscia:
		if w.obszar.has_point(antoni.position):
			return w
	return {}


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
	var ekran := ui.transform.affine_inverse() * (get_viewport().get_canvas_transform() * swiat)
	ekran.x = clampf(ekran.x, _podpowiedz.size.x / 2 + 2, 478 - _podpowiedz.size.x / 2)
	_podpowiedz.position = (ekran - Vector2(_podpowiedz.size.x / 2, 0)).round()
	_podpowiedz.visible = true


func _unhandled_input(zdarzenie: InputEvent) -> void:
	var k := zdarzenie as InputEventKey
	if not k or not k.pressed or k.echo or k.physical_keycode != KEY_E or not wolny():
		return
	get_viewport().set_input_as_handled()
	var w := _w_wyjsciu()
	if not w.is_empty():
		przejdz(w.scena)
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


# ---------- życie w tle ----------

## Miejsce do obejrzenia pod E, bez przedmiotów. Kwestie jak w dodaj_rozmowce.
func miejsce(poz: Vector2, napis: String, kwestie: Variant, wysokosc := 30.0) -> Node2D:
	var wezel := Node2D.new()
	wezel.position = poz
	obiekty.add_child(wezel)
	dodaj_rozmowce(wezel, kwestie, napis, wysokosc)
	return wezel


## Krótki napis u góry ekranu, który sam znika (głośnik, dzwonek, gwar). Gra toczy się dalej.
func komunikat(tekst: String, czas := 3.5) -> void:
	_komunikat.text = tekst
	var tw := create_tween()
	tw.tween_property(_komunikat, "modulate:a", 1.0, 0.3)
	tw.tween_interval(czas)
	tw.tween_property(_komunikat, "modulate:a", 0.0, 0.6)


## Mały napis nad głową postaci na kilka sekund (np. "mama, mema, mima").
func dymek(kto: Node2D, tekst: String, czas := 2.5) -> void:
	if not is_instance_valid(kto):
		return
	var l := etykieta(12, Color8(236, 226, 200))
	l.text = tekst
	l.add_theme_constant_override("outline_size", 4)
	l.add_theme_color_override("font_outline_color", Color8(12, 8, 10))
	ui.add_child(l)
	var para := [kto, l]
	_dymki.append(para)
	_ustaw_dymek(para)
	await get_tree().create_timer(czas).timeout
	_dymki.erase(para)
	l.queue_free()


## Co jakiś czas pokazuje nad postacią jeden z tekstów (gadanie w tle).
func gada_w_tle(kto: Node2D, teksty: Array, co_ile := 7.0) -> void:
	await get_tree().create_timer(randf_range(1.0, co_ile)).timeout
	while is_instance_valid(kto) and not koniec:
		if kto.visible and not dialog.trwa() and odleglosc(antoni.position, kto.position) < 260.0:
			dymek(kto, teksty.pick_random())
		await get_tree().create_timer(co_ile + randf_range(-1.5, 1.5)).timeout


func _ustaw_dymek(para: Array) -> void:
	var kto: Node2D = para[0]
	var l: Label = para[1]
	if not is_instance_valid(kto):
		l.visible = false
		return
	l.reset_size()
	var ekran := ui.transform.affine_inverse() * (get_viewport().get_canvas_transform() * (kto.position + Vector2(0, -80)))
	l.position = (ekran - Vector2(l.size.x / 2, 0)).round()
	l.visible = kto.visible and not dialog.trwa()


## Dźwięk z dzwieki/tlo/ (np. "gwar.ogg"). Pętla gra, dopóki trwa scena.
func dzwiek(plik: String, glosnosc_db := 0.0, petla := false) -> AudioStreamPlayer:
	var gracz := AudioStreamPlayer.new()
	var strumien: AudioStream = load("res://dzwieki/tlo/" + plik)
	if petla:
		strumien = strumien.duplicate()
		strumien.set("loop", true)
	gracz.stream = strumien
	gracz.volume_db = glosnosc_db
	add_child(gracz)
	gracz.play()
	if not petla:
		gracz.finished.connect(gracz.queue_free)
	return gracz


## Postać chodzi w kółko po punktach i chwilę stoi w każdym, lekko się kołysząc w marszu.
func spacer(kto: Node2D, punkty: Array, predkosc := 40.0, przerwa := 1.5) -> void:
	var i := 0
	var sprite: Node2D = kto.get_node_or_null("Sprite")
	while is_instance_valid(kto) and not koniec:
		var cel: Vector2 = punkty[i % punkty.size()]
		var czas := kto.position.distance_to(cel) / predkosc
		if czas > 0.05:
			var tw := create_tween()
			tw.tween_property(kto, "position", cel, czas)
			var krok: Tween = null
			if sprite:
				krok = create_tween().set_loops()
				krok.tween_property(sprite, "position:y", -1.0, 0.14)
				krok.tween_property(sprite, "position:y", 0.0, 0.14)
			await tw.finished
			if krok:
				krok.kill()
				sprite.position.y = 0.0
		await get_tree().create_timer(przerwa).timeout
		i += 1


## Błysk na cały ekran (flesz fotografa).
func blysk() -> void:
	dzwiek("flesz.wav", -6.0)
	await get_tree().create_timer(0.95).timeout
	var b := ColorRect.new()
	b.color = Color(1, 1, 0.95, 0.55)
	b.size = Vector2(480, 270)
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(b)
	var tw := create_tween()
	tw.tween_property(b, "color:a", 0.0, 0.35)
	tw.tween_callback(b.queue_free)


## Wybór w rozmowie: lista opcji na dole ekranu, zwraca numer wybranej.
func wybor(opcje: Array) -> int:
	antoni.sterowanie = false
	var lista := MenuLista.new()
	lista.position = Vector2(150, 232 - opcje.size() * 24)
	ui.add_child(lista)
	var stan := {"nr": -1}
	var pozycje := []
	for i in opcje.size():
		pozycje.append([opcje[i], func() -> void: stan.nr = i])
	lista.ustaw(pozycje)
	while stan.nr < 0:
		await get_tree().process_frame
	lista.queue_free()
	return stan.nr


func przejdz(scena: String) -> void:
	koniec = true
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	get_tree().change_scene_to_file(scena)
