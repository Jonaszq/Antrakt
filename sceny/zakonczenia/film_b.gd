extends FilmKonca
## Zakończenie B (połowiczne): miesiąc później, premiera Wolskiego "pamięci Adriana".
## Ania w areszcie, Wolski na wolności kłania się i bezgłośnie dziękuje Antoniemu.

const PRZOD_SCENY := Vector2(560, 196)


func _ready() -> void:
	przygotuj_film($Widownia, Color(0.5, 0.46, 0.54))
	var t: Dictionary = Dialogi.FILMY_KONCA["B"]
	for n in ["Bogdan", "Wolski"]:
		var p := obiekty.get_node_or_null(n)
		if p:
			p.visible = false
			p.position = Vector2(-500, -500)
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	# widzowie w pierwszych rzędach: oparcia foteli zasłaniają im nogi
	for w in [["gosc_pani", Vector2(262, 272)], ["gosc_pan", Vector2(386, 272)], ["para_pani", Vector2(440, 272)],
			["para_pan", Vector2(470, 272)], ["stasia", Vector2(232, 306)], ["zawada", Vector2(560, 306)]]:
		postac(w[0], w[1])
	var wolski := postac("wolski", Vector2(810, 196))
	await plansza(t["plansza"])
	antoni.sterowanie = false
	await napis(t["areszt"], 3.5)
	await idz(wolski, [PRZOD_SCENY], 40.0)
	await dymek(wolski, t["dedykacja"], 3.0)
	dzwiek("oklaski.ogg", -10.0)
	for i in 2:  # ukłon
		await idz(wolski, [PRZOD_SCENY + Vector2(0, 6)], 30.0)
		await idz(wolski, [PRZOD_SCENY], 30.0)
		await get_tree().create_timer(0.4).timeout
	await rozmowa(t["usmiech"])
	await dymek(wolski, t["dziekuje"], 3.0)
	await rozmowa(t["antoni"])
	koniec_filmu()
