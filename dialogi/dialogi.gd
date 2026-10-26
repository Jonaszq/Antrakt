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
# Antoniemu chce się siku, toaleta jest nieczynna, a potem okazuje się, że zgubił bilet.
# Bilet jest w płaszczu w szatni, płaszcz wydadzą za numerek, numerek leży przy stojaku z programami.

const SCENA1 := {
	# zaraz po planszy "Foyer, 18:30"
	"poczatek": [
		["Antoni", "Ech, ta kawa na komendzie... Strasznie chce mi się siku."],
		["Antoni", "Do spektaklu pół godziny. Gdzieś tu musi być toaleta."],
	],
	# Antoni podchodzi do drzwi TOALETY (uruchamia się samo)
	"toaleta": [
		["", "Na drzwiach wisi kartka: \"AWARIA. NIECZYNNE. Przepraszamy.\""],
		["Antoni", "No pięknie. To może chociaż zajmę miejsce na widowni."],
		["Antoni", "Bilet, bilet... (klepie się po kieszeniach)"],
		["Antoni", "Gdzie jest mój bilet?!"],
	],
	# to samo, gdy Antoni już wie, że zgubił bilet
	"toaleta_znowu": [
		["", "Na drzwiach wisi kartka: \"AWARIA. NIECZYNNE. Przepraszamy.\""],
		["Antoni", "No pięknie. Najpierw bilet, potem szukanie toalety."],
	],
	# bileterka przy drzwiach na widownię
	"bileterka_bez_biletu": [
		["Bileterka", "Dobry wieczór. Bilet poproszę."],
		["Antoni", "Proszę bardzo, o, tutaj... (szuka po kieszeniach) Chwileczkę."],
		["Bileterka", "Bez biletu nawet pan Wolski by nie wszedł. No, może pan Wolski tak."],
		["Antoni", "Płaszcz. Włożyłem go do płaszcza, a płaszcz oddałem do szatni."],
		["Bileterka", "To szatnia jest tam, po prawej. A ja tu stoję do trzeciego dzwonka."],
	],
	"bileterka_czeka": [
		["Bileterka", "Bilet się znalazł? Nie? To czekam."],
	],
	"bileterka_z_biletem": [
		["Antoni", "Mam! Proszę."],
		["Bileterka", "No proszę. Rząd trzeci, miejsce czternaste. Widownię otwieramy za kwadrans."],
		["Antoni", "A toaleta? Ta przy kasie jest nieczynna."],
		["Bileterka", "Awaria od rana. Personel ma swoją, za drzwiami z napisem PERSONEL."],
		["Bileterka", "Ale ja panu nic nie mówiłam."],
	],
	"bileterka_potem": [
		["Bileterka", "Rząd trzeci, miejsce czternaste. Tylko niech pan go drugi raz nie zgubi."],
	],
	# szatniarz za ladą szatni
	"szatniarz_zwykly": [
		["Szatniarz", "Płaszczyk już wisi, numerek pan ma. Spokojna głowa."],
	],
	"szatniarz_bez_numerka": [
		["Antoni", "Dobry wieczór. Oddawałem tu płaszcz, szary, z paskiem. Muszę coś wyjąć z kieszeni."],
		["Szatniarz", "Numerek poproszę."],
		["Antoni", "No właśnie... chyba go zgubiłem."],
		["Szatniarz", "Bez numerka nie wydam. Tu wisi trzysta płaszczy i połowa jest szara z paskiem."],
		["Antoni", "Gdzie mogłem go zgubić... Jak wchodziłem, schylałem się po program przy stojaku."],
	],
	"szatniarz_czeka": [
		["Szatniarz", "Numerek, proszę pana. Regulamin."],
	],
	"szatniarz_z_numerkiem": [
		["Antoni", "Czterdzieści siedem."],
		["Szatniarz", "Czterdzieści siedem... Proszę bardzo."],
		["", "Antoni przeszukuje kieszenie płaszcza."],
		["Antoni", "Jest! Bilet. I parę drobnych."],
		["Szatniarz", "Płaszcz zostaje u mnie? To proszę, numerek z powrotem. Tylko tym razem do portfela."],
	],
	"szatniarz_potem": [
		["Szatniarz", "Czterdzieści siedem, pamiętam. Wszystko gra."],
	],
	# rozmowy opcjonalne
	"zawada": [
		["Zawada", "Pan też na Wolskiego? Proszę się nie spodziewać fajerwerków."],
		["Antoni", "Podobno to wielki aktor."],
		["Zawada", "Wielki, owszem. Wolski gra od dwudziestu lat jedną rolę: siebie."],
		["Zawada", "Zawada, \"Kurier Teatralny\". Jutro przeczyta pan moją recenzję. Połowę już mam napisaną."],
		["Antoni", "Przed spektaklem?"],
		["Zawada", "Doświadczenie, młody człowieku. Doświadczenie."],
	],
	"zawada_potem": [
		["Zawada", "Dubler zniknął? Najrozsądniejszy człowiek w tym teatrze."],
	],
	"stasia": [
		["Pani Stasia", "Pan pierwszy raz na panu Adamie? Ja byłam na każdej jego premierze od 1998 roku. Od Hamleta!"],
		["Pani Stasia", "Proszę, tu podpis z Hamleta, tu z \"Zemsty\", tu z \"Wesela\". Dziś będzie trzydziesty pierwszy."],
		["Antoni", "Imponujące."],
		["Pani Stasia", "Pan Adam zawsze się podpisuje z serduszkiem. Taki to dżentelmen."],
	],
	"stasia_potem": [
		["Pani Stasia", "Podobno ten młody dubler przepadł. Pan Adam nigdy by nikogo nie zostawił w potrzebie."],
	],
	"kuba": [
		["Kuba", "(rozgląda się nerwowo) Przepraszam... pan jest z policji? Tak pan patrzy po ludziach."],
		["Antoni", "Dziś tylko widz. A co, masz coś na sumieniu?"],
		["Kuba", "Ja? Nie! Nic. Tak tylko pytam."],
		["Kuba", "Kuba, trzeci rok aktorskiego. Wie pan, kto dziś miał siedzieć w pogotowiu? Adrian, dubler Wolskiego."],
		["Kuba", "Dubler to najgorsza robota świata. Czekasz, aż ktoś zachoruje."],
		["Kuba", "Uczysz się roli na pamięć, a potem siedzisz w garderobie i słuchasz oklasków dla kogoś innego."],
		["Antoni", "Mówisz, jakbyś mu zazdrościł."],
		["Kuba", "Zazdroszczę. Ja się nawet na dublera nie dostałem."],
	],
	"kuba_potem": [
		["Kuba", "Jak Adrian się nie znajdzie, to może mnie wezmą. Żartuję. Chyba."],
		["Kuba", "I proszę... jakby ktoś pytał, to mnie tu nie było. Dobrze?"],
	],
	"starszy_pan": [
		["Starszy pan", "Słyszał pan? Podobno dubler Wolskiego zniknął. Od wczoraj nikt go nie widział."],
		["Antoni", "Może po prostu ma tremę."],
		["Starszy pan", "Trema przed rolą, której może nawet nie zagra? Młodzi dziś są dziwni."],
	],
	"elegancka_pani": [
		["Elegancka pani", "Wolski był podobno chory prawie cały tydzień. W środę już wracał, a w czwartek znowu trzydzieści dziewięć stopni!"],
		["Elegancka pani", "A dziś i tak zagra. Prawdziwy zawodowiec."],
	],
	# ludzie w tle
	"kelner": [
		["Kelner", "Szampana?"],
		["Antoni", "Nie, dziękuję. Przynajmniej nie przed spektaklem."],
		["Kelner", "Gdyby pan zmienił zdanie, krążę tu do trzeciego dzwonka."],
	],
	"para": [
		["Żona", "Mówiłam ci, że rząd siódmy, a nie siedemnasty!"],
		["Mąż", "Na bilecie jest siedemnaście!"],
		["Żona", "Bo kupiłeś w ostatniej chwili, jak zawsze!"],
		["Mąż", "(do Antoniego) Pan powie, czy z siedemnastego rzędu widać twarze?"],
		["Antoni", "Widać. Trochę z daleka."],
		["Żona", "Słyszysz? Z daleka!"],
	],
	"para_potem": [
		["Mąż", "Proszę się nie mieszać, to sprawa rodzinna."],
	],
	"dziecko": [
		["Chłopiec", "Pan jest duchem teatru?"],
		["Antoni", "Nie. Jestem tylko widzem."],
		["Chłopiec", "Szkoda. Mama mówi, że tu straszy."],
	],
	"fotograf": [
		["Fotograf", "Uśmiech! ...A, pan nie z obsady. Szkoda kliszy."],
		["Antoni", "Klisza? Ktoś jeszcze używa kliszy?"],
		["Fotograf", "W \"Głosie Miasta\" wszystko jest stare. Łącznie ze mną."],
	],
	# Antoni podchodzi do Ani przy drzwiach służbowych (uruchamia się samo)
	"ania_telefon": [
		["Ania", "(do telefonu) Adrian, odezwij się, proszę. Martwię się o ciebie."],
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
		["Antoni", "Dobra. Na razie mam własne problemy."],
	],
}

# Teksty, które pojawiają się na chwilę u góry ekranu albo nad głowami ludzi w tle.
const SCENA1_TLO := {
	"dzwonek": "Pierwszy dzwonek.",
	"dziecko": ["Nie złapiesz mnie!", "Brrrum!", "Hihi!"],
	"para": ["Siódmy!", "Siedemnasty!", "Zawsze to samo z tobą!"],
	"kelner": ["Szampan, proszę bardzo.", "Uwaga, taca!"],
	"stasia": ["Pan Adam to geniusz.", "Od dziewięćdziesiątego ósmego!"],
	"zawada": ["Hm.", "Banał.", "(coś notuje)"],
}


# ---------- SCENA 2: KULISY, SOBOTA 18:50 ----------

const SCENA2 := {
	# zaraz po wejściu
	"poczatek": [
		["Antoni", "Ciemno tu jak w grobie. To na pewno nie jest toaleta."],
	],
	# Antoni podchodzi do dyrektora i Wolskiego (uruchamia się samo)
	"klotnia": [
		["Lis", "Dwadzieścia lat prowadzę ten teatr i jeszcze nigdy dubler nie zniknął w dzień premiery!"],
		["Lis", "Adam, jeśli ty mi dziś padniesz na scenie, to premiera wisi na włosku. Nie mam nikogo!"],
		["Wolski", "Bogdan, spokojnie. Zagram za dwóch, a Adrian pewnie odsypia stres."],
		["", "Garderobiana chce poprawić Wolskiemu kołnierz. Wolski odsuwa jej rękę. Ma na dłoniach białe rękawiczki."],
		["Wolski", "Nie dotykać! Nikt nie dotyka mojego kostiumu przed premierą. Nikt."],
		["Lis", "Odsypia! Od wczoraj nie odbiera telefonu!"],
		["Wolski", "(z uśmiechem, do Antoniego) Zgubił się pan? Proszę, oto moje królestwo."],
		["Antoni", "Szukałem toalety. Chyba zaszedłem trochę za daleko."],
		["Wolski", "Ha! Najciekawsze rzeczy w teatrze dzieją się tam, gdzie widzom nie wolno wchodzić. Adam Wolski."],
		["Antoni", "Antoni. Z wydziału kryminalnego, ale dziś tylko jako widz."],
		["Lis", "Policja? Tylko tego brakowało... Bogdan Lis, dyrektor. Proszę wybaczyć, mamy drobny kryzys."],
		["Wolski", "Bogdan zawsze ma kryzys. Proszę się nie przejmować i zostać na bankiet. Stawiam wino."],
	],
	# zaraz po kłótni Marta łapie Antoniego za rękaw (uruchamia się samo)
	"marta_noz": [
		["Marta", "Hej, pan! Tak, pan."],
		["Marta", "Pan nie z zespołu? Nie szkodzi. Ma pan oczy? To mi pan pomoże."],
		["Antoni", "Ja tylko szukałem toalety..."],
		["Marta", "Toaleta jest przy drzwiach na widownię, zaraz pan pójdzie. Najpierw nóż."],
		["Marta", "Zginął rekwizytowy nóż. Bez niego Wolski nie zagra finału, a ja mam dwunastu ludzi i żadnego wolnego."],
		["Marta", "Sprawdź pan stół z rekwizytami i skrzynie z kostiumami. Ja lecę do świateł."],
		["Antoni", "Tak jest."],
		["Marta", "Marta, inspicjentka. Jak pan znajdzie, to do mnie. Biegiem."],
	],
	"marta_czeka": [
		["Marta", "I co, jest nóż? Nie? To czemu pan stoi?"],
	],
	"marta_oddaje": [
		["Antoni", "Ten?"],
		["Marta", "Tak! Gdzie był?"],
		["Antoni", "W garderobie, w torbie jakiegoś statysty. Naszywka \"J.A.\"."],
		["Marta", "J.A.? To ten student, Kuba. Statystuje w drugim akcie. Po co mu nóż z finału?"],
		["Marta", "Nieważne. Ratuje mi pan życie. A teraz toaleta przy drzwiach na widownię i prosto na swoje miejsce."],
	],
	"marta_potem": [
		["Marta", "Drzwi z napisem WIDOWNIA, tam na końcu. Proszę już iść, za chwilę trzeci dzwonek."],
	],
	# kolejne rozmowy pod E
	"lis_potem": [
		["Lis", "Niech pan wraca na widownię, dobrze? Jeszcze tylko policji za kulisami mi brakowało."],
	],
	"wolski_potem": [
		["Wolski", "Gorączka? Ech, było, minęło. Teatr leczy lepiej niż aspiryna."],
		["Wolski", "Tylko kostium mam nowy, stary jest w pralni. Ten drapie jak diabli."],
	],
	"maszynista": [
		["Maszynista", "Uwaga, plecy! Przepraszam, ale ta ściana zamku sama nie pojedzie."],
	],
	"palacz": [
		["Maszynista", "Spokojnie, dym na scenę nie leci. Marta by mnie zabiła."],
		["Antoni", "Widział pan dziś Adriana? Dublera?"],
		["Maszynista", "Od czwartku nie. Pewnie leży gdzieś z gorączką, jak pół zespołu w tym tygodniu."],
	],
	"palacz_potem": [
		["Maszynista", "Pff... Jeszcze jeden i wracam do roboty."],
	],
	"garderobiana": [
		["Garderobiana", "Przepraszam, gorące! Pan Wolski ma zagniecenie na rękawie, a ja mam żelazko i dziewięć minut!"],
	],
	"aktor": [
		["Aktor", "Mama, mema, mima, momo, mumu... Pan od dekoracji? Nie? To proszę mi nie przeszkadzać."],
		["Aktor", "Mam tylko dwie kwestie, ale za to jakie!"],
	],
	"aktorka": [
		["Aktorka", "W drugim akcie podaję Wolskiemu herbatę. Trzy sekundy na scenie i ani słowa."],
		["Aktorka", "Ale podobno mam piękne plecy."],
	],
	# miejsca do obejrzenia
	"stol": [
		["", "Stół z rekwizytami. Każdy rekwizyt ma swój obrys z taśmy: korona, kielich, sztylet, czaszka."],
		["", "Na końcu stołu pusty obrys w kształcie noża."],
		["Antoni", "Sztylet jest, nóż nie. Ktoś go zabrał."],
	],
	"stol_przed": [
		["", "Stół z rekwizytami. Korona, kielich, sztylet, czaszka. Lepiej niczego nie ruszać."],
	],
	"skrzynie": [
		["", "Skrzynie z kostiumami. Peleryny, sztuczne wąsy, korona z papieru."],
		["Antoni", "Noża nie ma. Ale ktoś tu zgubił kanapkę. Dawno."],
	],
	"tablica": [
		["", "Tablica ogłoszeń. Grafik prób, lista rekwizytów i kartka: \"Kto zabrał mój kubek z kotem?! M.\""],
	],
	"tron": [
		["", "Tron z dykty pomalowany na złoto. Z bliska widać gwoździe."],
	],
	"zarowka": [
		["", "Goła żarówka na statywie. Ola mówiła, że w teatrach świeci całą noc, żeby duchy miały przy czym grać."],
	],
	"pulpit": [
		["", "Pulpit inspicjenta. Scenariusz oklejony kolorowymi karteczkami i rząd przycisków z napisami \"DZWONEK\", \"KURTYNA\", \"BURZA\"."],
	],
	"wieszak": [
		["", "Wieszak z kostiumami do drugiego aktu. Na każdym karteczka z nazwiskiem."],
	],
}

const SCENA2_TLO := {
	"glosnik_1": "Głośnik: Piętnaście minut do początku.",
	"glosnik_2": "Głośnik: Dziesięć minut. Proszę o ciszę za kulisami.",
	"maszynista": ["Uwaga, plecy!", "Na trzy: raz, dwa...", "W lewo! Moje lewo!"],
	"garderobiana": ["Gorące! Gorące!", "Kto widział moje szpilki?!"],
	"aktor": ["Mama, mema, mima...", "Szczebrzeszyn...", "Bla, ble, bli, blo, blu."],
	"aktorka": ["Trzy sekundy. Trzy sekundy.", "Herbata, herbata..."],
	"palacz": ["Pff...", "Ale leje."],
}

# Garderoba Ani (za drzwiami GARDEROBY w kulisach).
const GARDEROBA := {
	"wejscie": [
		["Antoni", "Garderoba. Toaletka Ani, a w kącie rzeczy statystów. Pachnie pudrem i kwiatami."],
	],
	"toaletka": [
		["", "Toaletka Ani. Lustro w żarówkach, puder, szminka."],
		["", "Zdjęcie w ramce: Ania z jakimś chłopakiem. Śmieją się, za nimi morze."],
		["Antoni", "To pewnie Adrian."],
	],
	"toaletka_potem": [
		["", "Zdjęcie Ani i Adriana nad morzem. Na odwrocie nic nie ma."],
	],
	"torba_przed": [
		["", "Sportowa torba statysty na kanapie. Naszywka \"J.A.\". Wystaje z niej rękojeść noża."],
		["Antoni", "Pewnie jakiś rekwizyt. Nie mój interes."],
	],
	"torba": [
		["", "Sportowa torba statysty. Naszywka \"J.A.\", w środku podręcznik dykcji i scenariusz pełen notatek."],
		["", "Między nimi rekwizytowy nóż z finału. Ostrze chowa się w rękojeść."],
		["Antoni", "Co nóż z finału robi w torbie statysty?"],
	],
	"torba_potem": [
		["", "Torba \"J.A.\". Scenariusz \"Ostatniego aktu\", rola Wolskiego podkreślona na żółto."],
	],
	"kwiaty": [
		["", "Bukiet czerwonych róż. Bilecik: \"Połamania nóg, córeczko. Mama.\""],
	],
	"wieszak": [
		["", "Kostiumy Ani na drążku. Każdy podpisany numerem sceny."],
	],
	"kanapa": [
		["", "Kanapa, na niej kremowy szal Ani i czyjaś sportowa torba."],
	],
	"parawan": [
		["", "Parawan do przebierania. Przewieszona przez niego koszula nocna z pierwszego aktu."],
	],
	"szafa": [
		["", "Szafa zamknięta. Na górze pudła na kapelusze."],
	],
}


# ---------- SCENA 3: SPEKTAKL I ANTRAKT, SOBOTA 19:00 DO 21:30 ----------
# Akt pierwszy i drugi to filmiki (gracz tylko klika dalej), antrakt dzieje się w foyer.
# "Wolski" i "Ania" na scenie grają role ze sztuki.

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
	# Ania wchodzi na scenę
	"akt1_ania": [
		["Wolski", "Nareszcie jesteś. Powiedz mi prawdę, choć raz w życiu."],
		["Ania", "Prawda jest taka, że ty nie powinieneś był tu wracać."],
	],
	"akt1_ratunek": [
		["Wolski", "A jednak wróciłem. I stoję przed tobą, moja droga."],
		["Ania", "Tak. A jednak stoisz."],
		["", "Ania gra pewnie, tylko oczy ma zaczerwienione. Pod koniec aktu raz zerka w stronę kulis, jakby kogoś szukała."],
	],
	"antrakt": [
		["", "Kurtyna opada. Zapalają się światła. Antrakt."],
		["Antoni", "Kawa. Potrzebuję kawy."],
	],
	# drugi akt
	"przed_akt2": [
		["", "Trzeci dzwonek. Ludzie wracają na miejsca, ktoś jeszcze przeciska się przez rząd."],
	],
	"akt2": [
		["Wolski", "Wszyscy myślą, że zbrodnia to jedna chwila. Błysk ostrza i po wszystkim."],
		["Wolski", "Nieprawda. Zbrodnia to lata czekania. Ktoś musi bardzo długo cię nienawidzić."],
		["", "Ania wchodzi na scenę."],
		["Ania", "Czekałam dwadzieścia lat. Możesz mi wierzyć, że umiem czekać."],
	],
	"final": [
		["", "Finał. Ania podnosi nóż. Ten sam, którego szukała Marta."],
		["", "Światło gaśnie na sekundę. Kiedy wraca, Wolski leży na deskach."],
		["", "Cisza. A potem cała widownia wstaje."],
	],
	"koniec": [
		["", "Burza oklasków. Wolski kłania się trzy razy. Ania tylko raz, i szybko znika za kulisami."],
		["Antoni", "Dobre przedstawienie. Szkoda, że Adrian tego nie widział."],
	],
}

# Duże napisy na środku ekranu między aktami.
const SCENA3_NAPISY := {
	"akt1": "Akt pierwszy",
	"antrakt": "Antrakt",
	"akt2": "Akt drugi",
	"koniec": "21:30",
}

# Antrakt w foyer, około 20:10.
const ANTRAKT := {
	"poczatek": [
		["Antoni", "Dwadzieścia minut przerwy. Kawa, a potem może w końcu toaleta. Jeśli już ją naprawili."],
	],
	"bufet": [
		["Antoni", "Kawę poproszę."],
		["Bufetowa", "Kawa czarna jak dusza krytyka, proszę bardzo. Pięć złotych."],
	],
	"bufet_place": [
		["Antoni", "Proszę. Akurat drobne z płaszcza."],
		["Bufetowa", "Co do grosza! Smacznego."],
		["", "Wskazówka: kawę masz w ekwipunku (I). E ją wypija, potem przez chwilę chodzisz szybciej."],
	],
	"bufet_na_kreske": [
		["Antoni", "Mam tylko kartę..."],
		["Bufetowa", "Terminal nie działa od premiery Hamleta. Niech pan bierze, odda pan po spektaklu."],
		["", "Wskazówka: kawę masz w ekwipunku (I). E ją wypija, potem przez chwilę chodzisz szybciej."],
	],
	"bufet_potem": [
		["Bufetowa", "Druga kawa po spektaklu. Teraz kolejka."],
	],
	"zawada": [
		["Zawada", "Pierwszy akt: Wolski gra Wolskiego. Bez niespodzianek."],
		["Antoni", "A Ania?"],
		["Zawada", "Wrzos? Poprawna. Ale grała, jakby myślami była gdzie indziej. Szukała kogoś wzrokiem za kulisami."],
		["Zawada", "Zapiszę to sobie: \"Wrzos, nieobecna.\" Ładne, prawda?"],
	],
	"zawada_potem": [
		["Zawada", "Proszę mi nie zaglądać do notesu. To nieetyczne."],
	],
	"stasia": [
		["Pani Stasia", "Cudowny! Cudowny! Widział pan, jak on trzyma pauzę? Jak w Hamlecie w dziewięćdziesiątym ósmym!"],
		["Antoni", "Widziałem."],
		["Pani Stasia", "Po spektaklu idę po autograf. Trzydziesty pierwszy. Mam już przygotowaną stronę."],
	],
	"stasia_potem": [
		["Pani Stasia", "Strona trzydziesta pierwsza. Z serduszkiem."],
	],
	"kuba": [
		["Kuba", "(podskakuje) O! To pan. Ja tu nic, tylko... powtarzałem sobie tekst."],
		["Antoni", "Czyj tekst?"],
		["Kuba", "Wolskiego. Całą rolę umiem. Od miesięcy. Tak na wszelki wypadek, wie pan."],
		["Kuba", "Adrian znał ją lepiej, grał ją na próbie generalnej. Ale Adriana nie ma."],
	],
	"kuba_potem": [
		["Kuba", "\"Trzy noce nie spałem w tym domu...\" (mamrocze dalej pod nosem)"],
	],
	"wino": [
		["Żona", "Cała sukienka! Mówiłam, żebyś nie machał rękami!"],
		["Mąż", "To nie ja, to ten pan z wąsem!"],
		["Starszy pan", "Ja? Ja piję tylko wodę."],
	],
	"wino_potem": [
		["Żona", "Wiesz, ile kosztowała ta sukienka?!"],
	],
	"szatniarz": [
		["Szatniarz", "Chrrr... Chrrr..."],
		["Antoni", "Nie będę budził."],
	],
	"fotograf": [
		["Fotograf", "Antrakt to najlepsze zdjęcia. Ludzie zapominają, że ktoś patrzy."],
	],
	"bileterka": [
		["Bileterka", "Drugi akt po dzwonku. Proszę się nie oddalać."],
	],
	"bileterka_po_dzwonku": [
		["Bileterka", "Zapraszam, zapraszam. Rząd trzeci, pamiętam."],
	],
	# przy drzwiach do toalet (uruchamia się samo)
	"ania_placze": [
		["", "Przy drzwiach do toalet stoi Ania, wciąż w kostiumie. Płacze nad telefonem."],
		["Antoni", "Wszystko w porządku?"],
		["Ania", "Adrian. Dalej nie odbiera. Dzwonię i dzwonię."],
		["Ania", "Przepraszam. Muszę wracać, zaraz drugi dzwonek."],
	],
	"po_ani": [
		["Antoni", "Martwi się o niego. Tylko ona jedna szuka go naprawdę."],
	],
}

const ANTRAKT_TLO := {
	"kuba": ["Trzy noce nie spałem w tym domu...", "...bo milczenie to też rodzaj zbrodni.", "Zbrodnia to lata czekania..."],
	"dzwonek": "Drugi dzwonek. Proszę zająć miejsca.",
	"zawada": ["(skrobie w notesie)", "Hm. Banał."],
	"stasia": ["Cudowny!", "Jak w Hamlecie!"],
	"para": ["Cała sukienka!", "To nie ja!"],
	"szatniarz": ["Zzz...", "Chrrr..."],
	"kolejka": ["Długo jeszcze?", "Dwie kawy, proszę!", "Czy jest coś bez glutenu?"],
}


# ---------- SCENA 4: BANKIET W FOYER, SOBOTA 22:00 ----------
# Toast Wolskiego, potem wpada Irena z koszem. Po awanturze i rozmowie z Martą scena się kończy.

const SCENA4 := {
	"poczatek": [
		["Antoni", "Bankiet. Ola mówiła, że po premierze zawsze jest wino i dużo gadania."],
		["Antoni", "Dobrze. Posłucham, co gadają."],
	],
	# Wolski wznosi toast (uruchamia się samo)
	"toast": [
		["Wolski", "Kochani! Cisza, cisza, na chwilę!"],
		["Wolski", "Dziękuję wam za ten wieczór. Bogdanowi za nerwy, Marcie za cierpliwość, Irenie za kostiumy."],
		["Wolski", "I jeszcze jeden. Za nieobecnego przyjaciela."],
		["Wolski", "Za Adriana, który pewnie śpi teraz jak zabity. Wypijmy, żeby jutro miał kaca od naszych opowieści."],
		["", "Wszyscy piją. Ania odstawia kieliszek, nie biorąc ani łyka."],
		["Fotograf", "Zdjęcie zespołu! Wszyscy do mnie, szybciutko!"],
	],
	"wolski": [
		["Wolski", "Pan Antoni! I jak? Tylko szczerze, choć i tak usłyszę same komplementy."],
		["Antoni", "Był pan świetny."],
		["Wolski", "Wiem. Ale od policjanta to brzmi jak zeznanie pod przysięgą. Wino jest na stole, proszę się częstować."],
		["Antoni", "A ta pauza w pierwszym akcie?"],
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
	"lis_po_irenie": [
		["Lis", "Przepraszam za to przedstawienie. Irena jest nerwowa przed każdym praniem."],
		["Lis", "I niech pan tego nie wącha, na litość boską. Kelnerka zaraz to zabierze."],
	],
	# Irena wpada z wiklinowym koszem i krzyczy na dyrektora (uruchamia się samo)
	"irena_wpada": [
		["Irena", "Bogdan, co to ma być?! Takie stroje się oddaje do prania?! To wszystko śmierdzi jak zdechły szczur!"],
		["Lis", "(szeptem) Irena, na litość boską, nie teraz. Jest prasa."],
		["Irena", "Prasa niech powącha! Ten chłopak wszystko niszczy. Kostium Adama od próby w pralni, a we wtorek drugi spektakl!"],
		["", "Irena wyciąga z kosza zmiętą męską koszulę i parę rękawiczek."],
		["Irena", "Koszula i rękawiczki Adriana. Z próby generalnej. Leżały zwinięte w kącie garderoby."],
		["Irena", "Proszę bardzo, panie dyrektorze. Niech pan sam to wypierze!"],
	],
	"irena_wychodzi": [
		["", "Irena rzuca koszulę na stół, odwraca się na pięcie i wychodzi. Fotograf robi zdjęcie. Lis łapie się za głowę."],
	],
	# koszula na stole
	"koszula": [
		["", "Biała koszula, zmięta, z żółtawą plamą pod pachą. Rękawiczki sztywne, jakby czymś nasiąknięte."],
		["", "Antoni pochyla się nad stołem. Zapach jest słodkawy, chemiczny, a pod spodem coś zgniłego."],
		["Antoni", "To nie jest pot. Pot tak nie pachnie."],
		["", "Wskazówka: takie rzeczy warto zapisać w notesie (T). Gra sama tego nie zrobi."],
	],
	"koszula_potem": [
		["Antoni", "Słodkawy, chemiczny, zgniły. Nie zapomnę tego zapachu."],
	],
	"marta": [
		["Marta", "O, pan od noża! Uratował mi pan finał."],
		["Antoni", "Wszystko w porządku za kulisami?"],
		["Marta", "Teraz tak. Ale wie pan, co jest dziwne? Adrian całą próbę się drapał, jakby miał mrówki pod koszulą."],
		["Marta", "Blady był jak ściana. Myślałam, że to trema."],
		["Antoni", "Uczulenie?"],
		["Marta", "Może. A teraz nie odbiera telefonu. Dziwny ten tydzień."],
	],
	"marta_potem": [
		["Marta", "Ja już padam z nóg. Jutro sprzątanie po premierze."],
	],
	"ania": [
		["Ania", "Przepraszam, nie mam dziś siły na rozmowy."],
		["Antoni", "W pierwszym akcie..."],
		["Ania", "Zapomniałam tekstu. Zdarza się. Proszę mnie zostawić."],
	],
	"ania_potem": [
		["Ania", "..."],
	],
	"starszy_pan": [
		["Starszy pan", "Wolski był genialny. A ten student, co tak szybko uciekł? Nawet tortu nie spróbował."],
	],
	"elegancka_pani": [
		["Elegancka pani", "Gorączka czy nie, zagrał jak bóg. Mówiłam, prawdziwy zawodowiec."],
	],
	"kuba": [
		["Kuba", "Przeżyłem! Wolski zagrał. Mogę umierać spokojnie."],
		["Antoni", "Lepiej nie."],
		["Kuba", "(patrzy na zegarek) Muszę lecieć. Proszę nikomu nie mówić, że wyszedłem tak wcześnie."],
	],
	"kuba_wychodzi": "Ostatni tramwaj! Do widzenia!",
	"stasia": [
		["Pani Stasia", "Trzydziesty pierwszy autograf! Z serduszkiem, jak zawsze."],
	],
	"zawada": [
		["Zawada", "Trzecia tartinka. Za darmo smakują lepiej niż recenzje."],
	],
	"zawada_po_irenie": [
		["Zawada", "Ta awantura z kostiumami? Najlepsza scena wieczoru. Szkoda, że nie było jej w programie."],
	],
	"fotograf": [
		["Fotograf", "Jutro na pierwszej stronie: zespół z kieliszkami. A na drugiej Irena z koszem, jeśli redaktor się zgodzi."],
	],
	"kelnerka": [
		["Kelnerka", "Pusty kieliszek? Zabieram. Pełny? Zostawiam. Taka praca."],
	],
	"spiewak": [
		["Aktor", "Sto lat, sto lat! Pan się przyłączy? Nie? Pan z policji, pan nie śpiewa."],
	],
	"gramofon": [
		["", "Stary gramofon gra walca. Płyta trzeszczy, ale nikt nie chce jej zmienić."],
	],
	# po awanturze i rozmowie z Martą
	"koniec": [
		["", "Mija godzina. Goście powoli zakładają płaszcze. Gramofon gra trzeci raz tę samą płytę."],
	],
}

## SMS, który przychodzi na początku bankietu: [kontakt, godzina, tekst].
const SCENA4_SMS := ["Ola (siostra)", "21:52", "I jak?? Wolski był boski, prawda? Opowiadaj!"]

const SCENA4_TLO := {
	"stasia": ["Panie Adamie, jeszcze tutaj!", "Z serduszkiem!"],
	"zawada": ["(mlask)", "Trzecia..."],
	"kelnerka": ["Przepraszam, kieliszki!", "Pusty? Zabieram."],
	"spiewak": ["~ Sto lat, sto lat... ~", "~ Niech żyje, żyje nam! ~"],
	"goscie": ["Za premierę!", "Genialny był!", "Jeszcze wina?"],
}


# ---------- SCENA 5: TELEFON I JAZDA, SOBOTA 23:30 ----------

const SCENA5 := {
	"telefon": [
		["", "Telefon dyrektora dzwoni. Lis odbiera z uśmiechem, który znika po kilku sekundach."],
		["Lis", "Tak, Zenon, słucham... Co? Gdzie?"],
		["Lis", "Jak to nie oddycha? Wezwałeś pogotowie? ...Dobrze. Dobrze. Już jadę."],
		["Lis", "(cicho) To był stróż z magazynu. Znalazł Adriana. Adrian... nie oddycha."],
	],
	"omdlenie": [
		["", "Ania osuwa się na podłogę. Wolski łapie ją w ostatniej chwili."],
		["Wolski", "Ania! Wody, szybko!"],
	],
	"prosba": [
		["Lis", "Pan jest z policji, prawda? Proszę, niech pan jedzie ze mną. Nie dam rady sam."],
		["Antoni", "Jadę."],
	],
	# w aucie dyrektora
	"auto": [
		["", "Deszcz bębni o dach. Wycieraczki ledwo nadążają."],
		["Radio", "...do rana ulewy nad całym regionem, możliwe podtopienia. Prosimy kierowców o ostrożność..."],
		["", "Lis ścisza radio."],
		["Lis", "Przepraszam. Nie wiem, co się mówi w takiej chwili."],
		["", "Do magazynu jest kawałek drogi. Antoni zdąży zapytać o dwie rzeczy."],
	],
	"o_adrianie": [
		["Antoni", "Jaki był Adrian?"],
		["Lis", "Zdolny. Cholernie zdolny i cholernie nieśmiały. Na próbach mówił tak cicho, że Marta krzyczała na niego z pulpitu."],
		["Lis", "Od roku był z Anią. Myśleli, że nikt nie wie. W teatrze wszyscy wiedzą wszystko."],
		["Antoni", "A ostatnio?"],
		["Lis", "Ostatnio był jakiś nieswój. Myślałem, że to trema przed premierą."],
	],
	"o_teatrze": [
		["Antoni", "Jak się teatrowi powodzi?"],
		["Lis", "(śmieje się gorzko) Długi, kredyt na nowy dach, a miasto obcina dotację."],
		["Lis", "Na wszystkim oszczędzamy. Na tragarzach, na pralni, na ludziach."],
		["Antoni", "A dziś bilety się sprzedały."],
		["Lis", "Na jedną premierę. Teatru nie utrzymuje się z jednej premiery."],
	],
	"o_wolskim": [
		["Antoni", "A Wolski? Jak się dogadywali z Adrianem?"],
		["Lis", "Adam go uczył. Pół zespołu by się zabiło, żeby Wolski ich uczył, a on wybrał Adriana."],
		["Lis", "Dał mu nawet grać w swoim kostiumie na próbie generalnej, jak sam leżał z gorączką."],
		["Lis", "Adam ma złote serce. Wszyscy tak mówią."],
	],
	# po dwóch pytaniach, zawsze
	"auto_koniec": [
		["Lis", "Jeśli ta premiera się nie sprzeda, za pół roku zamkną nam teatr. A ja wysłałem chłopaka po jakieś graty..."],
		["Antoni", "Do magazynu?"],
		["Lis", "W piątek. Po rekwizyty do drugiego aktu. Sam go wysłałem."],
		["", "Dalej jadą w milczeniu. Światła miasta zostają w tyle."],
	],
	# pod bramą magazynu
	"brama": [
		["", "Magazyn dekoracji na końcu miasta. Pusta ulica i jedna latarnia przy bramie."],
		["", "Pod latarnią czeka stróż w płaszczu przeciwdeszczowym."],
		["Zenon", "Panie dyrektorze, ja nie wiedziałem. Myślałem, że on dawno poszedł."],
		["Lis", "Gdzie on jest, Zenon?"],
		["Zenon", "W środku. Za skrzyniami. Pogotowie już jedzie."],
		["Antoni", "Tyle z mojego wolnego wieczoru."],
	],
}

## Opcje rozmowy w aucie (kolejność jak klucze SCENA5: o_adrianie, o_teatrze, o_wolskim).
const SCENA5_PYTANIA := [
	["O Adriana", "o_adrianie"],
	["O teatr", "o_teatrze"],
	["O Wolskiego", "o_wolskim"],
]

const SCENA5_NAPISY := {
	"koniec": "Koniec rozdziału 1",
	"licznik": "5 dni do pogrzebu",
	"dalej": "Rozdział 2: Ciało w magazynie",
}


# ---------- ROZDZIAŁ 2 ----------

# Scena 6: magazyn dekoracji, niedziela 0:15. Lekarz stwierdza zawał, Nowicki daje
# Antoniemu kwadrans. Najpierw latarka ze skrzynki przy bramie, potem ślady:
# czerwone pasy na ramionach Adriana, telefon pod manekinem, lista rekwizytów.
const SCENA6 := {
	"poczatek": [
		["", "Hala magazynu tonie w ciemności. Palą się tylko dwie żarówki."],
		["", "Deszcz bębni o blaszany dach. Gdzieś z góry kapie woda."],
		["Lis", "Ja... ja zostanę przy bramie. Nie dam rady tam podejść."],
	],
	# pierwsza rozmowa z lekarzem pogotowia przy ciele
	"lekarz_przy_ciele": [
		["Antoni", "Co mu się stało?"],
		["Lekarz", "Te zaczerwienienia na ramionach? Pewnie uczulenie na proszek. Przyczyna to serce. Młody, ale zdarza się."],
		["Lekarz", "Nie żyje od wielu godzin. Resztę powie sekcja, jak ktoś ją zleci."],
	],
	# Nowicki wchodzi bramą
	"nowicki_wchodzi": [
		["", "Przez bramę wchodzi komisarz Nowicki, otrzepując prochowiec z deszczu."],
		["Nowicki", "No proszę. Mój urlopowicz."],
		["Antoni", "Szefie, daj mi się rozejrzeć. Kwadrans."],
		["Nowicki", "Antek, jesteś na urlopie. Chłopak dostał zawału wśród starych gratów, koniec historii. Masz kwadrans."],
	],
	"latarka": [
		["", "Skrzynka pełna rekwizytów: korony z papier-mâché, drewniane miecze, sztuczne kwiaty."],
		["", "Na samym dnie stara, ciężka latarka. Antoni naciska włącznik. Świeci!"],
	],
	"latarka_potem": [["", "Same rekwizyty. Latarkę już mam."]],
	"ciemno": [["Antoni", "Za ciemno. Bez światła nic tu nie zobaczę."]],
	# ciało Adriana (z latarką)
	"cialo": [
		["", "Adrian leży na boku między skrzyniami. Koszula rozpięta, twarz szara jak papier."],
		["Antoni", "Na ramionach i na plecach czerwone pasy. Równe, wyraźne, jak odciśnięte."],
		["Antoni", "Uczulenie na proszek? Tylko tam, gdzie przylega ubranie, a na dłoniach nic?"],
		["", "Antoni robi zdjęcie telefonem."],
	],
	"cialo_bez_latarki": [
		["", "Adrian leży na boku między skrzyniami. Żarówka świeci mu w plecy, twarz ginie w cieniu."],
		["Antoni", "Muszę mu się przyjrzeć z bliska. Potrzebuję światła."],
	],
	"cialo_potem": [["Antoni", "Taki młody. A wszyscy myśleli, że po prostu nie przyszedł na premierę."]],
	"lekarz_pewien": [
		["Antoni", "Pan jest pewien, że to serce?"],
		["Lekarz", "Młody człowiek, stres przed premierą, papierosy, kawa litrami. Widziałem to setki razy."],
		["Lekarz", "Ja swoje napiszę. Zawał."],
	],
	"lekarz_potem": [["Lekarz", "Proszę mi nie utrudniać. Mam jeszcze dwa wezwania tej nocy."]],
	"policjant": [
		["Policjant", "Proszę nie deptać. Robię zdjęcia do protokołu."],
		["Antoni", "Ma pan tego dużo?"],
		["Policjant", "Szef kazał zrobić pięć i zwijać się. Zawał to zawał."],
	],
	"policjant_potem": [["Policjant", "Jeszcze z tej strony i koniec."]],
	"nowicki": [["Nowicki", "No i? Coś znalazłeś, Sherlocku?"]],
	"nowicki_jeszcze": [["Nowicki", "Zegar tyka, Antek."]],
	"lis": [
		["Lis", "Sam go tu wysłałem. Po kielichy i koronę do drugiego aktu. Po kielichy, rozumie pan?"],
	],
	"lis_kiedy": [
		["Antoni", "Kiedy go pan wysłał?"],
		["Lis", "W piątek po południu. Myślałem, że wrócił i poszedł prosto do domu."],
	],
	"lis_potem": [["Lis", "(patrzy w podłogę i milczy)"]],
	# manekin przewraca się sam, gdy Antoni przechodzi obok
	"manekin_upada": [
		["Antoni", "Cholera jasna!"],
		["Antoni", "Spokojnie. To tylko manekin. Wiatr albo krzywa podłoga."],
	],
	"telefon": [
		["", "Tam, gdzie stał manekin, leży telefon. Ekranem w dół, z pękniętą szybką."],
		["Antoni", "Na etui naklejka z teatralną maską. To musi być telefon Adriana."],
		["Antoni", "Rozładowany. A gdyby nawet działał, jest zablokowany PIN-em. Potrzebuję ładowarki."],
	],
	"lista": [
		["", "Na stoliku z dekoracji salonu leży kartka. Lista rekwizytów podpisana przez dyrektora Lisa."],
		["", "\"Kielichy złote, 4 szt. Korona. Owoce. Świeczniki, 2 szt.\""],
		["", "Na dole krzywe, rozjechane litery, długopisem:"],
		["", "\"nie dam rady, kręci mi się w głowie\""],
		["Antoni", "Pisał to tutaj. Usiadł na tej sofie, bo nie mógł ustać na nogach."],
	],
	"kielich": [
		["", "Pod skrzynią coś błyszczy w świetle latarki. Złoty kielich, leży na boku."],
		["", "Na nóżce jest wgniecenie, a obok kurz rozmazany długim pociągnięciem."],
	],
	"termos": [
		["", "Na sofie stoi termos w kratkę. W środku resztka zimnej herbaty z cytryną."],
		["", "Pachnie zwyczajnie, herbatą i cytryną. Na zakrętce wydrapane: \"A.\""],
	],
	"termos_potem": [["", "Termos Adriana. Herbata z cytryną, zimna."]],
	"kielich_ciemno": [["", "Pod skrzynią coś jest, ale w tej ciemności nic nie widać."]],
	"lista_potem": [["Antoni", "Na sofie wgniecenie. Siedział tu dłużej."]],
	"skrzynia_przewrocona": [
		["", "Przewrócona skrzynka z rekwizytami. Korona, sztuczne owoce, złote kielichy."],
		["", "Kielichy są trzy. W wyściółce są cztery wgłębienia, jedno puste."],
	],
	"zamek": [["", "Ściana zamku ze sklejki. Farba odpryskuje, z wieżyczki zrobiło się gniazdo gołębi."]],
	"statek": [["", "Dziób pirackiego statku. Na burcie wymalowane: \"Wyspa skarbów, 1987\"."]],
	"regaly": [["", "Kartony z napisami: \"Wesele\", \"Dziady\", \"Kordian, nie ruszać!\". Kurz na palec."]],
	"wiadro": [["", "Wiadro pod dziurą w dachu. Prawie pełne. Nikt go od dawna nie wylewał."]],
	"salon": [["", "Salon z lat trzydziestych: sofa, fotel, lampa z frędzlami. Jakby ktoś zaraz miał podać herbatę."]],
	# koniec kwadransu (albo Antoni sam mówi, że skończył)
	"koniec": [
		["Nowicki", "Kwadrans minął. Zabieramy go."],
		["", "Sanitariusze kładą Adriana na nosze i wynoszą go bramą w deszcz."],
		["Nowicki", "Idź ogrzać się do budki stróża, Antek. Ja muszę tu jeszcze spisać papiery."],
	],
	"koniec_sam": [
		["Antoni", "Skończyłem, szefie."],
		["Nowicki", "No, w końcu mówisz z sensem."],
	],
}

const SCENA6_WYBOR := ["Jeszcze się rozejrzę", "Pokaż dowód", "Skończyłem"]

## Pokazywanie dowodów w scenie 6: kto -> {id dowodu: kwestie}.
const SCENA6_DOWODY := {
	"lekarz": {
		"zdjecie_pasy": [["Antoni", "Te pasy są tylko tam, gdzie przylegało ubranie."], ["Lekarz", "Uczulenie na proszek albo na farbę z kostiumu. Mówiłem. Zawał."]],
		"termos": [["Lekarz", "Herbata. Mam ją wysłać do laboratorium? Za co? Panie, to był zawał."]],
		"kielich": [["Lekarz", "Kielich? Panie, ja tu mam nieboszczyka, a nie inwentaryzację."]],
		"lista_rekwizytow": [["Lekarz", "Kręciło mu się w głowie? No to serce. Wszystko się zgadza."]],
	},
	"lis": {
		"lista_rekwizytow": [["Lis", "To moja lista... A na dole jego pismo. Boże, on to pisał tutaj, sam."]],
		"termos": [["Lis", "Jego termos. Zawsze z nim chodził, nawet na scenę by go wziął, gdyby mógł."]],
		"kielich": [["Lis", "Czwarty kielich. Wszystkie cztery są na liście. Gdzie on leżał?"], ["Antoni", "Pod skrzynią."], ["Lis", "Adrian był pedantem. Nigdy by go tak nie zostawił."]],
		"telefon_adriana": [["Lis", "Jego telefon. Dzwoniłem do niego w sobotę rano, nie odbierał. Myślałem, że się obraził."]],
	},
	"nowicki": {
		"zdjecie_pasy": [["Nowicki", "Wysypka. Antek, ludzie mają alergie. Nie rób mi z tego sprawy."]],
	},
}

const SCENA6_NIC := {
	"lekarz": [["Lekarz", "Nie wiem, co pan chce mi pokazać."]],
	"lis": [["Lis", "(kręci głową) Nic mi to nie mówi."]],
	"nowicki": [["Nowicki", "I co z tego?"]],
}

const SCENA6_TLO := {
	"policjant": ["Jeszcze jedno.", "Z tej strony...", "Ciemno jak w grobie."],
	"lekarz": ["(pisze kartę)", "Godzina zgonu... nieznana."],
	"lis": ["Boże...", "(kaszle)"],
	"nowicki": ["(ziewa)", "Halo, komenda? Tak, zawał."],
}

const SCENA6_NAPISY := {
	"zegar": "Kwadrans Nowickiego: %d min",
}


# Scena 7: budka stróża, 0:40. Rozmowa z Zenonem to wybór tematów. Ładowarki nikt
# nie oferuje: trzeba pokazać Zenonowi rozładowany telefon Adriana.
const SCENA7 := {
	"zenon_start": [
		["", "Zenon nalewa wrzątek do szklanki w metalowym koszyczku. Ręce mu się trzęsą."],
	],
	"piatek": [
		["Antoni", "Co się działo w piątek?"],
		["Zenon", "Przyszedł o dziewiątej wieczorem. Po rekwizyty od dyrektora. Wpuściłem go i wróciłem do meczu."],
		["Zenon", "Mecz był nudny jak flaki z olejem. Zasnąłem przy telewizorze."],
		["Zenon", "Obudziłem się, jak już grali hymn na koniec programu. Światło w hali się paliło, to myślałem, że chłopak jeszcze pakuje."],
	],
	"wyglad": [
		["Antoni", "Jak wyglądał, kiedy przyszedł?"],
		["Zenon", "Był biały jak ściana i spocony. Mówił, że pali go skóra, jakby się poparzył. Myślałem, że grypa."],
	],
	"znalazl": [
		["Antoni", "Kiedy go pan znalazł?"],
		["Zenon", "Dziś wieczorem. Dyrektor dzwonił, czy ktoś odebrał rekwizyty. Poszedłem sprawdzić..."],
		["Zenon", "Leżał tam przy tych skrzyniach. Cały dzień tam leżał, a ja tu siedziałem i herbatę piłem."],
	],
	"papierosy": [
		["Zenon", "Pan weźmie papierosa. Ja już nie mogę, żona mi zabroniła, a w nerwach to cała paczka idzie."],
	],
	"pokaz_telefon": [
		["Antoni", "To telefon Adriana. Rozładowany."],
		["Zenon", "Kabel? Mam tu pół szuflady kabli, ludzie zostawiają, a ja nie wyrzucam."],
		["", "Zenon grzebie w szufladzie i wyciąga ładowarkę."],
		["Zenon", "Ta powinna pasować. Niech pan bierze."],
	],
	"pokaz_inne": [["Zenon", "Nie wiem, panie. Nic mi to nie mówi."]],
	"koniec_rozmowy": [["Zenon", "Jakby co, ja tu siedzę. Gdzie miałbym iść."]],
	"telewizor": [["", "Mini-telewizor. Powtórka meczu, ktoś przegrywa trzy do zera."]],
	"kalendarz": [["", "Kalendarz z 1999 roku. Pożółkła kartka z marcem, nikt jej nie przewrócił."]],
	"szuflada": [["", "Szuflada pełna splątanych kabli. Nie będę grzebał w cudzych rzeczach."]],
	"szuflada_potem": [["", "Kable, kable i jeszcze raz kable."]],
	"radio": [["", "Nocna audycja. Ktoś dzwoni do studia i opowiada o swoim kocie."]],
	"klucze": [["", "Tablica z kluczami. Przy jednym haczyku kartka: \"HALA\". Haczyk pusty."]],
	"okno": [["", "Za oknem leje. Na placu radiowóz z wyłączonym kogutem."]],
	"paczki_kupuje": [
		["Sprzedawca", "(ziewa) Pączek? Z różą, ostatni."],
		["", "Antoni płaci trzy złote i zjada go na miejscu."],
	],
	"paczki_bez": [["Sprzedawca", "Bez pieniędzy nie ma pączków. Noc długa, panie."]],
	"paczki_potem": [["Sprzedawca", "(ziewa) Więcej nie ma. Rano przywiozą."]],
	"pies": [["", "Kundel na łańcuchu warczy zza siatki. Lepiej nie podchodzić."]],
	"radio_potem": [["", "Prognoza pogody: deszcz do rana, w nocy z piątku na sobotę temperatura spadła do trzech stopni."]],
	"dziennik": [
		["", "Zeszyt w kratkę: \"Książka wejść i wyjść\". Rubryki: data, godzina, kto, cel, wyjście."],
		["", "\"pt. 18:30, dostawa farb, wyjście 18:50.\""],
		["", "\"pt. 21:00, aktor z teatru, po rekwizyty od dyr. Lisa.\" W rubryce \"wyjście\" pusto."],
		["", "Następny wpis jest z niedzieli: \"23:40, policja\"."],
	],
	"dziennik_potem": [["", "\"pt. 21:00, aktor z teatru, po rekwizyty.\" Wyjścia brak."]],
	"gazeta": [
		["", "Gazeta z programem telewizyjnym, otwarta na piątku. Kilka pozycji zakreślonych długopisem."],
		["", "\"20:45 Piłka nożna: mecz ligowy. 22:45 Studio sport. 23:50 Hymn. Zakończenie programu.\""],
	],
	"gazeta_potem": [["", "\"23:50 Hymn. Zakończenie programu.\""]],
	"smieciarka": "Za siatką przejeżdża śmieciarka. Pies dostaje szału.",
	"sprzedawca_start": [["Sprzedawca", "(ziewa) Pączki, panie władzo? Czy pytania?"]],
	"sprzedawca_piatek": [
		["Antoni", "Stał pan tu w piątek wieczorem?"],
		["Sprzedawca", "Stoję tu co noc od dziesiątej do szóstej. Taka robota. Kierowcy, taksówkarze, czasem ktoś z teatru."],
	],
	"sprzedawca_widzial": [
		["Antoni", "Widział pan kogoś, kto wychodził z hali?"],
		["Sprzedawca", "W piątek? Był taki jeden. Blady, młody. Chyba wpół do jedenastej, bo radio akurat dawało wiadomości."],
		["Sprzedawca", "Kupił wodę, dużą butelkę. Wypił połowę od razu, tu przy okienku. I cały czas się drapał."],
		["Sprzedawca", "Potem poszedł z powrotem do hali. Nie wyszedł już, chyba. Ale ja tam nie pilnuję, od tego jest Zenek."],
	],
	"sprzedawca_paczek": [["Antoni", "Poproszę pączka."]],
	"sprzedawca_nic": [["Sprzedawca", "(ziewa) Nie wiem, panie. Ja tu tylko pączki."]],
	"sprzedawca_koniec": [["Sprzedawca", "Smacznej nocy."]],
}

const SCENA7_DOWODY_SPRZEDAWCA := {
	"zdjecie_pasy": [["Sprzedawca", "No właśnie tak się drapał. Po karku i po ramionach, aż mu się koszula podwijała."]],
	"telefon_adriana": [["Sprzedawca", "Telefon? Nie, nie pamiętam, żeby miał telefon. Płacił drobnymi."]],
	"kielich": [["Sprzedawca", "Złoty kielich? Panie, ja tu mam pączki, nie skarby."]],
}

const SCENA7_TEMATY := [
	["Co się działo w piątek?", "piatek"],
	["Jak wyglądał Adrian?", "wyglad"],
	["Kiedy go pan znalazł?", "znalazl"],
]

const SCENA7_TLO := {
	"zenon": ["(siorbie herbatę)", "Jezus Maria...", "Taki młody chłopak..."],
	"pies": ["Hau! Hau!", "Wrrr...", "(skomli)"],
	"sprzedawca": ["(ziewa)", "Pączki, pączki...", "(liczy drobne)"],
}

# Scena 8: plac przed magazynem, 1:10. Przyjeżdża taksówka z Anią i Wolskim.
const SCENA8 := {
	"start": [["", "Mżawka. Pod latarnią Nowicki pisze coś w notesie, oparty o radiowóz."]],
	"taksowka": "Na plac wjeżdża taksówka.",
	"ania_start": [
		["Ania", "Gdzie on jest? Chcę go zobaczyć."],
		["Antoni", "Karetka już go zabrała."],
		["Ania", "(cicho) Czy on... bardzo cierpiał?"],
		["Antoni", "Nie wiem."],
	],
	"ania_kiedy": [
		["Antoni", "Kiedy ostatnio rozmawiała pani z Adrianem?"],
		["Ania", "W czwartek rano. Potem już się nie odzywał."],
	],
	"ania_magazyn": [
		["Antoni", "Wiedziała pani, że pojechał do magazynu?"],
		["Ania", "Nie. Wiedziałam, że Lis go gdzieś wysłał. Nie pytałam gdzie."],
	],
	"ania_jak": [
		["Antoni", "Jak się pani trzyma?"],
		["Ania", "Nie wiem. Jakby to się działo komuś innemu."],
	],
	"ania_nic": [["Ania", "(kręci głową) Nie wiem. Nie wiem, co to jest."]],
	"ania_koniec": [["Ania", "Przepraszam. Nie mogę teraz."]],
	"wolski_start": [
		["Wolski", "Co stwierdził lekarz?"],
		["Antoni", "Zawał."],
		["Wolski", "(wypuszcza powietrze, jakby długo je wstrzymywał) Zawał... Biedny chłopak."],
		["Wolski", "Panie Antoni. Dobrze, że pan tu był. I pan Zenon też."],
		["Wolski", "Proszę, herbata z termosu. Gorąca, z sokiem malinowym. Niech pan pije, zimno jak w psiarni."],
		["", "Antoni pije. Herbata parzy w gardło i rozgrzewa."],
		["Wolski", "Pan jest dobrym człowiekiem. Teatr ma u pana dług."],
	],
	"wolski_tu": [
		["Antoni", "Skąd pan wiedział, co się stało?"],
		["Wolski", "Ania zadzwoniła. Nie mogłem jej puścić samej, w nocy, w takim stanie."],
	],
	"wolski_adrian": [
		["Antoni", "Dobrze pan znał Adriana?"],
		["Wolski", "To był mój dubler. Zdolny chłopak, za skromny na ten zawód."],
		["Wolski", "Od poniedziałku grał za mnie. Mówią, że dobrze. Ja leżałem z gorączką."],
		["Wolski", "(zerka na Anię) Ale nie mówmy o tym teraz. Nie przy niej."],
	],
	"wolski_ania": [
		["Antoni", "Co teraz z Anią?"],
		["Wolski", "Ania, chodź. (do Antoniego) Zajmę się wszystkim, pogrzeb, papiery. Ona musi odpocząć."],
	],
	"wolski_nic": [["Wolski", "Panie Antoni, to sprawa dla policji. Niech pan odpocznie."]],
	"wolski_koniec": [["Wolski", "Jeszcze raz dziękuję. Za wszystko."]],
	"taksowkarz_start": [["Taksówkarz", "(stuka w licznik) Ja nic, panie, ja tylko czekam. Licznik bije."]],
	"taksowkarz_skad": [
		["Antoni", "Skąd ich pan wiózł?"],
		["Taksówkarz", "Z Mokotowa, spod bloku tej pani. Zamówili na wpół do pierwszej."],
		["Taksówkarz", "Śmieszna rzecz, tego pana wiozłem pod ten sam blok już wcześniej. Koło wpół do dwunastej, spod teatru."],
	],
	"taksowkarz_czeka": [
		["Antoni", "Długo pan będzie czekał?"],
		["Taksówkarz", "Ile trzeba. Pan aktor płaci, pan aktor wymaga."],
	],
	"taksowkarz_nic": [["Taksówkarz", "Panie, ja wożę ludzi, nie zagadki."]],
	"taksowkarz_koniec": [["Taksówkarz", "Jakby co, stoję tu."]],
	"gniazdko": [
		["Antoni", "Ma pan w aucie gniazdko? Telefon jest rozładowany."],
		["Taksówkarz", "Mam, w zapalniczce. Niech pan podepnie, byle szybko."],
		["", "Antoni podpina telefon Adriana. Po chwili ekran się zapala."],
		["", "Blokada PIN. Na górze ekranu: \"1 nowa wiadomość\". Nadawcy nie widać."],
		["", "Bez kodu nic więcej się nie da."],
	],
	"gniazdko_bez": [
		["Antoni", "Ma pan ładowarkę do telefonu?"],
		["Taksówkarz", "Gniazdko mam, kabla nie mam. Kto dziś woził ze sobą kable."],
	],
	"gniazdko_potem": [["", "Telefon ma trochę baterii. Blokada PIN, \"1 nowa wiadomość\"."]],
	"nowicki": [["Nowicki", "Antek, spiszę ich i jadę. Ty też jedź do domu, jutro też jest dzień."]],
	"nowicki_jedziemy": [
		["Nowicki", "Państwo pozwolą. Imię, nazwisko, adres. Formalność."],
		["", "Nowicki spisuje Anię i Wolskiego. Wolski dyktuje za Anię."],
		["Nowicki", "To wszystko. Dobranoc państwu."],
	],
	"wolski_telefon": [["Wolski", "Jego telefon? Niech mi pan go da, przekażę rodzinie. Po co ma pan się z tym nosić."]],
	"wolski_telefon_oddal": [["", "Wolski chowa telefon do wewnętrznej kieszeni płaszcza."], ["Wolski", "Dziękuję. Rodzina będzie wdzięczna."]],
	"wolski_telefon_nie": [["Antoni", "Zostawię go sobie. Na razie."], ["Wolski", "(uśmiecha się) Jak pan uważa."]],
	"wolski_telefon_potem": [["Wolski", "Pan wie lepiej, panie Antoni."]],
	"brama": [["", "Brama magazynu zaklejona taśmą. Na kłódce świeża plomba."]],
	"radiowoz": [["", "Na siedzeniu radiowozu leży otwarty notes Nowickiego."], ["", "\"Dubler z teatru. Przyczyna: serce? (lekarz). Zgłosił: stróż.\""]],
	"kaluza": [["", "W kałuży odbija się latarnia. Miga, jakby zaraz miała zgasnąć."]],
	"latarnia": [["", "Latarnia brzęczy i mruga. Ktoś przykleił do niej ogłoszenie: \"Zaginął kot, rudy\"."]],
	"kiosk": [["", "Okienko z pączkami zamknięte na noc. Kartka: \"Zaraz wracam\"."]],
	"auto": [["", "Twoje auto. Nowicki jeszcze tu jest, wypada się pożegnać."]],
	"auto_jedz": [["Antoni", "Na dziś wystarczy."]],
}

const SCENA8_WYBOR := ["Możemy kończyć", "Jeszcze chwilę"]
const SCENA8_TELEFON_WYBOR := ["Oddaj mu telefon", "Zostawię go sobie"]

const SCENA8_DOWODY := {
	"ania": {
		"telefon_adriana": [["", "Ania odwraca wzrok."], ["Ania", "Schowaj to. Proszę."]],
		"zdjecie_pasy": [["", "Ania zakrywa usta dłonią."], ["Ania", "Nie chcę tego oglądać."]],
		"kielich": [["Ania", "Z drugiego aktu. On je zawsze polerował przed spektaklem."]],
		"termos": [["Ania", "To jego. Herbata z cytryną. Zawsze z cytryną."]],
		"lista_rekwizytow": [["", "Ania czyta dopisek na dole. Kartka drży jej w palcach."], ["Ania", "To jego pismo."]],
	},
	"wolski": {
		"zdjecie_pasy": [["Wolski", "Biedak. Pewnie od kurzu w tym magazynie, tam nikt nie sprząta od lat."]],
		"kielich": [["Wolski", "Rekwizyty. Niech pan to zostawi, Lis się zajmie."]],
		"termos": [["Wolski", "Ma pan dobre oko. Ja swój noszę od dwudziestu lat."]],
	},
	"taksowkarz": {},
}

const SCENA8_TLO := {
	"zenon": ["Panie Antoni, może parasol?", "(kaszle)", "Taki młody chłopak..."],
	"nowicki": ["(pisze w notesie)", "Cholerna mżawka..."],
	"ania": ["(płacze cicho)", "Adrian..."],
	"wolski": ["Już, już, Aniu.", "(obejmuje Anię)"],
	"taksowkarz": ["(stuka w licznik)", "(ziewa)"],
}

const SCENA8_NAPISY := {
	"koniec": "Koniec rozdziału 2",
	"godzina": "Antoni wraca do domu o drugiej w nocy.",
	"dalej": "Rozdział 3: Plama",
}

# ---------- ROZDZIAŁ 3 ----------

# Scena 9: niedziela 11:00, foyer w żałobie, gabinet Lisa i bufet.
const SCENA9 := {
	# SMS od Nowickiego (szefa Antoniego) na początek śledztwa: wolna ręka na 5 dni
	"sms_szef": "Antoni. Nie wierzę w te twoje teorie, ale masz pięć dni, do pogrzebu. Dzwoniłem do dyrektora Lisa, do pralni i wszędzie, gdzie możesz chodzić. Masz zgodę na wejścia, ludzie wiedzą, że jesteś od nas. Nikt się nie będzie dziwił. Po pogrzebie zamykamy temat.",
	"sms_szef_czyta": [["", "SMS od Nowickiego, 9:12 (telefon, Q)."], ["", "\"Masz pięć dni, do pogrzebu. Masz zgodę na wejścia: teatr, pralnia, wszędzie. Ludzie wiedzą, że jesteś od nas.\""], ["Antoni", "Pięć dni. I żadnych pytań, czemu łażę po cudzych garderobach. Dobra, szefie."]],
	"poczatek": [["", "Na drzwiach teatru czarna wstążka. W foyer pachnie płynem do podłóg i zwiędłymi kwiatami."]],
	"zdjecie": [
		["", "Zdjęcie Adriana w czarnej ramce. Świeczka, kilka goździków, kartki kondolencyjne."],
		["", "\"Zawsze w drugim rzędzie, a grałeś jak w pierwszym. Zespół.\""],
		["", "\"Adriankowi, od pani Stasi z czwartego rzędu.\""],
		["", "\"Do zobaczenia za kulisami. M.\""],
		["", "Ostatnia kartka, bez koperty: \"Przepraszam. Kocham. A.\" Duże A wywinięte w pętelkę, pod spodem kreska."],
	],
	"zdjecie_potem": [["", "Świeczka dopala się. Ktoś dołożył jeszcze jeden goździk."]],
	"wstazka": [["", "Czarna wstążka przypięta pinezką. Pod spodem kartka: \"Spektakl we wtorek odbędzie się zgodnie z planem\"."]],
	"aktor": [["Aktor", "(cicho) Nie mogę uwierzyć. W czwartek jeszcze z nim grałem scenę z kielichem."]],
	"aktor_potem": [["Aktor", "Dajmy mu dziś spokój. Wszystkim dajmy."]],
	"aktorka": [["Aktorka", "Był taki blady na próbie. Mówiłam mu, idź do lekarza. Śmiał się, że to trema."]],
	"aktorka_potem": [["Aktorka", "(wyciera oczy chusteczką)"]],
	"sprzataczka": [["Sprzątaczka", "Po bankiecie wino aż do szatni. Trzy razy myję i dalej się klei."]],
	"sprzataczka_potem": [["Sprzątaczka", "Niech pan uważa, mokre."]],
	"personel_zamkniete": [["Antoni", "Lis prosił, żebym przyszedł do gabinetu. Najpierw on."]],
	"wyjscie_bez_kwitu": [["Antoni", "Lis prosił, żebym przyszedł. Nie wyjdę, zanim z nim nie pogadam."]],
	"gabinet_wejscie": [["", "Gabinet dyrektora. Zasłony do połowy, na biurku papiery do sufitu."]],
	"lis_prosba": [
		["Lis", "Panie Antoni. Dziękuję, że pan przyszedł. Nie spałem całą noc."],
		["Lis", "We wtorek gramy drugi spektakl. Musimy. Bilety sprzedane, kasa pusta."],
		["Lis", "A kostium Wolskiego jest w pralni. Ktoś go oddał w czwartek, a teraz nikt nie ma głowy, żeby odebrać."],
		["Lis", "Czy pan by mógł? Kwit gdzieś tu leży. Na biurku. Gdzieś."],
	],
	"lis_kto": [
		["Antoni", "Kto oddał kostium do pralni?"],
		["Lis", "Nie wiem. W piątek rano kwit leżał w mojej przegródce z dopiskiem \"do odbioru\". Ktoś z garderoby, pewnie."],
	],
	"lis_kostium": [
		["Antoni", "Adrian grał w kostiumie Wolskiego?"],
		["Lis", "Od wtorku do czwartku, na próbach, kiedy Wolski leżał z gorączką. Jeden kostium, szyty na Wolskiego."],
		["Lis", "Na Adriana trochę za szeroki w ramionach. Irena chciała zwęzić, nie zdążyła."],
	],
	"lis_pogrzeb": [
		["Antoni", "Kiedy pogrzeb?"],
		["Lis", "W piątek w południe. Wolski wszystko załatwia. Złoty człowiek."],
	],
	"lis_nic": [["Lis", "Panie Antoni, ja nie mam do tego głowy. Kostium, wtorek. Tylko tyle."]],
	"lis_koniec": [["Lis", "Kwit, kwit... gdzie ja go położyłem."]],
	"lis_po_kwicie": [["Lis", "Pralnia jest na Kopernika. Dziękuję panu. Naprawdę."]],
	"papiery": [["", "Rachunki za prąd, faktury za farbę, wezwanie do zapłaty z ZUS-u. Kwitu nie ma."]],
	"papiery_potem": [["", "Same rachunki."]],
	"teczki": [["", "Teczki z umowami aktorów. Na wierzchu umowa Adriana, niepodpisana do końca. Kwitu nie ma."]],
	"teczki_potem": [["", "Umowy. Nic więcej."]],
	"popielniczka": [
		["", "Popielniczka pełna petów. Pod nią przyciśnięty mały niebieski kwit."],
		["", "\"Pralnia Perła. Odbiór: kostium sceniczny, 1 szt. Nr 0412.\""],
	],
	"popielniczka_potem": [["", "Same pety."]],
	"telefon_lisa": [["", "Stary telefon z tarczą. Słuchawka jeszcze ciepła."]],
	"szuflada_lisa": [["", "Szuflada zamknięta na kluczyk. Nie moja sprawa."]],
	"obsada": [
		["", "Na tablicy korkowej obsada \"Ostatniego aktu\". Przy nazwisku Wolskiego dopisane długopisem:"],
		["", "\"dubler: Adrian (wt–czw)\""],
	],
	"kalendarz_lisa": [["", "Kalendarz ścienny. Wtorek zakreślony na czerwono: \"SPEKTAKL II, 20:00\"."]],
	"okno_lisa": [["", "Podwórze teatru. Kontenery z dekoracjami i mokre kocie ślady na dachu szopy."]],
	"regal_lisa": [["", "Segregatory: \"Sezon 1998\", \"Sezon 1999\"... aż do dziś. Lis niczego nie wyrzuca."]],
	"kanapa_lisa": [["", "Kanapa z pogniecionym kocem. Lis tu spał."]],
	"kuba_wchodzi": [
		["Kuba", "Panie dyrektorze... Pani Irena mówi, że mam przyjść do miary. Na dublera."],
		["Kuba", "I słyszałem o kostiumie. Mieszkam obok pralni, mogę odebrać."],
		["Lis", "Nie, Kuba, ty się ucz roli. Pan Antoni pojedzie."],
		["", "Kuba patrzy na kwit w ręku Antoniego."],
	],
	"kuba_dubler": [
		["Antoni", "Jesteś nowym dublerem?"],
		["Kuba", "Pan dyrektor zadzwonił do mnie rano. Nie ma nikogo innego. Ja... wiem, jak to wygląda."],
	],
	"kuba_czwartek": [
		["Antoni", "Gdzie byłeś w czwartek rano?"],
		["Kuba", "Na zajęciach. Na uczelni. Gdzie miałbym być?"],
		["", "Kuba odpowiada za szybko."],
	],
	"kuba_pralnia": [
		["Antoni", "Mieszkasz obok pralni?"],
		["Kuba", "Pod siódemką, na Kopernika. Pani Halina mnie zna."],
	],
	"kuba_nic": [["Kuba", "Nie wiem, proszę pana. Naprawdę."], ["Kuba", "(patrzy na drzwi) Muszę lecieć, pani Irena czeka."]],
	"kuba_koniec": [["Kuba", "To ja... idę do pani Ireny."]],
	"kuba_kwit": [["", "Kuba wyciąga rękę."], ["Kuba", "Niech pan da. Ja i tak idę do domu, to po drodze."]],
	"kuba_kwit_dal": [
		["", "Antoni oddaje kwit. Kuba chowa go do kieszeni."],
		["Kuba", "Dziękuję! Przyniosę jutro, słowo."],
		["Lis", "Kuba... No dobrze. Tylko ostrożnie z tym kostiumem."],
		["", "Kuba wychodzi szybkim krokiem."],
	],
	"kuba_kwit_nie": [["Antoni", "Pojadę sam."], ["", "Kuba cofa rękę."]],
	"lis_kwit_kuba": [["Lis", "Kuba pojechał z kwitem. Mieszka obok, to i lepiej."]],
	"ania_kostium": [
		["Antoni", "Adrian mówił coś o kostiumie?"],
		["", "Ania milknie na chwilę."],
		["Ania", "Nie. Nic nie mówił."],
	],
	"ania_piatek": [
		["Antoni", "Gdzie pani była w piątek wieczorem?"],
		["Ania", "W domu. Sama. Myślałam, że on jest obrażony i dlatego nie dzwoni."],
	],
	"ania_jak": [
		["Antoni", "Jak się pani trzyma?"],
		["Ania", "Nie wiem. Wszędzie jego zdjęcia, jego kubek w bufecie. Lis pozwolił mi tu posiedzieć."],
	],
	"ania_nic": [["Ania", "Nie wiem. Przepraszam."]],
	"ania_koniec": [["Ania", "(odwraca się do okna)"]],
	"ania_kanapa": [["Ania", "(siedzi na kanapie Lisa, patrzy w okno)"]],
	"bufetowa_start": [
		["Bufetowa", "Panie Antoni... Proszę, kanapka. Na koszt firmy."],
		["Bufetowa", "Proszę jeść. Adrian zawsze brał z serem. Zawsze z serem..."],
	],
	"bufetowa_czwartek": [
		["Antoni", "Był tu w czwartek?"],
		["Bufetowa", "Na próbie był. Blady jak papier. Nic nie zjadł, tylko kawę wypił i drapał się po karku."],
	],
	"bufetowa_rano": [
		["Antoni", "Kto bywa w teatrze rano?"],
		["Bufetowa", "Rano? Ja przychodzę na dziesiątą. Wcześniej to tylko mleczarz, w czwartki przywozi mleko. I portier."],
	],
	"bufetowa_jak": [
		["Antoni", "Jak się pani trzyma?"],
		["Bufetowa", "Jakoś. Ktoś musi tę kawę parzyć."],
	],
	"bufetowa_nic": [["Bufetowa", "Nie wiem, panie Antoni. Ja tu tylko kawę."]],
	"bufetowa_koniec": [["Bufetowa", "Jakby pan był głodny, to ja tu jestem."]],
	"stasia": [["Pani Stasia", "Przyniosłam mu goździki. Na premierze się do mnie uśmiechnął. Do mnie, z czwartego rzędu."]],
	"stasia_idzie": "Pani Stasia kładzie goździki pod zdjęciem.",
}

const SCENA9_DOWODY := {
	"lis": {
		"zdjecie_pasy": [["Lis", "Lekarz mówił, uczulenie. Panie Antoni, niech pan mi tego nie pokazuje."]],
		"telefon_adriana": [["Lis", "Niech pan odda rodzinie. Albo policji. Ja nie mam do tego głowy."]],
		"lista_rekwizytow": [["Lis", "Moja lista. Gdybym go tam nie wysłał..."]],
		"kielich": [["Lis", "Czwarty kielich. Dobrze, że się znalazł, we wtorek będzie potrzebny."]],
		"kwit_odbioru": [["Lis", "O, jest. Gdzie on był? Pralnia na Kopernika, pan trafi."]],
	},
	"kuba": {
		"telefon_adriana": [["Kuba", "Telefon Adriana? Ja... ja nic do niego nie pisałem."]],
		"zdjecie_pasy": [["Kuba", "O Boże. Co to jest?"]],
		"kielich": [["Kuba", "Z drugiego aktu. Ja w nim podaję wino. Jako statysta."]],
	},
	"ania": {
		"telefon_adriana": [["Ania", "(odwraca wzrok) Mówiłam już. Schowaj to."]],
		"zdjecie_pasy": [["Ania", "Przestań mi to pokazywać. Proszę."]],
		"termos": [["Ania", "Jego termos. Oddasz mi go potem?"]],
		"kielich": [["Ania", "Z drugiego aktu. Pamiętam."]],
	},
	"bufetowa": {
		"zdjecie_pasy": [["Bufetowa", "Jezus Maria. Tak się właśnie drapał. Tu, przy ladzie."]],
		"termos": [["Bufetowa", "Jego termos! Zawsze mu nalewałam wrzątku. Herbata z cytryną."]],
		"kielich": [["Bufetowa", "To z rekwizytorni, nie ode mnie."]],
	},
}

const SCENA9_KWIT_WYBOR := ["Daj mu kwit", "Pojadę sam"]

const SCENA9_TLO := {
	"aktor": ["(milczy)", "(kręci głową)"],
	"aktorka": ["(pociąga nosem)", "Taki młody..."],
	"sprzataczka": ["(chlup, chlup)", "Klei się i klei..."],
	"bufetowa": ["(wyciera ladę)", "(radio gra cicho Chopina)"],
	"lis": ["(przerzuca papiery)", "Gdzie to jest..."],
}

# Scena 10: pralnia pani Haliny, niedziela 15:00. Wersja zwykła albo (s9_kwit_kuba)
# taka, w której Kuba odebrał kostium przed południem.
const SCENA10 := {
	"poczatek": [["", "Dzwonek nad drzwiami. Ciepło, para i zapach krochmalu. Za ścianą dudni pralka."]],
	"halina_start": [
		["Halina", "Dzień dobry, dzień dobry! Pan z teatru? Po kostium pana Wolskiego?"],
		["Antoni", "Tak. Kwit numer 0412."],
		["Halina", "Zaraz, zaraz... Był tu gdzieś. Ja już ślepa jestem, panie. Niech pan sam poszuka na stojakach, numery są na zawieszkach."],
	],
	"halina_start_kuba": [
		["Halina", "Dzień dobry! Pan z teatru? Jeśli po kostium pana Wolskiego, to już nie ma."],
		["Halina", "Ten młody spod siódemki odebrał przed dwunastą. Mokry jeszcze, nie chciał czekać na prasowanie."],
	],
	"stojak": [
		["", "Zawieszki: 0388, 0415, 0402, 0397. Płaszcz, garnitur, dwie sukienki."],
		["", "Zawieszki: 0420, 0391, 0409. Firanki i obrus z kościoła."],
		["", "Zawieszki: 0377, 0418, 0400, 0411, 0414. Mundur kolejarza i kurtki."],
		["", "Zawieszki: 0403, 0412, 0396. Pod folią ciemny, ciężki kostium ze złotymi guzikami."],
	],
	"stojak_pusto": [["", "Zawieszki: 0403, 0396 i pusty wieszak z kartką \"0412, ODEBRANY\"."]],
	"znalazl": [
		["Antoni", "Jest. 0412."],
		["Halina", "O, pan ma oko! Niech pan go położy na stole przy prasowalnicy, tam jest lampa."],
	],
	"lampa_bez": [["", "Stół prasowalnicy pod lampą. Pusty, ciepły od pary."]],
	"plama": [
		["", "Antoni rozkłada kostium pod lampą i odwija połę marynarki."],
		["", "Na bordowej podszewce, od karku przez ramiona, ciągnie się plama. Matowa, a w świetle lekko błyszczy."],
		["", "Antoni robi zdjęcie."],
	],
	"plama_zapach": [["", "Od podszewki idzie zapach. Słodkawy, chemiczny, a pod spodem coś zgniłego."]],
	"plama_potem": [["", "Plama na podszewce. W świetle lampy połyskuje jak lakier."]],
	"halina_plama": [
		["Halina", "Trzydzieści lat piorę i pierwszy raz coś mi nie schodzi. Jutro będzie jak nowy, słowo daję."],
		["Halina", "Niech pan go zostawi jeszcze na jeden dzień. Proszę."],
	],
	"ksiazka": [
		["", "Książka przyjęć. Rubryki: numer, rzecz, kto, data i godzina ze stempla."],
		["", "\"0412. Kostium sceniczny, teatr. Skrzynka nocna. Stempel: czw. 23:40. Podpis: A.\""],
		["", "Podpis to jedna litera, ale charakterna: duże A wywinięte u góry w pętelkę, pod spodem zamaszysta kreska."],
		["", "Adrian, Adam, Adamczyk... Połowa teatru podpisałaby się \"A.\". Ale nie każdy robi pętelkę."],
	],
	"ksiazka_potem": [["", "\"Stempel: czw. 23:40. Podpis: A.\" Pętelka u góry, kreska pod spodem."]],
	"skrzynka_nocna": [["", "Skrzynka nocna w drzwiach. W środku zegar, który stempluje godzinę na każdym worku. Nie spóźnia się, pani Halina pilnuje."]],
	"bulki": [["Halina", "Niech pan weźmie bułkę, pan taki blady. Detektywi też muszą jeść."]],
	"bulki_potem": [["", "Bułki z piekarni obok. Jedną już wziąłem."]],
	"kot": [["", "Rudy kot śpi na ręcznikach. Otwiera jedno oko i zamyka z powrotem."]],
	"kot_potem": [["", "(mruczy)"]],
	"zaplecze": [["", "Za drzwiami dudni wielka pralka. Pani Halina nie wpuszcza tam klientów."]],
	"zegar": [["", "Zegar ścienny. Piętnasta dwanaście."]],
	"halina_kto": [
		["Antoni", "Kto oddał ten kostium?"],
		["Halina", "Ktoś wrzucił do skrzynki nocnej. Rano wyjęłam worek, a na kartce tylko \"kostium, teatr, A.\" Zegar wybił godzinę na worku."],
	],
	"halina_co": [
		["Antoni", "Co to za plama?"],
		["Halina", "Ani wino, ani krew, ani tłuszcz. Błyszczy się jak lakier. Odplamiacz nic, wrzątek nic."],
	],
	"halina_pytal": [
		["Antoni", "Ktoś jeszcze pytał o ten kostium?"],
		["Halina", "Pan pierwszy, który przyszedł. Ale telefonów było..."],
	],
	"halina_pytal_kuba": [
		["Antoni", "Ten młody coś mówił?"],
		["Halina", "Mówiłam mu o plamie, że nie schodzi. A on, że teatr się zajmie, i poleciał z mokrym."],
	],
	"halina_telefon": [
		["Antoni", "Ktoś dzwonił w sprawie kostiumu?"],
		["Halina", "Dzwonił! W sobotę jakiś pan. Głos taki... aktorski. Pytał, czy ten kostium można po prostu wyrzucić."],
		["Halina", "Wyrzucić! Kostium za tyle pieniędzy! Nie przedstawił się."],
	],
	"halina_mlody": [
		["Antoni", "Kto jeszcze tu bywa z teatru?"],
		["Halina", "Ten młody spod siódemki, student. W czwartek pytał o kostium z teatru, czy już przyszedł. Nerwowy taki."],
	],
	"halina_nic": [["Halina", "Panie, ja się na tym nie znam. Ja tylko piorę."]],
	"halina_koniec": [["Halina", "Do widzenia, do widzenia! Niech pan uważa, ślisko."]],
	"klientka": [["Klientka", "Ślub w sobotę! Suknia po mamie, a pani Halina wyprała ją jak nową. Cudotwórczyni."]],
	"klientka_potem": [["Klientka", "Pan też przyjdzie na wesele? Żartuję. Ale ciasto będzie dobre."]],
}

const SCENA10_DOWODY := {
	"zdjecie_pasy": [["Halina", "Jezus... Takie pasy to jak od pokrzywy. Albo od złej chemii, ludzie po farbiarni tak mają."]],
	"kielich": [["Halina", "Kielichów nie piorę, panie."]],
	"lista_rekwizytow": [["Halina", "Nie moje pismo, nie moja sprawa."]],
}

const SCENA10_TLO := {
	"halina": ["(nuci)", "(paruje żelazko)", "Gdzie ja to..."],
	"klientka": ["Ślub w sobotę!", "Mama by się popłakała..."],
}


# Scena 11: pracownia kostiumów, niedziela 18:00. Irena zaczyna mówić dopiero,
# gdy Antoni pokaże jej zdjęcie plamy albo pasów na skórze.
const SCENA11 := {
	"poczatek": [["", "Pracownia kostiumów. Stukot maszyny do szycia, radio gra cicho. Za oknem leje."]],
	"irena_start": [
		["Irena", "Jak pan po opaskę, to jutro. Jak po co innego, to nie mam czasu."],
		["Irena", "(nie podnosi głowy znad maszyny)"],
	],
	"irena_znowu": [["Irena", "No?"]],
	"irena_kostium": [
		["Antoni", "Kostium pana Wolskiego. Ten z pralni."],
		["Irena", "Moja robota. Szyłam go trzy lata temu, na \"Króla\". Leżał jak ulał. I co z tego?"],
	],
	"irena_klucz": [
		["Antoni", "Kto ma klucz do pracowni?"],
		["Irena", "Ja i dyrekcja. Aktorzy przychodzą na przymiarki, kiedy im się przypomni."],
		["Irena", "Adrian pożyczał klucz temu studentowi, Kubie. Myślą, że nie wiem. Wszystko wiem."],
	],
	"irena_zapas": [
		["Antoni", "Na manekinie wisi drugi taki sam kostium."],
		["Irena", "Zapasowy. W nim pan Wolski grał premierę, bo tamten w piątek rano zniknął z wieszaka. Całą noc mu pas poszerzałam."],
		["Irena", "Po premierze oddał i nawet nie podziękował. A tamten? Nikt nie wie, kto go zabrał. Ja nie pytam."],
	],
	"irena_foto": [
		["Antoni", "Zdjęcie na ścianie. To z czwartku?"],
		["Irena", "Z próby generalnej. Fotograf z gazety. Adrian w kostiumie Adama, ja z boku, jak zawsze."],
		["Irena", "Kto obok? Nie pamiętam. Kręciło się tam pół zespołu i ten student z kluczem."],
		["Irena", "Sygnet? Z rekwizytorni, do \"Króla\". Nosi go każdy, kto akurat gra dworzanina. Chłopy i baby."],
	],
	"irena_nozyczki": [
		["Antoni", "Pożyczy mi pani nożyczki?"],
		["Irena", "Nikomu nie pożyczam nożyczek. Nikomu."],
	],
	"plama": [
		["Irena", "(zdejmuje okulary, patrzy długo)"],
		["Irena", "To nie farba. I nie pot. Pot tak nie błyszczy."],
	],
	"pasy": [
		["Irena", "Jezus Maria..."],
		["Irena", "To idzie szwami. Kark, ramiona, pod pachami. Dokładnie tak jest wszyta podszewka."],
	],
	"podszewka": [
		["Irena", "Na próbie mówił, że podszewka piecze."],
		["Irena", "Powiedziałam mu, żeby nie marudził. Że Adam nosi to od miesiąca i żyje."],
		["Irena", "(odwraca się do okna)"],
		["Irena", "Proszę nikomu nie mówić, że płakałam."],
	],
	"irena_okno": [["Irena", "(stoi przy oknie, nie odwraca się)"], ["Irena", "Niech pan robi, co ma robić."]],
	"irena_opaska": [
		["Antoni", "Mogę wziąć jedną opaskę?"],
		["Irena", "Bierz pan. Dla Adriana."],
	],
	"irena_nic": [["Irena", "Panie, ja szyję. Na papierach się nie znam."]],
	"irena_kwit": [["Irena", "Pralnia Perła. Halina pierze najlepiej w mieście, a i tak nie dała rady?"]],
	"irena_koniec": [["Irena", "(wraca do maszyny)"]],
	"irena_okno_koniec": [["Irena", "(dalej patrzy w okno)"]],
	"nozyczki_nie": [["", "Irena podnosi wzrok znad maszyny i patrzy na moje ręce. Lepiej nie teraz."]],
	"nozyczki": [["", "Duże nożyczki krawieckie. Ostre jak brzytwa. Irena stoi tyłem."], ["", "Biorę je."]],
	"nozyczki_potem": [["", "Na stole skrawki materiału i kreda krawiecka."]],
	"opaski": [["", "Stosik czarnych opasek na rękaw. Każda równiutko obszyta."]],
	"foto": [
		["", "Zdjęcie w ramce. Na dole długopisem: \"czwartek, próba generalna\"."],
		["", "Adrian w kostiumie Wolskiego, z kryzą i złotymi guzikami. Z boku Irena z igłą w ustach."],
		["", "Obok Adriana ktoś stoi, ale twarz zasłonił odblask lampy. Widać tylko dłoń na jego ramieniu, z grubym złotym sygnetem."],
	],
	"foto_potem": [["", "Czwartek, próba generalna. Dłoń z sygnetem na ramieniu Adriana."]],
	"manekin_wolski": [
		["", "Drugi egzemplarz kostiumu Wolskiego. Ten sam krój, kryza, złote guziki, tylko sprany."],
		["", "Odchylam połę. Podszewka szara, stara. Nic na niej nie ma."],
	],
	"manekin_wolski_potem": [["", "Zapasowy kostium. Podszewka szara i czysta."]],
	"manekiny": [["", "Suknie z falbanami na dwóch manekinach. Szpilki wbite w gorsety."]],
	"radio": [["", "Audycja o ogrodach. \"Róże przycinamy przed pierwszymi przymrozkami...\""]],
	"radio_potem": [["", "\"...a cebulki tulipanów sadzimy jesienią, na głębokość trzech cebulek.\""]],
	"okno": [["", "Deszcz na podwórzu teatru. Pod daszkiem ktoś z obsługi pali papierosa."]],
	"stojak": [["", "Kostiumy do \"Ostatniego aktu\". Na każdym wieszaku kartka z nazwiskiem. Wieszak \"Wolski\" pusty."]],
	"regal": [
		["", "Pudełka z guzikami, szpulki, kreda. Między nimi zeszyt \"Przymiarki\"."],
		["", "\"Wolski: ostatnia przymiarka trzy tygodnie temu. Adrian: kostium 0412, poniedziałek, bez poprawek.\""],
	],
	"regal_potem": [["", "Zeszyt przymiarek. Adrian dostał kostium 0412 w poniedziałek."]],
	"szafa": [["", "Zamknięta na klucz."]],
	"lustro": [["", "Wyglądam, jakbym nie spał od soboty. Bo nie spałem."]],
	"parawan": [["", "Za parawanem przebierają się aktorzy. Na haczyku wisi zapomniany krawat."]],
	"kosz": [["", "Kosz pełen ścinków. Same kolorowe resztki, nic bordowego."]],
	"bele": [["", "Bele materiału z metkami hurtowni. Aksamit, len, atłas."]],
	"deska": [["", "Deska do prasowania, żelazko jeszcze ciepłe."]],
	"kufer": [["", "Kufer na kłódkę. Klucz pewnie ma Irena."]],
}

const SCENA11_TLO := {
	"irena": ["(stuk-stuk maszyny)", "Cholerna nitka...", "(pociąga nosem)"],
	"irena_okno": ["(pociąga nosem)", "(patrzy w deszcz)"],
}



# Scena 11b (rozdział 3): kulisy, niedziela 20:00. Teatr zamknięty na żałobę, ale ekipa
# jeszcze siedzi. Gracz sam chodzi i wypytuje: sprzątaczka (klucze pod skrzynią),
# maszynista (czwartek 7:45 pod pracownią), garderobiana (kłamie, pęka przy zdjęciu
# plamy), Kuba (kłamie o czwartkowej nocy, pęka przy kwicie albo słowach Haliny).
const SCENA11B := {
	"plansza": "Kulisy, niedziela 20:00",
	"start": [["", "Teatr zamknięty na żałobę, ale za sceną pali się światło. Ekipa jeszcze siedzi. Każdy coś widział, tylko nikt nie lubi mówić pierwszy."]],
	"marta": [
		["Marta", "Panie Antoni? O tej porze? We wtorek robimy minutę ciszy na scenie, wszystko na mojej głowie."],
		["Marta", "Kto tu jest? Maszynista przy pulpicie, garderobiana Wolskiego przy wieszaku, sprzątaczka gdzieś łazi, a Kuba gada do tronu. Od piątku tylko to robi."],
		["Marta", "I niech pan weźmie na taksówkę, w niedzielę autobusy jeżdżą jak chcą. Teatr stawia. (wciska banknot)"],
	],
	"marta_potem": [["Marta", "Nie mam teraz głowy, panie Antoni. Naprawdę."]],
	# sprzątaczka: najpierw klucze, potem mówi
	"sprzataczka_start": [
		["Sprzątaczka", "Niech pan nie depcze, dopiero umyłam. I niech pan nie pyta, bo nie mam czasu."],
		["Sprzątaczka", "Zgubiłam klucze od schowka. Bez nich nie wyjdę stąd do rana, tam mam płaszcz."],
	],
	"sprzataczka_bez": [["Sprzątaczka", "Klucze, panie. Najpierw klucze. Gdzieś przy skrzyniach mi wypadły, jak przesuwałam."]],
	"klucze": [["", "Pod skrzynią, w kurzu: pęk kluczy z plastikową zawieszką \"SCHOWEK\"."]],
	"klucze_potem": [["", "Kurz i stare konfetti."]],
	"klucze_oddane": [
		["Sprzątaczka", "Moje klucze! No to pyta pan. Szybko."],
	],
	"sprzataczka_czwartek": [
		["Sprzątaczka", "W czwartek? Myłam korytarz przy wyjściu dla aktorów. Koło jedenastej w nocy."],
		["Sprzątaczka", "Wyszedł ktoś. Drobny, w kapturze. Pokrowiec na ubranie pod pachą, taki długi, na kostium."],
		["Sprzątaczka", "Twarzy nie widziałam. Ale pachniało za nim perfumami. Drogimi, jak w garderobach. Tu wszyscy się leją, panowie też."],
	],
	"sprzataczka_adrian": [["Sprzątaczka", "Pan Adrian zawsze mówił \"dzień dobry\". Jako jedyny. Reszta przechodzi, jakby mnie nie było."]],
	"sprzataczka_nic": [["Sprzątaczka", "Ja się na tym nie znam. Ja tylko sprzątam."]],
	"sprzataczka_koniec": [["Sprzątaczka", "Idę, póki mam klucze."]],
	# maszynista
	"maszynista_start": [["Maszynista", "Detektyw, co? Słyszałem. Siadaj, jak chcesz. Ja tu jeszcze godzinę liny sprawdzam."]],
	"maszynista_czwartek": [
		["Maszynista", "W czwartek rano? Niosłem drabinę koło pracowni, za kwadrans ósma."],
		["Maszynista", "Drzwi uchylone, światło się paliło. Na stojaku kostium z kartką \"WOLSKI, próba czw.\" I nikogo. Ireny jeszcze nie było, ona przychodzi po dziewiątej."],
		["Maszynista", "Pomyślałem: ktoś wyszedł na chwilę. Kto? Nie wiem. Drabina była ciężka."],
	],
	"maszynista_proba": [["Maszynista", "Na próbie dubler się drapał, cały czas za kołnierz. Myślałem, że nerwy. Pierwszy raz w roli Wolskiego."]],
	"maszynista_wolski": [["Maszynista", "Wolski? Gwiazda. Daje napiwki jak pan z filmu. Ale jak coś nie po jego myśli, to nagle cichnie i patrzy. Nie lubię tego patrzenia."]],
	"maszynista_nic": [["Maszynista", "Nie moja działka, szefie."]],
	"maszynista_koniec": [["Maszynista", "To ja wracam do lin."]],
	# garderobiana Wolskiego: kłamie
	"garderobiana_start": [["Garderobiana", "Panie, ja tu tylko wieszam. Kostiumów pana Wolskiego nikt nie rusza oprócz mnie."]],
	"garderobiana_kto": [["Garderobiana", "Nikt o nic nie pytał. Po co ktoś miałby pytać o kostiumy?"], ["", "Odwraca się do wieszaka trochę za szybko."]],
	"garderobiana_peka": [
		["Garderobiana", "(patrzy na zdjęcie długo) To... to jest ta podszewka? Od tego?"],
		["Garderobiana", "Dobrze. Powiem. W środę wieczorem pytała mnie Ania. W którym kostiumie pan Wolski gra jutro na próbie i kiedy idzie do pracowni do poprawki."],
		["Garderobiana", "Powiedziałam: ten z premiery, rano, na stojaku u Ireny. Myślałam, że chce mu zrobić niespodziankę. Ona go tak lubi..."],
	],
	"garderobiana_potem": [["Garderobiana", "Powiedziałam już wszystko. Proszę mnie zostawić."]],
	"garderobiana_nic": [["Garderobiana", "Nie wiem, co to ma do mnie."]],
	"garderobiana_koniec": [["Garderobiana", "Mam jeszcze trzy wieszaki."]],
	# Kuba: kłamie o czwartkowej nocy
	"kuba_start": [["Kuba", "(do tronu) \"...i niech ta noc będzie ostatnią...\" O, pan detektyw. Ja tylko powtarzam rolę."]],
	"kuba_czwartek": [["Kuba", "W czwartek wieczorem? W domu byłem. Uczyłem się roli. Całą noc."]],
	"kuba_pralnia": [
		["Antoni", "Halina z pralni mówi co innego. Pytałeś tam o kostium z teatru."],
	],
	"kuba_peka": [
		["Kuba", "No dobra! Byłem przy pralni. Wrzuciłem garnitur do skrzynki nocnej, koło jedenastej. Na rozmowę w Teatrze Nowym, rano miałem casting."],
		["Kuba", "Potem czekałem na nocny autobus, naprzeciwko. Spóźnił się. Za dwadzieścia dwunasta podszedł do skrzynki ktoś. Drobny, w kapturze."],
		["Kuba", "Wcisnął coś dużego, zawiniętego. Długo nie mógł. Potem odszedł szybko, prawie biegiem. Nie widziałem twarzy, przysięgam."],
	],
	"kuba_potem": [["Kuba", "Powiedziałem wszystko. Niech pan nie mówi Lisowi o castingu, dobra?"]],
	"kuba_rola": [["Kuba", "Dostałem rolę dublera. Wiem, jak to wygląda. Ale ja nie chciałem jej w ten sposób."]],
	"kuba_nic": [["Kuba", "Nie wiem, panie Antoni. (odwraca się do tronu) Mogę wrócić do roli?"]],
	"kuba_koniec": [["Kuba", "(wraca do tronu) \"...i niech ta noc...\""]],
	"skrzynie": [["", "Skrzynie z dekoracjami. Jedna przesunięta, na podłodze ślad w kurzu."]],
	"ghost_light": [["", "Lampa ducha. Pali się zawsze, kiedy teatr jest pusty. Żeby duchy miały przy czym grać."]],
	"wyjscie": "Do domu",
	"noc": "Poniedziałek. Do pogrzebu cztery dni.",
	"tlo": {
		"maszynista": ["(sprawdza linę) Trzyma...", "(gwiżdże cicho)"],
		"kuba": ["\"...i niech ta noc będzie ostatnią...\"", "\"...nie, jeszcze raz...\""],
		"sprzataczka": ["(szoruje) Ciągle ktoś łazi...", "(mruczy) Kurz, kurz, kurz..."],
	},
}

# Scena 12: pralnia, poniedziałek 10:00. Lampa UV leży w szafce pod ladą: da się ją
# wziąć tylko wtedy, gdy Halina jest zajęta klientem albo kurierem.
const SCENA12 := {
	"poczatek": [["", "Dzwonek nad drzwiami. W pralni kolejka. Pani Halina ma czerwone, spuchnięte dłonie i chowa je w fartuch."]],
	"halina_start": [
		["Halina", "Pan Antoni! Kostium leży na stole, pod lampą. Niech pan sam zobaczy, ja już nie mam siły na to patrzeć."],
	],
	"kuba_oddaje": [
		["Kuba", "Pani Halino, ja oddaję. W teatrze powiedzieli, że z taką plamą nie da się grać."],
		["Halina", "A mówiłam! Mokry zabrał, teraz przynosi. Leżał w ciepłym, to i wsiąkło."],
		["Kuba", "(widzi Antoniego) Dzień dobry... Ja tylko oddaję. Muszę lecieć na próbę."],
	],
	"kostium": [["", "Kostium leży rozłożony pod lampą prasowalnicy."]],
	"plama_ciemniejsza": [["", "Plama jest ciemniejsza niż wczoraj. Rozlała się wzdłuż szwów, jak atrament po bibule."]],
	"plama_bledsza": [["", "Plama zbladła po praniu, ale dalej ją widać. Idzie wzdłuż szwów na karku i ramionach."]],
	"podszewka_rekawiczki": [
		["", "Zakładam rękawiczki i odchylam podszewkę."],
		["", "Materiał jest sztywny, jakby coś w niego wsiąkło od środka, nie z wierzchu."],
	],
	"podszewka_bez": [
		["", "Odchylam podszewkę gołymi palcami."],
		["", "Po chwili zaczyna piec. Opuszki czerwienieją. Wycieram rękę w płaszcz, ale pali dalej."],
	],
	"podszewka_potem": [["", "Materiał sztywny od środka. Lepiej już go nie dotykać."]],
	"uv": [
		["", "Gaszę lampę prasowalnicy i świecę UV."],
		["", "Plama świeci na zielono. Jasno, równo, wzdłuż każdego szwu. Wino tak nie świeci. Pot też nie."],
	],
	"uv_potem": [["", "W UV plama świeci na zielono, wzdłuż szwów."]],
	"szafka_halina": [["Halina", "Panie Antoni, tam pan nie ma czego szukać. Tam moje szpargały."]],
	"szafka": [["", "Szafka pod ladą. Proszki, szczotki, kłębek sznurka. Z tyłu mała lampa z fioletową żarówką."], ["", "Biorę ją, zanim pani Halina się odwróci."]],
	"szafka_potem": [["", "Proszki i szczotki."]],
	"halina_plama": [
		["Antoni", "Plama jest ciemniejsza niż wczoraj."],
		["Halina", "Trzy razy prałam. Za każdym razem gorzej. Pierwszy raz mi się coś takiego trafia."],
	],
	"halina_rece": [
		["Antoni", "Co pani jest w ręce?"],
		["Halina", "E tam, od proszku."],
		["Halina", "(milczy chwilę)"],
		["Halina", "Od soboty mnie pieką. Od kiedy prałam ten kostium. Ale to pewnie przypadek."],
	],
	"halina_jak": [
		["Antoni", "Czym pani sprawdza plamy?"],
		["Halina", "Na oko, panie. Trzydzieści lat na oko."],
	],
	"halina_uv": [["Halina", "No... to moja lampa. Do wina. Niech pan ją weźmie, ja się już tego kostiumu boję."]],
	"halina_zdjecie": [["Halina", "Wczoraj była jaśniejsza. Słowo daję."]],
	"halina_nozyczki": [["Halina", "Nożyczki Ireny? Niech pan je schowa, bo ona panu głowę urwie."]],
	"halina_nic": [["Halina", "Panie, ja się na tym nie znam. Ja tylko piorę."]],
	"halina_koniec": [["Halina", "Następny proszę!"]],
	"halina_pani": [
		["Antoni", "Ktoś jeszcze pytał o ten kostium?"],
		["Halina", "Dziś rano ktoś dzwonił. Szeptem, nawet nie wiem, kobieta czy mężczyzna. Pytał, czy można odebrać bez kwitu."],
		["Halina", "Powiedziałam, że bez kwitu nic nie wydam. Numer zapisałam, przy książce leży, jakby co."],
	],
	"ksiazka_numer": [["", "Obok, na skrawku kwitu, ołówkiem: \"bez kwitu, szeptem, 601 314 220\"."]],
	"klient_lada": ["Garnitur na pogrzeb. Na jutro.", "Na jutro? Zrobi się, zrobi."],
	"kurier": ["Paczka dla pralni Perła!", "Już, już, idę."],
	"kot": [["", "Kot śpi na ręcznikach. Dziś nawet nie otwiera oka."]],
	"skrzynka_nocna": [["", "Skrzynka nocna. Pusta."]],
	"zegar": [["", "Zegar. Dziesiąta z minutami."]],
	"zaplecze": [["", "Za drzwiami dudni pralka. Pani Halina nie wpuszcza tam klientów."]],
	"stojaki": [["", "Zawieszki z numerami. Dziś więcej żałobnych garniturów niż wczoraj."]],
	"ksiazka": [["", "Książka przyjęć. Pod 0412 dopisane czerwonym: \"plama, NIE WYDAWAĆ\"."]],
}

const SCENA12_TLO := {
	"halina": ["(chucha w dłonie)", "Następny!", "Ojej, ojej..."],
}



# Scena 13: pralnia, wtorek 9:00 -> samochód (schowek, plan miasta) -> laboratorium.
# Nikt nie mówi, że trzeba wyciąć próbkę ani gdzie ją zawieźć.
const SCENA13 := {
	"poczatek": [["", "Wtorek. Pralnia jeszcze zamknięta, ale pani Halina otwiera mi od zaplecza."]],
	"halina_start": [
		["Halina", "Niech pan patrzy, panie Antoni. Rozprułam podszewkę, żeby zobaczyć od środka."],
		["Halina", "To nie jest brud. To coś żre ten materiał. I mnie też, niech pan spojrzy na ręce."],
	],
	"kostium": [["", "Podszewka rozpruta i rozłożona pod lampą. Materiał przeżarty od środka, cienki jak bibuła."]],
	"wytnij_bez_woreczka": [["", "Mogę wyciąć kawałek, ale w co go włożę? W kieszeń tego nie schowam."]],
	"wytnij_rekawiczki": [["", "W rękawiczkach odcinam nożyczkami kawałek podszewki z plamą i zamykam go w woreczku."]],
	"wytnij_bez": [
		["", "Odcinam kawałek podszewki. Palce znowu pieką."],
		["", "Zamykam próbkę w woreczku i długo wycieram ręce."],
	],
	"wytnij_potem": [["", "Próbka jest w woreczku. Reszty lepiej nie ruszać."]],
	"uv": [["", "W UV cała podszewka świeci na zielono. Najmocniej na karku i pod pachami."]],
	"halina_rece": [
		["Antoni", "Pokaże mi pani dłonie?"],
		["Halina", "(wyciąga je, czerwone i popękane)"],
		["Halina", "Lekarz mówi, że alergia. Trzydzieści lat piorę i nagle alergia."],
	],
	"halina_wyciac": [
		["Antoni", "Mogę wyciąć kawałek?"],
		["Halina", "Niech pan tnie. I tak już tego nikt nie założy."],
	],
	"halina_nozyczki": [
		["Antoni", "Pożyczy mi pani nożyczki?"],
		["Halina", "Moje są u szlifierza, odbieram jutro rano. Niech pan przyjdzie jutro, to pan dostanie."],
	],
	"wybor_jutro": ["Przyjdę jutro", "Poradzę sobie inaczej"],
	"jutro": [["", "Cały dzień w plecy. Następnego ranka pani Halina wręcza mi naostrzone nożyczki."]],
	"halina_gdzie": [
		["Antoni", "Wie pani, kto to może zbadać?"],
		["Halina", "Ja? Panie, ja piorę. Od tego są mądrzejsi."],
	],
	"halina_nic": [["Halina", "Ja nic nie wiem, ja tylko piorę."]],
	"halina_koniec": [["Halina", "Niech pan uważa na siebie."]],
	"kot": [["", "Kot nie śpi na ręcznikach. Siedzi przy drzwiach na zaplecze i patrzy na kostium."]],
	"zegar": [["", "Dziewiąta dwadzieścia."]],
}

## Samochód Antoniego: schowek z woreczkiem i plan miasta (bez zaznaczonego celu).
const SAMOCHOD := {
	"tytul": "Samochód",
	"menu": ["Schowek", "Jedź", "Wysiądź"],
	"schowek": [["", "Schowek. Mapa, skrobaczka do szyb, paczka strunowych woreczków na dowody z komendy. Biorę jeden."]],
	"schowek_potem": [["", "Mapa, skrobaczka, woreczki."]],
	"dokad": "Dokąd jechać?",
	"miejsca": ["Teatr", "Komenda", "Laboratorium", "Szpital", "Dom", "Pralnia", "Zostań"],
	"teatr": [["", "Pod teatrem ludzie z kwiatami i zniczami. Nic tu po mnie z tym."]],
	"komenda": [["", "Komisarza Nowickiego nie ma. Dyżurny wzrusza ramionami."], ["Policjant", "Próbki? To nie do nas, panie. My tu nic nie badamy."]],
	"szpital": [["", "Na izbie przyjęć kolejka. Pielęgniarka odsyła mnie z kwitkiem."]],
	"dom": [["", "W domu zupa od Oli w garnku i karteczka: \"Zjedz coś wreszcie!\""], ["", "Jem. Z szuflady biorę jeszcze zaskórniaki na taksówki."]],
	"dom_potem": [["", "W domu cicho. Zupy już nie ma."]],
	"pralnia": [["", "Wracam pod pralnię."]],
}

const LAB := {
	"plansza": "Laboratorium kryminalistyczne",
	"poczatek": [["", "Szum wentylatorów. Przy mikroskopie siedzi laborant i je zupę z termosu."]],
	"start": [
		["Laborant", "Godziny przyjęć od dziesiątej. Ale skoro pan już jest... Pan z komendy?"],
		["Antoni", "Pracuję z komisarzem Nowickim."],
		["Laborant", "Aha. No to co pan ma?"],
	],
	"zupa": [
		["Antoni", "Smaczna?"],
		["Laborant", "Pomidorowa od żony. Pan nie dostanie, nie ma szans."],
	],
	"jak_dlugo": [
		["Antoni", "Ile trwa badanie?"],
		["Laborant", "Jak pan coś przyniesie, to do wieczora. Zadzwonię."],
	],
	"przez_skore": [
		["Antoni", "Czy trucizna może przejść przez skórę?"],
		["Laborant", "Niektóre tak. Paskudztwa. Wsiąka powoli, człowiek nic nie czuje, a po dobie, dwóch już po nim."],
	],
	"probka": [
		["Laborant", "(odkłada łyżkę, ogląda woreczek pod światło)"],
		["Laborant", "O. To mi się nie podoba. Zostawi pan, wieczorem zadzwonię."],
	],
	"probka_bez_woreczka": [["Laborant", "Gołe szmaty nie przyjmuję. Woreczek z komendy, opisany, inaczej nic."]],
	"zdjecie": [["Laborant", "Zdjęcie to nie próbka. Ja muszę mieć materiał."]],
	"uv": [["Laborant", "Świeci na zielono w UV? Ciekawe... Niektóre związki tak mają. Ale bez próbki to wróżenie z fusów."]],
	"kostium": [["Laborant", "Cały kostium? Panie, ja tu nie mam pralni. Kawałek materiału w woreczku wystarczy."]],
	"termos": [["Laborant", "Ładny termos. Mój lepszy."]],
	"nic": [["Laborant", "Z tym to nie do mnie."]],
	"koniec": [["Laborant", "Do widzenia."]],
	"bez_probki": [["Laborant", "Bez próbki nic panu nie powiem."]],
	"po_oddaniu": [["Laborant", "(nie podnosi głowy znad mikroskopu)"]],
	"mikroskop": [["", "Pod szkiełkiem jakieś włókno. Nie moja sprawa."]],
	"regal": [["", "Słoiki z etykietami: numery spraw, daty. Na jednym: \"NIE OTWIERAĆ\"."]],
	"lodowka": [["", "Kartka na drzwiach: \"Próbki! Nie ruszać!\". W środku próbki i jogurt."]],
	"zlew": [["", "Zlew i mydło."]],
	"zlew_pali": [["", "Myję ręce długo, zimną wodą. Pieczenie wreszcie słabnie."]],
	"dygestorium": [["", "Szklana szafa z wyciągiem. W środku kolby i coś, co bulgocze."]],
	"plakat": [["", "\"Pracując z odczynnikami, zawsze zakładaj rękawiczki.\""]],
	"tablica": [["", "Grafik dyżurów i pocztówka z Zakopanego."]],
	"fartuchy": [["", "Białe fartuchy na wieszaku."]],
	"okno": [["", "Szare podwórko. Na parapecie zdechła mucha."]],
	"wieczor": "Wtorek, 19:20",
	"telefon": [
		["", "Telefon. Numer laboratorium."],
		["Laborant", "Panie Antoni? Mam wynik. Trucizna kontaktowa. Przechodzi przez skórę i zabija po dobie, dwóch."],
		["Laborant", "Kto to nosił, ten nie miał szans. I nikt by tego nie szukał."],
	],
	"telefon_slabszy": [["Laborant", "Stężenie małe, materiał był prany. Ale jest. Nie mam wątpliwości."]],
	"nowicki": [
		["", "Dzwonię do Nowickiego."],
		["Nowicki", "Trucizna w kostiumie? Antoni..."],
		["Nowicki", "Dobra. Masz czas do pogrzebu. Potem to idzie wyżej i już nic nie zrobimy po cichu."],
	],
}

# Retrospekcja 2 (po scenie 13): czwartkowa próba generalna. Pokazuje tylko to,
# co gracz ustalił. Kogo nie zna, ten jest czarną sylwetką.
const RETRO2 := {
	"tytul": "Czwartek, próba generalna. Tak mogło być.",
	"adrian_kostium": "Leży jak ulał...",
	"piecze": "Piecze mnie ta podszewka.",
	"irena": "Nie marudź! Adam nosi to od miesiąca i żyje.",
	"dlon": "(ktoś kładzie mu dłoń na ramieniu)",
	"blady": "(blady, poci się)",
	"sms": "22:10. \"Ten kostium mnie parzy...\"",
	"skrzynka": "23:40. Ktoś wrzuca kostium do skrzynki nocnej pralni. Podpis: A.",
	"koniec": "Do pogrzebu zostały trzy dni.",
	"rozdzial": "Koniec rozdziału 3.",
}

# ---------- REJESTR ŚLEDZTWA (ui/sledztwo.gd) ----------

## Dowody, które prowadzą donikąd: pokazanie ich komukolwiek zabiera dodatkowy czas.
# Scena 14 (rozdział 4): garderoba Wolskiego, wtorek 19:40, przed drugim spektaklem.
# Wolski nie rozmawia, dopóki nie ma peruki (leży pod szalem na kanapie). O tym, że to on
# miał zginąć, uwierzy dopiero na widok dowodu. Pani Stasia przynosi bukiet i wygaduje
# się o aptece w czwartek. Przy wyjściu Antoni widzi przez szparę, jak Wolski coś pali.
const SCENA14 := {
	"poczatek": [
		["", "Garderoba gwiazdy. Lustro w żarówkach, bukiety od wielbicieli, zapach pudru i koniaku."],
		["Głośnik", "Dwadzieścia minut do spektaklu. Dwadzieścia minut."],
	],
	"wolski_bez_peruki": [
		["Wolski", "Detektyw! Akurat. Niech pan mi lepiej powie, gdzie jest moja peruka."],
		["Wolski", "Bez peruki nie wyjdę na scenę, a bez sceny nie mam głowy do rozmów. Proszę wybaczyć."],
	],
	"wolski_bez_peruki_znowu": [["Wolski", "Peruka, panie detektywie. Najpierw peruka."]],
	"garderobiana_szuka": [
		["Garderobiana", "Wszędzie szukałam! W szafie, za parawanem, w pudłach. Jak kamień w wodę."],
		["Garderobiana", "Pan Adam ją zdjął wczoraj po spektaklu, rzucił gdzieś i poszedł. Jak zawsze."],
	],
	"garderobiana_szuka_znowu": [["Garderobiana", "Jak nie znajdę, to mnie zwolni. Znowu."]],
	"kanapa": [
		["", "Na kanapie rzucony jedwabny szal. Coś pod nim jest. Coś miękkiego i siwego."],
		["", "Peruka. Siwe loki, trochę zmierzwione. Ktoś na niej siedział."],
	],
	"kanapa_potem": [["", "Kanapa. Pachnie koniakiem i wodą kolońską."]],
	"peruka_oddana": [
		["Garderobiana", "Pod szalem! Mój Boże, pod szalem. Dziękuję panu, dziękuję."],
		["Garderobiana", "(ciszej, czesząc perukę) On w ogóle ostatnio jakiś nieswój. W czwartek o siódmej rano dzwoni do dyrektora, że chory. My się dowiedzieliśmy dopiero o dziewiątej, na próbie."],
		["Garderobiana", "A w środę wieczorem zdrów jak ryba, koniak pił i śpiewał. Ja tam nic nie mówię."],
	],
	"garderobiana_potem": [["Garderobiana", "(układa loki na główce, nuci pod nosem)"]],
	"garderobiana_czwartek": [
		["Antoni", "Pan Wolski był w czwartek chory?"],
		["Garderobiana", "Tak powiedział. Przez telefon kaszlał, aż słuchawka skakała. Teatralnie, jak to on."],
	],
	"garderobiana_adrian": [
		["Antoni", "Adrian tu przychodził?"],
		["Garderobiana", "Codziennie. Pan Adam mu pozwalał tu się przebierać, kiedy grał za niego. Dobre serce, mówili."],
		["Garderobiana", "Ja tam wiem swoje. Pan Adam nikomu nic za darmo nie daje."],
	],
	"garderobiana_nic": [["Garderobiana", "Ja się znam na perukach, proszę pana. Na papierach nie."]],
	"wolski_start": [
		["Wolski", "Moja peruka! Detektywie, jest pan skarbem. Siadaj pan, mów pan, mam piętnaście minut."],
	],
	"wolski_znowu": [["Wolski", "(maluje brwi) Słucham, słucham."]],
	"wolski_adrian": [
		["Antoni", "Jak się pan trzyma po śmierci Adriana?"],
		["Wolski", "Jak aktor. Gram dalej, bo co mam robić? Spektakl to spektakl."],
		["Wolski", "Chłopak był zdolny. Za miękki na ten zawód, ale zdolny."],
		["Wolski", "(odwraca się do lustra) Nie rozmawiajmy o umarłych przed spektaklem, to przynosi pecha. Jak mi w tej peruce?"],
	],
	"wolski_czwartek": [
		["Antoni", "Gdzie pan był w czwartek rano?"],
		["Wolski", "W łóżku. Grypa, gorączka, dreszcze. Dlatego Adrian grał za mnie próbę generalną."],
		["Wolski", "Po co pan pyta? Przecież to był zawał."],
		["Wolski", "(szybko) A propos, widział pan nasz plakat? Hamlet, dziewięćdziesiąty ósmy. Ech, to były czasy."],
	],
	"wolski_kostium": [
		["Antoni", "Pański kostium trafił do pralni z plamą na podszewce."],
		["Wolski", "Kostiumy się brudzą, panie detektywie. Od tego jest Irena i pralnia."],
	],
	"wolski_zginac": [
		["Antoni", "Myślę, że to pan miał zginąć."],
		["Wolski", "(odkłada pędzel, patrzy na mnie w lustrze, potem wybucha śmiechem)"],
		["Wolski", "Panie detektywie, ja gram w kryminałach, nie żyję w nich. Ma pan na to coś więcej niż przeczucie?"],
	],
	"wolski_zginac_znowu": [["Wolski", "Przeczucia zostawmy krytykom. Fakty, panie detektywie."]],
	"dowod_trucizny": [
		["Wolski", "(patrzy długo, pędzel drży mu w ręce)"],
		["Antoni", "Trucizna była w podszewce pańskiego kostiumu. W czwartek miał go założyć pan. Adrian włożył go za pana."],
		["Wolski", "(blednie pod pudrem, a potem się śmieje, za głośno)"],
		["Wolski", "Krytycy jeszcze nigdy tak się nie starali, żeby mnie zabić."],
		["Wolski", "(nalewa sobie koniaku, wypija jednym haustem)"],
		["Wolski", "Biedny Adrian. Zginął za mnie, rozumie pan? Znajdź tego, kto to zrobił. Dam panu wszystko, czego potrzeba."],
	],
	"wolski_kto": [
		["Antoni", "Kto mógłby chcieć pana śmierci?"],
		["Wolski", "Irena mnie nienawidzi od lat, a Bogdan... Bogdan liczy pieniądze. Niech pan sam oceni."],
		["Wolski", "I proszę nikomu nie mówić, że byłem tu taki blady. Mam reputację."],
	],
	"wolski_ubezpieczenie": [
		["Antoni", "Co Bogdan Lis ma do pieniędzy?"],
		["Wolski", "Teatr ledwo zipie, a ja jestem jedynym nazwiskiem, które sprzedaje bilety. Żywy albo martwy."],
		["Wolski", "Proszę zapytać, na ile mnie ubezpieczył. Ja tylko mówię."],
	],
	"wolski_telefon": [
		["Wolski", "(sięga po telefon za szybko, potem cofa rękę)"],
		["Wolski", "Chłopak wszędzie go zostawiał. Proszę go oddać rodzinie, oczywiście."],
	],
	"wolski_kwit": [["Wolski", "Pralnia, pralnia. Ja się nie zajmuję praniem, mam od tego ludzi."]],
	"wolski_noz": [["Wolski", "Rekwizyt z finału. Proszę oddać Marcie, zanim dostanie zawału. Pardon."]],
	"wolski_nic": [["Wolski", "Nie wiem, co to jest, i nie mam czasu się dowiadywać."], ["Wolski", "(nuci coś pod nosem i maluje brwi, jakby mnie nie było)"]],
	"wolski_dowod_bez": [["Wolski", "Obrzydliwe. Po co mi pan to pokazuje przed spektaklem? Co to ma wspólnego ze mną?"]],
	"wolski_dowod_potem": [["Wolski", "Proszę to schować. Już raz to widziałem, wystarczy."]],
	"wolski_peruka": [
		["Wolski", "Moja peruka! Pod szalem? Ja ją tam rzuciłem? Niemożliwe."],
		["Wolski", "Halinko, czesać, szybko! Detektywie, jest pan skarbem."],
	],
	"wolski_koniec": [["Wolski", "Do roboty, detektywie. I proszę zamknąć drzwi, przeciąga."]],
	"glosnik": [
		"Kwadrans do spektaklu. Kwadrans.",
		"Dziesięć minut. Pan Wolski proszony do charakteryzacji.",
		"Pięć minut. Proszę o ciszę za kulisami.",
	],
	"za_sciana": "(za ścianą wybuch śmiechu aktorów)",
	"stasia_puka": [
		["", "Pukanie. W drzwiach starsza pani z ogromnym bukietem różaneczników."],
		["Stasia", "Panie Adamie, to od nas, od klubu wielbicieli! Ja tylko na sekundkę, nie przeszkadzam!"],
	],
	"stasia_wolski": [["Wolski", "Pani Stasiu, aniele. Proszę postawić na stoliku, przy reszcie."]],
	"stasia_start": [["Stasia", "Pan detektyw! Ten od soboty. Ja pana pamiętam z foyer."]],
	"stasia_bukiet": [
		["Antoni", "Często pani przynosi kwiaty?"],
		["Stasia", "Na każdy spektakl. Pan Adam tak pięknie dziękuje. Trzydzieści lat go oglądam."],
	],
	"stasia_czwartek": [
		["Antoni", "Kiedy ostatnio widziała pani pana Wolskiego poza teatrem?"],
		["Stasia", "W czwartek! Przed dziesiątą, pod apteką na Kościuszki. Taki elegancki, w kapeluszu."],
		["Stasia", "Pomachałam, ale nie zauważył. Spieszył się z jakąś torebeczką."],
	],
	"wolski_przerywa": "Pani Stasiu, pomyliła pani. Leżałem z gorączką.",
	"stasia_potem": [["Stasia", "(poprawia kwiaty w wazonie, żeby róże były z przodu)"]],
	"stasia_nic": [["Stasia", "Ja się nie znam, panie detektywie. Ja tylko kwiaty."]],
	"stasia_koniec": [["Stasia", "Połamania nóg, panie Adamie!"]],
	"stasia_wychodzi": "Już mnie nie ma! Połamania nóg!",
	"plakat_hamlet": [["", "Plakat: \"HAMLET 1998\". Młody Wolski z czaszką w dłoni. Pierwsza wielka rola."]],
	"plakat_hamlet_program": [
		["", "Plakat: \"HAMLET 1998\". Młody Wolski z czaszką w dłoni."],
		["", "W programie premiery to samo: debiut w 1998, jako Hamlet. Ten rok musi być dla niego ważny."],
	],
	"plakat_romeo": [["", "\"ROMEO 1994\". Szkoła teatralna. Wolski jako Romeo, chudy jak patyk."]],
	"plakat_akt": [["", "\"Ostatni akt\". Ten sam plakat co w foyer, tylko z autografem: \"Dla siebie samego, A.W.\""], ["", "Pismo zamaszyste, pochylone w prawo. A ostre jak namiot, bez żadnej pętelki."]],
	"sejf": [["", "Mały stalowy sejf przy szafie. Pokrętło z czterema cyframi. Przy Wolskim nawet nie dotykam."]],
	"szafa": [["", "Garnitury, szlafrok z monogramem, trzy pary lakierków. Peruki tu nie ma."]],
	"parawan": [["", "Za parawanem lustro i stołek. Na podłodze rozsypany puder. Peruki nie ma."]],
	"stojak": [["", "Kostiumy z dawnych spektakli, każdy w folii. Na kartkach: \"Hamlet\", \"Król\", \"Ryszard\". Gęsto wiszą."]],
	"stojak_potem": [["", "Kostiumy wiszą tak gęsto, że za stojakiem schowałby się dorosły człowiek."]],
	"bukiety": [["", "Bukiety z bilecikami: \"Dla mistrza\", \"Od wiernych widzów\", \"Adamowi, Stasia i klub\"."]],
	"kosz": [["", "Kosz na śmieci. Pusty, ktoś go dziś wyniósł."]],
	"toaletka": [["", "Szminki, pudry, kredki. Koniak do połowy. Za ramą lustra wycinek z recenzją: \"Wolski w formie życia\"."]],
	"fotel": [["", "Fotel dla gości. Siedzisko jeszcze ciepłe."]],
	"wyjscie_szpara": [
		["", "Zamykam za sobą drzwi. Zostaje szpara."],
		["", "Wolski zdejmuje coś z dna szuflady. Kartki. Zapalniczką podpala je nad koszem."],
	],
	"szpara_wybor": ["Wejdź", "Odejdź"],
	"wchodzi": [
		["Antoni", "Pali pan coś?"],
		["Wolski", "(drgnął, potem uśmiech) Stare recenzje. Przesąd. Przed spektaklem palę te najgorsze."],
		["Wolski", "Proszę mi nie zabierać tradycji, detektywie. Dobranoc."],
		["", "W koszu dogasa papier. Zdążyłem zobaczyć rubryki, kolumny cyfr i słowo \"przelew\". To nie są recenzje."],
	],
	"odchodzi": [["", "Odchodzę korytarzem. Za plecami czuć dym. Cokolwiek palił, już tego nie ma."]],
	"wyjscie_bez": [["", "Zostawiam Wolskiego z jego peruką. Przez głośnik: \"Pięć minut\"."]],
}

const SCENA14_TLO := {
	"wolski": ["(nuci arię)", "Mi-mi-mi-mi...", "Gdzie ta przeklęta kredka?"],
	"garderobiana": ["Gdzie ona może być...", "Pod łóżkiem? Nie ma tu łóżka...", "(przekłada pudła)"],
}

# Scena 15: pracownia kostiumów, środa 9:00. Irena wroga. Gdy dzwoni telefon na
# korytarzu, wychodzi i zostawia klucze przy maszynie: szafa z belami bez spisu.
# Przyznaje się do kradzieży dopiero przy belach i spisie tkanin naraz.
const SCENA15 := {
	"poczatek": [
		["", "Środa, dziewiąta. Maszyna do szycia stoi. Irena siedzi przy niej i zwija taśmę krawiecką."],
		["", "Z korytarza dochodzi próba muzyczna. Ktoś fałszuje to samo miejsce piąty raz."],
	],
	"irena_start": [
		["Irena", "Znowu pan. Nie mam o czym z panem rozmawiać."],
		["Irena", "Wszystko powiedziałam w niedzielę. Do widzenia."],
	],
	"irena_start_wolski": [
		["Irena", "Znowu pan. Słyszałam, że był pan wczoraj u Adama. Że Adam panu o mnie naopowiadał."],
		["Irena", "Nie mam o czym z panem rozmawiać."],
	],
	"irena_znowu": [["Irena", "(zwija taśmę, nie patrzy)"]],
	"irena_papieros": [
		["Antoni", "Zapali pani?"],
		["Irena", "(patrzy na paczkę, potem na mnie) Zenon panu powiedział, co?"],
		["Irena", "(zapala, zaciąga się długo) Dobra. Jedno. Ale przy oknie."],
		["Irena", "Pan pyta, ja odpowiadam. Krótko."],
	],
	"irena_nienawidzi": [
		["Antoni", "Wolski mówi, że pani go nienawidzi."],
		["Irena", "Bo nienawidzę. Dwadzieścia lat szyję mu kostiumy i ani razu nie powiedział dziękuję."],
		["Irena", "Ale nienawidzić a zabić to dwie różne rzeczy, panie władzo."],
	],
	"irena_nienawidzi_zla": [
		["Antoni", "Wolski mówi, że pani go nienawidzi."],
		["Irena", "Wolski mówi dużo. Niech pan idzie z nim pogadać, ma więcej czasu."],
	],
	"irena_czwartek": [
		["Antoni", "Gdzie pani była w czwartek rano?"],
		["Irena", "Tutaj. Gdzie mam być? Szyłam."],
	],
	"irena_czwartek_zla": [
		["Antoni", "Gdzie pani była w czwartek rano?"],
		["Irena", "A co to pana obchodzi? Niech pan przyjdzie z nakazem."],
	],
	"irena_wolna": [
		["Antoni", "Maszyna stoi. Nie szyje pani dzisiaj?"],
		["Irena", "Nie szyję za darmo. Teatr nie płaci mi od pół roku. Niech sobie Bogdan sam szyje."],
	],
	"irena_bele_bez": [
		["Antoni", "W szafie leżą bele jedwabiu i brokatu."],
		["Irena", "(taśma zatrzymuje się w jej rękach)"],
		["Irena", "Dary. Od sponsorów. Ma pan jakiś papier, że nie? Nie ma pan. To proszę nie grzebać w moich szafach."],
	],
	"irena_bele_przyznanie": [
		["Antoni", "W szafie leżą bele jedwabiu i brokatu. W spisie tkanin ich nie ma."],
		["Irena", "(długo milczy, taśma rozwija się na podłogę)"],
		["Irena", "Pół roku bez pensji. Pół roku. Bogdan obiecuje, Adam pije koniak za trzysta złotych, a ja mam z czego żyć?"],
		["Irena", "Tak, kradnę szmaty. Kupuję w hurtowni na teatr, część oddaję na lewo. Ale truciciel?"],
		["Irena", "Ja bym Adama zabiła nożyczkami, w twarz, nie po cichu."],
	],
	"irena_hurtownia": [
		["Antoni", "Gdzie pani była w czwartek rano?"],
		["Irena", "W hurtowni. Na Fabrycznej, od siódmej. Wróciłam przed dziewiątą, na próbę."],
		["Irena", "Paragon? A kto paragony trzyma. Gdzieś tu leży, w ścinkach. Niech pan szuka, jak pan taki dokładny."],
	],
	"irena_klucz": [
		["Antoni", "Kto jeszcze ma klucz do pracowni?"],
		["Irena", "Klucz do pracowni mają tylko trzy osoby: ja, Marta i główna obsada. Czyli też Ania."],
		["Irena", "No i ten student, Kuba, co go Adrian pożyczał. Mówiłam panu."],
	],
	"irena_klucz_zla": [
		["Antoni", "Kto jeszcze ma klucz do pracowni?"],
		["Irena", "Mówiłam w niedzielę. Pół teatru."],
	],
	"irena_paragon": [
		["Irena", "No i proszę. Hurtownia \"Atlas\", siódma piętnaście. Mówiłam."],
		["Irena", "A teraz niech pan idzie donieść Bogdanowi. Mnie już wszystko jedno."],
	],
	"irena_podszewka": [["Irena", "Nie chcę już o tym mówić. Nie chcę."]],
	"irena_nic": [["Irena", "Nie wiem. Nie znam się. Proszę wyjść."]],
	"irena_koniec": [["Irena", "(wraca do zwijania taśmy)"]],
	"irena_koniec_papieros": [["Irena", "(gasi papierosa w doniczce) Koniec przerwy."]],
	"telefon_dzwoni": "(na korytarzu dzwoni telefon)",
	"irena_idzie": "Cholera, znowu ten telefon...",
	"irena_wraca": "(wraca z korytarza) Pomyłka. Trzeci raz.",
	"klucze": [["", "Pęk kluczy przy maszynie. Jeden mały, mosiężny, z nitką na kółku. Biorę cały pęk."]],
	"klucze_przy_irenie": [["", "Pęk kluczy przy maszynie. Irena siedzi pół metra dalej. Nie teraz."]],
	"klucze_odkladam": [["", "Kroki na korytarzu. Odkładam klucze przy maszynie, zanim Irena wejdzie."]],
	"szafa_zamknieta": [["", "Szafa zamknięta na klucz. Mały zamek, mosiężny."]],
	"szafa_otwieram": [
		["", "Mały klucz pasuje. Szafa otwiera się ze skrzypnięciem."],
		["", "Bele jedwabiu, brokatu, aksamitu w kolorze wina. Z metkami hurtowni \"Atlas\". Na każdej metce cena, której teatr nigdy by nie zapłacił."],
		["", "Na dnie szafy brązowa butelka. Ręczny napis: \"UTRWALACZ. ŻRĄCE. NIE DOTYKAĆ SKÓRĄ\"."],
		["", "Zamykam szafę i odkładam klucze. Lepiej, żeby nie wiedziała."],
	],
	"szafa_potem": [["", "Szafa z belami. Jedwab, brokat, metki \"Atlas\". Na dnie butelka z utrwalaczem."]],
	"utrwalacz_zapach": [["", "Odkręcam butelkę na moment. Ostry ocet, aż łzawią oczy. Nic słodkiego, nic zgniłego."]],
	"irena_utrwalacz": [
		["Antoni", "W pani szafie stoi butelka. \"Żrące, nie dotykać skórą\"."],
		["Irena", "(blednie, potem czerwienieje) Grzebał pan w mojej szafie?!"],
		["Irena", "To nie pana sprawa, co tam trzymam. Proszę stąd wyjść, zanim zawołam Bogdana."],
	],
	"irena_utrwalacz_prawda": [
		["Antoni", "A butelka z utrwalaczem?"],
		["Irena", "(wzdycha) Farbuję ten jedwab, zanim pójdzie na lewo. Żeby nikt go nie poznał na cudzej scenie."],
		["Irena", "Śmierdzi octem na całe piętro. Adrian zawsze otwierał okno i żartował, że marynuję śledzie."],
	],
	"regal": [
		["", "Na regale segregator: \"Spis tkanin pracowni\". Podpisany przez Lisa."],
		["", "Aksamit, len, atłas, bawełna, filc. Jedwabiu i brokatu nie ma w ogóle."],
	],
	"regal_potem": [["", "Spis tkanin: jedwabiu i brokatu nie ma."]],
	"skrzynka_bez": [["", "Skrzynka z materiałami pod stołem. Ścinki, szpulki, zwinięte metki. Szukam w tym jak w stogu siana."], ["", "Nic. Gdybym wiedział, czego szukać..."]],
	"skrzynka_paragon": [
		["", "Grzebię w skrzynce pod stołem. Ścinki, szpulki, metki."],
		["", "Na samym dnie zmięty paragon. Hurtownia \"Atlas\", Fabryczna 4. Czwartek, 7:15. Jedwab, brokat."],
	],
	"skrzynka_potem": [["", "Same ścinki i szpulki."]],
	"maszyna": [["", "Maszyna do szycia. Igła stoi w połowie ściegu. Irena dziś nic nie szyje."]],
	"okno": [["", "Podwórze. Zenon zamiata liście przy bramie."]],
	"radio": [["", "Radio wyłączone. Z korytarza słychać fortepian."]],
	"bele_podloga": [["", "Bele na podłodze: len, bawełna, filc. Tanie, wszystkie są w spisie."]],
	"irena_nie_ma": [["", "Taboret Ireny pusty. Na korytarzu słychać jej głos: \"Halo? Halo!\""]],
}

const SCENA15_TLO := {
	"irena": ["(zwija taśmę)", "Pół roku...", "(cmoka z irytacją)"],
	"proba": ["Ta-ra-ram... nie, jeszcze raz!", "(fortepian zaczyna od nowa)", "Od taktu dwunastego!"],
}

# Scena 16 (opcjonalna): gabinet Lisa, środa 13:00. Lis jest na dole u księgowej.
# Szuflada otwiera się zapasowym kluczem albo kluczykiem zza kalendarza: polisa na Wolskiego.
# Po polisie wraca Lis. Potwierdzenie z banku leży w teczkach, ale Antoni wie, czego
# szukać, dopiero gdy Lis powie o banku.
const SCENA16 := {
	"poczatek": [
		["", "Sekretariat pusty, drzwi gabinetu uchylone. Lis jest piętro niżej, u księgowej. Sekretarka mówi, że to potrwa."],
		["", "Za ścianą sekretarka odbiera telefon za telefonem."],
	],
	"papiery": [
		["", "Stos kopert. Wezwania do zapłaty: prąd, ogrzewanie, ZUS, drukarnia."],
		["", "Na jednym czerwona pieczątka: \"WEZWANIE OSTATECZNE\". Teatr tonie."],
	],
	"papiery_potem": [["", "Rachunki. Same rachunki."]],
	"teczki": [["", "Teczki: budżet, umowy, sponsorzy, bank, ZAiKS. Mógłbym tu siedzieć do jutra, gdybym nie wiedział, czego szukam."]],
	"teczki_bank": [
		["", "Zielona teczka \"BANK\". Na wierzchu potwierdzenie wizyty: oddział na Placu Wolności, czwartek, 8:05. Klient: Bogdan Lis. Wniosek o kredyt."],
		["", "Odrzucony."],
	],
	"teczki_bank_potem": [["", "Potwierdzenie z banku: czwartek 8:05. Wniosek odrzucony."]],
	"szuflada_zamknieta": [["", "Szuflada biurka zamknięta na mały kluczyk. Szarpnięcie nic nie daje."]],
	"szuflada_klucz": [["", "Zapasowy klucz z bezpieczników jest za duży. Ale dziurka... Nie, nie pasuje."]],
	"szuflada_otwieram": [["", "Kluczyk pasuje. Szuflada wyjeżdża ze zgrzytem."]],
	"polisa": [
		["", "Pod paczką papierosów i fiolką tabletek na nadciśnienie: polisa na życie."],
		["", "Ubezpieczony: Adam Wolski. Uposażony: Teatr Miejski. Suma: dwa miliony złotych."],
		["", "Podpisana trzy miesiące temu. B. Lis. Biorę ją."],
	],
	"szuflada_potem": [["", "Papierosy i tabletki na nadciśnienie."]],
	"kalendarz": [
		["", "Kalendarz ścienny. Środa: \"13:00 księgowa\", podkreślone trzy razy."],
		["", "Kalendarz odstaje od ściany. Za nim, na gwoździku, wisi mały kluczyk. Biorę go."],
	],
	"kalendarz_potem": [["", "Kalendarz. Za nim pusty gwoździk."]],
	"telefon_dzwoni": "(telefon na biurku Lisa dzwoni)",
	"telefon_odbieram": [
		["", "Podnoszę słuchawkę. Nic nie mówię."],
		["Głos", "Panie dyrektorze, nie ma co się chować. Do piątku albo idziemy do komornika."],
		["Głos", "Mówił pan, że będą pieniądze. Z ubezpieczenia, tak pan mówił. No to gdzie są?"],
		["", "Rozłącza się, zanim zdążę odpowiedzieć."],
	],
	"telefon_cicho": [["", "Stary telefon z tarczą. Milczy."]],
	"okno": [["", "Pod teatrem znicze. Ktoś przykleił do drzwi zdjęcie Adriana."]],
	"tablica": [["", "Obsada \"Ostatniego aktu\". Nazwisko Adriana przekreślone, nad nim długopisem: \"J. Adamczyk\"."]],
	"regal": [["", "Segregatory od 1990 roku. Nagrody, dyplomy. Na najwyższej półce kurz gruby na palec."]],
	"kroki": [["", "Kroki na korytarzu. Ciężkie, szybkie. Zamykam szufladę, ale za późno."]],
	"lis_wchodzi": [
		["Lis", "A pan co tu robi? W moim biurku?!"],
		["Lis", "To jest napad, panie. Zadzwonię na policję. Chociaż... pan jest z policji. No to cudownie."],
	],
	"lis_znowu": [["Lis", "(ociera czoło chustką) Słucham. Skoro już pan tu jest."]],
	"lis_bankrut": [
		["Antoni", "Teatr bankrutuje?"],
		["Lis", "Teatr umiera, panie. Od dwóch lat. Ja tylko trzymam go za rękę."],
	],
	"lis_polisa": [
		["Antoni", "Polisa na życie Wolskiego. Dwa miliony. Uposażony: teatr."],
		["Lis", "(siada ciężko w fotelu, długo milczy)"],
		["Lis", "Gdyby Adam umarł, pieniądze z polisy uratowałyby teatr. Myśli pan, że o tym nie myślałem? Myślałem."],
		["Lis", "Ale tego nie zrobiłem."],
	],
	"lis_czwartek_zly": [
		["Antoni", "Gdzie był pan w czwartek rano?"],
		["Lis", "W pracy. Jak zawsze. A teraz, jeśli pan pozwoli, mam teatr do ratowania."],
	],
	"lis_czwartek": [
		["Antoni", "Gdzie był pan w czwartek rano?"],
		["Lis", "W banku. O ósmej, zanim otworzyli, już stałem pod drzwiami. Błagałem o kredyt."],
		["Lis", "Odmówili. Potwierdzenie mam w teczkach, w tej zielonej. Niech pan sobie szuka, skoro i tak pan grzebie."],
	],
	"lis_wolski": [
		["Antoni", "Wolski mówi, że pan liczy pieniądze."],
		["Lis", "Adam? Adam niech liczy swoje butelki koniaku. Kto mu je kupuje, jak myśli? Teatr."],
	],
	"lis_wierzyciel": [
		["Antoni", "Dzwonił ktoś. Mówił o pieniądzach z ubezpieczenia."],
		["Lis", "(blednie) Mówię wierzycielom różne rzeczy, żeby dali mi jeszcze tydzień. To nie przestępstwo."],
	],
	"lis_kuba": [
		["Antoni", "Kuba Adamczyk dostał rolę dublera."],
		["Lis", "A kogo miałem wziąć? Zadzwoniłem do niego w sobotę rano. Chłopak zna rolę na pamięć."],
	],
	"lis_nic": [["Lis", "Nie wiem, co to jest. Ja się zajmuję pieniędzmi, których nie ma."]],
	"lis_koniec": [["Lis", "A teraz wynocha z mojego gabinetu. I kluczyk na biurko."]],
	"wyjscie_przed": [["", "Wychodzę, zanim Lis wróci. Sekretarka nawet nie podnosi głowy."]],
}

const SCENA16_TLO := {
	"sekretarka": ["Pana dyrektora nie ma.", "Przelew wyszedł, naprawdę.", "Proszę zadzwonić jutro.", "(telefon dzwoni)", "Nie, nie wiem, kiedy wróci."],
	"lis": ["Dwa miliony...", "(sapie)", "Księgowa mnie wykończy."],
}

# Scena 17: mieszkanie Adriana i klatka, środa 17:00. Ania z kluczem na klatce.
# W środku: zdjęcie "14.03" (PIN 1403), telefon trzeba naładować (ładowarka od Zenona
# albo od sąsiadki), trzy złe PIN-y blokują telefon na godzinę gry. Gdy Antoni wyjdzie
# z mieszkania, po schodach wchodzi Kuba z kluczem i ucieka.
const SCENA17 := {
	"poczatek": [
		["", "Blok na Woli, trzecie piętro. Na klatce pachnie kapustą, z dołu ktoś klnie, wnosząc rower."],
		["", "Ania stoi pod drzwiami z kluczem w dłoni i nie podnosi wzroku."],
	],
	"ania_start": [["Ania", "Przyszłam, bo obiecałam. Ale do środka nie wejdę."]],
	"ania_znowu": [["Ania", "(patrzy w okno na półpiętrze)"]],
	"ania_klucz_nie": [
		["Antoni", "Dasz mi klucz?"],
		["Ania", "(zaciska dłoń na kluczu) Nie wiem... To jego rzeczy. Jakby ktoś obcy grzebał w jego życiu."],
	],
	"ania_klucz_tak": [
		["Antoni", "Dasz mi klucz?"],
		["Ania", "(długo patrzy na klucz, potem wkłada mi go w rękę)"],
		["Ania", "Masz. Tylko niczego nie przestawiaj. On nie lubił, jak się przestawia."],
	],
	"ania_czwartek": [
		["Antoni", "Kiedy ostatnio rozmawiałaś z Adrianem?"],
		["Ania", "W czwartek rano. Mówiłam ci już. Przed próbą."],
	],
	"ania_choroba": [
		["Antoni", "Adrian był chory w ostatnich dniach?"],
		["Ania", "Zmęczony. Wszyscy byli zmęczeni przed premierą."],
	],
	"ania_kuba": [
		["Antoni", "Skąd Kuba ma klucz do mieszkania?"],
		["Ania", "Adrian mu dał. Pożyczał mu scenariusze, uczył go. Za dobre serce miał."],
		["Ania", "Ale czego on tu szukał? Teraz?"],
	],
	"ania_opaska": [
		["Ania", "(dotyka opaski palcami) Irena uszyła?"],
		["Ania", "(płacze cicho, potem wciska mi klucz w dłoń) Weź. Ja nie dam rady."],
	],
	"ania_sms": [
		["Antoni", "Czwartek, 22:10. \"Ten kostium mnie parzy, chyba jestem chory. Przyjedziesz?\" Odczytana."],
		["Ania", "(blednie)"],
		["Ania", "Ja... spałam. Musiałam spać. Telefon sam... nie wiem."],
		["Ania", "Muszę iść. Przepraszam."],
	],
	"ania_nic": [["Ania", "Nie wiem, Antoni. Nic już nie wiem."]],
	"ania_koniec": [["Ania", "Poczekam tu."]],
	"drzwi_zamkniete": [["", "Drzwi numer 12. Zamknięte. Klucz ma Ania."]],
	"drzwi_otwieram": [["", "Przekręcam klucz. Drzwi skrzypią. W środku zimno i cicho."]],
	"plakaty": [
		["", "Plakaty: \"Wesele\", \"Makbet\", \"Ostatni akt\". Na każdym ołówkiem dopisana jego rola."],
		["", "\"Gość weselny\". \"Drugi zabójca\". \"Dubler\". Żadnej głównej."],
	],
	"zdjecie": [
		["", "Na półce zdjęcie w ramce. Adrian i Ania na schodach teatru, oboje młodsi, roześmiani."],
		["", "Na dole jego pismem: \"14.03, nasz pierwszy raz w teatrze\"."],
	],
	"zdjecie_potem": [["", "\"14.03, nasz pierwszy raz w teatrze\"."]],
	"scenariusze": [
		["", "Sterta scenariuszy. \"Ostatni akt\" na wierzchu, cały w notatkach na marginesach."],
		["", "\"Adam gra to za głośno. Ja bym ciszej.\" \"Tu pauza.\" \"Tu ona na niego nie patrzy.\""],
	],
	"scenariusze_kuba": [["", "Sterta scenariuszy. Wierzchni egzemplarz \"Ostatniego aktu\" jest wymięty, jakby go ktoś czytał w tramwaju."]],
	"leki": [
		["", "Leki przeciwbólowe. Trzy puste opakowania i jedno prawie pełne. Wszystkie kupione w ostatnim tygodniu."],
		["", "Biorę to pełne. Może się przydać."],
	],
	"leki_potem": [["", "Puste opakowania po lekach przeciwbólowych."]],
	"lodowka": [["", "Na lodówce kartka pod magnesem, pismo rozjechane: \"od próby wszystko piecze, kupić maść\"."], ["", "Adrian pisał drobnymi, drukowanymi literami. Jak ktoś, kto całe życie przepisuje role."]],
	"lodowka_potem": [["", "\"Od próby wszystko piecze, kupić maść\"."]],
	"zlew": [["", "Kran kapie. Kap. Kap. Zakręcam go mocniej. Dalej kapie."]],
	"roslina": [["", "Zwiędła bazylia na parapecie. Nikt jej nie podlał od tygodnia."]],
	"lozko": [
		["", "Pościel skotłowana, prześcieradło zmięte w kłębek. Na poduszce plamy potu."],
		["", "Ktoś tu się rzucał całą noc."],
	],
	"szafa": [["", "Dwie koszule, sweter, jeden garnitur. Na dnie buty do tańca, zdarte do dziury."]],
	"gniazdko": [["", "Gniazdko przy stole."]],
	"brak_telefonu": [["", "Gniazdko. Szkoda, że telefon Adriana oddałem Wolskiemu. Teraz pewnie leży u niego."]],
	"bez_ladowarki": [["", "Telefon Adriana jest rozładowany do zera. Ładowarki Adriana nigdzie nie widać, a moja nie pasuje do tak starego modelu."]],
	"podlaczam": [["", "Podłączam telefon Adriana. Ekran budzi się po chwili: bateria jeden procent. Musi trochę postać."]],
	"laduje": [["", "Ładuje się. Jeszcze chwila."]],
	"pin_pytanie": [["", "Telefon włączony. \"Wpisz PIN\". Cztery cyfry."]],
	"pin_zly": "Zły PIN. Zostało prób: %d",
	"pin_blokada": [["", "\"Telefon zablokowany. Spróbuj ponownie za 60 minut.\""], ["", "Siedzę i patrzę w ścianę. Godzina w plecy."]],
	"pin_dobry": [
		["", "Telefon się odblokowuje. Tapeta: Adrian i Ania na schodach teatru."],
		["", "Wiadomości. Ostatnia wysłana: czwartek, 22:10. Do: Ania."],
		["", "\"Ten kostium mnie parzy, chyba jestem chory. Przyjedziesz?\""],
		["", "Odczytana. Bez odpowiedzi."],
	],
	"pin_potem": [["", "Czwartek, 22:10, do Ani. \"Ten kostium mnie parzy...\" Odczytana."]],
	"sasiadka_puka": [["", "Pukam do jedenastki. Szuranie kapci, łańcuch, szpara w drzwiach."]],
	"sasiadka_start": [["Sąsiadka", "Pan z policji? Do Adriana? Jezus Maria, to prawda, co mówią?"]],
	"sasiadka_znowu": [["Sąsiadka", "No?"]],
	"sasiadka_adrian": [
		["Antoni", "Jaki był Adrian?"],
		["Sąsiadka", "Taki grzeczny chłopak. Zakupy mi wnosił. W czwartek w nocy słyszałam, jak kaszle i płacze."],
		["Sąsiadka", "Ściany tu jak z papieru. Chciałam zapukać, ale późno było."],
	],
	"sasiadka_goscie": [
		["Antoni", "Ktoś do niego przychodził?"],
		["Sąsiadka", "Ta jego dziewczyna, ładna, ruda. Ostatnio rzadziej. I ten młody, okularnik, po książki."],
		["Sąsiadka", "W czwartek w nocy nikt nie przyszedł. A on chyba czekał, bo co chwilę otwierał drzwi na klatkę."],
	],
	"sasiadka_piatek": [
		["Antoni", "A w piątek?"],
		["Sąsiadka", "Wyszedł rano, blady jak ściana, w kurtce, chociaż ciepło było. I już nie wrócił."],
	],
	"sasiadka_ladowarka": [
		["Antoni", "Ma pani ładowarkę do starego telefonu?"],
		["Sąsiadka", "(znika na chwilę w mieszkaniu) Do takiej starej cegły jak moja? Proszę. Tylko oddać!"],
	],
	"sasiadka_nic": [["Sąsiadka", "Ja tam nic nie wiem, ja tylko słyszę przez ścianę."]],
	"sasiadka_koniec": [["Sąsiadka", "(zamyka drzwi na łańcuch)"]],
	"kuba_wbiega": "O cholera...",
	"kuba_ucieka": [["", "Po schodach wbiega Kuba. W ręku klucz z breloczkiem. Na mój widok zamiera, a potem zbiega na dół, przeskakując po trzy stopnie."]],
	"ania_po_kubie": [["Ania", "To był Kuba? Skąd on ma klucz?"]],
	"wyjscie_bez_ani": [["", "Schodzę na dół. Ani już nie ma na klatce."]],
	"wyjscie": [["", "Schodzę po schodach. Za ścianą u sąsiadów gra telewizor, teleturniej."]],
	"tv": "(przez ścianę telewizor sąsiadów: oklaski z teleturnieju)",
}

const SCENA17_TLO := {
	"ania": ["(patrzy w okno)", "(obraca klucz w palcach)", "(pociąga nosem)"],
}

## Wybór po scenie 15: dokąd teraz.
const SCENA15_DOKAD := ["Zajrzę do gabinetu Lisa", "Jadę do mieszkania Adriana"]

# Retrospekcja 3 (po scenie 17): czwartek 22:10 w mieszkaniu Adriana.
const RETRO3 := {
	"tytul": "Czwartek, 22:10. Tak mogło być.",
	"kaszel": "(kaszle, nie może złapać tchu)",
	"piecze": "Wszystko piecze...",
	"tabletki": "(łyka tabletki, jedną po drugiej)",
	"maść": "Trzeba kupić maść...",
	"sms": "\"Ten kostium mnie parzy, chyba jestem chory. Przyjedziesz?\"",
	"telefon_bez": "(sięga po telefon, pisze coś długo)",
	"sciana": "(zza ściany) Panie Adrianie? Wszystko dobrze?",
	"drzwi": "(otwiera drzwi na klatkę, nasłuchuje, zamyka)",
	"czeka": "Przyjedź...",
	"ekran": "Gdzieś w mieście świeci ekran telefonu. Ktoś czyta: \"Przyjedziesz?\". Odczytano.",
	"pierscionek": "Na palcu tej dłoni sygnet. Taki sam jak na zdjęciu z próby.",
	"koniec": "Nikt nie przyjechał.",
	"koniec_bez_sms": "Komu napisał? Bez jego telefonu się nie dowiem.",
}

# Retrospekcja 4 (po scenie 18): rok temu, nocna droga. Tylko jeśli Antoni słyszał o nagraniu.
const RETRO4 := {
	"tytul": "Rok temu, nocna droga. Tak mogło być.",
	"rower": "(dzwonek roweru)",
	"hamulce": "(pisk opon)",
	"uderzenie": "(głuche uderzenie)",
	"odjezdza": "(auto odjeżdża bez świateł)",
	"kamera": "(za drugim autem miga czerwona lampka kamery)",
	"wolski": "Mam cię, kochanie.",
	"pendrive": "Na nagraniu z pendrive'a widać numer rejestracyjny i twarz kierowcy w świetle latarni.",
	"koniec": "Rowerzysta przeżył. Kierowca nigdy się nie zgłosił.",
}

const RETRO_PRZYMIERZANIE := {
	"przymierz": "Przymierz: kto to był?",
	"zostaw": "Zostaw tak, jak jest",
	"kto": "Kto to był? (imię, Enter)",
	"nie_znam": "Nikogo takiego nie mam na tablicy.",
	"moze": "%s? Może...",
	"bez_karty": "Nie mam karty, która temu przeczy",
	"nic_nie_dowodzi": "To niczego nie dowodzi.",
}

## Przymierzanie w retrospekcjach: kontekst -> imię -> [karta, która temu przeczy, co mówi Antoni].
const PRZYMIERZANIE := {
	"pracownia": {
		"Irena": ["paragon", "Nie. Irena o tej porze była w hurtowni na Fabrycznej."],
		"Lis": ["bank", "Nie. Lis stał wtedy pod bankiem i błagał o kredyt."],
		"Wolski": ["recepta", "Nie. Do Wolskiego przyszedł wtedy lekarz z wizytą domową."],
		"Kuba": ["casting", "Nie. Kuba był o ósmej na castingu, ma zdjęcie z numerem."],
		"Marta": ["marta_grafik", "Nie. Marta była na korytarzu i potknęła się o skrzynki. To ona widziała."],
		"Halina": ["kwit", "Nie. Halina zobaczyła kostium dopiero w skrzynce nocnej, o 23:40."],
	},
	"sms": {
		"Wolski": ["sms", "Nie. SMS poszedł do Ani."],
		"Irena": ["sms", "Nie. SMS poszedł do Ani."],
		"Lis": ["sms", "Nie. SMS poszedł do Ani."],
		"Marta": ["sms", "Nie. SMS poszedł do Ani."],
		"Halina": ["sms", "Nie. SMS poszedł do Ani."],
		"Kuba": ["sms", "Nie. SMS poszedł do Ani."],
	},
	"droga": {
		"Wolski": ["pendrive", "Nie. Wolski jechał za nią i nagrywał."],
		"Irena": ["pendrive", "Nie. Na nagraniu za kierownicą siedzi ktoś inny."],
		"Lis": ["pendrive", "Nie. Na nagraniu za kierownicą siedzi ktoś inny."],
		"Marta": ["pendrive", "Nie. Na nagraniu za kierownicą siedzi ktoś inny."],
		"Halina": ["pendrive", "Nie. Na nagraniu za kierownicą siedzi ktoś inny."],
		"Kuba": ["pendrive", "Nie. Na nagraniu za kierownicą siedzi ktoś inny."],
	},
	"skrzynka": {
		"Kuba": ["garnitur", "Nie. Kuba był przy pralni o 23:10 i podpisał się pełnym nazwiskiem."],
		"Halina": ["kwit", "Nie. Halina rano wyjęła kostium ze skrzynki, nie wrzucała go."],
		"Wolski": ["recepta", "Nie wiem... Wolski leżał chory. Recepta to potwierdza."],
	},
}

## Imiona z tablicy i jak gracz może je wpisać (po uproszczeniu jak w teczce).
const PODEJRZANI_ALIASY := {
	"Ania": ["ania", "anna", "wrzos", "ania wrzos", "anna wrzos"],
	"Wolski": ["wolski", "adam", "adam wolski"],
	"Irena": ["irena", "mroz", "irena mroz"],
	"Lis": ["lis", "bogdan", "bogdan lis", "dyrektor"],
	"Marta": ["marta"],
	"Halina": ["halina", "pani halina"],
	"Kuba": ["kuba", "jakub", "adamczyk", "jakub adamczyk", "kuba adamczyk"],
}

# Scena 18: garderoba Wolskiego, środa 21:00. Teatr pusty. Antoni szuka czegoś na Wolskiego,
# słyszy kroki i musi schować się za stojakiem. Podsłuch rozmowy z Anią. Potem zeszyt,
# recepta w koszu i sejf (szyfr: rok pierwszej roli, 1998). Przyłapany: sejf dopiero jutro.
const SCENA18 := {
	"plansza": "Garderoba Wolskiego, środa 21:00",
	"plansza_jutro": "Garderoba Wolskiego, czwartek 15:00",
	"poczatek_klucz": [
		["", "Teatr pusty po próbie. Zapasowy klucz z bezpieczników pasuje i do garderób."],
		["", "Na korytarzu brzęczy świetlówka. Gdzieś daleko gwiżdże stróż."],
	],
	"poczatek_bez_klucza": [
		["", "Drzwi garderoby zamknięte. Czekam w ciemnym korytarzu prawie godzinę, aż sprzątaczka przyjdzie z wiadrem."],
		["", "Zostawia uchylone drzwi i idzie po nową szmatę. Wchodzę."],
	],
	"poczatek_jutro": [
		["", "Czwartek po południu. Wolski jest na próbie, garderobiana poszła po obiad. Drzwi otwarte."],
	],
	"kroki": "Kroki na korytarzu! Ktoś idzie prosto tutaj.",
	"przylapany_przed": [
		["Wolski", "Detektyw? W mojej garderobie? O tej porze?"],
		["Wolski", "(uśmiecha się szeroko) Rozumiem, rozumiem. Pan mnie pilnuje. Jakie to wzruszające."],
		["Wolski", "Ale teraz proszę mnie zostawić. Muszę się wyspać przed jutrzejszą próbą. Dobranoc, detektywie."],
		["", "Odprowadza mnie do drzwi i przekręca klucz od środka. Do sejfu dziś już się nie dobiorę."],
	],
	"skrzyp": "(podłoga skrzypi pod butem)",
	"kto_tu": "Kto tu jest?!",
	"przylapany_w_trakcie": [
		["Wolski", "(odsuwa kostiumy na stojaku) No proszę. Detektyw w szafie. Jak w farsie."],
		["Wolski", "Długo pan tu stoi? Nieważne. Proszę wyjść. Natychmiast. Uprzejmie proszę."],
		["", "Wypycha mnie na korytarz i zamyka drzwi na klucz."],
	],
	"wolski_koniak": "(nalewa koniaku, nuci)",
	"rozmowa": [
		"Aniu? To ja. Nie, nie przeszkadzasz.",
		"Aniu, nie płacz mi tu. Dubler zawsze się znajdzie. Ale ty nie.",
		"Słucham? Policja? Chłopak umarł na serce, kochanie. Tak powiedział lekarz.",
		"I jeszcze jedno. Od tego miesiąca płacisz podwójnie.",
		"Bo inaczej nagranie z twoim samochodzikiem i tym rowerzystą ląduje na komendzie.",
		"Rozumiemy się? No. Grzeczna dziewczynka. Dobranoc.",
	],
	"do_lustra": "Brawo, Adamie. Najlepsza rola sezonu.",
	"wolski_wychodzi": "(gasi lampę przy lustrze i wychodzi, gwiżdżąc)",
	"po_podsluchu": [
		["", "Stoję za kostiumami jeszcze długo po tym, jak ucichły kroki."],
		["", "Ciepły Wolski z wtorku. \"Biedny Adrian, zginął za mnie.\" Najlepsza rola sezonu."],
	],
	"szuflada": [
		["", "W szufladzie toaletki zeszyt w kratkę. Daty, kwoty, inicjały."],
		["", "\"A.W., pierwszego każdego miesiąca, 2000 zł\". Ciągnie się od roku. Ostatnia rubryka: \"od listopada x2\"."],
	],
	"szuflada_potem": [["", "Zeszyt z wpłatami \"A.W.\". Od roku, co miesiąc."]],
	"szuflada_wolski": [["", "Szuflada toaletki. Wolski siedzi tuż obok, nie ma mowy."]],
	"kosz": [
		["", "W koszu zmięta karteczka. Recepta: \"Adam Wolski. Wizyta domowa, czwartek 7:30. Gorączka 39,2\"."],
		["", "Podpis i pieczątka lekarza rodzinnego. Wolski naprawdę był chory."],
	],
	"kosz_popiol": [["", "Pod receptą trochę popiołu i nadpalony róg kartki: \"...rzelew 2000...\". To, co spalił we wtorek."]],
	"kosz_potem": [["", "Kosz. Popiół i zmięte chusteczki."]],
	"sejf": [["", "Mały sejf. Pokrętło z czterema cyframi."]],
	"sejf_wolski": [["", "Sejf przy szafie. Przy Wolskim nawet nie patrzę w tamtą stronę."]],
	"sejf_opis": "Szyfr sejfu (4 cyfry, Enter)",
	"sejf_zly": "Nie otwiera się. Pokrętło zgrzyta.",
	"sejf_otwarty": [
		["", "Klik. Drzwiczki się uchylają."],
		["", "W środku plik banknotów, zegarek i czarny pendrive w woreczku. Na woreczku flamastrem: \"A.\"."],
		["", "Pieniędzy nie ruszam. Biorę pendrive."],
	],
	"sejf_telefon": [["", "Pod banknotami telefon z pękniętą szybką i naklejką z maską. Telefon Adriana. \"Zgubiony\". Biorę go."]],
	"sejf_potem": [["", "Pieniądze i zegarek. Niech sobie leżą."]],
	"toaletka": [["", "Koniak, puder, szminki. Za ramą lustra recenzja: \"Wolski w formie życia\"."]],
	"stojak": [["", "Kostiumy z dawnych spektakli. Gęsto wiszą. Ktoś by się tu zmieścił."]],
	"plakat": [["", "\"HAMLET 1998\". Młody Wolski z czaszką."]],
	"szafa": [["", "Garnitury, szlafrok z monogramem. Listów z pogróżkami ani śladu."]],
	"kanapa": [["", "Kanapa. Pod poduszką nic. Tylko zapach wody kolońskiej."]],
	"bukiety": [["", "Zwiędłe bukiety. Nikt ich nie wyrzucił."]],
	"wyjscie_noc": [["", "Wychodzę cicho. Świetlówka na korytarzu brzęczy dalej."]],
}

const SCENA18_TLO := {
	"stroz": ["(gwizdanie gdzieś daleko)", "(brzęczenie świetlówki)"],
}

# Scena 19: foyer i bufet, czwartek 10:00. Marta pamięta Anię w pracowni o ósmej, ale nie dzień.
# Skrzynki na mleko przy drzwiach PERSONEL, grafik dostaw w jednej z nich, bufetowa o mleku.
# Kuba próbuje roli w kącie: otworzy się dopiero, gdy Antoni widział go na klatce.
const SCENA19 := {
	"plansza": "Teatr, czwartek 10:00",
	"poczatek": [
		["", "Czwartek rano. W foyer pachnie świeżym chlebem: dostawca wnosi pieczywo do bufetu."],
		["", "Aktorzy jedzą śniadanie przy stolikach i cicho żartują. Pierwszy raz od soboty ktoś się śmieje."],
	],
	"marta_start": [["Marta", "(wkłada baterie do krótkofalówek) Detektyw. Szybko, mam próbę techniczną za dwadzieścia minut."]],
	"marta_znowu": [["Marta", "(stuka krótkofalówką o dłoń) No?"]],
	"marta_pracownia": [
		["Antoni", "Kto przychodzi rano do pracowni kostiumów?"],
		["Marta", "Rano? Nikt. Irena przychodzi na dziewiątą, a wcześniej to tylko ja z kluczami."],
		["Marta", "(zatrzymuje się) Chociaż... Raz widziałam tam Anię. O ósmej. Chyba w piątek. Albo w czwartek? Nie, w piątek."],
	],
	"marta_szczegoly": [
		["Antoni", "Pamiętasz coś jeszcze z tamtego rana?"],
		["Marta", "Potknęłam się o jakieś skrzynki w korytarzu, ktoś je zostawił pod drzwiami. Prawie się zabiłam."],
		["Marta", "Ania miała coś w rękach, jakąś butelkę. Pomyślałam, że woda albo rozpuszczalnik do szminki."],
	],
	"marta_klucz": [
		["Antoni", "Kto ma klucz do pracowni?"],
		["Marta", "Ja, Irena, dyrekcja i główna obsada. Tak zawsze było."],
	],
	"marta_podpis": [
		["Antoni", "Znasz to pismo? Duże A z pętelką."],
		["Marta", "(mruży oczy) Pętelka i kreska pod spodem... Tak się podpisuje Ania. Na każdej kartce urodzinowej w pokoju aktorów."],
		["Marta", "Uczyła się autografu jeszcze w szkole teatralnej. Śmialiśmy się z niej."],
	],
	"marta_grafik": [
		["Marta", "(patrzy na grafik, potem na skrzynki pod drzwiami)"],
		["Marta", "Mleko w czwartki... To były te skrzynki. Pod drzwiami PERSONEL."],
		["Marta", "To był czwartek. Czwartek rano, przed próbą generalną. Jezu."],
	],
	"marta_grafik_bez": [["Marta", "Grafik dostaw? Co mnie obchodzi mleko? Ja pytam o nic, ja mam próbę."]],
	"marta_nic": [["Marta", "Nie mam pojęcia. Ja tu tylko pilnuję, żeby wszystko działało."]],
	"marta_koniec": [["Marta", "(wraca do krótkofalówek)"]],
	"skrzynki": [
		["", "Pod drzwiami PERSONEL stoją puste plastikowe skrzynki po mleku. Trzy, jedna na drugiej."],
		["", "Ktoś je zawsze zostawia w przejściu. Łatwo się potknąć."],
	],
	"grafik": [["", "W dolnej skrzynce, przyklejona taśmą, kartka: \"Mleczarnia Łąka. Dostawy: CZWARTKI, 7:30\". Odklejam ją."]],
	"skrzynki_potem": [["", "Puste skrzynki po mleku."]],
	"bufetowa_mleko": [
		["Antoni", "Kiedy przychodzi mleko?"],
		["Bufetowa", "Mleko? Tylko w czwartki, panie. W inne dni piją czarną."],
		["Bufetowa", "Skrzynki zostawiają pod drzwiami do kulis, bo do mnie im się nie chce nosić."],
	],
	"bufetowa_start": [["Bufetowa", "Kawy? Dziś jest z mlekiem. Czwartek."]],
	"bufetowa_kawa": [["Bufetowa", "Proszę. Na koszt firmy, pan tu prawie mieszka."]],
	"bufetowa_nic": [["Bufetowa", "Ja tu tylko nalewam."]],
	"bufetowa_koniec": [["Bufetowa", "Smacznego."]],
	"kuba_ucieka": [["Kuba", "(na mój widok odwraca się do ściany i powtarza rolę głośniej) \"...i nie ma już powrotu, panie...\""]],
	"kuba_start": [["Kuba", "(blednie) To pan... z klatki. Ja wszystko wytłumaczę."]],
	"kuba_znowu": [["Kuba", "No co jeszcze?"]],
	"kuba_mieszkanie": [
		["Antoni", "Co robiłeś w mieszkaniu Adriana?"],
		["Kuba", "Szedłem po scenariusz. Ten z jego notatkami. Adrian dał mi klucz, żebym brał, kiedy chcę."],
		["Kuba", "Uciekłem, bo... bo głupio wyszło. Jakbym okradał trupa. Ja tylko chciałem zagrać to tak, jak on by zagrał."],
	],
	"kuba_czwartek_zly": [
		["Antoni", "Gdzie byłeś w czwartek rano?"],
		["Kuba", "Na zajęciach. Mówiłem już. Mam próbę, przepraszam."],
	],
	"kuba_czwartek": [
		["Antoni", "Gdzie byłeś w czwartek rano? Na liście obecności cię nie ma."],
		["Kuba", "(wzdycha) Na castingu w Teatrze Nowym. Wagarowałem. Jak uczelnia się dowie, wylecę."],
		["Kuba", "(pokazuje telefon) Proszę. Ja z numerem 14 na piersi. Czwartek, 8:02."],
	],
	"kuba_kwit": [
		["Kuba", "Skrzynka w pralni? Byłem tam w czwartek, ale o 23:10. Oddałem garnitur na casting."],
		["Kuba", "(grzebie w portfelu) Mam swój kwit. Podpisałem się całym nazwiskiem, Adamczyk. Nie żadne \"A.\"."],
		["", "Koślawe, szkolne litery. A jak daszek, bez pętelki."],
	],
	"kuba_wolski": [
		["Antoni", "Znasz całą rolę Wolskiego na pamięć."],
		["Kuba", "Od roku. Każdy statysta marzy. Ale nie tak. Nie przez to."],
	],
	"kuba_nic": [["Kuba", "Nie wiem, co to jest. I nie chcę wiedzieć. Za tydzień mam egzamin."]],
	"kuba_koniec": [["Kuba", "(wraca do roli, ciszej)"]],
	"dostawca": [["Dostawca", "Z drogi, panie, chleb jedzie!"]],
	"aktor": [["Aktor", "Kuba gra za Adriana. Dzieciak, ale zdolny."]],
	"aktorka": [["Aktorka", "Ania nie przyszła na śniadanie. Od soboty nic nie je."]],
	"zdjecie": [["", "Zdjęcie Adriana pod świeczką. Ktoś dołożył świeże goździki."]],
}

const SCENA19_TLO := {
	"marta": ["Kanał dwa, próba...", "(krótkofalówka trzeszczy)", "Kto znowu wziął baterie?"],
	"kuba": ["\"...i nie ma już powrotu...\"", "\"...panie, to nie ja...\"", "(mamrocze rolę)"],
	"dostawca": ["Chleb jedzie!", "(sapie)"],
	"aktorzy": ["(śmiech przy stoliku)", "Podaj sól.", "Wczoraj Kuba zapomniał tekstu."],
}

# Retrospekcja 5 (po scenie 19): czwartek rano, pracownia, i noc przy skrzynce pralni.
const RETRO5 := {
	"tytul_czwartek": "Czwartek, 8:00. Tak mogło być.",
	"tytul_niewiadomo": "Czwartek? Piątek? 8:00. Tak mogło być.",
	"sylwetka": "(ktoś pochyla się nad kostiumem z butelką w dłoni)",
	"marta": "Kto tu zostawia te skrzynki?!",
	"marta_widzi": "(Marta przystaje w drzwiach, potem idzie dalej)",
	"rekawiczki": "(gumowe rękawiczki skrzypią na palcach)",
	"podszewka": "(pędzelkiem wzdłuż szwów podszewki)",
	"noc": "Czwartek, 23:10 i 23:40. Pralnia \"Perła\".",
	"kuba": "(wrzuca garnitur do skrzynki, podpisuje kwit: Adamczyk)",
	"kostium": "(wrzuca kostium do skrzynki, podpisuje kwit: A.)",
	"koniec": "Do pogrzebu została jedna noc.",
}

# Czwartek po scenie 19: dokąd teraz (lista budowana w Rozdzial4.czwartek).
# Przejazd między miejscami w rozdziale 4: taksówka za pieniądze albo autobus za czas.
const DOJAZD := {
	"taksowka": "Taksówka (%d zł, masz %d zł)",
	"autobus": "Autobusem (%d min w plecy)",
	"brak": "Mam tylko %d zł, na taksówkę nie starczy. Autobus. Trochę to potrwa.",
}

const CZWARTEK := {
	"pytanie": "Czwartek po południu. Co teraz?",
	"ania": "Garderoba Ani (Ania jest na próbie)",
	"wolski": "Garderoba Wolskiego (sejf)",
	"ola": "Obiad u Oli",
	"dom": "Wracam do domu",
}

# Obiad u Oli: raz na dzień, +40 sił, godzina w plecy.
const OLA := {
	"start": [["Ola", "No wreszcie! Siadaj. Rosół, ziemniaki, kotlet. I nie gadaj mi, że nie jesteś głodny."]],
	"slaby": [["Ola", "Antek, ty wyglądasz jak trup. Biegasz po mieście i nic z tego nie masz. Kiedy ostatnio spałeś? Jedz. Powoli."]],
	"palce": [["Ola", "Co ty masz z palcami? Czerwone jak od pokrzyw. Pokaż... Tylko nie mów, że to od pracy."]],
	"bilet": [["Ola", "Wiesz, że ja ci ten bilet dałam, żebyś odpoczął? A ty mi z premiery zrobiłeś śledztwo."]],
	"ania": [["Ola", "Ta dziewczyna od tego chłopaka... Biedna. Widziałam ją w telewizji. Taka chuda."]],
	"koniec": [["Ola", "Masz, tu pięćdziesiąt złotych na taksówki. Nie kłóć się. I zadzwoń do mamy, bo mnie męczy."], ["", "Najedzony. Od razu lepiej się myśli."]],
	"potem": [["Ola", "Dzisiaj już jadłeś. Idź łapać tych swoich morderców."]],
}

# Scena 20: garderoba Ani, czwartek 16:00. Ania na próbie. Rękawiczki w koszu (UV),
# spinka w pudełku z charakteryzacją, szuflada z wydrukami przelewów, kartka od Adriana.
const SCENA20 := {
	"plansza": "Garderoba Ani, czwartek 16:00",
	"poczatek_klucz": [["", "Zapasowy klucz pasuje. Ze sceny słychać próbę i głos Ani. Gra, jakby nic się nie stało."]],
	"poczatek_bez_klucza": [
		["", "Zamknięte. Czekam pod drzwiami prawie godzinę, aż garderobiana przyniesie Ani wyprasowaną suknię."],
		["", "Zostawia drzwi otwarte. Wchodzę, zanim wróci."],
	],
	"proba": ["(ze sceny) \"...nie zostawiaj mnie samej...\"", "(ze sceny) \"Jeszcze raz od wejścia!\"", "(ze sceny, głos Ani) \"...kochałam cię, wiesz?\""],
	"kroki": "Kroki na korytarzu. Ktoś idzie w stronę garderoby...",
	"kroki_mijaja": "Kroki mijają drzwi i cichną. Mało brakowało.",
	"ania_wchodzi": [
		["Ania", "Antoni?! Co ty tu robisz?"],
		["Ania", "(patrzy na otwartą szufladę, potem na mnie, długo)"],
		["Ania", "Wyjdź. Proszę cię, po prostu wyjdź."],
	],
	"kosz": [["", "Kosz pod toaletką. Pełno zużytych chusteczek z resztkami szminki."], ["", "Na dnie, pod chusteczkami, para gumowych rękawiczek. Zwinięte w kulkę."]],
	"kosz_uv": [["", "Świecę na nie lampą UV."], ["", "Świecą. Tym samym zielonym światłem co plama na podszewce. Zwłaszcza palce."]],
	"kosz_bez_uv": [["", "Zwykłe gumowe rękawiczki. Do czego aktorce gumowe rękawiczki?"]],
	"kosz_reka": [["", "Dotykam ich gołymi palcami. Po chwili zaczynają szczypać. Wycieram dłonie w spodnie."]],
	"kosz_rekawiczki": [["", "Wyjmuję je przez swoje lateksowe. Ostrożnie."]],
	"kosz_potem": [["", "Chusteczki z resztkami szminki."]],
	"pudelko": [["", "Pudełko z charakteryzacją: pudry, kredki, pędzelki. Między nimi wygięta spinka do włosów. Biorę ją."]],
	"pudelko_potem": [["", "Pudry, kredki, pędzelki."]],
	"szuflada_zamknieta": [["", "Dolna szuflada toaletki zamknięta na mały zamek. Prosty, tani."]],
	"szuflada_otwieram": [
		["", "Wkładam spinkę w zamek. Kręcę, naciskam... Klik."],
		["", "W szufladzie wydruki przelewów z banku. Co miesiąc, pierwszego. Odbiorca: Adam Wolski. Tytuł: \"darowizna\"."],
		["", "Od roku. Ostatni z listopada: podwójny."],
	],
	"szuflada_potem": [["", "Wydruki przelewów do Wolskiego."]],
	"lustro": [
		["", "Do lustra przyklejona kartka, pismo Adriana, drobne i drukowane:"],
		["", "\"Złamania karku, kochanie. Zawsze w ciebie wierzę.\""],
	],
	"szkatulka": [["", "Szkatułka z biżuterią. Na wierzchu gruby złoty sygnet."], ["", "Taki sam jak ten na zdjęciu z próby. Tylko że ten jest prawdziwy. W środku grawer: \"A. 14.03\"."], ["Antoni", "Rekwizytowy jest z mosiądzu. Ten nie."]],
	"szkatulka_potem": [["", "Sygnet z grawerem \"A. 14.03\". Ta sama data co PIN w telefonie Adriana."]],
	"zdjecie": [["", "Zdjęcie: Ania i Adrian na plaży. To samo, co w sobotę. Tylko ramka jest teraz odwrócona do ściany."], ["", "Za nim wsunięte drugie, starsze: mała Ania z ojcem przed bramą z napisem \"FARBIARNIA WOLA\"."]],
	"wieszak": [["", "Kostiumy Ani. Czarna suknia na finał. Obok, w folii, czarna sukienka na pogrzeb."]],
	"kanapa": [["", "Kanapa. Koc i poduszka. Wygląda, jakby tu nocowała."]],
	"szafa": [["", "Płaszcz, kozaki, parasol. Kluczyki do samochodu z breloczkiem w kształcie maski."]],
	"kwiaty": [["", "Zwiędłe róże. Bilecik: \"Dla mojej Julii. A.\""]],
	"parawan": [["", "Za parawanem sukienka z próby, rzucona na podłogę."]],
	"wyjscie": [["", "Wychodzę na korytarz. Ze sceny wciąż słychać jej głos."]],
	"koniec_dnia": [
		["", "Czwartek wieczorem. Siedzę w samochodzie pod teatrem i patrzę na zapalone okno garderoby Ani."],
		["", "Jutro w południe pogrzeb. Do pogrzebu została jedna noc."],
	],
	"rozdzial": "Koniec rozdziału 4.",
	"rozdzial5": "Rozdział 5: Ostatni akt",
}

const SCENA15_DOKAD_OLA := "Obiad u Oli"


# ---------- ROZDZIAŁ 5: OSTATNI AKT ----------

# Scena 21: pokój Antoniego, piątek od 6:00. Tablica z trzema pytaniami, telefony od Oli
# i Nowickiego, kuchnia, łóżko. Zegar idzie tylko od tego, co Antoni robi. SMS do
# oskarżonej osoby trzeba wysłać przed 9:00, inaczej sprawa idzie do archiwum.
const SCENA21 := {
	"plansza": "Pokój Antoniego, piątek %s",
	"pogrzeb": "Pogrzeb Adriana o 12:00.",
	"start": [["", "Nie spałem. Na ścianie wszystko, co mam: zdjęcia, kwity, kartki z notesu. I czerwona nitka."]],
	"start_zaspal": [["", "Zasnąłem nad notatkami. Zegar... %s. Straciłem rano, bo straciłem cały tydzień."]],
	"zegar": "Zegar: %s",
	"tablica_napis": "Tablica",
	"tablica_start": [["", "Trzy pytania. Każde trzeba przypiąć dowodem, inaczej nitka nie trzyma."]],
	"pytania": ["Jak zginął Adrian?", "Kto miał zginąć?", "Odejdź od tablicy"],
	"jak_odp": ["Zawał serca", "Trucizna w podszewce kostiumu", "Herbata z termosu", "Upadek w magazynie"],
	"kto_odp": ["Adrian", "Wolski", "Ania", "Lis"],
	"czym_przypiac": "Czym to przypiąć?",
	"bez_dowodu": "Nie mam czym (zostaw)",
	"zla_odp": [["", "Przypinam. Nitka zwisa. To się nie trzyma kupy."]],
	"zly_dowod": [["", "Dobra odpowiedź, ale ten dowód niczego tu nie dowodzi. Nitka spada."]],
	"jak_dobrze": [["", "Trucizna kontaktowa w podszewce. Zabija po dobie, dwóch. Nitka trzyma."]],
	"kto_dobrze": [["", "Kostium Wolskiego, rozmiar Wolskiego, premiera Wolskiego. To on miał go założyć. Nitka trzyma."]],
	"juz_jest": [["", "To już wisi. Nie ruszam."]],
	"zostawiam": [["", "Nie mam tego czym przypiąć. Zostawiam znak zapytania."]],
	"monolog_start": "Patrzę na całość.",
	# fragmenty monologu: [warunek, tekst]
	"monolog": [
		["p:zdjecie_plamy", "Plama, która nie schodzi."],
		["w:kwit", "Kwit z podpisem A."],
		["w:marta_grafik", "Czwartek rano w pracowni."],
		["w:sms", "SMS bez odpowiedzi."],
		["w:rekawiczki", "Rękawiczki, które świecą."],
		["w:przelewy", "Przelewy co miesiąc."],
		["f:s18_podsluch", "I powód: Wolski."],
	],
	"monolog_pusto": "Za mało. Mam dziury jak w starej kurtynie.",
	"ola_dzwoni": "Dzwoni telefon. Ola.",
	"ola": [["Ola", "Antek? Żyjesz? Jadłeś coś w ogóle od wczoraj?"]],
	"ola_wybor": ["Jadłem", "Jeszcze nie"],
	"ola_jadl_slaby": [["Ola", "Kłamiesz. Słyszę po głosie. Zjedz coś, zanim się przewrócisz, rozumiesz?"]],
	"ola_jadl": [["Ola", "No dobrze. Wierzę ci. Prawie."]],
	"ola_nie": [["Ola", "To zjedz! Masz w lodówce cokolwiek? Nie wychodź z domu na pusty żołądek."]],
	"ola_koniec": [["Ola", "I uważaj na siebie. Wiem, że dziś pogrzeb."]],
	"nowicki_dzwoni": "Dzwoni telefon. Komisarz Nowicki.",
	"nowicki": [["Nowicki", "Antek, masz czas do dwunastej. Potem chłopak idzie do ziemi, a sprawa do szafy. Jako zawał."], ["Nowicki", "Chyba że coś mi dasz."]],
	"nowicki_wybor": ["Przyjedź na 9:30 do teatru. Na scenę.", "Jeszcze nic nie mam"],
	"nowicki_tak": [["Nowicki", "Na scenę? Ty i te twoje teatry... Dobra. Biorę dwóch chłopaków. Lepiej, żeby to było coś."]],
	"nowicki_nie": [["Nowicki", "To nie dzwoń. Do dwunastej."]],
	"czajnik": [["", "Czajnik jeszcze ciepły. Piąta herbata od północy. Ręce i tak mi się trzęsą."]],
	"lodowka": [["", "Lodówka. Musztarda, dwa jajka, masło. Kartka od Oli: \"Zjedz coś!\" Później."]],
	"lozko": [["", "Narzuta nawet niepognieciona. Na sen będzie czas po pogrzebie."]],
	"okno": [["", "Świta. Sąsiad z dołu wyprowadza psa. Pies sika na tę samą latarnię co zawsze. Świat się nie zatrzymał."]],
	"stol_napis": "Telefon",
	"stol": [["", "Telefon. Jeden SMS: \"Przyjdź na scenę o 9:00.\" Do kogo?"]],
	"stol_wybor_nikt": "Nikogo jeszcze (odłóż telefon)",
	"stol_nikt_na_pewno": ["Wróć", "Nikogo nie oskarżę"],
	"skreslony": [["", "Skreśliłem tę osobę na tablicy w teczce. Na pewno?"]],
	"potwierdz": ["Tak, wysyłam", "Jeszcze nie"],
	"sms": "Przyjdź na scenę o 9:00. Antoni",
	"wyslane": [["", "Wysłane. Teraz nie ma odwrotu."]],
	"nikt": [["", "Nie mam nikogo. Odkładam telefon i patrzę, jak wskazówki idą do dwunastej."]],
	"za_pozno": [["", "Dziewiąta. Za późno, żeby kogokolwiek ściągać do teatru przed pogrzebem."]],
	"wyjscie": "Muszę najpierw wysłać tego SMS-a.",
	"tlo": ["(zegar) tik... tak...", "(za ścianą) radio, wiadomości o szóstej", "(pies na dworze) hau!"],
}

# Scena 22: pusta scena, piątek 9:00. Konfrontacja z oskarżoną osobą. Ania: rundy,
# w każdej gracz wybiera argument (Sledztwo.argumenty). Dobre: [mocne, słabe].
const SCENA22 := {
	"plansza": "Teatr Miejski, pusta scena, piątek 9:00",
	"start": [["", "Dekoracje ze sztuki o morderstwie. Jedno światło na krzesło, na którym w sztuce siedzi ofiara."]],
	"nowicki_jest": [["", "Na końcu widowni, w ciemności, skrzypi fotel. Nowicki. Przyszedł."]],
	"wchodzi": "Ktoś wchodzi od kulis.",
	"ania_wchodzi": [
		["Ania", "Antoni. Jestem już ubrana na pogrzeb, widzisz. Po co ta scena?"],
		["Antoni", "Usiądź. Na tym krześle."],
		["Ania", "Na krześle ofiary? (siada) No dobrze. Mów."],
	],
	"ania_przylapany": [["Ania", "Po tym, jak grzebałeś mi w garderobie, w ogóle nie powinnam przychodzić."]],
	"ania_uciekla": [["Ania", "I nie mów mi znowu o tym telefonie. Nie mam siły."]],
	"argument": "Co jej odpowiesz?",
	"wiecej": "Więcej...",
	"milcz": "Nic nie mam (milcz)",
	"ostatnia_szansa": "Ania wstaje z krzesła. Jeszcze jedno złe słowo i wyjdzie.",
	"slabe": [["Ania", "To nic pewnego i dobrze o tym wiesz."], ["", "Zostaje. Ale słyszę, jak to wątle zabrzmiało. Drugi taki argument i będzie po mnie."]],
	"zle": [
		[["Ania", "I co z tego? Szukasz na siłę."]],
		[["Ania", "To nie ma nic wspólnego ze mną."]],
		[["Ania", "Antoni, ty chyba nie spałeś. Słyszysz, co mówisz?"]],
	],
	# rundy: kłamstwo Ani, mocne argumenty, słabe argumenty, reakcja na dobry argument
	"rundy": [
		{"klamstwo": [["Ania", "Lekarz powiedział: zawał. Adrian miał słabe serce, brał leki. To wszystko."]],
		 "mocne": ["trucizna", "uv_zielona", "pasy_szwy", "plama"],
		 "slabe": ["skora", "podszewka_piekla", "zapach", "notatka_lodowka", "sam_dotknal", "halina_lakier", "ciemniejsza", "przez_skore"],
		 "reakcja": [["Ania", "(ściska torebkę) Trucizna? W kostiumie? To... to jakiś absurd."]]},
		{"klamstwo": [["Ania", "Ten kostium Adrian sam zaniósł do pralni. Zawsze o wszystko dbał."]],
		 "mocne": ["skrzynka_23_40", "pismo_ani"],
		 "slabe": ["sasiadka_kaszel", "pokrowiec", "kuba_widzial", "skrzynka_noc", "kwit_bez_karty"],
		 "reakcja": [["Antoni", "Kostium oddano do pralni w czwartek o 23:40. Podpis A. Adrian już wtedy leżał chory w domu."], ["Ania", "Każdy może napisać A. Adam też się tak podpisuje!"]]},
		{"klamstwo": [["Ania", "Może to Adam go oddał. Albo Kuba, on się kręcił koło tego kostiumu."]],
		 "mocne": ["recepta", "kuba_garnitur", "kuba_widzial", "pismo_ani"],
		 "slabe": ["wolski_chory", "pokrowiec", "wolski_grypa", "kuba_scenariusz"],
		 "reakcja": [["Ania", "(milczy dłuższą chwilę) Nie wiem, kto go oddał. Nie było mnie tam."]]},
		{"klamstwo": [["Ania", "W czwartek rano byłam w domu. Do pracowni Ireny w ogóle nie zaglądam."]],
		 "mocne": ["marta_czwartek"],
		 "slabe": ["marta_bez_dnia", "klucz_ania", "ania_pytala", "kartka_wolski", "marta_bez_karty", "mleko"],
		 "reakcja": [["Antoni", "Marta widziała cię w pracowni w czwartek o ósmej. Z butelką w ręku."], ["Ania", "Marta... Marta się potknęła. Ona nie wie, co widziała."]]},
		{"klamstwo": [["Ania", "Nie dotknęłam tego kostiumu. Pokaż mi choć jeden ślad, że go dotykałam."]],
		 "mocne": ["rekawiczki_uv"],
		 "slabe": ["pierscionek", "ania_pytala", "rekawiczki_bez_karty", "farbiarnia"],
		 "reakcja": [["Ania", "(patrzy na swoje dłonie) To... ja tylko poprawiałam szwy."]]},
		{"klamstwo": [["Ania", "Po co miałabym kogokolwiek krzywdzić? Adam to mój przyjaciel. Pomógł mi dostać tę rolę."]],
		 "mocne": ["podsluch", "zeszyt", "przelewy", "pendrive"],
		 "slabe": ["podsluch_czesc", "wolski_palil", "przelewy_bez_karty", "ania_dzwonila"],
		 "reakcja": [["Ania", "(szeptem) Rok. Cały rok płaciłam. Za to, że skręciłam w złą ulicę."]]},
		{"klamstwo": [["Ania", "Ostatni raz rozmawiałam z Adrianem w czwartek rano. Przysięgam ci na wszystko."]],
		 "mocne": ["ania_sms"],
		 "slabe": ["sms_bez_karty"],
		 "reakcja": [["Antoni", "Napisał do ciebie o 22:10, że kostium go parzy. Odczytałaś. I nie przyjechałaś."]]},
	],
	"sms_juz_wiedziala": [["Ania", "Już mi to mówiłeś na klatce. Uciekłam wtedy. Teraz nie mam dokąd."]],
	"przyznanie": [
		["Ania", "Bo nie mogłam mu pomóc! Rozumiesz? Nie ma na to lekarstwa."],
		["Ania", "To miał być on, Wolski. Adrian nigdy nie miał go założyć."],
		["Ania", "A potem Wolski zadzwonił, że jest chory, i było już za późno..."],
		["Ania", "Odebrałam kostium z próby w nocy. Myślałam, że jak go wypiorą, nic nie zostanie. Że to się nie stało."],
		["Ania", "Kwit wsunęłam Lisowi do przegródki. Miało wyglądać jak zwykłe pranie. Nikt nie pyta o zwykłe pranie."],
		["Ania", "A to świństwo... tata trzymał je w szopie. Z farbiarni. Mówił, żeby nigdy nie dotykać gołymi rękami."],
	],
	"kartka": [["Antoni", "\"Złamania karku, kochanie. Zawsze w ciebie wierzę.\" Wisi na twoim lustrze."]],
	"koniec_kartka": [["Ania", "(zakrywa twarz) Zabiłam jedyną osobę, która we mnie wierzyła."]],
	"koniec_bez_kartki": [["Ania", "(długo patrzy w puste krzesło obok) Zabiłam go. Zabiłam Adriana."]],
	"wychodzi": [["Ania", "Dość. Nie będę tego słuchać w dniu jego pogrzebu."], ["", "Ania wstaje i wychodzi. Drzwi od kulis trzaskają. Echo długo się niesie."]],
	# inne osoby: [kwestie po przyjściu, zaprzeczenie, alibi znane z karty]
	"inni": {
		"Wolski": [[["Wolski", "Panie Antoni, o dziewiątej rano? Na pustej scenie? Lubi pan teatr, przyznaję."]], [["Wolski", "Ja? Otruć samego siebie we własnym kostiumie? To byłby świetny scenariusz. Ale nie mój."]], [["Wolski", "Leżałem w czwartek z gorączką, był u mnie lekarz. Ma pan przecież receptę."]]],
		"Irena": [[["Irena", "Mam dziś pogrzeb do obszycia, panie Antoni. O co chodzi?"]], [["Irena", "Ja? Ja ten kostium szyłam! Wszywałabym truciznę we własną robotę?"]], [["Irena", "Byłam w czwartek rano w hurtowni. Ma pan mój paragon."]]],
		"Lis": [[["Lis", "Antoni, za trzy godziny pogrzeb, a pan mi urządza przedstawienie?"]], [["Lis", "Polisa to procedura! Każdy teatr ubezpiecza gwiazdy!"]], [["Lis", "W czwartek o ósmej błagałem w banku o kredyt. Ma pan potwierdzenie."]]],
		"Kuba": [[["Kuba", "Dostałem SMS-a... Panie Antoni, ja nic nie zrobiłem, przysięgam!"]], [["Kuba", "Ja tylko chciałem tę rolę! Nie w taki sposób!"]], [["Kuba", "Byłem na castingu w Teatrze Nowym. Ma pan moje zdjęcie z numerem."]]],
		"Marta": [[["Marta", "Inspicjentka ma zawsze coś do zrobienia, panie Antoni. Szybko."]], [["Marta", "Ja? Ja tylko pilnuję, żeby wszyscy weszli na czas."]], [["Marta", "To ja panu powiedziałam o czwartku. Sama siebie bym wydała?"]]],
		"Halina": [[["Halina", "Pan mnie ściągnął aż z pralni... Co się stało?"]], [["Halina", "Ja ten kostium tylko prałam! Ręce mam od tego popalone!"]], [["Halina", "Wyjęłam go ze skrzynki rano. Kwit ma pan przecież."]]],
	},
	"oskarzenie": [["Antoni", "Adrian zginął przez ten kostium. Wiem, kto go zatruł. Siedzi na krześle ofiary."]],
	"alibi_antoni": [["", "Ma rację. Sam mam w teczce dowód, że nie mogła tego zrobić. Że nie mógł."]],
	"nowicki_zabiera": [["Nowicki", "(z ciemnej widowni) Starczy. Zabieramy. Resztę wyjaśni prokurator."]],
	"nowicki_odmawia": [["Nowicki", "(z widowni) Antek, przecież ta osoba ma alibi. Sam je masz w papierach. Ja się pod tym nie podpiszę."]],
	"bez_nowickiego": [["", "Nikt nie przyjechał, żeby kogokolwiek zatrzymać. Osoba wychodzi. Drzwi trzaskają."]],
}

# Ostatnia retrospekcja: wszystko z twarzami. Pokazuje tylko to, co gracz ustalił.
const RETRO6 := {
	"tytul": "Czwartek. Tak było.",
	"sroda": "Środa wieczorem. Ania wie, że jutro na próbie Wolski założy swój kostium.",
	"ania_butelka": "(butelka) Tylko wzdłuż szwów...",
	"rekawiczki": "(zdejmuje gumowe rękawiczki)",
	"marta": "Ała! Kto tu... Ania?",
	"chory": "Czwartek, 7:00. Wolski dzwoni prywatnie do Lisa: gorączka. Reszta dowie się o dziewiątej. Dubler wchodzi na próbę.",
	"adrian": "Piecze mnie ta podszewka...",
	"sms": "22:10. \"Ten kostium mnie parzy...\" Odczytane.",
	"skrzynka": "23:40. Kostium ląduje w skrzynce nocnej pralni. Podpis: A.",
	"przymierzylem": "W retrospekcji wpisałem w tę sylwetkę Anię. Miałem rację od początku.",
	"przymierzylem_kogos": "W retrospekcji wpisałem w tę sylwetkę kogoś innego: %s. Myliłem się.",
	"koniec": "Tak było.",
}

# Scena 23: brawa. Wolski na widowni, potem Nowicki.
const SCENA23 := {
	"brawa": "Z ciemnej widowni: powolne brawa.",
	"wolski": [["Wolski", "Wspaniałe przedstawienie, panie Antoni. Teraz niech pan odda Anię policji i wszyscy pójdziemy na pogrzeb jak porządni ludzie."]],
	"wolski_ostrzezony": [["Wolski", "We wtorek mówił mi pan, że to ja miałem zginąć. Myślałem, że pan przesadza. Dziękuję. Uratował mi pan życie."]],
	"wolski_przylapany": [["Wolski", "A sejf proszę następnym razem zostawić w spokoju. Wiem, kto skrzypi podłogą w mojej garderobie."]],
	"wolski_nagrania": [["Wolski", "Myślę, że o nieistotnych nagraniach możemy zapomnieć. Prawda? Między przyjaciółmi teatru."]],
	"pendrive": [["Antoni", "Nagranie leży w mojej kieszeni. Ania za kierownicą, pan z kamerą. I zeszyt z wpłatami."], ["Antoni", "Na pogrzeb pójdzie pan w kajdankach."]],
	"pendrive_przylapany": [["Wolski", "(sięga do kieszeni marynarki, blednie) Pan... z mojego sejfu..."]],
	"bez_pendrive": [["Antoni", "Pan ją szantażował. Wiem o tym."], ["Wolski", "Wie pan? A co pan ma? Słowa przestępczyni? (uśmiecha się) Do zobaczenia na pogrzebie."]],
	"nowicki_wchodzi": "Trzask drzwi. Kroki na widowni. Kogut radiowozu błyska w foyer.",
	"nowicki_ania": [["Nowicki", "Pani Anna Wrzos? Proszę wstać. Pójdzie pani z nami."]],
	"nowicki_wolski": [["Nowicki", "Pan Wolski też. Szantaż i zatajenie wypadku. Proszę ręce do przodu."]],
	"nowicki_slyszal": [["Nowicki", "Wszystko słyszałem z ostatniego rzędu, Antek. Dobra robota."]],
	"nowicki_wezwany": [["Nowicki", "Zadzwoniłeś, to jestem. Mów, kogo mam zabrać."]],
}

# Zakończenia. Każde: lista ekranów (napisy), potem epilog i KONIEC.
## Scenki zakończeń (sceny/zakonczenia/film_a..d), przed ekranem z epilogiem.
const FILMY_KONCA := {
	"A": {
		"plansza": "Cmentarz, piątek 12:00",
		"policja": "Policja zabrała Anię sprzed teatru. Wolskiego zatrzymano za szantaż i zatajenie wypadku.",
		"halina": [["", "Halina kładzie na grobie chusteczkę wypraną do białości."], ["Halina", "Ta jedna mi się udała."]],
		"antoni": [["Antoni", "Teatr zagrał ostatni akt. Tym razem bez dublerów."]],
		"sam": "Antoni stoi jeszcze długo. Pierwszy raz od soboty nie ma dokąd się spieszyć.",
	},
	"B": {
		"plansza": "Teatr Miejski, miesiąc później",
		"areszt": "Ania czeka na proces w areszcie. Wolski gra nową premierę.",
		"dedykacja": "Ten spektakl dedykuję pamięci Adriana.",
		"usmiech": [["", "Widownia płacze. Wolski kłania się i uśmiecha prosto do Antoniego."]],
		"dziekuje": "(bezgłośnie) Dziękuję.",
		"antoni": [["Antoni", "(cicho) Nagranie gdzieś jest. Kiedyś je znajdę."]],
	},
	"C": {
		"plansza": "Garderoba Ani, piątek wieczorem",
		"areszt": "%s trafia do aresztu. Po tygodniu sprawa zaczyna się sypać.",
		"pogrzeb": "Na pogrzebie Ania obejmowała Antoniego i dziękowała mu ze łzami.",
		"rekawiczki": [["", "Ania odkręca kran przy lustrze i długo płucze gumowe rękawiczki."]],
		"kartka": [["", "Patrzy w lustro. Na kartkę od Adriana: \"Zawsze w ciebie wierzę.\""]],
		"przepraszam": "(szeptem) Przepraszam.",
	},
	"D": {
		"plansza": "Cmentarz, piątek 12:00. Deszcz.",
		"zawal": "Sprawa zostaje zamknięta jako zawał.",
		"kwiaty": [["", "Ania kładzie kwiaty na grobie. Wolski trzyma nad nią parasol i delikatnie ściska jej ramię."]],
		"wolski": "(cicho) Pierwszego, jak zwykle. Podwójnie.",
		"antoni": [["", "Antoni patrzy z daleka. Z notesem pełnym pytań."]],
	},
}

const ZAKONCZENIA := {
	"A": ["Zakończenie: Pełne", [
		"Cmentarz, piątek 12:00.",
		"Policja zabrała Anię sprzed teatru. Wolskiego zatrzymano za szantaż i zatajenie wypadku.",
		"Nad grobem Adriana stoi tylko kilka osób: Marta, Irena, pani Halina, Lis. I Antoni.",
		"Halina kładzie na grobie chusteczkę wypraną do białości.",
		"Halina: \"Ta jedna mi się udała.\"",
		"Antoni: \"Teatr zagrał ostatni akt. Tym razem bez dublerów.\"",
	]],
	"B": ["Zakończenie: Połowiczne", [
		"Teatr Miejski, miesiąc później.",
		"Ania czeka na proces w areszcie.",
		"Wolski gra nową premierę. Dedykuje ją \"pamięci Adriana\". Widownia płacze.",
		"Kłania się. Uśmiecha się prosto do Antoniego, który siedzi w pierwszym rzędzie.",
		"Wolski (bezgłośnie, ruchem ust): \"Dziękuję.\"",
	]],
	"C": ["Zakończenie: Złe", [
		"Komenda, piątek po południu.",
		"%s trafia do aresztu. Po tygodniu sprawa zaczyna się sypać.",
		"Na pogrzebie Ania obejmuje Antoniego i dziękuje mu ze łzami.",
		"Wieczorem, w garderobie, Ania płucze w umywalce gumowe rękawiczki.",
		"Patrzy w lustro, na kartkę od Adriana.",
		"Ania (szeptem): \"Przepraszam.\"",
	]],
	"D": ["Zakończenie: Czas minął", [
		"Cmentarz, piątek 12:00. Deszcz.",
		"Sprawa zostaje zamknięta jako zawał.",
		"Ania kładzie kwiaty na grobie Adriana. Wolski trzyma nad nią parasol i delikatnie ściska jej ramię.",
		"Wolski (cicho, do Ani): \"Pierwszego, jak zwykle. Podwójnie.\"",
		"Antoni patrzy z daleka. Z notesem pełnym pytań.",
	]],
	# dlaczego D (pokazywane przed napisami zakończenia)
	"powod_czas": "Do dziewiątej nikt nie dostał SMS-a.",
	"powod_nikt": "Antoni nikogo nie oskarżył.",
	"powod_wyszla": "Ania wyszła ze sceny. Bez przyznania nie było czego dać Nowickiemu.",
	"powod_alibi": "Oskarżona osoba miała alibi, o którym Antoni sam wiedział.",
	"powod_nikt_nie_zabral": "Nikt nie przyjechał, żeby kogokolwiek zatrzymać.",
	"stracone": "Zmarnowany czas w śledztwie: %d min",
	"koniec": "KONIEC",
	"dziekuje": "Dziękuję za rozgrywkę.\nBuziak dla ciebie!",
}

## Krótkie napisy argumentów na liście w konfrontacji (pełne zdania w SLEDZTWO_ARGUMENTY).
const ARGUMENTY_NAZWY := {
	"skora": "Pasy na skórze", "godzina_smierci": "Godzina śmierci", "czwartek_blady": "Blady na czwartkowej próbie",
	"kostium_wolskiego": "Grał w kostiumie Wolskiego", "klamstwo_czwartek": "Ostatnia rozmowa w czwartek",
	"nic_nie_mowil": "\"Nic nie mówił o kostiumie\"", "kuba_chcial_kostium": "Kuba chciał odebrać kostium",
	"kuba_dubler": "Kuba nowym dublerem", "kuba_alibi": "Kuba: zajęcia w czwartek", "kuba_recytuje": "Kuba zna rolę na pamięć",
	"kuba_pytal": "Kuba pytał w pralni", "kuba_klucz": "Kuba i klucz do pracowni", "wolski_wyrzucic": "Głos: \"wyrzucić kostium\"",
	"pani_bez_kwitu": "Ktoś dzwonił bez kwitu", "wolski_u_ani": "Wolski u Ani w sobotę", "telefon": "Telefon Adriana",
	"plama": "Plama na podszewce", "zapach": "Zapach plamy", "skrzynka_23_40": "Kwit: czwartek 23:40, podpis A.",
	"kuba_odebral": "Kuba odebrał kostium", "podszewka_piekla": "Podszewka piekła", "pasy_szwy": "Pasy wzdłuż szwów",
	"rece_haliny": "Dłonie Haliny", "uv_zielona": "Plama świeci w UV", "sam_dotknal": "Sam dotknąłem podszewki",
	"trucizna": "Wynik z laboratorium", "rece_haliny_alergia": "Halina: \"alergia\"", "wolski_chory": "Wolski zgłosił chorobę",
	"wolski_apteka": "Wolski pod apteką", "wolski_palil": "Wolski spalił przelewy", "wolski_hamlet": "Hamlet, 1998",
	"irena_kradnie": "Irena kradnie materiały", "irena_alibi": "Paragon Ireny", "klucz_ania": "Ania ma klucz do pracowni",
	"lis_polisa": "Polisa na Wolskiego", "lis_wierzyciel": "Wierzyciele Lisa", "lis_alibi": "Lis w banku",
	"ania_sms": "SMS o 22:10", "ania_unika": "Ania uciekła z klatki", "notatka_lodowka": "Notatka na lodówce",
	"sasiadka_kaszel": "Sąsiadka: kaszel w nocy", "kuba_klucz_mieszkanie": "Kuba i klucz do mieszkania",
	"podsluch": "Podsłuch: szantaż", "podsluch_czesc": "Początek podsłuchanej rozmowy", "zeszyt": "Zeszyt z wpłatami",
	"recepta": "Recepta Wolskiego", "pendrive": "Nagranie wypadku", "marta_czwartek": "Marta: czwartek, butelka",
	"marta_bez_dnia": "Marta: ktoś o ósmej", "kuba_casting": "Casting Kuby", "kuba_garnitur": "Kwit Kuby: 23:10",
	"rekawiczki_uv": "Rękawiczki świecą w UV", "przelewy": "Wydruki przelewów", "kartka_adriana": "Kartka od Adriana",
	"pierscionek": "Sygnet na zdjęciu", "farbiarnia": "Ojciec z farbiarni", "pokrowiec": "Sprzątaczka: ktoś z pokrowcem",
	"kuba_widzial": "Kuba: kobieta przy skrzynce", "kartka_wolski": "Kartka \"WOLSKI\" na kostiumie",
	"ania_pytala": "Garderobiana: Ania pytała",
	"halina_lakier": "Halina: plama jak lakier", "skrzynka_noc": "Kostium ze skrzynki nocnej",
	"ciemniejsza": "Plama ciemnieje", "przez_skore": "Trucizna przez skórę",
	"wolski_grypa": "Wolski: \"leżałem z grypą\"", "adrian_u_wolskiego": "Adrian przebierał się u Wolskiego",
	"ania_dzwonila": "Ania zadzwoniła po Wolskiego", "lis_bankrut": "Teatr umiera od dwóch lat",
	"irena_pensja": "Irena bez pensji", "mleko": "Mleko tylko w czwartki",
	"kuba_scenariusz": "Kuba po scenariusz",
	"kwit_bez_karty": "Książka przyjęć: czw. 23:40", "marta_bez_karty": "Marta: czwartek, ósma",
	"rekawiczki_bez_karty": "Rękawiczki świeciły", "przelewy_bez_karty": "Przelewy w szufladzie",
	"sms_bez_karty": "SMS z telefonu Adriana",
	"pismo_ani": "Podpis \"A.\" to pismo Ani", "irena_chemia": "Utrwalacz w szafie Ireny",
}

## Tablica w scenie 21: które argumenty przypinają dobrą odpowiedź.
const TABLICA_JAK := ["trucizna", "uv_zielona", "pasy_szwy", "plama", "skora", "podszewka_piekla", "zapach", "notatka_lodowka", "sam_dotknal", "przez_skore", "halina_lakier"]
const TABLICA_KTO_MIAL := ["kostium_wolskiego", "wolski_chory", "recepta", "podsluch", "wolski_apteka", "kartka_wolski", "ania_pytala", "wolski_grypa", "adrian_u_wolskiego"]


const FALSZYWE_TROPY := ["termos"]

## Argumenty do konfrontacji w finale: id -> [warunki, co mówi Antoni].
## Warunki jak w Sledztwo.jest: "f:flaga", "p:przedmiot", "k:karta dobrze", "w:karta wpisana", "!" odwraca.
const SLEDZTWO_ARGUMENTY := {
	"skora": [["p:zdjecie_pasy"], "Pasy na skórze były tylko tam, gdzie przylegał kostium."],
	"godzina_smierci": [["f:s7_piatek", "f:s7_woda"], "Zmarł w piątek koło jedenastej wieczorem, a nie w sobotę."],
	"czwartek_blady": [["f:s9_bufetowa_czwartek"], "Już w czwartek na próbie był blady i się drapał."],
	"kostium_wolskiego": [["f:s9_obsada"], "Od poniedziałku do czwartku Adrian grał za Wolskiego, w jego kostiumie. W czwartek Wolski miał wrócić."],
	"klamstwo_czwartek": [["f:s8_czwartek"], "Mówiłaś, że ostatni raz rozmawialiście w czwartek rano."],
	"nic_nie_mowil": [["f:s9_ania_kostium"], "Mówiłaś, że Adrian nic nie mówił o kostiumie."],
	"kuba_chcial_kostium": [["f:s9_kuba_prosil"], "Kuba sam się zgłosił, żeby odebrać kostium z pralni."],
	"kuba_dubler": [["f:s9_kuba_dubler"], "Kuba po śmierci Adriana od razu dostał rolę dublera."],
	"kuba_alibi": [["f:s9_kuba_czwartek"], "Kuba twierdzi, że w czwartek rano był na zajęciach."],
	"kuba_recytuje": [["f:s3_kuba"], "Kuba umie na pamięć całą rolę Wolskiego."],
	"kuba_pytal": [["f:s10_kuba_pytal"], "W czwartek Kuba pytał w pralni o kostium z teatru."],
	"kuba_klucz": [["f:s11_kuba_klucz"], "Kuba pożyczał od Adriana klucz do pracowni."],
	"wolski_wyrzucic": [["f:s10_telefon"], "Ktoś z aktorskim głosem pytał, czy kostium można po prostu wyrzucić."],
	"pani_bez_kwitu": [["f:s12_numer"], "Ktoś dzwonił do pralni szeptem, chciał odebrać kostium bez kwitu. Numer: 601 314 220."],
	"wolski_u_ani": [["f:s8_kurs"], "Wolski był u ciebie w sobotę jeszcze przed północą."],
	"telefon": [["p:telefon_adriana"], "Mam telefon Adriana."],
	"plama": [["p:zdjecie_plamy"], "Na podszewce kostiumu Wolskiego jest plama, która nie schodzi w praniu."],
	"zapach": [["f:s10_zapach"], "Plama pachnie tak samo jak koszula Adriana."],
	"skrzynka_23_40": [["k:kwit"], "Kostium wrzucono do skrzynki nocnej w czwartek o 23:40, z podpisem A."],
	"kuba_odebral": [["f:s10_kuba_odebral"], "Kuba odebrał kostium mokry, zanim ktokolwiek przyjrzał się plamie."],
	"podszewka_piekla": [["f:s11_podszewka"], "Na czwartkowej próbie Adrian skarżył się, że podszewka piecze."],
	"pasy_szwy": [["f:s11_szwy"], "Pasy na skórze idą dokładnie tam, gdzie szwy podszewki."],
	"rece_haliny": [["f:s12_rece"], "Halina ma poparzone dłonie od soboty, od kiedy prała ten kostium."],
	"uv_zielona": [["f:s12_uv"], "W świetle UV plama świeci na zielono, wzdłuż szwów podszewki."],
	"sam_dotknal": [["f:s12_dotknal"], "Sam dotknąłem tej podszewki. Piekło jeszcze godzinę."],
	"trucizna": [["f:s13_wynik"], "Laboratorium: trucizna kontaktowa w podszewce, zabija po dobie, dwóch."],
	"rece_haliny_alergia": [["f:s13_rece"], "Halina, która prała ten kostium, ma popękane dłonie. Lekarz mówi: alergia."],
	"wolski_chory": [["f:s14_chory"], "Wolski w czwartek o siódmej rano zgłosił chorobę, a w środę wieczorem był zdrowy."],
	"wolski_apteka": [["f:s14_apteka"], "Pani Stasia widziała Wolskiego w czwartek przed dziesiątą pod apteką. Miał leżeć z gorączką."],
	"wolski_palil": [["f:s14_spalil"], "Wolski spalił przed spektaklem kartki z przelewami i nazwał je recenzjami."],
	"wolski_hamlet": [["f:s14_rok"], "Wolski zadebiutował jako Hamlet w 1998 roku. To dla niego ważna data."],
	"irena_kradnie": [["f:s15_przyznala"], "Irena kradnie materiały z pracowni, bo teatr nie płaci jej od pół roku."],
	"irena_alibi": [["k:paragon"], "Irena w czwartek o 7:15 była w hurtowni na Fabrycznej."],
	"klucz_ania": [["f:s15_klucz_ania"], "Klucz do pracowni ma Irena, Marta i główna obsada. Także Ania."],
	"lis_polisa": [["p:polisa"], "Teatr ubezpieczył Wolskiego na dwa miliony. Uposażony: teatr, który bankrutuje."],
	"lis_wierzyciel": [["f:s16_wierzyciel"], "Lis obiecywał wierzycielom pieniądze z ubezpieczenia."],
	"lis_alibi": [["k:bank"], "Lis w czwartek o 8:05 był w banku."],
	"ania_sms": [["k:sms"], "W czwartek o 22:10 Adrian napisał do ciebie, że kostium go parzy. Odczytałaś to."],
	"ania_unika": [["f:s17_ania_sms"], "Kiedy powiedziałem ci o SMS-ie, uciekłaś z klatki."],
	"notatka_lodowka": [["f:s17_notatka"], "Na lodówce Adriana: \"od próby wszystko piecze, kupić maść\"."],
	"sasiadka_kaszel": [["f:s17_sasiadka"], "Sąsiadka słyszała w czwartek w nocy, jak Adrian kaszle i płacze. Nikt do niego nie przyszedł."],
	"kuba_klucz_mieszkanie": [["f:s17_kuba"], "Kuba miał klucz do mieszkania Adriana i uciekł na mój widok."],
	"podsluch": [["f:s18_podsluch"], "Słyszałem, jak Wolski szantażuje Anię nagraniem wypadku z rowerzystą."],
	"podsluch_czesc": [["f:s18_podsluch_czesc", "!f:s18_podsluch"], "Słyszałem początek rozmowy Wolskiego z Anią. Mówił do niej czule, jak do kogoś, kto mu coś winien."],
	"zeszyt": [["k:zeszyt"], "Wolski od roku dostaje od ciebie co miesiąc 2000 złotych."],
	"recepta": [["k:recepta"], "Wolski w czwartek rano leżał z gorączką. Był u niego lekarz."],
	"pendrive": [["k:pendrive"], "Mam nagranie wypadku. Za kierownicą siedzisz ty, nagrywał Wolski."],
	"marta_czwartek": [["k:marta_grafik"], "Marta widziała cię w pracowni w czwartek o ósmej. Z butelką w ręku."],
	"marta_bez_dnia": [["f:s19_marta", "!k:marta_grafik"], "Marta widziała cię w pracowni o ósmej rano. Nie pamięta dnia."],
	"kuba_casting": [["k:casting"], "Kuba w czwartek o ósmej był na castingu w Teatrze Nowym."],
	"kuba_garnitur": [["k:garnitur"], "Kuba był przy pralni o 23:10 i podpisał się pełnym nazwiskiem. Kostium wrzucił ktoś inny."],
	"rekawiczki_uv": [["k:rekawiczki"], "Rękawiczki z twojego kosza świecą w UV tak samo jak plama na podszewce."],
	"przelewy": [["k:przelewy"], "W twojej szufladzie leżą wydruki przelewów do Wolskiego."],
	"kartka_adriana": [["f:s20_lustro"], "\"Złamania karku, kochanie. Zawsze w ciebie wierzę.\" Kartka od Adriana na twoim lustrze."],
	"farbiarnia": [["f:s20_tata", "f:s13_wynik"], "Twój ojciec pracował w farbiarni. Laboratorium mówi: trucizna kontaktowa. Takie rzeczy stoją tam na półkach."],
	"pierscionek": [["f:s11_foto", "f:s20_sygnet"], "Na zdjęciu z próby dłoń z sygnetem na ramieniu Adriana. Rekwizytowy jest z mosiądzu. Ten był złoty, jak twój ze szkatułki: \"A. 14.03\"."],
	"pokrowiec": [["f:s11b_pokrowiec"], "W czwartek koło jedenastej w nocy ktoś drobny w kapturze wyniósł z teatru pokrowiec na kostium. Pachniało za nim drogimi perfumami."],
	"kuba_widzial": [["f:s11b_kuba_widzial"], "Kuba czekał na autobus naprzeciwko pralni. O 23:40 ktoś drobny w kapturze wcisnął do skrzynki coś dużego, zawiniętego."],
	"kartka_wolski": [["f:s11b_wieszak"], "W czwartek za kwadrans ósma kostium wisiał w pustej pracowni z kartką \"WOLSKI, próba czw.\"."],
	"ania_pytala": [["f:s11b_ania_pytala"], "W środę wieczorem pytałaś garderobianą, w którym kostiumie Wolski gra na próbie i kiedy idzie do pracowni."],
	"halina_lakier": [["f:s10_plama_halina"], "Halina pierze od trzydziestu lat. Ta plama błyszczy się jak lakier i nie schodzi ani w odplamiaczu, ani we wrzątku."],
	"skrzynka_noc": [["f:s10_skrzynka", "!k:kwit"], "Kostium ktoś wrzucił w nocy do skrzynki. Na kartce tylko \"kostium, teatr, A.\""],
	"ciemniejsza": [["f:s12_ciemniejsza"], "Po każdym praniu plama robi się ciemniejsza, zamiast schodzić."],
	"przez_skore": [["f:s13_przez_skore"], "Laborant mówi, że ta trucizna wsiąka przez skórę. Człowiek nic nie czuje, a po dobie, dwóch już po nim."],
	"wolski_grypa": [["f:s14_wolski_czwartek"], "Wolski sam mówi, że w czwartek rano leżał z grypą. Dlatego Adrian grał w jego kostiumie."],
	"adrian_u_wolskiego": [["f:s14_adrian_tu"], "Adrian codziennie przebierał się w garderobie Wolskiego, kiedy grał za niego."],
	"ania_dzwonila": [["f:s8_wolski_ania_dzwonila"], "W sobotę w nocy zadzwoniłaś po Wolskiego, nie po policję ani po lekarza."],
	"lis_bankrut": [["f:s16_bankrut"], "Teatr umiera od dwóch lat. Lis sam to przyznał."],
	"irena_pensja": [["f:s15_pensja"], "Teatr nie płaci Irenie od pół roku. Złość miała, ale na Lisa, nie na Adriana."],
	"mleko": [["f:s19_mleko"], "Mleko przychodzi do teatru tylko w czwartki. Skrzynki stoją pod drzwiami do kulis, a w nich puste butelki."],
	"kuba_scenariusz": [["f:s19_kuba_scenariusz"], "Kuba był w mieszkaniu Adriana po scenariusz z notatkami. Uczył się roli, nie zacierał śladów."],
	"kwit_bez_karty": [["f:s10_ksiazka", "!k:kwit"], "W książce przyjęć pralni: kostium wrzucony do skrzynki w czwartek o 23:40, podpis A."],
	"marta_bez_karty": [["f:s19_czwartek", "!k:marta_grafik"], "Marta mówi, że to był czwartek, ósma rano. Widziała cię w pracowni."],
	"rekawiczki_bez_karty": [["f:s20_uv", "!k:rekawiczki"], "Rękawiczki z twojego kosza świeciły w UV. Widziałem to na własne oczy."],
	"przelewy_bez_karty": [["f:s20_przelewy", "!k:przelewy"], "Widziałem w twojej szufladzie wydruki przelewów do Wolskiego."],
	"pismo_ani": [["k:podpis"], "Podpis \"A.\" na kwicie z pralni to twoje pismo. Ta sama pętelka, ta sama kreska co na kartce \"Przepraszam. Kocham. A.\" u Adriana."],
	"irena_chemia": [["f:s15_utrwalacz", "!f:s15_utrwalacz_prawda"], "Irena trzyma w zamkniętej szafie żrący utrwalacz. Kiedy o niego zapytałem, wyrzuciła mnie z pracowni."],
	"sms_bez_karty": [["f:s17_sms", "!k:sms"], "Czytałem telefon Adriana. W czwartek wieczorem pisał do ciebie, że kostium go parzy."],
}

## Epilog: [warunki, zdanie gdy spełnione, zdanie gdy nie ("" = nic)].
const SLEDZTWO_EPILOG := [
	[["p:kielich"], "Czwarty kielich wrócił na scenę. Lis mówił, że bez niego drugi akt by się nie skleił.", "Czwarty kielich został pod skrzynią w magazynie. Nikt go już nie szukał."],
	[["f:s7_woda"], "Sprzedawca z kiosku do dziś opowiada, że to on ostatni widział Adriana żywego.", ""],
	[["f:s8_kurs"], "Taksówkarz z Mokotowa zeznawał w sądzie. Pamiętał każdą godzinę.", ""],
	[["f:s8_telefon_wolski"], "Telefon Adriana nigdy nie trafił do rodziny. Wolski twierdził, że go zgubił.", ""],
	[["f:s9_kwit_kuba"], "Kuba odebrał kostium z pralni za wcześnie. Część plamy spłynęła z wodą.", ""],
	[["f:s12_dotknal"], "Antoni jeszcze przez tydzień czuł pieczenie w palcach.", ""],
	[["f:s13_dom"], "Ola do dziś wypomina, że zupa była dla niej, nie dla detektywa.", ""],
	[["f:s11b_klucze"], "Sprzątaczka z teatru mówi Antoniemu \"dzień dobry\". Jako jedynemu.", ""],
	[["f:s11b_kuba_widzial"], "Kuba zeznawał w sądzie o kobiecie w kapturze. Na casting do Teatru Nowego się dostał.", ""],
	[["f:s11b_ania_pytala"], "Garderobiana Wolskiego odeszła z teatru po sezonie. Mówi, że już nikomu nie powie, co kto nosi.", ""],
	[["f:taksowki"], "Taksówkarze z postoju pod teatrem do dziś machają Antoniemu na powitanie.", ""],
	[["f:s11_opaska"], "Antoni nosił czarną opaskę Ireny aż do pogrzebu.", ""],
	[["f:s14_ostrzezony"], "Wolski od tamtego wieczoru nie założył żadnego kostiumu, zanim garderobiana go nie wyprała.", ""],
	[["f:s14_peruka"], "Garderobiana Wolskiego co premierę przysyła Antoniemu kartkę z podziękowaniem.", ""],
	[["f:s15_przyznala"], "Irena oddała teatrowi bele jedwabiu. Lis udał, że nic nie wie.", ""],
	[["f:s17_kran"], "Kran w mieszkaniu Adriana kapał jeszcze miesiąc, aż właściciel wymienił uszczelkę.", ""],
	[["f:s17_ladowarka_sasiadki"], "Sąsiadka z jedenastki do dziś czeka na swoją ładowarkę.", ""],
	[["f:s18_przylapany"], "Wolski do końca sezonu zamykał garderobę na dwa zamki.", ""],
	[["f:s18_telefon"], "Telefon Adriana wrócił do jego matki. Z sejfu Wolskiego.", ""],
	[["f:s19_kawa"], "Bufetowa od tamtej pory każdemu policjantowi nalewa kawę z mlekiem. Nawet w poniedziałki.", ""],
	[["f:s20_przylapany"], "Ania do pogrzebu nie odezwała się do Antoniego ani słowem.", ""],
	[["f:obiad_sr", "f:obiad_czw"], "Ola mówi, że w tamtym tygodniu Antoni pierwszy raz od lat jadł u niej dwa dni z rzędu.", ""],
	[["f:s11_podszewka"], "Irena od tamtej pory wszywa podszewki tylko w rękawiczkach.", ""],
	[["f:s21_nowicki"], "Nowicki od tamtej pory dzwoni do Antoniego, zanim zamknie jakąkolwiek sprawę jako zawał.", "Nowicki dowiedział się wszystkiego z gazet."],
	[["f:s22_kartka"], "Kartkę od Adriana Antoni oddał jego matce. Powiesiła ją nad łóżkiem syna.", ""],
	[["f:s2_torba_kuby"], "Kuba do dziś nosi nóż z inicjałami J.A. Mówi, że na szczęście.", ""],
	[["f:s4_kuba_wyszedl"], "Kuba przyznał w końcu, że po toaście wyszedł zapalić. Pierwszy raz w życiu.", ""],
	[["f:s9_ania"], "Kanapa w gabinecie Lisa stoi tam, gdzie stała. Nikt już na niej nie siada.", ""],
	[["f:s11_nozyczki"], "Irena odzyskała swoje nożyczki dopiero po procesie. Z numerem dowodu rzeczowego.", ""],
	[["f:s13_nozyczki_haliny"], "Halina dostała nowe nożyczki od teatru. Lis przysłał je z kartką \"za straty\".", ""],
	[["f:s12_kuba_oddal"], "Kuba długo nie mógł sobie darować, że odebrał ten kostium.", ""],
	[["f:s12_lampa"], "Halina oddała lampę UV na przegląd. Mówi, że teraz każdą plamę ogląda dwa razy.", ""],
	[["f:s13_zgoda"], "Halina oprawiła w ramkę kwit za wycięty kawałek podszewki.", ""],
	[["f:s14_plakat"], "Plakat Hamleta z 1998 roku zniknął z garderoby Wolskiego. Nikt nie wie, kiedy.", ""],
	[["f:s14_sejf"], "Sejf Wolskiego otwierała potem policja. Szyfru nie zmienił.", ""],
	[["f:s14_polisa", "f:s16_polisa"], "Ubezpieczyciel nie wypłacił teatrowi ani grosza. Wolski żyje.", ""],
	[["f:s16_bankrut"], "Teatr przetrwał jeszcze jeden sezon. Na \"Ostatni akt\" przychodziły tłumy.", ""],
	[["f:s15_klamala"], "Irena przeprosiła Antoniego za kłamstwo. Przy Lisie, żeby słyszał.", ""],
	[["f:s15_alibi"], "Paragon z hurtowni Irena trzyma w portfelu. Na wszelki wypadek.", ""],
	[["f:s17_zdjecie"], "Pani Stasia z czwartego rzędu przychodzi na każdy spektakl. Siada obok pustego miejsca.", ""],
	[["f:s17_kuba_klucz"], "Klucz do mieszkania Adriana Kuba oddał jego matce. Razem ze scenariuszem.", ""],
	[["f:s19_casting"], "Na castingu w Teatrze Nowym Kubę zapamiętali jako tego, który przyszedł o ósmej rano.", ""],
	[["f:s19_garnitur"], "Kuba odebrał w końcu swój garnitur z pralni. Halina dała mu go za darmo.", ""],
	[["f:s20_uv"], "Rękawiczki z kosza Ani trafiły do laboratorium. Laborant nie był zdziwiony.", ""],
	[["f:s22_przyznala"], "Ania przyznała się przed sądem do wszystkiego. Do potrącenia też.", ""],
	[["f:s15_utrwalacz", "!f:s15_utrwalacz_prawda"], "Antoni długo podejrzewał Irenę o ten utrwalacz. Farbowała nim kradziony jedwab, nic więcej.", ""],
	[["f:s15_utrwalacz_prawda"], "Irena wylała utrwalacz do zlewu jeszcze tego samego dnia. Okno w pracowni stało otwarte do wieczora.", ""],
	[["k:podpis"], "Kwit z podpisem \"A.\" trafił do akt sprawy. Biegły od pisma potwierdził to, co Antoni zobaczył sam.", ""],
	[["f:s11_foto_irena"], "Zdjęcie z próby generalnej Irena zdjęła ze ściany. Trzyma je w szufladzie, odwrócone.", ""],
	[["f:s11b_wieszak"], "Maszynista z kulis od tamtej pory zagląda do pracowni co rano. Tak na wszelki wypadek.", ""],
]

# Retrospekcja 1 (po scenie 7): piątek w magazynie, tak jak to sobie wyobraża Antoni.
const RETRO1 := {
	"tytul": "Piątek, 21:00. Tak mogło być.",
	"zenon": "Tylko nie siedź do rana!",
	"skora": "Pali... wszystko mnie pali...",
	"lista": "nie dam rady...",
	"woda": "Wody... muszę się napić.",
	"termos": "(pije herbatę z termosu)",
	"kielichy": "Kielichy złote... cztery.",
	"kielich_upada": "Zostaw... potem...",
	"siada": "Tylko chwilę posiedzę.",
	"koniec": "Tak mogło być. Na pewno?",
}


# ---------- PODPOWIEDZI ----------
# Gdy gracz przez ScenaGry.PODPOWIEDZ_PO sekund niczego nowego nie znajdzie ani się
# nie dowie, Antoni myśli na głos: pierwsza podpowiedź, której jeszcze nie załatwił.
# Klucz = nazwa pliku sceny. Wpis: [warunki "załatwione" (wystarczy jeden), myśl].
# Warunki jak w Sledztwo.jest. "f:_" = nigdy załatwione (ostatnia rada w scenie).
# Podpowiedź mówi, gdzie iść albo czego szukać, nigdy nie zdradza odpowiedzi.
const PODPOWIEDZI := {
	"scena1": [
		[["f:s1_bez_biletu", "p:numerek", "p:bilet"], "Toaleta nieczynna. Zapytam kogoś z obsługi. Bileterka stoi przy wejściu na widownię."],
		[["p:numerek", "p:bilet"], "Szatniarz bez numerka nic nie wyda. Gdzie mogłem go upuścić? Stałem przy stojaku z programami..."],
		[["p:bilet"], "Mam numerek. Do szatni: w płaszczu powinien być bilet."],
		[["f:_"], "Z biletem wracam do bileterki. Ona coś wie o toalecie."],
	],
	"scena2": [
		[["p:klucz", "p:noz", "f:s2_oddal"], "Marta szuka noża. Stół i skrzynie z rekwizytami... a na ścianie skrzynka z bezpiecznikami."],
		[["p:noz", "f:s2_oddal"], "Mam klucz do garderób. Nóż mógł trafić do czyjejś torby."],
		[["f:s2_oddal"], "Mam nóż. Trzeba go oddać Marcie."],
		[["f:_"], "Drzwi z napisem WIDOWNIA. Spektakl zaraz się zacznie."],
	],
	"garderoba": [
		[["p:noz", "f:s2_oddal"], "Torby aktorów pod ścianą. Któraś z inicjałami?"],
	],
	"scena6": [
		[["p:latarka"], "Ciemno jak w grobie. Przy bramie stała skrzynka z rekwizytami, może jest tam coś do świecenia."],
		[["p:zdjecie_pasy"], "Z latarką (Tab) obejrzę ciało jeszcze raz. Dokładnie."],
		[["p:telefon_adriana"], "Adrian musiał mieć telefon. Gdzie? Między tymi manekinami?"],
		[["p:lista_rekwizytow"], "Po co Adrian tu w ogóle przyszedł? Może zostawił jakąś kartkę."],
		[["f:_"], "Kiedy skończę, powiem Nowickiemu."],
	],
	"scena10": [
		[["f:s10_kostium", "f:s10_kuba_odebral"], "Na kwicie jest numer: 0412. Sam przejrzę stojaki, Halina go nie znajdzie."],
		[["p:zdjecie_plamy", "f:s10_kuba_odebral"], "Kostium trzeba położyć pod lampą i dobrze mu się przyjrzeć. Zrobię zdjęcie."],
		[["f:s10_ksiazka"], "Kto oddał ten kostium? Halina zapisuje wszystko w książce przyjęć."],
		[["f:_"], "Na dziś starczy. Wyjście jest przy ladzie."],
	],
	"scena11b": [
		[["f:s11b_klucze", "p:klucze_schowka"], "Sprzątaczka nie odezwie się, dopóki nie ma kluczy. Mówiła coś o skrzyniach."],
		[["f:s11b_klucze"], "Mam jej klucze. Oddam je i zapytam o czwartek."],
		[["f:s11b_ania_pytala"], "Garderobiana kłamie, widać po niej. Może zmięknie, jak zobaczy, co ten kostium zrobił?"],
		[["f:s11b_wieszak"], "Maszynista kręci się tu od świtu. Zapytam go o czwartek rano."],
	],
	"scena12": [
		[["p:lampa_uv"], "Halina coś trzyma w szafce pod ladą. Zajrzę, kiedy zajmie się klientem."],
		[["f:s12_uv"], "Mam lampę UV. Poświecę nią na podszewkę."],
		[["f:s12_numer"], "Kto dzwonił w sprawie kostiumu? Halina mogła zapisać numer przy książce."],
	],
	"scena13": [
		[["p:woreczek", "p:probka", "f:s13_oddana"], "Laboratorium nie przyjmie próbki luzem. W aucie, w schowku, wożę woreczki na dowody."],
		[["p:probka", "f:s13_oddana"], "Trzeba wyciąć kawałek podszewki. Czym? Irena miała ostre nożyczki."],
		[["f:s13_oddana"], "Próbkę trzeba zawieźć do laboratorium. Mam w aucie plan miasta."],
	],
	"scena15": [
		[["f:s15_zapalila", "f:s15_przyznala"], "Irena jest kłębkiem nerwów. Może zapali, jak ją poczęstuję?"],
		[["f:s15_bele", "f:s15_przyznala"], "Klucze leżą przy maszynie. Kiedy Irena wyjdzie odebrać telefon, zajrzę do szafy."],
		[["f:s15_spis", "f:s15_przyznala"], "Na regale leży spis tkanin. Ciekawe, czy zgadza się z tym, co jest w szafie."],
		[["f:s15_przyznala"], "Mam bele i spis. Pokażę je Irenie."],
		[["p:paragon"], "Irena mówiła o hurtowni. Rachunki trzyma gdzieś przy stole."],
	],
	"scena17": [
		[["p:klucz_adriana", "f:s17_wszedl"], "Ania ma klucz, ale go nie odda ot tak. Zapytam ją jeszcze raz o ten czwartek."],
		[["p:ladowarka", "f:s17_sms"], "Telefon Adriana jest rozładowany. Potrzebuję ładowarki. Może sąsiedzi pożyczą?"],
		[["f:s17_laduje", "f:s17_sms"], "Mam ładowarkę. W pokoju jest gniazdko."],
		[["f:s17_sms"], "PIN. Ludzie ustawiają daty, które coś dla nich znaczą. Przyjrzę się zdjęciom w mieszkaniu."],
	],
	"scena18": [
		[["f:s18_zeszyt"], "Szuflada w toaletce. Wolski coś tam chowa."],
		[["f:s18_recepta"], "Kosz. Ludzie wyrzucają rzeczy, które ich zdradzają."],
		[["f:s18_sejf"], "Sejf. Szyfr to pewnie rok ważny dla Wolskiego. Plakaty na ścianie, program premiery..."],
	],
	"scena19": [
		[["f:s19_marta"], "Marta bywa w teatrze od świtu. Zapytam ją, kogo widuje rano w pracowni."],
		[["p:grafik", "f:s19_czwartek"], "Marta potknęła się o skrzynki. Stoją pod drzwiami PERSONEL, zajrzę do nich."],
		[["f:s19_czwartek"], "Mam grafik dostaw. Pokażę go Marcie, może przypomni sobie dzień."],
		[["f:s19_kuba_otwarty"], "Kuba coś ukrywa. Może kwit z pralni rozwiąże mu język?"],
	],
	"scena20": [
		[["f:s20_kosz"], "Kosz pod toaletką. Ania coś wyrzuciła?"],
		[["p:spinka", "f:s20_przelewy"], "Szuflada jest zamknięta. Czymś cienkim dałoby się ją otworzyć. Pudełko z charakteryzacją?"],
		[["f:s20_przelewy"], "Mam spinkę. Teraz szuflada."],
	],
	"scena21": [
		[["f:s21_jak", "f:s21_kto_mial"], "Tablica. Najpierw dwa pytania: jak zginął i kto miał zginąć."],
		[["f:_"], "Telefon na stole. Komu wyślę SMS-a?"],
	],
}

## Gdy w teczce są karty, których gracz nie uzupełnił (po podpowiedziach sceny).
## Napis w rogu ekranu, gdy przybędzie argumentów do finału albo kart w teczce.
const NOWY_TROP := "Nowy trop"

## Wieczorne podsumowanie dnia w telefonie (Gra._podsumuj_dzien).
const DZIENNIK := {
	"kontakt": "Dziennik",
	"komunikat": "Nowy dzień. Podsumowanie wczorajszego w telefonie (Q).",
	"naglowek": "%s, wieczorem.",
	"miejsca": "Byłem: %s.",
	"kasa": "Wydałem %d zł, zostało %d zł.",
	"czas": "Stracony czas: %d min.",
	"tropy": "Nowe tropy: %d.",
	"pytania": "Wciąż nie wiem:",
}

## Otwarte pytania w dzienniku: [kiedy się pojawia (wszystkie), co je zamyka (wystarczy jedno), pytanie].
## Pytanie bez odpowiedzi, nigdy podpowiedź, gdzie jej szukać.
const DZIENNIK_PYTANIA := [
	[[], ["f:s13_wynik"], "Na co naprawdę umarł Adrian?"],
	[["f:s10_ksiazka"], ["w:podpis"], "Czyje pismo jest na kwicie z pralni?"],
	[["f:s10_ksiazka"], ["f:s11b_kuba_widzial", "f:s11b_pokrowiec", "w:podpis"], "Kto wrzucił kostium do skrzynki w czwartek w nocy?"],
	[["f:s9_obsada"], ["f:s14_ostrzezony", "f:s14_teoria"], "Czyj to był naprawdę kostium? Kto miał w nim zginąć?"],
	[["f:s15_utrwalacz"], ["f:s15_utrwalacz_prawda"], "Po co Irenie żrący utrwalacz?"],
	[["f:s14_spalil"], ["f:s18_podsluch", "w:zeszyt"], "Co Wolski spalił przed spektaklem i dlaczego?"],
	[["f:s11b_wieszak"], ["w:marta_grafik"], "Kto był w pracowni w czwartek rano?"],
	[["f:s17_kuba"], ["f:s19_kuba_scenariusz"], "Czego Kuba szukał w mieszkaniu Adriana?"],
	[["f:s17_ania_sms"], ["f:s22_przyznala"], "Dlaczego Ania uciekła z klatki?"],
]

const PODPOWIEDZ_TECZKA := "W teczce (F) mam karty bez wpisów. Bez nich nic nie udowodnię."


# ---------- TECZKA DOWODÓW ----------
# Karty dokłada gra (Teczka.dodaj("paragon")), gdy gracz zdobędzie dowód albo usłyszy
# ważne zeznanie. Gracz sam wypełnia rubryki. Gra porównuje wpis bez wielkości liter,
# polskich znaków, spacji i dwukropków, z każdą z dopuszczalnych odpowiedzi.
# id: [nazwa, gdzie znaleziony, opis faktu, [[rubryka, [dobre odpowiedzi]], ...]]

const KARTY := {
	"podpis": ["Podpis \"A.\" z kwitu", "Pralnia", "Duże A wywinięte w pętelkę, pod spodem kreska. Kto tak pisze?",
		[["Czyje pismo", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]]]],
	"paragon": ["Paragon z hurtowni", "Pracownia kostiumów", "Zakup tkanin, czwartek 7:15.",
		[["Kogo dotyczy", ["irena", "mroz", "irena mroz"]]]],
	"bank": ["Potwierdzenie z banku", "Biuro dyrektora", "Wizyta w banku, czwartek 8:05.",
		[["Kogo dotyczy", ["lis", "bogdan", "bogdan lis", "dyrektor", "dyrektor lis"]]]],
	"kwit": ["Kwit z pralni", "Pralnia", "Kostium oddany do skrzynki nocnej, podpis \"A.\".",
		[["Kiedy", ["czwartek 23:40", "czwartek 2340", "czw 23:40", "czw 2340"]]]],
	"sms": ["SMS z telefonu Adriana", "Telefon Adriana", "\"Ten kostium mnie parzy...\" Wiadomość odczytana.",
		[["Do kogo", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]], ["Kiedy", ["czwartek 22:10", "czwartek 2210", "czw 22:10", "czw 2210"]]]],
	"marta_grafik": ["Zeznanie Marty i grafik dostaw", "Teatr, korytarz przy bufecie", "Ktoś był w pracowni o 8:00, w dniu dostawy mleka.",
		[["Kogo dotyczy", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]], ["Kiedy", ["czwartek", "czw"]]]],
	"rekawiczki": ["Rękawiczki z kosza", "Kosz na śmieci", "W świetle UV świecą tak samo jak plama na kostiumie.",
		[["Czyje", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]]]],
	"podszewka": ["Zeznanie Ireny", "Pracownia kostiumów", "Ktoś skarżył się, że podszewka kostiumu piecze.",
		[["Kto", ["adrian"]], ["Kiedy", ["czwartek", "czw", "na probie", "na próbie", "proba", "próba", "proba generalna", "próba generalna"]]]],
	"recepta": ["Recepta z kosza", "Garderoba Wolskiego", "Wizyta domowa lekarza, czwartek 7:30–9:00. Gorączka 39,2.",
		[["Kogo dotyczy", ["wolski", "adam", "adam wolski"]]]],
	"zeszyt": ["Zeszyt z wpłatami", "Szuflada Wolskiego", "Co miesiąc 2000 zł od roku, od listopada podwójnie.",
		[["Kto płaci", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]], ["Kto bierze", ["wolski", "adam", "adam wolski"]]]],
	"casting": ["Zdjęcie z castingu", "Telefon Kuby", "Chłopak z numerem 14 na piersi, Teatr Nowy, czwartek 8:02.",
		[["Kogo dotyczy", ["kuba", "jakub", "adamczyk", "jakub adamczyk", "kuba adamczyk"]]]],
	"garnitur": ["Kwit na garnitur", "Portfel Kuby", "Garnitur oddany do skrzynki nocnej pralni, pełny podpis.",
		[["Kogo dotyczy", ["kuba", "jakub", "adamczyk", "jakub adamczyk", "kuba adamczyk"]], ["Kiedy", ["czwartek 23:10", "czwartek 2310", "czw 23:10", "czw 2310"]]]],
	"przelewy": ["Wydruki przelewów", "Szuflada Ani", "Przelewy co miesiąc, tytuł \"darowizna\", ostatni podwójny.",
		[["Kto płaci", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]], ["Komu", ["wolski", "adam", "adam wolski"]]]],
	"pendrive": ["Pendrive z sejfu", "Sejf Wolskiego", "Nagranie wypadku sprzed roku.",
		[["Kto prowadził", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]], ["Kto nagrywał", ["wolski", "adam", "adam wolski"]]]],
}

const TECZKA_NAPISY := {
	"pusta": "Teczka jest pusta. Karty pojawią się, gdy zdobędziesz dowody.",
	"wpisane": "WPISANE",
	"zatwierdz": "Zatwierdź",
	"puste": "Najpierw wypełnij wszystkie rubryki.",
	"nie_znam": "Nie znam nikogo takiego. Wpisz imię kogoś, kogo spotkałeś.",
	"nie_czas": "Tu trzeba wpisać dzień i godzinę.",
	"epilog_zla": "Karta \"%s\": wpisałeś \"%s\". To był błąd.",
	"pomoc": "F albo Esc – zamknij   1 karty   2 podejrzani",
	"tablica": "Kliknij osobę, żeby ją skreślić albo przywrócić.",
}

## Imiona, które teczka przyjmuje oprócz podejrzanych (PODEJRZANI_ALIASY).
const TECZKA_IMIONA := ["adrian", "antoni", "ola", "nowicki", "zawada", "stasia", "zenon", "lekarz", "fotograf", "kelnerka", "bufetowa", "szatniarz", "garderobiana", "sprzataczka", "maszynista", "policjant"]

## Podejrzani na tablicy: [imię na tablicy, folder postaci].
## Główni podejrzani: dwie kobiety i dwóch mężczyzn (Jonasz, 26.10). Pozostali (Lis,
## Marta, Halina) mają swoje tropy, ale nie stoją na tablicy.
const PODEJRZANI := [
	["Ania", "ania"], ["Irena", "irena"], ["Wolski", "wolski"], ["Kuba", "gosc_student"],
]

## Foldery postaci dla każdego imienia, które da się wpisać w sylwetkę.
const FOLDERY_POSTACI := {
	"Ania": "ania", "Irena": "irena", "Wolski": "wolski", "Kuba": "gosc_student",
	"Lis": "bogdan", "Marta": "marta", "Halina": "halina",
}


# ---------- ZAMKNIĘTE DRZWI ----------
# Napis, który pojawia się, gdy Antoni podejdzie do drzwi, którymi nie da się przejść.
# Trzymaj je krótkie, żeby mieściły się w jednej linijce.

const DRZWI := {
	"foyer_widownia": "Zamknięte. Widownię otwierają tuż przed spektaklem.",
	"foyer_wyjscie": "Nie wyjdę teraz. Ola by mnie zabiła.",
	"foyer_toalety": "AWARIA. NIECZYNNE. Przepraszamy.",
	"foyer_personel": "PERSONEL. Nie mam tam czego szukać. Na razie.",
	"foyer_personel_2": "Najpierw bilet. Bez niego i tak nie wejdę na spektakl.",
	"kulisy_wyjscie": "Zaraz wracam. Najpierw sprawdzę, kto się tak drze.",
	"kulisy_wyjscie_2": "Najpierw ten nóż. Marta by mnie zabiła.",
	"kulisy_dol": "Tędy przyszedłem. Nie ma czasu, zaraz trzeci dzwonek.",
	"kulisy_garderoby": "Zamknięte na klucz. Na drzwiach kartki z nazwiskami aktorów.",
	"kulisy_podworze": "Podwórze. Leje jak z cebra.",
	"antrakt_widownia": "Jeszcze nie. Drugi akt po dzwonku.",
	"antrakt_wyjscie": "Wyjść w antrakcie? Ola by mi tego nie darowała.",
	"antrakt_toalety": "Wciąż nieczynne. Kartka nawet się nie przekrzywiła.",
	"antrakt_personel": "Za kulisy w czasie spektaklu? Lepiej nie.",
	"bankiet_widownia": "Widownia już zamknięta. Spektakl się skończył.",
	"bankiet_wyjscie": "Jeszcze nie wychodzę. Najpierw posłucham, co ludzie mówią.",
	"bankiet_personel": "Za kulisy już nie wejdę. Marta by mnie zabiła.",
	"bankiet_toalety": "Nadal awaria. Teatr na premierę, a toaleta jak w pociągu.",
	"magazyn_brama": "Nie wyjdę, dopóki Nowicki nie skończy. Mam swój kwadrans.",
}


# ---------- NOTES ----------
# Gra sama niczego nie zapisuje w notesie, gracz notuje wszystko sam.

const NOTES := {
	# karteczka nad notesem przy pierwszym otwarciu (scena 1, po rozmowie Ani)
	"samouczek": "To Twój notes. Gra nic tu nie zapisze za Ciebie, więc notuj wszystko, co ważne. Później trzeba to będzie pamiętać.\n\nWpisz, co usłyszałeś od Ani.\n\nEsc zamyka, T otwiera.",
}


# ---------- PRZEDMIOTY ----------
# Nazwa w cudzysłowie przed dwukropkiem to identyfikator (i nazwa ikonki w ui/przedmioty/).
# [nazwa w grze, opis, rodzaj, nieużywane]
# rodzaj: "fabularny" (trop, nie znika), "picie" (E wypija: kawa), "inny".

const PRZEDMIOTY := {
	# fabularne (ze scenariusza; w nawiasie gdzie leżą i w której scenie)
	"program": ["Program premiery", "Biografia Wolskiego: zadebiutował w 1998 roku jako Hamlet. Na okładce jego zdjęcie.", "fabularny", 0],  # stojak w foyer, sc. 1
	"bilet": ["Bilet", "Premiera \"Ostatniego aktu\", rząd 3, miejsce 14. Prezent od Oli.", "fabularny", 0],  # kieszeń płaszcza w szatni, sc. 1
	"numerek": ["Numerek z szatni", "Mosiężny numerek 47. Bez niego szatniarz nie wyda płaszcza.", "fabularny", 0],  # pod stojakiem z programami, sc. 1
	"noz": ["Rekwizytowy nóż", "Nóż z finału spektaklu. Ostrze chowa się w rękojeść. Leżał w torbie statysty \"J.A.\".", "fabularny", 0],  # torba Kuby w garderobie, sc. 2
	"klucz": ["Zapasowy klucz", "Klucz z zawieszką \"PRACOWNIA / GARDEROBY\". Otwiera drzwi także po godzinach.", "fabularny", 0],  # bezpieczniki w kulisach, sc. 2
	"latarka": ["Latarka", "Stara, ciężka, ale świeci jak trzeba.", "fabularny", 0],  # skrzynka z rekwizytami w magazynie, sc. 6
	"ladowarka": ["Ładowarka", "Ładowarka do telefonu. Pasuje do starszych modeli.", "fabularny", 0],  # szuflada w budce stróża, sc. 7
	"rekawiczki": ["Lateksowe rękawiczki", "Chronią dłonie. Przy podejrzanych plamach lepiej ich nie zdejmować.", "fabularny", 0],  # apteczka w bufecie, sc. 9
	"lampa_uv": ["Lampa UV", "W jej świetle niektóre plamy świecą.", "fabularny", 0],  # szafka pod ladą w pralni, sc. 12
	"nozyczki": ["Nożyczki krawieckie", "Ostre jak brzytwa. Irena by mnie za nie zabiła.", "fabularny", 0],  # kosz z przyborami w pracowni, sc. 11
	"woreczek": ["Woreczek na dowody", "Strunowy woreczek z komendy. Bez niego laboratorium nic nie przyjmie.", "fabularny", 0],  # schowek w samochodzie, sc. 13
	"paragon": ["Paragon z hurtowni", "Hurtownia tkanin \"Atlas\", czwartek 7:15. Na nazwisko Ireny.", "fabularny", 0],  # skrzynka z materiałami w pracowni, sc. 15
	"grafik": ["Grafik dostaw", "\"Mleczarnia Łąka. Dostawy: CZWARTKI, 7:30\". Była w skrzynce po mleku pod drzwiami PERSONEL.", "fabularny", 0],  # skrzynka na mleko przy bufecie, sc. 19
	"spinka": ["Spinka do włosów", "Wygięta. Da się nią otworzyć prosty zamek.", "fabularny", 0],
	"telefon_adriana": ["Telefon Adriana", "Pęknięta szybka, na etui naklejka z maską. Rozładowany i zablokowany PIN-em.", "fabularny", 0],  # pod manekinem w magazynie, sc. 6
	"termos": ["Termos", "Termos Adriana w kratkę, na zakrętce wydrapane \"A.\". Resztka herbaty z cytryną.", "fabularny", 0],  # na sofie w magazynie, sc. 6
	"kwit_odbioru": ["Kwit z pralni", "\"Pralnia Perła. Odbiór: kostium sceniczny, 1 szt. Nr 0412.\" Leżał pod popielniczką u Lisa.", "fabularny", 0],  # biurko Lisa, sc. 9
	"kielich": ["Złoty kielich", "Czwarty kielich z listy rekwizytów. Leżał pod skrzynią obok ciała, nóżka wgnieciona.", "fabularny", 0],  # pod skrzynią w magazynie, sc. 6
	"lista_rekwizytow": ["Lista rekwizytów", "Lista od dyrektora Lisa. Na dole dopisek Adriana: \"nie dam rady, kręci mi się w głowie\".", "fabularny", 0],  # stolik w salonie, magazyn, sc. 6
	"zdjecie_plamy": ["Zdjęcie plamy", "Podszewka kostiumu Wolskiego. Plama od karku przez ramiona, matowa, w świetle lekko błyszczy.", "fabularny", 0],  # pralnia, sc. 10
	"zdjecie_pasy": ["Zdjęcie: pasy na ramionach", "Zdjęcie z telefonu. Czerwone, równe pasy na ramionach i plecach Adriana.", "fabularny", 0],  # ciało Adriana, sc. 6
	"pendrive": ["Pendrive", "Czarny pendrive z sejfu Wolskiego. Coś na nim jest.", "fabularny", 0],  # sejf w garderobie Wolskiego, sc. 18
	# zwykłe
	"probka": ["Próbka podszewki", "Kawałek podszewki z plamą w woreczku na dowody.", "fabularny", 0],  # wycięta w pralni, sc. 13
	"polisa": ["Polisa na życie", "Ubezpieczony: Adam Wolski. Uposażony: Teatr Miejski. Dwa miliony złotych. Podpis: B. Lis.", "fabularny", 0],  # szuflada Lisa, sc. 16
	"klucz_adriana": ["Klucz do mieszkania Adriana", "Klucz z breloczkiem w kształcie serca. Od Ani.", "fabularny", 0],  # Ania na klatce, sc. 17
	"klucze_schowka": ["Klucze od schowka", "Pęk kluczy z zawieszką \"SCHOWEK\". Ktoś ich szuka.", "fabularny", 0],  # pod skrzynią w kulisach, sc. 11b
	"opaska": ["Czarna opaska", "Uszyła ją Irena. Dla Adriana.", "fabularny", 0],  # stół przy maszynie w pracowni, sc. 11
	"kawa": ["Kawa", "Czarna. Przez chwilę chodzisz szybciej.", "picie", 5],
	"papierosy": ["Papierosy", "Antoni nie pali, ale zestresowani ludzie chętniej gadają przy papierosie.", "inny", 0],
}

# Miejsca do przeszukania (E): [podpowiedź nad miejscem, tekst po przeszukaniu, tekst gdy pusto]
const SKRZYNKI := {
	"stojak_programy": ["Stojak z programami", "Program premiery. Jeden wezmę. A pod stojakiem... numerek z szatni! Czterdzieści siedem. To mój!", "Jeden program wystarczy."],
	"bufet": ["Bufet", "Na ladzie kawa dla widzów premiery. Biorę jedną.", "Więcej nie wezmę, nie wypada."],
	"apteczka_s9": ["Apteczka", "Bandaże, plaster, tabletki. Na dnie paczka lateksowych rękawiczek. Biorę parę.", "Bandaże i plaster."],
	"apteczka": ["Apteczka", "Tabletki, bandaże, plaster. Nic mi nie dolega, zostawiam.", "Bandaże, plaster. Nic więcej mi nie trzeba."],
	"bankiet": ["Stół bankietowy", "Tartinki, pączki i wino. Zjadam jedną tartinkę na stojąco.", "Starczy. Nie chcę wyjść na łakomczucha."],
	"bezpieczniki": ["Bezpieczniki", "Między bezpiecznikami wisi zapasowy klucz z zawieszką \"PRACOWNIA / GARDEROBY\". Ktoś tu dba o wygodę.", "Same bezpieczniki."],
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
