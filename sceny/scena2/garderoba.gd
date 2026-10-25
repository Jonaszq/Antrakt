extends ScenaGry
## Garderoba Ani (część sceny 2). Na toaletce, obok zdjęcia z Adrianem, leży
## rekwizytowy nóż, którego szuka Marta. Antoni bierze go dopiero wtedy, gdy wie,
## że Marta go szuka. Dolne drzwi wracają do kulis (scena2 czyta Gra.flagi).

const KULISY := "res://sceny/scena2/scena2.tscn"
const DRZWI := Rect2(288, 318, 64, 42)

var _noz: Sprite2D


func _ready() -> void:
	przygotuj($Garderoba)
	Telefon.godzina = "18:55"
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	var t: Dictionary = Dialogi.GARDEROBA
	if not (Ekwipunek.ma("noz") or Gra.flagi.get("s2_oddal")):
		_noz = rekwizyt("noz_maly", Vector2(286, 90))
	miejsce(Vector2(290, 120), "Toaletka", _toaletka)
	miejsce(Vector2(191, 292), "", t["kwiaty"])
	miejsce(Vector2(102, 280), "", t["kanapa"])
	miejsce(Vector2(575, 228), "", t["parawan"])
	miejsce(Vector2(440, 126), "", t["wieszak"])
	miejsce(Vector2(76, 130), "", t["szafa"])
	ustaw_wyjscie(DRZWI, "Do kulis", KULISY)
	Gra.flagi["s2_z_garderoby"] = true
	await rozjasnij()
	if not Gra.flagi.get("s2_byl_w_garderobie"):
		Gra.flagi["s2_byl_w_garderobie"] = true
		await rozmowa(t["wejscie"])


func _toaletka() -> void:
	var t: Dictionary = Dialogi.GARDEROBA
	if not is_instance_valid(_noz) or not _noz.visible:
		await rozmowa(t["toaletka_potem"])
	elif not Gra.flagi.get("s2_szuka"):
		await rozmowa(t["toaletka_przed"])
	else:
		await rozmowa(t["toaletka"])
		_noz.visible = false
		Ekwipunek.dodaj("noz")
