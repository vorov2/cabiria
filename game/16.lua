-- Chapter 16
dofile "lib/es.lua"

es.main {
    chapter = "16",
    onenter = function(s)
        es.music("soundinspace")
        take("bag")
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/ship",
    noinv = true,
    disp = "Судовой отчёт",
    systems = { "Сантори", "Антелла-12", "Солнечная система" },
    dsc = [[<b>Корабль:</b> ГКМ "Грозный"^
    <b>Порт приписки:</b> Байконур^
    <b>Экипаж:</b> три человека^
    <b>Местоположение:</b>]],
    obj = { "location" }
}

es.obj {
    nam = "location",
    count = 1,
    dsc = function(s)
        local nam = all.intro1.systems[s.count]
        return "{"..nam.."}"
    end,
    act = function(s)
        s.count = s.count + 1
        if s.count == 4 then
            walkin("intro2")
            return true
        else
            walkin("intro1")
            return true
        end
    end
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    pic = "common/earth",
    noinv = true,
    disp = "",
    enter = function(s)
        es.music("roar")
    end,
    obj = { "earth" }
}

es.obj {
    nam = "earth",
    dsc = "{Земля}",
    act = function(s)
        walkin("pause1")
    end
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv = true,
    pause = 80,
    enter = function(s)
        es.music("stream", 3, 0, 3000)
    end,
    next = "intro3"
}
-- endregion

-- region intro3
es.room {
    nam = "intro3",
    noinv = true,
    pic = "dream/beach.sky",
    dsc = [[День такой жаркий, что в городе находится невозможно. Кажется, что кожа плавится от духоты. Хорошо хоть, что мы с Верой можем выбраться на пляж.
    ^Когда только подходишь к озеру со стороны кричащей от зноя дороги, шаркая в шлёпках по липкому асфальту, сразу чуствуешь приятную прохладу.]],
    next = "beach1"
}
-- endregion

-- region beach1
es.room {
    nam = "beach1",
    pic = "dream/beach.shore",
    done = false,
    disp = "Пляж",
    dsc = [[Как ни странно, на пляже нет никого, кроме нас, хотя при такой погоде только и думаешь о том, как бы найти спасения у воды.]],
    onexit = function(s, t)
        if t.nam == "shore1" then
            p "Надо сначала разложить вещи."
            return false
        end
    end,
    obj = { "vera1", "spot" },
    way = {
        path { "К берегу", "shore1" }
    }
}

es.obj {
    nam = "vera1",
    done = false,
    dsc = "{Вера} стоит рядом. На секунду мне кажется, что она улыбается, когда ветер мягко касается её волос, но нет -- это лишь падает на лицо тень.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.head")
            return true
        else
            return "Вера смотрит неподвижным взглядом на воду."
        end
    end,
    used = function(s, w)
        if w.nam == "bag" and w.done then
            return "Зачем ей пустая сумка?"
        elseif w.nam == "bag" then
            return "Думаю, лучше мне самому разобрать вещи."
        elseif w.nam == "towel" then
            return "Думаю, я сам смогу расстелить полотенце."
        elseif w.nam == "bottle" and not w.unbar then
            return "Вера сама открыть бутылку не сможет."
        elseif w.nam == "bottle" then
            w.done = true
            purge("bottle")
            es.walkdlg("vera.bottle")
            return true
        end
    end
}

es.obj {
    nam = "spot",
    dsc = "Место здесь удачное, {песок} чистый и берег недалеко. Осталось расстелить полотенце.",
    act = "Правда, сидеть мы тут будем под палящим солнцем, но что поделать.",
    used = function(s, w)
        if w.nam == "towel" and not all.bottle.done then
            return "Вера наверняка хочет пить, полотенце я всегда расстелить успею."
        elseif w.nam == "towel" then
            purge(w.nam)
            purge("bag")
            all.beach1.done = true
            walkin("beach2")
            return true
        elseif w.nam == "umbrella" then
            return "Надо сначала постелить полотенце."
        elseif w.nam == "bottle" then
            return "Зачем бросать на песок бутылку минералки?"
        end
    end
}

es.obj {
    nam = "bag",
    done = false,
    disp = es.tool "Сумка",
    inv = function(s)
        if not s.done then
            s.done = true
            take("bottle")
            take("towel")
            take("umbrella")
            return "В сумке лежат бутылка минералки, полотенце и пляжный зонт."
        else
            return "Больше в сумке ничего нет."
        end
    end
}

es.obj {
    nam = "bottle",
    unbar = false,
    done = false,
    disp = es.tool "Бутылка воды",
    inv = function(s)
        if not s.unbar then
            s.unbar = true
            return "Я скручиваю пробку у бутылки."
        else
            return "Открытая бутылка минеральной воды \"Ессентуки-17\"."
        end
    end
}

es.obj {
    nam = "towel",
    disp = es.tool "Полотенце",
    inv = "Полотенце давно полиняло на солнце."
}
-- endregion

-- region beach2
es.room {
    nam = "beach2",
    pic = "dream/beach.shore",
    disp = "Пляж",
    dsc = [[Ветер приятно холодит нагревшуюся кожу. Я на секунду закрываю глаза и подставляю лицо ласковому озёрному бризу.]],
    onexit = function(s, t)
        if t.nam == "shore1" and not all.umbrella.done then
            p "Надо сначала поставить зонтик."
            return false
        elseif t.nam == "shore1" then
            es.walkdlg("vera.tail")
            return false
        end
    end,
    obj = { "vera2", "sand", "sandbag", "skin" },
    way = {
        path { "К берегу", "shore1" }
    }
}

es.obj {
    nam = "vera2",
    done = false,
    dsc = "{Вера} сидит на полотенце, обхватив колени, и смотрит в",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.shadow")
            return true
        else
            return "Вера смотрит неподвижным взглядом на воду."
        end
    end
}

es.obj {
    nam = "sand",
    dsc = "{песок}, на треснувшую ракушку.",
    act = "Здесь можно поставить зонт.",
    used = function(s, w)
        if w.nam == "umbrella" and not w.unbar then
            return "Зонтик надо сначала раскрыть."
        elseif w.nam == "umbrella" then
            purge("umbrella")
            w.done = true
            return [[Я втыкаю зонт в песок рядом с Верой, и её накрывает тень. Тут же поднимается ветерок, взъерошивает её волосы. 
            ^Вера ни на что не обращает внимания. Она смотрит на пенящиеся у берега волны.]]
        end
    end
}

es.obj {
    nam = "sandbag",
    dsc = "У её ног валяется пустая холщовая {сумка}, на которую ветер уже успел намести песок.",
    act = "Можно подумать, что время ускорилось, и мы провели на пляже несколько часов."
}

es.obj {
    nam = "skin",
    dsc = "{Кожа} у Веры на плечах стала бронзовой от загара.",
    act = "Как бы нам не сгореть под этим солнцем!"
}

es.obj {
    nam = "umbrella",
    unbar = false,
    done = false,
    disp = es.tool "Пляжный зонт",
    inv = function(s)
        if not all.beach1.done then
            return "Надо сначала постелить полотенце."
        end
        if not s.unbar then
            s.unbar = true
            return [[Фиксатор на стержне зонта впивается мне в палец. Я поднимаю на удивление тугой бегунок, раскрывая широкий сине-белый купол, яркий, как детская игрушка.
            ^От зонта на песок тут же ложится ажурная тень.]]
        else
            s.unbar = false
            return "Я закрываю зонт."
        end
    end
}
-- endregion

-- region shore1
es.room {
    nam = "shore1",
    pic = "dream/beach.water",
    disp = "У берега",
    dsc = [[Я стою на берегу. Ветер треплет волосы. Озеро разволновалось, словно решило превратиться в большое неистовое море.]],
    enter = function(s)
        es.stopMusic(5000)
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я оборачиваюсь, махаю Вере рукой, но она на меня не смотрит."
            return false
        end
    end,
    obj = { "wave1" },
    way = {
        path { "Отойти", "main" }
    }
}

es.obj {
    nam = "wave1",
    done = 0,
    dsc = "{Волны} накатывают на песок, утаскивая в зеленоватую воды мелкие камешки и битые ракушки.",
    act = function(s)
        walkin("pause2")
        return true
    end
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    pause = 80,
    enter = function(s)
        es.music("santorum", 10, 0, 4000)
    end,
    next = "shore2"
}
-- endregion

-- region shore2
es.room {
    nam = "shore2",
    pic = "dream/burst1",
    disp = "У берега",
    dsc = [[Я стою на берегу.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я оборачиваюсь, махаю Вере рукой, но она на меня не смотрит."
            return false
        end
    end,
    obj = { "wave2" },
    way = {
        path { "Отойти", "main" }
    }
}

es.obj {
    nam = "wave2",
    done = false,
    dsc = [[Я смотрю на тающий в седой дымке горизонт. Небо, если долго вглядываться вдаль, почти неотличимо от воды, как будто я внутри картины, которую забыл дописать художник.
    ^{Волны} пенятся, окатывая холодом босые ноги.]],
    act = function(s)
        walkin("pause3")
        return true
    end
}
-- endregion

-- region pause3
es.room {
    nam = "pause3",
    pause = 50,
    next = "shore3"
}
-- endregion

-- region shore3
es.room {
    nam = "shore3",
    pic = "dream/burst2",
    disp = "У берега",
    dsc = [[Я стою на берегу.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я оборачиваюсь, махаю Вере рукой, но она на меня не смотрит."
            return false
        end
    end,
    obj = { "wave3" },
    way = {
        path { "Отойти", "main" }
    }
}

es.obj {
    nam = "wave3",
    done = false,
    dsc = [[{Волны} поднимаются выше, словно озеро и правда превратилось в море.
    ^Небо темнеет, наливается закатным багрянцем, который отражается в воде.]],
    act = function(s)
        walkin("pause4")
        return true
    end
}
-- endregion

-- region pause4
es.room {
    nam = "pause4",
    pause = 50,
    next = "interlude1"
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    pic = "common/nubolids1",
    disp = "У берега",
    dsc = [[Хочется уйти подальше от воды, но я не могу пошевелиться.
    ^Надо мной поднимается огромная штормовая волна.
    ^Я не могу пошевелиться.
    ^Вода отливает багрянцем.
    ^Нет.
    ^Она соткана из тонких красных нитей.
    ^Нуболиды!
    ^Крик застывает в горле. Волна нуболидов сметает меня. Алые, как боль, черви пронзают насквозь.]],
    next = "pause5"
}
-- endregion

-- region pause5
es.room {
    nam = "pause5",
    pause = 20,
    enter = function(s)
        es.music("violin")
    end,
    next = "cabin"
}
-- endregion

-- region cabin
es.room {
    nam = "cabin",
    pic = "ship/cabin",
    disp = "Каюта",
    dsc = [[Я просыпаюсь с надрывным хрипом. Боль свинцом разливается в лёгких. Я едва не задохнулся во сне.]],
    onexit = function(s, w)
        if w.nam == "main" and not all.amnion.done then
            p "Для начала нужно вылезти из этого проклятого спальника."
            return false
        elseif w.nam == "main" then
            p "Мне сейчас не до того."
            return false
        elseif w.nam == "pause6" and not all.amnion.done then
            p "Для начала нужно вылезти из этого проклятого спальника."
            return false
        elseif w.nam == "pause6" and not all.thoughts.done then
            p "Надо успокоиться, собраться с мыслями."
            return false
        end
    end,
    obj = { "amnion", "thoughts" },
    way = {
        path { "В душевую", "main" },
        path { "В коридор", "pause6" }
    }
}

es.obj {
    nam = "amnion",
    done = false,
    cnd = "not s.done",
    dsc = "Я барахтаюсь в липком {амнионе} под потолком каюты.",
    act = function(s)
        s.done = true
        return "Я наконец выбираюсь из приставучего спальника."
    end
}

es.obj {
    nam = "thoughts", 
    done = false,
    dsc = "Мне требуется несколько секунд на то, чтобы прийти в себя после кошмара, {собраться с мыслями}.",
    act = function(s)
        if not s.done then
            s.done = true
            return [[Всё в порядке, мы следуем к Антелле-12. Это был просто дурацкий сон.
            ^Мне надо проверить Веру.]]
        else
            return "Мне надо проверить Веру."
        end
    end
}
-- endregion

-- region pause6
es.room {
    nam = "pause6",
    pause = 60,
    enter = function(s)
        es.music("shutdown")
    end,
    next = "credits_roll"
}
-- endregion

-- region credits_roll
local config = {
    fps = 20,
    font = "theme/sans.ttf",
    size = 19,
    bg = "#1F1F1F",
    fg = "lightgray"
}

es.room {
    nam = "credits_roll",
    bg = "clean",
    counter = 0,
    enter = function(s)
        es.music("premonition", 2)
        timer:set(1000/config.fps)
    end,
    offset = 0,
    {
        cache = false,
        height = false
    },
    credits = {
        "",
        "ПЛАТФОРМА INSTEAD",
        "Пётр Косых",
        "",
        "",
        "СЦЕНАРИЙ",
        "Василий Воронков",
        "",
        "",
        "ПРОГРАММИРОВАНИЕ",
        "Василий Воронков",
        "",
        "",
        "МУЗЫКАЛЬНОЕ ОФОРМЛЕНИЕ",
        "Василий Воронков",
        "",
        "",
        "ТЕСТИРОВАНИЕ",
        "Олег Бош",
        "Пётр Косых",
        "",
        "",
        "ЗВУКОВЫЕ ЭФФЕКТЫ (freesound.org)",
        "gabemille74",
        "StephenSaldanha",
        "GowlerMusic",
        "Breviceps",
        "facuarmo",
        "gladkiy",
        "laffik",
        "Robinhood76",
        "RutgerMuller",
        "jobro",
        "tranzfusion",
        "jokallset",
        "thebraindrinker",
        "Joao_Janz",
        "giddster",
        "",
        "",
        "СИЛУЭТЫ ПЕРСОНАЖЕЙ",
        "NACreative @ Freepik",
        "",
        "",
        "ГРАФИЧЕСКОЕ ОФОРМЛЕНИЕ",
        "Garry's Mod",
        "Шедеврум",
        "Кандинский",
        "",
        "",
        "МОСКВА 2024"
    },
    make = function(s)
        local len = #s.credits
        local fnt = sprite.fnt(config.font, config.size)
        local height = fnt:height() * 1.2
        local theight = height * len
        local spr = es.sprite(400, theight, config.bg)
        local shift = 0
        for i,v in ipairs(s.credits) do
            if v ~= "" then
                fnt:text(v, config.fg):draw(spr, 0, shift)
            end
            shift = shift + height
        end
        return spr,theight
    end,
    timer = function(s)
        s.counter = s.counter + 1
        if s.counter == 2400 then
            es.stopMusic(1000)
            timer:stop()
            instead:restart()
        end
        s.offset = s.offset + 1
        if not s.cache then
            s.cache,s.height = s:make()
        end
        s.cache:copy(0, s.height - s.offset, 400, s.offset, sprite.scr(), 80, 0)
        return true
    end
}
-- endregion