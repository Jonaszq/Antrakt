extends ScenaGry
## Scena 22 (rozdział 5): pusta scena, piątek 9:00. Przychodzi osoba, do której Antoni
## wysłał SMS-a w scenie 21 (Gra.flagi["oskarzony"]) i siada na krześle ofiary.
## Ania: rundy z Dialogi.SCENA22["rundy"]. Przy każdym kłamstwie gracz wybiera argument
## (Sledztwo.argumenty): mocny przechodzi, słaby też, ale co drugi słaby liczy się jako
## błąd, zły to błąd. Szans jest 3 minus każde pytanie z tablicy, którego Antoni nie
## przypiął. Ania łamie się przy SMS-ie,
## potem ostatnia retrospekcja i brawa (scena 23).
## Inna osoba: z alibi znanym z teczki albo bez Nowickiego na widowni -> D, inaczej C.

const RETRO := "res://sceny/retrospekcje/retro6.tscn"
const ZAKONCZENIE := "res://sceny/zakonczenia/zakonczenie.tscn"
const KRZESLO := Vector2(396, 160)
const KULISY := Vector2(660, 150)
const MIEJSCE_ANTONIEGO := Vector2(450, 196)

var _kto: Node2D


func _ready() -> void:
	przygotuj($Widownia)
	Telefon.godzina = "9:00"
	Notatnik.wlacz()
	var t: Dictionary = Dialogi.SCENA22
	var f: Dictionary = Gra.flagi
	$Widownia/Mrok.color = Color(0.42, 0.38, 0.46)
	for n in ["Wolski", "Bogdan"]:
		var w: Node2D = obiekty.get_node(n)
		w.visible = false
		w.position = Vector2(-500, -500)
	if f.get("s21_nowicki", false):
		postac("nowicki", Vector2(480, 600))
	antoni.position = MIEJSCE_ANTONIEGO
	antoni.stan("lewo")
	var oskarzony: String = f.get("oskarzony", "Ania")
	await plansza(t["plansza"])
	antoni.sterowanie = false
	await rozmowa(t["start"])
	if f.get("s21_nowicki", false):
		await rozmowa(t["nowicki_jest"])
	komunikat(t["wchodzi"], 2.5)
	_kto = postac(_folder(oskarzony), KULISY)
	await idz(_kto, [Vector2(560, 160), KRZESLO], 40.0)
	zwroc_sie(_kto)
	antoni.sterowanie = false
	if oskarzony == "Ania":
		await _ania()
	else:
		await _inna(oskarzony)


func _folder(imie: String) -> String:
	for p in Dialogi.PODEJRZANI:
		if p[0] == imie:
			return p[1]
	return "ania"


func _koniec(litera: String, powod := "") -> void:
	Gra.flagi["zakonczenie"] = litera
	Gra.flagi["powod"] = powod
	przejdz(ZAKONCZENIE)


## Antoni mówi argument na głos.
func _powiedz(arg: String) -> void:
	await rozmowa([["Antoni", Dialogi.SLEDZTWO_ARGUMENTY[arg][1]]])


func _ania() -> void:
	var t: Dictionary = Dialogi.SCENA22
	var f: Dictionary = Gra.flagi
	await rozmowa(t["ania_wchodzi"])
	if f.get("s20_przylapany", false):
		await rozmowa(t["ania_przylapany"])
	if f.get("s17_ania_sms", false):
		await rozmowa(t["ania_uciekla"])
	var szanse := 3
	for flaga in ["s21_jak", "s21_kto_mial"]:
		if not f.get(flaga, false):
			szanse -= 1
	var bledy := 0
	var slabe := 0
	for runda in t["rundy"]:
		await rozmowa(runda["klamstwo"])
		while true:
			var arg := await wybierz_argument(t["argument"], t["milcz"])
			if arg in runda["mocne"]:
				if runda["reakcja"][0][0] != "Antoni":
					await _powiedz(arg)
				await rozmowa(runda["reakcja"])
				break
			var slaby: bool = arg in runda["slabe"]
			if slaby:
				await _powiedz(arg)
				await rozmowa(t["slabe"])
				slabe += 1
				if slabe % 2 == 1:
					await rozmowa(runda["reakcja"])
					break
			else:
				if arg != "":
					await _powiedz(arg)
				await rozmowa(t["zle"].pick_random())
			bledy += 1
			Sledztwo.strata(10)
			if bledy >= szanse:
				await rozmowa(t["wychodzi"])
				await idz(_kto, [Vector2(560, 160), KULISY], 60.0)
				_koniec("D", "powod_wyszla")
				return
			if bledy == szanse - 1:
				komunikat(t["ostatnia_szansa"], 3.5)
			if slaby:
				await rozmowa(runda["reakcja"])
				break
	if f.get("s17_ania_sms", false):
		await rozmowa(t["sms_juz_wiedziala"])
	await rozmowa(t["przyznanie"])
	if f.get("s20_lustro", false) and await wybor(["Powiedz o kartce na lustrze", "Milcz"]) == 0:
		await rozmowa(t["kartka"])
		await rozmowa(t["koniec_kartka"])
		f["s22_kartka"] = true
	else:
		await rozmowa(t["koniec_bez_kartki"])
	f["s22_przyznala"] = true
	przejdz(RETRO)


func _inna(kto: String) -> void:
	var t: Dictionary = Dialogi.SCENA22
	var f: Dictionary = Gra.flagi
	var linie: Array = t["inni"][kto]
	await rozmowa(linie[0])
	await rozmowa(t["oskarzenie"])
	await rozmowa(linie[1])
	var alibi: String = Dialogi.PRZYMIERZANIE["pracownia"].get(kto, [""])[0]
	if alibi != "" and Teczka.sprawdzona(alibi):
		await rozmowa(linie[2])
		await rozmowa(t["alibi_antoni"])
		if f.get("s21_nowicki", false):
			await rozmowa(t["nowicki_odmawia"])
		_koniec("D", "powod_alibi")
	elif f.get("s21_nowicki", false):
		await rozmowa(t["nowicki_zabiera"])
		_koniec("C")
	else:
		await rozmowa(t["bez_nowickiego"])
		await idz(_kto, [Vector2(560, 160), KULISY], 60.0)
		_koniec("D", "powod_nikt_nie_zabral")
