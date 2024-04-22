-- Chapter 15
dofile "lib/es.lua"

es.main {
    chapter = "15",
    onenter = function(s)
        es.music("signal")
        walk("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/ship",
    disp = "Судовой отчёт",
    dsc = [[<b>Корабль:</b> ГКМ "Грозный"^
    <b>Порт приписки:</b> Байконур^
    <b>Экипаж:</b> три человека^
    <b>Дееспособный экипаж:</b> три человека^
    <b>Местоположение:</b> Сантори]],
    next = "ship1"
}
-- endregion

-- region ship1
es.room {
    nam = "ship1",
    mus = false,
    pic = "ship/corridor",
    disp = "Коридор корабля",
    dsc = [[Мы долго молчим -- словно соблюдаем траур.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я не могу сейчас просто взять и уйти."
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("whatif", 2)
        end
    end,
    obj = { "majorov1", "vera1" },
    way = {
        path { "В каюту", "main" },
        path { "В техотсек", "main" },
        path { "В медотсек", "main" },
        path { "В навигационный отсек", "main" },
        path { "В рубку", "main" }
    }
}

es.obj {
    nam = "majorov1",
    dsc = "{Майоров} сидит на полу перед телом Минаевой, обхватив голову.",
    act = function(s)
        if not all.vera1.done then
            return "Я не знаю, что ему сказать."
        else
            es.walkdlg("majorov.head")
            return true
        end
    end
}

es.obj {
    nam = "vera1",
    done = false,
    dsc = "{Вера} смотрит на него отрешённым взглядом.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.head")
            return true
        else
            return "Надо дать ей время успокоиться."
        end
    end
}
-- endregion

-- region ship2
es.room {
    nam = "ship2",
    pic = "ship/corridor",
    disp = "Коридор корабля",
    dsc = [[Я понимаю, о чём она хочет поговорить, и отдал бы сейчас всё за то, чтобы этот разговор не состоялся. Но выбора нет.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Мне нужно поговорить с Верой."
            return false
        end
    end,
    obj = { "vera2", "cold" },
    way = {
        path { "В каюту", "main" },
        path { "В техотсек", "main" },
        path { "В медотсек", "main" },
        path { "В навигационный отсек", "main" },
        path { "В рубку", "main" }
    }
}

es.obj {
    nam = "vera2",
    dsc = "{Вера} стоит напротив и молча смотрит на меня.",
    act = function(s)
        es.stopMusic(7000)
        es.walkdlg("vera.main")
        return true
    end
}

es.obj {
    nam = "cold",
    dsc = "{Холод} садит в спину.",
    act = "Я чувствую себя неуютно на собственном корабле."
}
-- endregion

-- region ship3
es.room {
    nam = "ship3",
    pic = "ship/corridor",
    disp = "Коридор корабля",
    dsc = [[Коридор белый, как на засвеченной фотографии. Я понимаю, что запомню этот момент на всю жизнь.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Мне нужно поговорить с Верой."
            return false
        end
    end,
    obj = { "vera3" },
    way = {
        path { "В каюту", "main" },
        path { "В техотсек", "main" },
        path { "В медотсек", "main" },
        path { "В навигационный отсек", "main" },
        path { "В рубку", "main" }
    }
}

es.obj {
    nam = "vera3",
    dsc = "{Вера} молча смотрит в пол, как приговорённая к казни.",
    act = function(s)
        es.walkdlg("vera.nav")
        return true
    end
}
-- endregion

-- region nav
es.room {
    nam = "nav",
    pic = "ship/nav",
    disp = "Навигационный отсек",
    dsc = [[Навигационный отсек кажется камерой для бессмысленных экспериментов -- особенно, сама капсула, стоящая на металлическом пьедестале, из которого выплетаются толстые гофрированные трубы.]],
    enter = function(s)
        es.stopMusic(3000)
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я хочу попрощаться с Верой."
            return false
        end
    end,
    obj = { "vera4", "capsule", "majorov2" },
    way = {
        path { "В коридор", "main" }
    }
}

es.obj {
    nam = "vera4",
    dsc = "{Вера} переоделась в лёгкую белую форму. Она сидит на краю открытой",
    act = function(s)
        es.walkdlg("vera.tail")
        return true
    end
}

es.obj {
    nam = "capsule",
    dsc = "{капсулы},",
    act = "Я почему-то вспоминаю о камере содержания."
}

es.obj {
    nam = "majorov2",
    dsc = "пока {Майоров} готовит для инъекции шприц.",
    act = "За всё это время он не проронил ни слова, точно утратил способность говорить."
}
-- endregion

-- region pre_cabin
es.room {
    nam = "pre_cabin",
    pause = 80,
    enter = function(s)
        es.music("sorrow", 20, 4000)
    end,
    next = "cabin"
}
-- endregion

-- region cabin
es.room {
    nam = "cabin",
    done = false,
    pic = "ship/cabin",
    disp = "Каюта",
    dsc = function(s)
        if not s.done then
            return [[Меня трясёт. Я вваливаюсь в каюту, качаясь, как мертвецки пьяный. Я не в силах сдерживаться. Я падаю на колени, размазывая слёзы по лицу.]]
        else
            return [[Каюту насквозь пронизывает химозный холод. Я быстро одеваюсь. Меня снова трясёт.]]
        end
    end,
    onexit = function(s, t)
        if t.nam == "shower" and s.done then
            p "Я уже принял душ."
            return false
        elseif t.nam == "ship4" and not s.done then
            p "Я бы хотел сначала принять душ."
            return false
        elseif t.nam == "ship4" and s.done and not all.pause1.seen then
            walkin("pause1")
            return false
        end
    end,
    obj = { "clothes", "drobe", "showerdoor" },
    way = {
        path { "В коридор", "ship4" },
        path { "В душевую", "shower" }
    }
}

es.obj {
    nam = "clothes",
    dsc = "Справа от меня -- {люк} с отсеком для хранения.",
    act = "Там, наверное, лежит моя форма."
}

es.obj {
    nam = "drobe",
    dsc = "Рядом с ним -- ещё одна {заслонка}, отмеченная по периметру броским красным пунктиром.",
    act = "Там хранится мой скафандр."
}

es.obj {
    nam = "showerdoor",
    dsc = "У выхода из каюты -- сдвигающая гармошкой {дверца} в душевую с сухой чисткой.",
    act = "Индивидуальная душевая -- настоящая роскошь для космического корабля."
}
-- endregion

-- region shower
es.room {
    nam = "shower",
    pic = "ship/shower",
    disp = "Душевая",
    dsc = [[Я раздеваюсь и пролезаю в душевую.
    ^Сначала я долго втираю в себя щелочной порошок, отдающий бытовой хлоркой -- так рьяно, словно хочу сжечь кожу, -- а потом долго строю под струёй затхлого воздуха.
    ^Воды в душевой нет, помыться можно только так.]],
    enter = function(s)
        es.sound("air")
        all.cabin.done = true
    end,
    way = {
        path { "В каюту", "cabin" }
    }
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    seen = false,
    noinv = true,
    pause = 100,
    enter = function(s)
        s.seen = true
        es.stopMusic(3000)
    end,
    next = "ship4"
}
-- endregion

-- region ship4
es.room {
    nam = "ship4",
    mus = false,
    pic = "ship/corridor",
    disp = "Коридор",
    dsc = [[На полу коридора осталось несколько красных пятен. Я стараюсь не смотреть еа них.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("anticipation", 1)
        end
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Мне надо помочь Майорову."
            return false
        elseif t.nam == "nav" then
            p "Я не могу там находиться."
            return false
        end
    end,
    way = {
        path { "В каюту", "cabin" },
        path { "В техотсек", "main" },
        path { "В медотсек", "main" },
        path { "В навигационный отсек", "nav" },
        path { "В рубку", "deck" }
    }
}
-- endregion

-- region deck
es.room {
    nam = "deck",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[Кажется, что капитан заканчивает вахту, я только что проснулся от тяжёлого изматывающего сна, а остальной экипаж отдыхает в своих каютах.]],
    obj = { "majorov3" },
    way = {
        path { "В коридор", "ship4" }
    }
}

es.obj {
    nam = "majorov3",
    done = false,
    dsc = "{Майоров} сидит в ложементе пилота и проверяет что-то в терминале. Рябящий экран отбрасывает на его лицо зелёную тень.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("majorov.order")
            return true
        else
            es.walkdlg("majorov.ask")
            return true
        end
    end,
    used = function(s, w)
        if (w.nam == "envelope" or w.nam == "order") and not s.done then
            s.done = true
            es.walkdlg("majorov.order")
            return true
        elseif (w.nam == "envelope" or w.nam == "order") and s.done then
            es.walkdlg("majorov.ask")
            return true
        end
    end
}

es.obj {
    nam = "envelope",
    disp = es.tool "Конверт",
    inv = function(s)
        take("order")
        purge("envelope")
        es.music("note")
        return "Я открываю край конверта и вытаскиваю из него бланк ядовито-жёлтого цвета."
    end
}

es.obj {
    nam = "order",
    disp = es.tool "Бланк приказа",
    inv = function(s)
        es.walkdlg("majorov.flight")
        return true
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        gamefile("game/16.lua", true)
    end
}
-- endregion