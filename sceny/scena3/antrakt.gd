extends ScenaGry
## Scena 3, antrakt: foyer, sobota około 20:10, między aktami.
## Kolejka do bufetu, bufetowa sprzedaje kawę i kanapkę (pierwsza okazja, żeby
## coś zjeść albo wypić), widzowie komentują pierwszy akt, ktoś rozlał wino,
## szatniarz drzemie. Przy drzwiach do toalet Antoni widzi płaczącą Anię, która
## chowa telefon. Po chwili drugi dzwonek i drzwiami WIDOWNIA wraca na drugi akt.
## Teksty w Dialogi.ANTRAKT.

const WIDOWNIA := Rect2(392, 108, 96, 34)
const NASTEPNA := "res://sceny/scena3/scena3_akt2.tscn"
const LADA_BUFETU := Rect2(684, 96, 172, 30)  # przód lady wycięty z tła, zasłania nogi bufetowej

var _ania: Node2D
var _bileterka: Node2D
var _dzwonek := false


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "20:10"
	var t: Dictionary = Dialogi.ANTRAKT
	var tlo: Dictionary = Dialogi.ANTRAKT_TLO
	antoni.position = Vector2(440, 196)
	antoni.stan("dol")
	_ania = obiekty.get_node("Ania")
	_ania.position = Vector2(282, 140)
	gdy_blisko(_ania, 70.0, _ania_placze)
	_bileterka = postac("bileterka", Vector2(398, 150))
	dodaj_rozmowce(_bileterka, func() -> void:
		await rozmowa(t["bileterka_po_dzwonku" if _dzwonek else "bileterka"]))
	_bufet()
	# widzowie komentują pierwszy akt
	var zawada := postac("zawada", Vector2(626, 206))
	dodaj_rozmowce(zawada, _kolejne("zawada"))
	gada_w_tle(zawada, tlo["zawada"], 8.0)
	var stasia := postac("stasia", Vector2(196, 252))
	dodaj_rozmowce(stasia, _kolejne("stasia"))
	gada_w_tle(stasia, tlo["stasia"], 7.0)
	dodaj_rozmowce(postac("gosc_student", Vector2(170, 330)), _kolejne("kuba"))
	# rozlane wino
	rekwizyt("plama_wina", Vector2(600, 336))
	var maz := postac("para_pan", Vector2(578, 326))
	var zona := postac("para_pani", Vector2(624, 328))
	var pan := postac("gosc_pan", Vector2(548, 352))
	var wino := _kolejne("wino")
	for kto in [maz, zona, pan]:
		dodaj_rozmowce(kto, wino)
	gada_w_tle(zona, tlo["para"], 6.0)
	gada_w_tle(maz, tlo["para"], 8.0)
	# szatniarz drzemie za ladą
	var szatniarz := postac("szatniarz", Vector2(848, 288))
	miejsce(Vector2(790, 288), "Szatnia", t["szatniarz"], 74.0)
	gada_w_tle(szatniarz, tlo["szatniarz"], 4.0)
	var fotograf := postac("fotograf", Vector2(250, 420))
	dodaj_rozmowce(fotograf, t["fotograf"])
	_fotografuje(fotograf)
	var kelner := postac("kelner", Vector2(620, 420))
	dodaj_rozmowce(kelner, Dialogi.SCENA1["kelner"])
	spacer(kelner, [Vector2(480, 420), Vector2(330, 440), Vector2(480, 420), Vector2(620, 420)], 34.0, 3.0)
	skrzynka(Vector2(600, 126), "apteczka", ["tabletki"], "apteczka", 46.0)
	zamkniete_drzwi(WIDOWNIA, Dialogi.DRZWI["antrakt_widownia"])
	zamkniete_drzwi(Rect2(396, 470, 88, 40), Dialogi.DRZWI["antrakt_wyjscie"])
	zamkniete_drzwi(Rect2(264, 108, 36, 34), Dialogi.DRZWI["antrakt_toalety"])
	zamkniete_drzwi(Rect2(190, 106, 48, 38), Dialogi.DRZWI["antrakt_personel"])
	dzwiek("gwar.ogg", -9.0, true)
	await plansza("Antrakt, 20:10")
	await rozmowa(t["poczatek"])


## Bufetowa za ladą i kolejka przed nią.
func _bufet() -> void:
	var t: Dictionary = Dialogi.ANTRAKT
	postac("bufetowa", Vector2(770, 112))
	var lada := Sprite2D.new()
	var wycinek := AtlasTexture.new()
	wycinek.atlas = $Foyer/Tlo.texture
	wycinek.region = LADA_BUFETU
	lada.texture = wycinek
	lada.centered = false
	lada.position = LADA_BUFETU.position + Vector2(0, LADA_BUFETU.size.y)
	lada.offset = Vector2(0, -LADA_BUFETU.size.y)
	obiekty.add_child(lada)
	var stan := {"kupil": false}
	miejsce(Vector2(770, 132), "Bufet", func() -> void:
		if stan.kupil:
			await rozmowa(t["bufet_potem"])
			return
		stan.kupil = true
		await rozmowa(t["bufet"])
		if Ekwipunek.ma("monety"):
			Ekwipunek.usun("monety")
			await rozmowa(t["bufet_place"])
		else:
			await rozmowa(t["bufet_na_kreske"])
		Ekwipunek.dodaj("kawa")
		Ekwipunek.dodaj("kanapka"), 74.0)
	var kolejka := [postac("gosc_pani", Vector2(712, 150)), postac("dziecko", Vector2(712, 178))]
	for kto in kolejka:
		gada_w_tle(kto, Dialogi.ANTRAKT_TLO["kolejka"], 7.0)
	dodaj_rozmowce(kolejka[0], [["Elegancka pani", "Kolejka jest, proszę pana. Ja też chcę kawę."]])
	dodaj_rozmowce(kolejka[1], [["Chłopiec", "Mama poszła siku, a ja pilnuję kolejki."]])


## Pierwsza rozmowa z kwestii "<kto>", każda kolejna z "<kto>_potem".
func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		await rozmowa(Dialogi.ANTRAKT[kto if stan.pierwsza else kto + "_potem"])
		stan.pierwsza = false


func _fotografuje(fotograf: Node2D) -> void:
	while not koniec:
		await get_tree().create_timer(randf_range(9.0, 15.0)).timeout
		if wolny() and odleglosc(antoni.position, fotograf.position) < 220.0:
			blysk()


func _ania_placze() -> void:
	antoni.sterowanie = false
	zwroc_sie(_ania)
	await dialog.pokaz(Dialogi.ANTRAKT["ania_placze"])
	# Ania odchodzi za kulisy drzwiami PERSONEL
	await przesun(_ania, Vector2(214, 128), 0.9)
	var tw := create_tween()
	tw.tween_property(_ania, "modulate:a", 0.0, 0.4)
	await tw.finished
	_ania.queue_free()
	await dialog.pokaz(Dialogi.ANTRAKT["po_ani"])
	antoni.sterowanie = true
	await get_tree().create_timer(6.0).timeout
	_dzwonek = true
	dzwiek("dzwonek.wav", -4.0)
	komunikat(Dialogi.ANTRAKT_TLO["dzwonek"])
	ustaw_wyjscie(WIDOWNIA, "Na widownię", NASTEPNA)
