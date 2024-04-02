-- Tutorial
dofile "lib/es.lua"

es.main {
    chapter = "tutorial",
    onenter = function(s)
        walkin("pause1")
    end
}

-- region pause1
es.room {
    nam = "pause1",
    pause = 50,
    noinv = true,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = "chamber1"
}
-- endregion

-- region chamber1
es.room {
    nam = "chamber1",
    mus = false,
    disp = "Учебная комната",
    pic = "tutorial/chamber1",
    dsc = [[В игре вам необходимо взаимодействовать с предметами на сцене и в инвентаре, а также решать задачи с помощью вычислительной техники (например, вводить команды в терминале). Здесь нет ничего сложного.
    Предметы на игровой сцене, с которыми можно взаимодействовать, представлены в виде гиперссылок.]],
    enter = function(s)
        if not s.mus then
            es.loopMusic("hope")
        end
    end,
    onexit = function(s, t)
        if t.nam == "chamber2" and not all.door.unlocked then
            p "Дверь в соседнюю комнату закрыта, возможно нам тут поможет терминал."
            return false
        end
    end,
    obj = {
        "walls",
        "painting",
        "desk",
        "box_holder",
        "card",
        "comp",
        "door"
    },
    way = {
        path { "В соседнюю комнату", "chamber2" }
    }
}

es.obj {
    nam = "walls",
    dsc = "Вы находитесь в пустой комнате с {некрашеными} стенами.",
    act = "Стоит, наверное, покрасить их в какой-нибудь дружелюбный цвет.",
    used = function(s, w)
        if w.nam == "box" or w.nam == "card" or w.nam == "key" then
            return "Кажется, мы занимаемся чем-то не тем."
        end
    end
}

es.obj {
    nam = "painting",
    dsc = "На стене висит {картина}.",
    act = [[Здесь вы увидите описание картины -- например, большая станция на орбите синевого газового гиганта. Но будьте внимательны! Иногда в таких описаниях содержится полезная для прохождения информация.
    ^Описания интерактивных предметов всегда выводятся в область общего описания сцены. Если вы хотите вернуть общее описания, щёлкните на названии сцены над иллюстрацией.]],
    used = function(s, w)
        if w.nam == "box" then
            return "Не представляю, что можно сделать со шкатулкой и картиной."
        elseif w.nam == "card" then
            return "Чем нам тут поможет карта?"
        elseif w.nam == "key" then
            return "Это просто картина, а не тайная дверь от сейфа."
        end
    end
}

es.obj {
    nam = "desk",
    dsc = function(s)
        if not all.box_holder.taken then
            return "Посреди комнаты стоит офисный {стол},"
        else
            return "Посреди комнаты стоит офисный {стол}."
        end
    end,
    act = "Стол как стол, рассматривать тут решительно нечего.",
    used = function(s, w)
        if w.nam == "box" then
            all.box_holder.taken = false
            purge("box")
            return "Вы кладёте шкатулку обратно на стол."
        end
    end
}

es.obj {
    nam = "box_holder",
    done = false,
    taken = false,
    cnd = "not s.taken",
    dsc = "на котором лежит {шкатулка}.",
    act = function(s)
        s.taken = true
        take("box")
        if not s.done then
            s.done = true
            return [[Вы берёте со стола шкатулку. Обратите внимание, теперь она у вас инвентаре, в списке в правой части экрана.
            ^Если вы щёлкнете на предмете из инвентаря один раз, то войдёте в режим использования предмета. Например, вы можете положить шкатулку обратно на стол. Если щёлкнуть на предмете дважды, то можно увидеть его подробное описание, или же совершить с ним какое-либо действие.
            ^Предметом из инвентаря можно воздействовать как на предметы в сцене, так и в самом инвентаре.
            ^Наша цель -- открыть шкатулку, и тогда обучение закончится. Но так просто это не получится! Интересно, что находится в соседней комнате.]]
        else
            return "Вы берёте со стола шкатулку."
        end
    end
}

es.obj {
    nam = "box",
    disp = es.tool "Шкатулка",
    inv = "Шкатулка закрыта на ключ, так просто её не откроешь!",
    used = function(s, w)
        if w.nam == "key" then
            walkin("outro1")
            return true
        elseif w.nam == "card" then
            return "Боюсь, открыть шкатулку картой не получится."
        end
    end
}

es.obj {
    nam = "card",
    disp = es.tool "Ключ-карта",
    dsc = "На полу валяется чья-то потерянная {ключ-карта}.",
    tak = "Вы поднимаете ключ-карту.",
    inv = "С помощью этой ключ-карты можно получить доступ к вычислительному аппарату.",
    used = function(s, w)
        if w.used then
            return w:used(s)
        end
    end
}

es.obj {
    nam = "comp",
    unlocked = false,
    dsc = "У стены можно заметить {вычислительный аппарат} с мерцающим монитором.",
    act = "ВА нужно разблокировать с помощью ключ-карты.",
    used = function(s, w)
        if w.nam == "card" then
            s.unlocked = true
            walkin("comp.terminal")
            return true
        end
    end
}

es.terminal {
    nam = "comp.terminal",
    locked = function(s)
        return all.comp.locked
    end,
    commands_help = {
        open = "открывает двери"
    },
    commands = {
        open = function(s, args, load)
            local arg = tonumber(s:arg(args))
            if not arg then
                return {
                    "Боюсь, вы забыли указать номер двери в качестве аргумента.",
                    "Например, так: open 1"
                }
            elseif arg < 0 or arg > 1 then
                return "Так-так, а какая цифра нарисована на двери?"
            end
            if all.door.unlocked then
                return "Но ведь дверь уже открыта!"
            end
            if not load then
                return "$load"
            end
            all.door.unlocked = true
            return "Всё получилось! Теперь можно идти в соседнюю комнату!"
        end
    },
    welcome = {
        "Здесь вам нужно вводить команды, команды могут принимать аргументы.",
        "Начать работу с терминалом можно с команды HELP, которая выведет",
        "список остальных доступных команд, а закончить - командой EXIT,",
        "которая вернёт вас обратно в комнату."
    }
}

es.obj {
    nam = "door",
    unlocked = false,
    dsc = "В дальнем конце комнаты есть {дверь}, на которой нарисована цифра \"1\".",
    act = function(s)
        if not s.unlocked then
            return "Дверь в соседнюю комнату закрыта, возможно нам тут поможет терминал."
        else
            return "Дверь открыта, можно зайти в соседнюю комнату."
        end
    end,
    used = function(s, w)
        if w.nam == "card" then
            return "Карта так не работает."
        elseif w.nam == "key" then
            return "Этот ключ явно не от двери, да и дверь уже открыта."
        end
    end
}
-- endregion

-- region chamber2
es.room {
    nam = "chamber2",
    disp = "Ещё одна учебная комната",
    pic = "tutorial/chamber2",
    dsc = [[А эта комната совсем пустая, здесь даже мебели никакой нет. Её совсем забыли обставить! Неужели кто-то не доделал обучение?]],
    obj = { "key" },
    way = {
        path { "Выйти", "chamber1" }
    }
}

es.obj {
    nam = "key",
    disp = es.tool "Ключ",
    dsc = "Впрочем, если приглядеться, то можно заметить, что на полу валяется маленький {ключ}.",
    inv = "Интересно, от чего он?",
    tak = "Вы поднимаете ключ.",
    used = function(s, w)
        if w.nam == "box" then
            walkin("outro1")
            return true
        end
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    pic = "tutorial/chamber1",
    disp = "Конец обучения",
    dsc = [[Поздравляем! Вы прошли обучение! Теперь можно смело приниматься за игру.
    ^Но погодите...
    ^А что было в шкатулке? Не открыли ли мы ящик Пандоры?]],
    next = "outro2"
}
-- endregion

-- region outro2
es.room {
    nam = "outro2",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        instead.restart()
    end
}
-- endregion