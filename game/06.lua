-- Chapter 6
dofile "lib/es.lua"

es.main {
    chapter = "6",
    onenter = function(s)
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/station",
    seconds = 42,
    enter = function(s)
        es.music("violin")
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds + 1
        if s.seconds == 47 then
            es.music("dali", 1, 0, 3000)
            timer:stop()
            es.walkdlg {
                dlg = "kofman",
                branch = "head",
                disp = "Коридор",
                pic = "ship/corridor"
            }
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    template = "НИОС \"Кабирия\"^День второй^^14:31:%s",
    dsc = function(s)
        return string.format(s.template, all.intro1.seconds)
    end
}
-- endregion

-- region corridor
es.room {
    nam = "corridor",
    pic = "ship/corridor",
    disp = "Коридор",
    dsc = [[Я стою посреди коридора, соединяющего отсеки.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Надо бы сначала закончить работу."
            return false
        end
    end,
    obj = { "kofman" },
    way = {
        path { "В шлюз", "main" },
        path { "В каюту", "cabin" },
        path { "В техотсек", "tech" },
        path { "В медотсек", "med" },
        path { "В навигационный отсек", "nav" },
        path { "В рубку", "deck" }
    }
}

es.obj {
    nam = "kofman",
    dsc = "{Кофман} открыл люк в полу и что-то перебирает в трюме, сидя на коленях.",
    act = function(s)
        es.walkdlg("kofman.task")
        return true
    end
}
-- endregion

-- region tech
es.room {
    nam = "tech",
    done = false,
    problem = false,
    pic = "ship/tech",
    disp = "Технический отсек",
    dsc = [[Аппараты работают, и в отсеке стоит низкочастотный гул, от которого закладывает уши и становится тяжело дышать, словно тебе невидимой удавкой сжимают горло. Из-за трудолюбиво пыхтящих систем охлаждения воздух стал тёплым, как в парной, и мне не терпится поскорее отсюда выйти.]],
    onexit = function(s, t)
        if t.nam == "corridor" and s.done then
            es.stopMusic(3000)
            purge("key")
            walkin("pause1")
            return false
        end
    end,
    obj = { "key_holder", "modules", "comp" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "key_holder",
    taken = false,
    dsc = function(s)
        if not s.taken then
            return "В кронштейне у двери висит {сервисный ключ}."
        else
            return "На стене у двери -- {кронштейн} для сервисного ключа."
        end
    end,
    act = function(s)
        if not s.taken then
            take("key")
            s.taken = true
            return "Я достаю из люка ключ."
        else
            return "Здесь хранится сервисный ключ."
        end
    end,
    used = function(s, w)
        if w.nam == "key" then
            s.taken = false
            purge("key")
            return "Я возвращаю сервисный ключ на стену."
        end
    end
}

es.obj {
    nam = "key",
    disp = es.tool "Сервисный ключ",
    inv = "Универсальный сервисный ключ в виде трёхгранника."
}

es.obj {
    nam = "modules",
    done = false,
    dsc = function(s)
        if not s.done then
            return "{БВА} работает, несмотря на то, что мы должны были переключиться на фотонный аппарат."
        else
            return "{БВА} застыл, как величественное надгорбие аналоговым машинам, отключённый от сети."
        end
    end,
    act = function(s)
        if not s.done then
            return "Возможно, его забыли отключить?"
        else
            return "Лучше его не трогать."
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not s.done then
            s.done = true
            return [[И правильно! Лучше на всякий случай отключить БВА.
            ^Я вставляю в сервисный разъём ключ и несколько раз поворачиваю его, преодолевая тугое скрипящее сопротивление машины. БВА ворчит, как старый дизель, обиженно вспыхивает индикаторами и затихает.]]
        elseif w.nam == "key" and s.done then
            return "Опять включать БВА? Но зачем? Мне кажется, я могу найти занятие получше."
        end
    end
}

es.obj {
    nam = "comp",
    done = false,
    dsc = "За ним стоит {центральный вычислительный аппарат} -- именно он мне и нужен.",
    act = function(s)
        walkin("tech.terminal")
        return true
    end,
    used = function(s, w)
        if w.nam == "key" then
            return "Вычислительный аппарат работает. Что я хочу сделать?"
        end
    end
}

es.terminal {
    nam = "tech.terminal",
    vars = {
        calc = -1,
        navdat = -1,
        reports = false,
        monitor = false,
        backup = true,
        logs = false,
        seed = 0
    },
    header = {
        "Управляющая оснастка ГКМ Эпсилон",
        "Версия 12.3.445",
        "-"
    },
    commands_help = {
        ver = "информация о версии",
        monitor = "системный монитор",
        services = "запуск оснастки сервисов",
        reports = "подсистема операционных очётов",
        logs = "операционные логи"
    },
    serviceLine = function(s, nam)
        local app = "доступен"
        if s.vars[nam] == false then
            app = "недоступен"
        elseif s.vars[nam] == -1 then
            app = "заблокирован"
        end
        local dsc = s.allServices[nam]
        return string.format("%s (%s): %s", nam, dsc, app)
    end,
    allServices = {
        ["monitor"] = "сервис мониторинга системных ресурсов",
        ["rms"] = "сервис управления правами",
        ["navdat"] = "сервис анализа навигационных данных",
        ["calc"] = "сервис отложенных вычислений",
        ["reports"] = "сервис отчетов",
        ["backup"] = "сервис резервного копирования данных",
        ["logs"] = "сервис операционного логирования"
    },
    allServices2 = {
        ["monitor"] = "сервису мониторинга",
        ["rms"] = "сервису управления правами",
        ["navdat"] = "сервису анализа навигационных данных",
        ["calc"] = "сервису отложенных вычислений",
        ["reports"] = "сервису отчетов",
        ["backup"] = "сервису резервного копирования данных",
        ["logs"] = "сервису операционного логирования"
    },
    commands = {
        ver = function(s)
            return {
                "Эпсилон 12.3.445",
                "Версия ядра 7.0.12"
            }
        end,
        logs = function(s)
            if not s.vars.logs then
                return s:error("Сервис операционного логирования недоступен!")
            end
            if not load then
                return "$load"
            end
            if s.vars.seed == 0 then
                s.vars.seed = rnd(1024)
            end
            return es.generateLog(s.vars.seed, 26)
        end,
        monitor = function(s, args, load)
            if not s.vars.monitor then
                return s:error("Сервис мониторинга недоступен!")
            end
            local arg = s:arg(args)
            if not arg then
                if not load then
                    return "$load"
                end
                local cpu,mem = rnd(4,9),rnd(42, 49)
                if s.vars.backup then
                    cpu = cpu + 80
                    mem = 99
                end
                return {
                    string.format("Потребление памяти: %s%%", mem),
                    string.format("Общая загрузка вычислительных блоков: %s%%", cpu),
                    string.format("Загрузка нейронного блока: %s%%", rnd(1,4)),
                    "Загрузка навигационного блока: 0%",
                    string.format("Загрузка дисковой подсистемы: %s%%", rnd(1,5)),
                    "",
                    "Синтакис:",
                    "Общие данные: monitor",
                    "Данные по сервису: monitor [название сервиса]"
                }
            elseif not s.allServices[arg] then
                return string.format("Сервис не найден: %s.", arg)
            elseif s.vars[arg] == -1 then
                return string.format("Сервис %s заблокирован.", arg)
            elseif s.vars[arg] == false then
                return string.format("Сервис %s не запущен.", arg)
            elseif not load then
                return "$load"
            elseif arg == "backup" then
                if not load then
                    return "$load"
                end
                return {
                    string.format("Статистика по %s (%s):", s.allServices2[arg], arg),
                    "Потребление памяти: 8093KB",
                    "Загрузка вычислительных блоков: 99%",
                    "Загрузка нейронного блока: 0%",
                    "Загрузка навигационного блока: 0%",
                    "Загрузка дисковой подсистемы: 99%"
                }
            else
                return {
                    string.format("Статистика по %s (%s):", s.allServices2[arg], arg),
                    string.format("Потребление памяти: %sKB", rnd(12,16)),
                    string.format("Загрузка вычислительных блоков: %s%%", rnd(1, 3)),
                    "Загрузка нейронного блока: 0%",
                    "Загрузка навигационного блока: 0%",
                    string.format("Загрузка дисковой подсистемы: %s%%", rnd(1,2))
                }
            end
        end,
        services = function(s, args, load)
            if not args or #args == 0 then
                if not load then
                    return "$load"
                end
                local retval = {}
                for k,v in pairs(s.allServices) do
                    table.insert(retval, s:serviceLine(k))
                end
                table.insert(retval, "")
                table.insert(retval, "Синтаксис:")
                table.insert(retval,
                    "Остановка сервиса: services stop [название сервиса]")
                table.insert(retval,
                    "Запуск сервиса: services start [название сервиса]")
                return retval
            else
                local allServ = es.keys(s.allServices)
                local cmd = args[1]
                if cmd == "start" or cmd == "stop" then
                    local srv = args[2]
                    if not srv or srv == "" then
                        return s:error("Не задано кодовое имя сервиса.")
                    elseif not srv:any(allServ) then
                        return string.format("Сервис не найден: %s.", srv)
                    elseif cmd == "start" then
                        if s.vars[srv] == -1 then
                            return s:error("Невозможно запустить заблокированный сервис.")
                        end
                        if s.vars[srv] == nil then
                            return s:error("Недостаточно прав для совершения операции.")
                        end
                        if s.vars[srv] then
                            return string.format("Сервис %s (%s) уже запущен.", srv,
                                s.allServices[srv])
                        elseif not load then
                            return "$load"
                        else
                            if s.vars.backup and srv ~= "monitor" then
                                es.music("juxtaposition", 2, 0, 3000)
                                all.tech.problem = true
                                return s:error("Недостаточно памяти!")
                            end
                            s.vars[srv] = true
                            return string.format("Сервис запущен: %s (%s).",
                                srv, s.allServices[srv])
                        end
                    elseif cmd == "stop" then
                        if s.vars[srv] == -1 then
                            return s:error("Невозможно запустить заблокированный сервис.")
                        end
                        if s.vars[srv] == nil then
                            return s:error("Недостаточно прав для совершения операции.")
                        end
                        if s.vars[srv] == false then
                            return string.format("Сервис [%s] уже остановлен.", srv)
                        elseif not load then
                            return "$load"
                        else
                            s.vars[srv] = false
                            return string.format("Сервис остановлен: %s (%s).",
                                srv, s.allServices[srv])
                        end
                    end
                else
                    return s:error(string.format("Неизвестная сервисная команда: %s.", cmd))
                end
            end
        end,
        reports = function(s, args, load)
            local fakes = {"lifesup", "grav", "meng", "seng"}
            if not s.vars.reports then
                return s:error("Сервис отчётов недоступен!")
            elseif s.vars.backup then
                return s:error("Недостаточно памяти!")
            end
            local arg = s:arg(args)
            if not arg then
                return {
                    "Доступные операционные отчёты:",
                    "lifesup (система жизнеобеспечения)",
                    "grav (система жизнеобеспечения)",
                    "meng (маршевый двигатель)",
                    "seng (маневровые двигатели)",
                    "dock (система стыковки)",
                    "",
                    "Синтаксис:",
                    "reports [название отчёта]"
                }
            elseif arg:any(fakes) and not load then
                return "$load"
            elseif arg:any(fakes) then
                return {
                    "Моникёр сессии: "..rnd(1234, 59966),
                    "Операционная дельта: "..rnd(8, 64),
                    "Количество ошибок за последний цикл: 0"
                }
            elseif arg == "dock" and not load then
                return "$load"
            elseif arg == "dock" then
                all.tech.done = true
                return {
                    "Моникёр сессии: "..rnd(1234, 59966),
                    "Операционная дельта: "..rnd(128, 1024),
                    "Количество ошибок за последний цикл: 204567",
                    "Система стыковки работает в штатном режиме."
                }
            else
                return s:error(string.format("Неизвестный отчёт: %s.", arg))
            end
        end
    },
    before_command = function(s)
        if not all.modules.done then
            return s:error("Обнаружена интерференция по линии ТА-12А!")
        end
    end
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv = true,
    pause = 50,
    next = function(s)
        es.music("hope", 2)
        es.walkdlg {
            dlg = "majorov",
            branch = "head",
            pic = "ship/corridor",
            disp = "Коридор"
        }
    end
}
-- endregion

-- region cabin
es.room {
    nam = "cabin",
    pic = "ship/cabin",
    disp = "Каюта",
    dsc = [[Я зачем-то залезаю в каюту, словно желаю убедиться, что всё осталось на своих местах.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Душ сейчас я принимать не буду."
            return false
        end
    end,
    obj = { "clothes", "drobe", "showerdoor" },
    way = {
        path { "В душевую", "main" },
        path { "В коридор", "corridor" }
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
    act = "Сейчас скафандр точно не нужен."
}

es.obj {
    nam = "showerdoor",
    dsc = "У выхода из каюты -- сдвигающая гармошкой {дверца} в душевую с сухой чисткой.",
    act = "Индивидуальная душевая -- настоящая роскошь для космического корабля."
}
-- endregion

-- region nav
es.room {
    nam = "nav",
    pic = "ship/nav",
    disp = "Навигационный отсек",
    dsc = [[Я подхожу к пустой капсуле и долго стою рядом, как у надгробия. Сам не понимаю, что привело меня в навигационный отсек.]],
    way = {
        path { "В коридор", "corridor" }
    }
}
-- endregion

-- region med
es.room {
    nam = "med",
    pic = "ship/med",
    disp = "Медицинский отсек",
    dsc = [[Наша медичка -- самая напрасная трата пространства, какую я видел на кораблях дальнего следования. Впрочем, "Грозный" совсем недавно вышел с верфи и проектировался по каким-нибудь обновлённым стандартам. Жаль, правда, что жилым отсекам не подкинули пару лишних кубометров.]],
    way = {
        path { "В коридор", "corridor" }
    }
}
-- endregion

-- region deck
es.room {
    nam = "deck",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[В рубке никого нет, да и мне здесь ничего не нужно.]],
    way = {
        path { "В коридор", "corridor" }
    }
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
    next = "interlude1"
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    pic = "station/neardock3",
    disp = "Коридор у пристани",
    onenter = function(s)
        es.music("fatigue2")
    end,
    dsc = [[Спал я плохо и, хотя меня всё ещё преследуют кошмары, я всерьёз думаю о том, чтобы вернуться в жилой модуль и свалиться в кровать. Делать мне всё равно больше нечего -- все на станции как будто забыли о моём существовании, и даже Андреев, обещавший устроить какую-то экскурсию, так и не объявился.]],
    obj = { "figure" }
}

es.obj {
    nam = "figure",
    dsc = "Я бреду по сумрачному коридору у пристани, как вдруг замечаю вдалеке {знакомую фигуру}.",
    act = function(s)
        walkin("neardock")
        return true
    end
}
-- endregion

-- region neardock
es.room {
    nam = "neardock",
    pic = "station/neardock3",
    disp = "Коридор у пристани",
    dsc = [[Света здесь так мало, что можно всерьёз решить, что врубать лампы в полную силу запрещается по правилам станции.]],
    obj = { "dreams", "vera" }
}

es.obj {
    nam = "dreams",
    dsc = "Наверное, когда прекратятся кошмары с мерзкими алыми червями, пожирающими меня живьём, им на смену придут новые сны -- и я начну блуждать по таким вот сумрачным {лабиринтам} в поисках света в конце тоннеля.",
    act = "И ещё неизвестно, что лучше."
}

es.obj {
    nam = "vera",
    dsc = "^^Девушка, с которой я познакомился вчера -- её зовут {Вера} -- расхаживает взад-вперёд по коридору.",
    act = function(s)
        es.music("faith", 2, 0, 3000)
        es.walkdlg("vera.head")
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
    next = "c1"
}
-- endregion

-- region c1
es.room {
    nam = "c1",
    mus = false,
    pic = "station/cabin1",
    disp = "Жилой модуль C1",
    dsc = [[Сутки на "Кабирии" -- механические, а освещение в каютах в течение вычисленного по хронометру дня не торопятся приглушать. Кажется, время остановилось.]],
    onenter = function(s)
        if not s.mus then
            s.mus = true
            es.music("fatigue2")
        end
    end,
    obj = { "porthole", "bed", "box", "toilet_door", "wallcomp" },
    way = {
        path { "В коридор", "block_c" },
        path { "В санузел", "toilet" }
    }
}

es.obj {
    nam = "porthole",
    dsc = "Единственное, что изменяется по мере того, как станция плывёт по орбите -- это вид в иллюминаторе. Но сейчас {иллюминатор} закрыт.",
    act = function(s)
        walkin("pause4")
        return true
    end
}

es.obj {
    nam = "bed",
    dsc = "У стены притулилась узкая {кровать} со смятой подушкой.",
    act = "Кровать наводит на мысли о последнем кошмаре."
}

es.obj {
    nam = "box",
    dsc = "Рядом -- {колонка} для личных вещей",
    act = "Она такая узенькая, словно намекает, что вещей не должно быть много."
}

es.obj {
    nam = "toilet_door",
    dsc = "и дверца в {санузел}, где, помимо душа с сухой чисткой, который до боли напоминает аналогичные конструкции на моём корабле, есть и кран с настоящей водой.",
    act = "Даже гальюн у меня теперь персональный."
}

es.obj {
    nam = "wallcomp",
    dsc = "На стене висит широкий информационный {экран}. Правда, я до сих пор не понял, как им пользоваться.",
    act = "Терминала в каюте нет, а на экран выводится статистика и экстренные сообщения. Сейчас вот, например, там отображается скорость нашего движения по орбите."
}

es.obj {
    nam = "coffee",
    content = 3,
    disp = es.tool "Стакан кофе",
    inv = function(s)
        s.content = s.content - 1
        if s.content == 2 then
            return "Я делаю несколько глотков почти остывшего кофе."
        elseif s.content == 1 then
            return "От кофейной горечи сводит рот."
        elseif s.content == 0 then
            return "Я делаю последний глоток, теперь стаканчик пуст."
        else
            return "Стакан пуст."
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
    obj = { "sink" },
    way = {
        path { "Выйти", "c1" }
    }
}

es.obj {
    nam = "sink",
    done = false,
    dsc = "До сих пор не могу поверить, что в раковине есть {кран} с настоящей водой, а не с отдающим хлоркой порошком, разъедающим кожу.",
    act = function(s)
        if not s.done then
            s.done = true
            return "Я умываю холодной водой лицо, мне становится немного лучше."
        else
            return "Я уже умылся."
        end
    end
}
-- endregion

-- region block_c
es.room {
    nam = "block_c",
    pic = "station/c1",
    disp = "Жилой блок C",
    dsc = [[Нет у меня желания никуда идти, лучше отдохнуть в своём модуле.]],
    way = {
        path { "В модуль C1", "c1" }
    }
}
-- endregion

-- region pause4
es.room {
    nam = "pause4",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        gamefile("game/07.lua", true)
    end
}
-- endregion
