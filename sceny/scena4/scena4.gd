extends ScenaGry
## Scena 4: bankiet w foyer, sobota 22:00. Zespół i goście świętują premierę.
## Po chwili Wolski wznosi toast za "nieobecnego przyjaciela Adriana", fotograf robi
## zdjęcie zespołu. W środku bankietu kostiumolożka Irena wpada z wiklinowym koszem,
## krzyczy na dyrektora, rzuca na stół koszulę i rękawiczki Adriana z próby
## generalnej i wychodzi. Antoni może powąchać koszulę (słodkawy, chemiczny, zgniły
## zapach). Marta mówi, że Adrian na próbie się drapał. Po awanturze i rozmowie
## z Martą mija godzina i zaczyna się scena 5. W tle gramofon, Stasia czeka
## po autograf, Zawada je tartinki, kelnerka zbiera kieliszki, ktoś śpiewa.
## Teksty w Dialogi.SCENA4.

const NASTEPNA := "res://sceny/scena5/scena5.tscn"
const DRZWI_PERSONEL := Rect2(190, 106, 48, 38)
const STOLIK := Vector2(655, 197)  # stolik_1, tu Irena rzuca koszulę


var _toast := false
var _irena := false  # awantura już była
var _marta := false
var _konczy := false
var _postac_ireny: Node2D
var _lis: Node2D
var _wolski: Node2D
var _zawada: Node2D


func _ready() -> void:
	przygotuj($Foyer)
	Telefon.godzina = "22:04"
	Notatnik.wlacz()  # od sceny 1 notes jest zawsze dostępny
	var t: Dictionary = Dialogi.SCENA4
	var tlo: Dictionary = Dialogi.SCENA4_TLO
	antoni.position = Vector2(440, 142)
	antoni.stan("dol")
	# Ania stoi sama przy ławce, z dala od świętujących
	var ania: Node2D = obiekty.get_node("Ania")
	ania.position = Vector2(150, 284)
	dodaj_rozmowce(ania, _kolejne("ania"))
	# Wolski w centrum uwagi, wokół niego goście
	_wolski = postac("wolski", Vector2(440, 286))
	dodaj_rozmowce(_wolski, _kolejne("wolski"))
	var pani := postac("gosc_pani", Vector2(482, 292))
	dodaj_rozmowce(pani, t["elegancka_pani"])
	gada_w_tle(pani, tlo["goscie"], 9.0)
	var pan := postac("gosc_pan", Vector2(398, 296))
	dodaj_rozmowce(pan, t["starszy_pan"])
	gada_w_tle(pan, tlo["goscie"], 10.0)
	var stasia := postac("stasia", Vector2(470, 322))
	dodaj_rozmowce(stasia, t["stasia"])
	gada_w_tle(stasia, tlo["stasia"], 7.0)
	dodaj_rozmowce(postac("gosc_student", Vector2(300, 410)), t["kuba"])
	_lis = postac("bogdan", Vector2(560, 186))
	dodaj_rozmowce(_lis, _kolejne("lis"))
	dodaj_rozmowce(postac("marta", Vector2(262, 172)), _rozmowa_z_marta)
	# Irena na razie jest za kulisami, wpada później z koszem
	_postac_ireny = postac("irena", Vector2(214, 128))
	_postac_ireny.visible = false
	var kosz := Sprite2D.new()
	kosz.texture = preload("res://rekwizyty/kosz_wiklinowy.png")
	kosz.position = Vector2(13, -22)
	_postac_ireny.add_child(kosz)
	# ludzie w tle
	_zawada = postac("zawada", Vector2(744, 150))
	dodaj_rozmowce(_zawada, t["zawada"])
	gada_w_tle(_zawada, tlo["zawada"], 6.0)
	var kelnerka := postac("kelnerka", Vector2(520, 240))
	dodaj_rozmowce(kelnerka, t["kelnerka"])
	spacer(kelnerka, [Vector2(620, 300), Vector2(540, 380), Vector2(370, 360), Vector2(520, 240)], 36.0, 2.0)
	gada_w_tle(kelnerka, tlo["kelnerka"], 9.0)
	var spiewak := postac("aktor", Vector2(90, 460))
	dodaj_rozmowce(spiewak, t["spiewak"])
	gada_w_tle(spiewak, tlo["spiewak"], 4.0)
	dodaj_rozmowce(postac("fotograf", Vector2(330, 250)), t["fotograf"])
	# gramofon i kieliszki na stolikach
	rekwizyt("gramofon", Vector2(615, 267), 22.0)
	miejsce(Vector2(615, 272), "Gramofon", t["gramofon"])
	rekwizyt("taca_kieliszki", Vector2(715, 237), 24.0)
	skrzynka(Vector2(712, 132), "bankiet", ["paczek", "kanapka"])
	zamkniete_drzwi(Rect2(392, 108, 96, 34), Dialogi.DRZWI["bankiet_widownia"])
	zamkniete_drzwi(Rect2(396, 470, 88, 40), Dialogi.DRZWI["bankiet_wyjscie"])
	zamkniete_drzwi(DRZWI_PERSONEL, Dialogi.DRZWI["bankiet_personel"])
	zamkniete_drzwi(Rect2(264, 108, 36, 34), Dialogi.DRZWI["bankiet_toalety"])
	dzwiek("gramofon.ogg", -8.0, true)
	dzwiek("gwar.ogg", -16.0, true)
	await plansza("Bankiet, 22:00")
	var sms: Array = Dialogi.SCENA4_SMS
	Telefon.dodaj_sms(sms[0], sms[2], sms[1])
	await rozmowa(t["poczatek"])
	pomoc_klawiszy()
	# bez przerywników: toast, gdy Antoni sam podejdzie do Wolskiego,
	# Irena wpada, gdy po toaście Antoni podejdzie do dyrektora
	gdy_blisko(_wolski, 60.0, _wznies_toast)


## Czeka podaną liczbę sekund, a potem aż Antoni będzie wolny (bez rozmowy i okien).
func _czekaj_wolny(sekundy: float) -> void:
	await get_tree().create_timer(sekundy).timeout
	while not wolny():
		await get_tree().process_frame


## Pierwsza rozmowa z kwestii "<kto>", każda kolejna z "<kto>_potem".
func _kolejne(kto: String) -> Callable:
	var stan := {"pierwsza": true}
	return func() -> void:
		await rozmowa(Dialogi.SCENA4[kto if stan.pierwsza else kto + "_potem"])
		stan.pierwsza = false


func _wznies_toast() -> void:
	if _toast:
		return
	_toast = true
	antoni.sterowanie = false
	zwroc_sie(_wolski)
	await dialog.pokaz(Dialogi.SCENA4["toast"])
	await blysk()
	antoni.sterowanie = true
	gdy_blisko(_lis, 70.0, _irena_wpada)


## Irena wypada z drzwi PERSONEL z koszem, robi awanturę dyrektorowi,
## rzuca koszulę Adriana na stolik i wychodzi (gdy Antoni stoi przy dyrektorze).
func _irena_wpada() -> void:
	if _irena or not _toast:
		return
	_irena = true
	antoni.sterowanie = false
	_postac_ireny.visible = true
	await przesun(_postac_ireny, Vector2(520, 196), 1.6)
	await dialog.pokaz(Dialogi.SCENA4["irena_wpada"])
	await przesun(_postac_ireny, STOLIK + Vector2(-26, 6), 0.9)
	var koszula := rekwizyt("koszula_stol", STOLIK, 24.0)
	miejsce(STOLIK + Vector2(0, 6), "Koszula Adriana", _kolejne("koszula"))
	await dialog.pokaz(Dialogi.SCENA4["irena_wychodzi"])
	blysk()
	await przesun(_postac_ireny, Vector2(214, 128), 2.2)
	var tw := create_tween()
	tw.tween_property(_postac_ireny, "modulate:a", 0.0, 0.4)
	await tw.finished
	_postac_ireny.queue_free()
	koszula.visible = true
	dodaj_rozmowce(_lis, Dialogi.SCENA4["lis_po_irenie"])
	dodaj_rozmowce(_zawada, Dialogi.SCENA4["zawada_po_irenie"])
	antoni.sterowanie = true
	_sprawdz_koniec()


func _rozmowa_z_marta() -> void:
	await rozmowa(Dialogi.SCENA4["marta_potem" if _marta else "marta"])
	_marta = true
	_sprawdz_koniec()


func _sprawdz_koniec() -> void:
	if not (_irena and _marta) or _konczy:
		return
	_konczy = true
	# chwila na powąchanie koszuli i rozmowy, potem mija godzina
	await _czekaj_wolny(20.0)
	if koniec:
		return
	await rozmowa(Dialogi.SCENA4["koniec"])
	przejdz(NASTEPNA)
