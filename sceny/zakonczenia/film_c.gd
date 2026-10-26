extends FilmKonca
## Zakończenie C (złe): zatrzymano niewinną osobę. Wieczorem Ania sama w garderobie
## płucze rękawiczki, patrzy na kartkę od Adriana i szepcze "przepraszam".

const LUSTRO := Vector2(290, 140)


func _ready() -> void:
	przygotuj_film($Garderoba, Color(0.42, 0.38, 0.46))
	var t: Dictionary = Dialogi.FILMY_KONCA["C"]
	antoni.position = Vector2(320, 200)
	antoni.visible = false
	var ania := postac("ania", Vector2(320, 344))
	await plansza(t["plansza"])
	antoni.sterowanie = false
	await napis(t["areszt"] % Gra.flagi.get("oskarzony", "Ktoś"), 4.0)
	await napis(t["pogrzeb"], 3.5)
	await idz(ania, [Vector2(320, 200), LUSTRO], 34.0)
	await rozmowa(t["rekawiczki"])
	await get_tree().create_timer(1.2).timeout
	await rozmowa(t["kartka"])
	await dymek(ania, t["przepraszam"], 3.0)
	koniec_filmu()
