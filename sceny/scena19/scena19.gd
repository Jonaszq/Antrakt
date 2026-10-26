extends ScenaGry
## Scena 19 (rozdział 4): foyer i bufet, czwartek 10:00. Marta zapytana o poranki
## w pracowni przypomina sobie Anię o ósmej, "chyba w piątek" (s19_marta), a dopytana
## o skrzynki, o które się potknęła (s19_szczegoly). Skrzynki po mleku stoją pod drzwiami
## PERSONEL, w dolnej grafik dostaw (czwartki). Grafik pokazany Marcie po jej szczegółach
## daje kartę "marta_grafik". Kuba otwiera się, jeśli Antoni widział go na klatce (s17_kuba)
## albo pokaże mu kartę kwitu: wtedy kwit na garnitur (karta "garnitur") i casting
## (karta "casting"). Teksty w Dialogi.SCENA19.

const NASTEPNA := "res://sceny/retrospekcje/retro5.tscn"
const WYJSCIE := Rect2(396, 470, 88, 40)
const LADA_BUFETU := Rect2(684, 96, 172, 30)
const SKRZYNKI := Vector2(262, 168)


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "10:00"
	Notatnik.wlacz()
	Gra.flagi["dni_do_pogrzebu"] = 1
	var t: Dictionary = Dialogi.SCENA19
	var tlo: Dictionary = Dialogi.SCENA19_TLO
	var ania := obiekty.get_node_or_null("Ania")
	if ania:
		ania.queue_free()  # Ania jest na próbie
	antoni.position = Vector2(440, 440)
	antoni.stan("gora")
	var zdjecie := rekwizyt("zdjecie_zalobne", Vector2(560, 200))
	dodaj_rozmowce(zdjecie, t["zdjecie"], "Zdjęcie Adriana", 50.0)
	var skrzynki := rekwizyt("skrzynki_mleko", SKRZYNKI)
	dodaj_rozmowce(skrzynki, _skrzynki, "Skrzynki", 44.0)
	var marta := postac("marta", Vector2(340, 200))
	dodaj_rozmowce(marta, _rozmowa_z_marta)
	gada_w_tle(marta, tlo["marta"], 10.0)
	var kuba := postac("gosc_student", Vector2(120, 300))
	dodaj_rozmowce(kuba, _rozmowa_z_kuba)
	gada_w_tle(kuba, tlo["kuba"], 8.0)
	var aktor := postac("aktor", Vector2(600, 260))
	dodaj_rozmowce(aktor, t["aktor"])
	gada_w_tle(aktor, tlo["aktorzy"], 9.0)
	var aktorka := postac("aktorka", Vector2(650, 270))
	dodaj_rozmowce(aktorka, t["aktorka"])
	var dostawca := postac("maszynista", Vector2(440, 460))
	dodaj_rozmowce(dostawca, t["dostawca"])
	gada_w_tle(dostawca, tlo["dostawca"], 10.0)
	spacer(dostawca, [Vector2(440, 300), Vector2(700, 170), Vector2(440, 300), Vector2(440, 460)], 38.0, 2.5)
	_bufet()
	ustaw_wyjscie(WYJSCIE, "Wyjdź", NASTEPNA)
	dzwiek("gwar.ogg", -20.0, true)
	await plansza(t["plansza"])
	await rozmowa(t["poczatek"])


func _bufet() -> void:
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
	miejsce(Vector2(770, 132), "Bufet", _rozmowa_z_bufetowa, 74.0)


func _skrzynki() -> void:
	var t: Dictionary = Dialogi.SCENA19
	if Ekwipunek.ma("grafik"):
		await rozmowa(t["skrzynki_potem"])
		return
	await rozmowa(t["skrzynki"])
	await rozmowa(t["grafik"])
	Ekwipunek.dodaj("grafik")
	Gra.flagi["s19_skrzynki"] = true


func _rozmowa_z_marta() -> void:
	var t: Dictionary = Dialogi.SCENA19
	var f: Dictionary = Gra.flagi
	await rozmowa(t["marta_znowu" if f.get("s19_marta_zagadal", false) else "marta_start"])
	f["s19_marta_zagadal"] = true
	var tematy := [
		["Kto przychodzi rano do pracowni?", temat("s19_marta", t["marta_pracownia"])],
		["Pamiętasz coś jeszcze z tamtego rana?", temat("s19_szczegoly", t["marta_szczegoly"]), func() -> bool: return f.get("s19_marta", false)],
		["Kto ma klucz do pracowni?", t["marta_klucz"]],
	]
	var dowody := {"grafik": _grafik, "karta_kwit": t["marta_podpis"], "karta_podpis": t["marta_podpis"]}
	await przesluchanie(tematy, dowody, t["marta_nic"], t["marta_koniec"])


## Grafik działa dopiero, gdy Marta opowiedziała o skrzynkach.
func _grafik() -> void:
	var t: Dictionary = Dialogi.SCENA19
	if not Gra.flagi.get("s19_szczegoly", false):
		await rozmowa(t["marta_grafik_bez"])
		return
	await rozmowa(t["marta_grafik"])
	Gra.flagi["s19_czwartek"] = true
	Teczka.dodaj("marta_grafik")


func _rozmowa_z_bufetowa() -> void:
	var t: Dictionary = Dialogi.SCENA19
	var f: Dictionary = Gra.flagi
	if not f.get("s19_kawa", false):
		f["s19_kawa"] = true
		await rozmowa(t["bufetowa_start"])
		await rozmowa(t["bufetowa_kawa"])
		Ekwipunek.dodaj("kawa")
	var tematy := [
		["Kiedy przychodzi mleko?", temat("s19_mleko", t["bufetowa_mleko"]), func() -> bool: return f.get("s19_skrzynki", false)],
	]
	await przesluchanie(tematy, {}, t["bufetowa_nic"], t["bufetowa_koniec"])


func _otwarty() -> bool:
	return Gra.flagi.get("s17_kuba", false) or Gra.flagi.get("s19_kuba_otwarty", false)


func _rozmowa_z_kuba() -> void:
	var t: Dictionary = Dialogi.SCENA19
	var f: Dictionary = Gra.flagi
	if not _otwarty():
		await rozmowa(t["kuba_ucieka"])
	elif f.get("s19_kuba_zagadal", false):
		await rozmowa(t["kuba_znowu"])
	else:
		await rozmowa(t["kuba_start"])
		f["s19_kuba_zagadal"] = true
	var tematy := [
		["Co robiłeś w mieszkaniu Adriana?", temat("s19_kuba_scenariusz", t["kuba_mieszkanie"]), func() -> bool: return f.get("s17_kuba", false)],
		["Gdzie byłeś w czwartek rano?", _czwartek],
		["Znasz całą rolę Wolskiego", t["kuba_wolski"], func() -> bool: return f.get("s3_kuba", false)],
	]
	var dowody := {"karta_kwit": _kwit, "kwit_odbioru": _kwit}
	await przesluchanie(tematy, dowody, t["kuba_nic"], t["kuba_koniec"])


func _czwartek() -> void:
	var t: Dictionary = Dialogi.SCENA19
	if not _otwarty():
		await rozmowa(t["kuba_czwartek_zly"])
		return
	await rozmowa(t["kuba_czwartek"])
	Gra.flagi["s19_casting"] = true
	Teczka.dodaj("casting")


func _kwit() -> void:
	await rozmowa(Dialogi.SCENA19["kuba_kwit"])
	Gra.flagi["s19_kuba_otwarty"] = true
	Gra.flagi["s19_garnitur"] = true
	Teczka.dodaj("garnitur")
