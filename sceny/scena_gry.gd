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
const PODPOWIEDZ_PO := 120.0  # sekundy bez postępu, po których Antoni myśli na głos
const URAZA_PROG := 2  # tyle chybionych dowodów pod nos i rozmówca się obraża

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
var _trop: Label


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
	_trop = etykieta(12, Color8(242, 212, 126))
	_trop.text = Dialogi.NOWY_TROP
	_trop.position = Vector2(372, 246)
	_trop.size = Vector2(100, 20)
	_trop.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_trop.add_theme_constant_override("outline_size", 4)
	_trop.add_theme_color_override("font_outline_color", Color8(12, 8, 10))
	_trop.modulate.a = 0.0
	ui.add_child(_trop)
	dialog = Dialog.new()
	add_child(dialog)
	Gra.zapisz(scene_file_path)
	_podpowiedzi()
	_tropy()


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
	# retrospekcje dzieją się w przeszłości: nie ruszają licznika ani dziennika
	var teraz := not "/retrospekcje/" in scene_file_path
	var nowy_dzien := false
	if teraz:
		nowy_dzien = Gra.ustaw_dzien(tekst)
		Gra.zapamietaj_miejsce(tekst)
	if teraz and Gra.flagi.has("dni_do_pogrzebu"):
		var licznik := etykieta(12, Color8(200, 150, 140))
		licznik.text = Gra.do_pogrzebu()
		licznik.size = Vector2(480, 20)
		licznik.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		miejsce.add_child(licznik)
		licznik.position = Vector2(0, 40)
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_interval(1.4)
	tw.tween_property(miejsce, "modulate:a", 0.0, 0.8)
	tw.tween_property(_zaslona, "color:a", 0.0, 1.0)
	await tw.finished
	miejsce.queue_free()
	antoni.sterowanie = true
	if nowy_dzien:
		komunikat(Dialogi.DZIENNIK["komunikat"], 4.0)


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
		pomoc.text += "  T notes  F teczka"
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


## Postać idzie krokiem po kolei przez punkty (omija przeszkody, jeśli punkty są
## dobrane przez alejki). Kołysze się przy każdym kroku i obraca w stronę marszu.
func idz(kto: Node2D, punkty: Array, predkosc := 40.0) -> void:
	var sprite: Node2D = kto.get_node_or_null("Sprite")
	var krok: Tween = null
	if sprite:
		krok = create_tween().set_loops()
		krok.tween_property(sprite, "position:y", -1.0, 0.16)
		krok.tween_property(sprite, "position:y", 0.0, 0.16)
	for cel in punkty:
		if sprite is AnimatedSprite2D and absf(cel.x - kto.position.x) > 2.0:
			(sprite as AnimatedSprite2D).flip_h = cel.x < kto.position.x
		var czas := maxf(kto.position.distance_to(cel) / predkosc, 0.05)
		var tw := create_tween()
		tw.tween_property(kto, "position", cel, czas)
		await tw.finished
	if krok:
		krok.kill()
		sprite.position.y = 0.0


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


## Gdy gracz długo nie robi postępu (nowa flaga, przedmiot, karta, wpis w karcie),
## Antoni mówi na głos pierwszą niezałatwioną podpowiedź z Dialogi.PODPOWIEDZI[nazwa
## pliku sceny], a gdy takich nie ma, przypomina o pustych kartach w teczce.
func _podpowiedzi() -> void:
	var klucz := scene_file_path.get_file().get_basename()
	var lista: Array = Dialogi.PODPOWIEDZI.get(klucz, [])
	var drzewo := get_tree()
	var stan := _postep()
	var bezczynnie := 0.0
	while is_instance_valid(self) and not koniec:
		await drzewo.create_timer(1.0).timeout
		if not is_instance_valid(self) or koniec:
			return
		var teraz := _postep()
		if teraz != stan:
			stan = teraz
			bezczynnie = 0.0
			continue
		if not wolny() or not antoni.visible:
			continue
		bezczynnie += 1.0
		if bezczynnie < PODPOWIEDZ_PO:
			continue
		bezczynnie = 0.0
		var mysl := ""
		for p in lista:
			if not p[0].any(func(w): return Sledztwo.jest(w)):
				mysl = p[1]
				break
		if mysl == "" and Teczka.karty.keys().any(func(id): return not Teczka.sprawdzona(id)):
			mysl = Dialogi.PODPOWIEDZ_TECZKA
		if mysl != "":
			await rozmowa([["Antoni", mysl]])


## Liczba rzeczy, które gracz już ustalił (zmiana = postęp).
func _postep() -> int:
	var n := Gra.flagi.size() + Ekwipunek.przedmioty.size() * 100 + Teczka.karty.size() * 1000
	for id in Teczka.karty:
		if Teczka.sprawdzona(id):
			n += 10000
	return n


## "Nowy trop" w rogu ekranu z cichym akordem, gdy przybędzie argumentów albo kart.
## Nie mówi, co to znaczy: gracz tylko wie, że coś ważnego właśnie usłyszał.
func _tropy() -> void:
	var drzewo := get_tree()
	var ile := Gra.ile_tropow()
	while is_instance_valid(self) and not koniec:
		await drzewo.create_timer(0.5).timeout
		if not is_instance_valid(self) or koniec:
			return
		var teraz := Gra.ile_tropow()
		if teraz > ile:
			dzwiek("trop.wav", -8.0)
			var tw := create_tween()
			tw.tween_property(_trop, "modulate:a", 1.0, 0.3)
			tw.tween_interval(2.5)
			tw.tween_property(_trop, "modulate:a", 0.0, 0.8)
		ile = teraz


## Antoni znajduje albo dostaje pieniądze: dopisuje je i pokazuje napis u góry.
func znajdz_kase(ile: int) -> void:
	Gra.dodaj_kase(ile)
	komunikat("+%d zł  (masz %d zł)" % [ile, Gra.kasa], 3.0)


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
	# drzewo zapamiętane z góry: gdy scena się zmieni w trakcie wyboru, czekanie po prostu
	# się urywa, zamiast pytać o get_tree() węzła, którego już nie ma w drzewie
	var drzewo := get_tree()
	while stan.nr < 0:
		await drzewo.process_frame
	lista.queue_free()
	return stan.nr


## Okienko z polem tekstowym (PIN, szyfr, imię w retrospekcji). Zwraca wpisany tekst;
## pusty Enter albo Esc = rezygnacja ("").
func wpisz(opis: String, dlugosc := 20) -> String:
	antoni.sterowanie = false
	var tlo := ColorRect.new()
	tlo.color = Color(0.05, 0.05, 0.07, 0.92)
	tlo.position = Vector2(150, 90)
	tlo.size = Vector2(180, 70)
	ui.add_child(tlo)
	var napis := etykieta(12, Color(0.85, 0.9, 0.85))
	napis.text = opis
	napis.position = Vector2(10, 6)
	tlo.add_child(napis)
	var pole := LineEdit.new()
	pole.max_length = dlugosc
	pole.position = Vector2(10, 30)
	pole.size = Vector2(160, 30)
	tlo.add_child(pole)
	pole.grab_focus()
	var wynik := {"tekst": null}
	pole.text_submitted.connect(func(tekst: String) -> void: wynik.tekst = tekst.strip_edges())
	var drzewo := get_tree()
	while wynik.tekst == null:
		if Input.is_key_pressed(KEY_ESCAPE):
			wynik.tekst = ""
		await drzewo.process_frame
	tlo.queue_free()
	antoni.sterowanie = true
	return wynik.tekst


## Temat rozmowy, który zapamiętuje, że gracz o to zapytał (flaga dla Sledztwo).
func temat(flaga: String, kwestie: Array) -> Callable:
	return func() -> void:
		await rozmowa(kwestie)
		Gra.flagi[flaga] = true


## Rozmowa jak przesłuchanie: gracz sam wybiera tematy i może pokazać dowód.
## tematy: lista [napis, kwestie albo Callable, warunek (Callable -> bool) albo null].
## dowody: id -> kwestie albo Callable (karty z teczki mają id "karta_<id>").
## Temat bez spełnionego warunku się nie pokazuje (np. pytanie o pasy dopiero, gdy
## Antoni je zobaczył). dowody: id przedmiotu albo karty -> kwestie, reszta dostaje
## kwestie nic_nie_wiem. Po każdym temacie lista wraca, aż gracz wybierze "Nic więcej".
func przesluchanie(tematy: Array, dowody: Dictionary, nic_nie_wiem: Array, pozegnanie: Array = []) -> void:
	var kto: String = nic_nie_wiem[0][0] if not nic_nie_wiem.is_empty() else ""
	if kto in ["", "Antoni"]:
		kto = ""
	if kto != "" and Gra.obrazony(kto):
		await rozmowa(_uraza_tekst("zimno", kto))
	while true:
		var obrazony := kto != "" and Gra.obrazony(kto)
		# obrażony rozmówca nie odpowiada na pytania, dopóki Antoni nie przeprosi;
		# dowody działają dalej, bo na twarde fakty trzeba zareagować
		var widoczne := [] if obrazony else tematy.filter(func(t): return t.size() < 3 or t[2] == null or t[2].call())
		var napisy: Array = widoczne.map(func(t): return t[0])
		if obrazony:
			napisy.append(Dialogi.URAZA["przepros"])
		napisy.append_array(["Pokaż dowód", "Nic więcej"])
		var nr := await wybor(napisy)
		if nr == napisy.size() - 1:
			if not pozegnanie.is_empty():
				await rozmowa(pozegnanie)
			antoni.sterowanie = true
			return
		if nr == napisy.size() - 2:
			var id := await wybierz_dowod()
			if id != "":
				var reakcja = dowody.get(id, nic_nie_wiem)
				# dowód, który tej osobie nic nie mówi, albo fałszywy trop: mija trochę czasu,
				# a podsuwanie ludziom pod nos dowodów, które ich nie dotyczą, to insynuacja
				if not dowody.has(id):
					Sledztwo.strata(5)
				if id in Dialogi.FALSZYWE_TROPY:
					Sledztwo.strata(10)
				Gra.flagi["pokazal_" + id] = true
				if not dowody.has(id) and kto != "" and not Gra.obrazony(kto):
					await rozmowa(reakcja)
					await _urazony(kto)
					continue
				if reakcja is Callable:
					# reakcja zwracająca true kończy rozmowę (np. rozmówca wychodzi)
					var wynik = await reakcja.call()
					if wynik is bool and wynik:
						antoni.sterowanie = true
						return
				else:
					await rozmowa(reakcja)
			continue
		if obrazony and nr == 0:
			await rozmowa(_uraza_tekst("przeprosiny", kto))
			Sledztwo.strata(20)
			Gra.przepros(kto)
			continue
		var co = widoczne[nr][1]
		if co is Callable:
			# temat zwracający true kończy rozmowę (rozmówca wyrzuca Antoniego)
			var wynik = await co.call()
			if wynik is bool and wynik:
				antoni.sterowanie = true
				return
		else:
			await rozmowa(co)


## Chybiony dowód: pierwszy raz rozmówca się krzywi, za URAZA_PROG razem się obraża.
func _urazony(kto: String) -> void:
	var ile := Gra.uraz(kto)
	if ile >= URAZA_PROG:
		await rozmowa(_uraza_tekst("obraza", kto))
	else:
		await rozmowa(_uraza_tekst("ostrzezenie", kto))


func _uraza_tekst(klucz: String, kto: String) -> Array:
	var wiersze: Array = Dialogi.URAZA[klucz]
	var w: Array = wiersze[Gra.flagi.get("uraza_" + kto, 0) % wiersze.size()]
	return w.map(func(linia): return [kto if linia[0] == "*" else linia[0], linia[1]])


## Lista dowodów do pokazania: przedmioty fabularne i sprawdzone karty z teczki
## (najnowsze, żeby lista zmieściła się na ekranie). Zwraca id albo "" (wróć).
func wybierz_dowod() -> String:
	var ids: Array = []
	for id in Ekwipunek.przedmioty:
		if Dialogi.PRZEDMIOTY[id][2] == "fabularny":
			ids.append(id)
	for id in Teczka.karty:
		if Teczka.sprawdzona(id):
			ids.append("karta_" + id)
	ids = ids.slice(maxi(0, ids.size() - 7))
	var napisy: Array = ids.map(func(id): return ("Karta: " + Dialogi.KARTY[id.substr(6)][0]) if id.begins_with("karta_") else Dialogi.PRZEDMIOTY[id][0])
	napisy.append("Wróć")
	var nr := await wybor(napisy)
	return ids[nr] if nr < ids.size() else ""


## Lista argumentów (Sledztwo.argumenty) po 6 na stronę. Zwraca id albo "".
func wybierz_argument(pytanie: String, rezygnacja: String) -> String:
	var ids: Array = Sledztwo.argumenty()
	var strona := 0
	komunikat(pytanie, 2.5)
	while true:
		var kawalek: Array = ids.slice(strona * 6, strona * 6 + 6)
		var napisy: Array = kawalek.map(func(id): return Dialogi.ARGUMENTY_NAZWY.get(id, id))
		var wiecej := ids.size() > 6
		if wiecej:
			napisy.append("Więcej...")
		napisy.append(rezygnacja)
		var nr := await wybor(napisy)
		if nr < kawalek.size():
			return kawalek[nr]
		if wiecej and nr == kawalek.size():
			strona = (strona + 1) % ceili(ids.size() / 6.0)
			continue
		return ""
	return ""


func przejdz(scena: String) -> void:
	koniec = true
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	get_tree().change_scene_to_file(scena)
