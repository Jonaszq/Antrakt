class_name Rozdzial4
## Przejścia między scenami rozdziału 4: środa (gabinet Lisa jest opcjonalny), czwartek po
## scenie 19 (garderoba Ani, sejf Wolskiego, jeśli wczoraj Antoniego przyłapano) i obiad
## u Oli raz na dzień (+40 sił, godzina w plecy). Teksty w Dialogi.CZWARTEK i Dialogi.OLA.

const GABINET := "res://sceny/scena16/scena16.tscn"
const MIESZKANIE := "res://sceny/scena17/scena17.tscn"
const GARDEROBA_ANI := "res://sceny/scena20/scena20.tscn"
const GARDEROBA_WOLSKIEGO := "res://sceny/scena18/scena18.tscn"
const KONIEC := "res://sceny/scena20/koniec4.tscn"
const OBIAD_SILY := 40
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
		if cele[w] == "ola":
			await obiad(s, "obiad_czw")
			continue
		if cele[w] == GARDEROBA_WOLSKIEGO:
			f["s18_jutro"] = true
		return cele[w]
	return KONIEC


## Obiad u Oli. Co mówi Ola, zależy od stanu Antoniego.
static func obiad(s: ScenaGry, flaga: String) -> void:
	var t: Dictionary = Dialogi.OLA
	var f: Dictionary = Gra.flagi
	s.antoni.sterowanie = false
	await s.rozmowa(t["start"])
	if Gra.sily < 40:
		await s.rozmowa(t["slaby"])
	if f.get("s12_dotknal", false) or f.get("s20_dotknal", false):
		await s.rozmowa(t["palce"])
	await s.rozmowa(t["ania"] if f.get("s17_sms", false) else t["bilet"])
	await s.rozmowa(t["koniec"])
	Gra.dodaj_sily(OBIAD_SILY)
	Sledztwo.strata(OBIAD_CZAS)
	if not Ekwipunek.ma("zupa"):
		Ekwipunek.dodaj("zupa")
	f[flaga] = true
