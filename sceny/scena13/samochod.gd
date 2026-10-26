class_name Samochod
## Samochód Antoniego (scena 13): schowek z woreczkami na dowody i plan miasta.
## Na planie nic nie jest zaznaczone jako cel; zła jazda kosztuje czas.
## Teksty w Dialogi.SAMOCHOD.

const PRALNIA := "res://sceny/scena13/scena13.tscn"
const LABORATORIUM := "res://sceny/scena13/laboratorium.tscn"
const ZLA_JAZDA := 90


## Menu w samochodzie. Zwraca scenę, do której jechać, albo "" (Antoni wysiada).
static func jazda(s: ScenaGry, skad: String) -> String:
	var t: Dictionary = Dialogi.SAMOCHOD
	s.komunikat(t["tytul"], 2.0)
	while true:
		var w := await s.wybor(t["menu"])
		if w == 0:
			if Ekwipunek.ma("woreczek"):
				await s.rozmowa(t["schowek_potem"])
			else:
				await s.rozmowa(t["schowek"])
				Ekwipunek.dodaj("woreczek")
		elif w == 1:
			var cel := await _plan(s)
			if cel != "" and cel != skad:
				return cel
		else:
			s.antoni.sterowanie = true
			return ""
	return ""


## Plan miasta na cały ekran i lista miejsc. Zwraca scenę albo "" (zostaje w aucie).
static func _plan(s: ScenaGry) -> String:
	var t: Dictionary = Dialogi.SAMOCHOD
	var plan := TextureRect.new()
	plan.texture = load("res://ui/plan_miasta.png")
	s.ui.add_child(plan)
	var w := await s.wybor(t["miejsca"])
	plan.queue_free()
	match t["miejsca"][w]:
		"Laboratorium":
			return LABORATORIUM
		"Pralnia":
			return PRALNIA
		"Dom":
			if Gra.flagi.get("s13_dom", false):
				await s.rozmowa(t["dom_potem"])
			else:
				await s.rozmowa(t["dom"])
				s.znajdz_kase(40)
				Gra.flagi["s13_dom"] = true
			Sledztwo.strata(ZLA_JAZDA + 30)
		"Teatr":
			await s.rozmowa(t["teatr"])
			Sledztwo.strata(ZLA_JAZDA)
		"Komenda":
			await s.rozmowa(t["komenda"])
			Sledztwo.strata(ZLA_JAZDA)
		"Szpital":
			await s.rozmowa(t["szpital"])
			Sledztwo.strata(ZLA_JAZDA)
	return ""
