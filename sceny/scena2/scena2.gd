extends ScenaGry
## Scena 2: kulisy, sobota 18:50. Antoni szukał toalety i trafił za scenę.
## Dyrektor Lis panikuje, bo dubler Adrian zniknął, a Wolski żartuje i wszystkich
## uspokaja (pierwsze wrażenie: ciepły, zabawny). Inspicjentka Marta odsyła
## Antoniego na widownię. Dalej będzie scena 3 (spektakl), na razie wyjście
## prowadzi na mapę widowni.

const WYJSCIE := Rect2(352, 424, 80, 50)
const NASTEPNA := "res://mapy/widownia/widownia.tscn"

var _lis: Node2D
var _wolski: Node2D
var _marta: Node2D
var _poznal_dyrekcje := false
var _poznal_marte := false


func _ready() -> void:
	przygotuj($Kulisy)
	Telefon.godzina = "18:51"
	antoni.stan("gora")
	_marta = obiekty.get_node("Marta")
	_lis = postac("bogdan", Vector2(560, 196))
	_wolski = postac("wolski", Vector2(604, 192))
	gdy_blisko(Vector2(582, 194), 130.0, _klotnia)
	dodaj_rozmowce(_marta, _rozmowa_z_marta)
	await plansza("Kulisy, 18:50")
	antoni.sterowanie = false
	await dialog.pokaz([
		["Antoni", "Ciemno tu jak w grobie. To na pewno nie jest toaleta."],
		["", "Wskazówka: pod Tab możesz wziąć Antoniego z latarnią, który lepiej widzi w ciemności."],
	])
	antoni.sterowanie = true


func _klotnia() -> void:
	antoni.sterowanie = false
	zwroc_sie(_lis)
	await dialog.pokaz([
		["Lis", "Dwadzieścia lat prowadzę ten teatr i jeszcze nigdy dubler nie zniknął w dzień premiery!"],
		["Lis", "Adam, jeśli ty mi dziś padniesz na scenie, to premiera wisi na włosku. Nie mam nikogo!"],
		["Wolski", "Bogdan, spokojnie. Zagram za dwóch, a Adrian pewnie odsypia stres."],
		["Lis", "Odsypia! Od wczoraj nie odbiera telefonu!"],
		["Wolski", "(z uśmiechem, do Antoniego) Zgubił się pan? Proszę, oto moje królestwo."],
		["Antoni", "Szukałem toalety. Chyba zaszedłem trochę za daleko."],
		["Wolski", "Ha! Najciekawsze rzeczy w teatrze dzieją się tam, gdzie widzom nie wolno wchodzić. Adam Wolski."],
		["Antoni", "Antoni. Z wydziału kryminalnego, ale dziś tylko jako widz."],
		["Lis", "Policja? Tylko tego brakowało... Bogdan Lis, dyrektor. Proszę wybaczyć, mamy drobny kryzys."],
		["Wolski", "Bogdan zawsze ma kryzys. Proszę się nie przejmować i zostać na bankiet. Stawiam wino."],
	])
	Notatnik.dodaj("Dubler Adrian nie odbiera od wczoraj. Dyrektor Lis w panice.")
	_poznal_dyrekcje = true
	dodaj_rozmowce(_lis, [
		["Lis", "Niech pan wraca na widownię, dobrze? Jeszcze tylko policji za kulisami mi brakowało."],
	])
	dodaj_rozmowce(_wolski, [
		["Wolski", "Gorączka? Ech, było, minęło. Teatr leczy lepiej niż aspiryna."],
		["Wolski", "Tylko kostium mam nowy, stary jest w pralni. Ten drapie jak diabli."],
	])
	_otworz_wyjscie()
	antoni.sterowanie = true


func _rozmowa_z_marta() -> void:
	if _poznal_marte:
		await rozmowa([["Marta", "Toaleta w foyer, po lewej od szatni. Proszę już iść, za chwilę trzeci dzwonek."]])
		return
	_poznal_marte = true
	await rozmowa([
		["Marta", "Hej! Pan tu nie może być. Za dziesięć minut podnosimy kurtynę."],
		["Antoni", "Szukam toalety."],
		["Marta", "W foyer, po lewej od szatni. Ma pan szczęście, że to nie środek spektaklu."],
		["Marta", "Marta, inspicjentka. Jak ktoś się tu gubi, to potem ja tego kogoś szukam. Proszę za mną nie łazić."],
	])
	_otworz_wyjscie()


func _otworz_wyjscie() -> void:
	if _poznal_dyrekcje and _poznal_marte:
		ustaw_wyjscie(WYJSCIE, "Wróć na widownię", NASTEPNA)
		Notatnik.dodaj("Wolski gra w nowym kostiumie, stary jest w pralni.")
