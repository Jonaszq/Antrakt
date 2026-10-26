extends RetroBaza
## Ostatnia retrospekcja (po przyznaniu się Ani w scenie 22): czwartek w pracowni, tym
## razem z twarzą. Pokazuje tylko to, co gracz ustalił: rękawiczki (karta), Marta
## (s19_szczegoly), choroba Wolskiego, podszewka na próbie, SMS, skrzynka nocna.
## Przypomina, kogo gracz wpisał w sylwetkę w retrospekcji 5. Potem scena 23.
## Teksty w Dialogi.RETRO6.

const NASTEPNA := "res://sceny/scena23/scena23.tscn"
const DRZWI := Vector2(52, 150)
const STOJAK := Vector2(112, 262)


func _ready() -> void:
	przygotuj_retro($Pracownia, Vector2(800, 480), Vector2(240, 240), Color(0.6, 0.56, 0.54))
	var r: Dictionary = Dialogi.RETRO6
	var f: Dictionary = Gra.flagi
	var ania := postac("ania", DRZWI)
	await plansza(r["tytul"])
	antoni.sterowanie = false
	komunikat(r["sroda"], 3.5)
	await idz(ania, [Vector2(60, 200), STOJAK + Vector2(30, 0)], 26.0)
	await dymek(ania, r["ania_butelka"], 3.0)
	if Teczka.sprawdzona("rekawiczki"):
		await dymek(ania, r["rekawiczki"], 2.5)
	if f.get("s19_szczegoly", false):
		var skrzynki := rekwizyt("skrzynki_mleko", Vector2(90, 190))
		var marta := postac("marta", Vector2(52, 120))
		await idz(marta, [Vector2(70, 180)], 40.0)
		await dymek(marta, r["marta"], 2.5)
		await idz(marta, [Vector2(52, 120)], 40.0)
		marta.queue_free()
		skrzynki.visible = true
	var przymierzona: String = str(f.get("retro_pracownia", ""))
	if przymierzona == "Ania":
		await rozmowa([["Antoni", r["przymierzylem"]]])
	elif przymierzona != "":
		await rozmowa([["Antoni", r["przymierzylem_kogos"] % przymierzona]])
	var napisy: Array = []
	if f.get("s14_chory", false) or Teczka.sprawdzona("recepta"):
		napisy.append(r["chory"])
	if f.get("s11_podszewka", false):
		napisy.append(r["adrian"])
	if Teczka.sprawdzona("sms"):
		napisy.append(r["sms"])
	if Teczka.sprawdzona("kwit"):
		napisy.append(r["skrzynka"])
	napisy.append(r["koniec"])
	zakoncz(napisy, NASTEPNA)
