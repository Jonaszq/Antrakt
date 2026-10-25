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
		["Elegancka pani", "Wolski był podobno chory przez cały tydzień. Trzydzieści dziewięć stopni!"],
		["Elegancka pani", "A dziś i tak zagra. Prawdziwy zawodowiec."],
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
		["Marta", "Toaleta dla personelu jest zaraz przy drzwiach na widownię. Szybko, a potem prosto na swoje miejsce."],
		["Marta", "Marta, inspicjentka. Jak ktoś się tu gubi, to potem ja tego kogoś szukam. Proszę za mną nie łazić."],
	],
	"marta_potem": [
		["Marta", "Drzwi z napisem WIDOWNIA, tam na końcu. Proszę już iść, za chwilę trzeci dzwonek."],
	],
}


# ---------- SCENA 3: SPEKTAKL, SOBOTA 19:00 (FILMIK) ----------
# Gracz tylko ogląda i klika dalej. "Wolski" i "Ania" na scenie grają role ze sztuki.

const SCENA3 := {
	# Antoni siada na swoim miejscu
	"przed": [
		["Antoni", "Zdążyłem. Ola byłaby dumna."],
		["", "Gasną światła. Kurtyna idzie w górę."],
	],
	"akt1": [
		["Wolski", "Trzy noce nie spałem w tym domu. Ktoś chodzi po schodach, gdy wszyscy już śpią."],
		["Wolski", "A ja wiem, kto. Wiem i milczę, bo milczenie to też rodzaj zbrodni."],
		["", "Widownia wstrzymuje oddech. Wolski gra, jakby naprawdę bał się o życie."],
	],
	"akt2": [
		["Wolski", "Nareszcie jesteś. Powiedz mi prawdę, choć raz w życiu."],
		["Ania", "Prawda jest taka, że ty... że ty nie powinieneś..."],
		["", "Ania milknie w pół zdania. Patrzy na kostium Wolskiego, jakby zobaczyła ducha."],
	],
	"akt2_ratunek": [
		["Wolski", "...nie powinienem żyć? Wiem. A jednak stoję przed tobą, moja droga."],
		["Ania", "Tak. A jednak stoisz."],
		["", "Spektakl toczy się dalej. Nikt na widowni niczego nie zauważył. Prawie nikt."],
	],
	"koniec": [
		["", "Burza oklasków. Wolski kłania się trzy razy. Ania tylko raz, i szybko znika za kulisami."],
		["Antoni", "Dobre przedstawienie. Tylko ta jedna pomyłka..."],
	],
}

# Duże napisy na środku ekranu między aktami.
const SCENA3_NAPISY := {
	"akt1": "Akt pierwszy",
	"akt2": "Akt drugi",
	"koniec": "21:30",
}


# ---------- SCENA 4: BANKIET W FOYER, SOBOTA 22:00 ----------
# Najważniejsze są rozmowy z Ireną i Martą. Po obu scena się kończy.

const SCENA4 := {
	"poczatek": [
		["Antoni", "Bankiet. Ola mówiła, że po premierze zawsze jest wino i dużo gadania."],
		["Antoni", "Dobrze. Posłucham, co gadają."],
	],
	"wolski": [
		["Wolski", "Pan Antoni! I jak? Tylko szczerze, choć i tak usłyszę same komplementy."],
		["Antoni", "Był pan świetny."],
		["Wolski", "Wiem. Ale od policjanta to brzmi jak zeznanie pod przysięgą. Wino jest na stole, proszę się częstować."],
		["Antoni", "A ta pauza w drugim akcie?"],
		["Wolski", "Ania? Trema, każdemu się zdarza. Złapałem ją, nikt nie zauważył. No, prawie nikt."],
	],
	"wolski_potem": [
		["Wolski", "Proszę się bawić! Jutro i tak wszyscy będziemy mieli kaca."],
	],
	"lis": [
		["Lis", "Udało się! Bez dublera, z Adamem po gorączce, a jednak się udało!"],
		["Antoni", "Adrian się odezwał?"],
		["Lis", "Nie. Jak go dorwę, to... Nieważne. Dziś świętujemy."],
	],
	"lis_potem": [
		["Lis", "Niech pan spróbuje tartinek. Kosztowały mnie majątek."],
	],
	"irena": [
		["Irena", "Ten chłopak wszystko niszczy."],
		["Antoni", "Kto taki?"],
		["Irena", "Adrian, a kto! Kostium Adama od próby w pralni, a we wtorek drugi spektakl!"],
		["Antoni", "Adrian nosił kostium Wolskiego?"],
		["Irena", "Na czwartkowej próbie, bo Adam leżał z gorączką. Po próbie kostium zniknął z wieszaka i wylądował w pralni."],
		["Irena", "Coś na niego wylał i nawet się nie przyznał. Dwa miesiące go szyłam."],
		["", "Wskazówka: takie rzeczy warto zapisać w notesie (T). Gra sama tego nie zrobi."],
	],
	"irena_potem": [
		["Irena", "Jak ten kostium nie wróci na wtorek, to Adam zagra w szlafroku."],
	],
	"marta": [
		["Marta", "O, pan od toalety. Znalazł pan w końcu?"],
		["Antoni", "Znalazłem. Wszystko w porządku za kulisami?"],
		["Marta", "Teraz tak. Ale wie pan, co jest dziwne? Na próbie generalnej Adrian cały czas się drapał."],
		["Marta", "Jakby miał mrówki pod koszulą. Blady był jak ściana."],
		["Antoni", "Uczulenie?"],
		["Marta", "Może. A teraz nie odbiera telefonu. Dziwny ten tydzień."],
	],
	"marta_potem": [
		["Marta", "Ja już padam z nóg. Jutro sprzątanie po premierze."],
	],
	"ania": [
		["Ania", "Przepraszam, nie mam dziś siły na rozmowy."],
		["Antoni", "W drugim akcie..."],
		["Ania", "Zapomniałam tekstu. Zdarza się. Proszę mnie zostawić."],
	],
	"ania_potem": [
		["Ania", "..."],
	],
	"starszy_pan": [
		["Starszy pan", "Wolski był genialny. A ta mała w drugim akcie? Zbladła jak trup."],
	],
	"elegancka_pani": [
		["Elegancka pani", "Gorączka czy nie, zagrał jak bóg. Mówiłam, prawdziwy zawodowiec."],
	],
	"student": [
		["Student", "Przeżyłem! Wolski zagrał. Mogę umierać spokojnie."],
		["Antoni", "Lepiej nie."],
	],
	# po rozmowach z Ireną i Martą
	"koniec": [
		["", "Mija godzina. Wino się kończy, goście powoli zakładają płaszcze."],
	],
}

## SMS, który przychodzi na początku bankietu: [kontakt, godzina, tekst].
const SCENA4_SMS := ["Ola (siostra)", "21:52", "I jak?? Wolski był boski, prawda? Opowiadaj!"]


# ---------- ZAMKNIĘTE DRZWI ----------
# Napis, który pojawia się, gdy Antoni podejdzie do drzwi, którymi nie da się przejść.
# Trzymaj je krótkie, żeby mieściły się w jednej linijce.

const DRZWI := {
	"foyer_widownia": "Zamknięte. Widownię otwierają tuż przed spektaklem.",
	"foyer_wyjscie": "Nie wyjdę teraz. Ola by mnie zabiła.",
	"kulisy_wyjscie": "Zaraz wracam. Najpierw sprawdzę, kto się tak drze.",
	"kulisy_wyjscie_2": "To chyba drzwi na widownię. Ale gdzie ta toaleta? Zapytam kogoś.",
	"kulisy_dol": "Tędy przyszedłem. Nie ma czasu, zaraz trzeci dzwonek.",
	"bankiet_widownia": "Widownia już zamknięta. Spektakl się skończył.",
	"bankiet_wyjscie": "Jeszcze nie wychodzę. Najpierw posłucham, co ludzie mówią.",
	"bankiet_personel": "Za kulisy już nie wejdę. Marta by mnie zabiła.",
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
	"bankiet": ["Stół bankietowy", "Tartinki, pączki i wino. Biorę coś na ząb.", "Starczy. Nie chcę wyjść na łakomczucha."],
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
