-- Chapter 5
dofile "lib/es.lua"

es.main {
    chapter = "5",
    onenter = function(s)
        walkin("intro1")
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
            es.music("overcome", 2, 0, 3000)
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
    disp = "Пристань",
    dsc = [[Я первым выбрался из стыковочного рукава. Вектор гравитации изменился, и меня тут же, точно магнитом, притянуло к стене. Я грохнулся на металлическую переборку и лежал, не двигаясь, сбитый с ног ударной волной.
    ^Потребовалось время, чтобы привыкнуть к изменившейся силе тяжести.]],
    next = "intro3"
}
-- endregion

-- region intro3
es.room {
    nam = "intro3",
    pic = "station/dock",
    disp = "Пристань",
    dsc = [[У пристани нас ожидала аварийная команда -- несколько человек в серых, похожих на рабочие робы, комбинезонах.
    ^Кто-то помог мне подняться. 
    ^Мужчина с расплывчатым лицом стал что-то втолковывать, не соображая, что я -- в шлеме с опущенным забралом.
    ^Вслед за мной выполз Майоров.
    ^Он ловко вынырнул из люка, распластался на полу, придавленный гравитацией, но быстро встал на ноги, лишь едва заметно покачнувшись. Волосы -- слиплись от пота. Кожа на лице пошла пунцовыми пятнами, как от проказы.
    ^К Майорову тут же подбежала девушка в светлой униформе. Меня сторонились, как заразного. Может быть, вышедшую нам на встречу делегацию пугал мой скафандра.]],
    obj = { "takeoff_helmet" }
}

es.obj {
    nam = "takeoff_helmet",
    dsc = [[Вскоре на пристань выбрался весь экипаж "Грозного". Я наконец догадался {стянуть с головы шлем}.]],
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
    mus = false,
    done = false,
    pic = "station/dock",
    disp = "Пристань",
    dsc = function(s)
        if not s.done then
            return [[Я мечусь у пристани, как искринка пыли в броуновском движении. Скафандр неприятно поскрипывает при каждом шаге.]]
        else
            return [[Я мечусь у пристани, как искринка пыли в броуновском движении.]]
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("fatigue2", 2, 0, 5000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "pause1" and s.done then
            p "Больше нет смысла возвращаться на корабль."
            return false
        elseif t.nam == "neardock1" and not s.done then
            walkin("no_suit")
            return false
        end
    end,
    obj = { "docklight", "grigoriev" },
    way = {
        path { "В стыковочный рукав", "pause1" },
        path { "Отойти от пристани", "neardock1" }
    }
}

es.obj {
    nam = "docklight",
    dsc = "{Лампа} над люком в стыковочный рукав светит ярко, как прожектор, будто пытается выжечь проникший сюда с корабля воздух.",
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

-- region no_suit
es.room {
    nam = "no_suit",
    noinv = true,
    pic = "station/dock",
    dsc = [[Разгуливать здесь в тесном и увесистом скафандре не так-то просто -- на корабле он тоже не казался лёгким, а сейчас нещадно вяжет свинцовой тяжестью шаги, точно я взгромоздил на себя водолазный костюм начала 19-го века.]],
    next = "dock"
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv = true,
    pause = 50,
    next = function(s)
        all.dock.done = true
        purge("helmet")
        es.music("hope", 2, 0, 3000)
        p "Я спустился на корабль, с удовольствием скинул с себя тяжёлый скафандр и снова вылез на пристань. Кажется, стало даже легче дышать."
        walkin("dock")
    end
}
-- endregion

-- region neardock1
es.room {
    nam = "neardock1",
    mus = false,
    pic = "station/neardock1",
    disp = "Коридор у пристани",
    dsc = [[От нарастающего шума, звучащих вразнобой голосов, кружится голова. Коридор у пристани угнетает размерами. За две с лишним недели на "Грозном" я так привык к дефициту пространства, что чувствую себя, как глубоководная рыба, которую вытащили на поверхность.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("lotus", 2, 0, 3000)
        end
    end,
    obj = {
        "otherdock",
        "majorov",
        "girl"
    },
    way = {
        path { "К пристани", "dock" },
        path { "Вниз по коридору", "neardock2" }
    }
}

es.obj {
    nam = "otherdock",
    dsc = "{Коридор} уходит вглубь, как под воду, и быстро теряется в тени -- на станции наверняка ещё есть другие пристани, но там не горит ни единого огонька.",
    act = "Мы здесь -- единственные гости. На секунду меня посещает мысль, что мы попали в ловушку. Я понимаю, что в этом нет ни малейшего смысла. Однако связи с Землёй нет, сигнал через червоточину отослать невозможно, и нам придётся дожидаться следующего корабля."
}

es.obj {
    nam = "majorov",
    done = false,
    cnd = "not s.done",
    dsc = "^Капитан о чём-то увлечённо разговаривает с Андреевым, но в ушах у меня звенит, как у контуженного, и приходится {напрягаться}, чтобы что-то услышать.",
    act = function(s)
        s.done = true
        es.walkdlg("majorov.head")
        return true
    end
}

es.obj {
    nam = "girl",
    cnd = "{grigoriev}.done and {majorov}.done",
    dsc = "^^Неподалёку появляется в тени невысокая {девушка}.",
    act = "Кажется, она хочет заговорить, но не решается."
}
-- endregion

-- region neardock2
es.room {
    nam = "neardock2",
    mus = false,
    pic = "station/neardock2",
    disp = "Коридор у пристани",
    dsc = [[Знаменитая "Кабирия" выглядит точно так же, как и все известные мне орбитальные станции -- грубые металлические переборки, энергосберегающие лампы, разливающие по стенам стерильный свет, жёлтые сигнальные люминофоры, которые зажигаются, когда у пристани стоит корабль...]],
    enter = function(s)
        if not s.mus and all.grigoriev.done and all.majorov.done then
            s.mus = true
            es.music("faith", 2, 0, 3000)
        end
    end,
    obj = { "vera" },
    way = {
        path { "К причалу", "neardock1" }
    }
}

es.obj {
    nam = "vera",
    cnd = "{grigoriev}.done and {majorov}.done",
    dsc = "{Девушка} сиротливо стоит у стены и с любопытством на меня поглядывает.",
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
    disp = "Коридор у пристани",
    dsc = [[Свет приглушили, и коридор у пристани охватил вязкий, едва разреженный тусклыми лампами полумрак, напоминающий о сумерках на Земле. Я подумал -- а когда мы вернёмся домой? Здесь, на орбите Сантори-5, Земля кажется далёкой, как сон, словно во сне только и существует.]],
    next = function(s)
        es.music("anticipation", 2, 0, 3000)
        es.walkdlg {
            dlg = "andreev",
            branch = "walk",
            disp = "Коридор у пристани",
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
    mus = false,
    pic = "station/c1",
    disp = "Жилой блок C",
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("roar", 1, 0, 3000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Хочется поскорее залезть в кровать и выспаться без ночных кошмаров. Переход закончился, мы прилетели."
            return false
        elseif t.nam == "c1a" then
            p "Дверь открывается ключ-картой."
            return false
        end
    end,
    dsc = [[Здесь темно, как в бункере. Надо будет поскорее разобраться с этими однообразными коридорами, чтобы не блуждать впотьмах в поисках жилого модуля.]],
    obj = { "door" },
    way = {
        path { "В модуль C1", "c1a" },
        path { "В коридор", "main" },
        path { "В жилой блок D", "main" }
    }
}

es.obj {
    nam = "door",
    dsc = "На двери в каюту -- магнитный {замок}.",
    act = "Не понятно, что я здесь делаю. Андреев дал мне ключ-карту. Я устал и хочу спать.",
    used = function(s, w)
        if w.nam == "card" then
            walkin("c1a")
            return true
        end
    end
}
-- endregion

-- region c1a
es.room {
    nam = "c1a",
    pic = "station/cabin1",
    disp = "Жилой модуль C1",
    dsc = [[У меня даже нет сил осматривать каюту. Последний раз я нормально спал ещё на Земле.]],
    obj = { "bed" },
    enter = function(s)
        es.stopMusic(3000)
    end,
    way = {
        path { "В коридор", "block_c" },
        path { "В санузел", "latrine" }
    }
}

es.obj {
    nam = "bed",
    dsc = "Всё, что мне нужно -- это добраться до {кровати}.",
    act = function(s)
        purge("card")
        walkin("interlude2")
        return true
    end
}
-- endregion

-- region latrine
es.room {
    nam = "latrine",
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
    dsc = [[Поначалу я хотел осмотреться, может, даже поисследовать станцию, но, стоило мне остаться одному, и я свалился в кровать, как под снотворным, счастливый от того, что наконец-то высплюсь без ночных кошмаров.]],
    enter = function(s)
        es.music("signal")
        snapshots:make()
    end,
    next = "pause2"
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.loopMusic("nightmare")
    end,
    next = "dream1"
}
-- endregion

-- region dream1
es.room {
    nam = "dream1",
    pic = "dream/lake.boat1",
    disp = "Озеро",
    dsc = [[Озеро застыло во времени -- не слышно ни ветра, ни дыхания воды, ни даже привычных шорохов, которые заполняют тихие ночи.]],
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
    dsc = "{Луна} над головой -- огромна и занимает половину небосвода. Она падает на планету, пойманная гравитационной волной.",
    act = "А может, это мы, захваченные приливом, несёмся навстречу облакам газового гиганта, который лишь притворяется Луной?"
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
    dsc = "и собственные {руки}, замершие в густом сумраке, как у подвешенной на нитки марионетки.",
    act = "Темнота сковывает меня, мне сложно пошевелиться."
}

es.obj {
    nam = "net",
    disp = es.tool "Сеть",
    inv = "Рваная сеть для ловли рыбы.",
    tak = "Я подбираю со дна рыболовецкую сеть.",
    dsc = function(s)
        if have("paddle") then
            return "На дне лодки невзрачной грудой валяется рваная рыболовецкая {сеть}."
        else
            return "На дне лодки, рядом с рваной рыболовецкой {сетью},"
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" then
            all.paddle.net = true
            purge("net")
            return "Я обматываю сеть вокруг веретена весла -- получается небольшой карман, в который можно что-то положить."
        end
    end
}

es.obj {
    nam = "paddle",
    net = false,
    orb = false,
    disp = function(s)
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
            return "Молочный свет, исходящий из сферы, серебрит лопасть весла."
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
                return [[Я аккуратно, точно боюсь спугнуть живое существо, подплываю к сфере.
                ^Теперь можно дотянуться до неё рукой.]]
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
            return "Что-то бьётся о борт лодки -- настойчиво, с монотонным глухим стуком, как будто ломится в дверь. Нет ни единой волны. Кажется, {нечто незримое} пробирается на борт моей лодки."
        elseif s.examed and not s.near then
            return "Светящаяся {сфера} неподвижно висит над водой справа от лодки."
        elseif s.examed and s.near then
            return "{Сфера}, которую я преследую, совсем рядом с лодкой."
        end
    end,
    tak = function(s)
        if not s.examed then
            s.examed = true
            p "Я аккуратно, чтобы не упасть, перегибаюсь через борт. В глаза тут же бьёт яркий живой свет, я тянусь к нему, но маленькая сфера проворно, как живое существо, отскаивает от лодки и, проскользив над самой поверхностью воды, устремляется в темноту."
            return false
        elseif s.examed and not s.near then
            p "Сфера слишком далеко, я не могу до неё дотянуться."
            return false
        elseif s.examed and s.near then
            s.taken = true
            return "Сфера больше не пытается от меня cбежать. Она привыкла ко мне, смирилась со своим предназначением. Я аккуратно поднимаю её и кладу на дно лодки."
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" and not s.taken and not s.examed then
            return "Надо сначала разобраться, что это, прежде чем бить веслом."
        elseif w.nam == "paddle" and not s.taken and s.near then
            return "Сейчас я могу достать сферу рукой."
        elseif w.nam == "paddle" and not s.taken then
            walkin("death_intro1")
            return true
        elseif w.nam == "paddle" and s.taken and not w.net then
            return "Но что я собираюсь делать? Разбить сферу? Вряд ли это поможет."
        elseif w.nam == "paddle" and s.taken and w.net and s.near and not s.taken then
            return "Я пытаюсь поймать сферу в примотанную к веслу сетку, но у меня ничего не выход. Возможно, проще подцепить её рукой? Ведь сфера совсем близко."
        elseif w.nam == "paddle" and s.taken then
            w.orb = true
            purge("orb1")
            return "Я аккуратно кладу сферу в связанный из сетки карман на весле. Надеюсь, она не вывалится в воду."
        elseif w.nam == "net" and not s.taken and not s.examed then
            return "Надо сначала разобраться, что это."
        elseif w.nam == "net" and not s.taken and s.examed and s.near then
            return "Сфера совсем рядом, я могу попробовать достать её рукой."
        elseif w.nam == "net" and not s.taken and s.examed and not s.near then
            return "Сеть небольшая и рваная, вряд ли у меня получится поймать ей ускользающую сферу."
        elseif w.nam == "net" and s.taken then
            return "Не представляю, что я собираюсь делать."
        end
    end,
    inv = [[Сфера лежит на дне лодки, источая пульсирующий свет. Когда я смотрю на сферу, внутри меня что-то оттаивает и оживает.]]
}

es.obj {
    nam = "reach",
    cnd = "{orb1}.examed and not {orb1}.near",
    dsc = "Кажется, я даже могу {дотянуться} до неё веслом.",
    act = "Не уверен, впрочем, что это хорошая идея. Лодка может перевернуться."
}
-- endregion

-- region dream2
es.room {
    nam = "dream2",
    pic = "dream/lake.boat2",
    disp = "Озеро",
    dsc = [[Здесь всё заполнено фальшивыми отражениями.
    ^Луна ещё больше увеличилась в размерах, и что-то -- внутренний голос, ангел-хранитель -- подсказывает мне, что плыть дальше не стоит, что надо вернуться назад.]],
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
            p "Я пытаюсь плыть в темноту, но чёрная вода густеет с каждым взмахом весла, и лодка застывает, пойманная в ловушку, как муха на липучку."
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
    act = "Я замечаю в воде смутное движение, как будто всё озеро кишит жизнью, которая прячется от света.",
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
    dsc = "Нет ничего менее реального, чем это озеро, эта тёмная вода, эта огромная Луна, которая бьёт в глаза, но не светит. На секунду я понимаю, что сплю, но тут же отбрасываю эту мысль -- слишком уж явно страх пробирается под кожу, слишком осязаема окружающая темнота.",
    onexit = function(s, t)
        if (t.nam == "wake1" or t.nam == "dream3") and not all.wall.examed then
            p "Не стоит слепо плыть в темноту, надо разобраться, что ждёт впереди."
            return false
        elseif t.nam == "wake1" and all.wall.examed and not all.flag.orb then
            p "Я пытаюсь плыть вперёд, но ожившая темнота не пускает, отталкивает мою утлую лодку."
            return false
        elseif t.nam == "main" then
            p "Я пытаюсь развернуться, но ничего не получается. Уже нет пути назад."
            return false
        elseif t.nam == "dream3" then
            p "Я пытаюсь грести в сторону, но ничего не меняется -- перед мной всё та же стена темноты."
            return false
        end
    end,
    obj = { "flag", "wall" },
    way = {
        path { "Плыть назад", "main" },
        path { "Плыть налево", "dream3" },
        path { "Плыть направо", "dream3" },
        path { "Плыть вперёд", "wake1" }
    }
}

es.obj {
    nam = "flag",
    orb = false,
    dsc = function(s)
        if not s.orb then
            return "Я только сейчас замечаю, что на носу лодки -- необычно длинный {флагшток}, как на огромных и раскошных яхтах."
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
            return "Надо получше рассмотреть, что впереди."
        elseif w.nam == "paddle" then
            w.net = false
            w.orb = false
            s.orb = true
            return "Я приделываю сферу на нос корабля. Мы рассекаем светом дрогнувшую темноту."
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
            return "Темнота стала гуще, и тлеющая сфера, приделанная к веслу, уже не в силах освещать мне путь. {Впереди} что-то движется -- я вижу стремительные чёрные мазки поверх серой грунтовки неба."
        end
    end,
    act = function(s)
        if not s.examed then
            return "Так я ничего не могу разглядеть."
        else
            return "Я не смогу плыть дальше, пока эти чёрные тени лезут из воды."
        end
    end,
    used = function(s, w)
        if w.nam == "paddle" and s.examed and w.orb then
            walkin("death_intro3")
            return true
        elseif w.nam == "paddle" and s.examed and not w.orb then
            return "Весло тут не поможет."
        elseif w.nam == "paddle" and not s.examed then
            s.examed = true
            return [[Я аккуратно поднимаю весло над водой -- так, чтобы не вывалилась сфера, -- приглядываюсь и вижу, как тонкие чёрные ленты вылезают из омута, сплетаясь в плотную стену, которая не даёт плыть дальше.
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
    dsc = [[Я делаю несколько сильных гребков, и темнота впереди расступается, пропускает меня, испуганная светом. Чёрные извивающиеся полосы проносится над головой, едва не касаясь щёк. Сфера раскачивается в сетке на флагштоке, как от ветра.]],
    next = function(s)
        es.music("santorum")
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
    ^Темнота тут же набрасывается на меня, в миг смывая последние отблески света. Больше нет ни Луны, ни озера, ни лодки. Но я не в пустоте. Тьма вокруг наполнена движением, жизнью, ликующей из-за того, что избавилась от света.
    ^У меня нет сил, чтобы сопротивляться. Я бросаю бесполезное теперь весло и закрываю глаза.]],
    next = function(s)
        purge("paddle")
        walkin("pause3")
        return true
    end
}
-- endregion

-- region pause3
es.room {
    nam = "pause3",
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
    ^Я лежу на узкой койке. Где-то над головой с отдышкой пыхтят воздуховоды. Несколько диодов у потолка ритмично подмигают мне, встречая после сна. Всё в порядке, всё работает штатно, нет ни единой причины для беспокойства.
    ^Но лоб -- влажный от пота. И опять трещит голова.]],
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
    dsc = [[Я схватил обеими руками весло, перегнулся через борт и уже коснулся лопастью сферы, как лодка вдруг перевернулась, и я рухнул в ледяную чёрную воду.]],
    enter = function(s)
        es.stopMusic(3000)
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
    dsc = [[Я заставляю внутренний голос умолкнуть и продолжаю упрямо грести вперёд.
    ^Отражений становится больше, но и темнота никуда не уходит. Кажется, эти иллюзорные отблески вредят мне -- они вливаются в меня сквозь глаза и обжигают изнутри.]],
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = "death"
}
-- endregion

-- region death_intro3
es.room {
    nam = "death_intro3",
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Я поднимаю весло, чтобы разогнать темноту, сфера вываливается из прикрученной к веретену сетки, и бесшумно исчезает в чёрной воде. Меня тут же штормовым валом сметает темнота.]],
    enter = function(s)
        es.stopMusic(3000)
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
    ^^Вереснев Олег Викторович, техник ГКМ "Грозный", 26 полных лет, был обнаружен сегодня мёртвым в своём жилом модуле. Причина смерти -- кровоизлияние в мозг. Предрасположенностей для кровоизлияния не имел. Проводится детальный химический анализ крови.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
        return true
    end
}
-- endregion
