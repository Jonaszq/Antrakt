extends FilmKonca
## Zakończenie A (pełne): cmentarz w południe. Ania i Wolski zatrzymani, nad grobem
## Adriana kilka osób. Halina kładzie wypraną chusteczkę, Antoni zostaje sam.

const GROB := Vector2(428, 248)


func _ready() -> void:
	przygotuj_film($Cmentarz, Color(0.92, 0.92, 0.96))
	var t: Dictionary = Dialogi.FILMY_KONCA["A"]
	antoni.position = Vector2(320, 96)
	antoni.stan("dol")
	var marta := postac("marta", Vector2(474, 272))
	var lis := postac("bogdan", Vector2(510, 262))
	var irena := postac("irena", Vector2(540, 248))
	await plansza(t["plansza"])
	antoni.sterowanie = false
	await napis(t["policja"], 4.0)
	await prowadz([Vector2(320, 230), Vector2(372, 232)], 40.0)
	antoni.stan("prawo")
	var halina := postac("halina", Vector2(320, 80))
	await idz(halina, [Vector2(320, 272), Vector2(GROB.x, 272), GROB], 34.0)
	await rozmowa(t["halina"])
	await get_tree().create_timer(1.0).timeout
	await rozmowa(t["antoni"])
	# wszyscy odchodzą do bramy, Antoni zostaje
	for p in [halina, marta, lis, irena]:
		odejdz(p, [Vector2(p.position.x, 276), Vector2(320, 276), Vector2(320, 80)])
		await get_tree().create_timer(1.6).timeout
	await get_tree().create_timer(3.0).timeout
	antoni.stan("prawo")
	await napis(t["sam"], 3.0)
	koniec_filmu()
