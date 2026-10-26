extends ScenaGry
## Scena 1: foyer, sobota 18:30. Samouczek chodzenia, rozmów i przedmiotów.
## Antoniemu chce się siku, ale toaleta jest nieczynna, a potem okazuje się, że
## zgubił bilet. Bileterka go nie wpuści, bilet jest w płaszczu w szatni, szatniarz
## wyda płaszcz za numerek, a numerek leży pod stojakiem z programami.
## Z biletem bileterka zdradza, że toaleta personelu jest za drzwiami PERSONEL.
## Przy tych drzwiach Ania dzwoni do Adriana, po podsłuchaniu włącza się notes.
## Wokół gwar: krytyk, fanka Wolskiego, student, kelner, kłócąca się para, dziecko,
## fotograf. Drzwiami PERSONEL Antoni trafia za kulisy (scena 2).

const DRZWI := Rect2(190, 106, 48, 38)
const TOALETY := Rect2(264, 108, 36, 34)
const NASTEPNA := "res://sceny/scena2/scena2.tscn"

var _ania: Node2D
var _wie_o_bilecie := false  # Antoni już wie, że nie ma biletu
var _bileterka_zna := false  # pierwsza rozmowa z bileterką za nami
var _szatniarz_zna := false
var _plaszcz := false  # bilet wyjęty z płaszcza
var _bileterka_ok := false  # pokazał bilet, wie o toalecie personelu


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "18:31"
	_ania = obiekty.get_node("Ania")
	antoni.stan("gora")
	var tlo: Dictionary = Dialogi.SCENA1_TLO
	# obsługa teatru
	dodaj_rozmowce(postac("bileterka", Vector2(440, 150)), _rozmowa_z_bileterka)
	postac("szatniarz", Vector2(848, 288))
	miejsce(Vector2(790, 288), "Szatnia", _rozmowa_z_szatniarzem, 74.0)
	# widzowie, z którymi można pogadać
	var zawada := postac("zawada", Vector2(596, 190))
	dodaj_rozmowce(zawada, _kolejne(Dialogi.SCENA1, "zawada"))
	gada_w_tle(zawada, tlo["zawada"], 9.0)
	var stasia := postac("stasia", Vector2(196, 252))
	dodaj_rozmowce(stasia, _kolejne(Dialogi.SCENA1, "stasia"))
	gada_w_tle(stasia, tlo["stasia"], 8.0)
	dodaj_rozmowce(postac("gosc_student", Vector2(170, 330)), _kolejne(Dialogi.SCENA1, "kuba"))
	dodaj_rozmowce(postac("gosc_pan", Vector2(560, 252)), Dialogi.SCENA1["starszy_pan"])
	dodaj_rozmowce(postac("gosc_pani", Vector2(694, 248)), Dialogi.SCENA1["elegancka_pani"])
	# ludzie w tle
	var kelner := postac("kelner", Vector2(620, 300))
	dodaj_rozmowce(kelner, Dialogi.SCENA1["kelner"])
	spacer(kelner, [Vector2(700, 300), Vector2(740, 380), Vector2(600, 400), Vector2(560, 320), Vector2(620, 300)], 34.0, 2.5)
	gada_w_tle(kelner, tlo["kelner"], 10.0)
	var maz := postac("para_pan", Vector2(700, 344))
	var zona := postac("para_pani", Vector2(736, 346))
	var para := _kolejne(Dialogi.SCENA1, "para")
	dodaj_rozmowce(maz, para)
	dodaj_rozmowce(zona, para)
	gada_w_tle(maz, tlo["para"], 6.0)
	gada_w_tle(zona, tlo["para"], 7.0)
	var dziecko := postac("dziecko", Vector2(296, 186))
	dodaj_rozmowce(dziecko, Dialogi.SCENA1["dziecko"])
	spacer(dziecko, [Vector2(296, 420), Vector2(576, 420), Vector2(576, 190), Vector2(296, 186)], 70.0, 0.6)
	gada_w_tle(dziecko, tlo["dziecko"], 6.0)
	var fotograf := postac("fotograf", Vector2(250, 420))
	dodaj_rozmowce(fotograf, Dialogi.SCENA1["fotograf"])
	_fotografuje(fotograf)
	dzwiek("gwar.ogg", -12.0, true)
	gdy_blisko(_ania, 80.0, _podsluchaj_anie)
	gdy_blisko(Vector2(282, 128), 34.0, _toaleta)
	# przedmioty ze scenariusza i jedzenie (teksty w Dialogi.SKRZYNKI)
	skrzynka(Vector2(372, 470), "stojak_programy", ["program", "numerek"], "stojak_programy")
	skrzynka(Vector2(740, 132), "bufet", ["kawa"])
	skrzynka(Vector2(600, 126), "apteczka", [], "apteczka", 46.0)
	zamkniete_drzwi(Rect2(392, 108, 96, 34), Dialogi.DRZWI["foyer_widownia"])
	zamkniete_drzwi(Rect2(396, 470, 88, 40), Dialogi.DRZWI["foyer_wyjscie"])
	zamkniete_drzwi(TOALETY, Dialogi.DRZWI["foyer_toalety"])
	zamkniete_drzwi(DRZWI, Dialogi.DRZWI["foyer_personel"])
	await plansza("Foyer, 18:30")
	await rozmowa(Dialogi.SCENA1["poczatek"])
	pomoc_klawiszy()
	await get_tree().create_timer(35.0).timeout
	dzwiek("dzwonek.wav", -4.0)
	komunikat(tlo["dzwonek"])


## Pierwsza rozmowa z kwestii "<kto>", każda kolejna z "<kto>_potem".
func _kolejne(teksty: Dictionary, kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		await rozmowa(teksty[kto if stan.pierwsza else kto + "_potem"])
		stan.pierwsza = false


## Fotograf co jakiś czas błyska fleszem, gdy Antoni jest w pobliżu.
func _fotografuje(fotograf: Node2D) -> void:
	while not koniec:
		await get_tree().create_timer(randf_range(9.0, 15.0)).timeout
		if wolny() and odleglosc(antoni.position, fotograf.position) < 220.0:
			blysk()


func _zgubiony_bilet() -> void:
	_wie_o_bilecie = true
	if not _bileterka_ok:
		zamkniete_drzwi(DRZWI, Dialogi.DRZWI["foyer_personel_2"])


func _toaleta() -> void:
	antoni.stan("gora")
	if _wie_o_bilecie or Ekwipunek.ma("bilet"):
		await rozmowa(Dialogi.SCENA1["toaleta_znowu"])
		return
	await rozmowa(Dialogi.SCENA1["toaleta"])
	_zgubiony_bilet()


func _rozmowa_z_bileterka() -> void:
	if _bileterka_ok:
		await rozmowa(Dialogi.SCENA1["bileterka_potem"])
	elif not _bileterka_zna:
		_bileterka_zna = true
		await rozmowa(Dialogi.SCENA1["bileterka_bez_biletu"])
		_zgubiony_bilet()
		if Ekwipunek.ma("bilet"):
			await _pokaz_bilet()
	elif Ekwipunek.ma("bilet"):
		await _pokaz_bilet()
	else:
		await rozmowa(Dialogi.SCENA1["bileterka_czeka"])


func _pokaz_bilet() -> void:
	await rozmowa(Dialogi.SCENA1["bileterka_z_biletem"])
	_bileterka_ok = true
	ustaw_wyjscie(DRZWI, "Drzwi służbowe", NASTEPNA)


func _rozmowa_z_szatniarzem() -> void:
	if _plaszcz:
		await rozmowa(Dialogi.SCENA1["szatniarz_potem"])
	elif Ekwipunek.ma("numerek") and _wie_o_bilecie:
		await rozmowa(Dialogi.SCENA1["szatniarz_z_numerkiem"])
		_plaszcz = true
		Ekwipunek.dodaj("bilet")
		znajdz_kase(20)
	elif not _wie_o_bilecie:
		await rozmowa(Dialogi.SCENA1["szatniarz_zwykly"])
	elif not _szatniarz_zna:
		_szatniarz_zna = true
		await rozmowa(Dialogi.SCENA1["szatniarz_bez_numerka"])
	else:
		await rozmowa(Dialogi.SCENA1["szatniarz_czeka"])


func _podsluchaj_anie() -> void:
	antoni.sterowanie = false
	antoni.stan("gora")
	await dialog.pokaz(Dialogi.SCENA1["ania_telefon"])
	# Ania znika za drzwiami służbowymi
	await przesun(_ania, Vector2(214, 128), 0.8)
	var tw := create_tween()
	tw.tween_property(_ania, "modulate:a", 0.0, 0.4)
	await tw.finished
	_ania.queue_free()
	await dialog.pokaz(Dialogi.SCENA1["antoni_po_ani"])
	# samouczek notesu: gracz sam zapisuje, co usłyszał
	Notatnik.wlacz()
	await Notatnik.samouczek(Dialogi.NOTES["samouczek"])
	await dialog.pokaz(Dialogi.SCENA1["antoni_po_notesie"])
	antoni.sterowanie = true
