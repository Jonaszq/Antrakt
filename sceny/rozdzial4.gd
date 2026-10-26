class_name Rozdzial4
## Przejścia między scenami rozdziału 4: środa (gabinet Lisa jest opcjonalny), czwartek po
## scenie 19 (garderoba Ani, sejf Wolskiego, jeśli wczoraj Antoniego przyłapano) i obiad
## u Oli raz na dzień (godzina w plecy, ale Ola daje pieniądze na taksówki).
## Każdy przejazd: taksówka za Gra.TAKSOWKA zł albo autobus (DOJAZD minut w plecy).
## Teksty w Dialogi.CZWARTEK, Dialogi.OLA i Dialogi.DOJAZD.

const GABINET := "res://sceny/scena16/scena16.tscn"
const MIESZKANIE := "res://sceny/scena17/scena17.tscn"
const GARDEROBA_ANI := "res://sceny/scena20/scena20.tscn"
const GARDEROBA_WOLSKIEGO := "res://sceny/scena18/scena18.tscn"
const KONIEC := "res://sceny/scena20/koniec4.tscn"
const OBIAD_KASA := 50
const DOJAZD := 40
const OBIAD_CZAS := 60


## Środa po pracowni Ireny (albo po gabinecie Lisa): dokąd jechać.
static func sroda(s: ScenaGry, z_gabinetu: bool) -> String:
	while true:
		var opcje: Array = []
		var cele: Array = []
		if not z_gabinetu:
			opcje.append(Dialogi.SCENA15_DOKAD[0])
			cele.append(GABINET)
		opcje.append(Dialogi.SCENA15_DOKAD[1])
		cele.append(MIESZKANIE)
		if not Gra.flagi.get("obiad_sr", false):
			opcje.append(Dialogi.SCENA15_DOKAD_OLA)
			cele.append("ola")
		var w := await s.wybor(opcje)
		await dojazd(s)
		if cele[w] == "ola":
			await obiad(s, "obiad_sr")
			continue
		return cele[w]
	return MIESZKANIE


## Czwartek po scenie 19 i po każdej odwiedzinach: lista zależna od tego, co już było.
static func czwartek(s: ScenaGry) -> String:
	var t: Dictionary = Dialogi.CZWARTEK
	var f: Dictionary = Gra.flagi
	while true:
		var opcje: Array = []
		var cele: Array = []
		if not f.get("s20_byl", false):
			opcje.append(t["ania"])
			cele.append(GARDEROBA_ANI)
		if f.get("s18_przylapany", false) and not f.get("s18_sejf", false) and not f.get("s18_jutro_byl", false):
			opcje.append(t["wolski"])
			cele.append(GARDEROBA_WOLSKIEGO)
		if not f.get("obiad_czw", false):
			opcje.append(t["ola"])
			cele.append("ola")
		opcje.append(t["dom"])
		cele.append(KONIEC)
		s.komunikat(t["pytanie"], 2.5)
		var w := await s.wybor(opcje)
		if cele[w] != KONIEC:
			await dojazd(s)
		if cele[w] == "ola":
			await obiad(s, "obiad_czw")
			continue
		if cele[w] == GARDEROBA_WOLSKIEGO:
			f["s18_jutro"] = true
		return cele[w]
	return KONIEC


## Przejazd na drugi koniec miasta: taksówka (pieniądze) albo autobus (czas śledztwa).
static func dojazd(s: ScenaGry) -> void:
	var t: Dictionary = Dialogi.DOJAZD
	if Gra.kasa < Gra.TAKSOWKA:
		s.komunikat(t["brak"] % Gra.kasa, 3.0)
		Sledztwo.strata(DOJAZD)
		return
	if await s.wybor([t["taksowka"] % [Gra.TAKSOWKA, Gra.kasa], t["autobus"] % DOJAZD]) == 0:
		Gra.dodaj_kase(-Gra.TAKSOWKA)
		Gra.flagi["taksowki"] = true
	else:
		Sledztwo.strata(DOJAZD)


## Obiad u Oli. Co mówi Ola, zależy od stanu Antoniego.
static func obiad(s: ScenaGry, flaga: String) -> void:
	var t: Dictionary = Dialogi.OLA
	var f: Dictionary = Gra.flagi
	s.antoni.sterowanie = false
	await s.rozmowa(t["start"])
	if Sledztwo.stracone() > 200:
		await s.rozmowa(t["slaby"])
	if f.get("s12_dotknal", false) or f.get("s20_dotknal", false):
		await s.rozmowa(t["palce"])
	var obrazeni := Gra.obrazeni()
	if not obrazeni.is_empty():
		var kto := ", ".join(obrazeni)
		await s.rozmowa(t["obrazeni"].map(func(r): return [r[0], r[1].replace("{kto}", kto)]))
	await s.rozmowa(t["ania"] if f.get("s17_sms", false) else t["bilet"])
	await s.rozmowa(t["koniec"])
	s.znajdz_kase(OBIAD_KASA)
	Sledztwo.strata(OBIAD_CZAS)
	f[flaga] = true
