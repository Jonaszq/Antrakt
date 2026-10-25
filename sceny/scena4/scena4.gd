extends ScenaGry
## Scena 4: bankiet w foyer, sobota 22:00. Zespół świętuje premierę.
## Irena narzeka, że Adrian zniszczył kostium Wolskiego (od próby w pralni),
## Marta wspomina, że Adrian na próbie się drapał. Gracz sam decyduje, co zapisać
## w notesie (przy Irenie jest wskazówka). Po rozmowach z Ireną i Martą mija godzina
## i scena się kończy. Scena 5 (telefon do dyrektora) jeszcze nie istnieje,
## na razie potem jest wolne foyer. Teksty w Dialogi.SCENA4.

const NASTEPNA := "res://mapy/foyer/foyer.tscn"
const DRZWI_PERSONEL := Rect2(190, 106, 48, 38)

var _irena := false
var _marta := false


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "22:04"
	Notatnik.wlacz()  # od sceny 1 notes jest zawsze dostępny
	antoni.position = Vector2(440, 142)
	antoni.stan("dol")
	# Ania stoi sama przy ławce, z dala od świętujących
	var ania: Node2D = obiekty.get_node("Ania")
	ania.position = Vector2(150, 284)
	dodaj_rozmowce(ania, _kolejne("ania"))
	# Wolski w centrum uwagi, wokół niego goście
	dodaj_rozmowce(postac("wolski", Vector2(440, 286)), _kolejne("wolski"))
	dodaj_rozmowce(postac("gosc_pani", Vector2(482, 292)), Dialogi.SCENA4["elegancka_pani"])
	dodaj_rozmowce(postac("gosc_pan", Vector2(398, 296)), Dialogi.SCENA4["starszy_pan"])
	dodaj_rozmowce(postac("gosc_student", Vector2(300, 410)), Dialogi.SCENA4["student"])
	dodaj_rozmowce(postac("bogdan", Vector2(560, 186)), _kolejne("lis"))
	dodaj_rozmowce(postac("irena", Vector2(804, 158)), _rozmowa_z_irena)
	dodaj_rozmowce(postac("marta", Vector2(262, 172)), _rozmowa_z_marta)
	skrzynka(Vector2(712, 132), "bankiet", ["paczek", "kanapka"])
	zamkniete_drzwi(Rect2(392, 108, 96, 34), Dialogi.DRZWI["bankiet_widownia"])
	zamkniete_drzwi(Rect2(396, 470, 88, 40), Dialogi.DRZWI["bankiet_wyjscie"])
	zamkniete_drzwi(DRZWI_PERSONEL, Dialogi.DRZWI["bankiet_personel"])
	await plansza("Bankiet, 22:00")
	var sms: Array = Dialogi.SCENA4_SMS
	Telefon.dodaj_sms(sms[0], sms[2], sms[1])
	await rozmowa(Dialogi.SCENA4["poczatek"])
	pomoc_klawiszy()


## Pierwsza rozmowa z kwestii "<kto>", każda kolejna z "<kto>_potem".
func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		await rozmowa(Dialogi.SCENA4[kto if stan.pierwsza else kto + "_potem"])
		stan.pierwsza = false


func _rozmowa_z_irena() -> void:
	await rozmowa(Dialogi.SCENA4["irena_potem" if _irena else "irena"])
	_irena = true
	_sprawdz_koniec()


func _rozmowa_z_marta() -> void:
	await rozmowa(Dialogi.SCENA4["marta_potem" if _marta else "marta"])
	_marta = true
	_sprawdz_koniec()


func _sprawdz_koniec() -> void:
	if not (_irena and _marta) or koniec:
		return
	await rozmowa(Dialogi.SCENA4["koniec"])
	przejdz(NASTEPNA)
