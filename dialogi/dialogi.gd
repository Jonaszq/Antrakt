class_name Dialogi
## WSZYSTKIE TEKSTY GRY W JEDNYM MIEJSCU.
##
## Tutaj zmieniasz, co mówią postacie, bez szukania po plikach scen.
## Każda rozmowa to lista kwestii: ["Kto mówi", "Co mówi"].
## Pusty mówca "" to narracja (bez imienia i bez głosu "blabla").
## Sceny biorą stąd teksty po nazwie, np. Dialogi.SCENA1["ania_telefon"].
## Jeśli dopiszesz kwestię, wystarczy dodać kolejną linijkę w nawiasach.
## Nie zmieniaj tylko nazw w cudzysłowie przed dwukropkiem (np. "ania_telefon"),
## bo po nich sceny szukają tekstów.


# ---------- FILMIK WSTĘPNY ----------

const WSTEP := {
	# Antoni pod teatrem w deszczu
	"pod_teatrem": [
		["Antoni", "Bilet od siostry. Jeden wolny wieczór."],
		["Antoni", "Żadnych trupów. Żadnych przesłuchań. Tylko teatr."],
	],
}


# ---------- SCENA 1: FOYER, SOBOTA 18:30 ----------

const SCENA1 := {
	"starszy_pan": [
		["Starszy pan", "Słyszał pan? Podobno dubler Wolskiego zniknął. Od wczoraj nikt go nie widział."],
		["Antoni", "Może po prostu ma tremę."],
		["Starszy pan", "Trema przed rolą, której może nawet nie zagra? Młodzi dziś są dziwni."],
	],
	"elegancka_pani": [
		["Elegancka pani", "Wolski grał podobno generalną w gorączce. Trzydzieści dziewięć stopni!"],
		["Elegancka pani", "Prawdziwy zawodowiec. Dubler nawet nie musiał wchodzić na scenę."],
	],
	"student": [
		["Student", "Kupiłem bilet pół roku temu. Jak Wolski dziś nie zagra, to chyba umrę."],
		["Antoni", "Lepiej nie."],
	],
	# Antoni podchodzi do Ani przy drzwiach służbowych (uruchamia się samo)
	"ania_telefon": [
		["Ania", "(do telefonu) Adrian, odezwij się, proszę. Cokolwiek się stało, przepraszam."],
		["Ania", "...Och. Nie zauważyłam pana. Przepraszam, muszę wracać za kulisy."],
	],
	# po wyjściu Ani
	"antoni_po_ani": [
		["Antoni", "Za co ona przeprasza? I komu?"],
		["Antoni", "Dobra. Najpierw toaleta, potem zagadki. Może tymi drzwiami?"],
	],
}


# ---------- SCENA 2: KULISY, SOBOTA 18:50 ----------

const SCENA2 := {
	# zaraz po wejściu
	"poczatek": [
		["Antoni", "Ciemno tu jak w grobie. To na pewno nie jest toaleta."],
		["", "Wskazówka: pod Tab możesz wziąć Antoniego z latarnią, który lepiej widzi w ciemności."],
	],
	# Antoni podchodzi do dyrektora i Wolskiego (uruchamia się samo)
	"klotnia": [
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
	],
	# kolejne rozmowy pod E
	"lis_potem": [
		["Lis", "Niech pan wraca na widownię, dobrze? Jeszcze tylko policji za kulisami mi brakowało."],
	],
	"wolski_potem": [
		["Wolski", "Gorączka? Ech, było, minęło. Teatr leczy lepiej niż aspiryna."],
		["Wolski", "Tylko kostium mam nowy, stary jest w pralni. Ten drapie jak diabli."],
	],
	"marta_pierwsza": [
		["Marta", "Hej! Pan tu nie może być. Za dziesięć minut podnosimy kurtynę."],
		["Antoni", "Szukam toalety."],
		["Marta", "W foyer, po lewej od szatni. Ma pan szczęście, że to nie środek spektaklu."],
		["Marta", "Marta, inspicjentka. Jak ktoś się tu gubi, to potem ja tego kogoś szukam. Proszę za mną nie łazić."],
	],
	"marta_potem": [
		["Marta", "Toaleta w foyer, po lewej od szatni. Proszę już iść, za chwilę trzeci dzwonek."],
	],
}


# ---------- WPISY W NOTESIE ----------
# Zbierane od początku, ale notes jest wyłączony, dopóki nie zacznie się akcja.

const NOTES := {
	"ania_przeprasza": "Dubler zaginął. Ania za coś przeprasza?",
	"adrian_nie_odbiera": "Dubler Adrian nie odbiera od wczoraj. Dyrektor Lis w panice.",
	"kostium_w_pralni": "Wolski gra w nowym kostiumie, stary jest w pralni.",
}


# ---------- TELEFON ANTONIEGO ----------

## SMS-y: kontakt -> lista [godzina, tekst, czy napisał Antoni (true) czy do niego (false)].
const SMS := {
	"Ola (siostra)": [
		["14:02", "Siema braciszku! Masz tu bilet na premierę \"Ostatniego aktu\". Dziś 19:00, Teatr Miejski.", false],
		["14:03", "Tylko się nie spóźnij! Długo na niego pracowałam.", false],
		["14:03", "Miłego spektaklu. I choć raz nie myśl o pracy :)", false],
		["14:20", "Dzięki, Ola. Będę na czas.", true],
	],
	"Komisarz Nowicki": [
		["pt 17:45", "Urlop to urlop, Antoni. Nie chcę cię widzieć na komendzie do poniedziałku.", false],
		["pt 17:51", "Tak jest, szefie.", true],
	],
	"Mama": [
		["pt 19:10", "Jadłeś coś dzisiaj?", false],
		["pt 21:30", "Antoś?", false],
	],
}

## Historia połączeń: [kto, rodzaj (przychodzące, wychodzące, nieodebrane, odrzucone), kiedy].
const POLACZENIA := [
	["Ola (siostra)", "przychodzące", "dziś 14:05, 2 min"],
	["Mama", "nieodebrane", "pt 21:31"],
	["Pizzeria Roma", "wychodzące", "pt 20:12, 1 min"],
	["Komisarz Nowicki", "przychodzące", "pt 17:40, 4 min"],
	["Nieznany numer", "odrzucone", "czw 09:12"],
	["Mama", "wychodzące", "śr 18:30, 12 min"],
]
