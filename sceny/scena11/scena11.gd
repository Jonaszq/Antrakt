extends ScenaGry
## Scena 11 (rozdział 3): pracownia kostiumów, niedziela 18:00.
## Irena szyje opaski i zbywa Antoniego. Mówi o podszewce dopiero, gdy zobaczy zdjęcie
## plamy (sc. 10) albo pasów na skórze (sc. 6) i wtedy odwraca się do okna (s11_otwarta).
## Dopiero wtedy da się zabrać nożyczki ze stołu (potrzebne w sc. 13). Zeznanie dodaje
## kartę "podszewka" do teczki. Zdjęcie z próby (s11_foto) pokaże się w retrospekcji 2.
## Teksty w Dialogi.SCENA11.

const NASTEPNA := "res://sceny/scena12/scena12.tscn"
const DRZWI := Rect2(26, 104, 52, 36)
const OKNO := Vector2(521, 132)
const NOZYCZKI := Vector2(600, 254)

var _irena: Node2D
var _nozyczki: Sprite2D


func _ready() -> void:
	przygotuj($Pracownia)
	Telefon.godzina = "18:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA11
	antoni.position = Vector2(52, 156)
	antoni.stan("dol")
	_irena = postac("irena", Vector2(132, 372))
	dodaj_rozmowce(_irena, _rozmowa_z_irena)
	gada_w_tle(_irena, Dialogi.SCENA11_TLO["irena"], 9.0)
	rekwizyt("opaski_stos", Vector2(86, 352), 22.0)
	_nozyczki = rekwizyt("nozyczki_stol", NOZYCZKI, 30.0)
	miejsce(Vector2(600, 268), "Stół krawiecki", _wez_nozyczki, 50.0)
	miejsce(Vector2(78, 376), "Opaski", t["opaski"], 40.0)
	miejsce(Vector2(472, 112), "Zdjęcie", _po_kolei("foto", "s11_foto"), 76.0)
	miejsce(Vector2(207, 318), "Kostium", _po_kolei("manekin_wolski", "s11_zapas"), 60.0)
	miejsce(Vector2(455, 204), "Manekiny", t["manekiny"], 60.0)
	miejsce(Vector2(231, 138), "Radio", _po_kolei("radio", ""), 40.0)
	miejsce(Vector2(521, 112), "Okno", t["okno"], 70.0)
	miejsce(Vector2(74, 252), "Stojak", t["stojak"], 60.0)
	miejsce(Vector2(668, 128), "Regał", _po_kolei("regal", "s11_zeszyt"), 70.0)
	miejsce(Vector2(134, 126), "Szafa", t["szafa"], 70.0)
	miejsce(Vector2(748, 130), "Szafa", t["szafa"], 70.0)
	miejsce(Vector2(603, 146), "Lustro", t["lustro"], 60.0)
	miejsce(Vector2(739, 348), "Parawan", t["parawan"], 60.0)
	miejsce(Vector2(575, 440), "Kosz", t["kosz"], 30.0)
	miejsce(Vector2(667, 438), "Bele", t["bele"], 30.0)
	miejsce(Vector2(432, 442), "Deska", t["deska"], 30.0)
	miejsce(Vector2(762, 446), "Kufer", t["kufer"], 30.0)
	ustaw_wyjscie(DRZWI, "Wyjdź", NASTEPNA)
	dzwiek("gramofon.ogg", -28.0, true)  # radio z audycją o ogrodach
	await plansza("Pracownia kostiumów, niedziela 18:00")
	await rozmowa(t["poczatek"])


## Pierwszy raz pełny opis (i flaga), potem krótka wersja "<klucz>_potem".
func _po_kolei(klucz: String, flaga: String) -> Callable:
	var stan := {"bylo": false}
	return func() -> void:
		var t: Dictionary = Dialogi.SCENA11
		await rozmowa(t[klucz + "_potem"] if stan.bylo and t.has(klucz + "_potem") else t[klucz])
		stan.bylo = true
		if flaga != "":
			Gra.flagi[flaga] = true


func _wez_nozyczki() -> void:
	var t: Dictionary = Dialogi.SCENA11
	if Ekwipunek.ma("nozyczki"):
		await rozmowa(t["nozyczki_potem"])
	elif not Gra.flagi.get("s11_otwarta", false):
		await rozmowa(t["nozyczki_nie"])
	else:
		await rozmowa(t["nozyczki"])
		Ekwipunek.dodaj("nozyczki")
		Gra.flagi["s11_nozyczki"] = true
		_nozyczki.visible = false


## Zdjęcie plamy albo pasów: Irena pęka, opowiada o podszewce i odchodzi do okna.
func _pokazal(klucz: String, flaga: String) -> void:
	var t: Dictionary = Dialogi.SCENA11
	await rozmowa(t[klucz])
	Gra.flagi[flaga] = true
	if Gra.flagi.get("s11_otwarta", false):
		return
	await rozmowa(t["podszewka"])
	Gra.flagi["s11_otwarta"] = true
	Gra.flagi["s11_podszewka"] = true
	Teczka.dodaj("podszewka")
	await idz(_irena, [Vector2(330, 380), Vector2(521, 200), OKNO], 60.0)


func _rozmowa_z_irena() -> void:
	var t: Dictionary = Dialogi.SCENA11
	if Gra.flagi.get("s11_otwarta", false):
		await rozmowa(t["irena_okno"])
	elif Gra.flagi.get("s11_zagadal", false):
		await rozmowa(t["irena_znowu"])
	else:
		await rozmowa(t["irena_start"])
		Gra.flagi["s11_zagadal"] = true
	var otwarta := func() -> bool: return Gra.flagi.get("s11_otwarta", false)
	var tematy := [
		["Kostium Wolskiego", temat("s11_kostium", t["irena_kostium"])],
		["Kto ma klucz do pracowni?", temat("s11_ania_bywa", t["irena_klucz"])],
		["Zapasowy kostium", t["irena_zapas"], func() -> bool: return Gra.flagi.get("s11_zapas", false)],
		["Zdjęcie z próby", temat("s11_foto_irena", t["irena_foto"]), func() -> bool: return Gra.flagi.get("s11_foto", false)],
		["Pożyczy mi pani nożyczki?", t["irena_nozyczki"], func() -> bool: return not otwarta.call() and not Ekwipunek.ma("nozyczki")],
		["Mogę wziąć opaskę?", _wez_opaske, func() -> bool: return otwarta.call() and not Ekwipunek.ma("opaska")],
	]
	var dowody := {
		"zdjecie_plamy": _pokazal.bind("plama", "s11_plama"),
		"zdjecie_pasy": _pokazal.bind("pasy", "s11_szwy"),
		"karta_kwit": t["irena_kwit"],
	}
	await przesluchanie(tematy, dowody, t["irena_nic"], t["irena_koniec"])


func _wez_opaske() -> void:
	await rozmowa(Dialogi.SCENA11["irena_opaska"])
	Ekwipunek.dodaj("opaska")
	Gra.flagi["s11_opaska"] = true

