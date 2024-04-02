-- Chapter 5
dofile "lib/es.lua"

es.main {
    chapter = "5",
    onenter = function(s)
        walkin("dream1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/station",
    seconds = 41,
    enter = function(s)
        es.music("hemisphere")
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds + 1
        if s.seconds == 49 then
            timer:stop()
            walkin("intro2")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    template = "НИОС \"Кабирия\"^День первый^^19:36:%s",
    dsc = function(s)
        return string.format(s.template, all.intro1.seconds)
    end
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    pic = "station/dockfloor",
    disp = "Пирс",
    dsc = [[Я первым выбрался из стыковочного рукава. Вектор гравитации изменился, и меня тут же, словно магнитом, притянуло к стене. Я грохнулся на металлическую переборку и лежал, не двигаясь, точно меня сбило с ног ударной волной.
    ^Потребовалось время, чтобы привыкнуть к изменившейся силе тяжести.]],
    next = "intro3"
}
-- endregion

-- region intro3
es.room {
    nam = "intro3",
    pic = "station/dock",
    disp = "Пирс",
    enter = function(s)
        es.music("fatigue2", 2)
    end,
    dsc = [[У пирса наш ожидала целая аварийная команда -- несколько человек в серых обтягивающих комбинезонах.
    ^Кто-то помог мне подняться. 
    ^Мужчина с расплывчатым лицом стал что-то втолковывать, не соображая, что я -- в шлеме с опущенным забралом.
    ^Вслед за мной выполз Майоров. Он ловко вынырнул из люка, распластавшись на полу, и тут же встал на ноги, лишь едва заметно покачнувшись. Волосы у него слиплись от пота, а лицо было таким красным, словно кожа у него слезает с костей.
    ^К Майорову тут же подбежала девушка в светлой униформе -- видимо, медицинский сотрудник. Меня сторожились, как прокажённого -- видимо, из-за скафандра.]],
    obj = { "takeoff_helmet" }
}

es.obj {
    nam = "takeoff_helmet",
    dsc = "Вскоре на пирсе уже стояли все члены моей команды. Я наконец догадался {стянуть с головы шлем}.",
    act = function(s)
        take("helmet")
        es.walkdlg("andreev.head")
        return true
    end
}

es.obj {
    nam = "helmet",
    disp = es.tool "Шлем",
    inv = "Шлем мне пока не пригодится."
}
-- endregion

-- region dock
es.room {
    nam = "dock",
    pic = "station/dock",
    disp = "Пирс",
    dsc = [[Я брожу у пирса, точно искорка пыли в броуновском движении. Скафандр неприятно поскрипывает при каждом шаге.]],
    obj = { "docklight", "grigoriev" },
    way = {
        path { "Отойти от пирса", "neardock1" }
    }
}

es.obj {
    nam = "docklight",
    dsc = "{Лампа} над люком в стыковочный рукав светит ярко, как прожектор, словно пытается выжечь проникший сюда с корабля воздух.",
    act = "Видимо, у местных это обычный способ приветствовать гостей."
}

es.obj {
    nam = "grigoriev",
    done = false,
    cnd = "not s.done",
    dsc = "{Григорьев} неожиданно заинтересовался девушкой в светлой униформе и обстоятельно её о чем-то распрашивает.",
    act = function(s)
        s.done = true
        es.walkdlg("grigoriev.head")
        return true
    end
}
-- endregion

-- region neardock1
es.room {
    nam = "neardock1",
    pic = "station/neardock1",
    disp = "Коридор у пирса",
    dsc = "От нарастающего шума, звучащих вразнобой голосов, кружится голова. Коридор у пирса кажется невыносимо огромным. Во время многодневного дрейфа я так привык к дефициту пространства, что чувствую себя, как глубоководная рыба, которую вытащили на поверхность.",
    obj = {
        "otherdock",
        "suit",
        "majorov",
        "girl"
    },
    way = {
        path { "К пирсу", "dock" },
        path { "Вниз по коридору", "neardock2" }
    }
}

es.obj {
    nam = "otherdock",
    dsc = "{Коридор} уходит по обе стороны от меня, но быстро теряется в тени -- на станции наверняка ещё есть несколько пирсов, но там не горит ни единого огонька.",
    act = "Мы здесь -- единственные гости. На секунду меня посещает странная мысль -- что мы попали в ловушку, -- хотя в этом нет ни малейшего смысла. Однако связи с Землёй нет, сигнал через червоточину отослать невозможно, и нам придётся ждать следующего корабля."
}

es.obj {
    nam = "suit",
    dsc = "Я чувствую себя, как дурак, в тесном и неудобном {скафандре}.",
    act = "Надеюсь, официальная процедура приветствия скоро завершится, и нам покажут наши каюты."
}

es.obj {
    nam = "majorov",
    done = false,
    cnd = "not s.done",
    dsc = "^Капитан о чём-то увлечённо разговаривает с Андреевым, но в ушах у меня звенит, как после контузии, и мне приходится {напрягаться}, чтобы что-то услышать.",
    act = function(s)
        s.done = true
        es.walkdlg("majorov.head")
        return true
    end
}

es.obj {
    nam = "girl",
    cnd = "{grigoriev}.done and {majorov}.done",
    dsc = "^Неподалёку появляется в тени невысокая {девушка}.",
    act = "Кажется, она хочет заговорить, но не решается."
}
-- endregion

-- region neardock2
es.room {
    nam = "neardock2",
    mus = false,
    pic = "station/neardock2",
    disp = "Коридор у пирса",
    dsc = [[Знаменитая "Кабирия" выглядит точно так же, как и все известные мне орбитальные станции -- грубые металлические переборки, энергосберегающие лампы, разливающие стерильный свет по стенам, жёлтые сигнальные люминофоры, которые зажигаются, когда у пирса стоит корабль...]],
    enter = function(s)
        if not s.mus and all.grigoriev.done and all.majorov.done then
            s.mus = true
            es.music("faith", 2, 0, 2000)
        end
    end,
    obj = { "vera" },
    way = {
        path { "К пирсу", "neardock1" }
    }
}

es.obj {
    nam = "vera",
    cnd = "{grigoriev}.done and {majorov}.done",
    dsc = "{Девушка} сиротливо стоит у стены, взволнованно поглядывая на мой скафандр.",
    act = function(s)
        es.walkdlg("vera.head")
        return true
    end
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    noinv = true,
    pic = "station/dockceil",
    disp = "Коридор у пирса",
    dsc = [[Свет приглушили, и коридор у пирса охватила вязкая, едва разреженная тусклыми лампами темнота, напоминающая о сумерках на Земле. Я подумал -- а когда я вернусь домой? Здесь, на орбите Сантори-5, Земля кажется далёкой, как сон, словно во сне только и существует.]],
    next = function(s)
        es.music("hope", 1, 0, 2000)
        es.walkdlg {
            dlg = "andreev",
            branch = "walk",
            disp = "Коридор у пирса",
            pic = "station/neardock3"
        }
        return true
    end
}

es.obj {
    nam = "card",
    disp = es.tool "Ключ-карта",
    inv = "Ключ-карта от жилого модуля С1, моего временного дома."
}
-- endregion

-- region block_c
es.room {
    nam = "block_c",
    pic = "station/c1",
    disp = "Жилой блок C",
    onexit = function(s, t)
        if t.nam == "main" then
            p "Хочется поскорее сбросить с себя скафандр, залезть в кровать и наконец-то выспаться без ночных кошмаров. Дрейф закончился, мы прилетели."
            return false
        elseif t.nam == "cabin1" then
            p "Дверь открывается ключ-картой."
            return false
        end
    end,
    dsc = [[Здесь темно, как в бункере. Надо будет поскорее разобраться с этими однообразными коридорами, чтобы не блуждать впотьмах в поисках своего модуля.]],
    obj = { "door" },
    way = {
        path { "В модуль C1", "cabin1" },
        path { "В соединительный коридор", "main" },
        path { "В жилой блок D", "main" }
    }
}

es.obj {
    nam = "door",
    dsc = "На двери в каюту -- магнитный {замок}.",
    act = "Не понятно, почему я здесь так долго стою, ведь Андреев дал мне ключ-карту.",
    used = function(s, w)
        if w.nam == "card" then
            walkin("cabin1")
            return true
        elseif w.nam == "helmet" then
            return "Не понимаю, чем здесь поможет шлем от скафандра."
        end
    end
}
-- endregion

-- region c1a
es.room {
    nam = "c1a",
    pic = "station/cabin1",
    disp = "Жилой модуль C1",
    dsc = [[У меня даже нет сил осматривать каюту. Кажется, я последний раз нормально спал ещё на Земле.]],
    obj = { "spacesuit", "bed" },
    way = {
        path { "В коридор", "block_c" },
        path { "В санузел", "toilet" }
    }
}

es.obj {
    nam = "spacesuit",
    done = false,
    cnd = "not s.done",
    dsc = "Всё, что мне нужно -- {сбросить} с себя тяжёлый скафандр и добраться до",
    act = function(s)
        s.done = true
        purge("helmet")
        return "Я стаскиваю с себя неудобный скафандр и бросаю его на полу."
    end
}

es.obj {
    nam = "bed",
    dsc = function(s)
        if not all.spacesuit.done then
            return "{кровати}."
        else
            return "Всё, что мне нужно -- это добраться до {кровати}."
        end
    end,
    act = function(s)
        if not all.spacesuit.done then
            return "Я бы предпочёл сначала выбраться из скафандра."
        else
            purge("card")
            walkin("interlude2")
            return true
        end
    end
}
-- endregion

-- region toilet
es.room {
    nam = "toilet",
    pic = "station/toilet1",
    disp = "Санузел",
    dsc = [[Места в санузле чуть ли не больше, чем в моей каюте на "Грозном".]],
    obj = { "sink", "mirror" },
    way = {
        path { "Выйти", "c1a" }
    }
}

es.obj {
    nam = "sink",
    done = false,
    dsc = "Есть даже полноценная {раковина} с водой.",
    act = function(s)
        if not s.done then
            s.done = true
            return "Я умываю холодной водой лицо, мне становится немного лучше."
        else
            return "Я уже умылся."
        end
    end
}

es.obj {
    nam = "mirror",
    dsc = "И {зеркало}!",
    act = "Впрочем, у меня нет никакого желания смотреть на своё отражение."
}
-- endregion

-- region interlude2
es.room {
    nam = "interlude2",
    noinv = true,
    pic = "station/cabin1",
    disp = "Жилой модуль C1",
    dsc = [[Поначалу я хотел осмотреться, может, даже поисследовать станцию, но, стоило мне остаться одному, как я свалился в кровать, точно под снотворным, счастливый от того, что наконец-то высплюсь без ночных кошмаров.]],
    enter = function(s)
        es.stopMusic(2000)
        snapshots:make()
    end,
    next = "pause1"
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv = true,
    pause = 50,
    next = "dream1"
}
-- endregion

-- region dream1
es.room {
    nam = "dream1",
    pic = "dream/lake.boat1",
    disp = "Озеро",
    dsc = [[Озеро так спокойно, словно застыло во времени -- не слышно ни ветра, ни дыхания воды, ни даже привычных шорохов, которые заполняют тихие ночи.
    ^Я -- в пустоте, которая лишь притворяется ночным озером.]],
    enter = function(s)
        es.loopMusic("nightmare")
    end,
    onexit = function(s)
        if not have("paddle") then
            p "Мне понадобится весло."
            return false
        end
    end,
    obj = {
        "moon",
        "light",
        "boat",
        "hands",
        "net",
        "paddle",
        "water1",
        "water2",
        "orb1",
        "reach"
    },
    way = {
        path { "Плыть в сторону", "dream2" },
        path { "Плыть вперёд", "dream3" }
    }
}

es.obj {
    nam = "moon",
    dsc = "{Луна} над головой огромная, в половину небосвода, как будто падает на планету, пойманная гравитационной волной.",
    act = "А может, это мы, захваченные приливом, падаем на поверхность газового гиганта, который похож на Луну?"
}

es.obj {
    nam = "light",
    dsc = "Однако {света} больше не становится.",
    act = "И Луна не отражается в воде."
}

es.obj {
    nam = "boat",
    dsc = function(s)
        local txt = "Я едва различаю очертания {лодки}, в которой сижу"
        if have("paddle") then
            txt = txt.."."
        else
            txt = txt..","
        end
        return txt
    end,
    act = "Лодка старая и гнилая. Как я решился отправиться на ней в плавание?"
}

es.obj {
    nam = "hands",
    cnd = "not have('paddle')",
    dsc = "и собственные {руки}, которые застыли в вязком сумраке, как у подвешенной на нитки марионетки.",
    act = "Темнота сковывает меня, мне сложно пошевелиться."
}

es.obj {
    nam = "net",
    disp = es.tool "Сеть",
    inv = "Рваная сеть для ловли рыбы.",
    tak = "Я подбираю со дна рыболовецкую сеть.",
    dsc = function(s)
        if have("paddle") then
            return "На дне лодки невразчной грудой валяется рваная рыболовецкая {сеть}."
        else
            return "На дне лодки, рядом с рваной рыболовецкой {сетью},"
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" then
            all.paddle.net = true
            purge("net")
            return "Я обматываю сеть вокруг веретена весла -- получается, небольшой карман, в который можно что-то положить."
        end
    end
}

es.obj {
    nam = "paddle",
    net = false,
    orb = false,
    disp = function(s)
        print("paddle.disp")
        if s.orb then
            return (es.tool "Весло со сферой")
        elseif s.net then
            return (es.tool "Весло с сетью")
        else
            return (es.tool "Весло")
        end
    end,
    dsc = function(s)
        if have("net") then
            return "На дне лодки валяется {весло}."
        else
            return "валяется {весло}."
        end
    end,
    used = function(s, w)
        if w.nam == "net" or w.nam == "orb1" then
            return w:used(s)
        end
    end,
    inv = function(s)
        if not s.net and not s.orb then
            return "Короткое деревянное весло со скользким древком -- не обронить бы его в воду."
        elseif s.net and not s.orb then
            return "Я соорудил в нижней части весла, у лопасти, небольшой карман с помощью рыболовецкой сетки."
        elseif s.net and s.orb then
            return "Молочный свет, исходящий из сферы, подкрашивает лопасть весла."
        end
    end,
    tak = "Я поднимаю весло."
}

es.obj {
    nam = "water1",
    dsc = "{Вода слева} от меня заполнена пугающими, лишёнными источника отражениями,",
    act = "Надо определиться, куда плыть.",
    used = function(s, w)
        if w.nam == "paddle" then
            walkin("dream2")
            return true
        end
    end
}

es.obj {
    nam = "water2",
    dsc = "{справа же} -- чёрная, как мазут.",
    act = "Надо определиться, куда плыть.",
    used = function(s, w)
        if w.nam == "paddle" then
            if all.orb1.examed and not all.orb1.near then
                all.orb1.near = true
                return "Я аккуратно, точно боюсь спугнуть живое существо, подплываю к сфере так, чтобы можно было дотянуться до неё рукой."
            else
                walkin("dream3")
                return true
            end
        end
    end
}

es.obj {
    nam = "orb1",
    taken = false,
    examed = false,
    near = false,
    disp = es.tool "Сфера",
    dsc = function(s)
        if not s.examed then
            return "Что-то бьётся о борт лодки, хотя нет ни единой волны -- как будто {невидимое живое существо} пытается пробраться ко мне на борт."
        elseif s.examed and not s.near then
            return "Световая {сфера} неподвижно висит над водой справа от лодки."
        elseif s.examed and s.near then
            return "{Сфера}, которую я преследую, совсем рядом с лодкой."
        end
    end,
    tak = function(s)
        if not s.examed then
            s.examed = true
            p "Я аккуратно, чтобы не упасть, перегибаюсь через борт лодки. В глаза тут же бьёт яркий живой свет, я тянусь к нему, но маленькая сфера проворно, как живое существо, отскаивает от лодки и, проскользив над самой поверхностью воды, устремляется в темноту."
            return false
        elseif s.examed and not s.near then
            p "Сфера слишком далеко, я не могу до неё дотянуться."
            return false
        elseif s.examed and s.near then
            s.taken = true
            return "Сфера больше не пытается от меня cбежать. Она словно привыкла ко мне, смирилась со своим предназначением. Я аккуратно поднимаю её и кладу на дно лодки."
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" and not s.taken and not s.examed then
            return "Надо сначала разобраться, что это, прежде чем бить веслом."
        elseif w.nam == "paddle" and not s.taken then
            walkin("death_intro1")
            return true
        elseif w.nam == "paddle" and s.taken and not w.net then
            return "Но что я собираюсь делать? Разбить сферу? Вряд ли это поможет."
        elseif w.nam == "paddle" and s.taken and w.net and s.near and not s.taken then
            return "Я пытаюсь поймать сферу в примотанную к веслу сетку, но у меня ничего не получается. Возможно, получится достать её рукой? Ведь она совсем близко."
        elseif w.nam == "paddle" and s.taken then
            w.orb = true
            purge("orb1")
            return "Я аккуратно кладу сферу в связанный из сетки карман на весле. Надеюсь, она не вывалится в воду."
        elseif w.nam == "net" and not s.taken and not s.examed then
            return "Надо сначала разобраться, что это."
        elseif w.nam == "net" and not s.taken and s.examed and s.near then
            return "Сфера совсем рядом, я могу попробовать достать её рукой."
        elseif w.nam == "net" and not s.taken and s.examed and not s.near then
            return "Сеть небольшая и драная, вряд ли у меня получится зацепить ей сферу."
        elseif w.nam == "net" and s.taken then
            return "Не представляю, что я собираюсь делать."
        end
    end,
    inv = [[Сфера лежит на дне лодки, источая пульсирующий живой свет. Я чувствую, что мне нужен этот свет, чтобы плыть дальше, но, если я брошу сферу в воду, она вновь попытается сбежать от меня.]]
}

es.obj {
    nam = "reach",
    cnd = "{orb1}.examed",
    dsc = "Кажется, я даже могу {дотянуться} до неё веслом.",
    act = function(s)
        if all.orb1.near then
            return "Впрочем, не уверен, впрочем, что это хорошая идея. Лодка может перевернуться."
        else
            return "Сейчас выловить сферу будет куда проще."
        end
    end
}
-- endregion

-- region dream2
es.room {
    nam = "dream2",
    pic = "dream/lake.boat2",
    disp = "Озеро",
    dsc = [[Здесь всё заполнено фальшивыми отражениями.
    ^Луна ещё больше увеличилась в размерах, и что-то -- внутренний голос, ангел-хранитель -- подсказывает мне, что плыть дальше не стоит, надо вернуться назад.]],
    obj = { "reflections" },
    way = {
        path { "Плыть дальше", "death_intro2" },
        path { "Плыть назад", "dream1" }
    }
}

es.obj {
    nam = "reflections",
    dsc = "От отражений в {воде} рябит в глазах.",
    act = "Каким образом может отражаться то, что не существует?",
    used = function(s, w)
        if w.nam == "paddle" then
            walkin("death_intro2")
            return true
        end
    end
}
-- endregion

-- region dream3
es.room {
    nam = "dream3",
    pic = "dream/lake.boat3",
    disp = "Озеро",
    dsc = [[Я гребу -- и темнота расступается передо мной. Меня наполняет наивная радость -- я наконец-то выберусь из этого места, сбегу от фальшивого света и темноты.]],
    onenter = function(s)
        if not all.paddle.orb then
            p "Я пытаюсь плыть в темноту, но чёрная вода странно густеет с каждым взмахов весла, и лодка моя застывает, пойманная в ловушку."
            return false
        end
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Нет! Меньше всего мне сейчас хочется возвращаться, ведь я так близок к цели."
            return false
        end
    end,
    obj = { "glass" },
    way = {
        path { "Плыть назад", "main" },
        path { "Плыть вперёд", "dream4" }
    }
}

es.obj {
    nam = "glass",
    dsc = "{Вода} удивительно ровная и похожа на стекло.",
    act = "Я замечаю в воде какое-то смутное движение, как будто все озеро кишит жизнью, которая прячется от света.",
    used = function(s, w)
        if w.nam == "paddle" then
            walkin("dream4")
            return true
        end
    end
}
-- endregion

-- region dream4
es.room {
    nam = "dream4",
    pic = "dream/lake1",
    disp = "Озеро",
    dsc = "Нет ничего менее реального, чем это озеро, эта тёмная вода, эта огромная Луна, которая бьёт мне в глаза, но не светит. На секунду я понимаю, что сплю, но тут же отбрасываю эту мысль -- слишком уж явно страх пробирается мне под кожу, слишком осязаема окружающая меня темнота.",
    onexit = function(s, t)
        if (t.nam == "wake1" or t.nam == "dream3") and not all.wall.examed then
            p "Не стоит слепо плыть в темноту, надо разобраться, что меня ждёт впереди."
            return false
        elseif t.nam == "wake1" and all.wall.examed and not all.flag.orb then
            p "Я пытаюсь плыть вперёд, но ожившая темнота не пускает меня, отталкивает мою утлую лодку."
            return false
        elseif t.nam == "main" then
            p "Я пытаюсь развернуться, но у меня ничего не получается. Уже нет пути назад."
            return false
        elseif t.nam == "dream3" then
            p "Я пытаюсь грести в сторону, но ничего не меняется -- перед мной всё та же стена темноты."
            return false
        end
    end,
    obj = { "flag", "wall" },
    way = {
        path { "Плыть назад", "main" },
        path { "Плыть налево", "dream4" },
        path { "Плыть направо", "dream4" },
        path { "Плыть вперёд", "wake1" }
    }
}

es.obj {
    nam = "flag",
    orb = false,
    dsc = function(s)
        if not s.orb then
            return "Я только сейчас замечаю, что на носу моей лодки -- необычно длинный {флагшток}, как на огромных и раскошных судах."
        else
            return "На флагштоке в носу корабля висит опутанная рваной сеткой {сфера}."
        end
    end,
    act = function(s)
        if s.orb then
            return "Лишь бы хватило её света."
        else
            return "Интересно, был ли он раньше?"
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" and not all.wall.examed then
            return "Надо сначала получше рассмотреть, что там, впереди."
        elseif w.nam == "paddle" then
            w.net = false
            w.orb = false
            s.orb = true
            return "Я приделываю сферу на нос корабля. Теперь мы бьём светом в лицо темноте. Я чувствую воодушевление."
        end
    end
}

es.obj {
    nam = "wall",
    examed = false,
    dsc = function(s)
        if s.examed then
            return "Путь мне преграждает огромная {стена} клокочущей темноты."
        else
            return "Темнота здесь стала гуще, и тлеющая сфера, приделанная к веслу, уже не в силах освещать мне путь. {Впереди} что-то движется -- мазки чёрным на тёмно-сером фоне."
        end
    end,
    act = function(s)
        if not s.examed then
            return "Так я ничего не могу разглядеть."
        else
            return "Я не смогу плыть дальше, пока эти чёрные тени поднимаются из воды."
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" and s.examed then
            walkin("death_intro3")
            return true
        elseif w.nam == "paddle" and not s.examed then
            s.examed = true
            return [[Я аккуратно поднимаю весло над водой -- так, чтобы не вывалилась сфера, -- приглядываюсь и вижу, как тонкие чёрные ленты поднимаются из воды, сплеватаясь в некое подобие плотной подвижной стены, которая не даёт мне плыть дальше.
            ^Меня так зачаровывают эти живые тени, что сфера едва не выскализывает из сетки на весле. Что бы со мной произошло, если бы я остался без света! Надо быть осторожнее.]]
        end
    end
}
-- endregion

-- region wake1
es.room {
    nam = "wake1",
    noinv = true,
    pic = "dream/lake1",
    disp = "Озеро",
    enter = function(s)
        es.stopMusic(4000)
    end,
    dsc = [[Я делаю несколько сильных гребков, и темнота впереди расступается, пропускает меня, испуганная моим светом. Чёрные извивающиеся полосы проносится мимо меня, едва не касаясь щёк. Сфера раскачивается в сетке на флагштоке, как от ветра.]],
    next = function(s)
        es.music("not_ok")
        walkin("wake2")
        return true
    end
}
-- endregion

-- region wake2
es.room {
    nam = "wake2",
    noinv = true,
    pic = "dream/lake.deep3",
    disp = "Озеро",
    dsc = [[Грести становится тяжелее. Я останавливаюсь, чтобы передохнуть, и в этот момент сфера на носу лодки гаснет.
    ^Темнота тут же набрасывается на меня огромной волной, в миг смывая последние отблески света. Больше нет ни Луны, ни озера, ни лодки. Однако я не в пустоте. Тьма вокруг наполнена движением, жизнью, ликующей из-за того, что избавилась от света.
    ^У меня нет сил, чтобы сопротивляться. Я бросаю бесполезное теперь весло и закрываю глаза.]],
    next = function(s)
        purge("paddle")
        walkin("pause2")
        return true
    end
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = "c1b"
}
-- endregion

-- region c1b
es.room {
    nam = "c1b",
    pic = "station/cabin1",
    disp = "Каюта",
    dsc = [[Я открываю глаза.
    ^Я лежу на узкой койке. Где-то над головой мерно шумят воздуховоды, несколько диодов у потолка ритмично подмигают мне, как всё в порядке, всё работает штатно, нет ни единой причины для беспокойства. Но лоб мой -- влажный от пота. И после сна -- трещит голова.]],
    enter = function(s)
        es.music("note")
    end,
    obj = { "getup" }
}

es.obj {
    nam = "getup",
    dsc = "Я пытаюсь {подняться} с кровати.",
    act = function(s)
        gamefile("game/06.lua", true)
        return true
    end
}
-- endregion

-- region death_intro1
es.room {
    nam = "death_intro1",
    noinv = true,
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Я схватил весло обеими руками за рукоятку, перегнулся через край лодки и уже коснулся лопастью сферы, как лодка вдруг перевернулась, и я рухнул в ледяную чёрную воду.]],
    enter = function(s)
        es.stopMusic(2000)
    end,
    next = "death"
}
-- endregion

-- region death_intro2
es.room {
    nam = "death_intro2",
    noinv = true,
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Я заставлю внутренний голос замолкнуть и продолжаю упрямо грести вперёд. Отражений становится всё больше, но и темнота никуда не уходит. Кажеться, что эти иллюзорные отблески вредят мне -- они вливаются в меня сквозь глаза и обжигают всего изнутри.]],
    enter = function(s)
        es.stopMusic(2000)
    end,
    next = "death"
}
-- endregion

-- region death_intro3
es.room {
    nam = "death_intro3",
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Я поднимаю весло, чтобы разогнать темноту, сфера вываливается из прикрученной к веретену сетки, и бесшумно исчезает в чёрной воде. Меня тут же огромной волной накрывает темнота.]],
    enter = function(s)
        es.stopMusic(2000)
    end,
    next = "death"
}
-- endregion

-- region death
es.room {
    nam = "death",
    noinv = true,
    pic = "common/report",
    dsc = [[Отчёт Елены Викторны Ефимовой, главного врача НИОС "Кабирия"
    ^День 3865, 07:22 у.в.
    ^^Вереснев Олег Викторович, техник ГМК "Грозный", 26 полных лет, был обнаружен сегодня мёртвым в своей каюте. Причина смерти -- кровоизлияние в мозг. Предрасположенностей для кровоизлияния не имел. Проводится детальный химический анализ крови.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "Последняя точка сохранения",
    next = function(s)
        snapshots:restore()
        return true
    end
}
-- endregion
