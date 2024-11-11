-- Chapter 12
dofile "lib/es.lua"

es.main {
    chapter = "12",
    onenter = function(s)
        es.music("violin")
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/station",
    seconds = 26,
    enter = function(s)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds - 1
        if s.seconds == 19 then
            timer:stop()
            es.music("bass")
            es.walkdlg {
                dlg = "vera",
                branch = "head",
                disp = "Коридор",
                pic = "station/corridor4"
            }
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    txt = "НИОС \"Кабирия\"^^",
    dsc = function(s)
        return string.format("%sОсталось до схода с орбиты: 03:02:%d", s.txt, all.intro1.seconds)
    end
}
-- endregion

-- region med_corridor
es.room {
    nam = "med_corridor",
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Здесь спокойно и тихо, как и должно быть на станции, где уставшие друг от друга люди заперлись в модулях с глухими дверями. Легко представить, что ничего не произошло, и мы не падаем в атмосферу газового гиганта.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p [[Лучше подождать здесь. Сейчас многие на станции относятся к членам команды "Грозного" напряжённо.]]
            return false
        end
    end,
    obj = { "med_vera", "med_minaeva", "await", "grigoriev" },
    way = {
        path { "В медблок", "main" }
    }
}

es.obj {
    nam = "med_vera",
    cnd = "{grigoriev}.done",
    dsc = "{Вера} и",
    act = "Бинт на щеке ей заменили. Я смотрю на Веру и чувствую себя так, словно это именно я виноват в том, что произошло."
}

es.obj {
    nam = "med_minaeva",
    cnd = "{grigoriev}.done",
    dsc = "{Минаева} обсуждают что-то вполголоса, как заговорщики.",
    act = function(s)
        es.music("lotus", 1, 0, 3000)
        es.walkdlg("minaeva.vera")
        return true
    end
}

es.obj {
    nam = "await",
    done = false,
    cnd = "not s.done",
    dsc = "Я нетерпеливо расхаживаю перед дверью в медблок, {дожидаясь} Веру.",
    act = function(s)
        s.done = true
        return "Из конца коридора доносятся чьи-то обеспокоенные голоса. Вскоре в бледном свете уставших ламп вырисовывается человеческая фигура. Я не сразу узнаю Григорьева."
    end
}

es.obj {
    nam = "grigoriev",
    done = false,
    cnd = "{await}.done",
    dsc = "{Григорьев} стоит спиной к узким иллюминаторам, в которые всё ещё проскальзывает колючий свет Сантори, и смотрит на меня с доброжелательной улыбкой.",
    act = function(s)
        if s.done then
            return "Я думаю, мы уже всё обсудили."
        else
            s.done = true
            es.music("dali", 1, 0, 3000)
            es.walkdlg("grigoriev.head")
            return true
        end
    end
}
-- endregion

-- region intense1
es.room {
    nam = "intense1",
    leave = false,
    mus = false,
    need_mus = false,
    pic = "station/intense1",
    disp = "Реанимационная (отсек 1)",
    dsc = [[Реанимационная неожиданно напоминает отсек навигации на "Грозном" -- даже освещение и собирающиеся по углам, как морщины, тени. Пользуются реанимационной наверняка не слишком часто -- в воздухе витает поблёскивающая пыль, которую гоняют ожившие с нашим приходом воздуховоды.]],
    onexit = function(s, t)
        if t.nam == "intense_corridor" and not s.leave
            and not all.xray_snapshot.done then
            s.leave = true
            es.walkdlg("vera.leave")
            return false
        end
    end,
    preact = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("overcome")
        elseif s.need_mus then
            s.need_mus = false
            es.music("whatif", 2, 0, 3000)
        end
    end,
    obj = {
        "comm",
        "vera",
        "desk",
        "monitor",
        "coffee",
        "xray",
        "locker1",
        "capsule",
        "capsule_comp",
        "snapshot4_holder",
        "xray_snapshot"
    },
    way = {
        path { "В коридор", "intense_corridor" },
        path { "В отсек 2", "intense2" }
    }
}

es.obj {
    nam = "comm",
    dsc = "На стене у входа висит {интерком} с треснувшей бакелитовой трубкой.",
    act = "Мне сейчас не нужно никому звонить."
}

es.obj {
    nam = "vera",
    xray = false,
    dsc = function(s)
        if not all.xray_snapshot.done then
            return "{Вера}"
        else
            return "{Вера} вытирает кофе со стола."
        end
    end,
    act = function(s)
        if all.xray_snapshot.done then
            return "Мы уже всё обсудили, лучше не терять времени."
        elseif s.xray then
            es.walkdlg("vera.intense")
            return true
        else
            es.walkdlg("vera.xray")
            return true
        end
    end
}

es.obj {
    nam = "desk",
    cnd = "not {xray_snapshot}.done",
    dsc = "стоит у высокого стола со стареньким потрескивающим {ВА}.",
    act = function(s)
        return "Не стоит мешать Вере."
    end,
    used = function(s, w)
        if w.nam == "terminal_key" then
            return "Не стоит мешать Вере."
        end
    end
}

es.obj {
    nam = "monitor",
    done = false,
    cnd = "not {xray_snapshot}.done",
    dsc = "Мерцающий, точно в истерическом припадке, {монитор} доживает последние дни.",
    act = function(s)
        if s.done then
            return "От такого монитора быстро разболится голова."
        else
            s.done = true
            es.walkdlg("vera.monitor")
            return true
        end
    end
}

es.obj {
    nam = "coffee",
    cnd = "{vera}.xray and not {xray_snapshot}.done",
    dsc = "На нём примостился пластиковый {стаканчик с кофе}, который забыла Минаева.",
    act = "Да, кофе бы сейчас не помешал."
}

es.obj {
    nam = "xray",
    light = false,
    snapshot = false,
    dsc = function(s)
        local txt = "На стене рядом висит массивный {негатоскоп}"
        if s.light then
            txt = txt..", который ярко светится, как огромная лампа."
        else
            txt = txt.."."
        end
        return txt
    end,
    act = function(s)
        if not s.light then
            s.light = true
            return "Я щёлкаю переключателем, и негатоскоп наливается светом."
        else
            s.light = false
            return "Я выключаю негатоскоп."
        end
    end,
    used = function(s, w)
        if w.kind == "snapshot" and not s.light then
            return "Надо сначала включить световую панель."
        elseif w.nam == "snapshot4" then
            purge("snapshot4")
            s.snapshot = true
            return "Я вешаю снимок на панель негатоскопа."
        elseif w.kind == "snapshot" then
            if w.nam == "snapshot2" then
                all.vera.xray = true
            end
            purge(w.nam)
            es.walkdlg("vera." .. w.nam)
            return true
        elseif w.nam == "magnet" then
            return "Для того, чтобы закрепить на панели снимок, магнит не нужен."
        end
    end
}

es.obj {
    nam = "xray_snapshot",
    done = false,
    cnd = "{xray}.light and {xray}.snapshot",
    dsc = [[^^На светящейся панели негатоскопа приклеен {рентгеновский снимок} навигатора с "Грозного".]],
    act = function(s)
        if all.snapshot4_holder.bad then
            all.xray.snapshot = false
            return "На снимке ничего не получается разглядеть, видимо, я напутал что-то с настройками."
        elseif s.done then
            return "На первый взгляд ничего необычного не видно, особенно, если не привык разглядывать рентгеновские снимки. Лишь спустя несколько секунд замечаешь, что сердце на снимке оплетено тонкой нитью, точно терновником."
        else
            s.done = true
            purge("snapshot1")
            purge("snapshot2")
            purge("snapshot3")
            purge("snapshot4")
            purge("terminal_key")
            purge("pincer")
            purge("cup")
            es.music("premonition", 2, 0, 3000)
            es.walkdlg("vera.nubolid")
            return true
        end
    end
}

es.obj {
    nam = "locker1",
    dsc = "Прямо под ним -- низкий металлический {шкаф} с двумя дверцами.",
    act = "Шкафчик, к счастью, не заперт на ключ -- я открываю дверцу, но внутри нет ничего, кроме толстых папок с документами. Они нам сейчас без надобности."
}

es.obj {
    nam = "capsule",
    done = false,
    dsc = "Чуть дальше, ближе к двери в соседний отсек, стоит {медицинская капсула}. Из-за неё сходство реанимационной с отсеком навигации становится даже немного пугающим.",
    act = function(s)
        if s.done then
            return "Впрочем, жизнь навигатора на поздних стадиях мало чем отличается от медицинской комы, так что сходство неудивительно."
        else
            s.done = true
            return [[Наполовину сделанный из стекла саркофаг траурно затянут тенью -- нужно подойти и коснуться забрала ладонью, чтобы темнота рассеялась.
            ^Несколько секунд я стою и смотрю на капсулу, как будто хочу убедиться в том, что она мне не мерещится. Потом кладу на стеклянную крышку руку. Тень мгновенно спадает, как погребальный саван, но смотреть на тело навигатора я почему-то не могу.
            ^Я отворачиваюсь и отхожу от капсулы.]]
        end
    end
}

es.obj {
    nam = "capsule_comp",
    unlocked = false,
    dsc = "В капсулу встроен {терминал} с небольшим заплывшим от грязи экраном.",
    act = function(s)
        if not all.vera.xray or all.xray_snapshot.done then
            return "Нет времени возиться с терминалом, у меня есть другие дела."
        else
            s.unlocked = false
            walkin("capsule.terminal")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "terminal_key" and all.xray_snapshot.done then
            return "Нет времени возиться с терминалом, у меня есть другие дела."
        elseif w.nam == "terminal_key" then
            s.unlocked = true
            walkin("capsule.terminal")
            return true
        end
    end
}

es.obj {
    nam = "snapshot4_holder",
    bad = false,
    ready = false,
    cnd = "s.ready",
    dsc = "Из прорези в терминале торчит {рентгеновский снимок}.",
    act = function(s)
        s.ready = false
        take("snapshot4")
        return "Я беру рентгеновский снимок."
    end
}

es.obj {
    nam = "snapshot4",
    kind = "snapshot",
    disp = es.tool "Рентгеновский снимок",
    inv = "Рентгеновский снимок, который я только что сделал. Надо проверить его на негатоскопе."
}

es.terminal {
    nam = "capsule.terminal",
    locked = function(s)
        return not all.capsule_comp.unlocked
    end,
    vars = {
        lux = 0,
        contrast = 0,
        temp = 0,
        snapshot = false,
        lux_on = false,
        contrast_on = false,
        xray_on = false,
        snapshot_bad = false
    },
    commands_help = {
        lux = "настройка освещения",
        contrast = "настройка контраста",
        man = "настройка аппарата для рентгеновских снимков",
        xray = "рентгеновский снимок",
        print = "печать снимков",
        status = "получение данных о пациенте",
        control = "включение сервисов капсулы"
    },
    onoff = function(s, b)
        if b then
            return "включён"
        else
            return "выключен"
        end
    end,
    commands = {
        control = function(s, args, load)
            local arg = tonumber(s:arg(args))
            if not arg or arg < 0 or arg > 4 then
                local str = "Некорректный индекс системы."
                if not arg then
                    str = "Не задан индекс системы."
                end
                return {
                    str,
                    "",
                    "Доступные системы:",
                    string.format("[1] Сервис освещения: %s", s:onoff(s.vars.lux_on)),
                    string.format("[2] Сервис контраста: %s", s:onoff(s.vars.contrast_on)),
                    string.format("[3] Сервис печати: %s", s:onoff(s.vars.printer_on)),
                    string.format("[4] Рентгеновский сканер: %s", s:onoff(s.vars.xray_on)),
                    "",
                    "Синтакис:",
                    "control [индекс системы]"
                }
            end
            if not load then
                return "$load"
            end
            if arg == 1 then
                s.vars.lux_on = not s.vars.lux_on
                if s.vars.lux_on then
                    s.vars.temp = s.vars.temp + 4
                else
                    s.vars.temp = s.vars.temp - 4
                end
                return string.format("Сервис освещения: %s.", s:onoff(s.vars.lux_on))
            elseif arg == 2 then
                s.vars.contrast_on = not s.vars.contrast_on
                if s.vars.contrast_on then
                    s.vars.temp = s.vars.temp + 2
                else
                    s.vars.temp = s.vars.temp - 2
                end
                return string.format("Сервис контраста: %s.", s:onoff(s.vars.contrast_on))
            elseif arg == 3 then
                s.vars.printer_on = not s.vars.printer_on
                if s.vars.printer_on then
                    s.vars.temp = s.vars.temp + 3
                else
                    s.vars.temp = s.vars.temp - 3
                end
                return string.format("Сервис печати: %s.", s:onoff(s.vars.printer_on))
            elseif arg == 4 then
                s.vars.xray_on = not s.vars.xray_on
                if s.vars.xray_on then
                    s.vars.temp = s.vars.temp + 2
                else
                    s.vars.temp = s.vars.temp - 2
                end
                return string.format("Рентгеновский сканер: %s.", s:onoff(s.vars.xray_on))
            end
        end,
        man = function(s)
            return {
                "Настройки контраста:",
                "Для рентгена сердца: 16 цт",
                "Для рентгена остальных внутренних органов: 12 цт",
                "Для рентгена костей требуется контраст: 8 цт",
                "",
                "Настройки освещения:",
                "При уровне контраста 01 -- 07 цт: 300 лм",
                "При уровне контраста 08 -- 11 цт: 400 лм",
                "При уровне контраста 12 -- 15 цт: 500 лм",
                "При уровне контраста 16 -- 19 цт: 600 лм",
                "При уровне контраста 20 -- 23 цт: 700 лм",
                "При уровне контраста 24 -- 27 цт: 800 лм",
                "При уровне контраста 28 -- 31 цт: 900 лм",
                "При уровне контраста 32 -- 35 цт: 1000 лм",
                "При уровне контраста 36 -- 39 цт: 1100 лм",
                "При уровне контраста 40 -- 43 цт: 1200 лм",
                "При уровне контраста 44 -- 47 цт: 1300 лм",
                "При уровне контраста 48 -- 51 цт: 1400 лм",
                "При уровне контраста 52 -- 55 цт: 1500 лм",
                "При уровне контраста 56 -- 59 цт: 1600 лм",
                "",
                "При температуре объекта выше 0 градусов по Цельсию на каждый градус",
                "увеличивать значение контраста на 1. Например, для рентгена костей при",
                "температуре 10 градусов требуется контраст 18 цт.",
                "Внимание! Активация дополнительного оборудования изменяет температуру",
                "объекта!"
            }
        end,
        status = function(s, args, load)
            if not load then
                return "$load"
            end
            return {
                "Режим капсулы: гибернация",
                "Статус пациента:",
                "Внимание! Жизненная активность отсутствует!",
                "",
                string.format("Температура тела: %d по Цельсию.", s.vars.temp)
            }
        end,
        contrast = function(s, args, load)
            if not s.vars.contrast_on then
                return "Система контраста отключёна."
            end
            local lvl = tonumber(s:arg(args))
            if not lvl then
                if not load then
                    return "$load"
                end
                return {
                    "Текущий уровень контраста:",
                    tostring(s.vars.contrast).." цт",
                    "",
                    "Синтаксис:",
                    "contrast [уровень контраста]",
                    "Допустимые значения уровня контраста: от 0 до 25"
                }
            elseif lvl < 0 or lvl > 25 then
                return {
                    "Недопустимое значение уровня контраста.",
                    "Допустимые значения уровня контраста: от 0 до 25"
                }
            else
                if not load then
                    return "$load"
                end
                s.vars.contrast = lvl
                return {
                    "Уровень контраста успешно изменён.",
                    "Текущий уровень контраста:",
                    tostring(s.vars.contrast) .. " цт"
                }
            end
        end,
        lux = function(s, args, load)
            if not s.vars.lux_on then
                return "Система освещения отключёна."
            end
            local lvl = tonumber(s:arg(args))
            if not lvl then
                if not load then
                    return "$load"
                end
                return {
                    "Текущий уровень освещённости:",
                    tostring(s.vars.lux).." лм",
                    "",
                    "Синтаксис:",
                    "lux [уровень освещённости]",
                    "Допустимые значения уровня освещённости: от 0 до 1600"
                }
            elseif lvl < 0 or lvl > 1600 then
                return {
                    "Недопустимое значение уровня освещённости.",
                    "Допустимые значения уровня освещённости: от 0 до 1600"
                }
            else
                if not load then
                    return "$load"
                end
                s.vars.lux = lvl
                return {
                    "Уровень освещённости успешно изменён.",
                    "Текущий уровень освещённости:",
                    tostring(s.vars.lux).." лм",
                }
            end
        end,
        xray = function(s, args, load)
            if not s.vars.xray_on then
                return "Рентгеновский сканер отключён."
            end
            if not load then
                return "$load"
            end
            local str = "abcdefghijklmnopqrstuvwxyz"
            local knum = tostring(rnd(1, 99))
            if #knum == 1 then
                knum = "0"..knum
            end
            s.vars.snapshot = string.charAt(str, rnd(#str))..knum
            local contrast = s.vars.contrast
            local lux = 0
            if contrast > 31 and contrast < 36 then
                lux = 1000
            elseif contrast > 27 and contrast < 30 then
                lux = 900
            elseif contrast > 23 and contrast < 26 then
                lux = 800
            elseif contrast > 19 and contrast < 22 then
                lux = 700
            elseif contrast > 15 and contrast < 18 then
                lux = 600
            else
                lux = -1
            end
            all.snapshot4_holder.bad = (s.vars.contrast ~= 24 or lux ~= s.vars.lux)
            return string.format(
                "Рентгеновский снимок произведён и записан в буфер по ключу [%s].",
                s.vars.snapshot)
        end,
        print = function(s, args, load)
            if not s.vars.printer_on then
                return "Сервис печати отключён."
            end
            local arg = s:arg(args)
            if not arg or arg ~= s.vars.snapshot or not s.vars.snapshot then
                local str = ""
                if not arg then
                    es.sound("error")
                    str = "Не задан ключ буфера."
                elseif not s.vars.snapshot then
                    es.sound("error")
                    str = "Буфер для печати пуст."
                elseif arg ~= s.vars.snapshot then
                    es.sound("error")
                    str = string.format("Некорректный ключ буфера: [%s]", arg)
                end
                return {
                    str,
                    "",
                    "Синтакис:",
                    "print [ключ буфера]"
                }
            end
            if not load then
                return "$load"
            end
            all.snapshot4_holder.ready = true
            return "Снимок распечатан."
        end
    }
}

es.obj {
    nam = "terminal_key",
    disp = es.tool "Ключ-карта",
    inv = "Ключ-карта, открывающая доступ к вмонтированному в медицинскую капсулу терминалу."
}
-- endregion

-- region intense2
es.room {
    nam = "intense2",
    mus = false,
    pic = "station/intense2",
    disp = "Реанимационная (отсек 2)",
    dsc = [[Второй отсек реанимационной похож на основной -- и так же насквозь пропитан пылью. Потоки воздуха гоняют пыль над головой. Кажется, что я оказался в забытой кладовке.]],
    preact = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("fatigue2", 2)
        end
    end,
    obj = {
        "tray",
        "cup_holder",
        "pincer_holder",
        "board",
        "magnet_holder",
        "locker2",
        "locker2_lock",
        "locker2_magnet",
        "locker2_content",
        "snapshot1_holder",
        "snapshot2_holder",
        "snapshot3_holder",
    },
    way = {
        path { "В отсек 1", "intense1" }
    }
}

es.obj {
    nam = "tray",
    dsc = function(s)
        if all.pincer_holder.taken and all.cup_holder.taken then
            return "На привалившемся к стенке столе вместо ВА стоит жестяной {короб}."
        else
            return "На привалившемся к стенке столе вместо ВА стоит жестяной {короб}, где"
        end
    end,
    act = "Обычный короб, ничего интересного.",
    used = function(s, w)
        if w.nam == "magnet" then
            return "Думаю, сейчас не лучшее время, чтобы играть с магнитом."
        elseif w.nam == "pincer" then
            all.pincer_holder.taken = false
            purge("pincer")
            return "Я кладу пинцет обратно в короб."
        elseif w.nam == "cup" then
            all.cup_holder.taken = false
            purge("cup")
            return "Я бросаю стакан в короб."
        end
    end
}

es.obj {
    nam = "cup_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = function(s)
        if all.pincer_holder.taken then
            return "валяется пустой {пластиковый стакан}."
        else
            return "валяются пустой {пластиковый стакан} и"
        end
    end,
    act = function(s)
        take("cup")
        s.taken = true
        return "Я беру стакан."
    end
}

es.obj {
    nam = "cup",
    disp = es.tool "Пластиковый стакан",
    inv = "Пустой пластиковый стакан с плоским донцем."
}

es.obj {
    nam = "pincer_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = function(s)
        if all.cup_holder.taken then
            return "лежит {тонкий пинцет}."
        else
            return "{тонкий пинцет}."
        end
    end,
    act = function(s)
        s.taken = true
        take("pincer")
        return "Я забираю пинцет."
    end
}

es.obj {
    nam = "pincer",
    disp = es.tool "Пинцет",
    inv = "Небольшой пинцет с тонкими острыми концами."
}

es.obj {
    nam = "board",
    done = false,
    dsc = "Негатоскоп, как ни странно, заменяет обычная {маркерная доска} с серыми разводами, оставшимися от стёртых надписей.",
    act = function(s)
        local txt = [[На поверхности доски проступают призрачные очертания пронумерованного списка, выведенного суетливым размашистым почерком -- как будто кто-то записывал здесь распорядок дня, вроде того, что висел в моей каюте на "Грозном".]]
        if not s.done then
            s.done = true
            txt = txt .. "^Маркера в лотке, впрочем, нет -- вместо него там приютился круглый магнит."
        end
        return txt
    end,
    used = function(s, w)
        if w.nam == "magnet" then
            purge(w.nam)
            all.magnet_holder.taken = false
            return "Я возвращаю магнит в лоток."
        end
    end
}

es.obj {
    nam = "magnet_holder",
    taken = false,
    broken = false,
    cnd = "{board}.done and not s.taken",
    dsc = function(s)
        if not s.broken then
            return "На лотке для маркера лежит похожий на пуговицу {магнит} в ярко-красном пластиковом корпусе."
        else
            return "На лотке для маркера лежит {магнит}."
        end
    end,
    act = function(s)
        if not s.broken then
            s.broken = true
            return "Я пытаюсь взять магнит, тот в ответ трещит, и в руках у меня оказывается яркая пластиковая облатка."
        else
            return "Магнит на удивление сильный и тонкий, как монетка. Я пытаюсь содрать магнит с металлического лотка, но у меня никак не получается его подцепить."
        end
    end,
    used = function(s, w)
        if w.nam == "pincer" then
            s.taken = true
            take("magnet")
            return "С помощью пинцента отодрать магнит от лотка оказывается совсем не сложно."
        elseif w.nam == "cup" then
            return "Стакан здесь не поможет."
        end
    end
}

es.obj {
    nam = "magnet",
    disp = es.tool "Магнит",
    inv = "Круглый магнитик, с помощью которого можно прилепить к маркерной доске какую-нибудь заметку."
}

es.obj {
    nam = "locker2",
    examed = false,
    unlocked = false,
    uncapped = false,
    dsc = function(s)
        if s.uncapped then
            return "Под доской расположился невысокий металлический {шкаф} с двумя распахнутыми дверцами."
        elseif s.unlocked and not s.uncapped then
            return "Под доской расположился невысокий металлический {шкаф}."
        elseif not s.examed then
            return "Под доской расположился невысокий металлический {шкаф} -- такой же, как и в главном отсеке, с двумя распашными дверцами."
        else
            return "Под доской расположился невысокий металлический {шкаф} с двумя дверцами"
        end
    end,
    act = function(s)
        if not s.unlocked then
            s.examed = true
            return "К сожалению, дверцы заперты на замок, причём замок тут самый обычный, механический, с тонким язычком."
        elseif not s.uncapped then
            s.uncapped = true
            return "Я распахиваю дверцы шкафа."
        else
            s.uncapped = false
            return "Я закрываю дверцы шкафа."
        end
    end,
    used = function(s, w)
        if w.nam == "magnet" then
            return "Нет времени играться с магнитом."
        elseif w.kind == "snapshot" and not s.uncapped then
            return "Сложно положить что-то в открытый шкаф."
        elseif w.kind == "snapshot" and s.uncapped then
            purge(w.nam)
            local holder = _(w.nam .. "_holder")
            holder.taken = false
            return string.format("Я возвращаю рентген с пометкой \"%s\" обратно в шкаф.",
                holder.aff)
        end
    end
}

es.obj {
    nam = "locker2_lock",
    magnet = false,
    cnd = "{locker2}.examed and not {locker2}.unlocked",
    dsc = "которые закрыты на механический {замок}.",
    act = "Дверцу, конечно, можно выломать, но силу применять бы не хотелось. Минаева нас не поймёт.",
    used = function(s, w)
        if w.nam == "pincer" then
            return "Я не взломщик. Вряд ли у меня получится взломать замок с помощью пинцета."
        elseif w.nam == "cup" then
            return "От стакана в такой ситуации мало пользы."
        elseif w.nam == "magnet" then
            s.magnet = true
            purge("magnet")
            return "Я прилепляю магнит на дверцу рядом с замком."
        end
    end
}

es.obj {
    nam = "locker2_magnet",
    cnd = "{locker2_lock}.magnet and not {locker2}.unlocked",
    dsc = "У замка, на самом краю дверцы, прилеплен похожий на монетку {магнит}.",
    act = "Сдвинуть магнит пальцами никак не получается -- он слишком плоский, и я не могу за него зацепиться.",
    used = function(s, w)
        if w.nam == "pincer" then
            all.locker2_lock.magnet = false
            take("magnet")
            return "Я поддеваю магнитик пинцетом и -- он падает мне на ладонь."
        elseif w.nam == "cup" then
            all.locker2.unlocked = true
            return "Я прижимаю стакан донцем к двери и двигаю им магнит. Замок издаёт радостный щелчок. Дверцы больше не заперты."
        end
    end
}

es.obj {
    nam = "locker2_content",
    cnd = function(s)
        return all.locker2.uncapped and s:countTaken() < 3
    end,
    countTaken = function(s)
        local count = 0
        for i = 1, 3, 1 do
            if _("snapshot"..tostring(i).."_holder").taken then
                count = count + 1
            end
        end
        return count
    end,
    dsc = function(s)
        local count = s:countTaken();
        if count == 0 then
            return "Внутри шкафа, поверх папки с бумагами, лежат три рентгеновских снимка с выведенными маркером именами -- "
        elseif count == 1 then
            return "Внутри шкафа, поверх папки с бумагами, лежат два рентгеновских снимка с выведенными маркером именами -- "
        elseif count == 2 then
            return "Внутри шкафа, поверх папки с бумагами, лежит рентгеновский снимок с выведенным маркером именем -- "
        end
    end
}

local snapshot_base = {
    cnd = function(s)
        return all.locker2.uncapped and not s.taken
    end,
    dsc = function(s)
        local punc = ","
        local count = all.locker2_content:countTaken()
        if (s.index == 1 and count == 2) or (s.index == 2 and count > 1) or s.index == 3 then
            punc = "."
        end
        return "{"..s.aff.."}"..punc
    end,
    act = function(s)
        take("snapshot"..tostring(s.index))
        s.taken = true
        return string.format("Я беру рентген с пометкой: \"%s\".", s.aff)
    end,
    used = function(s, w)
        if w.kind == "snapshot" then
            purge(w.nam)
            local holder = _(w.nam.."_holder")
            holder.taken = false
            return string.format("Я кидаю рентгеновский снимок с пометкой \"%s\" на папку с бумагами.", holder.aff)
        end
    end
}

es.obj(snapshot_base) {
    nam = "snapshot1_holder",
    taken = false,
    aff = "Марина Рискова",
    index = 1
}

es.obj(snapshot_base) {
    nam = "snapshot2_holder",
    taken = false,
    aff = "Иванна Иванова",
    index = 2
}

es.obj(snapshot_base) {
    nam = "snapshot3_holder",
    taken = false,
    aff = "Анна Симонова",
    index = 3
}

local snap_base = {
    kind = "snapshot",
    disp = function(s)
        local holder = _(s.nam .. "_holder")
        return es.tool(string.format("Рентген (%s)", holder.aff))
    end,
    inv = function(s)
        local holder = _(s.nam .. "_holder")
        return string.format("Рентгеновский снимок с пометкой: \"%s\".", holder.aff)
    end
}

es.obj(snap_base) {
    nam = "snapshot1"
}

es.obj(snap_base) {
    nam = "snapshot2"
}

es.obj(snap_base) {
    nam = "snapshot3"
}
-- endregion

-- region intense_corridor
es.room {
    nam = "intense_corridor",
    mus = false,
    pic = "station/corridor5",
    disp = "Коридор",
    dsc = [[Я как будто ожидаю, что снова из складок темноты появится улыбающийся Григорьев с пластиковой бутылкой в руке и назовёт меня Олежкой -- но никого нет, даже Сантори больше не заглядывает в иллюминаторы.]],
    enter = function(s)
        if all.xray_snapshot.done then
            enable "#diner"
        end
        if not s.mus then
            s.mus = true
            es.music("horn", 1, 0, 5000)
        end
    end,
    obj = { "portholes" },
    way = {
        path { "В реанимационную", "intense1" },
        path { "#diner", "К столовой", "diner_corridor1" }:disable()
    }
}

es.obj {
    nam = "portholes",
    dsc = "{Иллюминаторы}, точно картины аванградистов, забирают в узкие металлические рамки практически идеальную темноту.",
    act = "Сантори снова скрылась от глаз, точно ушла в червоточину, и всё вокруг затянуло привычным мраком."
}
-- endregion

-- region diner_corridor1
es.room {
    nam = "diner_corridor1",
    mus = false,
    pic = "station/corridor1",
    disp = "Коридор",
    dsc = [[Я совсем забыл об усталости и иду быстрым размашистым шагом, но привычный уже коридор стал длиннее, словно всё пространство вокруг искажается, пока мы падаем в Сантори-5.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("bass", 1, 0, 3000)
        end
    end,
    obj = { "pair" },
    way = {
        path { "К реанимационной", "intense_corridor" },
        path { "К столовой", "diner_corridor2" }
    }
}

es.obj {
    nam = "pair",
    dsc = [[У стены, под льющимся с потолка светом, точно под софитами, стоят {мужчина и женщина}. Женщина закрыла ладонями лицо и беззвучно плачет. Мужчина говорит ей что-то шёпотом, поглаживая по плечу.]],
    act = "Лучше им не мешать."
}
-- endregion

-- region diner_corridor2
es.room {
    nam = "diner_corridor2",
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Наконец я добираюсь до столовой. Кажется, что я прошёл не меньше десятка пролётов.]],
    obj = { "door", "walls", "lamps" },
    way = {
        path { "К реанимационной", "diner_corridor1" },
        path { "В столовую", "diner" }
    }
}

es.obj {
    nam = "door",
    dsc = "Я стою перед {дверью}, но почему-то не решаюсь зайти.",
    act = "Столовая работает."
}

es.obj {
    nam = "walls",
    dsc = "По стенам проходит мелкая вибрация -- дрожь умирающих механизмов.",
    act = "Наверное, Мицюкин со своими людьми пытается сейчас завести двигательные блоки."
}

es.obj {
    nam = "lamps",
    dsc = "Мерцают {лампы}.",
    act = "От этого дико болят глаза."
}
-- endregion

-- region diner
es.room {
    nam = "diner",
    mus = false,
    pic = "station/diner",
    disp = "Столовая",
    dsc = function(s)
        if not all.efimova.done then
            return [[Я наконец решаюсь и захожу в столовую. Первое, что я чувствую -- резкий и горклый запах кофе.]]
        else
            return [[В столовой стоит резкий и горклый запах кофе.]]
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("countdown", 1, 0, 1000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "diner_corridor2" and not all.efimova.done then
            all.efimova.done = true
            es.walkdlg("efimova.head")
            return false
        elseif t.nam == "diner_corridor2" then
            p "Нет времени разгуливать по станции."
            return false
        elseif t.nam == "vending" and not all.efimova.done then
            all.efimova.done = true
            es.walkdlg("efimova.head")
            return false
        end
    end,
    obj = { "efimova", "coffeecup", "vera2" },
    way = {
        path { "В коридор", "diner_corridor2" },
        path { "К продуктовому автомату", "vending" }
    }
}

es.obj {
    nam = "efimova",
    done = false,
    cnd = "not s.done",
    dsc = "У самого входа я сталкиваюсь с {Ефимовой}, главврачом. Она смотрит на меня так, словно не ожидала увидеть на станции других людей.",
    act = function(s)
        s.done = true
        es.walkdlg("efimova.head")
        return true
    end
}

es.obj {
    nam = "coffeecup",
    cnd = "not {efimova}.done",
    dsc = "В руке у неё -- пластиковый {стаканчик с кофе}.",
    act = "Если мы правы, то кофе ей сейчас пить точно не стоит."
}

es.obj {
    nam = "vera2",
    cnd = "{efimova}.done",
    dsc = "{Вера} сидит на коленях и придерживает головой Ефимовой.",
    act = function(s)
        es.walkdlg("vera.tail")
        return true
    end
}
-- endregion

-- region vending
es.room {
    nam = "vending",
    pic = "station/diner",
    disp = "Продуктовый автомат",
    dsc = [[Продуктовый автомат больше всего напоминает промышленный рефрижератор и время от времени издаёт такой же низкочастотный гул.]],
    obj = { "coffeebutton" },
    way = {
        path { "Отойти", "diner" }
    }
}

es.obj {
    nam = "coffeebutton",
    dsc = "В глазах у меня двоится от волнения, удары сердца, точно эхом, отдаются в висках. Я не сразу нахожу кнопку с пометкой \"{Кофе}\".",
    act = function(s)
        walkin("outro1")
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
        gamefile("game/13.lua", true)
    end
}
-- endregion