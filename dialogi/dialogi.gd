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
	# zaraz po planszy "Foyer, 18:30"
	"poczatek": [
		["Antoni", "Ech, ta kawa na komendzie... Strasznie chce mi się siku."],
		["Antoni", "Do spektaklu pół godziny. Muszę znaleźć jakiś kibel."],
	],
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
		["Antoni", "Lepiej to sobie zapiszę. Stary nawyk z komendy."],
		["", "Od teraz pod T masz notes. Wpisujesz w nim wszystko sam."],
	],
	# po zamknięciu notesu
	"antoni_po_notesie": [
		["Antoni", "Dobra. Najpierw kibel, potem zagadki. Może tymi drzwiami?"],
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


# ---------- ZAMKNIĘTE DRZWI ----------
# Napis, który pojawia się, gdy Antoni podejdzie do drzwi, którymi nie da się przejść.
# Trzymaj je krótkie, żeby mieściły się w jednej linijce.

const DRZWI := {
	"foyer_widownia": "Zamknięte. Widownię otwierają tuż przed spektaklem.",
	"foyer_wyjscie": "Nie wyjdę teraz. Ola by mnie zabiła.",
	"kulisy_wyjscie": "Zaraz wracam. Najpierw sprawdzę, kto się tak drze.",
	"kulisy_wyjscie_2": "Nie wiem, którędy do foyer. Zapytam kogoś.",
}


# ---------- NOTES ----------
# Gra sama niczego nie zapisuje w notesie, gracz notuje wszystko sam.

const NOTES := {
	# karteczka nad notesem przy pierwszym otwarciu (scena 1, po rozmowie Ani)
	"samouczek": "To Twój notes. Gra nic tu nie zapisze za Ciebie, więc notuj wszystko, co ważne. Później trzeba to będzie pamiętać.\n\nWpisz, co usłyszałeś od Ani.\n\nEsc zamyka, T otwiera.",
}


# ---------- PRZEDMIOTY ----------
# Nazwa w cudzysłowie przed dwukropkiem to identyfikator (i nazwa ikonki w ui/przedmioty/).
# [nazwa w grze, opis, rodzaj, siły]
# rodzaj: "fabularny" (trop, nie znika), "jedzenie" albo "picie" (E zjada/wypija),
# "inny". Siły to ile pasek sił rośnie po zjedzeniu (0 = nic).

const PRZEDMIOTY := {
	# fabularne (ze scenariusza; w nawiasie gdzie leżą i w której scenie)
	"program": ["Program premiery", "Biografia Wolskiego: zadebiutował w 1998 roku jako Hamlet. Na okładce jego zdjęcie.", "fabularny", 0],  # stojak w foyer, sc. 1
	"klucz": ["Zapasowy klucz", "Klucz z zawieszką \"PRACOWNIA / GARDEROBY\". Otwiera drzwi także po godzinach.", "fabularny", 0],  # bezpieczniki w kulisach, sc. 2
	"latarka": ["Latarka", "Stara, ciężka, ale świeci jak trzeba.", "fabularny", 0],  # skrzynka z rekwizytami w magazynie, sc. 6
	"ladowarka": ["Ładowarka", "Ładowarka do telefonu. Pasuje do starszych modeli.", "fabularny", 0],  # szuflada w budce stróża, sc. 7
	"rekawiczki": ["Lateksowe rękawiczki", "Chronią dłonie. Przy podejrzanych plamach lepiej ich nie zdejmować.", "fabularny", 0],  # apteczka w bufecie, sc. 9
	"lampa_uv": ["Lampa UV", "W jej świetle niektóre plamy świecą.", "fabularny", 0],  # szafka pod ladą w pralni, sc. 12
	"nozyczki": ["Nożyczki krawieckie", "Ostre jak brzytwa. Irena by mnie za nie zabiła.", "fabularny", 0],  # kosz z przyborami w pracowni, sc. 11
	"woreczek": ["Woreczek na dowody", "Strunowy woreczek z komendy. Bez niego laboratorium nic nie przyjmie.", "fabularny", 0],  # schowek w samochodzie, sc. 13
	"paragon": ["Paragon z hurtowni", "Hurtownia tkanin, czwartek 7:12. Na nazwisko Ireny.", "fabularny", 0],  # skrzynka z materiałami w pracowni, sc. 15
	"grafik": ["Grafik dostaw", "Dostawy mleka do bufetu: tylko w czwartki.", "fabularny", 0],  # skrzynka na mleko przy bufecie, sc. 19
	"spinka": ["Spinka do włosów", "Wygięta. Da się nią otworzyć prosty zamek.", "fabularny", 0],  # pudełko z charakteryzacją Ani, sc. 20
	"pendrive": ["Pendrive", "Czarny pendrive z sejfu Wolskiego. Coś na nim jest.", "fabularny", 0],  # sejf w garderobie Wolskiego, sc. 18
	# zwykłe (pasek sił)
	"bulka": ["Bułka", "Świeża bułka z pralni pani Haliny.", "jedzenie", 10],
	"kanapka": ["Kanapka", "Z serem i pomidorem, z bufetu.", "jedzenie", 20],
	"paczek": ["Pączek", "Z lukrem. Z budki przed magazynem.", "jedzenie", 15],
	"kawa": ["Kawa", "Czarna. Przez chwilę chodzisz szybciej.", "picie", 5],
	"herbata": ["Herbata z termosu", "Herbata od Wolskiego. Gorąca i słodka.", "picie", 10],
	"tabletki": ["Tabletki przeciwbólowe", "Na ból głowy. Nie więcej niż dwie dziennie.", "jedzenie", 15],
	"papierosy": ["Papierosy", "Antoni nie pali, ale zestresowani ludzie chętniej gadają przy papierosie.", "inny", 0],
	"monety": ["Drobne monety", "Kilka złotych. Na automat albo taksówkę.", "inny", 0],
}

# Miejsca do przeszukania (E): [podpowiedź nad miejscem, tekst po przeszukaniu, tekst gdy pusto]
const SKRZYNKI := {
	"stojak_programy": ["Weź program", "Program premiery. Jeden wezmę.", "Jeden program wystarczy."],
	"bufet": ["Bufet", "Na ladzie kanapki i kawa dla widzów premiery. Biorę po jednej.", "Więcej nie wezmę, nie wypada."],
	"apteczka": ["Apteczka", "W apteczce są tabletki przeciwbólowe. Biorę listek.", "Bandaże, plaster. Nic więcej mi nie trzeba."],
	"szatnia": ["Szatnia", "Szatniarz: \"To pana? Wypadło komuś z płaszcza, nikt się nie przyznaje.\" Biorę drobne.", "Szatniarz kiwa głową. Nic więcej tu nie ma."],
	"bezpieczniki": ["Bezpieczniki", "Między bezpiecznikami wisi zapasowy klucz. Ktoś tu dba o wygodę.", "Same bezpieczniki."],
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
