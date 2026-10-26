class_name Sledztwo
## Rejestr śledztwa: co gracz ustalił, co stracił i ile czasu zmarnował.
## Gra nie czyta notatnika, tylko flag (Gra.flagi) i ekwipunku. Warunki to napisy:
## "f:nazwa" (flaga), "p:id" (przedmiot w ekwipunku), "k:id" (karta z teczki wpisana
## dobrze), "w:id" (wpisana, dobrze czy źle: tam, gdzie gracz nie może poznać wyniku); "!" na początku odwraca warunek. Z tego korzystają retrospekcje,
## konfrontacja w finale (Dialogi.SLEDZTWO_ARGUMENTY) i epilog (Dialogi.SLEDZTWO_EPILOG).


## Na czas argumenty(): "k:" znaczy wtedy "karta zatwierdzona", dobrze czy źle.
static var _wpisane := false


## Czy spełniony jest jeden warunek.
static func jest(warunek: String) -> bool:
	if warunek.begins_with("!"):
		return not jest(warunek.substr(1))
	var rodzaj := warunek.substr(0, 2)
	var nazwa := warunek.substr(2)
	match rodzaj:
		"f:":
			return bool(Gra.flagi.get(nazwa, false))
		"p:":
			return Ekwipunek.ma(nazwa)
		"k:":
			return Teczka.wpisana(nazwa) if _wpisane else Teczka.sprawdzona(nazwa)
		"w:":
			return Teczka.wpisana(nazwa)
	push_warning("Sledztwo: nieznany warunek " + warunek)
	return false


## Czy spełnione są wszystkie warunki z listy.
static func wszystkie(warunki: Array) -> bool:
	for w in warunki:
		if not jest(w):
			return false
	return true


## Zmarnowany czas (fałszywe tropy, złe karty, pytania nie do tych osób).
static func strata(minuty: int) -> void:
	Gra.flagi["stracone_minuty"] = int(Gra.flagi.get("stracone_minuty", 0)) + minuty


static func stracone() -> int:
	return int(Gra.flagi.get("stracone_minuty", 0))


## Argumenty, które gracz ma w ręku na konfrontację (id z Dialogi.SLEDZTWO_ARGUMENTY).
## Liczą się karty zatwierdzone, też te ze złym wpisem: gracz o błędzie nie wie,
## a w finale taki argument nie trafia (trafny()).
static func argumenty() -> Array:
	var wynik := []
	_wpisane = true
	for id in Dialogi.SLEDZTWO_ARGUMENTY:
		if wszystkie(Dialogi.SLEDZTWO_ARGUMENTY[id][0]):
			wynik.append(id)
	_wpisane = false
	return wynik


## Czy karty, na których stoi argument, są wpisane dobrze.
static func trafny(id: String) -> bool:
	return not Dialogi.SLEDZTWO_ARGUMENTY.has(id) or wszystkie(Dialogi.SLEDZTWO_ARGUMENTY[id][0])


## Zdania epilogu: co gracz odkrył, a co przeoczył.
static func epilog() -> Array:
	var zdania := []
	for e in Dialogi.SLEDZTWO_EPILOG:
		var tekst: String = e[1] if wszystkie(e[0]) else e[2]
		if tekst != "":
			zdania.append(tekst)
	for zla in Teczka.zle_karty():
		zdania.append(Dialogi.TECZKA_NAPISY["epilog_zla"] % [Dialogi.KARTY[zla[0]][0], zla[1]])
	return zdania
