extends ScenaGry
## Scena 10 (rozdział 3): pralnia pani Haliny, niedziela 15:00.
## Zwykle: Halina nie może znaleźć kostiumu, gracz sam szuka numeru 0412 na stojakach,
## kładzie kostium pod lampą prasowalnicy i fotografuje plamę na podszewce. Jeśli
## w scenie 4 wąchał koszulę Adriana (s4_koszula), czuje ten sam zapach (s10_zapach).
## Gdy w scenie 9 oddał kwit Ani (s9_kwit_ania), kostiumu już nie ma: Ania odebrała go
## mokry, zostaje tylko relacja Haliny (s10_ania_odebrala).
## Książka przyjęć (stempel czw. 23:40, podpis A.) dodaje kartę "kwit" do teczki.
## Teksty w Dialogi.SCENA10.

const NASTEPNA := "res://sceny/scena11/scena11.tscn"
const DRZWI := Rect2(288, 318, 64, 42)
const LAMPA := Vector2(511, 200)
## Miejsca przy stojakach (przód każdego stojaka); kostium wisi na ostatnim.
const STOJAKI := [Vector2(215, 232), Vector2(375, 232), Vector2(215, 310), Vector2(375, 310)]

var _ania_ma := false
var _kostium: Sprite2D


func _ready() -> void:
	przygotuj($Pralnia)
	Telefon.godzina = "15:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA10
	var tlo: Dictionary = Dialogi.SCENA10_TLO
	_ania_ma = Gra.flagi.get("s9_kwit_ania", false)
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	var halina := postac("halina", Vector2(205, 112))
	dodaj_rozmowce(halina, _rozmowa_z_halina, "", 74.0)
	gada_w_tle(halina, tlo["halina"], 10.0)
	var klientka := postac("para_pani", Vector2(120, 170))
	dodaj_rozmowce(klientka, _kolejne("klientka"))
	gada_w_tle(klientka, tlo["klientka"], 12.0)
	for i in STOJAKI.size():
		miejsce(STOJAKI[i], "Stojak", _stojak.bind(i), 60.0)
	miejsce(LAMPA, "Lampa", _lampa, 50.0)
	miejsce(Vector2(207, 156), "Książka przyjęć", _ksiazka, 46.0)
	miejsce(Vector2(250, 156), "Bułki", _bulki, 46.0)
	miejsce(Vector2(357, 128), "Kot", _kolejne("kot"), 76.0)
	miejsce(Vector2(540, 334), "Skrzynka nocna", t["skrzynka_nocna"], 40.0)
	miejsce(Vector2(78, 112), "Zaplecze", t["zaplecze"], 60.0)
	miejsce(Vector2(161, 112), "Zegar", t["zegar"], 80.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", NASTEPNA)
	dzwiek("gramofon.ogg", -26.0, true)  # stara piosenka w radiu
	await plansza("Pralnia \"Perła\", niedziela 15:00")
	await rozmowa(t["poczatek"])
	await rozmowa(t["halina_start_ania" if _ania_ma else "halina_start"])
	if _ania_ma:
		Gra.flagi["s10_ania_odebrala"] = true


func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		var klucz := kto if stan.pierwsza or not Dialogi.SCENA10.has(kto + "_potem") else kto + "_potem"
		await rozmowa(Dialogi.SCENA10[klucz])
		stan.pierwsza = false


## Każdy stojak ma inne numery. Kostium 0412 wisi na ostatnim (prawy dolny).
func _stojak(nr: int) -> void:
	var t: Dictionary = Dialogi.SCENA10
	if nr != 3:
		await rozmowa([t["stojak"][nr]])
		return
	if _ania_ma:
		await rozmowa(t["stojak_pusto"])
		return
	if Gra.flagi.get("s10_kostium", false):
		await rozmowa([["", "Pusty wieszak 0412. Kostium leży na stole przy prasowalnicy."]])
		return
	await rozmowa([t["stojak"][nr]])
	await rozmowa(t["znalazl"])
	Gra.flagi["s10_kostium"] = true
	_kostium = rekwizyt("kostium_folia", Vector2(497, 166), 10.0)


## Pod lampą prasowalnicy widać plamę (tylko gdy kostium leży na stole).
func _lampa() -> void:
	var t: Dictionary = Dialogi.SCENA10
	if not Gra.flagi.get("s10_kostium", false):
		await rozmowa(t["lampa_bez"])
		return
	if Ekwipunek.ma("zdjecie_plamy"):
		await rozmowa(t["plama_potem"])
		return
	await rozmowa(t["plama"])
	await blysk()
	Ekwipunek.dodaj("zdjecie_plamy")
	if Gra.flagi.get("s4_koszula", false):
		await rozmowa(t["plama_zapach"])
		Gra.flagi["s10_zapach"] = true
	await rozmowa(t["halina_plama"])


func _ksiazka() -> void:
	var t: Dictionary = Dialogi.SCENA10
	if Gra.flagi.get("s10_ksiazka", false):
		await rozmowa(t["ksiazka_potem"])
		return
	await rozmowa(t["ksiazka"])
	Gra.flagi["s10_ksiazka"] = true
	Teczka.dodaj("kwit")


func _bulki() -> void:
	var t: Dictionary = Dialogi.SCENA10
	if Gra.flagi.get("s10_bulka", false):
		await rozmowa(t["bulki_potem"])
		return
	await rozmowa(t["bulki"])
	Gra.flagi["s10_bulka"] = true
	Ekwipunek.dodaj("bulka")


func _rozmowa_z_halina() -> void:
	var t: Dictionary = Dialogi.SCENA10
	var tematy := [
		["Kto oddał ten kostium?", temat("s10_skrzynka", t["halina_kto"])],
		["Co to za plama?", temat("s10_plama_halina", t["halina_co"]),
			func() -> bool: return _ania_ma or Ekwipunek.ma("zdjecie_plamy")],
	]
	if _ania_ma:
		tematy.append(["Pani Ania coś mówiła?", temat("s10_ania_odebrala", t["halina_pytal_ania"])])
	else:
		tematy.append(["Ktoś jeszcze pytał o kostium?", t["halina_pytal"]])
	await przesluchanie(tematy, Dialogi.SCENA10_DOWODY, t["halina_nic"], t["halina_koniec"])

