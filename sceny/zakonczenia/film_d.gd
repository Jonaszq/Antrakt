extends FilmKonca
## Zakończenie D (czas minął): deszcz na cmentarzu, sprawa zamknięta jako zawał.
## Ania kładzie kwiaty, Wolski trzyma ją za ramię i przypomina o wpłacie.
## Antoni patrzy z daleka.

const GROB := Vector2(420, 250)


func _ready() -> void:
	przygotuj_film($Cmentarz, Color(0.46, 0.5, 0.6))
	var t: Dictionary = Dialogi.FILMY_KONCA["D"]
	antoni.position = Vector2(140, 268)
	antoni.stan("prawo")
	deszcz()
	await plansza(t["plansza"])
	antoni.sterowanie = false
	await napis(t["zawal"], 3.5)
	var ania := postac("ania", Vector2(320, 80))
	idz(ania, [Vector2(320, 266), GROB], 30.0)
	await get_tree().create_timer(1.2).timeout
	var wolski := postac("wolski", Vector2(320, 80))
	await idz(wolski, [Vector2(320, 266), GROB + Vector2(34, 2)], 30.0)
	await rozmowa(t["kwiaty"])
	await dymek(wolski, t["wolski"], 3.5)
	antoni.stan("prawo")
	await rozmowa(t["antoni"])
	koniec_filmu()
