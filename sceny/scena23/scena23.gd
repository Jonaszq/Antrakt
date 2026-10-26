extends ScenaGry
## Scena 23 (rozdział 5): brawa. Ania na krześle ofiary, z ciemnej widowni klaszcze Wolski.
## Co mówi, zależy od tego, czy Antoni ostrzegł go we wtorek (s14_ostrzezony) i czy
## przyłapał go na grzebaniu w garderobie (s18_przylapany). Pendrive (przedmiot albo
## karta) = Wolski w kajdankach, zakończenie A; bez niego Wolski wychodzi, zakończenie B.
## Nowicki przychodzi zawsze, ale wcześniej słyszał wszystko tylko wtedy, gdy Antoni
## go zaprosił (s21_nowicki). Teksty w Dialogi.SCENA23.

const ZAKONCZENIE := "res://sceny/zakonczenia/zakonczenie.tscn"
const KRZESLO := Vector2(396, 160)
const MIEJSCE_ANTONIEGO := Vector2(450, 196)


func _ready() -> void:
	przygotuj($Widownia)
	Telefon.godzina = "9:40"
	var t: Dictionary = Dialogi.SCENA23
	var f: Dictionary = Gra.flagi
	$Widownia/Mrok.color = Color(0.42, 0.38, 0.46)
	obiekty.get_node("Bogdan").visible = false
	obiekty.get_node("Bogdan").position = Vector2(-500, -500)
	var wolski: Node2D = obiekty.get_node("Wolski")
	wolski.position = Vector2(480, 600)
	var ania := postac("ania", KRZESLO)
	antoni.position = MIEJSCE_ANTONIEGO
	antoni.stan("dol")
	await rozjasnij()
	antoni.sterowanie = false
	komunikat(t["brawa"], 3.0)
	dzwiek("oklaski.ogg", -14.0)
	await idz(wolski, [Vector2(480, 260)], 30.0)
	zwroc_sie(wolski)
	await rozmowa(t["wolski"])
	if f.get("s14_ostrzezony", false):
		await rozmowa(t["wolski_ostrzezony"])
	if f.get("s18_przylapany", false):
		await rozmowa(t["wolski_przylapany"])
	await rozmowa(t["wolski_nagrania"])
	var pendrive := Ekwipunek.ma("pendrive") or Teczka.sprawdzona("pendrive")
	if pendrive:
		await rozmowa(t["pendrive"])
		if f.get("s18_przylapany", false):
			await rozmowa(t["pendrive_przylapany"])
	else:
		await rozmowa(t["bez_pendrive"])
		await idz(wolski, [Vector2(480, 640)], 50.0)
		wolski.visible = false
	komunikat(t["nowicki_wchodzi"], 3.5)
	var nowicki := postac("nowicki", Vector2(440, 640))
	var policjant := postac("policjant", Vector2(520, 640))
	idz(policjant, [Vector2(520, 290)], 45.0)
	await idz(nowicki, [Vector2(440, 280)], 45.0)
	zwroc_sie(nowicki)
	await rozmowa(t["nowicki_slyszal"] if f.get("s21_nowicki", false) else t["nowicki_wezwany"])
	await rozmowa(t["nowicki_ania"])
	if pendrive:
		await rozmowa(t["nowicki_wolski"])
	f["zakonczenie"] = "A" if pendrive else "B"
	f["powod"] = ""
	przejdz(ZAKONCZENIE)
