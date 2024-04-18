-- Chapter 3
dofile "lib/es.lua"

es.main {
    chapter = "3",
    onenter = function(s)
        walkin("entrance")
    end
}

-- region entrance
es.room {
    nam = "entrance",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.music("nightmare", 1, 0, 3000)
    end,
    next = "dream1"
}
-- endregion

-- region dream1
es.room {
    nam = "dream1",
    pic = "dream/lake.deep3",
    disp = "Под водой",
    dsc = [[У меня нет больше сил сопротивляться, я растворяюсь в темноте, поддаюсь мощным подводным потокам, которые уносят меня -- или то, что от меня осталось, последние искорки сознания -- в глубину. Вокруг меня кружатся, сплетаясь друг с другом, тонкие алые ленты, такие стремительные и живые, что их не способна объять даже безграничная темнота.
    ^Я невольно любуюсь ими, пока не понимаю, что и сам стал частью этого завораживающего потока.]],
    next_disp = "Что это?",
    next = "pause1"
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = "intro1"
}
-- endregion

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/ship",
    disp = "Судовой отчёт",
    enter = function(s)
        es.music("grosni")
    end,
    decor = [[<b>Корабль:</b> ГКМ "Грозный"^
    <b>Экипаж:</b> шесть человек^
    <b>Пункт назначения:</b> Сантори-5, НИОС "Кабирия"]],
    obj = {
        "diagnosis",
        "trail1",
        "trail2",
        "trail3",
        "error"
    }
}

es.obj {
    nam = "diagnosis",
    started = false,
    dsc = function(s)
        if not s.started then
            return "{Запуск} диагностики..."
        else
            return "Диагностика:^"
        end
    end,
    act = function(s)
        s.started = true
    end
}

es.obj {
    nam = "trail1",
    shown = false,
    dsc = function(s)
        if s.shown then
            return "^Маршевая магистраль (норма 3-6): 4"
        elseif _("diagnosis").started then
            return "^Маршевая магистраль (норма 3-6): {Проверка}"
        end
    end,
    act = function(s)
        s.shown = true
    end
}

es.obj {
    nam = "trail2",
    shown = false,
    dsc = function(s)
        if s.shown then
            return "^Провизорная магистраль норма 7-9): 7"
        elseif all.trail1.shown then
            return "^Провизорная магистраль (норма 7-9): {Проверка}"
        end
    end,
    act = function(s)
        s.shown = true
    end
}

es.obj {
    nam = "trail3",
    shown = false,
    dsc = function(s)
        if s.shown then
            return "^Магистраль 12-02 (норма 4-7): 12"
        elseif all.trail2.shown then
            return "^Магистраль 12-02 (норма 4-7): {Проверка}"
        end
    end,
    act = function(s)
        s.shown = true
    end
}

es.obj {
    nam = "error",
    dsc = function(s)
        if all.trail3.shown then
            es.sound("error")
            return "^^Внимание! {Ошибка}!"
        end
    end,
    act = function(s)
        walkin("intro2")
        return true
    end
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    pic = "common/ship",
    disp = "Судовой отчёт",
    obj = { "timer" }
}

obj {
    nam = "timer",
    tick = 1,
    dsc = function(s)
        local tab = {
            "{7 часов 12 минут}",
            "{5 часов 50 минут}",
            "{3 часa 22 минуты}",
            "{1 час 39 минут}",
            "{0 часов 44 минуты}"
        }
        return "До выхода из червоточины осталось:^^" .. tab[s.tick]
    end,
    act = function(s)
        if s.tick < 5 then
            s.tick = s.tick + 1
        else
            es.stopMusic(3000)
            walkin("deck1")
        end
        return true
    end
}
-- endregion

-- region deck1
es.room {
    nam = "deck1",
    pic = "ship/deck",
    onexit = function(s, t)
        if t.nam == "main" and not all.belt1.done then
            p "Надо бы сначала отстегнуть ремень."
            return false
        elseif t.nam == "main" then
            es.walkdlg {
                dlg = "majorov",
                branch = "head",
                pic = "ship/corridor",
                disp = "Коридор"
            }
            return false
        end
    end,
    disp = "Рубка",
    dsc = [[В рубке пусто и тихо -- приглушённое шипение воздуховодов в стенах лишь подчёркивает тишину. Свет режет глаза.]],
    obj = { "seat1", "belt1", "porthole1" },
    way = {
        path { "В коридор", "main" }
    }
}

es.obj {
    nam = "seat1",
    dsc = function(s)
        if not all.belt1.done then
            return "Я лежу в {ложементе} эрц-пилота,"
        else
            return "Я {завис} посреди рубки, пытаясь собраться с мыслями."
        end
    end,
    act = function(s)
        if not all.belt1.done then
            return "Я даже не помню, как заснул -- и почему залез в ложемент Григорьева, когда у меня есть свой? Боюсь, как бы мне не влепили выговор. Отличная вахта получилась. Но силы у меня и правда на исходе -- больше на долгий переход я не соглашусь."
        else
            return "До выхода из червоточины остаётся совсем мало времени. Где Григорьев? Где остальные члены экипажа?"
        end
    end
}

es.obj {
    nam = "belt1",
    done = false,
    cnd = "not s.done",
    dsc = "{ремень} безопасности стискивает грудь.",
    act = function(s)
        s.done = true
        es.music("fatigue", 3)
        return "Я отстёгиваю ремень и выбираюсь из ложемента."
    end
}

obj {
    nam = "porthole1",
    dsc = "Небольшой {иллюминатор} упрямо притягивает мой взгляд.",
    act = [[У Григорьева своеобразное чувство юмора. В действительности, пока мы идём в червоточине, увидеть что-то в иллюминатор невозможно.
    ^Мы плывём за пределами обычного пространства и времени, в измерении, которое человеческий мозг не в состоянии помыслить, если только ты не находишься в кареалогической фуге.]]
}
-- endregion

-- region deck2
es.room {
    nam = "deck2",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[Я понимаю, как все мы намучились за этот полёт -- больше четырехсот часов изнуряющего безделья посреди пустоты. Даже Майоров, опытный капитан, похож на коматозника, которому всё приходится делать через силу.
    ^Как ни странно, самым бодрым выглядит Григорьев -- быть может, бессоница во время перехода и правда лучше постоянных кошмаров. Стоит сомкнуть глаза, и изнанка вселенной, в которой мы находимся, исторгает нас, подобно архимедовой силе, сводит с ума.]],
    onexit = function(s, t)
        if t.nam == "corridor" then
            p "На это нет времени, мы скоро выходим из червоточины."
            return false
        end
    end,
    obj = { "kofman1", "panel1" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "kofman1",
    dsc = "{Кофман} суетится у диагностического щитка.",
    act = function(s)
        es.walkdlg("kofman.head")
        return true
    end
}

es.obj {
    nam = "panel1",
    dsc = "Рядом со мной в стену вмонтирована {панель} с аналоговыми приборами.",
    act = "Я проверяю большой круглый циферблат с подрагивающей стрелкой и зачем-то постукиваю по нему костяшками пальцев. Стрелка неуверенно показывает на цифру \"6\"."
}
-- endregion

-- region deck3
es.room {
    nam = "deck3",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = function(s)
        if all.seat2.seated and all.beltcheck1.done then
            return [[Впервые за долгое время весь экипаж находится в рубке.]]
        else
            return [[Впервые за долгое время весь экипаж находится в рубке. Все устроились в ложементах, смотрят в потолок и молчат, из-за чего походят не на живых людей, а на манекенов.]]
        end
    end,
    onexit = function(s, t)
        if t.nam == "corridor" then
            p "На это нет времени, мы скоро выходим из червоточины."
            return false
        end
    end,
    obj = {
        "porthole2",
        "seat2",
        "belt2",
        "beltcheck1",
        "beltcheck2",
        "wait"
    },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "porthole2",
    cnd = "not {seat2}.done",
    dsc = "Из {иллюминатора} мне бьёт в глаза бездонная темнота.",
    act = "Скоро в иллюминатор будут видны звёзды."
}

es.obj {
    nam = "seat2",
    done = false,
    cnd = "not s.done",
    dsc = function(s)
        if s.done then
            return "Мне до одури неудобно в собственном {ложементе}, подголовник давит на шею."
        else
            return "Мой личный {ложемент} у двери напоминает почему-то больничную койку."
        end
    end,
    act = function(s)
        if not s.done then
            s.done = true
            return "Я подплываю к ложементу и залезаю в него так медленно и неуклюже, словно впервые оказался в невесомости."
        else
            return "На станции будет возможность отдохнуть от этих прокрустовых кресел."
        end
    end
}

es.obj {
    nam = "belt2",
    done = false,
    cnd = "not s.done",
    dsc = function(s)
        if not all.seat2.done then
            return "А {ремни} безопасности -- верёвки, которыми связывают буйных больных."
        else
            return "Осталось только застегнуть {ремни}."
        end
    end,
    act = function(s)
        if not all.seat2.done then
            return "Сначала надо забраться в ложемент."
        else
            s.done = true
            return [[Я пристёгиваю ремень и вспоминаю, что по инструкции надо проверить режим противоперегрузочной компенсации -- смысла в этом мало, перегрузок во время выхода из червоточины не бывает, но капитан же просил действовать по инструкции.
            ^У ложемента есть три основных режима, нужно запустить проверку для каждого из них.]]
        end
    end
}

es.obj {
    nam = "beltcheck1",
    done = false,
    position = 0,
    cnd = "{belt2}.done and not s.done",
    dsc = function(s)
        return string.format([[В левый подлокотник ложемента вмонтирован {рычажок}, который переключается по четырём позициям.
        ^Сейчас рычаг в позиции "%s".]], tostring(s.position))
    end,
    act = function(s)
        if s.position == 3 then
            s.position = 0
            return "Я сбрасываю рычаг в нулевую позицию."
        else
            s.position = s.position + 1
            return string.format("Я перевожу рычаг на позицию \"%s\".", tostring(s.position))
        end
    end
}

es.obj {
    nam = "beltcheck2",
    position = 0,
    checks = 0,
    c1 = false,
    c2 = false,
    c3 = false,
    cnd = "{belt2}.done and not {beltcheck1}.done",
    dsc = "^Справа есть ещё один {рычаг}, положение которого надо синхронизировать с первым.",
    act = function(s)
        local master = all.beltcheck1.position
        local poses = {
            "Спинка ложемента с едва слышным звуком приподнимается.",
            "Ложмент раскладывается, как кровать, и становится почти плоским. Что-то похрустывает у меня в пояснице.",
            "Ложемент надрывно гудит и приподнимается над полом, тисками сжимая рёбра."
        }
        local checks = {
            " Отлично! Первая проверка пройдена. Правый рычаг автоматически возвращается на нулевую отметку.",
            " Так, закончилась вторая проверка.",
            [[ Всё, теперь все проверки закончены.
            ^Мерцель тоже пожжужала ложементом (остальные, видимо, не восприняли указания капитана всерьёз), и на нас снова навалилась тишина.
            ^Казалось, прошло несколько часов, прежде чем под потолком загорелась первый алый люминофор.
            ^Выход начался.]]
        }
        if s.position == 3 then
            s.position = 0
            return "Я сбрасываю рычаг в нулевую позицию."
        else
            s.position = s.position + 1
            if s.position == master and not s["c"..tostring(master)] then
                s.checks = s.checks + 1
                local txt = poses[s.checks] .. checks[s.checks]
                if s.checks == 3 then
                    es.music("anticipation", 1, 0, 3000)
                    all.beltcheck1.done = true
                end
                s["c"..tostring(master)] = true
                s.position = 0
                return txt
            elseif s.position == master and s["c"..tostring(master)] then
                return "Этот режим я уже проверял."
            else
                return string.format("Я перевожу правый рычаг в позицию \"%s\".",
                    tostring(s.position))
            end
        end
    end
}

es.obj {
    nam = "wait",
    mus = false,
    count = 1,
    cnd = "{beltcheck1}.done",
    dsc = function(s)
        local counts = {
            "{пять}",
            "{четыре}",
            "{три}",
            "{два}",
            "{один}"
        }
        return string.format(
            "Я, как и в самый первый свой полёт, начинаю вполголоса считать: %s.",
            counts[s.count])
    end,
    act = function(s)
        if not s.mus then
            s.mus = true
            es.music("countdown")
        end
        s.count = s.count + 1
        if s.count > 5 then
            walkin("pause2")
            return true
        else
            local counts = {
                "Загорается второй люминофор.",
                "Третий люминофор.",
                "Грудную клетку стискивает от волнения.",
                "Горит уже пять алых люминофоров.",
                "Кажется, в любую секунду заорёт сирена."
            }
            return counts[s.count - 1]
        end
    end
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    noinv = true,
    pause = 80,
    enter = function(s)
        es.stopMusic()
    end,
    next = "interlude1"
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    noinv = true,
    pic = "common/star",
    enter = function(s)
        es.music("dali")
    end,
    dsc = [[В старых фантастических фильмах выход из червоточины всегда сопровождался зрелищными эффектами -- пространство растягивалось, как в кривой линзе, звёзды за огромными стеклянными панелями взрывались феерверками, люди с истошными криками, как новорождённые младенцы, возвращались в реальный холодный мир.
    ^Но, на самом деле, не происходит ничего.
    ^Просто под потолком загорелось и погасло несколько лампочек.]],
    next = "interlude2"
}
-- endregion

-- region interlude2
es.room {
    nam = "interlude2",
    noinv = true,
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[-- Всех поздравляю, -- говорит Майоров. -- Вереснев! -- Он поворачивается ко мне. -- Врубай аппараты.
    ^Ничего не изменилось. Все молча сидят в ложементах. Меня не покидает пугающее чувство, что мы так и не вышли из червоточины.
    ^Я пытаюсь вспомнить, случалось ли такое, чтобы корабль не мог вернуться в обычный космос.]],
    next = function(s)
        es.stopMusic(5000)
        walkin("deck4")
        return true
    end
}
-- endregion

-- region deck4
es.room {
    nam = "deck4",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[Все молча сидят в ложементах, словно, как и я, сомневаются в том, что вернулись в реальный мир, но решаются высказать это вслух.]],
    onenter = function(s)
        if all.corridor.mus then
            es.walkdlg {
                dlg = "majorov",
                branch = "nowork",
                pic = "ship/deck",
                disp = "Рубка"
            }
            return false
        end
    end,
    onexit = function(s, t)
        if not all.belt3.done then
            all.belt3.try = true
            p "Это же не первый мой полёт, почему я так нервничаю? Не могу даже скинуть с себя ремень безопасности, застёжка заела."
            return false
        elseif all.belt3.done and not all.majorov1.done then
            p "Я бы сначала уточнил у Майорова, что нужно делать."
            return false
        end
    end,
    obj = { "belt3", "porthole3", "majorov1" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "belt3",
    done = false,
    try = false,
    cnd = "not s.done",
    dsc = "{Ремни} удавкой сжимают горло.",
    act = function(s)
        if not s.try then
            s.try = true
            return "Я пытась отстегнуть ремень безопасности, но язычок замка застрял в защёлке, и у меня ничего не получается."
        else
            s.done = true
            return "Со второй попытки я справляюсь с ремнём и поднимаюсь из ложемента."
        end
    end
}

es.obj {
    nam = "porthole3",
    done = false,
    dsc = "Заманчиво поблёскивает {иллюминатор}, отражая огни ламп.",
    act = function(s)
        if not all.belt3.done then
            return "Неплохо бы сначала отстегнуться."
        elseif not s.done then
            s.done = true
            es.walkdlg("majorov.porthole")
            return true
        else
            return "Нечего там смотреть."
        end
    end
}

es.obj {
    nam = "majorov1",
    done = false,
    dsc = "{Майоров} с усталым видом массирует виски.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("majorov.dowork1")
            return true
        else
            es.walkdlg("majorov.dowork2")
            return true
        end
    end
}
-- endregion

-- region deck5
es.room {
    nam = "deck5",
    pic = "ship/deck",
    disp = "Рубка",
    dsc = [[В рубке никого нет. Терминалы у большинства ложементов работают. Все выбежали отсюда быстро, как при эвакуации.]],
    way = {
        path { "В коридор", "corridor" }
    }
}
-- endregion

-- region corridor
es.room {
    nam = "corridor",
    mus = false,
    pic = "ship/corridor",
    disp = "Коридор",
    dsc = [[Освещение в коридоре приглушённое, и глаза, воспалившиеся от чрезмерного света в рубке, за это благодарны.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("lotus", 2)
        end
    end,
    onexit = function(s, t)
        if t.nam == "deck4" and all.nav1.crisis then
            walkin("deck5")
            return false
        elseif t.nam == "nav1" and all.nav1.done then
            walkin("nav2")
            return false
        end
    end,
    obj = { "cells", "pain" },
    way = {
        path { "В каюту", "cabin" },
        path { "В техотсек", "tech" },
        path { "В медотсек", "med" },
        path { "В навигационный отсек", "nav1" },
        path { "В рубку", "deck4" }
    }
}

es.obj {
    nam = "cells",
    dsc = "По обе стороны от меня тянутся узенькие двери в личные {отсеки}.",
    act = "У меня нет времени на то, чтобы ходить по чужим отсекам."
}

es.obj {
    nam = "pain",
    done = false,
    dsc = "На мгновение мне кажется, что корабль покачивается, точно на волнах, и я судорожно цепляюсь за леер. В виски покалывает -- {мигрень} вернулась, как тяжёлая болезнь после ремиссии.",
    act = function(s)
        if not s.done then
            return "Может, выпить ещё таблетку?"
        else
            return "Боюсь, придётся потерпеть."
        end
    end
}
-- endregion

-- region cabin
es.room {
    nam = "cabin",
    pic = "ship/cabin",
    disp = "Каюта",
    dsc = [[Я должен торопиться, но вместо этого я зачем-то залезаю в свою каюту, в эти несколько кубометров личного пространства, как будто именно сейчас, перед стыковкой, мне нужно спрятаться ото всех и побыть несколько секунд одному.]],
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
    act = "Скафандр так и не пригодился."
}

es.obj {
    nam = "showerdoor",
    dsc = "У выхода из каюты -- сдвигающая гармошкой {дверца} в душевую с сухой чисткой.",
    act = "Индивидуальная душевая -- настоящая роскошь для космического корабля."
}
-- endregion

-- region med
es.room {
    nam = "med",
    pic = "ship/med",
    disp = "Медицинский отсек",
    dsc = [[Наша медичка -- самая напрасная трата пространства, какую я видел на кораблях дальнего следования. Впрочем, "Грозный" совсем недавно вышел с верфи и проектировался по каким-нибудь обновлённым стандартам. Жаль, правда, что жилым отсекам не подкинули пару лишних кубометров.]],
    obj = { "medbox", "locker", "rean_holder" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "medbox",
    dsc = "{Аптечка} с медикаментами висит на стене.",
    act = function(s)
        all.pain.done = true
        return [[Таблеток от мигрени больше не осталось -- видимо, весь экипаж подсел на них во время полёта в червоточине. Надо будет пополнить запасы -- мы должны везти много медикаментов в грузовых отсеках.
        ^Я понимаю, что ещё пару дней в червоточине, и мы бы попросту начали сходить с ума.]]
    end
}

es.obj {
    nam = "locker",
    unbar = false,
    dsc = "В углу прячется массивный металлический {рундук}, в котором хранится медицинское оборудование.",
    act = function(s)
        if not all.nav1.done then
            return "Мне там ничего не нужно."
        elseif s.unbar then
            s.unbar = true
            return "Я закрываю рундук."
        else
            s.unbar = true
            return "Я открываю рундук."
        end
    end,
    used = function(s, w)
        if w.nam == "rean" and not s.unbar then
            return "Рундук сейчас закрыт."
        elseif w.nam == "rean" then
            all.rean_holder.taken = false
            purge("rean")
            return "Я возвращаю реаниматор на место."
        end
    end
}

es.obj {
    nam = "rean_holder",
    taken = false,
    cnd = "{locker}.unbar and not s.taken",
    dsc = "Внутри лежит {реаниматор}.",
    act = function(s)
        s.taken = true
        take("rean")
        return "Я забираю реаниматор."
    end
}

es.obj {
    nam = "rean",
    disp = es.tool "Реаниматор",
    inv = "Реаниматор -- это здоровый чёрный диск, похожий на противопехотную мину, который заводится против часовой стрелки."
}
-- endregion

-- region tech
es.room {
    nam = "tech",
    pic = "ship/tech",
    disp = "Технический отсек",
    done = function(s)
        return all.gravs.done and all.comps.done and all.power_med.done
    end,
    onexit = function(s, t)
        if all.gravs.wait > 1 then
            p "Я бы сначала подождал, пока заработает гравитация."
            return false
        end
        if t.nam == "corridor" and not s:done() then
            p "Я ещё не закончил здесь работу."
            return false
        elseif t.nam == "corridor" and not all.nav1.crisis then
            es.walkdlg {
                dlg = "majorov",
                branch = "corridor",
                pic = "ship/corridor",
                disp = "Коридор"
            }
            return false
        end
    end,
    timer = function(s)
        all.gravs.wait = all.gravs.wait + 1
        if all.gravs.wait == 6 then
            p "Надо немного подождать."
            return true
        elseif all.gravs.wait == 20 then
            p "Гравитационные катушки должны были уже заработать, но я всё ещё вишу в воздухе."
            return true
        elseif all.gravs.wait == 30 then
            p "Катушки вышли из строя? Ладно, жду ещё десять секунд. Не хочется, чтобы набравшая силу гравитация приложила меня с размаху об пол -- или, что ещё хуже, о какой-нибудь терминал."
            return true
        elseif all.gravs.wait == 40 then
            timer:stop()
            es.stopMusic(2000)
            all.gravs.done = true
            all.gravs.wait = 0
            p [[Гравитация обрушивается на меня штормовой волной. Я падаю на колени, не отпуская леер, словно от него зависит моя жизнь.
            ^Требуется время, чтобы свыкнуться с вновь обретённой силой тяжести. Несмотря на то, что искусственной гравитации на "Грозном" далеко до земной, мышцы ноют от боли, требуя пощады.]]
            return true
        else
            return false
        end
    end,
    preact = function(s)
        if all.gravs.wait > 1 then
            return "Я не хочу отпускать леер, пока не заработали гравитационные катушки."
        end
    end,
    dsc = [[Наверное, когда я вернусь на Землю, мои ночные кошмары продолжатся -- только вместо алых червей я буду видеть эту опостылевшую техничку или свою каюту размером с гардеробный шкаф.]],
    obj = {
        "key_holder",
        "patron_holder",
        "modules",
        "power",
        "power_gravs",
        "power_med",
        "power_comps",
        "gravs",
        "comps"
    },
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
    nam = "patron_holder",
    taken = false,
    dsc = function(s)
        if not s.taken then
            return "Рядом с ним закреплён предохранительный {патрон}."
        else
            return "Рядом с ним -- {крепление} для предохранительного патрона."
        end
    end,
    act = function(s)
        if not s.taken then
            s.taken = true
            take("patron")
            return "Я снимаю предохранительный патрон со стены."
        else
            return "Я уже взял предохранительный патрон."
        end
    end,
    used = function(s, w)
        if w.nam == "key" then
            return "Ключ вставляется в соседний кронштейн."
        elseif w.nam == "patron" then
            s.taken = false
            purge("patron")
            return "Я возвращаю патрон на место."
        end
    end
}

es.obj {
    nam = "patron",
    disp = es.tool "Предохранитель",
    inv = "Предохранительный патрон для электрического щитка."
}

es.obj {
    nam = "key",
    disp = es.tool "Сервисный ключ",
    dsc = "У меня под ногами валяется сервисный {ключ}.",
    tak = "Я поднимаю ключ.",
    inv = "Стандартный сервисный ключ в виде трёхгранника."
}

es.obj {
    nam = "modules",
    dsc = "{БВА}, как реквизит из древнего фантастического фильма, подмигивает мне лампочками.",
    act = "Всё штатно, ни одного красного огонька.",
    used = function(s, w)
        if w.nam == "key" then
            return "БВА работает штатно и ремонта не требует, не думаю, что стоит снимать панель для сервисного обслуживания."
        elseif w.nam == "patron" then
            return "Предохранитель не для этого."
        end
    end
}

es.obj {
    nam = "power",
    unbar = false,
    patron = false,
    done = function(s)
        return all.power_comps.done and all.power_gravs.done and all.power_med.done
    end,
    dsc = function(s)
        if not s.unbar then
            return "В глубине отсека, словно нарочно спрятанный от глаз, высится массивный металлический короб с главным {распределительным щитом}."
        elseif s.unbar and s:done() then
            return "{Распределительный щиток} открыт. Энергия подаётся на все системы."
        elseif s.unbar and s.patron then
            return "{Распределительный щиток} открыт. Сейчас энергия отведена от"
        elseif s.unbar then
            return "{Распределительный щиток} открыт. Сначала надо вставить предохранительный патрон."
        end
    end,
    act = function(s)
        if s.unbar then
            return "Главный распредительный щиток корабля, где можно подавать энергию на различные системы. Перед входом в червоточину все фотонные ВА отрубаются."
        else
            return "Для доступа к распределительному щитку нужен ключ."
        end
    end,
    used = function(s, w)
        if w.nam == "patron" and not s.unbar then
            return "Стоит сначала открыть щиток."
        elseif w.nam == "patron" then
            s.patron = true
            purge("patron")
            return "Я вставляю в отверстие предохранительный патрон, поворачиваю его против часовой стрелки, и он сам, медленно раскручиваясь против бега секунд, втягивается в панель."
        elseif w.nam == "key" and s.unbar then
            s.unbar = false
            return "Дверца распределительного щитка теперь закрыта."
        else
            s.unbar = true
            return "Я открываю дверцу распределительного щитка."
        end
    end
}

es.obj {
    nam = "power_gravs",
    done = false,
    cnd = "{power}.unbar and {power}.patron and not s.done",
    dsc = function(s)
        if all.power_comps.done and all.power_med.done then
            return "{гравитационных катушек}."
        elseif not all.power_comps.done and all.power_med.done then
            return "{гравитационных катушек} и"
        elseif all.power_comps.done and not all.power_med.done then
            return "{гравитационных катушек} и"
        elseif not all.power_comps.done and not all.power_med.done then
            return "{гравитационных катушек},"
        end
    end,
    act = function(s)
        s.done = true
        return "Я щёлкаю переключателем, загорается тусклый светодиод -- скоро у нас будет гравитация."
    end
}

es.obj {
    nam = "power_med",
    done = false,
    cnd = "{power}.unbar and {power}.patron and not s.done",
    dsc = function(s)
        if all.power_comps.done and all.power_gravs.done then
            return "{медицинского модуля}."
        elseif all.power_comps.done and not all.power_gravs.done then
            return "{медицинского модуля}."
        elseif not all.power_comps.done and all.power_gravs.done then
            return "{медицинского модуля} и"
        elseif not all.power_comps.done and not all.power_gravs.done then
            return "{медицинского модуля} и"
        end
    end,
    act = function(s)
        s.done = true
        return "Энергия на медицинскую капсулу теперь подаётся, хотя, насколько я помню, она долго приходит в себя после отключения, так что воспользоваться ей в ближайшее время не получится."
    end
}

es.obj {
    nam = "power_comps",
    done = false,
    cnd = "{power}.unbar and {power}.patron and not s.done",
    dsc = "{вычислительной техники}.",
    act = function(s)
        s.done = true
        return "Теперь можно включать вычислительные аппараты."
    end
}

es.obj {
    nam = "gravs",
    wait = 0,
    done = false,
    dsc = function(s)
        if not s.done then
            return "{Управление гравами} (ещё одна оцинкованная колонка) располагается рядом со щитком,"
        else
            return "Управление гравами (ещё одна оцинкованная колонка) располагается рядом со щитком,"
        end
    end,
    act = function(s)
        if not all.power_gravs.done then
            return "Сначала надо включить подачу энергии."
        else
            return "Для включения потребуется сервисный ключ."
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not all.power_gravs.done then
            return "Сначала надо включить подачу энергии."
        elseif w.nam == "key" and s.wait == 0 then
            s.wait = 1
            return [[Больше четырёхсот часов без гравитации -- и тело уже отвыкло, что у него есть вес. Не просто так меня посылают реанимировать корабль после червоточины -- как самого молодого. Сами-то лежат в ложементах, опутанные ремнями, как пауки в своих тенётах.
            ^Я вставляю ключ в разъем и поворачиваю до упора. Из машины раздаётся нарастающий гул. Надо повернуть ещё разок, и тогда у меня останется несколько секунд перед тем, как заработают гравитационные катушки.]]
        elseif w.nam == "key" and s.wait == 1 then
            s.wait = 2
            timer:set(1000)
            es.stopMusic()
            es.loopMusic("descend")
            return "Я резко крутанул ключ и вцепился в леер на стене. Всё, теперь надо просто ждать."
        elseif w.nam == "key" and s.wait > 1 then
            return "Надо ждать, пока не заработают гравитационные катушки."
        end
    end
}

es.obj {
    nam = "comps",
    done = false,
    dsc = "а {центральный вычислительный аппарат} прячется за БВА.",
    act = function(s)
        if not all.power_comps.done then
            return "Сначала надо включить подачу энергии."
        elseif not s.done then
            return "Для включения фотонного ВА потребуется сервисный ключ."
        else
            return "Всё уже сделано."
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not all.power_comps.done then
            return "Сначала надо включить подачу энергии."
        elseif w.nam == "key" and not s.done then
            s.done = true
            return [[Я поворачиваю ключ, экран на терминале вспыхивает, и по нему бегут строчки трассировки загрузочного модуля. Спустя несколько секунд появляется экран управляющего интерфейса. Всё прошло без ошибок.
            ^Детальную диагностику проведём вместе с Кофманом.]]
        elseif w.nam == "key" then
            return "Здесь я уже всё сделал."
        end
    end
}
-- endregion

-- region interlude3
es.room {
    nam = "interlude3",
    pic = "ship/nav",
    noinv = true,
    disp = "Навигационный отсек",
    enter = function(s)
        es.stopMusic()
        es.music("horn")
    end,
    dsc = [[Я забегаю в отсек навигатора. Вслед за мной тут же влетают Григорьев и Кофман. Кофман грубо отодвигает меня плечом и подскакивает к Мерцель, которая колдует у анализатора.]],
    next = function(s)
        all.nav1.crisis = true
        walkin("nav1")
    end
}
-- endregion

-- region nav1
es.room {
    nam = "nav1",
    crisis = false,
    done = false,
    pic = "ship/nav",
    disp = "Навигационный отсек",
    dsc = function(s)
        if not all.tech:done() then
            return [[Я захожу в навигационный отсек и какое-то время нерешительно стою у капсулы. Зачем я сюда пришёл? Майоров дал мне вполне чёткие указания, а я зачем-то пытаюсь тянуть время.]]
        else
            return [[Мне сложно в это поверить. Теперь настоящим кошмаром кажутся не мои сны во время дрейфа, а происходящее сейчас.]]
        end
    end,
    obj = { "merzel", "kofman2", "majorov2", "capsule" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "merzel",
    cnd = "{tech}:done()",
    dsc = "{Мерцель}",
    act = function(s)
        es.walkdlg("mercel.head")
        return true
    end
}

es.obj {
    nam = "kofman2",
    cnd = "{tech}:done()",
    dsc = "вместе c {Кофманом} терзают несчастный ЦИАН, в который уже раз запуская бессмысленную диагностику.",
    act = function(s)
        es.walkdlg("kofman.nav")
        return true
    end
}

es.obj {
    nam = "majorov2",
    talk = false,
    cnd = "{tech}:done()",
    dsc = "{Майоров} стоит у",
    act = function(s)
        if not s.talk then
            es.loopMusic("doom", 3)
            s.talk = true
            es.walkdlg("majorov.reanimation1")
            return true
        else
            es.walkdlg("majorov.reanimation2")
            return true
        end
    end
}

es.obj {
    nam = "capsule",
    cnd = "{tech}:done()",
    drop = false,
    dsc = "{капсулы} и проверяет какие-то показатели.",
    act = function(s)
        if not all.majorov2.talk then
            return "Я подхожу к капсуле и касаюсь стеклянного забрала -- туман внутри проясняется, и я вижу лицо девушки, которое кажется таким же мертвым, как и всегда."
        else
            return "Надо открыть капсулу сервисным ключом."
        end
    end,
    used = function(s, w)
        if w.nam == "key" and not all.majorov2.talk then
            es.loopMusic("doom")
            all.majorov2.talk = true
            es.walkdlg("majorov.reanimation1")
            return true
        elseif w.nam == "key" then
            if not s.drop then
                s.drop = true
                drop("key")
                return "Ключ от волнения выскальзывает у меня из руки и со звоном падает на пол."
            else
                all.nav1.done = true
                es.walkdlg("majorov.capsule")
                return true
            end
        end
    end
}
-- endregion

-- region nav2
es.room {
    nam = "nav2",
    pic = "ship/nav",
    disp = "Навигационный отсек",
    dsc = [[Мне сложно в это поверить. Теперь настоящим кошмаром кажутся не мои сны во время дрейфа, а происходящее сейчас.]],
    obj = { "body", "majorov3", "mercel2", "kofman3" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "body",
    dsc = "{Тело} девушки лежит рядом с раскупоренной капсулой.",
    act = "Надо торопиться, может быть, ещё есть шанс.",
    used = function(s, w)
        if w.nam == "rean" then
            purge("rean")
            es.walkdlg("majorov.reanimation3")
            return true
        end
    end
}

es.obj {
    nam = "majorov3",
    dsc = "Перед ней сидит на коленях {Майоров} и пытается делать искусственное дыхание.",
    act = function(s)
        if not have("rean") then
            return "Сейчас не время для разговоров, мне нужно взять реаниматор."
        else
            purge("rean")
            es.walkdlg("majorov.reanimation3")
            return true
        end
    end
}

es.obj {
    nam = "mercel2",
    dsc = "Мерцель стоит в стороне, закрывая ладонями лицо.",
    act = "Сейчас не время для разговоров."
}

es.obj {
    nam = "kofman3",
    dsc = "{Кофман} проверяет что-то в терминале капсулы.",
    act = "Сейчас не время для разговоров."
}
-- endregion

-- region nav3
es.room {
    nam = "nav3",
    mus = false,
    pic = "ship/nav",
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.stopMusic(2000)
        end
    end,
    dsc = [[Все смотрят на меня.]],
    obj = {
        "step1",
        "step2",
        "step3",
        "step4",
        "step5"
    }
}

es.obj {
    nam = "step1",
    try = false,
    done = false,
    cnd = "not s.done",
    dsc = "Я {расстёгиваю} на груди девушки тонкую белую форму, похожую на больничную робу.",
    act = function(s)
        if not s.try then
            s.try = true
            return [[Я пытаюсь унять дрожь в руках.
            ^Всё должно получиться.
            ^Я проходил медицинские курсы, меня готовили к такой ситуации.]]
        else
            s.done = true
            walkin("pause3")
            return true
        end
    end
}

es.obj {
    nam = "step2",
    done = false,
    cnd = "{step1}.done and not s.done",
    dsc = "Я {ставлю} реаниматор на грудь девушки. Эта штука кажется не медицинским устройством, а страшным пыточным инструментом.",
    act = function(s)
        s.done = true
        walkin("interlude5")
        return true
    end
}

es.obj {
    nam = "step3",
    done = false,
    cnd = "{step2}.done and not s.done",
    dsc = "Я {поворачиваю} тугой трещащий барабан реаниматора, словно пытаюсь завости сломанный аппарат.",
    act = function(s)
        s.done = true
        walkin("interlude6")
        return true
    end
}

es.obj {
    nam = "step4",
    done = false,
    cnd = "{step3}.done and not s.done",
    dsc = "Барабан медленно вращается против часовой стрелки, методично отсчитывая обратные секунды, как бомба замедленного действия. Девушка несколько раз вздрагивает. Майоров проверяет её пульс и качает головой. Но можно {попробовать} снова!",
    act = function(s)
        s.done = true
        walkin("interlude7")
        return true
    end
}

es.obj {
    nam = "step5",
    cnd = "{step4}.done",
    dsc = "Барабан реаниматора завершает очередной оборот и застывает. На груди у девушки выступает кровь, кажется, что аппарат вгрызается ей в тело. Ко мне подходит {Григорьев} и кладёт руку на плечо.",
    act = function(s)
        es.stopMusic(2000)
        es.walkdlg("grigoriev.head")
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
        es.loopMusic("onechance")
    end,
    next = "interlude4"
}
-- endregion

-- region interlude4
es.room {
    nam = "interlude4",
    noinv = true,
    pic = "common/blackhole",
    dsc = [[В **** году была открыта технология, позволяющая проламывать пространство и перемещаться в червоточинах, преодолевая немыслимые ранее расстояния. Открытие долго считалось теоретическим, так как первые эксперименты показали, что любое электронное оборудование в червоточинах перестаёт работать.
    ^^В **** году были проведены первые эксперименты, в которых для осуществления навигации использовался человеческий мозг. Человек при этом вводился в состояние искусственной комы, которое стали называть кареалогической фугой в честь её открывателя, почётного члена всесоюзной АН, Михаила Кареа. Короткие эксперименты -- от несколько минут до нескольких часов -- не приводили к необратимым изменениям сознания.]],
    next = "nav3"
}
-- endregion

-- region interlude5
es.room {
    nam = "interlude5",
    noinv = true,
    pic = "common/ray",
    dsc = [[В результате экспериментов было установлено, что мужчины и женщины по-разному реагируют на кареалогическую фугу. Мужчины даже после нескольких минут навигационных расчетов в камере демонстрировали заметные изменения в поведении, которые граничили с аутизмом. Женщины без видимых проблем переносили в фуге несколько часов и даже дней. Причины этого определить так и не удалось.
    ^^В **** году один из экспериментов привёл к смерти человека. На внеочередном съезде партийной деки было принято решение прекратить все эксперименты.
    ^^В **** после прихода нового генерального секретаря развитие исследования дальних рубежей космоса было признано приоритетным направлением. Работа над кареалогической фугой возобновилась. В экспериментах принимали участие только женщины. Семьи участников получали государственные дотации на пятьдесят лет.]],
    next = "nav3"
}
-- endregion

-- region interlude6
es.room {
    nam = "interlude6",
    noinv = true,
    pic = "common/flight",
    dsc = [[В **** году были изучены все последствия кареалогической фуги на сознание навигатора и определены основные стадии деформации сознания, которые назвали циклами. На последнем, четвёртом, цикле навигатор не способен к самостоятельной жизнедеятельности за пределами аппарата, однако может находиться в состоянии искуственной комы бесконечно долго.
    ^^В **** году был осуществлён первый полёт через червоточину.]],
    next = "nav3"
}
-- endregion

-- region interlude7
es.room {
    nam = "interlude7",
    noinv = true,
    pic = "common/planet1",
    dsc = [[В **** году была открыта экзопланета Сантори-5, на которой впервые за всю историю человечества обнаружили неземную форму жизни, нуболидов.
    ^^В **** году для исследования нуболидов на орбите Сантори-5 была построена научная орбитальная станция "Кабирия".
    ^^Исследования на Сантори-5 продолжаются уже больше 10 лет.]],
    next = "nav3"
}
-- endregion

-- region outro1
-- endregion

-- region splash
es.room {
    nam = "splash1",
    noinv = true,
    pause = 70,
    bg = "common/splash",
    enter = function(s)
        es.music("soundinspace")
    end,
    next = function(s)
        walkin("outro1")
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pause = 1,
    next = function(s)
        gamefile("game/04.lua", true)
    end
}
-- endregion
