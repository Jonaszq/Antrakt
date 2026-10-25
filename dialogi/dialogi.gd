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
		["Kuba", "Kuba, trzeci rok aktorskiego. Wie pan, kto dziś miał siedzieć w pogotowiu? Adrian, dubler Wolskiego."],
		["Kuba", "Dubler to najgorsza robota świata. Czekasz, aż ktoś zachoruje."],
		["Kuba", "Uczysz się roli na pamięć, a potem siedzisz w garderobie i słuchasz oklasków dla kogoś innego."],
		["Antoni", "Mówisz, jakbyś mu zazdrościł."],
		["Kuba", "Zazdroszczę. Ja się nawet na dublera nie dostałem."],
	],
	"kuba_potem": [
		["Kuba", "Jak Adrian się nie znajdzie, to może mnie wezmą. Żartuję. Chyba."],
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
		["Antoni", "W garderobie Ani. Na toaletce, obok zdjęcia."],
		["Marta", "U Ani? Dziwne. Ona go w ogóle nie dotyka aż do finału."],
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
		["Antoni", "Garderoba Ani. Pachnie pudrem i kwiatami."],
	],
	"toaletka_przed": [
		["", "Toaletka Ani. Lustro w żarówkach, puder, szminka. Obok zdjęcia w ramce leży nóż."],
		["Antoni", "Pewnie jakiś rekwizyt. Nie mój interes."],
	],
	"toaletka": [
		["", "Toaletka Ani. Lustro w żarówkach, puder, szminka."],
		["", "Obok zdjęcia w ramce leży nóż. Rekwizytowy, ostrze chowa się w rękojeść."],
		["", "Na zdjęciu Ania z jakimś chłopakiem. Śmieją się, za nimi morze."],
		["Antoni", "To pewnie Adrian. Tylko co nóż z finału robi u Ani?"],
		["", "Wskazówka: to może się przydać później. Notes masz pod T."],
	],
	"toaletka_potem": [
		["", "Zdjęcie Ani i Adriana nad morzem. Na odwrocie nic nie ma."],
	],
	"kwiaty": [
		["", "Bukiet czerwonych róż. Bilecik: \"Połamania nóg, córeczko. Mama.\""],
	],
	"wieszak": [
		["", "Kostiumy Ani na drążku. Każdy podpisany numerem sceny."],
	],
	"kanapa": [
		["", "Kanapa, na niej kremowy szal Ani. Jeszcze ciepły."],
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
	# Ania wchodzi na scenę, myli kwestię i zamiera
	"akt1_ania": [
		["Wolski", "Nareszcie jesteś. Powiedz mi prawdę, choć raz w życiu."],
		["Ania", "Prawda jest taka, że ty... że ty nie powinieneś..."],
		["", "Ania milknie w pół zdania. Patrzy na kostium Wolskiego, jakby zobaczyła ducha."],
	],
	"akt1_ratunek": [
		["Wolski", "...nie powinienem żyć? Wiem. A jednak stoję przed tobą, moja droga."],
		["Ania", "Tak. A jednak stoisz."],
		["", "Spektakl toczy się dalej. Nikt na widowni niczego nie zauważył. Prawie nikt."],
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
		["", "Ania wchodzi na scenę. Tym razem nie myli ani słowa."],
		["Ania", "Czekałam dwadzieścia lat. Możesz mi wierzyć, że umiem czekać."],
	],
	"final": [
		["", "Finał. Ania podnosi nóż. Ten sam, który leżał na jej toaletce."],
		["", "Światło gaśnie na sekundę. Kiedy wraca, Wolski leży na deskach."],
		["", "Cisza. A potem cała widownia wstaje."],
	],
	"koniec": [
		["", "Burza oklasków. Wolski kłania się trzy razy. Ania tylko raz, i szybko znika za kulisami."],
		["Antoni", "Dobre przedstawienie. Tylko ta jedna pomyłka..."],
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
		["Antoni", "Kawę i kanapkę poproszę."],
		["Bufetowa", "Kawa czarna jak dusza krytyka, proszę bardzo."],
		["Bufetowa", "I kanapka z serem. Dziewięć złotych."],
	],
	"bufet_place": [
		["Antoni", "Proszę. Akurat drobne z płaszcza."],
		["Bufetowa", "Co do grosza! Smacznego."],
		["", "Wskazówka: jedzenie i picie masz w ekwipunku (I). E zjada albo wypija."],
	],
	"bufet_na_kreske": [
		["Antoni", "Mam tylko kartę..."],
		["Bufetowa", "Terminal nie działa od premiery Hamleta. Niech pan bierze, odda pan po spektaklu."],
		["", "Wskazówka: jedzenie i picie masz w ekwipunku (I). E zjada albo wypija."],
	],
	"bufet_potem": [
		["Bufetowa", "Druga kawa po spektaklu. Teraz kolejka."],
	],
	"zawada": [
		["Zawada", "Pierwszy akt: Wolski gra Wolskiego. Bez niespodzianek."],
		["Antoni", "A ta pauza Ani?"],
		["Zawada", "Pauza? Najlepszy moment wieczoru. Pierwszy raz od lat ktoś na tej scenie wyglądał na naprawdę przerażonego."],
		["Zawada", "Zapiszę to sobie: \"Wrzos, strach prawdziwszy niż sztuka.\" Ładne, prawda?"],
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
		["Kuba", "Widział pan, jak Ania zamarła? Na egzaminie by za to oblała."],
		["Kuba", "Adrian by się tak nie zawiesił. Znał ten tekst lepiej niż Wolski. Grał go przecież na próbie generalnej."],
	],
	"kuba_potem": [
		["Kuba", "Ciekawe, czy Adrian w ogóle wie, że premiera się udała."],
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
		["", "Ania szybko chowa telefon do kieszeni kostiumu i ociera oczy."],
		["Ania", "Przepraszam, to nerwy. Premiera."],
		["Antoni", "W pierwszym akcie..."],
		["Ania", "Muszę wracać. Zaraz drugi dzwonek."],
	],
	"po_ani": [
		["Antoni", "Za każdym razem, jak ją spotykam, za coś przeprasza."],
	],
}

const ANTRAKT_TLO := {
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
		["Starszy pan", "Wolski był genialny. A ta mała w pierwszym akcie? Zbladła jak trup."],
	],
	"elegancka_pani": [
		["Elegancka pani", "Gorączka czy nie, zagrał jak bóg. Mówiłam, prawdziwy zawodowiec."],
	],
	"kuba": [
		["Kuba", "Przeżyłem! Wolski zagrał. Mogę umierać spokojnie."],
		["Antoni", "Lepiej nie."],
	],
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
		["", "Antoni płaci drobnymi."],
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
		["Wolski", "Panie Antoni. Dobrze, że pan tu był. I pan Zenon też."],
		["Wolski", "Proszę, herbata z termosu. Gorąca, z sokiem malinowym. Niech pan pije, zimno jak w psiarni."],
		["", "Antoni pije. Herbata parzy w gardło i rozgrzewa. (+10 sił)"],
		["Wolski", "Pan jest dobrym człowiekiem. Teatr ma u pana dług."],
	],
	"wolski_tu": [
		["Antoni", "Skąd pan wiedział, co się stało?"],
		["Wolski", "Ania zadzwoniła. Nie mogłem jej puścić samej, w nocy, w takim stanie."],
	],
	"wolski_adrian": [
		["Antoni", "Dobrze pan znał Adriana?"],
		["Wolski", "To był mój dubler. Zdolny chłopak, za skromny na ten zawód."],
		["Wolski", "Przez cały tydzień grał za mnie. Mówią, że dobrze. Ja leżałem z gorączką."],
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
	"brama": [["", "Brama magazynu zaklejona taśmą. Na kłódce świeża plomba."]],
	"radiowoz": [["", "Na siedzeniu radiowozu leży otwarty notes Nowickiego."], ["", "\"Dubler z teatru. Przyczyna: serce? (lekarz). Zgłosił: stróż.\""]],
	"kaluza": [["", "W kałuży odbija się latarnia. Miga, jakby zaraz miała zgasnąć."]],
	"latarnia": [["", "Latarnia brzęczy i mruga. Ktoś przykleił do niej ogłoszenie: \"Zaginął kot, rudy\"."]],
	"kiosk": [["", "Okienko z pączkami zamknięte na noc. Kartka: \"Zaraz wracam\"."]],
	"auto": [["", "Twoje auto. Nowicki jeszcze tu jest, wypada się pożegnać."]],
	"auto_jedz": [["Antoni", "Na dziś wystarczy."]],
}

const SCENA8_WYBOR := ["Możemy kończyć", "Jeszcze chwilę"]

const SCENA8_DOWODY := {
	"ania": {
		"telefon_adriana": [["", "Ania odwraca wzrok."], ["Ania", "Schowaj to. Proszę."]],
		"zdjecie_pasy": [["", "Ania zakrywa usta dłonią."], ["Ania", "Nie chcę tego oglądać."]],
		"kielich": [["Ania", "Z drugiego aktu. On je zawsze polerował przed spektaklem."]],
		"termos": [["Ania", "To jego. Herbata z cytryną. Zawsze z cytryną."]],
		"lista_rekwizytow": [["", "Ania czyta dopisek na dole. Kartka drży jej w palcach."], ["Ania", "To jego pismo."]],
	},
	"wolski": {
		"telefon_adriana": [["Wolski", "Jego telefon? Niech mi pan go da, przekażę rodzinie. Po co ma pan się z tym nosić."]],
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
	"dalej": "Rozdział 3: Plama. Już wkrótce.",
}

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


# ---------- TECZKA DOWODÓW ----------
# Karty dokłada gra (Teczka.dodaj("paragon")), gdy gracz zdobędzie dowód albo usłyszy
# ważne zeznanie. Gracz sam wypełnia rubryki. Gra porównuje wpis bez wielkości liter,
# polskich znaków, spacji i dwukropków, z każdą z dopuszczalnych odpowiedzi.
# id: [nazwa, gdzie znaleziony, opis faktu, [[rubryka, [dobre odpowiedzi]], ...]]

const KARTY := {
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
	"pendrive": ["Pendrive z sejfu", "Sejf Wolskiego", "Nagranie wypadku sprzed roku.",
		[["Kto prowadził", ["ania", "wrzos", "ania wrzos", "anna", "anna wrzos"]], ["Kto nagrywał", ["wolski", "adam", "adam wolski"]]]],
}

const TECZKA_NAPISY := {
	"pusta": "Teczka jest pusta. Karty pojawią się, gdy zdobędziesz dowody.",
	"zle": "Antoni kręci głową. Coś się nie zgadza.",
	"dobrze": "SPRAWDZONE",
	"pomoc": "F albo Esc – zamknij   1 karty   2 podejrzani",
	"tablica": "Kliknij osobę, żeby ją skreślić albo przywrócić.",
}

## Podejrzani na tablicy: [imię na tablicy, folder postaci].
const PODEJRZANI := [
	["Ania", "ania"], ["Wolski", "wolski"], ["Irena", "irena"],
	["Lis", "bogdan"], ["Marta", "marta"], ["Halina", "halina"],
]


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
# [nazwa w grze, opis, rodzaj, siły]
# rodzaj: "fabularny" (trop, nie znika), "jedzenie" albo "picie" (E zjada/wypija),
# "inny". Siły to ile pasek sił rośnie po zjedzeniu (0 = nic).

const PRZEDMIOTY := {
	# fabularne (ze scenariusza; w nawiasie gdzie leżą i w której scenie)
	"program": ["Program premiery", "Biografia Wolskiego: zadebiutował w 1998 roku jako Hamlet. Na okładce jego zdjęcie.", "fabularny", 0],  # stojak w foyer, sc. 1
	"bilet": ["Bilet", "Premiera \"Ostatniego aktu\", rząd 3, miejsce 14. Prezent od Oli.", "fabularny", 0],  # kieszeń płaszcza w szatni, sc. 1
	"numerek": ["Numerek z szatni", "Mosiężny numerek 47. Bez niego szatniarz nie wyda płaszcza.", "fabularny", 0],  # pod stojakiem z programami, sc. 1
	"noz": ["Rekwizytowy nóż", "Nóż z finału spektaklu. Ostrze chowa się w rękojeść. Leżał na toaletce Ani.", "fabularny", 0],  # garderoba Ani, sc. 2
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
	"telefon_adriana": ["Telefon Adriana", "Pęknięta szybka, na etui naklejka z maską. Rozładowany i zablokowany PIN-em.", "fabularny", 0],  # pod manekinem w magazynie, sc. 6
	"termos": ["Termos", "Termos Adriana w kratkę, na zakrętce wydrapane \"A.\". Resztka herbaty z cytryną.", "fabularny", 0],  # na sofie w magazynie, sc. 6
	"kielich": ["Złoty kielich", "Czwarty kielich z listy rekwizytów. Leżał pod skrzynią obok ciała, nóżka wgnieciona.", "fabularny", 0],  # pod skrzynią w magazynie, sc. 6
	"lista_rekwizytow": ["Lista rekwizytów", "Lista od dyrektora Lisa. Na dole dopisek Adriana: \"nie dam rady, kręci mi się w głowie\".", "fabularny", 0],  # stolik w salonie, magazyn, sc. 6
	"zdjecie_pasy": ["Zdjęcie: pasy na ramionach", "Zdjęcie z telefonu. Czerwone, równe pasy na ramionach i plecach Adriana.", "fabularny", 0],  # ciało Adriana, sc. 6
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
	"stojak_programy": ["Stojak z programami", "Program premiery. Jeden wezmę. A pod stojakiem... numerek z szatni! Czterdzieści siedem. To mój!", "Jeden program wystarczy."],
	"bufet": ["Bufet", "Na ladzie kanapki i kawa dla widzów premiery. Biorę po jednej.", "Więcej nie wezmę, nie wypada."],
	"apteczka": ["Apteczka", "W apteczce są tabletki przeciwbólowe. Biorę listek.", "Bandaże, plaster. Nic więcej mi nie trzeba."],
	"bankiet": ["Stół bankietowy", "Tartinki, pączki i wino. Biorę coś na ząb.", "Starczy. Nie chcę wyjść na łakomczucha."],
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
