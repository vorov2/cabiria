-- Chapter 4
dofile "lib/es.lua"

es.main {
    chapter = "4",
    onenter = function(s)
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/ship",
    noinv = true,
    disp = "Судовой отчёт",
    enter = function(s)
        es.loopMusic("doom", 6000)
    end,
    dsc = [[<b>Корабль:</b> ГКМ "Грозный"^
    <b>Местоположение:</b> Сантори-5^
    <b>Статус</b>: Стыковка c НИОС "Кабирия"]],
    next = function(s)
        es.walkdlg {
            dlg = "majorov",
            branch = "head",
            pic = "ship/deck",
            disp = "Рубка"
        }
    end
}
-- endregion

-- region deck1
es.room {
    nam = "deck1",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[Рубку охватила напряжённая тишина. Кажется, воздух пронизан электричеством.]],
    onexit = function(s, t)
        if t.nam == "corridor" then
            p "Надо сначала выбраться из ложемента."
            return false
        end
    end,
    obj = { "belt1", "beltcheck1", "beltcheck2" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "belt1",
    done = false,
    dsc = "Я пытаюсь выбраться из ложемента, но {ремень} как назло заклинило.",
    act = function(s)
        if not all.beltcheck1.active then
            all.beltcheck1.active = true
            return "Отсоединить ремень не получается. Видимо, система безопасности и правда считает, что произошло столкновение."
        elseif all.beltcheck1.active
            and all.beltcheck1.position == all.beltcheck2.position then
            s.done = true
            es.walkdlg("kofman.head")
            return true
        else
            return "Ничего не выходит. Ремень по-прежнему не отстёгивается."
        end
    end
}

es.obj {
    nam = "beltcheck1",
    active = false,
    position = 3,
    cnd = "s.active",
    dsc = function(s)
        return "{Левый рыжачок} ремня в позиции \"" .. tostring(s.position).."\","
    end,
    act = function(s)
        if s.position == 3 then
            s.position = 0
            return "Я сбрасываю рычаг в нулевую позицию."
        else
            s.position = s.position + 1
            return "Я перевожу левый рычаг на позицию \"" .. tostring(s.position) .. "\""
        end
    end
}

es.obj {
    nam = "beltcheck2",
    position = 1,
    cnd = "{beltcheck1}.active",
    dsc = function(s)
        return "а {правый} - в позиции \"" .. tostring(s.position) .. "\"."
    end,
    act = function(s)
        if s.position == 3 then
            s.position = 0
            return "Я сбрасываю рычаг в нулевую позицию."
        else
            s.position = s.position + 1
            return "Я перевожу правый левый рычаг на позицию \""
                ..tostring(s.position) .. "\""
        end
    end
}
-- endregion

-- region deck2
es.room {
    nam = "deck2",
    report = false,
    talk = false,
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[Всё в рубке кажется засвеченным, как на плохой фотографии.]],
    obj = { "crew", "comp1", "kofman1" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "crew",
    dsc = "{Все} лежат в ложементах, уткнувшись в мерцающие экраны.",
    act = "Сейчас не время для праздных разговоров, у меня есть дела."
}

es.obj {
    nam = "comp1",
    dsc = "{Терминал}, вмонтированный в мой ложемент, тоже ожил.",
    act = function(s)
        if all.suit.taken then
            return "Пользоваться клавиатурой терминала в металлизированных перчатках не слишком удобно. К тому же я уже сделал всё, что было нужно."
        else
            walkin("comp1.terminal")
            return true
        end
    end
}

local function outOfOrder(s, args, load)
    local function formatLine()
        local arr = es.rndArray(rnd(1, 1024), 5, 2048)
        local res = {}
        for i,v in ipairs(arr) do
            table.insert(res, "0x"..string.upper(string.format("%06x", v)))
        end
        return table.concat(res, " ")
    end
    if not load then
        return "$load"
    end
    es.sound("error")
    return {
        "Ошибка!",
        "Нарушено соединение с контуром! Невозможно получить данные!",
        "Код ошибки: <ошибка при получении кода ошибки>",
        "Дамп:",
        formatLine(),
        formatLine(),
        formatLine(),
        formatLine(),
        formatLine()
    }
end
es.terminal {
    nam = "comp1.terminal",
    header = {
        "Управляющая оснастка ГКМ Эпсилон",
        "Версия 12.3.445",
        "-"
    },
    commands_help = {
        monitor = "системный монитор",
        services = "запуск оснастки сервисов",
        reports = "подсистема операционных очётов",
        logs = "операционные логи"
    },
    commands = {
        logs = outOfOrder,
        monitor = outOfOrder,
        ver = function(s)
            return {
                "Эпсилон 12.3.445",
                "Версия ядра 7.0.12"
            }
        end,
        services = outOfOrder,
        reports = outOfOrder
    }
}

es.obj {
    nam = "kofman1",
    report = false,
    dsc = "{Кофман} что-то сердито выстукивает на клавиатуре.",
    act = function(s)
        if all.suit.taken then
            es.walkdlg("kofman.suit")
        elseif not all.tech.done or all.deck2.report then
            es.walkdlg("kofman.dowork")
        else
            es.walkdlg("kofman.tech")
        end
        return true
    end
}
-- endregion

-- region corridor
es.room {
    nam = "corridor",
    mus = false,
    pic = "ship/corridor",
    disp = "Коридор",
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("whatif", 2, 0, 2000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "gate" and not all.deck2.report then
            p "Рано пока лезть в шлюз, возможно, стыковка не завершилась корректно."
            return false
        end
    end,
    dsc = [[Я стою посреди коридора, соединяющего отсеки.]],
    obj = { "hatch", "cutter_holder" },
    way = {
        path { "В шлюз", "gate" },
        path { "В каюту", "cabin" },
        path { "В техотсек", "tech" },
        path { "В медотсек", "med" },
        path { "В навигационный отсек", "nav" },
        path { "В рубку", "deck2" }
    }
}

es.obj {
    nam = "hatch",
    unbar = false,
    dsc = function(s)
        if not s.unbar then
            return "Под ногами у меня -- {люк} в трюм."
        else
            return "Под ногами у меня -- открытый {люк} в трюм."
        end
    end,
    act = function(s)
        if not s.unbar then
            return "В трюме хранятся инструменты, которые, скажем так, редко пригождаются во время удачного полёта. Открывается трюм, как и всё на этом чёртовом корабле, с помощью сервисного ключа."
        else
            return "Опасно оставлять люк открытым, кто-нибудь может туда провалиться."
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not all.deck2.report then
            return "Что мне там делать? У меня есть другие дела."
        elseif w.nam == "key" and not s.unbar then
            s.unbar = true
            return "Я открыл люк с помощью сервисного ключа."
        elseif w.nam == "key" then
            s.unbar = false
            return "Я запечатал люк в трюм."
        elseif w.nam == "cutter" and s.unbar then
            all.cutter_holder.taken = false
            purge("cutter")
            return "Я положил резак обратно в трюм."
        elseif w.nam == "cutter" then
            return "Трюм сейчас закрыт."
        end
    end
}

es.obj {
    nam = "cutter_holder",
    taken = false,
    cnd = "{hatch}.unbar and not s.taken",
    dsc = "Люк открыт, и в неглубокой нише под ним я вижу {плазменный резак}.",
    act = function(s)
        s.taken = true
        take("cutter")
        return "Я вытаскиваю резак из люка. Тяжёлый!"
    end
}

es.obj {
    nam = "cutter",
    mod = 0,
    disp = es.tool "Плазменный резак",
    inv = function(s)
        if s.mod == 1 then
            s.mod = 2
            return "Резак включён на среднюю мощность."
        elseif s.mod == 2 then
            s.mod = 3
            return "Резак включён на максимальную мощность."
        else
            s.mod = 1
            return "Резак включён на минимальную мощность."
        end
    end,
    default = "Плазменный резак -- опасная штука, надо обращаться с ним поосторожнее.",
    dsc = function(s)
        if all.hatch.unbar and not have("cutter") then
            return 
        end
    end
}
-- endregion

-- region nav
es.room {
    nam = "nav",
    pic = "ship/nav",
    disp = "Навигационный отсек",
    dsc = [[Я подхожу к пустой капсуле и долго стою рядом, как у надгробия. Сам не понимаю, что привело меня в навигационный отсек. Может, я надеялся, что всё произошедшее привиделось мне в очередном кошмаре, а навигатор по-прежнему лежит в своём саркофаге.]],
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
    obj = { "locker", "rean_holder", "flash_holder" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "locker",
    unbar = false,
    dsc = function(s)
        local txt = "В углу прячется массивный металлический {рундук}, в котором хранится медицинское оборудование."
        if s.unbar then
            return txt .. " Рундук сейчас открыт."
        end
        return txt
    end,
    act = function(s)
        if s.unbar then
            s.unbar = false
            return "Я закрываю рундук."
        else
            s.unbar = true
            return "Я открываю рундук."
        end
    end,
    used = function(s, w)
        if w.nam == "flash" and not s.unbar then
            return "Рундук сейчас закрыт."
        elseif w.nam == "flash" then
            all.flash_holder.taken = false
            purge("flash")
            return "Я бросаю фонарик обратно в рундук."
        end
    end
}

es.obj {
    nam = "rean_holder",
    cnd = "{locker}.unbar",
    dsc = "Внутри лежит {реаниматор}.",
    act = function(s)
        return "Надеюсь, он больше нам не понадобится."
    end
}

es.obj {
    nam = "flash_holder",
    taken = false,
    cnd = "{locker}.unbar and not s.taken",
    dsc = "В самый угол закатился маленький медицинский {фонарь}, похожий на вечное перо.",
    act = function(s)
        s.taken = true
        take("flash")
        return "Я забираю фонарик."
    end
}

es.obj {
    nam = "flash",
    disp = es.tool "Фонарь",
    inv = "Небольшой медицинский фонарик, который почти не даёт света. Разогнать им сумрак вокруг точно не выйдет, но если навести его, как указку, на какой-нибудь прячущийся предмет, то, возможно, получится согнать с него тень."
}
-- endregion

-- region cabin
es.room {
    nam = "cabin",
    pic = "ship/cabin",
    disp = "Каюта",
    onexit = function(s, t)
        if t.nam == "main" then
            p "Не лучшее время, чтобы принимать душ."
            return false
        end
    end,
    dsc = [[После всего произошедшего узенькая каюта кажется уютной и родной. Так хочется откатить время на несколько часов назад, когда я беспечно плавал в невесомости, переживая о каких-то снах.]],
    obj = { "memo", "sleepbag", "suit" },
    way = {
        path { "В душевую", "main" },
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "memo",
    dsc = "{Лист} на стене с распорядком вахты издевательски поблёскивает на свету.",
    act = "Первый пункт -- проверить навигатора."
}

es.obj {
    nam = "sleepbag",
    dsc = "{Спальник}, в котором я проводил долгие часы во время перехода, валяется на полу.",
    act = "Может, всё происходящее -- просто очередной кошмар?"
}

es.obj {
    nam = "suit",
    unbar = false,
    taken = false,
    disp = es.tool "Скафандр",
    dsc = function(s)
        if not s.unbar and not s.taken then
            return "Я стою у {заслонки} с красным пунктиром, где должен находиться мой скафандр."
        elseif not s.unbar and s.taken then
            return "Я стою у {заслонки} с красным пунктиром, где лежал мой скафандр."
        elseif s.unbar and not s.taken then
            return "Я стою у ниши в стене, где лежит мой {скафандр}."
        elseif s.unbar then
            return "Я стою у ниши в стене, где лежал мой {скафандр}."
        end
    end,
    act = function(s)
        if not s.unbar then
            return "Заслонка открывается сервисным ключом."
        elseif s.unbar and not s.taken and not all.deck2.report then
            return "Зачем мне надевать скафандр?"
        elseif s.unbar and s.taken then
            return "Скафандр уже на мне."
        else
            s.taken = true
            walkin("spacesuit")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not s.unbar then
            s.unbar = true
            return "Я открываю заслонку."
        elseif w.nam == "key" and s.unbar then
            s.unbar = false
            return "Я закрываю заслонку."
        end
    end
}
-- endregion

-- region spacesuit
es.room {
    nam = "spacesuit",
    pic = "ship/spacesuit",
    disp = "Каюта",
    dsc = [[Набрав побольше воздуха в грудь, словно собираюсь нырять на глубину, я влезаю в громоздский скафандр. Он тут же обхватывает меня, стискивает грудную клетку, не давая вздохнуть.
    ^Перед глазами плывут красные круги.
    ^Дело здесь явно не в скафандре. Мне просто надо успокоиться.]],
    enter = function(s)
        es.music("tragedy", 3, 0, 3000)
    end,
    obj = { "weight", "helmet" }
}

es.obj {
    nam = "helmet",
    done = false,
    disp = function(s)
        if s.done then
            return es.tool "Шлем (надет)"
        else
            return es.tool "Шлем"
        end
    end,
    dsc = "Я закрепляю на поясе {шлем} -- мне он пока не нужен.",
    tak = function(s)
        walkin("cabin")
        return true
    end,
    inv = function(s)
        if all.deck2.report and here().nam ~= "gate" then
            return "Я бы препочёл сначала подняться в шлюз."
        elseif all.deck2.report and here().nam == "gate" and not s.done then
            s.done = true
            return "Я надеваю шлем."
        elseif all.deck2.report and here().nam == "gate" and s.done then
            s.done = false
            return "Я снимаю шлем."
        else
            return "Рано пока надевать шлем."
        end
    end
}

es.obj {
    nam = "weight",
    dsc = "\"Облечённая модель скафандра универсального\" на удивление {тяжёлая}, и я двигаюсь так, словно к ногам привязали пудовый груз.",
    act = "Или это последствия долгих дней, проведённых в невесомости?"
}
-- endregion

-- region tech
es.room {
    nam = "tech",
    pic = "ship/tech",
    done = false,
    disp = "Технический отсек",
    dsc = [[Технический отсек чем-то напоминает склад техники, которую свезли сюда со всего корабля.]],
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
    dsc = "{БВА} отключена, как и полагается при активации электроники.",
    act = "С БВА всё в порядке, не нужно её трогать.",
    used = function(s, w)
        if w.nam == "key" then
            return "С БВА всё в порядке, не нужно её трогать."
        elseif w.nam == "cutter" then
            return "Кажется, я схожу с ума."
        end
    end
}

es.obj {
    nam = "comp",
    done = false,
    dsc = "За ним скромно прячется {центральный вычислительный аппарат}.",
    act = function(s)
        if all.suit.taken then
            return "Пользоваться клавиатурой терминала в металлизированных перчатках не слишком удобно. К тому же я уже сделал всё, что было нужно."
        else
            walkin("tech.terminal")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "key" then
            return "Вычислительный аппарат работает. Что я хочу сделать?"
        elseif w.nam == "cutter" then
            return "Похоже, я переутомился."
        end
    end
}

es.terminal {
    nam = "tech.terminal",
    vars = {
        calc = false,
        reports = false,
        monitor = true,
        backup = true,
        logs = true,
        mus = false,
        seed = 0
    },
    header = {
        "Управляющая оснастка ГКМ Эпсилон",
        "Версия 12.3.445",
        "-"
    },
    commands_help = {
        monitor = "системный монитор",
        services = "запуск оснастки сервисов",
        reports = "подсистема операционных очётов",
        logs = "операционные логи"
    },
    serviceLine = function(s, nam)
        local app = "доступен"
        if s.vars[nam] == false then
            app = "недоступен"
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
    commands = {
        ver = function(s)
            return {
                "Эпсилон 12.3.445",
                "Версия ядра 7.0.12"
            }
        end,
        logs = function(s, args, load)
            if not s.vars.logs then
                return s:error("Ошибка! Сервис операционного логирования недоступен!")
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
                return {
                    string.format("Потребление памяти: %s%%", rnd(55, 63)),
                    string.format("Общая загрузка вычислительных блоков: %s%%", rnd(9,12)),
                    string.format("Загрузка нейронного блока: %s%%", rnd(81,99)),
                    "Загрузка навигационного блока: 0%",
                    string.format("Загрузка дисковой подсистемы: %s%%", rnd(1,5)),
                    "",
                    "Синтакис:",
                    "Общие данные: monitor",
                    "Данные по сервису: monitor [название сервиса]"
                }
            elseif not s.allServices[arg] then
                return string.format("Сервис не найден: %s.", arg)
            elseif not s.vars[arg] then
                return string.format("Сервис %s не запущен.", arg)
            else
                if not load then
                    return "$load"
                end
                return {
                    string.format("%s (%s):", arg, s.allServices[arg]),
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
                local all = es.keys(s.allServices)
                local cmd = args[1]
                if cmd == "start" or cmd == "stop" then
                    local srv = args[2]
                    if not srv or srv == "" then
                        return s:error("Не задано кодовое имя сервиса.")
                    elseif not srv:any(all) then
                        return string.format("Сервис не найден: %s.", srv)
                    elseif cmd == "start" then
                        if s.vars[srv] == nil then
                            return s:error("Недостаточно прав для совершения операции.")
                        end
                        if s.vars[srv] then
                            return string.format("Сервис %s (%s) уже запущен.", srv,
                                s.allServices[srv])
                        elseif not load then
                            return "$load"
                        else
                            s.vars[srv] = true
                            return string.format("Сервис запущен: %s (%s).",
                                srv, s.allServices[srv])
                        end
                    elseif cmd == "stop" then
                        if s.vars[srv] == nil then
                            return s:error("Недостаточно прав для совершения операции.")
                        end
                        if s.vars[srv] == false then
                            return string.format(
                                "Сервис [%s] уже остановлен.", srv)
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
                es.stopMusic()
                all.tech.done = true
                return {
                    "Моникёр сессии: "..rnd(1234, 59966),
                    "Операционная дельта: "..rnd(128, 1024),
                    "Количество ошибок за последний цикл: 4",
                    "",
                    "Внимание! Система стыковки заблокирована из-за ошибки с кодом ",
                    "<ошибка чтения кода ошибки>!"
                }
            else
                return s:error(string.format("Неизвестный отчёт: %s.", arg))
            end
        end
    },
    before_exit = function(s)
        if all.tech.done and not s.vars.mus then
            s.vars.mus = true
            es.music("juxtaposition", 1, 0, 3000)
        end
        return false
    end
}
-- endregion

-- region gate
local function testPane()
    if not all.deck2.report then
        return "Надо сначала обсудить происходящее с остальными членами экипажа. Я не в том положении, чтобы что-то решать самостоятельно."
    elseif not all.suit.taken then
        return "Лучше всё-таки и правда надеть скафандр. Он должен быть у меня в каюте."
    elseif have("helmet") and not all.helmet.done then
        return "Я забыл надеть шлем от скафандра."
    elseif not all.hatch2.sealed then
        return "Сначала надо герметизировать отсек."
    else
        return true
    end
end

es.room {
    nam = "gate",
    pic = "ship/gate",
    disp = "Шлюз",
    dsc = "Я вишу на лестнице в тонкой кишке передаточного шлюза, где с трудом помещается один человек в скафандре.",
    onexit = function(s, t)
        if t.nam == "corridor" and all.hatch2.sealed then
            p "Сейчас отсек герметизирован."
            return false
        elseif t.nam == "corridor" and all.helmet.done then
            p "Я бы предпочёл сначала снять шлем."
            return false
        elseif t.nam == "blockpane" then
            local ret = testPane()
            if ret == true and have("flash") then
                p "Я включаю фонарик и поднимаюсь чуть выше по лестнице. Света совсем мало, таким фонарём только радужку глаза просвечивать, но это лучше, чем ничего."
                return true
            elseif ret == true and not have("flash") then
                p "Я поднимаюсь чуть выше по лестнице. Здесь ещё темнее."
                return true
            else
                p(ret)
                return false
            end
        end
    end,
    enter = function(s)
        snapshots:make()
    end,
    obj = {
        "light",
        "blocker",
        "hatch1",
        "sign",
        "hatch2",
        "key_finder"
    },
    way = {
        path { "В коридор", "corridor" },
        path { "Подняться выше", "blockpane" }
    }
}

es.obj {
    nam = "light",
    dsc = "Здесь темно, и едва получается хоть что-нибудь {разглядеть}.",
    act = "Видимо, какие-то лампы отказали во время стыковки. Как такое вообще могло произойти? Ведь это совершенно новый корабль!",
    used = function(s, w)
        if w.nam == "flash" then
            return "Весь шлюз фонарик осветить не сможет, но, надеюсь, польза от него всё же будет."
        end
    end
}

es.obj {
    nam = "blocker",
    dsc = function(s)
        if not all.blocker_holder.unbar then
            return "Над головой у меня смутно проступает в полумраке прямоугольная {заслонка}, за которой прячутся блокираторы."
        else
            return "Над головой у меня смутно чернеет прямоугольная {ниша}, в которой прячутся блокираторы."
        end
    end,
    act = "Отсюда я почти ничего не вижу.",
    used = function(s, w)
        if w.nam == "cutter" then
            return "Использовать плазменный резак вместо фонаря -- это не лучшая идея. К тожу резак не освещает, а слепит -- смотреть на его струю невозможно, глаза вытекают."
        elseif w.nam == "key" then
            return "Мне не хватает света, я должен хорошо видеть, какие блокираторы режу."
        elseif w.nam == "flash" then
            return "Надо подняться повыше."
        end
    end
}

es.obj {
    nam = "hatch1",
    dsc = "У выходного {люка}",
    act = "После успешной стыковки люк открывается рычагом, который так и норовит заехать мне по затылку, но сейчас рычаг не работает -- сколько раз его не дёргай.",
    used = function(s, w)
        if w.nam == "key" then
            return "Если бы всё было так просто! Но, боюсь, универсальный сервисный ключ не настолько универсален."
        elseif w.nam == "cutter" then
            return "Нет смысла резать сам люк, надо просто снять блокиратор."
        end
    end
}

es.obj {
    nam = "sign",
    dsc = "висит невзрачная серая {табличка}.",
    act = "В темноте кажется, что на ней нацарапаны иероглифы.",
    used = function(s, w)
        if w.nam == "flash" then
            return [[Я навожу на табличку миниатюрный фонарик и читаю:
            ^"Внимание! Переборки шлюза могут разрушиться при воздействии мощных излучателей".]]
        elseif w.nam == "cutter" then
            return "Использовать плазменный резак вместо фонаря -- это не лучшая идея. К тожу резак не освещает, а слепит -- смотреть на его струю невозможно, глаза начинают вытекать."
        elseif w.nam == "key" then
            return "Я думаю, лучше оставить табличку в покое."
        end
    end
}

es.obj {
    nam = "hatch2",
    sealed = false,
    dsc = function(s)
        local txt = "Я нащупываю {рычаг} ещё одного люка, который герметизирует шлюз."
        if s.sealed then
            return txt .. " Сейчас люк закрыт."
        else
            return txt
        end
    end,
    act = function(s)
        if s.sealed then
            s.sealed = false
            return "Я открыл люк под ногами, теперь можно спуститься вниз."
        else
            s.sealed = true
            return "Я дергаю за рычаг, и люк с едким шипением закрывается."
        end
    end
}

es.obj {
    nam = "key_finder",
    taken = false,
    cnd = "{blocker_holder}.lost and not s.taken",
    dsc = "Под ногами у меня валяется {сервисный ключ} -- к счастью, он попал в островок света, и его не сложно заметить.",
    act = function(s)
        s.taken = true
        take("key")
        return "Я подбираю сервисный ключ."
    end
}
-- endregion

-- region blockpane
es.room {
    nam = "blockpane",
    pic = "ship/blockpane",
    disp = "Шлюз",
    dsc = [[Главное -- не сорваться с хлипкой лестницы.]],
    obj = {
        "blocker_holder",
        "instruction",
        "blockers",
        "block1",
        "block2",
        "block3"
    },
    way = {
        path { "Спуститься ниже", "gate" }
    }
}

es.obj {
    nam = "blocker_holder",
    unbar = false,
    lost = false,
    dsc = function(s)
        if not s.unbar then
            return "Передо мной -- {заслонка}, за которой должны быть аварийные блокираторы."
        else
            return "Передо мной -- открытая {заслонка}."
        end
    end,
    act = function(s)
        if not s.unbar then
            return "Дайте-ка догадаться, как она открывается!"
        else
            return "Главное -- не торопиться!"
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not s.unbar and not s.lost then
            s.lost = true
            purge("key")
            es.music("dali", 2, 0, 3000)
            return "Делать что-нибудь в скафандре до одури неудобно! Пальцы одеревенели, как при обморожении. Сервисный ключ выскальзывает из рук, когда я пытаюсь открыть заслонку, и со звоном проваливается в гулкую кишку шлюза."
        elseif w.nam == "key" and not s.unbar then
            s.unbar = true
            return "Я открываю заслонку."
        elseif w.nam == "key" and s.unbar then
            s.unbar = false
            return "Я закрываю заслонку."
        elseif w.nam == "flash" then
            return "Света от фонарика совсем мало, надо направить его на ту поверхность, которую я хочу получше разглядеть."
        end
    end
}

es.obj {
    nam = "instruction",
    dsc = "На её обратной стороне есть небольшая {табличка}.",
    act = "Я ничего толком не вижу.",
    used = function(s, w)
        if w.nam == "flash" then
            return "На табличке три квадрата -- жёлтый с единичкой внутри, синий с двойкой и красный с тройкой."
        elseif w.nam == "cutter" then
            return "Использовать плазменный резак вместо фонаря -- это не лучшая идея. К тожу резак не освещает, а слепит -- смотреть на его струю невозможно, глаза начинают вытекать."
        end
    end
}

es.obj {
    nam = "blockers",
    cnd = "{blocker_holder}.unbar",
    dsc = "Внутри -- {три} жилки блокираторов, которые выглядят, как силовые кабели, и ничем друг от друга не отличаются.",
    act = "Я знаю, что у блокираторов разная прочность, но никаких отличительных пометок не вижу, здесь слишком темно.",
    used = function(s, w)
        if w.nam == "flash" then
            return "Да, фонарик может помочь."
        end
    end
}

local block_base = {
    done = false,
    cnd = "{blocker_holder}.unbar",
    squares = {
        "жёлтым",
        "синим",
        "красным"
    },
    anyDone = function(s)
        return all.block1.done or all.block2.done or all.block3.done
    end,
    allDone = function(s)
        return all.block1.done and all.block2.done and all.block3.done
    end,
    check = function(s)
        local p = all.cutter.mod
        if p == 0 then
            return "Стоит сначала включить резак."
        elseif p < s.num then
            es.sound("cutter")
            return "Я навожу резак на стальную жилу, сдавливаю курки и -- ничего не происходит. На блокираторе не остаётся даже следа."
        elseif p == s.num then
            es.sound("cutter")
            return true
        else
            walkin("death")
            return false
        end
    end,
    act = function(s)
        if not s.done then
            return "На блокираторе должны быть какие-то пометки, но я ничего не вижу."
        else
            return "С этим блокироватором я уже разобрался."
        end
    end,
    used = function(s, w)
        if w.nam == "flash" then
            return string.format("Я свечу фонариком на блокиратор, на нём есть наклейка с %s квадратом.", s.squares[s.num])
        elseif w.nam == "cutter" and not s.done then
            local res = s:check()
            if res == true then
                local snd = s:anyDone()
                s.done = true
                if s:allDone() then
                    walkin("outro1")
                    return true
                elseif snd then
                    return "Вот и второй блокиратор готов -- с ним, правда, пришлось повозиться подольше. Остался последний -- и дело сделано."
                else
                    return "Я аккуратно срезаю резаком блокиратор. Пока всё идёт удачно."
                end
            elseif res == false then
                return true
            else
                return res
            end
        elseif w.nam == "cutter" then
            return "Всё уже сделано."
        elseif w.nam == "key" and not s.done then
            return "Сервисный ключ тут не поможет."
        elseif w.nam == "key" then
            return "Я думаю, стоит оставить блокироватор в покое."
        end
    end
}

es.obj(block_base) {
    nam = "block1",
    num = 3,
    dsc = function(s)
        if not s.done then
            return "{Правый} не разрезан."
        else
            return "{Правый} разрезан."
        end
    end
}

es.obj(block_base) {
    nam = "block2",
    num = 1,
    dsc = function(s)
        if not s.done then
            return "{Левым} ещё предстоит заняться."
        else
            return "{Левый} готов."
        end
    end
}

es.obj(block_base) {
    nam = "block3",
    num = 2,
    dsc = function(s)
        if not s.done then
            return "{Средний} пока цел."
        else
            return "Со {средним} я уже разобрался."
        end
    end
}
-- endregion

-- region death
es.room {
    nam = "death",
    pic = "common/flash",
    enter = function(s)
        es.music("bigexplosion")
    end,
    dsc = [[Я сдавил курок резака, и струя плазмы ударила по блокиратору. Неожиданно рука дрогнула, дуло резака увело в сторону, полоснув плазмой по переборкам.
    ^Cтенки шлюза мгновенно лопнули, словно кто-то вскрыл их огромным консервным ножом, и меня утянуло в темноту.]],
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pic = "ship/gate",
    enter = function(s)
        es.music("roar", 1, 0, 1000)
    end,
    dsc = [[Последний блокиратор!
    ^Я постарался унять дрожь в руках, навёл дуло резака на блокиратор и дёрнул за спусковой крючок. Несколько секунд ничего не происходило. Струя плазмы била в стальную жилу без видимого эффекта. Спустя несколько секунд блокиратор начал раскаляться, стал пунцовым от жара и треснул, как сухожилие.
    ^Люк у меня над головой задрожал и открылся.]],
    next = "outro2"
}
-- endregion

-- region outro2
es.room {
    nam = "outro2",
    noinv = true,
    pause = 100,
    enter = function(s)
        es.music("bam")
    end,
    next = function(s)
        gamefile("game/05.lua", true)
    end
}
-- endregion
