-- Chapter 8
dofile "lib/es.lua"

es.main {
    chapter = "8",
    onenter = function(s)
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    seconds = 46,
    pic = "common/station",
    enter = function(s)
        es.music("violin")
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds + 1
        if s.seconds == 50 then
            timer:stop()
            walkin("intro2")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    txt = "НИОС \"Кабирия\"^День четвёртый^^09:31:%s",
    dsc = function(s)
        return string.format(s.txt, all.intro1.seconds)
    end
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    pic = "station/tech",
    disp = "Технический отсек лаборатории",
    dsc = [[Несмотря на несколько чашек местного кофе, не уступающего по горечи рвотному, меня тянет в сон, как в обморок.
    ^Тусклое освещение в техническом отсеке слепит, и всё вокруг кажется расплывчатым. Я несколько раз моргаю и тру глаза, чтобы просто прочитать сообщения на экране терминала.]],
    next = function(s)
        es.music("dali")
        walkin("tech")
        return true
    end
}
-- endregion

-- region tech
es.room {
    nam = "tech",
    pic = "station/tech",
    disp = "Технический отсек лаборатории",
    dsc = [[Отсек чем-то напоминает техничку на нашем корабле. Пространства здесь, конечно, гораздо больше, и потолки высокие, почти, как в земных постройках.]],
    onexit = function(s)
        all.forgot.done = true
    end,
    obj = {
        "techrack",
        "alexin",
        "logs",
        "forgot",
        "comp",
        "toolbox",
        "cable"
    },
    way = {
        path { "В холл", "hall" },
        path { "К стойке с модуляторами", "rack" }
    }
}

es.obj {
    nam = "techrack",
    dsc = "Через всю стену тянется огромная {стойка} с операционными модулями, которые отвечают за работу лаборатории.",
    act = "Думаю, с этими модулями мне придётся провозиться ещё много дней."
}

es.obj {
    nam = "alexin",
    done = false,
    dsc = "{Алексин} -- мой новый коллега-инженер -- сидит у основного терминала и со скучающим видом листает какие-то",
    act = function(s)
        if s.done then
            return "Здесь я свою работу закончил. Не стоит его больше беспокоить. Лучше сходить к Марутяну."
        elseif not all.module1:hasUnchecked() then
            s.done = true
            es.walkdlg("alexin.final")
            return true
        elseif have("card") then
            es.walkdlg("alexin." .. (all.comp.problem or "work"))
            return true
        else
            all.forgot.done = true
            es.walkdlg("alexin.head")
            return true
        end
    end
}

es.obj {
    nam = "logs",
    dsc = "{логи}.",
    act = "Сложно сказать, действительно ли он чем-то занят или лишь изображает активную деятельность. Судя по тому, как он щурится и трёт глаза, кофе тоже не придало ему бодрости."
}

es.obj {
    nam = "forgot",
    done = false,
    cnd = "not s.done",
    dsc = "Я вдруг понимаю, что совершенно {забыл} всё, о чем он мне говорил Алексин по поводу сегодняшней работы.",
    act = "Надо проверить какие-то модули? Состояние такое, что тяжело даже думать."
}

es.obj {
    nam = "card",
    disp = es.tool "Карта доступа",
    inv = "Карта доступа для терминала, судя по всему, здесь вся техника авторизуется с помощью таких карт."
}

es.obj {
    nam = "comp",
    mus = false,
    problem = false,
    unlocked = false,
    dsc = "Моё рабочее место -- стандартный {терминал} и узенький столик -- ютится в углу, где поменьше света.",
    act = function(s)
        s.unlocked = false
        walkin("comp.terminal")
        return true
    end,
    used = function(s, w)
        if w.nam == "key" then
            return "Не думаю, что стоит разбирать терминал."
        elseif w.nam == "card" then
            s.unlocked = true
            walkin("comp.terminal")
            return true
        end
    end
}

es.obj {
    nam = "toolbox",
    locked = true,
    opened = false,
    dsc = function(s)
        local base = "Под столешницей прячется металлический {шкаф}, в котором обычно хранятся инструменты и запасное оборудование."
        if s.opened then
            return base.."^^Шкаф заполнен какими-то мятыми коробками, выгоревшими модулями, погнутыми ключами -- всему этому место на свалке."
        else
            return base
        end
    end,
    act = function(s)
        if s.locked then
            return "Вручную шкаф не открывается, здесь электронный замок. Возможно, получится открыть его с помощью терминала."
        elseif s.opened then
            s.opened = false
            return "Я закрываю шкаф."
        else
            s.opened = true
            return "Я открываю дверцу шкафа."
        end
    end,
    used = function(s, w)
        if w.nam == "cable" and s.opened then
            drop("cable")
            return "Я положил силовой кабель обратно в шкаф."
        elseif w.nam == "cable" then
            return "Вряд ли я смогу положить силовой кабель в закрытый шкаф."
        elseif w.nam == "card" then
            return "Боюсь, магнитной картой этот шкаф не открывается."
        elseif w.nam == "key" then
            return "Сервисный ключ здесь не поможет, у замков здесь программное управление."
        end
    end
}

es.obj {
    nam = "cable",
    disp = es.tool "Силовой кабель",
    cnd = "{toolbox}.opened",
    dsc = "Единственная полезная штука во всём этом хламе -- соединительный {кабель} с клеммами.",
    tak = "Я забираю из шкафа кабель.",
    inv = "Обычный силовой кабель с клеммами, ничего интересного."
}

es.terminal {
    nam = "comp.terminal",
    locked = function(s)
        return not all.comp.unlocked
    end,
    commands_help = {
        diag = "программа диагностики операционного модуля",
        modres = "перезагрузка операционного модуля",
        status = "проверка статуса диагностики операционных модулей",
        readlog = "программа чтения удалённых логов",
        files = "получение списка файлов в личном профиле",
        read = "чтения файла из личного профиля",
        volt = "регулировка напряжения по контурам",
        circ = "переназначение энергетических контуров",
        elock = "сервис управления электронными замками"
    },
    mod = function(s, args)
        local mod = s:arg(args)
        if not mod then
            return false, {
                "Не указан номер операционного модуля.",
                "",
                "Синтаксис:",
                "diag [номер операционного модуля]"
            }
        elseif not tonumber(mod) then
            return false,
                es.error("Некорректный формат модуля операционного модуля: "..mod)
        else
            mod = tonumber(mod)
            local mk = _("module"..tostring(mod - 3))
            if mod < 4 or mod > 8 or not mk.active then
                return false, es.error("Модуль не введён в сервисный режим для проверки.")
            end
            return true, mk
        end
    end,
    commands = {
        circ = function(s, arg)
            return s:error("Нет доступа!")
        end,
        volt = function(s, arg)
            return s:error("Нет доступа!")
        end,
        elock = function(s, args, load)
            local key = s:arg(args)
            if not key then
                return {
                    "Не передан идентификатор оборудования.",
                    "",
                    "Доступное оборудование:",
                    "001. toolbox (строка описания отсутствует)",
                    "002. [идентикатор отсутствует] (строка описания отсутствует)",
                    "",
                    "Синтаксис:",
                    "elock [идентификатор оборудования]"
                }
            elseif key == "toolbox" and not load then
                return "$load"
            elseif key == "toolbox" then
                local t = all.toolbox
                if t.locked then
                    t.locked = false
                    return string.format(
                        "Электронный замок для оборудования \"%s\" разблокирован.",
                        key)
                elseif not t.locked and t.opened then
                    return s:error("Невозможно заблокировать электронный замок!")
                elseif not t.locked then
                    t.locked = true
                    return string.format(
                        "Электронный замок для оборудования \"%s\" заблокирован.",
                        key)
                end
            else
                return s:error("Неизвестный идентификатор оборудования: "..key)
            end
        end,
        readlog = function(s, args, load)
            local seed = s:arg(args)
            if not seed then
                return {
                    "Не передан идентификатор модуля.",
                    "",
                    "Синтаксис:",
                    "readlog [номер модуля]"
                }
            end
            seed = tonumber(seed)
            if not seed then
                return s:error("Некорректный формат номер модуля: " .. seed)
            end
            if seed < 1 or seed > 9 then
                return s:error("Неизвестный номер модуля: " .. seed)
            end
            if not load then
                return "$load"
            end
            return es.generateLog(seed, 26)
        end,
        diag = function(s, args, loaded)
            local b,res = s:mod(args)
            if not b then
                return res
            end
            if not loaded then
                return "$load"
            end
            local ep1,ep2 = all.module1:endpoints()
            if not res.problem then
                res.checked = true
                local num = res:number()
                if num == 5 then
                    all.comp.problem = "volt"
                    return {
                        string.format("Модуль %s: предупреждение:", num),
                        "Обнаружено повышенное напряжение в пределах допуска.",
                        "Диагностика прошла успешно."
                    }
                else
                    return string.format(
                        "Модуль %s: диагностика прошла успешно.", num)
                end
            elseif res.problem == "hard"
                and res:number() == 8 and ep1
                and _(ep1):number() == 5 and _(ep2):number() == 8 then
                res.checked = true
                return string.format(
                    "Модуль %s: диагностика прошла успешно.", res:number())
            elseif res.problem == "reset" or res.problem == "hard" then
                if res:number() == 8 and not all.comp.mus then
                    all.comp.mus = true
                    es.music("juxtaposition", 2)
                end
                all.comp.problem = "reset"
                return s:error(string.format("Модуль %s: не отвечает на диагностические команды.", 
                    res:number()))
            end
        end,
        read = function(s, args, load)
            local fl = s:arg(args)
            if not fl then
                return {
                    "Не задано имя файла.",
                    "",
                    "Синтаксис:",
                    "read [имя файла]"
                }
            end
            if not load then
                return "$load"
            end
            if fl == "dump-01312.dat" then
                return es.generateLog(10334, 21)
            elseif fl == "dump-02476.dat" then
                return es.generateLog(22431, 26)
            elseif fl == "message-3471-11-23.txt" then
                return {
                    "",
                    "Сергей, я всё понимаю, но сделать сейчас мы ничего не можем. Замену",
                    "для десятого модуля опять не привели. Официальный запрос, конечно же,",
                    "направлялся. Если в следующий раз не привезут, давай оформим жалобу.",
                    "Номер запроса: 013-456.",
                    "",
                    "С уважением,",
                    "Арто Марутян"
                }
            elseif fl == "message-3487-16-24.txt" then
                return {
                    "",
                    "Сергей Алексеевич, ну в самом деле! Я не могу подобное одобрить!",
                    "Мы на пороге величайшего открытия, а ты хочешь, чтобы я всё обесточил",
                    "на несколько дней! Нет, извини. Этого не будет. Если модуль",
                    "окончательно выйдет из строя, ссылайся на меня. Пусть я буду во всём",
                    "виноват. Можешь даже это сообщение как компромат сохранить.",
                    "Да и вообще у меня есть большие сомнения, что после вашего ремонта",
                    "станет лучше. Помню, как вы в последний раз ремонтировали!",
                    "",
                    "С уважением,",
                    "Арто Марутян"
                }
            elseif fl == "message-3489-14-05.txt" then
                return {
                    "",
                    "Сергей, повторяться я не буду. Модуль работает, проходит все тесты.",
                    "А у нас есть сроки, за несоблюдение которых могут вообще прикрыть",
                    "весь проект. О таком варианте ты не думал? Да, да, меня бы давно уже",
                    "уволили, если бы была прямая связь. Давай просто заниматься своей",
                    "работой, а не переводить стрелки.",
                    "",
                    "С уважением,",
                    "Арто Марутян"
                }
            elseif fl == "message-3493-17-03.txt" then
                return {
                    "",
                    "Я не понимаю, теперь уже два модуля плохо работают? Что вы там с ними",
                    "делаете? Это же не расходники! Разберитесь! Это ваша работа.",
                    "",
                    "С уважением,",
                    "Арто Марутян"
                }
            elseif fl == "memo.txt" then
                return {
                    "",
                    "Чтобы не забыть! На пятый модуль подаётся избыточное напряжение,",
                    "причину мы так и не установили, но сейчас это не важно. Модуль должен",
                    "выдержать. Главное: если соединить его с восьмым, происходит",
                    "горячая перезагрузка, и восьмой снова начинает работать. Что делать с",
                    "десятым я пока не знаю.",
                }
            else
                return string.format("Файл \"%s\" не найден.", fl)
            end
        end,
        files = function(s, args, load)
            if not load then
                return "$load"
            end
            return {
                "Список файлов в личном профиле:",
                "",
                "[001] dump-01312.dat             12.21 KB        3369T0812.0",
                "[002] dump-02476.dat              9.84 KB        3454T0311.0",
                "[003] message-3471-11-23.txt      0.42 KB        3471T1123.0",
                "[004] message-3487-16-24.txt      0.70 KB        3487T1624.0",
                "[005] message-3489-14-05.txt      0.52 KB        3489T1405.0",
                "[006] message-3493-17-03.txt      0.28 KB        3493T1703.0",
                "[007] memo.txt                    0.42 KB        3504T1306.0"
            }
        end,
        modres = function(s, args, loaded)
            local b,res = s:mod(args)
            if not b then
                return res
            end
            if not loaded then
                return "$load"
            end
            if res.problem == "reset" then
                res.problem = false
                if all.comp.problem == "reset" then
                    all.comp.problem = false
                end
            end
            if res.problem == "hard" then
                local ep1,ep2 = all.module1:endpoints()
                if res:number() == 8 and ep1 and
                    _(ep1):number() == 5 and _(ep2):number() == 8 then
                    all.comp.problem = false
                    res.checked = false
                    return {
                        string.format("Модуль %s: перезагрузка прошла успешно.",
                            res:number()),
                        "Настройки диагностики сброшены."
                    }
                else
                    all.comp.problem = "hard"
                    return {
                        s:error(string.format("Модуль %s: невозможно произвести перезагрузку.",
                            res:number()))
                    }
                end
            else
                res.checked = false
                return {
                    string.format("Модуль %s: перезагрузка прошла успешно.",
                        res:number()),
                    "Настройки диагностики сброшены."
                }
            end
        end,
        status = function(s, args)
            local tab = {
                "Модуль 01: диагностика прошла успешно",
                "Модуль 02: диагностика прошла успешно",
                "Модуль 03: диагностика прошла успешно"
            }
            for i = 1, 5, 1 do
                local txt = ""
                local mobj = _("module"..i)
                if not mobj.checked then
                    txt = "данные диагностики устарели"
                else
                    txt = "диагностика прошла успешно"
                end
                table.insert(tab, "Модуль 0"..tostring(i + 3)..": "..txt)
            end
            table.insert(tab, "Модуль 10: модуль не найден")
            return tab
        end
    },
    before_exit = function(s)
        if not all.alexin.done and not all.module1:hasUnchecked() then
            all.alexin.done = true
            es.music("hope", 1, 0, 4000)
            es.walkdlg {
                dlg = "alexin",
                branch = "final",
                disp = "Технический отсек лаборатории",
                pic = "station/tech"
            }
            return true
        end
    end
}
-- endregion

-- region rack
es.room {
    nam = "rack",
    mus = false,
    pic = "station/tech",
    disp = "Стойка с модулями",
    dsc = [[Оборудование здесь уже не напоминает мне о космических кораблях. Скорее, кажется, что я нахожусь на электростанции с холодным термоядерным синтезом.]],
    onexit = function(s)
        local a1,a2 = all.module1:endpoints()
        if a1 and not a2 then
            _(a1).cable = false
            local nn = _(a1):name(2)
            p(string.format("Я снял клемму с %s модуля.", nn))
        end
    end,
    enter = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("fatigue2", 2)
        end
    end,
    obj = {
        "keybox",
        "module_rack",
        "module1",
        "module2",
        "module3",
        "module4",
        "module5",
        "cable_holder"
    },
    way = {
        path { "Отойти", "tech" }
    }
}

es.obj {
    nam = "keybox",
    dsc = function(s)
        if not have("key") then
            return "Я замечаю в стене знакомый {лючок} с сервисным ключом."
        else
            return "На стене рядом со стойкой -- {люк} для сервисного ключа."
        end
    end,
    act = function(s)
        if not have("key") then
            take("key")
            return "Я забираю сервисный ключ из люка на стене."
        else
            return "Ключ я уже забрал."
        end
    end,
    used = function(s, w)
        if w.nam == "key" then
            purge("key")
            return "Я кладу сервисный ключ обратно в люк."
        end
    end
}

es.obj {
    nam = "key",
    disp = es.tool "Сервисный ключ",
    inv = "Стандартный сервисный ключ, такой же используется и на \"Грозном\"."
}

es.obj {
    nam = "module_rack",
    dsc = "{Модули} -- длинные цилиндры, которые могут выдвигаться из прорезей в стойке с помощью сервисного ключа -- расположены в несколько рядов. Мне нужны модули",
    act = "У модулей есть только порядковые номера -- нет другого способа понять, за что они отвечают, кроме как изучить, чему соответствует тот или иной номер.",
    used = function(s, w)
        if w.nam == "key" then
            return "С помощью ключа можно перевести любой из модулей в диагностический режим."
        end
    end
}

local base_module = {
    active = false,
    checked = false,
    problem = false,
    cable = false,
    dsc = function(s)
        if s.active then
            return s.dsc_active
        else
            return s.dsc_inactive
        end
    end,
    modules = {
        "module1",
        "module2",
        "module3",
        "module4",
        "module5",
    },
    hasUnchecked = function(s)
        for i,v in ipairs(s.modules) do
            if not _(v).checked then
                return true
            end
        end
        return false
    end,
    activeModule = function(s)
        for i,v in ipairs(s.modules) do
            if _(v).active then
                return v
            end
        end
    end,
    endpoints = function(s)
        local a,b = false,false
        for i,v in ipairs(s.modules) do
            local vo = _(v)
            if vo.cable == "start" then
                a = v
            elseif vo.cable == "end" then
                b = v
            end
        end
        if not a and not b then
            return false
        else
            return a,b
        end
    end,
    name = function(s, idx)
        local a,b,c = s.code:triple(",")
        if idx == 1 then
            return a
        elseif idx == 2 then
            return b
        elseif idx == 3 then
            return c
        end
    end,
    number = function(s)
        local num = tonumber(s.nam:sub(7, 8))
        return num + 3
    end,
    used = function(s, w)
        if w.nam == "key" and s.active then
            s.active = false
            return string.format(
                "Я отключаю диагностический режим у %s модуля.",
                s:name(2))
        elseif w.nam == "key" then
            if s:activeModule() then
                return "Диагностический режим можно активировать только на одном модуле, иначе программа диагностики не будет корректно работать."
            else
                s.active = true
                return string.format(
                    "Я вставляю сервисный ключ и активирую %s модуль.",
                    s:name(1))
            end
        elseif w.nam == "cable" then
            local e1,e2 = s:endpoints()
            if not e1 then
                s.cable = "start"
                return string.format(
                    "Я подключил одну клемму кабеля к %s модулю.",
                    s:name(3))
            elseif e1 == s.nam then
                return "Я не могу подключить обе клеммы к одному и тому же модулю. Да и зачем это делать?"
            else
                s.cable = "end"
                purge("cable")
                return string.format(
                    "Я подключил кабель к %s и %s модулям. Теперь, возможно, стоит покопаться в терминале -- если, конечно, я правильно подключил клеммы.",
                    _(e1):name(3), s:name(3))
            end
        end
    end,
    act = function(s)
        return ("На модуле высвечиваются цифры \"0%d\" -- %s операционный модуль."):format(s:number(), s:name(1))
    end
}

es.obj(base_module) {
    nam = "module1",
    code = "четвёртый,четвёртого,четвёртому",
    dsc_inactive = "{четыре},",
    dsc_active = "{четыре} (сейчас выдвинут),"
}

es.obj(base_module) {
    nam = "module2",
    code = "пятый,пятого,пятому",
    dsc_inactive = "{пять},",
    dsc_active = "{пять} (в диагностическом режиме),"
}

es.obj(base_module) {
    nam = "module3",
    code = "шестой,шестого,шестому",
    dsc_inactive = "{шесть},",
    dsc_active = "{шесть} (переключен в режим диагностики),",
    problem = "reset"
}

es.obj(base_module) {
    nam = "module4",
    code = "седьмой,седьмого,седьмому",
    dsc_inactive = "{семь} и",
    dsc_active = "{семь} (выдвинут) и"
}

es.obj(base_module) {
    nam = "module5",
    code = "восьмой,восьмого,восьмому",
    dsc_inactive = "{восемь}.",
    dsc_active = "{восемь} (в диагностическом режиме).",
    problem = "hard"
}

es.obj {
    nam = "cable_holder",
    dsc = function(s)
        local a,b = all.module1:endpoints()
        if a and b then
            return string.format("{Кабель} сейчас тянется от %s к %s модулю.",
                _(a):name(2), _(b):name(3))
        elseif a then
            return string.format("{Кабель} подключён одним концом к %s модулю.",
                _(a):name(3))
        end
    end,
    act = function(s)
        local a,b = all.module1:endpoints()
        if a and b then
            _(a).cable = false
            _(b).cable = false
            take("cable")
            return "Я отключил кабель от обоих модулей."
        elseif a then
            _(a).cable = false
            local nn = _(a):name(2)
            return string.format("Я снял клемму с %s модуля.", nn)
        end
    end
}
-- endregion

-- region hall
es.room {
    nam = "hall",
    been = false,
    pic = "station/hall",
    disp = "Холл",
    dsc = [[Холл почему-то напоминает мне зал ожидания на аэровокзале -- вскоре после того, как улетел очередной межконтинентальный лайнер, и привычный гомон сменила мягкая сонная тишина.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "У меня ещё есть здесь работа."
            return false
        elseif t.nam == "lab" and not all.alexin.done then
            p "Думаю, для начала стоит закончить свою работу в техническом отсеке."
            return false
        else
            s.been = true
        end
    end,
    obj = { "porthole", "simonova" },
    way = {
        path { "В коридор", "main" },
        path { "В инженерный отсек", "tech" },
        path { "В лабораторию", "lab" }
    }
}

es.obj {
    nam = "porthole",
    dsc = "Широкий {иллюминатор} похож на экран, по которому круглые сутки показывают светящуюся в темноте, точно жемчужина, планету.",
    act = "Огромный вихрь теперь захватывает половину Сантори-5. Интересно, как долго он будет продолжаться?"
}

es.obj {
    nam = "simonova",
    done = false,
    dsc = "Рядом с иллюминатором стоит {Симонова} и смотрит отрешённым взглядом на своё отражение в стекле.",
    cnd = "not {hall}.been",
    act = function(s)
        if s.done then
            return "Мне кажется, она хочет побыть одна."
        else
            s.done = true
            es.walkdlg("simonova.head")
            return true
        end
    end
}
-- endregion

-- region lab
es.room {
    nam = "lab",
    mus = false,
    pic = "station/lab",
    disp = "Лаборатория",
    dsc = [[Странно, но в лаборатории никого нет -- все рабочие столы пустые, лишь мерцают экраны терминалов.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("premonition", 1, 0, 4000)
        end
    end,
    obj = { "evac", "aquarium", "labcomp" },
    way = {
        path { "В холл", "hall" }
    }
}

es.obj {
    nam = "evac",
    dsc = "Можно подумать, что срочно объявили {эвакуацию}, и сотрудники ушли, даже не заблокировав компьютеры. Алый свет, как в проявочной, лишь усиливает это ощущение.",
    act = "Наверное, у всех какой-нибудь внештатный перерыв, я ещё не слишком разобрался в порядках на станции."
}

es.obj {
    nam = "aquarium",
    dsc = "{Нуболиды} в камере сегодня взволнованы -- они носятся кругами, закручиваясь штопором, как в водовороте, словно хотят вырваться наружу.",
    act = function(s)
        walk("outro1")
        return true
    end
}

es.obj {
    nam = "labcomp",
    dsc = "{Терминал} рядом с камерой работает, но изображение на экране дёргается, как во время системной ошибки.",
    act = function(s)
        walk("lab.terminal")
        return true
    end
}

es.terminal {
    nam = "lab.terminal",
    locked = function(s)
        return true
    end,
    commands_help = {
        ion = "настройка ионизации воздуха",
        reset = "сброс всех настроек",
        kray = "излучение Крайченко"
    },
    commands = {
        kray = true,
        ion = true,
        reset = true
    },
    welcome = function(s)
        return "Внимание! Повышенный уровень излучения Крайченко в контейнере."
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pic = "common/nubolids3",
    disp = "Лаборатория",
    dsc = [[Я подхожу ближе и касаюсь стекла рукой. Наболиды тут же замирают. Они чуствуют меня. Я даже не могу избавиться от мысли, что они каким-то образом видят, что я стою у камеры.
    ^Словно в подтверждение моих слов алые ленты оживают и тянутся к моей руке, касаются сквозь стекло моих пальцев. Меня пронизывают слабые разряды электричества.
    ^Я отдёргиваю руку.]],
    enter = function(s)
        es.music("horn")
    end,
    next = function(s)
        gamefile("game/09.lua", true)
    end
}
-- endregion