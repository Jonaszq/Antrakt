extends ScenaGry
## Scena 8 (koniec rozdziału 2): plac przed magazynem, niedziela 1:10. Gracz cały
## czas steruje Antonim. Podjeżdża taksówka z Anią i Wolskim. Ania kłamie, że ostatnio
## rozmawiała z Adrianem w czwartek (wyjdzie w scenie 17). Wolski daje herbatę (+10 sił).
## Taksówkarz pamięta, że wiózł Wolskiego pod blok Ani już przed północą; w jego aucie
## można podładować telefon Adriana (ładowarka od Zenona). Nowicki spisuje dane
## i odjeżdża, kiedy gracz uzna, że skończył; potem Antoni wsiada do swojego auta.
## Wolski prosi o telefon Adriana: oddany przepada na resztę gry (Sledztwo).
## Teksty w Dialogi.SCENA8.

const NASTEPNA := "res://sceny/scena9/scena9.tscn"
const POSTOJ := Vector2(470, 384)  # gdzie staje taksówka (środek dołu obrazka)

var _ania: Node2D
var _wolski: Node2D
var _kierowca: Node2D
var _nowicki: Node2D
var _taksowka: Sprite2D
var _latarnia: PointLight2D
var _sila_latarni := 1.0
var _nowicki_pojechal := false


func _ready() -> void:
	przygotuj($Plac)
	Telefon.godzina = "1:10"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA8
	var tlo: Dictionary = Dialogi.SCENA8_TLO
	antoni.position = Vector2(260, 200)
	antoni.stan("dol")
	_latarnia = $Plac/Swiatla.get_child(2)
	_sila_latarni = _latarnia.energy
	_nowicki = postac("nowicki", Vector2(206, 352))
	dodaj_rozmowce(_nowicki, _rozmowa_z_nowickim)
	gada_w_tle(_nowicki, tlo["nowicki"], 11.0)
	var zenon := postac("zenon", Vector2(664, 132))
	dodaj_rozmowce(zenon, [["Zenon", "Ja tu postoję. W budce nie mogę usiedzieć."]])
	gada_w_tle(zenon, tlo["zenon"], 13.0)
	miejsce(Vector2(245, 112), "Brama", t["brama"], 40.0)
	miejsce(Vector2(130, 330), "Radiowóz", t["radiowoz"], 40.0)
	miejsce(Vector2(300, 254), "Kałuża", t["kaluza"], 16.0)
	miejsce(Vector2(420, 292), "Latarnia", t["latarnia"], 60.0)
	miejsce(Vector2(745, 112), "Kiosk", t["kiosk"], 40.0)
	miejsce(Vector2(692, 384), "Twoje auto", _auto, 40.0)
	dzwiek("magazyn.ogg", -20.0, true)
	await plansza("Plac przed magazynem, 1:10")
	await rozmowa(t["start"])
	await get_tree().create_timer(6.0).timeout
	await _przyjazd()


## Latarnia na placu mruga.
func _process(_delta: float) -> void:
	if _latarnia:
		_latarnia.energy = _sila_latarni * (0.15 if randf() < 0.04 else 1.0)


## Taksówka wjeżdża z prawej, wysiadają Ania i Wolski, kierowca staje przy drzwiach.
func _przyjazd() -> void:
	komunikat(Dialogi.SCENA8["taksowka"], 2.5)
	_taksowka = rekwizyt("taksowka", Vector2(900, POSTOJ.y))
	var silnik := dzwiek("auto.ogg", -18.0, true)
	var tw := create_tween()
	tw.tween_property(_taksowka, "position", POSTOJ, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tw.finished
	if silnik:
		silnik.volume_db = -26.0  # silnik chodzi dalej, licznik bije
	_blokada(_taksowka, Rect2(-50, -14, 100, 14))
	var tlo: Dictionary = Dialogi.SCENA8_TLO
	_wolski = postac("wolski", POSTOJ + Vector2(-20, 4))
	_ania = postac("ania", POSTOJ + Vector2(-30, 6))
	_kierowca = postac("maszynista", POSTOJ + Vector2(40, 6))
	idz(_ania, [Vector2(396, 410)], 30.0)
	idz(_kierowca, [Vector2(556, 410)], 20.0)
	await idz(_wolski, [Vector2(424, 414)], 30.0)
	dodaj_rozmowce(_ania, _rozmowa_z_ania)
	dodaj_rozmowce(_wolski, _rozmowa_z_wolskim)
	dodaj_rozmowce(_kierowca, _rozmowa_z_kierowca)
	gada_w_tle(_ania, tlo["ania"], 9.0)
	gada_w_tle(_wolski, tlo["wolski"], 12.0)
	gada_w_tle(_kierowca, tlo["taksowkarz"], 15.0)


## Niewidoczna przeszkoda w miejscu, gdzie stoi auto (względem jego pozycji).
func _blokada(kto: Node2D, obszar: Rect2) -> void:
	var cialo := StaticBody2D.new()
	var ksztalt := CollisionShape2D.new()
	var prost := RectangleShape2D.new()
	prost.size = obszar.size
	ksztalt.shape = prost
	ksztalt.position = obszar.position + obszar.size / 2.0
	cialo.add_child(ksztalt)
	kto.add_child(cialo)


func _rozmowa_z_ania() -> void:
	var t: Dictionary = Dialogi.SCENA8
	if not Gra.flagi.get("s8_ania", false):
		Gra.flagi["s8_ania"] = true
		await rozmowa(t["ania_start"])
	var tematy := [
		["Kiedy ostatnio z nim rozmawiała?", func() -> void:
			await rozmowa(t["ania_kiedy"])
			Gra.flagi["s8_czwartek"] = true],
		["Wiedziała, że pojechał do magazynu?", t["ania_magazyn"]],
		["Jak się pani trzyma?", t["ania_jak"]],
	]
	await przesluchanie(tematy, Dialogi.SCENA8_DOWODY["ania"], t["ania_nic"], t["ania_koniec"])


func _rozmowa_z_wolskim() -> void:
	var t: Dictionary = Dialogi.SCENA8
	if not Gra.flagi.get("s8_herbata", false):
		Gra.flagi["s8_herbata"] = true
		await rozmowa(t["wolski_start"])
	var tematy := [
		["Skąd pan wiedział?", temat("s8_wolski_ania_dzwonila", t["wolski_tu"])],
		["Dobrze pan znał Adriana?", t["wolski_adrian"]],
		["Co teraz z Anią?", t["wolski_ania"]],
	]
	var dowody: Dictionary = Dialogi.SCENA8_DOWODY["wolski"].duplicate()
	dowody["telefon_adriana"] = _wolski_chce_telefon
	await przesluchanie(tematy, dowody, t["wolski_nic"], t["wolski_koniec"])


## Wolski prosi o telefon Adriana. Oddany telefon przepada (nie będzie SMS-a w rozdz. 4).
func _wolski_chce_telefon() -> void:
	var t: Dictionary = Dialogi.SCENA8
	if Gra.flagi.get("s8_telefon_zatrzymal", false):
		await rozmowa(t["wolski_telefon_potem"])
		return
	await rozmowa(t["wolski_telefon"])
	var w := await wybor(Dialogi.SCENA8_TELEFON_WYBOR)
	if w == 0:
		await rozmowa(t["wolski_telefon_oddal"])
		Ekwipunek.usun("telefon_adriana")
		Gra.flagi["s8_telefon_wolski"] = true
	else:
		await rozmowa(t["wolski_telefon_nie"])
		Gra.flagi["s8_telefon_zatrzymal"] = true


func _rozmowa_z_kierowca() -> void:
	var t: Dictionary = Dialogi.SCENA8
	if not Gra.flagi.get("s8_taksowkarz", false):
		Gra.flagi["s8_taksowkarz"] = true
		await rozmowa(t["taksowkarz_start"])
	var tematy := [
		["Skąd ich pan wiózł?", func() -> void:
			await rozmowa(t["taksowkarz_skad"])
			Gra.flagi["s8_kurs"] = true],
		["Długo pan będzie czekał?", t["taksowkarz_czeka"]],
	]
	await przesluchanie(tematy, {"telefon_adriana": _gniazdko}, t["taksowkarz_nic"], t["taksowkarz_koniec"])


## Telefon Adriana w gniazdku zapalniczki: tylko z ładowarką od Zenona.
func _gniazdko() -> void:
	var t: Dictionary = Dialogi.SCENA8
	if Gra.flagi.get("s8_telefon", false):
		await rozmowa(t["gniazdko_potem"])
	elif Ekwipunek.ma("ladowarka"):
		await rozmowa(t["gniazdko"])
		Gra.flagi["s8_telefon"] = true
	else:
		await rozmowa(t["gniazdko_bez"])


func _rozmowa_z_nowickim() -> void:
	if _nowicki_pojechal:
		return
	await rozmowa(Dialogi.SCENA8["nowicki"])
	if _taksowka == null or _ania == null:
		return
	var w := await wybor(Dialogi.SCENA8_WYBOR)
	antoni.sterowanie = true
	if w == 0:
		await _odjazd()


## Nowicki spisuje Anię i Wolskiego, potem odjeżdżają radiowóz i taksówka.
func _odjazd() -> void:
	antoni.sterowanie = false
	await idz(_nowicki, [Vector2(370, 410)], 40.0)
	await rozmowa(Dialogi.SCENA8["nowicki_jedziemy"])
	_nowicki_pojechal = true
	for kto in [_ania, _wolski, _kierowca]:
		idz(kto, [POSTOJ + Vector2(0, -4)], 30.0)
	await idz(_nowicki, [Vector2(206, 352)], 40.0)
	for kto in [_ania, _wolski, _kierowca, _nowicki]:
		kto.queue_free()
	_ania = null
	var radiowoz: Node2D = obiekty.get_node("radiowoz")
	var tw := create_tween().set_parallel()
	tw.tween_property(radiowoz, "position:x", -200.0, 3.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(_taksowka, "position:x", 1000.0, 3.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(0.8)
	await tw.finished
	_taksowka.queue_free()
	antoni.sterowanie = true


func _auto() -> void:
	var t: Dictionary = Dialogi.SCENA8
	if not _nowicki_pojechal:
		await rozmowa(t["auto"])
		return
	await rozmowa(t["auto_jedz"])
	antoni.sterowanie = false
	koniec = true
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.2)
	await tw.finished
	var n: Dictionary = Dialogi.SCENA8_NAPISY
	await _napis(n["koniec"], 24, Color8(236, 226, 200), 96, 2.4)
	await _napis(n["godzina"], 12, Color8(170, 160, 140), 116, 2.4)
	await _napis(n["dalej"], 12, Color8(170, 160, 140), 124, 3.0)
	get_tree().change_scene_to_file(NASTEPNA)


func _napis(tekst: String, rozmiar: int, kolor: Color, y: float, czas: float) -> void:
	var l := etykieta(rozmiar, kolor)
	l.text = tekst
	l.position = Vector2(0, y)
	l.size = Vector2(480, 40)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.modulate.a = 0.0
	ui.add_child(l)
	var tw := create_tween()
	tw.tween_property(l, "modulate:a", 1.0, 0.8)
	tw.tween_interval(czas)
	tw.tween_property(l, "modulate:a", 0.0, 0.8)
	await tw.finished
	l.queue_free()
