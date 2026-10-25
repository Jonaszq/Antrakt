extends ScenaGry
## Scena 6 (rozdział 2): magazyn dekoracji, niedziela 0:15. W hali palą się tylko
## dwie żarówki. Lekarz pogotowia stwierdza zawał, komisarz Nowicki daje Antoniemu
## kwadrans na rozejrzenie się. Antoni zaczyna bez latarni (Tab jej nie pozwala
## wybrać), latarka leży w skrzynce z rekwizytami przy bramie. Z latarką może
## znaleźć: czerwone pasy na ramionach Adriana (zdjęcie), telefon Adriana pod
## manekinem, który sam się przewraca, i listę rekwizytów z dopiskiem Adriana.
## Po kwadransie (albo gdy Antoni powie Nowickiemu, że skończył) ciało jest
## zabierane i brama prowadzi dalej. W tle deszcz o dach, kapanie, blacha na
## wietrze, szczury i flesz policjanta. Teksty w Dialogi.SCENA6.

const NASTEPNA := "res://menu/menu.tscn"  # scena 7 (budka stróża) jeszcze nie zrobiona
const BRAMA := Rect2(430, 556, 100, 40)
const MINUT := 15
const SEKUND_NA_MINUTE := 32.0  # kwadrans gry to ok. 8 minut naprawdę
const CIALO := Vector2(785, 428)

var _start_zegara := -1.0
var _zostalo := MINUT
var _konczy := false
var _zegar: Label
var _cialo: Sprite2D
var _lekarz: Node2D
var _policjant: Node2D
var _nowicki: Node2D
var _lis: Node2D
var _manekin: Sprite2D
var _flesz: PointLight2D


func _ready() -> void:
	przygotuj($Magazyn)
	Telefon.godzina = "0:15"
	Notatnik.wlacz()
	# Antoni zaczyna bez latarni, musi ją znaleźć
	Gra.latarnia_dostepna = false
	Gra.ustaw_latarnie(false)
	var t: Dictionary = Dialogi.SCENA6
	var tlo: Dictionary = Dialogi.SCENA6_TLO
	antoni.position = Vector2(480, 548)
	antoni.stan("gora")
	_cialo = rekwizyt("cialo_adriana", CIALO)
	dodaj_rozmowce(_cialo, _ogledz_cialo, "Adrian", 26.0)
	_lekarz = postac("lekarz", Vector2(838, 466))
	dodaj_rozmowce(_lekarz, _kolejne("lekarz"))
	gada_w_tle(_lekarz, tlo["lekarz"], 11.0)
	_policjant = postac("policjant", Vector2(700, 468))
	dodaj_rozmowce(_policjant, _kolejne("policjant"))
	gada_w_tle(_policjant, tlo["policjant"], 9.0)
	spacer(_policjant, [Vector2(700, 468), Vector2(790, 494), Vector2(720, 500)], 22.0, 4.0)
	_lis = postac("bogdan", Vector2(626, 526))
	dodaj_rozmowce(_lis, _kolejne("lis"))
	gada_w_tle(_lis, tlo["lis"], 12.0)
	_nowicki = postac("nowicki", Vector2(480, 640))
	_nowicki.visible = false
	_manekin = obiekty.get_node("manekin_upadek")
	# latarka w skrzynce z rekwizytami przy bramie
	miejsce(Vector2(353, 502), "Skrzynka z rekwizytami", _wez_latarke)
	# ślady i miejsca do obejrzenia (w ciemnych kątach tylko z latarką)
	miejsce(Vector2(714, 270), "Stolik", _ciemno_albo(_lista))
	miejsce(Vector2(772, 266), "Salon z lat 30.", _ciemno_albo(_kolejne("salon")))
	miejsce(Vector2(845, 414), "Przewrócona skrzynka", t["skrzynia_przewrocona"])
	miejsce(Vector2(100, 214), "Zamek", _ciemno_albo(_kolejne("zamek")))
	miejsce(Vector2(850, 214), "Statek", _ciemno_albo(_kolejne("statek")))
	miejsce(Vector2(378, 300), "Regały", _ciemno_albo(_kolejne("regaly")))
	miejsce(Vector2(520, 238), "Wiadro", t["wiadro"])
	gdy_blisko(Vector2(157, 482), 70.0, _manekin_upada)
	zamkniete_drzwi(BRAMA, Dialogi.DRZWI["magazyn_brama"])
	_flesz = PointLight2D.new()
	_flesz.texture = antoni.get_node("Swiatlo").texture
	_flesz.color = Color(0.85, 0.9, 1.0)
	_flesz.energy = 0.0
	_flesz.texture_scale = 1.6
	obiekty.add_child(_flesz)
	_zegar = etykieta(12, Color8(236, 226, 200))
	_zegar.position = Vector2(300, 24)
	_zegar.size = Vector2(172, 20)
	_zegar.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_zegar.add_theme_constant_override("outline_size", 4)
	_zegar.add_theme_color_override("font_outline_color", Color8(12, 8, 10))
	_zegar.visible = false
	ui.add_child(_zegar)
	dzwiek("magazyn.ogg", -6.0, true)
	await plansza("Magazyn dekoracji, 0:15")
	await rozmowa(t["poczatek"])
	await _wstep()
	pomoc_klawiszy()
	_start_zegara = Time.get_ticks_msec() / 1000.0
	_zegar.visible = true
	_tlo_flesz()
	_tlo_szczury()
	_tlo_blacha()


## Kamera jedzie do ciała, lekarz mówi swoje, potem bramą wchodzi Nowicki.
func _wstep() -> void:
	antoni.sterowanie = false
	var kamera := Camera2D.new()
	kamera.limit_right = 960
	kamera.limit_bottom = 600
	kamera.global_position = antoni.get_node("Kamera").get_screen_center_position()
	obiekty.add_child(kamera)
	kamera.make_current()
	var tw := create_tween()
	tw.tween_property(kamera, "global_position", CIALO + Vector2(0, -20), 2.0).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await _blysk_policjanta()
	await dialog.pokaz(Dialogi.SCENA6["lekarz_przy_ciele"])
	tw = create_tween()
	tw.tween_property(kamera, "global_position", antoni.position + Vector2(0, -30), 1.4).set_trans(Tween.TRANS_SINE)
	await tw.finished
	antoni.get_node("Kamera").make_current()
	kamera.queue_free()
	_nowicki.visible = true
	antoni.stan("dol")
	await przesun(_nowicki, Vector2(500, 584), 1.6)
	await dialog.pokaz(Dialogi.SCENA6["nowicki_wchodzi"])
	await przesun(_nowicki, Vector2(560, 500), 1.4)
	dodaj_rozmowce(_nowicki, _rozmowa_z_nowickim)
	gada_w_tle(_nowicki, Dialogi.SCENA6_TLO["nowicki"], 13.0)
	antoni.sterowanie = true


func _process(delta: float) -> void:
	super(delta)
	if _start_zegara < 0.0 or _konczy:
		return
	var minelo := int((Time.get_ticks_msec() / 1000.0 - _start_zegara) / SEKUND_NA_MINUTE)
	var zostalo := maxi(0, MINUT - minelo)
	if zostalo != _zostalo or not _zegar.text:
		_zostalo = zostalo
		_zegar.text = Dialogi.SCENA6_NAPISY["zegar"] % zostalo
		Telefon.godzina = "0:%02d" % (15 + minelo)
		if zostalo == 3:
			dymek(_nowicki, "Trzy minuty, Antek!", 3.0)
	if zostalo == 0 and wolny():
		_zakoncz()


## Pierwsza rozmowa z kwestii "<kto>", każda kolejna z "<kto>_potem" (jeśli jest).
func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		var klucz := kto if stan.pierwsza or not Dialogi.SCENA6.has(kto + "_potem") else kto + "_potem"
		await rozmowa(Dialogi.SCENA6[klucz])
		stan.pierwsza = false


## Bez latarni Antoni mówi, że jest za ciemno, z latarnią robi swoje.
func _ciemno_albo(co: Callable) -> Callable:
	return func() -> void:
		if Gra.latarnia:
			await co.call()
		else:
			await rozmowa(Dialogi.SCENA6["ciemno"])


func _wez_latarke() -> void:
	if Gra.latarnia_dostepna:
		await rozmowa(Dialogi.SCENA6["latarka_potem"])
		return
	await rozmowa(Dialogi.SCENA6["latarka"])
	Ekwipunek.dodaj("latarka")
	Gra.latarnia_dostepna = true
	Gra.ustaw_latarnie(true)
	komunikat(Dialogi.SCENA6_NAPISY["latarka"], 5.0)


func _ogledz_cialo() -> void:
	if Ekwipunek.przedmioty.has("zdjecie_pasy"):
		await rozmowa(Dialogi.SCENA6["cialo_potem"])
	elif not Gra.latarnia:
		await rozmowa(Dialogi.SCENA6["cialo_bez_latarki"])
	else:
		await rozmowa(Dialogi.SCENA6["cialo"])
		await blysk()
		Ekwipunek.dodaj("zdjecie_pasy")


func _lista() -> void:
	if Ekwipunek.przedmioty.has("lista_rekwizytow"):
		await rozmowa(Dialogi.SCENA6["lista_potem"])
		return
	await rozmowa(Dialogi.SCENA6["lista"])
	Ekwipunek.dodaj("lista_rekwizytow")


## Manekin przewraca się sam, gdy Antoni przechodzi obok. Pod nim leży telefon Adriana.
func _manekin_upada() -> void:
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_manekin, "rotation", -PI / 2.0, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_property(_manekin, "rotation", -PI / 2.0 + 0.08, 0.08)
	tw.tween_property(_manekin, "rotation", -PI / 2.0, 0.08)
	await get_tree().create_timer(0.4).timeout
	dzwiek("upadek.wav", -2.0)
	await tw.finished
	zwroc_sie(_manekin)
	await dialog.pokaz(Dialogi.SCENA6["manekin_upada"])
	antoni.sterowanie = true
	var tel := rekwizyt("telefon_podloga", Vector2(160, 480))
	dodaj_rozmowce(tel, _ciemno_albo(_telefon), "Coś leży", 14.0)


func _telefon() -> void:
	if Ekwipunek.przedmioty.has("telefon_adriana"):
		return
	await rozmowa(Dialogi.SCENA6["telefon"])
	Ekwipunek.dodaj("telefon_adriana")
	for r in _rozmowcy:
		if r[0] is Sprite2D and (r[0] as Sprite2D).texture.resource_path.ends_with("telefon_podloga.png"):
			r[0].queue_free()


func _rozmowa_z_nowickim() -> void:
	await rozmowa(Dialogi.SCENA6["nowicki"])
	if await wybor(Dialogi.SCENA6_WYBOR) == 1:
		await rozmowa(Dialogi.SCENA6["koniec_sam"])
		_zakoncz()
	else:
		await rozmowa(Dialogi.SCENA6["nowicki_jeszcze"])


## Koniec kwadransu: ściemnienie, ciało zabrane, brama otwarta.
func _zakoncz() -> void:
	if _konczy:
		return
	_konczy = true
	_zegar.visible = false
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 0.8)
	await tw.finished
	_cialo.queue_free()
	_lekarz.queue_free()
	_nowicki.position = antoni.position + Vector2(40, 6)
	antoni.stan("prawo")
	tw = create_tween()
	tw.tween_property(_zaslona, "color:a", 0.0, 0.8)
	await tw.finished
	await dialog.pokaz(Dialogi.SCENA6["koniec"])
	antoni.sterowanie = true
	ustaw_wyjscie(BRAMA, "Do budki stróża", NASTEPNA)


## Scena 7 jeszcze nie istnieje: plansza i powrót do menu.
func przejdz(scena: String) -> void:
	koniec = true
	antoni.sterowanie = false
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	var napis := etykieta(12, Color8(170, 160, 140))
	napis.text = Dialogi.SCENA6_NAPISY["dalej"]
	napis.position = Vector2(0, 124)
	napis.size = Vector2(480, 20)
	napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(napis)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file(scena)


# ---------- życie w tle ----------

func _blysk_policjanta() -> void:
	if not is_instance_valid(_policjant):
		return
	_flesz.position = _policjant.position + Vector2(0, -30)
	if odleglosc(antoni.position, _policjant.position) < 320.0:
		dzwiek("flesz.wav", -14.0)
	await get_tree().create_timer(0.95).timeout
	var tw := create_tween()
	tw.tween_property(_flesz, "energy", 3.0, 0.04)
	tw.tween_property(_flesz, "energy", 0.0, 0.35)
	await tw.finished


func _tlo_flesz() -> void:
	while not koniec and not _konczy:
		await get_tree().create_timer(randf_range(10.0, 16.0)).timeout
		await _blysk_policjanta()


## Co jakiś czas szczur przebiega między skrzyniami najbliżej Antoniego.
func _tlo_szczury() -> void:
	var trasy := [[Vector2(240, 452), Vector2(330, 500)], [Vector2(600, 300), Vector2(700, 296)],
			[Vector2(900, 470), Vector2(770, 486)], [Vector2(150, 260), Vector2(60, 270)],
			[Vector2(420, 410), Vector2(540, 420)]]
	while not koniec:
		await get_tree().create_timer(randf_range(14.0, 24.0)).timeout
		if not wolny():
			continue
		var trasa: Array = trasy[0]
		for tr in trasy:
			if antoni.position.distance_to(tr[0]) < antoni.position.distance_to(trasa[0]):
				trasa = tr
		if antoni.position.distance_to(trasa[0]) > 220.0:
			continue
		var szczur := rekwizyt("szczur", trasa[0])
		szczur.flip_h = trasa[1].x < trasa[0].x
		dzwiek("szczur.wav", -8.0)
		var tw := create_tween()
		tw.tween_property(szczur, "position", trasa[1], 0.9)
		tw.tween_callback(szczur.queue_free)


func _tlo_blacha() -> void:
	var pierwszy := true
	while not koniec:
		await get_tree().create_timer(randf_range(18.0, 32.0)).timeout
		dzwiek("blacha.wav", -9.0)
		if pierwszy:
			pierwszy = false
			await get_tree().create_timer(1.5).timeout
			dymek(antoni, "To tylko wiatr...", 2.5)
