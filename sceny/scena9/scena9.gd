extends ScenaGry
## Scena 9 (rozdział 3): niedziela 11:00, foyer teatru w żałobie. Zdjęcie Adriana ze
## świeczką, aktorzy w ciszy, sprzątaczka, bufetowa (kanapka, przesłuchanie) i apteczka
## z rękawiczkami, którą gracz musi sam znaleźć. Drzwi PERSONEL prowadzą do gabinetu
## Lisa (gabinet.tscn), gdzie leży kwit z pralni. Bez kwitu Antoni nie wychodzi z teatru.
## Stan między foyer a gabinetem w Gra.flagi (s9_*). Teksty w Dialogi.SCENA9.

const GABINET := "res://sceny/scena9/gabinet.tscn"
const NASTEPNA := "res://menu/menu.tscn"  # scena 10 (pralnia) jeszcze nie zrobiona
const PERSONEL := Rect2(190, 106, 48, 38)
const WYJSCIE := Rect2(396, 470, 88, 40)
const LADA_BUFETU := Rect2(684, 96, 172, 30)
const ZDJECIE := Vector2(560, 200)


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "11:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA9
	var tlo: Dictionary = Dialogi.SCENA9_TLO
	var f: Dictionary = Gra.flagi
	obiekty.get_node("Ania").queue_free()  # Ania jest dziś w gabinecie Lisa
	if f.get("s9_z_gabinetu", false):
		antoni.position = Vector2(214, 160)
		antoni.stan("dol")
	else:
		antoni.position = Vector2(440, 460)
		antoni.stan("gora")
	# żałoba: zdjęcie ze świeczką i czarna wstążka przy wejściu
	var zdjecie := rekwizyt("zdjecie_zalobne", ZDJECIE)
	dodaj_rozmowce(zdjecie, _kolejne("zdjecie"), "Zdjęcie Adriana", 50.0)
	var wstazka := rekwizyt("wstazka_czarna", Vector2(500, 492), 20.0)
	dodaj_rozmowce(wstazka, t["wstazka"], "Wstążka", 44.0)
	var aktor := postac("aktor", Vector2(120, 300))
	dodaj_rozmowce(aktor, _kolejne("aktor"))
	gada_w_tle(aktor, tlo["aktor"], 14.0)
	var aktorka := postac("aktorka", Vector2(124, 420))
	dodaj_rozmowce(aktorka, _kolejne("aktorka"))
	gada_w_tle(aktorka, tlo["aktorka"], 11.0)
	var sprzataczka := postac("sprzataczka", Vector2(400, 330))
	dodaj_rozmowce(sprzataczka, _kolejne("sprzataczka"))
	gada_w_tle(sprzataczka, tlo["sprzataczka"], 9.0)
	spacer(sprzataczka, [Vector2(400, 330), Vector2(480, 330), Vector2(480, 250), Vector2(400, 250)], 12.0, 3.0)
	_bufet()
	skrzynka(Vector2(600, 126), "apteczka_s9", ["rekawiczki"], "apteczka", 46.0)
	ustaw_wyjscie(PERSONEL, "Do gabinetu dyrektora", GABINET)
	if Ekwipunek.ma("kwit_odbioru"):
		ustaw_wyjscie(WYJSCIE, "Do pralni", NASTEPNA)
	else:
		zamkniete_drzwi(WYJSCIE, t["wyjscie_bez_kwitu"][0][1])
	dzwiek("gramofon.ogg", -24.0, true)  # radio w bufecie gra cicho muzykę klasyczną
	if f.get("s9_z_gabinetu", false):
		await rozjasnij()
	else:
		await plansza("Niedziela, 11:00. Teatr")
		await rozmowa(t["poczatek"])
	if not f.get("s9_stasia", false):
		_stasia()


## Pani Stasia przynosi goździki pod zdjęcie Adriana.
func _stasia() -> void:
	await get_tree().create_timer(25.0).timeout
	if koniec:
		return
	Gra.flagi["s9_stasia"] = true
	var stasia := postac("stasia", Vector2(440, 500))
	dodaj_rozmowce(stasia, Dialogi.SCENA9["stasia"])
	await idz(stasia, [Vector2(440, 260), ZDJECIE + Vector2(-26, 14)], 26.0)
	komunikat(Dialogi.SCENA9["stasia_idzie"], 3.0)
	await get_tree().create_timer(6.0).timeout
	dymek(stasia, "(modli się po cichu)", 3.0)


func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		var klucz := kto if stan.pierwsza or not Dialogi.SCENA9.has(kto + "_potem") else kto + "_potem"
		await rozmowa(Dialogi.SCENA9[klucz])
		stan.pierwsza = false


## Bufetowa za ladą (przód lady wycięty z tła, jak w antrakcie).
func _bufet() -> void:
	var bufetowa := postac("bufetowa", Vector2(770, 112))
	var lada := Sprite2D.new()
	var wycinek := AtlasTexture.new()
	wycinek.atlas = $Foyer/Tlo.texture
	wycinek.region = LADA_BUFETU
	lada.texture = wycinek
	lada.centered = false
	lada.position = LADA_BUFETU.position + Vector2(0, LADA_BUFETU.size.y)
	lada.offset = Vector2(0, -LADA_BUFETU.size.y)
	obiekty.add_child(lada)
	gada_w_tle(bufetowa, Dialogi.SCENA9_TLO["bufetowa"], 13.0)
	miejsce(Vector2(770, 132), "Bufet", _rozmowa_z_bufetowa, 74.0)


func _rozmowa_z_bufetowa() -> void:
	var t: Dictionary = Dialogi.SCENA9
	if not Gra.flagi.get("s9_kanapka", false):
		Gra.flagi["s9_kanapka"] = true
		await rozmowa(t["bufetowa_start"])
		Ekwipunek.dodaj("kanapka")
	var tematy := [
		["Był tu w czwartek?", t["bufetowa_czwartek"]],
		["Kto bywa w teatrze rano?", t["bufetowa_rano"]],
		["Jak się pani trzyma?", t["bufetowa_jak"]],
	]
	await przesluchanie(tematy, Dialogi.SCENA9_DOWODY["bufetowa"], t["bufetowa_nic"], t["bufetowa_koniec"])


## Scena 10 jeszcze nie istnieje: napis i powrót do menu.
func przejdz(scena: String) -> void:
	koniec = true
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.0)
	await tw.finished
	var napis := etykieta(12, Color8(170, 160, 140))
	napis.text = Dialogi.SCENA9_NAPISY["dalej"]
	napis.position = Vector2(0, 124)
	napis.size = Vector2(480, 20)
	napis.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui.add_child(napis)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file(scena)
