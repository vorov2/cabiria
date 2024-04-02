-- Chapter 15
dofile "lib/es.lua"

es.main {
    chapter = "15",
    onenter = function(s)
        walk("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    disp = "Судовой отчёт",
    dsc = [[^<b>Корабль:</b>^ ГКМ "Грозный"^^
    <b>Порт приписки:</b>^ Байконур^^
    <b>Экипаж:</b>^ три человека^^
    <b>Дееспособный экипаж:</b>^ три человека^^
    <b>Местоположение:</b>^ Сантори]],
    next = "ship1"
}
-- endregion

-- region ship1
es.room {
    nam = "ship1",
    disp = "Коридор корабля",
    dsc = [[Мы долго молчим -- словно соблюдаем траур.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я не могу сейчас просто взять и уйти."
            return false
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
    dlg = "14/majorov",
    branch = "head",
    dsc = "{Майоров} сидит на полу перед телом Минаевой, обхватив голову.",
    act = function(s)
        if not all.vera1.done then
            return "Я не знаю, что ему сказать."
        else
            walkin(s.dlg)
            return true
        end
    end
}

es.obj {
    nam = "vera1",
    done = false,
    dlg = "14/vera",
    branch = "head",
    dsc = "{Вера} смотрит на него пустым отрешённым взглядом.",
    act = function(s)
        if not s.done then
            s.done = true
            walkin(s.dlg)
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
    disp = "Коридор корабля",
    dsc = [[Я понимаю, о чём она хочет поговорить и отдал бы сейчас всё за то, чтобы этого разговора не состоялось.]],
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
    dlg = "14/vera",
    branch = "main",
    dsc = "{Вера} стоит напротив и молча смотрит на меня.",
    act = function(s)
        walkin(s.dlg)
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
    dlg = "14/vera",
    branch = "nav",
    dsc = "{Вера} молча смотрит в пол, словно приговорённая к казни.",
    act = function(s)
        walkin(s.dlg)
        return true
    end
}
-- endregion

-- region nav
es.room {
    nam = "nav",
    disp = "Навигационный отсек",
    dsc = [[Навигационный отсек кажется мне камерой для чудовищных экспериментов -- особенно сама капсула, стоявая на металлическом пьедестале, из которого выплетаются толстые гофрированные трубы.]],
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
    dlg = "14/vera",
    branch = "tail",
    dsc = "{Вера} переоделась в лёгкую белую форму. Она сидит на краю открытой",
    act = function(s)
        walkin(s.dlg)
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
    act = "За всё это время он не проронил ни слова, как будто утратил способность к речи."
}
-- endregion

-- region cell
es.room {
    nam = "cell",
    done = false,
    disp = "Каюта",
    dsc = function(s)
        if not s.done then
            return [[Меня трясёт. Я вваливаюсь в свою каюту, качаясь, как мертвецки пьяный. Я не в силах сдерживаться. Я падаю на колени, размазывая слёзы по лицу.]]
        else
            return [[Каюту насквозь пронизывает резкий химический холод. Я быстро одеваюсь. Меня снова трясёт.]]
        end
    end,
    onexit = function(s, t)
        if t.nam == "shower" and s.done then
            p "Я уже принял душ."
            return false
        elseif t.nam == "ship4" and not s.done then
            p "Я бы хотел сначала принять душ."
            return false
        end
    end,
    obj = { "clothes", "drobe", "showerdoor" },
    way = {
        path { "В душевую", "shower" },
        path { "В коридор", "ship4" }
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
    disp = "Душевая",
    dsc = [[Я раздеваюсь и пролезаю в душевую.
    ^Сначала я долго втираю в себя едкий щелочной порошок, отдающий бытовой хлоркой -- так рьяно, словно хочу сжечь кожу, -- а потом долго строю под струёй затхлого воздуха.
    ^Воды в душевой нет, помыться можно только так.]],
    onenter = function(s)
        all.cell.done = true
    end,
    way = {
        path { "В каюту", "cell" }
    }
}
-- endregion

-- region ship4
es.room {
    nam = "ship4",
    disp = "Коридор",
    dsc = [[На полу коридора осталось несколько красных пятен. Я стараюсь на них не смотреть.]],
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
        path { "В каюту", "cell" },
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
    disp = "Рубка",
    dsc = [[Свет в рубке такой же яркий, как и в навигационном отсеке. Кажется, корабль хочет выжечь мне глаза. Я прикрываюсь от света ладонью.]],
    obj = { "majorov3" },
    way = {
        path { "В коридор", "ship4" }
    }
}

es.obj {
    nam = "majorov3",
    done = false,
    dlg = "14/majorov",
    branch = function(s)
        if not s.done then
            return "order"
        else
            return "ask"
        end
    end,
    dsc = "{Майоров} сидит в ложементе пилота и проверяет что-то в терминале. Рябящий экран отбрасывает на его лицо зелёную тень.",
    act = function(s)
        walkin(s.dlg)
        return true
    end,
    used = function(s, w)
        if w.nam == "envelope" or w.nam == "order" then
            walkin(s.dlg)
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
    onenter = function(s)
        gamefile("game/15.lua", true)
        return true
    end
}
-- endregion