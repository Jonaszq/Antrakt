class_name Sledztwo
## Rejestr śledztwa: co gracz ustalił, co stracił i ile czasu zmarnował.
## Gra nie czyta notatnika, tylko flag (Gra.flagi) i ekwipunku. Warunki to napisy:
## "f:nazwa" (flaga), "p:id" (przedmiot w ekwipunku), "k:id" (sprawdzona karta
## z teczki); "!" na początku odwraca warunek. Z tego korzystają retrospekcje,
## konfrontacja w finale (Dialogi.SLEDZTWO_ARGUMENTY) i epilog (Dialogi.SLEDZTWO_EPILOG).


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
			return Teczka.sprawdzona(nazwa)
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
static func argumenty() -> Array:
	var wynik := []
	for id in Dialogi.SLEDZTWO_ARGUMENTY:
		if wszystkie(Dialogi.SLEDZTWO_ARGUMENTY[id][0]):
			wynik.append(id)
	return wynik


## Zdania epilogu: co gracz odkrył, a co przeoczył.
static func epilog() -> Array:
	var zdania := []
	for e in Dialogi.SLEDZTWO_EPILOG:
		var tekst: String = e[1] if wszystkie(e[0]) else e[2]
		if tekst != "":
			zdania.append(tekst)
	return zdania
