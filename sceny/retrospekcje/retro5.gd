extends RetroBaza
## Retrospekcja 5 (po scenie 19): czwartek 8:00 w pracowni. Czarna sylwetka przy kostiumie
## na stojaku. Dzień pewny tylko ze sprawdzoną kartą "marta_grafik"; Marta potyka się
## o skrzynki tylko, jeśli o nich opowiedziała (s19_szczegoly); rękawiczki i pędzelek
## wzdłuż szwów tylko z kartą "rekawiczki" albo UV/szwami z rozdz. 3. Przymierzanie
## (kontekst "pracownia"), potem noc przy pralni: Kuba o 23:10 tylko z kartą "garnitur".
## Na koniec wybór, co dalej w czwartek (Rozdzial4.czwartek). Teksty w Dialogi.RETRO5.

const DRZWI := Vector2(52, 150)
const STOJAK := Vector2(112, 262)


func _ready() -> void:
	przygotuj_retro($Pracownia, Vector2(800, 480), Vector2(240, 240), Color(0.55, 0.52, 0.5))
	var r: Dictionary = Dialogi.RETRO5
	var f: Dictionary = Gra.flagi
	var kto := postac("ania", DRZWI)
	kto.modulate = SYLWETKA
	await plansza(r["tytul_czwartek"] if Teczka.sprawdzona("marta_grafik") else r["tytul_niewiadomo"])
	antoni.sterowanie = false
	await idz(kto, [Vector2(60, 200), STOJAK + Vector2(30, 0)], 26.0)
	await dymek(kto, r["sylwetka"], 3.0)
	if Teczka.sprawdzona("rekawiczki"):
		await dymek(kto, r["rekawiczki"], 2.5)
	if f.get("s11_szwy", false) or f.get("s12_uv", false):
		await dymek(kto, r["podszewka"], 3.0)
	if f.get("s19_szczegoly", false):
		var skrzynki := rekwizyt("skrzynki_mleko", Vector2(90, 190))
		var marta := postac("marta", Vector2(52, 120))
		await idz(marta, [Vector2(70, 180)], 40.0)
		await dymek(marta, r["marta"], 2.0)
		await dymek(marta, r["marta_widzi"], 2.5)
		await idz(marta, [Vector2(52, 120)], 40.0)
		marta.queue_free()
		skrzynki.visible = true
	await przymierz(kto, "pracownia")
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.2)
	await tw.finished
	for n in _noc():
		komunikat(n, 3.5)
		await get_tree().create_timer(4.0).timeout
	super.przejdz(await Rozdzial4.czwartek(self))


func _noc() -> Array:
	var r: Dictionary = Dialogi.RETRO5
	var wynik := [r["noc"]]
	if Teczka.sprawdzona("garnitur"):
		wynik.append(r["kuba"])
	wynik.append(r["kostium"])
	return wynik
