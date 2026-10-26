class_name RetroBaza
extends ScenaGry
## Wspólne rzeczy retrospekcji z rozdziału 4: wyblakły obraz, kamera bez Antoniego
## i przymierzanie: gracz wpisuje imię w czarną sylwetkę i może obalić je kartą z teczki.
## Dane przymierzania w Dialogi.PRZYMIERZANIE[kontekst]: imię -> [karta, co mówi Antoni].

const CENA_PRZYMIERZENIA := 10
const CENA_ZLEJ_KARTY := 5

var kamera: Camera2D


func przygotuj_retro(mapa: Node2D, rozmiar: Vector2, srodek: Vector2, mrok: Color) -> void:
	przygotuj(mapa)
	antoni.visible = false
	antoni.sterowanie = false
	antoni.wybor_gracza = false
	mapa.get_node("Mrok").color = mrok
	var filtr := CanvasLayer.new()
	filtr.layer = 5
	var obraz := ColorRect.new()
	obraz.size = Vector2(1920, 1080)
	obraz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://ui/retrospekcja.gdshader")
	obraz.material = mat
	filtr.add_child(obraz)
	add_child(filtr)
	kamera = Camera2D.new()
	kamera.limit_right = int(rozmiar.x)
	kamera.limit_bottom = int(rozmiar.y)
	kamera.position = srodek
	obiekty.add_child(kamera)
	kamera.make_current()


## Imię wpisane przez gracza -> imię z tablicy podejrzanych ("" gdy nikogo takiego nie ma).
func rozpoznaj(tekst: String) -> String:
	var u := Teczka.uprosc(tekst)
	for imie in Dialogi.PODEJRZANI_ALIASY:
		if u in Dialogi.PODEJRZANI_ALIASY[imie]:
			return imie
	return ""


func _folder(imie: String) -> String:
	return Dialogi.FOLDERY_POSTACI.get(imie, "ania")


## Przymierzanie sylwetki. Zwraca imię, które zostało na sylwetce ("" = nikt).
## Wynik trafia też do Gra.flagi["retro_" + kontekst].
func przymierz(sylwetka: Node2D, kontekst: String) -> String:
	var r: Dictionary = Dialogi.RETRO_PRZYMIERZANIE
	var dane: Dictionary = Dialogi.PRZYMIERZANIE[kontekst]
	var twarz: Node2D = null
	var imie := ""
	while true:
		if await wybor([r["przymierz"], r["zostaw"]]) == 1:
			break
		var wpisane := await wpisz(r["kto"], 20)
		if wpisane == "":
			continue
		var kto := rozpoznaj(wpisane)
		if kto == "":
			await rozmowa([["Antoni", r["nie_znam"]]])
			continue
		Sledztwo.strata(CENA_PRZYMIERZENIA)
		if twarz:
			twarz.queue_free()
		twarz = postac(_folder(kto), sylwetka.position)
		twarz.modulate = Color(0.85, 0.85, 0.9, 0.9)
		sylwetka.visible = false
		imie = kto
		await rozmowa([["Antoni", r["moze"] % kto]])
		# karta, która temu przeczy
		var ids: Array = []
		for id in Teczka.karty:
			if Teczka.wpisana(id):
				ids.append(id)
		var napisy: Array = ids.map(func(id): return "Karta: " + Dialogi.KARTY[id][0])
		napisy.append(r["bez_karty"])
		var nr := await wybor(napisy)
		if nr >= ids.size():
			continue
		var karta: String = ids[nr]
		# karta ze złym wpisem nic nie obala, choć gracz nie wie dlaczego
		if dane.has(kto) and dane[kto][0] == karta and Teczka.sprawdzona(karta):
			await rozmowa([["Antoni", dane[kto][1]]])
			blysk()
			twarz.queue_free()
			twarz = null
			sylwetka.visible = true
			imie = ""
			Gra.flagi["obalone_%s_%s" % [kontekst, kto]] = true
		else:
			Sledztwo.strata(CENA_ZLEJ_KARTY)
			await rozmowa([["Antoni", r["nic_nie_dowodzi"]]])
	Gra.flagi["retro_" + kontekst] = imie
	antoni.sterowanie = false
	return imie


## Przejście do kolejnej sceny po zaciemnieniu z napisami.
func zakoncz(napisy: Array, scena: String) -> void:
	var tw := create_tween()
	tw.tween_property(_zaslona, "color:a", 1.0, 1.2)
	await tw.finished
	for n in napisy:
		komunikat(n, 3.5)
		await pauza(4.0)
	get_tree().change_scene_to_file(scena)
