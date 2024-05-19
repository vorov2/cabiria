-- Chapter 14
dofile "lib/es.lua"

es.main {
    chapter = "14",
    onenter = function(s)
        es.music("countdown")
        take("cutter")
        walkin("intro1")
    end
}

es.obj {
    nam = "cutter",
    disp = es.tool "Плазменный резак",
    inv = "Стандартный плазменный резак. Чтобы включить, нужно дёрнуть за спусковой крючок." 
}

-- region intro1
es.room {
    nam = "intro1",
    noinv = true,
    seconds = 2,
    minutes = 32,
    pic = "common/station",
    enter = function(s)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds - 1
        if s.seconds < 0 then
            s.seconds = 59
            s.minutes = s.minutes - 1
        elseif s.seconds == 55 then
            timer:stop()
            walkin("nearlab")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    txt = "НИОС \"Кабирия\"^^",
    dsc = function(s)
        local sec = tostring(all.intro1.seconds)
        if #sec == 1 then
            sec = "0"..sec
        end
        return string.format("%sОсталось до схода с орбиты: 00:%d:%s", s.txt,
            all.intro1.minutes, sec)
    end
}
-- endregion

-- region nearlab
es.room {
    nam = "nearlab",
    pic = "station/debris1",
    disp = "Коридор",
    dsc = [[Мне кажется, каждый шаг может стать последним -- пол раскроит жуткая трещина, меня затянет в кипящие огнём недра станции, -- и я придерживаюсь за трещащий леер в стене, как за спасательную верёвку.]],
    enter = function(s)
        es.music("doom", 2, 0, 4000)
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Нет, Майоров сказал, что Вера пошла в лабораторию. Нет смысла возвращаться. К тому же со спины на меня надвигается темнота."
            return false
        end
    end,
    obj = { "screams", "labdoor" },
    way = {
        path { "К рубке", "main" },
        path { "В лабораторию", "labhall" }
    }
}

es.obj {
    nam = "screams",
    dsc = "В спину мне бьют чьи-то надрывные {крики} -- кто-то пытается кричать, когда воздух в лёгких почти вышел.",
    act = "Я оборачиваюсь, но никого не вижу. Коридор почти полностью тёмный, лишь несколько последних ламп, точно искорки, медленно гаснут, сдаваясь сумраку."
}

es.obj {
    nam = "labdoor",
    dsc = "Дверь в {лабораторию} открыта, и из неё падает на пол длинная синяя тень.",
    act = "Майоров сказал, что Вера пошла в лабораторию."
}
-- endregion

-- region labhall
es.room {
    nam = "labhall",
    pic = "station/hall_blue",
    disp = "Холл лаборатории",
    dsc = [[В холле, который после давящей темноты коридоров, кажется невыносимо огромным, никого нет.]],
    obj = { "porthole", "voices" },
    way = {
        path { "В коридор", "nearlab" },
        path { "В инженерный отсек", "labtech" },
        path { "В лабораторный отсек", "lab" }
    }
}

es.obj {
    nam = "porthole",
    dsc = "Из панорамного {иллюминатора} исходит яркое свечение. Весь отсек пронизывает холодная синева.",
    act = "Сантори-5 с рвущимися в темноту протуберанцами стала теперь куда ближе, чем раньше, и затягивает нас в свой нескончаемый ураган."
}

es.obj {
    nam = "voices",
    dsc = "Из лабораторного отсека доносятся громкие {голоса}.",
    act = function(s)
        if not all.lab.visited then
            return "Я узнаю голос Веры."
        else
            return "Надо разобраться, что там происходит."
        end
    end
}
-- endregion

-- region lab
es.room {
    nam = "lab",
    visited = false,
    crisis = false,
    pic = "station/lab",
    disp = "Лабораторный отсек",
    dsc = [[В лаборатории стоит треск от работающих терминалов, перемигиваются индикаторы, по лупатым экранам ползут строчки трассировок. Как будто ничего не произошло.]],
    onenter = function(s)
        if not s.visited then
            s.visited = true
            es.music("premonition", 2, 0, 3000)
            es.walkdlg {
                dlg = "vera",
                branch = "head",
                pic = "station/lab",
                disp = "Лабораторный отсек"
            }
            return false
        end
    end,
    onexit = function(s, t)
        if t.nam == "labhall" and s.crisis then
            return "На это нет времени."
        end
    end,
    obj = {
        "simonova",
        "simcomp",
        "vera1",
        "simcomp2",
        "chamber",
        "labcomp"
    },
    way = {
        path { "В холл", "labhall" }
    }
}

es.obj {
    nam = "simonova",
    talk = false,
    done = false,
    dsc = function(s)
        if not s.done then
            return "{Симонова} -- осунувшаяся, со спутанными волосами -- стоит у своего терминала и что-то быстро выщёлкивает на клавиатуре, не глядя в экран."
        else
            return "{Симонова} c"
        end
    end,
    act = function(s)
        if not s.done and not s.talk then
            s.talk = true
            es.walkdlg("simonova.head")
            return true
        elseif not s.done and s.talk and not all.labcomp.tenebris then
            es.walkdlg("simonova.nogo")
            return true
        elseif not s.done and s.talk and all.labcomp.tenebris then
            s.done = true
            es.walkdlg("simonova.go")
            return true
        else
            return "Говорить нам больше не о чем."
        end
    end
}

es.obj {
    nam = "simcomp",
    cnd = "not {simonova}.done",
    dsc = "{Вычислительный аппарат} в ответ раздражённо пищит, выплёвывая сообщения об ошибках, но Симонова ничего не замечает.",
    act = "Кажется, она пытается наугад вводить какие-то координаты."
}

es.obj {
    nam = "vera1",
    task = false,
    dsc = function(s)
        if all.simonova.talk and not s.task then
            return "{Вера} показывает головой на дверь, предлагая отойти в сторону."
        elseif all.simonova.done then
            return "{Верой} стоит у двери в холл."
        else
            return "{Вера} поглаживает её по спине, пытается успокоить."
        end
    end,
    act = function(s)
        if not all.lab.crisis and (not all.simonova.talk or s.task) then
            es.walkdlg("vera.go")
            return true
        elseif not all.lab.crisis and not s.task then
            s.task = true
            es.walkdlg("vera.chamber")
            return true
        else
            return "Сейчас не до разговоров."
        end
    end
}

es.obj {
    nam = "simcomp2",
    cnd = "{simonova}.done",
    dsc = "{Вычислительный аппарат} Симоновой по-прежнему работает.",
    act = "Вычислительный аппарат заблокирован, доступа без ключ-карты нет вообще.",
    used = function(s, w)
        if not all.lab.crisis then
            return "Сейчас мне до этого."
        end
        if w.nam == "keycard" then
            walkin("sim.terminal")
            return true
        elseif w.nam == "servicekey" then
            return "Сервисный ключ здесь не поможет."
        elseif w.nam == "cutter" then
            es.sound("cutter")
            es.walkdlg {
                dlg = "simonova",
                branch = "nubolids2",
                disp = "Лабораторный отсек",
                pic = "station/lab"
            }
            return true
        end
    end
}

es.terminal {
    nam = "sim.terminal",
    locked = function(s)
        return true
    end,
    commands_help = {
        coor = "расчёт координат",
        probe = "пробирование координат",
        tunnel = "экспериментальное туннелирование"
    },
    commands = {
        coor = true,
        probe = true,
        tunnel = true
    }
}

es.obj {
    nam = "chamber",
    dsc = function(s)
        if all.lab.crisis then
            return "^{Камера содержания} заполнена кипящей алой массой."
        elseif not all.labcomp.tenebris then
            return "^Защитная тень на {камере содержания}, скрывающая от глаз инопланетных паразитов, отключена. Нуболиды вихрем носятся в своей прозрачной тюрьме и бьются о стенки."
        else
            return "^{Камера содержания} затянута густой тенью."
        end
    end,
    act = function(s)
        if all.lab.crisis then
            return "Кажется, они материализуются в камере из пустоты. Скоро камера не выдержит."
        elseif not all.labcomp.tenebris then
            return "Даже нуболиды чувствуют, что станции осталось недолго."
        else
            return "Когда не смотришь на этих бешеных червей, становится действительно спокойнее."
        end
    end
}

es.obj {
    nam = "labcomp",
    examed = false,
    fixed = false,
    unlocked = false,
    tenebris = false,
    dsc = function(s)
        if not s.fixed then
            return "На экране {терминала} рядом с камерой пляшут какие-то сообщения."
        else
            return "На экране {терминала} рядом с камерой отображается приветствие операционной системы."
        end
    end,
    act = function(s)
        if all.lab.crisis then
            return "Это не поможет, Симонова включила что-то на своём терминале."
        elseif not s.fixed then
            s.examed = true
            return "Кажется, вычислительный аппарат завис и не реагирует на нажатия клавиш. По экрану бегут бессвязные строчки логов и сообщения об ошибках."
        else
            s.unlocked = false
            walkin("lab.terminal")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "cutter" then
            return "Я не собираюсь жечь вычислительный аппарат плазменным резаком."
        elseif w.nam == "servicekey" and not all.simonova.talk then
            return "Надо сначала разобраться, что здесь происходит."
        elseif w.nam == "servicekey" and all.simonova.talk then
            s.fixed = true
            return "Я вставляю сервисный ключ в разъём и поворачиваю его по часовой стрелке. Изображение на экране мигает, начинается загрузка системы."
        elseif w.nam == "keycard" then
            if all.lab.crisis then
                return "Это не поможет, Симонова включила что-то на своём терминале."
            elseif not s.fixed then
                return "Вычислительный аппарат надо сначала перезагрузить."
            else
                s.unlocked = true
                walkin("lab.terminal")
                return true
            end
        end
    end
}

local system_error = function(s, args, load)
    if not load then
        return "$load"
    end
    local code = "ABCDEFGH"
    local err = code:charAt(rnd(#code)) .. tostring(rnd(10, 86))
    return string.format("Внимание! Невозможно запустить модуль из-за ошибки кодом %s.", err)
end
es.terminal {
    nam = "lab.terminal",
    locked = function(s)
        return not all.labcomp.unlocked
    end,
    vars = {
        ten = false
    },
    commands_help = {
        lux = "настройка уровня освещения",
        ion = "настройка ионизации воздуха",
        reset = "сброс всех настроек",
        kray = "излучение Крайченко",
        tenebris = "перекрытие внешнего потока света"
    },
    commands = {
        kray = system_error,
        lux = system_error,
        ion = system_error,
        reset = system_error,
        tenebris = function(s, args, load)
            local arg = s:arg(args)
            local num = tonumber(arg)
            if not arg or not num then
                local txt = "Отсутствует обязательный параметр."
                if arg then
                    txt = "Некорректный параметр команды."
                end
                local cond = "отключено"
                if s.vars.ten then
                    cond = "включено"
                end
                return {
                    txt,
                    "",
                    "Синтаксис:",
                    "tenebris [состояние перекрытия]",
                    "Текущее состояние перекрытия: " .. cond,
                    "Допустимые значения:",
                    "0 - отключено",
                    "1 - включено"
                }
            end
            if not load then
                return "$load"
            end
            if num == 0 then
                s.vars.ten = false
                all.labcomp.tenebris = false
                return "Перекрытие внешнего потока света отключено."
            else
                s.vars.ten = true
                all.labcomp.tenebris = true
                return "Перекрытие внешнего потока света включено."
            end
        end
    },
    before_exit = function(s)
        if not s.vars.ten and all.simonova.done then
            all.lab.crisis = true
            es.walkdlg {
                dlg = "simonova",
                branch = "nubolids1",
                disp = "Лабораторный отсек",
                pic = "station/lab"
            }
            return true
        end
    end
}
-- endregion

-- region labtech
es.room {
    nam = "labtech",
    mus = false,
    pic = "station/tech",
    disp = "Инженерный отсек лаборатории",
    dsc = [[Инженерный отсек выглядит, как заброшенная много лет назад техничка. Все вычислительные аппараты отключены, в воздухе витает пыль.]],
    enter = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("tragedy", 2)
        end
    end,
    obj = {
        "keybox",
        "modules",
        "mycomp",
        "desk",
        "locker",
        "cardholder"
    },
    way = {
        path { "В холл", "labhall" }
    }
}

es.obj {
    nam = "keybox",
    taken = false,
    dsc = function(s)
        if not s.taken then
            return "На стене у входа висит в кронштейне {сервисный ключ}."
        else
            return "На стене у входа висит {кронштейн} для сервисного ключа."
        end
    end,
    act = function(s)
        if not s.taken then
            s.taken = true
            take("servicekey")
            return "Я беру из бокса сервисный ключ."
        else
            return "Здесь хранится сервисный ключ."
        end
    end,
    used = function(s, w)
        if w.nam == "cutter" then
            return "На станции и так хватает разрушений."
        elseif w.nam == "servicekey" then
            return "Думаю, сервисный ключ мне ещё пригодится."
        end
    end
}

es.obj {
    nam = "servicekey",
    disp = es.tool "Сервисный ключ",
    inv = "Стандартный сервисный ключ, нечего тут разглядывать."
}

es.obj {
    nam = "modules",
    dsc = "У стойки с модулями лежит несколько {металлических гильз} -- запасные блоки для перегоревшей десятки.",
    act = "Это было последнее, над чем работал Алексин."
}

es.obj {
    nam = "mycomp",
    dsc = "{Терминал}, за которым я работал, также обесточен.",
    act = "Не включается. Видимо, где-то сгорела проводка, или предохранители выбило."
}

es.obj {
    nam = "desk",
    dsc = "{Рабочий стол} Алексина прячется в тени.",
    act = "На столе нет ничего интересного."
}

es.obj {
    nam = "locker",
    unlocked = false,
    unbar = false,
    dsc = function(s)
        if not s.unbar then
            return "Рядом притулился его личный {металлический шкафчик}."
        else
            return "Рядом притулился его личный {металлический шкафчик} c отодвинутым верхним ящиком."
        end
    end,
    act = function(s)
        if not s.unlocked then
            return "Шкафчик закрыт на ключ."
        elseif not s.unbar then
            s.unbar = true
            return "Я отодвигаю первый ящик."
        elseif s.unbar then
            s.unbar = false
            return "Я задвигаю ящик."
        end
    end,
    used = function(s, w)
        if w.nam == "cutter" and s.unlocked then
            return "Я уже срезал замок."
        elseif w.nam == "cutter" then
            s.unlocked = true
            es.sound("cutter")
            return "Я включаю плазменный резак и аккуратно срезаю личинку замка."
        elseif w.nam == "keycard" and not s.unbar then
            return "Я не могу положить карту в закрытый ящик."
        elseif w.nam == "keycard" then
            purge("keycard")
            all.cardholder.taken = false
            return "Я бросаю ключ-карту обратно в ящик."
        end
    end
}

es.obj {
    nam = "cardholder",
    taken = false,
    cnd = "{locker}.unbar and not s.taken",
    dsc = "В ящике лежит магнитная {ключ-карта}.",
    act = function(s)
        s.taken = true
        take("keycard")
        return "Я беру карту."
    end
}

es.obj {
    nam = "keycard",
    disp = es.tool "Ключ-карта",
    inv = "Ключ-карта Алексина, её уровня доступа должно хватить для всех терминалов."
}
-- endregion

-- region death1
es.room {
    nam = "death1",
    pic = "station/lab",
    disp = "Лабораторный отсек",
    dsc = [[Я ничего не успеваю сделать. Симонова хватает со стола тяжёлую клавиатуру и с размаху бьёт Веру по голове. Та охает, отшатывается и падает на пол. Я подбегаю к ней, падаю на колени. Клавиатура падает на металлический пол, разлетаются повсюду колпачки от клавиш.
    ^-- Вера! Вера! -- кричу я.
    ^Она не отвечает.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "RELOAD",
    next = function(s)
        gamefile("game/14.lua", true)
    end
}
-- endregion

-- region lab2
es.room {
    nam = "lab2",
    pic = "common/nubolids6",
    disp = "Лабораторный отсек",
    dsc = [[Потолок над нами угрожающе колышется, света почти нет. Лишь иногда сквозь плотную массу нуболидов пробивается красный просверк и отбрасывает на стены длинную тень.
    ^Мы в западне.]],
    enter = function(s)
        snapshots:make()
    end,
    obj = { "vera2", "simonova2", "nubolids" },
    way = {
        path { "В холл", "death2" }
    }
}

es.obj {
    nam = "vera2",
    dsc = "{Вера} прижимается к стене у выхода, с ужасом глядя на нуболидов. Она боится пошевелиться.",
    act = function(s)
        es.walkdlg("vera.death")
        return true
    end
}

es.obj {
    nam = "simonova2",
    dsc = "{Симонова} стоит, сгорбившись, согнув в локтях руки. Голова у неё мелко трясётся, как у старухи.",
    act = function(s)
        es.walkdlg("simonova.death")
        return true
    end
}

es.obj {
    nam = "nubolids",
    dsc = "Из кровяного ковра {нуболидов} вытягиваются осторожные, словно робкие отростки, высматривая что-то, изучая всё вокруг.",
    act = function(s)
        es.walkdlg("nubolids.death")
        return true
    end,
    used = function(s, w)
        if w.nam == "cutter" then
            es.sound("cutter")
            es.music("onechance", 1, 0, 2000)
            es.walkdlg {
                dlg = "vera",
                branch = "rescue",
                disp = "Лабораторный отсек",
                pic = "common/nubolids3"
            }
            return true
        end
    end
}
-- endregion

-- region death2
es.room {
    nam = "death2",
    pic = "common/nubolids3",
    disp = "Лабораторный отсек",
    dsc = [[Я бросаюсь к Вере в безумной надежде опередить этих чудовищных созданий, но мощный поток алых червей накрывает нас с головой.]],
    next_disp = "RELOAD",
    enter = function(s)
        es.music("death")
    end,
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region hall2
es.room {
    nam = "hall2",
    mus = false,
    pic = "station/hall_blue",
    disp = "Холл",
    dsc = [[Такое чувство, что всё у меня внутри разорвано на части, что я сам доживаю последние мгновения, что в любую секунду кровь брызнет из глаз.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("santorum", 1, 0, 2000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "labtech" or t.nam == "lab" then
            p "Сейчас на это нет времени."
            return false
        elseif t.nam == "interlude1" and not all.vera3.done then
            p "Сначала надо решить, что мы будем делать."
            return false
        end
    end,
    obj = { "simonova3", "vera3" },
    way = {
        path { "В коридор", "interlude1" },
        path { "В инженерный отсек", "labtech" },
        path { "В лабораторный отсек", "lab" }
    }
}

es.obj {
    nam = "simonova3",
    done = false,
    dsc = "{Симонова} лежит на полу рядом с иллюминатором, до ужаса похожая на сломанную куклу -- руки прижаты к телу, ноги ровно вытянуты.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.simonova")
            return true
        else
            return "Симонова мертва."
        end
    end
}

es.obj {
    nam = "vera3",
    done = false,
    dsc = function(s)
        if s.done then
            return "{Вера} стоит рядом с ней, размывая по щекам слёзы."
        else
            return "{Вера} сидит рядом с ней на коленях, размывая по щекам слёзы."
        end
    end,
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.todo")
            return true
        else
            return "Нет времени на разговоры."
        end
    end
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    noinv = true,
    pic = "station/debris4",
    disp = "Коридор",
    dsc = [[Мы выходим в коридор.
    ^Основная лестница у лифтов сломана, и, если спуститься там не получится, придётся преодолеть с десяток пролётов до пожарного спуска.
    ^Потом добраться до причала.]],
    enter = function(s)
        es.music("bass", 3, 0, 3000)
    end,
    next_disp = "-- Мы справимся, -- шепчу я Вере.",
    next = "corridor1"
}
-- endregion

-- region corridor1
es.room {
    nam = "corridor1",
    pic = function(s)
        if not all.lever.done then
            return "station/wall1"
        else
            return "station/debris2"
        end
    end,
    disp = "Коридор",
    dsc = function(s)
        if not all.lever.done then
            return [[Мы проходим несколько метров, и перед нами вырастает металлическая стена, преграждающая проход.]]
        else
            return [[Путь вперёд открыт, лучше здесь не задерживаться.]]
        end
    end,
    onexit = function(s, t)
        if t.nam == "corridor2" and not all.lever.done then
            p "Дальше прохода нет."
            return false
        elseif t.nam == "main" then
            p "Нет смысла возвращаться."
            return false
        end
    end,
    obj = { "wall", "vera4", "lever" },
    way = {
        path { "К лаборатории", "main" },
        path { "К лифту", "corridor2" }
    }
}

es.obj {
    nam = "wall",
    done = false,
    cnd = "not {lever}.done",
    dsc = "{Перегородка} состоит из прочных стальных пластин.",
    act = "Руками эту стену не отодвинешь.",
    used = function(s, w)
        if w.nam == "servicekey" then
            return "Эта штука тут не поможет."
        elseif w.nam == "cutter" and not s.done then
            s.done = true
            es.walkdlg("vera.cutter")
            return true
        elseif w.nam == "cutter" and s.done then
            return "Надо найти другой способ поднять перегородку."
        end
    end
}

es.obj {
    nam = "vera4",
    dsc = "{Вера} стоит рядом со мной, но мне всё равно кажется, что она рассеивается в подступающем к нам мраке.",
    act = function(s)
        if not all.lever.done then
            es.walkdlg("vera.wall")
            return true
        else
            return "Нам нужно идти."
        end
    end
}

es.obj {
    nam = "lever",
    unlocked = false,
    done = false,
    dsc = function(s)
        if not s.unlocked then
            return "Я замечаю металлическую {коробку}, приделанную к стене рядом с перегородкой."
        else
            return "На стене рядом с перегородкой -- массивный стальной {рычаг}."
        end
    end,
    act = function(s)
        if not s.unlocked then
            return "Раньше я совсем не обращал на неё внимания. Видимо, это какая-то защитная крышка, но поднять её руками не получится."
        elseif s.unlocked and not s.done then
            s.done = true
            return "Я дёргаю за рычаг, и перегородка, отрезавшая нас от остальной части коридора, с лязгом поднимается к потолку. Путь свободен."
        else
            return "Всё уже сделано."
        end
    end,
    used = function(s, w)
        if w.nam == "keycard" then
            return "Ключ-карта здесь не поможет."
        elseif w.nam == "cutter" then
            return "Не все проблемы решаются с помощью плазменного резака, я могу повредить что-нибудь."
        elseif w.nam == "servicekey" then
            s.unlocked = true
            return "В нижней части короба и правда есть отверстие для сервисного ключа, я поворачиваю ключ с неприятным треском, и коробка открывается."
        end
    end
}
-- endregion

-- region corridor2
es.room {
    nam = "corridor2",
    pic = "station/debris1",
    disp = "Коридор",
    dsc = [[Разглядеть что-то в свете рябящих ламп тяжело, и мне всё время кажется, что впереди вздрагивают чьи-то тени -- яростно и ярко, словно их отбрасывают языки огня.]],
    onexit = function(s, t)
        if t.nam == "corridor3" and not all.vera5.done then
            es.walkdlg("vera.corridor2")
            return false
        elseif t.nam == "main" then
            p "Нет смысла возвращаться."
            return false
        end
    end,
    obj = { "vera5" },
    way = {
        path { "К лаборатории", "main" },
        path { "К лифту", "corridor3" }
    }
}

es.obj {
    nam = "vera5",
    done = false,
    dsc = "{Вера} прижимается к моему плечу.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.corridor2")
            return true
        else
            return "Стоит поторопиться."
        end
    end
}
-- endregion

-- region corridor3
es.room {
    nam = "corridor3",
    pic = "station/debris3",
    done = false,
    disp = "Пролёт рядом с рубкой",
    dsc = [[В этой части коридора все стены заросли густой копотью. Я невольно зажимаю нос.]],
    onexit = function(s, t)
        if t.nam == "corridor4" and not s.done then
            s.done = true
            es.walkdlg("vera.deck")
            return false
        elseif t.nam == "main" then
            p "Нет смысла возвращаться."
            return false
        elseif t.nam == "deck" and not all.stairs.done then
            p "Нечего нам там делать."
            return false
        end
    end,
    obj = { "vera6", "debris", "deckdoor" },
    way = {
        path { "К лаборатории", "main" },
        path { "В рубку", "deck" },
        path { "К лифту", "corridor4" }
    }
}

es.obj {
    nam = "vera6",
    done = false,
    dsc = function(s)
        if not all.corridor3.done then
            return "{Вера} спотыкается обо что-то и чуть не падает, успев вовремя ухватить меня за плечо."
        elseif all.stairs.done then
            return "{Вера} тяжело дышит, мы оба выбились из сил."
        else
            return "{Вера} стоит рядом с {Андреевым}."
        end
    end,
    act = function(s)
        if s.done then
            walkin("death5")
            return true
        elseif all.stairs.done then
            s.done = true
            es.walkdlg("vera.godeck")
            return true
        elseif not all.corridor3.done then
            es.walkdlg("vera.corridor3")
            return true
        else
            return "Нет времени на разговоры."
        end
    end
}

es.obj {
    nam = "debris",
    cnd = "not {stairs}.done",
    dsc = "Пол завален {вывернутой арматурой} и кусками обшивки.",
    act = "Надо быть осторожнее. Не переломать бы тут ноги."
}

es.obj {
    nam = "deckdoor",
    dsc = "^В густеющем с каждой минутой мраке вырисовывается открытый {проём} в рубку, откуда льётся умирающий свет.",
    act = function(s)
        if not all.stairs.done then
            return "У нас нет на это времени."
        else
            walkin("deck")
            return true
        end
    end
}
-- endregion

-- region corridor4
es.room {
    nam = "corridor4",
    pic = function(s)
        if not all.lever2.done then
            return "station/wall1"
        else
            return "station/debris5"
        end
    end,
    disp = "Коридор",
    dsc = [[Сердце молотит в груди. Я чувствую, что силы уже на исходе.]],
    onexit = function(s, t)
        if t.nam == "corridor3" and not all.stairs.done then
            p "Нет смысла возвращаться."
            return false
        elseif t.nam == "corridor5" and not all.lever2.done then
            p "Проход перекрыт."
            return false
        elseif t.nam == "corridor5" and not all.andreev1.done then
            p "Надо сначала помочь Андрееву."
            return false
        elseif t.nam == "corridor5" and all.stairs.done then
            walkin("death5")
            return false
        end
    end,
    obj = {
        "andreev1",
        "vera7",
        "vera7b",
        "blocker",
        "lever2"
    },
    way = {
        path { "К рубке", "corridor3" },
        path { "К лифту", "corridor5" }
    }
}

es.obj {
    nam = "andreev1",
    done = false,
    cnd = "not {stairs}.done",
    dsc = function(s)
        if not s.done then
            return "{Андреев} вскрикивает и падает на колени."
        else
            return "{Андреев} вместе с {Верой} стоят рядом."
        end
    end,
    act = function(s, w)
        if not s.done then
            s.done = true
            return "Я помогаю Андрееву подняться."
        else
            return "Надо торопиться."
        end
    end
}

es.obj {
    nam = "vera7",
    cnd = "not {andreev1}.done",
    dsc = "{Вера} подбегает к нему.",
    act = function(s, w)
        es.walkdlg("vera.andreev")
        return true
    end
}

es.obj {
    nam = "vera7b",
    cnd = "{stairs}.done",
    dsc = "{Вера} бежит рядом со мной.",
    act = "Счёт идёт на секунды!"
}

es.obj {
    nam = "blocker",
    cnd = "not {lever2}.done",
    dsc = "{Проход} дальше прегрождает перегородка.",
    act = "Теперь-то я знаю, что с этим нужно делать."
}

es.obj {
    nam = "lever2",
    done = false,
    unlocked = false,
    cnd = "not {stairs}.done",
    dsc = function(s)
        if not s.unlocked then
            return "Металлическая {коробка} с рычагом, блокирующем пролёты, висит на стене."
        else
            return "{Рычаг}, блокирующий пролёты, висит на стене."
        end
    end,
    act = function(s)
        if s.done then
            return "Больше ничего делать не нужно."
        elseif not s.unlocked then
            return "Руками её не открыть."
        else
            s.done = true
            return "Я дёргаю за рычаг, и перегородка с лязгом поднимается."
        end
    end,
    used = function(s, w)
        if w.nam == "cutter" then
            return "Плазменный резак -- это плохая идея."
        elseif w.nam == "servicekey" and s.unlocked then
            return "Коробка уже открыта."
        elseif w.nam == "servicekey" then
            s.unlocked = true
            return "Я открываю короб сервисным ключом."
        end
    end
}
-- endregion

-- region corridor5
es.room {
    nam = "corridor5",
    pic = "station/corridor_elevator",
    disp = "Пролёт рядом с лифтом",
    dsc = [[Из-за сгущающейся темноты кажется, что мы будем идти бесконечно, что коридор никогда не кончится.]],
    onenter = function(s)
        snapshots:make()
    end,
    onexit = function(s, t)
        if t.nam == "corridor4" and not all.stairs.done then
            p "Нет смысла возвращаться."
            return false
        elseif t.nam == "main" then
            p "Надо сначала проверить, можно ли здесь спуститься на нижний уровень."
            return false
        end
    end,
    obj = { "andreev2", "vera8", "stairs" },
    way = {
        path { "К рубке", "corridor4" },
        path { "К пожарному спуску", "main" }
    }
}

es.obj {
    nam = "andreev2",
    done = false,
    dsc = "{Андреев} идёт рядом,",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("andreev.majorov")
            return true
        else
            return "Нет времени для разговоров."
        end
    end
}

es.obj {
    nam = "vera8",
    done = false,
    dsc = "а {Веру} я поддерживаю за руку, точно боюсь, что она исчезнет.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.corridor5")
            return true
        else
            return "Нет времени для разговоров."
        end
    end
}

es.obj {
    nam = "stairs",
    unbar = false,
    done = false,
    dsc = function(s)
        if not s.unbar then
            return "В полумраке вырисовывается {дверь} на лестничную клетку."
        else
            return "Проём на лестничную клетку открыт, однако сама {лестница} сорвана со стены и перегораживает спуск так, что даже спрыгнуть вниз не получится."
        end
    end,
    act = function(s)
        if not s.unbar then
            s.unbar = true
            return [[То, что на станции ещё что-то работает, воспринимается как чудо. Затаив дыхание, я нажимаю кнопку на стене, и дверь с шипением уползает в стену. Отлично!
            ^Впрочем, радоваться долго не получается.
            ^Верхняя часть лестницы, покорёженный обрубок, сорвана со стены и застяла внутри спуска, как кость в горле. Даже спрыгнуть вниз не получится.]]
        else
            return "Я бью по ней ногой, чтобы протолкнуть вниз, в жерло пожарного спуска, но ничего не получается."
        end
    end,
    used = function(s, w)
        if w.nam == "servicekey" or w.nam == "keycard" then
            return "Это здесь не поможет."
        elseif w.nam == "cutter" then
            es.sound("cutter")
            s.done = true
            es.walkdlg("andreev.death")
            return true
        end
    end
}
-- endregion

-- region corridor5_crisis
es.room {
    nam = "corridor5_crisis",
    mus = false,
    run = false,
    pic = "station/corridor_elevator",
    disp = "Пролёт рядом с лифтом",
    dsc = [[Я понимаю, что всё сейчас решится за мгновения. От моих действий зависят наши жизни.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.loopMusic("rush")
        end
    end,
    onexit = function(s, t)
        if t.nam == "corridor4" and not s.run then
            p "Мы не можем бросить здесь Андреева."
            return false
        elseif t.nam == "main" and not s.run then
            walkin("death3")
            return false
        elseif t.nam == "main" then
            walkin("death5")
            return false
        end
    end,
    obj = { "nubolids3", "andreev3", "vera9" },
    way = {
        path { "К рубке", "corridor4" },
        path { "К пожарному спуску", "main" }
    }
}

es.obj {
    nam = "nubolids3",
    cnd = "not {corridor5_crisis}.run",
    dsc = "Я стискиваю плазменный резак, но волна {нуболидов} слишком далеко от меня.",
    act = "Нет времени их разглядывать!",
    used = function(s, w)
        if w.nam == "cutter" then
            walkin("death4")
            return true
        else
            walkin("death3")
            return true
        end
    end
}

es.obj {
    nam = "andreev3",
    cnd = "not {corridor5_crisis}.run",
    dsc = "{Андреев} в ужасе замер посреди коридора.",
    act = function(s)
        walkin("death3")
        return true
    end,
    used = function(s, w)
        if w.nam == "cutter" then
            purge("cutter")
            all.corridor5_crisis.run = true
            es.walkdlg {
                dlg = "andreev",
                branch = "fin",
                pic = "station/torch",
                disp = "Пролёт рядом с лифтом"
            }
            return true
        end
    end
}

es.obj {
    nam = "vera9",
    dsc = "{Вера} стоит рядом со мной.",
    act = function(s)
        if all.corridor5_crisis.run then
            walkin("death5")
        else
            walkin("death3")
        end
        return true
    end
}
-- endregion

-- region death3
es.room {
    nam = "death3",
    pic = "common/nubolids3",
    disp = "Пролёт у лифта",
    dsc = [[Я не успеваю ничего сделать, меня разбивает паралич от нерешительности. Волна нуболидов сметает Андреева и устремляется к нам.
    ^Сначала она обрушивается на Веру.
    ^Я включаю резак, но уже слишком поздно.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region death4
es.room {
    nam = "death4",
    pic = "common/nubolids3",
    disp = "Пролёт у лифта",
    dsc = [[Нуболиды слишком далеко, а струя раскалённого газа из резака хоть и обжигает глаза невыносимым светом, но быстро сдаётся под натиском темноты.
    ^Нуболиды проносятся сквозь Андреева так, словно он стал бесплотным духом. Я делаю несколько шагов вперёд и -- резак гаснет.
    ^На меня и Веру надвигается ожившая тьма.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region death5
es.room {
    nam = "death5",
    pic = "common/nubolids3",
    disp = "Коридор",
    dsc = [[Я не успеваю ничего сделать, словно разбивает паралич от нерешительности. Волна нуболидов настигает нас.
    ^Сначала она обрушивается на Веру...]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region deck
es.room {
    nam = "deck",
    mus = false,
    mus2 = false,
    pic = function(s)
        if not all.lamp.done then
            return "station/deck"
        else
            return "station/dark_deck"
        end
    end,
    disp = "Рубка",
    dsc = function(s)
        if not all.lamp.done then
            return [[В рубке всё ещё горит свет, остаётся только молиться, что он отпугнёт нуболидов.]]
        else
            return [[Рубку затягивает непроницаемая темнота, лишь поблёскивают тусклые огоньки на терминале да мерцает старый монитор. Здесь в любой момент могут появиться нуболиды.]]
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("nightmare", 2, 0, 3000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "interlude2" and not have("flash") then
            p "Выходить сейчас в коридор -- это самоубийство."
            return false
        elseif t.nam == "interlude2" and have("flash") then
            p "Надо включить фонарь."
            return false
        end
    end,
    preact = function(s)
        if not all.bodies.done then
            all.bodies.done = true
            es.walkdlg("vera.bodies")
            return true
        end
        if not s.mus2 and not snd.music_playing() then
            s.mus2 = true
            es.music("nightmare", 2)
        end
    end,
    obj = {
        "bodies",
        "vera10",
        "skrewdriver",
        "comp",
        "lamp",
        "spot",
        "box",
        "rack",
        "bat_holder"
    },
    way = {
        path { "В коридор", "interlude2" }
    }
}

es.obj {
    nam = "bodies",
    done = false,
    cnd = "not {lamp}.done",
    dsc = "Я стараюсь не смотреть на {мёртвые тела}.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.bodies")
            return true
        else
            return "У меня нет сил на это смотреть."
        end
    end
}

es.obj {
    nam = "vera10",
    cnd = "not {lamp}.done",
    dsc = function(s)
        if not all.bodies.done then
            return "{Вера} в ужасе застыла перед лужей запёкшейся крови."
        else
            return "{Вера} стоит у выхода, отвернувшись от меня."
        end
    end,
    act = function(s, w)
        if not all.bodies.done then
            all.bodies.done = true
            es.walkdlg("vera.bodies")
            return true
        else
            return "Мне кажется, стоит оставить её в покое."
        end
    end
}

es.obj {
    nam = "skrewdriver",
    disp = es.tool "Отвёртка",
    inv = "Запачканная в крови отвёртка.",
    dsc = "На полу валяется {отвёртка}.",
    act = function(s)
        take("skrewdriver")
        es.music("crush", 1, 0, 3000)
        es.walkdlg("vera.tremor")
        return true
    end
}

es.obj {
    nam = "comp",
    locked = false,
    dsc = "Один из {вычислительных аппаратов} всё ещё работает, хотя экран у него рябит и потрескивает.",
    act = function(s)
        s.locked = true
        walkin("deck.terminal")
        return true
    end,
    used = function(s, w)
        if w.nam == "keycard" then
            s.locked = false
            walkin("deck.terminal")
            return true
        end
    end
}

es.terminal {
    nam = "deck.terminal",
    locked = function(s)
        return all.comp.locked
    end,
    commands_help = {
        status = "Статус двигательных модулей.",
        control = "Настройка двигательных модулей."
    },
    acl = {
        status = true
    },
    engines = {
        "[1] основной",
        "[2] маневровый",
        "[3] вспомогательный",
        "[4] резервный",
    },
    commands = {
        control = function(s, args)
            local arg = s:arg(args)
            local num = tonumber(arg)
            if not arg or not num or num < 0 or num > 4 then
                local txt = "Не указан номер двигательного блока."
                if arg then
                    txt = string.format("Некорректный номер двигательного блока: \"%s\".", num)
                end
                return {
                    txt,
                    "",
                    "Синтаксис:",
                    "control [номер двигательного блока] [идентификатор команды]",
                    "Доступные номера двигательных блоков:",
                    s.engines[1], s.engines[2], s.engines[3], s.engines[4]
                }
            end
            if not args[2] then
                return s:error("Не указан идентификатор команды.")
            end
            return s:error(
                string.format("Некорректный идентификатор команды: \"%s\".", args[2]))
        end,
        status = function(s, args, load)
            local arg = s:arg(args)
            local num = tonumber(arg)
            if not arg or not num or num < 0 or num > 4 then
                local txt = "Не указан номер двигательного блока."
                if arg then
                    txt = string.format("Некорректный номер двигательного блока: \"%s\".", num)
                end
                return {
                    txt,
                    "",
                    "Синтаксис:",
                    "status [номер двигательного блока]",
                    "Доступные номера двигательных блоков:",
                    s.engines[1], s.engines[2], s.engines[3], s.engines[4]
                }
            end
            if not load then
                return "$load"
            end
            es.sound("error")
            return {
                "Внимание! Ошибка!",
                string.format("Двигательный блок \"%s\" не отвечает.", s.engines[num])
            }
        end
    }
}

es.obj {
    nam = "lamp",
    done = false,
    cnd = "not s.done",
    dsc = "Единственная живая {лампа} предательски мерцает над головой.",
    act = "Если она погаснет, то нам конец.",
    used = function(s, w)
        if w.nam == "skrewdriver" and not all.spot.box then
            return "Я не могу дотянуться до лампы."
        elseif w.nam == "skrewdriver" and all.spot.box and not have("battery") then
            return "Не стоит торопиться. Если я сниму лампу, то мы окажемся в темноте, и здесь в любую секунду могут появиться нуболиды."
        elseif w.nam == "skrewdriver" and all.spot.box and have("battery") then
            s.done = true
            es.walkdlg("vera.lamp")
            return true
        end
    end
}

es.obj {
    nam = "spot",
    box = false,
    cnd = "not {lamp}.done",
    dsc = function(s)
        if not s.box then
            return "Словно нарочно, ярче всего она освещает тёмные пятна крови на {полу}."
        else
            return "Под ней стоит пустая {коробка} из крепкого пластика."
        end
    end,
    act = function(s)
        if not s.box then
            return "Нет у меня желания это рассматривать."
        else
            s.box = false
            take("box")
            return "Я забираю коробку."
        end
    end,
    used = function(s, w)
        if w.nam == "box" then
            s.box = true
            purge("box")
            return "Я ставлю коробку под лампу."
        end
    end
}

es.obj {
    nam = "box",
    disp = es.tool "Пустая коробка",
    inv = "Пустая из крепкого пластика -- достаточно прочная, чтобы выдержать мой вес.",
    dsc = "В пролегающей у основания стены тени прячётся невзрачная {коробка}.",
    tak = "Я поднимаю коробку -- она не слишком тяжёлая и пустая."
}

es.obj {
    nam = "rack",
    cnd = "not {lamp}.done",
    dsc = "В стойку с {вычислительными модулями} рядом с приборной панелью вставлены несколько",
    act = "Вычислительные модули нам сейчас не помогут."
}

es.obj {
    nam = "bat_holder",
    count = 0,
    cnd = "not {lamp}.done",
    dsc = "{батарей}.",
    act = function(s)
        if s.count == 0 then
            s.count = s.count + 1
            return "Я вытаскиваю первую попавшуюся батарею. Так, эта полностью разряжена."
        elseif s.count == 1 then
            s.count = s.count + 1
            return "Я беру ещё одну батарею -- тоже нет заряда."
        elseif s.count == 2 then
            s.count = s.count + 1
            es.walkdlg("vera.battery")
            return true
        else
            return "У меня уже есть батарея."
        end
    end
}

es.obj {
    nam = "battery",
    disp = es.tool "Батарея",
    inv = "Стандартная батарея с небольшим зарядом.",
    used = function(s, w)
        if w.nam == "bulb" then
            purge("bulb")
            purge("battery")
            take("flash")
            return "Я подсоединяю батарею к лампе. Надеюсь, этот импровизированный фонарь прослужит какое-то время. Остаётся только включить подачу питания на батарее."
        end
    end
}

es.obj {
    nam = "bulb",
    disp = es.tool "Лампа",
    inv = "Лампа, которую я скрутил с потолка.",
    used = function(s, w)
        if w.nam == "battery" then
            return w:used(s)
        end
    end
}

es.obj {
    nam = "flash",
    active = false,
    disp = es.tool "Фонарь",
    inv = function(s)
        if not s.active then
            s.active = true
            walkin("interlude2")
            return true
        else
            return "Самодельный фонарик, надеюсь его света хватит."
        end
    end
}
-- endregion

-- region interlude2
es.room {
    nam = "interlude2",
    pic = "station/dark_corridor1",
    disp = "Коридор",
    noinv = true,
    dsc = [[Мой самодельный фонарь наливается слабым светом. Надеюсь этого хватит.
    ^Мы выходим в коридор.
    ^Я свечу перед собой, но постоянно оборачиваюсь в страхе, что нуболиды тенью следуют за нами по пятам.
    ^В стенах раздаётся треск лопающего металла, пол под ногами трясётся.]],
    enter = function(s)
        es.music("nochance", 2, 0, 3000)
    end,
    next = function(s)
        es.walkdlg("vera.walking")
    end
}
-- endregion

-- region corridor6
es.room {
    nam = "corridor6",
    pic = "station/dark_corridor2",
    disp = "Коридор",
    dsc = [[Фонарь, как лезвие, вспарывает собравшуюся впереди темноту.]],
    onexit = function(s, t)
        if t.nam == "corridor7" and not all.darkness.done then
            p "Надо сначала понять, что там, впереди."
            return false
        end
    end,
    obj = { "vera11", "darkness" },
    way = {
        path { "К пожарному спуску", "corridor7" }
    }
}

es.obj {
    nam = "vera11",
    dsc = "{Вера} держится поодаль от меня.",
    act = "Мы поговорим на корабле."
}

es.obj {
    nam = "darkness",
    done = false,
    dsc = "Я замечаю в плотной завесе тьмы впереди какое-то {движение}.",
    act = function(s)
        if not s.done then
            return "Так ничего не разглядеть, надо подойти поближе и направить туда луч фонаря."
        else
            return "Мне показалось."
        end
    end,
    used = function(s, w)
        if w.nam == "flash" then
            s.done = true
            return [[Я делаю несколько шагов вперёд, ощупываю лучом фонаря потолок и стены.
            ^Ничего.]]
        end
    end
}
-- endregion

-- region corridor7
es.room {
    nam = "corridor7",
    pic = "station/dark_corridor1",
    disp = "Пролёт у пожарного спуска",
    dsc = [[Мы наконец добрались. Фонарь освещает проход на лестничную клетку.]],
    onexit = function(s, t)
        if t.nam == "cage" and not all.firedoor.unbar then
            p "Надеюсь, дверь откроется."
            return false
        end
    end,
    obj = { "firedoor", "vera12" },
    way = {
        path { "На лестничную клетку", "cage" }
    }
}

es.obj {
    nam = "firedoor",
    unbar = false,
    cnd = "not s.unbar",
    dsc = "Но {дверь} закрыта.",
    act = "Я не могу разглядеть кнопку в темноте.",
    used = function(s, w)
        if w.nam == "flash" then
            s.unbar = true
            return "Я освещаю фонарём переборки рядом с дверью. Наконец луч выхватывает большую металлическую кнопку. Я нажимаю на неё, дверь открывается. Нам снова повезло."
        end
    end
}

es.obj {
    nam = "vera12",
    dsc = "{Вера} стоит, устало прислоняясь к стене.",
    act = function(s)
        es.walkdlg("vera.corridor7")
        return true
    end
}
-- endregion

-- region cage
es.room {
    nam = "cage",
    mus = false,
    pic = "station/staircase",
    disp = "Лестничная клетка",
    dsc = [[Я захожу на лестничную клетку один -- здесь так тесно, что вдвоём не развернуться. Мне надо убедиться, что мы сможем здесь спуститься.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("nightmare", 1, 0, 3000)
        end
    end,
    obj = { "pit" },
    way = {
        path { "В коридор", "corridor7" }
    }
}

es.obj {
    nam = "pit",
    dsc = "{Спуск} на нижний уровень похож на заполненную тьмой воронку.",
    act = "Стоит убедиться, что там безопасно, прежде чем спускаться.",
    used = function(s, w)
        if w.nam == "flash" then
            es.walkdlg("vera.descent")
            return true
        end
    end
}
-- endregion

-- region descent
es.room {
    nam = "descent",
    pic = "station/tonnel",
    disp = "Спуск",
    dsc = [[Я вишу на лестнице, обхватив перила одной рукой, а второй -- сжимая фонарь, от которого зависят наши жизни.]],
    enter = function(s)
        es.music("descend", 2, 0, 2000)
    end,
    obj = { "vera13", "downward" }
}

es.obj {
    nam = "vera13",
    dsc = "{Вера} терпеливо ждёт, цепляясь за лестницу у меня над головой.",
    act = function(s)
        es.walkdlg("vera.descent2")
        return true
    end
}

es.obj {
    nam = "downward",
    dsc = "Подо мной -- {чёрная пропасть}.",
    act = "Так я ничего не могу разглядеть.",
    used = function(s, w)
        if w.nam == "flash" then
            es.walkdlg("vera.descent3")
            return true
        end
    end
}
-- endregion

-- region neardock1
es.room {
    nam = "neardock1",
    pic = "station/dark_corridor1",
    disp = "Коридор",
    dsc = [[Света на этом уровне тоже нет, наверное, полностью отказал отвечающий за освещение контур. Надо быть осторожнее.]],
    onexit = function(s, t)
        if t.nam == "neardock2" then
            p "Надо сначала помочь Кофману."
            return false
        end
    end,
    obj = { "kofman", "vera14" },
    way = {
        path { "К причалу", "neardock2" }
    }
}

es.obj {
    nam = "kofman",
    done = false,
    dsc = "Я ощупываю сумрак лучом фонаря и замечаю {Кофмана}, который лежит на полу у стены.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("kofman.head")
            return true
        else
            return "Он слишком тяжёлый, я не могу поднять его одной рукой. Ведь в другой у меня -- фонарь."
        end
    end
}

es.obj {
    nam = "vera14",
    dsc = "{Вера} стоит рядом со мной.",
    act = function(s)
        es.walkdlg("vera.neardock1")
        return true
    end,
    used = function(s, w)
        if w.nam == "flash" and not all.kofman.done then
            return "Надо сначала проверить, что с Кофманом."
        else
            purge("flash")
            walkin("interlude3")
            return true
        end
    end
}
-- endregion

-- region interlude3
es.room {
    nam = "interlude3",
    noinv = true,
    pic = "station/dark_corridor1",
    disp = "Коридор",
    dsc = [[Я отдаю Вере фонарь и помогаю Кофману подняться. Он наваливается на меня всем весом, как утопающий, который пытается спастись, но лишь тянет к себе, в темноту.
    ^Мы с трудом продвигаемся вперёд.]],
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = "neardock2"
}
-- endregion

-- region neardock2
es.room {
    nam = "neardock2",
    pic = "station/dark_corridor2",
    disp = "Коридор",
    dsc = [[Причал, у которого, как я надеюсь, ещё стоит "Грозный", уже совсем близко. Остался последний пролёт.
    ^Жаль, что впереди ничего не видно.]],
    enter = function(s)
        es.music("nochance", 2)
    end,
    onexit = function(s, t)
        if t.nam == "neardock3" then
            es.walkdlg("kofman.tail")
            return false
        end
    end,
    obj = { "vera15", "kofman2" },
    way = {
        path { "К причалу", "neardock3" }
    }
}

es.obj {
    nam = "vera15",
    done = false,
    dsc = "{Вера} освещает наш путь фонарём.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.neardock2")
            return true
        else
            return "Мы ещё успеем наговориться."
        end
    end
}

es.obj {
    nam = "kofman2",
    dsc = "{Кофман} что-то бормочет себе под нос.",
    act = function(s)
        es.walkdlg("kofman.tail")
        return true
    end
}
-- endregion

-- region neardock3
es.room {
    nam = "neardock3",
    pic = "station/redtail",
    disp = "Коридор",
    dsc = [[От красных вспышек вытекают глаза.]],
    preact = function(s)
        es.music("onechance", 10, 0, 4000)
    end,
    onenter = function(s)
        snapshots:make()
    end,
    obj = { "vera16", "line", "lever3" }
}

es.obj {
    nam = "vera16",
    done = false,
    dsc = function(s)
        if not s.done then
            return "Я держу {Веру} одной рукой, а другой -- хватаюсь за"
        else
            return "Мы с {Верой} держимся за"
        end
    end,
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.neardock3")
            return true
        else
            return "Разговорами тут не поможешь."
        end
    end
}

es.obj {
    nam = "line",
    dsc = "{леер}.",
    act = function(s)
        if not all.vera16.done then
            return "Леер трещит и прогибается. Скоро либо он не выдержит, либо -- я."
        else
            return "Леер сильно провисает, он может оборваться в любую секунду."
        end
    end
}

es.obj {
    nam = "lever3",
    unlocked = false,
    dsc = function(s)
        if not s.unlocked then
            return "Рядом со мной -- металлический {короб} рычага, блокирующего переходы."
        else
            return "Рядом со мной -- {рычаг}, блокирующий переходы."
        end
    end,
    act = function(s)
        if not all.vera16.done then
            return "У меня нет свободных рук."
        elseif not s.unlocked then
            return "Руками его не откроешь."
        else
            es.walkdlg {
                dlg = "vera",
                branch = "save",
                pic = "station/redtail",
                disp = "Коридор"
            }
            return true
        end
    end,
    used = function(s, w)
        if not all.vera16.done then
            return "У меня нет свободных рук."
        elseif w.nam == "servicekey" and s.unlocked then
            return "Коробка уже открыта."
        elseif w.nam == "servicekey" then
            s.unlocked = true
            return "Я открываю короб сервисным ключом."
        elseif w.nam == "skrewdriver" and s.unlocked then
            return "Коробка уже открыта."
        elseif w.nam == "skrewdriver" then
            return "Лучше воспользоваться сервисным ключом."
        end
    end
}
-- endregion

-- region ascend
es.room {
    nam = "ascend",
    pic = "station/redtail",
    disp = "Коридор",
    enter = function(s)
        es.music("nochance")
    end,
    dsc = [[Аварийные люминофоры выхватывают из темноты очертания стен и пола -- то, что сейчас стало стенами и полом, -- лишь затем, чтобы через мгновение всё это смела темнота.]],
    obj = { "vera17", "line2" }
}

es.obj {
    nam = "vera17",
    dsc = "{Вера} стоит рядом.",
    act = function(s)
        es.walkdlg("vera.ascend1")
        return true
    end
}

es.obj {
    nam = "line2",
    dsc = "Я дёргаю за {леер}, проверяя его на прочность.",
    act = "Вес одного он точно должен выдержать."
}
-- endregion

-- region death6
es.room {
    nam = "death6",
    pic = "station/redtail",
    dsc = [[Я лезу первым, леер, как лезвие, врезается в кисти рук, но подниматься получается довольно быстро. Вера лезет вслед за мной.
    ^Вдруг я слышу её крик. Она соскальзывает с леера и падает на перегородку.
    ^-- Вера! Вера! -- кричу я.
    ^Она не отвечает.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region dock
es.room {
    nam = "dock",
    mus = false,
    pic = "station/dark_corridor1",
    disp = "Пристань",
    dsc = [[Мы поднялись. Я сам не могу в это поверить, но мы -- поднялись. Остался лишь один маленький шаг.]],
    preact = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("roar")
        end
    end,
    obj = { "vera18", "hatch" }
}

es.obj {
    nam = "vera18",
    dsc = "{Вера} смотрит на свои окровавленные ладони.",
    act = "Надо быстрее идти на корабль!"
}

es.obj {
    nam = "hatch",
    dsc = [[Массивный {люк} с вентилем не заблокирован, значит "Грозный" всё ещё здесь.]],
    act = "Руками провернуть вентиль не получается, сил совсем не осталось.",
    used = function(s, w)
        if w.nam == "skrewdriver" then
            return "Отвёртка слишком короткая, тут она не поможет."
        elseif w.nam == "servicekey" then
            drop("servicekey")
            walkin("interlude4")
            return true
        end
    end
}
-- endregion

-- region interlude4
es.room {
    nam = "interlude4",
    noinv = true,
    pic = "ship/gate",
    disp = "Пристань",
    dsc = [[Я просовываю в вентиль сервисный ключ, наваливаюсь на него всем телом, и вентиль сдвигается.
    ^Люк открывается.
    ^Мы с Верой залазим в шлюз.]],
    enter = function(s)
        es.music("soundinspace")
    end,
    next = "ship"
}
-- endregion

-- region ship
es.room {
    nam = "ship",
    pic = "ship/corridor",
    disp = "Коридор корабля",
    dsc = [[Мы один за другим спускаемся из шлюза в коридор корабля. Здесь так ярко, что глаза, привыкшее к сумраку, слезятся.]],
    enter = function(s)
        es.music("violin")
    end,
    obj = { "minaeva1", "majorov1", "vera19" }
}

es.obj {
    nam = "minaeva1",
    dsc = "На полу лежит {Минаева}. Её форма расстёгнута, а к груди присосался чёрный диск реаниматора, который вращается по кругу, громко отщёлкивая секунды. Минаева вздрагивает, но не приходит в сознание.",
    act = "Что делает Майоров? У нас же есть медицинская капсула!"
}

es.obj {
    nam = "majorov1",
    dsc = "{Майоров} стоит перед ней на коленях.",
    act = function(s)
        es.walkdlg("majorov.head")
        return true
    end
}

es.obj {
    nam = "vera19",
    dsc = "{Вера} с ужасом смотрит на распростёртое тело.",
    act = function(s)
        es.walkdlg("vera.ship")
        return true
    end
}
-- endregion

-- region ship2
es.room {
    nam = "ship2",
    pic = "ship/corridor",
    disp = "Коридор корабля",
    dsc = [[Глаза всё ещё не привыкли к яркому свету. Кажется, всё вокруг застилает снежная белизна.]],
    enter = function(s)
        es.music("tragedy", 2, 0, 3000)
    end,
    obj = { "device", "minaeva2", "vera19" }
}

es.obj {
    nam = "device",
    dsc = "{Реаниматор}",
    act = function(s)
        es.walkdlg("majorov.minaeva")
        return true
    end
}

es.obj {
    nam = "minaeva2",
    dsc = "на груди {Минаевой} уже отработал.",
    act = "Она не должна умереть!"
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(4000)
    end,
    next = function(s)
        gamefile("game/15.lua", true)
    end
}
-- endregion
