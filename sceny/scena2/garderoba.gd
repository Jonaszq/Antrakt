extends ScenaGry
## Garderoba (część sceny 2): toaletka Ani ze zdjęciem z Adrianem, a na kanapie torba
## statysty "J.A." (Kuba) z rekwizytowym nożem, którego szuka Marta. Antoni bierze go
## dopiero wtedy, gdy wie, że Marta go szuka. Dolne drzwi wracają do kulis (scena2 czyta Gra.flagi).

const KULISY := "res://sceny/scena2/scena2.tscn"
const DRZWI := Rect2(288, 318, 64, 42)

var _noz := false  # nóż jeszcze leży w torbie


func _ready() -> void:
	przygotuj($Garderoba)
	Telefon.godzina = "18:55"
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	var t: Dictionary = Dialogi.GARDEROBA
	_noz = not (Ekwipunek.ma("noz") or Gra.flagi.get("s2_oddal"))
	rekwizyt("torba_sportowa", Vector2(112, 284), 12.0)
	miejsce(Vector2(290, 120), "Toaletka", _kolejne_toaletka())
	miejsce(Vector2(118, 290), "Torba", _torba)
	miejsce(Vector2(191, 292), "", t["kwiaty"])
	miejsce(Vector2(80, 280), "", t["kanapa"])
	miejsce(Vector2(575, 228), "", t["parawan"])
	miejsce(Vector2(440, 126), "", t["wieszak"])
	miejsce(Vector2(76, 130), "", t["szafa"])
	ustaw_wyjscie(DRZWI, "Do kulis", KULISY)
	Gra.flagi["s2_z_garderoby"] = true
	await rozjasnij()
	if not Gra.flagi.get("s2_byl_w_garderobie"):
		Gra.flagi["s2_byl_w_garderobie"] = true
		await rozmowa(t["wejscie"])


func _kolejne_toaletka() -> Callable:
	var stan := {"bylo": false}
	return func() -> void:
		var t: Dictionary = Dialogi.GARDEROBA
		await rozmowa(t["toaletka_potem" if stan.bylo else "toaletka"])
		stan.bylo = true


func _torba() -> void:
	var t: Dictionary = Dialogi.GARDEROBA
	if not _noz:
		await rozmowa(t["torba_potem"])
	elif not Gra.flagi.get("s2_szuka"):
		await rozmowa(t["torba_przed"])
	else:
		await rozmowa(t["torba"])
		_noz = false
		Gra.flagi["s2_torba_kuby"] = true
		Ekwipunek.dodaj("noz")
