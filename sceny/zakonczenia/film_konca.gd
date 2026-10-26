class_name FilmKonca
extends ScenaGry
## Wspólna podstawa scenek zakończeń (film_a..film_d): Antoni nie steruje, gra się nie
## zapisuje, na końcu ściemnienie i ekran z epilogiem (zakonczenie.tscn).
## Teksty w Dialogi.FILMY_KONCA.

const EKRAN_KONCA := "res://sceny/zakonczenia/zakonczenie.tscn"


func przygotuj_film(mapa: Node2D, mrok: Color) -> void:
	Gra.zapisuj = false  # zapis zostaje na ostatniej grywalnej scenie
	przygotuj(mapa)
	antoni.sterowanie = false
	antoni.wybor_gracza = false
	mapa.get_node("Mrok").color = mrok


## Napis u góry ekranu i chwila na przeczytanie.
func napis(tekst: String, czas := 3.5) -> void:
	komunikat(tekst, czas)
	await get_tree().create_timer(czas + 0.6).timeout


func koniec_filmu() -> void:
	await get_tree().create_timer(1.0).timeout
	przejdz(EKRAN_KONCA)


## Deszcz: ukośne krople nad całym ekranem i szum w tle.
func deszcz() -> void:
	var warstwa := CanvasLayer.new()
	warstwa.layer = 4
	add_child(warstwa)
	var kropla := Image.create(1, 8, false, Image.FORMAT_RGBA8)
	kropla.fill(Color(0.75, 0.8, 0.95, 0.55))
	var czastki := CPUParticles2D.new()
	czastki.texture = ImageTexture.create_from_image(kropla)
	czastki.amount = 520
	czastki.lifetime = 1.2
	czastki.preprocess = 1.2
	czastki.position = Vector2(960, -40)
	czastki.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	czastki.emission_rect_extents = Vector2(1100, 10)
	czastki.direction = Vector2(-0.2, 1.0)
	czastki.spread = 2.0
	czastki.gravity = Vector2.ZERO
	czastki.initial_velocity_min = 900.0
	czastki.initial_velocity_max = 1100.0
	czastki.scale_amount_min = 3.0
	czastki.scale_amount_max = 4.0
	czastki.particle_flag_align_y = true
	warstwa.add_child(czastki)
	dzwiek("magazyn.ogg", -12.0, true)


## W filmie Antoni nie odzyskuje sterowania po rozmowie.
func rozmowa(kwestie: Array) -> void:
	antoni.sterowanie = false
	await dialog.pokaz(kwestie)


## Antoni idzie sam przez punkty, z animacją chodu.
func prowadz(punkty: Array, predkosc := 40.0) -> void:
	var kier := "dol"
	var wszystkie := []
	for p in punkty:
		wszystkie.append_array(trasa(wszystkie[-1] if not wszystkie.is_empty() else antoni.position, p))
	for cel in wszystkie:
		var d: Vector2 = cel - antoni.position
		if absf(d.x) > absf(d.y):
			kier = "lewo" if d.x < 0.0 else "prawo"
		else:
			kier = "dol" if d.y > 0.0 else "gora"
		antoni.sprite.flip_h = kier == "lewo"
		antoni.sprite.play("idzie_" + ("prawo" if kier == "lewo" else kier))
		var tw := create_tween()
		tw.tween_property(antoni, "position", cel, maxf(d.length() / predkosc, 0.05))
		await tw.finished
	antoni.stan(kier)


## Postać odchodzi przez punkty i znika.
func odejdz(kto: Node2D, punkty: Array, predkosc := 30.0) -> void:
	await idz(kto, punkty, predkosc)
	if not is_instance_valid(kto):
		return
	var tw := create_tween()
	tw.tween_property(kto, "modulate:a", 0.0, 0.8)
	await tw.finished
	if is_instance_valid(kto):
		kto.queue_free()
