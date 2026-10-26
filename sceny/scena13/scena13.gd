extends ScenaGry
## Scena 13 (rozdział 3): pralnia, wtorek 9:00. Halina rozpruła podszewkę. Gracz sam
## musi wyciąć kawałek nożyczkami (sc. 11), włożyć go do woreczka ze schowka w aucie
## (Samochod) i zawieźć do laboratorium, którego nikt nie wskazuje (laboratorium.gd).
## Bez nożyczek Halina da swoje dopiero jutro: przepada dzień. Bez rękawiczek pieką
## palce (s13_dotknal). Teksty w Dialogi.SCENA13.

const DRZWI := Rect2(288, 318, 64, 42)
const LAMPA := Vector2(511, 200)
const DZIEN := 1440

var _halina: Node2D


func _ready() -> void:
	przygotuj($Pralnia)
	Telefon.godzina = "9:20"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA13
	var powrot: bool = Gra.flagi.get("s13_byl", false)
	antoni.position = Vector2(320, 300)
	antoni.stan("gora")
	_halina = postac("halina", Vector2(205, 112))
	dodaj_rozmowce(_halina, _rozmowa_z_halina, "", 74.0)
	rekwizyt("kostium_folia", Vector2(497, 166), 10.0)
	miejsce(LAMPA, "Podszewka", _podszewka, 50.0)
	miejsce(Vector2(357, 128), "Kot", t["kot"], 76.0)
	miejsce(Vector2(161, 112), "Zegar", t["zegar"], 80.0)
	ustaw_wyjscie(DRZWI, "Do samochodu", "")
	if powrot:
		_zaslona.color.a = 0.0
		return
	await plansza("Pralnia \"Perła\", wtorek 9:00")
	await rozmowa(t["poczatek"])
	await rozmowa(t["halina_start"])
	Gra.flagi["s13_byl"] = true


func _podszewka() -> void:
	var t: Dictionary = Dialogi.SCENA13
	await rozmowa(t["kostium"])
	while true:
		var opcje := []
		if Ekwipunek.ma("nozyczki"):
			opcje.append("Wytnij kawałek")
		if Ekwipunek.ma("lampa_uv"):
			opcje.append("Poświeć lampą UV")
		opcje.append("Zostaw")
		var w := await wybor(opcje)
		match opcje[w]:
			"Wytnij kawałek":
				await _wytnij()
			"Poświeć lampą UV":
				await rozmowa(t["uv"])
				Gra.flagi["s12_uv"] = true
			_:
				break
	antoni.sterowanie = true


func _wytnij() -> void:
	var t: Dictionary = Dialogi.SCENA13
	if Gra.flagi.get("s13_probka", false):
		await rozmowa(t["wytnij_potem"])
	elif not Ekwipunek.ma("woreczek"):
		await rozmowa(t["wytnij_bez_woreczka"])
	else:
		if Ekwipunek.ma("rekawiczki"):
			await rozmowa(t["wytnij_rekawiczki"])
		else:
			await rozmowa(t["wytnij_bez"])
			Sledztwo.strata(30)
			Gra.flagi["s13_dotknal"] = true
		Ekwipunek.usun("woreczek")
		Ekwipunek.dodaj("probka")
		Gra.flagi["s13_probka"] = true


func _rozmowa_z_halina() -> void:
	var t: Dictionary = Dialogi.SCENA13
	var tematy := [
		["Pokaże mi pani dłonie?", temat("s13_rece", t["halina_rece"])],
		["Mogę wyciąć kawałek?", temat("s13_zgoda", t["halina_wyciac"])],
		["Pożyczy mi pani nożyczki?", _nozyczki_haliny, func() -> bool: return not Ekwipunek.ma("nozyczki")],
		["Kto to może zbadać?", t["halina_gdzie"]],
	]
	await przesluchanie(tematy, {}, t["halina_nic"], t["halina_koniec"])


## Bez nożyczek Ireny: Halina da swoje dopiero jutro, przepada dzień.
func _nozyczki_haliny() -> void:
	var t: Dictionary = Dialogi.SCENA13
	await rozmowa(t["halina_nozyczki"])
	var w := await wybor(t["wybor_jutro"])
	if w == 0:
		await plansza("Środa, 9:00")
		await rozmowa(t["jutro"])
		Sledztwo.strata(DZIEN)
		Ekwipunek.dodaj("nozyczki")
		Gra.flagi["s13_nozyczki_haliny"] = true


## Wyjście prowadzi do samochodu: schowek albo jazda.
func przejdz(_scena: String) -> void:
	antoni.sterowanie = false
	var cel := await Samochod.jazda(self, Samochod.PRALNIA)
	if cel != "":
		super.przejdz(cel)
