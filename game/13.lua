-- Chapter 13
dofile "lib/es.lua"

es.main {
    chapter = "13",
    onenter = function(s)
        es.music("tragedy", 2)
        take("skiagram")
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    noinv = true,
    seconds = 3,
    minutes = 46,
    pic = "common/station",
    enter = function(s)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds - 1
        if s.seconds < 0 then
            s.seconds = 59
            s.minutes = s.minutes - 1
        elseif s.seconds == 57 then
            timer:stop()
            walkin("block_a")
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
        return string.format("%sОсталось до схода с орбиты: 01:%d:%s", s.txt,
            all.intro1.minutes, sec)
    end
}
-- endregion

-- region block_a
es.room {
    nam = "block_a",
    pic = "station/block_a",
    disp = "Жилой блок А",
    dsc = [[Я до последнего верил в непричастность своего экипажа к кошмару, который творится на станции. Мы могли бы найти что-нибудь с Верой -- улику, указывающую на обезумевшего Марутяна, решившего потравить коллег. А в итоге виновником оказался кофе, который мы привезли на "Грозном".]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я уже направляюсь к выходу из жилого блока, но останавливаюсь. Зачем? Куда я иду? Я же хотел поговорить с Майоровым. Мысли путаются."
            return false
        end
    end,
    obj = { "ring", "shadows" },
    way = {
        path { "В общий коридор", "main" }
    }
}

es.obj {
    nam = "ring",
    done = false,
    dsc = "Я стою в жилом блоке напротив двери в модуль Майрова. Нужно лишь протянуть руку и нажать на {кнопку} звонка.",
    act = function(s)
        if not s.done then
            s.done = true
            return "Я нажимаю на кнопку, дверь не открывают. Не спит же он в такой ситуации?"
        else
            es.walkdlg("majorov.head")
            return true
        end
    end
}

es.obj {
    nam = "shadows",
    done = false,
    cnd = "not s.done",
    dsc = "Из глубины коридора {кто-то} идёт -- по тусклым, едва омытым светом стенам, дёргается вытянутая, как в ночном кошмаре, тень.",
    act = function(s)
        s.done = true
        return "Нет, показалось. Это просто игра света."
    end
}
-- endregion

-- region a6
es.room {
    nam = "a6",
    mus = false,
    suspect = false,
    pic = "station/cabin2",
    disp = "Жилой модуль А6",
    dsc = [[В модуле душно, и кажется, что воздух нагрелся от света.]],
    onexit = function(s, t)
        if t.nam == "block_a" and not s.suspect then
            p "У меня ещё есть здесь дела."
            return false
        elseif t.nam == "block_a" and s.suspect then
            es.walkdlg("majorov.leave")
            return false
        elseif t.nam == "main" then
            p "Нечего мне там делать."
            return false
        end
    end,
    preact = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("doom", 2)
        end
    end,
    obj = { "porthole", "coffee", "majorov" },
    way = {
        path { "В коридор", "block_a" },
        path { "В санузел", "main" }
    }
}

es.obj {
    nam = "porthole",
    done = false,
    dsc = "{Иллюминатор} закрыт, словно из страха перед орбитальной темнотой.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("majorov.porthole")
            return true
        else
            return "Лучше оставить иллюминатор в покое."
        end
    end
}

es.obj {
    nam = "coffee",
    done = false,
    dsc = "На столике рядом стоит {пустой стаканчик} из-под кофе.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("majorov.coffee")
            return true
        else
            return "Надеюсь, у Майорова не слишком высокая чувствительность к токсину."
        end
    end
}

es.obj {
    nam = "majorov",
    dsc = "{Майоров} сидит на кровати, обхватив голову.",
    act = "Глядя на него сейчас, сложно представить, что ему ещё нет сорока. Капитан похож на измученного старика.",
    used = function(s, w)
        if w.nam == "skiagram" and not all.coffee.done then
            return "Я бы предпочёл сначала рассказать ему о кофе."
        elseif w.nam == "skiagram" then
            es.music("whatif", 2, 0, 3000)
            purge(w.nam)
            es.walkdlg("majorov.skiagram")
            return true
        end
    end
}

es.obj {
    nam = "skiagram",
    disp = es.tool "Рентгеновский снимок",
    inv = "Рентгеновский снимок нуболида, который я сделал в реанимационной."
}
-- endregion

-- region corridor
es.room {
    nam = "corridor",
    pic = "station/corridor4",
    disp = "Коридор",
    dsc = [[Я бреду по коридору, точно зомби. Получается, мы прилетели, чтобы уничтожить Кабирию? Последний рубеж человечества, величайшее открытие за всю историю, нашу национальную гордость. Учёные-герои, лучшие сыны и дочери отечества. А мы прилетели их отравить.]],
    enter = function(s)
        es.music("dali", 1, 0, 3000)
    end,
    obj = { "shake", "woman" },
    way = {
        path { "К лестнице", "toplevel" }
    }
}

es.obj {
    nam = "shake",
    dsc = "По стенам вновь проходит {вибрация} -- видимо, Григорьев с новым оператором всё ещё пытаются завести металлическое сердце станции.",
    act = "Есть ли у нас шанс выбраться отсюда?"
}

es.obj {
    nam = "woman",
    done = false,
    cnd = "not s.done",
    dsc = "Навстречу мне идёт {женщина средних лет} со стаканчиком кофе в руке.",
    act = function(s)
        s.done = true
        es.walkdlg("crowd.woman")
        return true
    end
}
-- endregion

-- region toplevel
es.room {
    nam = "toplevel",
    done = false,
    pic = "station/staircase",
    disp = "Верхняя палуба",
    dsc = [[Я поднимаюсь по скрипящей лестнице на верхнюю палубу и оказываюсь в тесной клетке без света, как несколько дней назад, перед тем, как произошла катастрофа. Хотя нет, прошло ведь только несколько часов.]],
    onexit = function(s, t)
        if t.nam == "neardeck" and not s.done then
            p "Дверь закрыта."
            return false
        end
    end,
    obj = { "door", "find_button" },
    way = {
        path { "В коридор", "neardeck" }
    }
}

es.obj {
    nam = "door",
    dsc = function(s)
        if not all.toplevel.done then
            return "{Дверь} в коридор закрыта, и никто так и не починил здесь свет."
        else
            return "{Дверь} открыта, но в коридоре тоже почти нет света."
        end
    end,
    act = function(s)
        if not all.toplevel.done then
            return "Надеюсь, дверь не обесточена."
        else
            return "Не стоит здесь задерживаться."
        end
    end
}

es.obj {
    nam = "find_button",
    cnd = "not {toplevel}.done",
    dsc = "Где-то должна быть {кнопка}, открывающая выход.",
    act = function(s)
        all.toplevel.done = true
        return "Я вслепую нащупываю кнопку и с трудом нажимаю её -- она упрямо сопротивляется мне, не хочет выпускать наружу."
    end
}
-- endregion

-- region neardeck
es.room {
    nam = "neardeck",
    done = false,
    pic = "station/debris3",
    disp = "Пролёт рядом с рубкой",
    dsc = [[Я понятия не имею, зачем иду в рубку, о чём буду говорить с Григорьевым. Капитан прав, мы уже ничего не узнаем -- по крайней мере, если не сможем каким-то чудом вернуться на Землю.]],
    enter = function(s)
        es.music("bass", 1, 0, 3000)
    end,
    onexit = function(s, t)
        if t.nam == "deck" and not s.done then
            p "Я вдруг думаю -- а когда я сам в последний раз пил кофе? Я мог взять кофе в столовой и -- забыть. Всё ли в порядке у меня с головой? Может, никакого разговора с Майоровым не было, как и рентгеновского снимка."
            return false
        end
    end,
    obj = { "debris", "blood", "lamp" },
    way = {
        path { "В рубку", "deck" }
    }
}

es.obj {
    nam = "debris",
    dsc = "Этот уровень выглядит, как после бомбёжки. {Завалы} из обрушившихся панелей и кусков облицовки разбирать не стали.",
    act = function(s)
        all.neardeck.done = true
        return "Удивительно, как мы это пережили."
    end
}

es.obj {
    nam = "blood",
    dsc = "На некоторых стенах чернеют {пятна крови}.",
    act = function(s)
        all.neardeck.done = true
        return "Я совершенно не хочу вспоминать о том, что здесь произошло."
    end
}

es.obj {
    nam = "lamp",
    dsc = "Света почти нет, над {дверью рубки} вдалеке горит единственная недавно вкрученная лампа -- точно маяк в плотной облегающей темноте.",
    act = function(s)
        all.neardeck.done = true
        return "На мгновение я думаю, что надо было прихватить с собой кусок арматуры покрепче -- ведь иначе в рубку не попасть."
    end
}
-- endregion

-- region deck
es.room {
    nam = "deck",
    pic = "station/deck",
    disp = "Рубка",
    dsc = [[Рубка встречает колким светом. Горят мониторы, мерцают на панелях огни. Один аварийный люминофор всё ещё расплёскивает по стенам кровавые отблески и бьёт по глазам, гонит вон.]],
    onexit = function(s, t)
        if t.nam == "neardeck" then
            p "Убежать уже не получится."
            return false
        end
    end,
    obj = { "chair", "body", "grigoriev", "monitor", "deckcomp" },
    way = {
        path { "Выйти", "neardeck" }
    }
}

es.obj {
    nam = "chair",
    dsc = "У одного из {кресел} свёрнут подлокотник.",
    act = "Какую же силу надо было для этого приложить?"
}

es.obj {
    nam = "body",
    done = false,
    dsc = "На полу, в тёмном, точно мазут, пятне крови, лежит {тело мужчины} с отвёрткой в глазу.",
    act = function(s)
        s.done = true
        return "Кажется, это Михаил Лысанов, помощник Мицюкина."
    end
}

es.obj {
    nam = "grigoriev",
    head = false,
    dsc = "{Григорьев}, как в какой-то сюрреалистической постановке, сидит перед терминалом и медленно отстукивает что-то на клавиатуре, будто пытается поймать забытую мелодию.",
    act = function(s)
        if not s.head then
            s.head = true
            es.walkdlg("grigoriev.head")
        elseif s.head and not all.deckcomp.done then
            es.walkdlg("grigoriev.terminal")
        else
            es.walkdlg("grigoriev.toxin")
        end
        return true
    end
}

es.obj {
    nam = "monitor",
    dsc = "На панорамном {мониторе}, передающем изображения с камер, сверкает ледяной синевой Сантори-5, распуская во все стороны смертоносные лучи.",
    act = "Я вдруг понимаю, что очередной выброс попадёт по станции задолго до того, как мы войдём в атмосферу планеты."
}

es.obj {
    nam = "deckcomp",
    done = false,
    dsc = "Индикатор питания дисков на {терминале} отбивает рваный ритм, как стробоскоп.",
    act = function(s)
        if not all.grigoriev.head then
            all.grigoriev.head = true
            es.walkdlg("grigoriev.head")
        else
            walkin("deck.terminal")
        end
        return true
    end
}

es.terminal {
    nam = "deck.terminal",
    locked = function(s)
        return false
    end,
    commands_help = {
        status = "Статус двигательных модулей.",
        control = "Настройка двигательных модулей."
    },
    commands = {
        control = function()
            return "Нет доступа."
        end,
        status = function(s, args, load)
            local arg = s:arg(args)
            local num = tonumber(arg)
            local tab = {
                "[1] основной",
                "[2] маневровый",
                "[3] вспомогательный",
                "[4] резервный",
            }
            if not arg or not num or num < 0 or num > 4 then
                local txt = "Не указан номер двигательного блока."
                if arg then
                    txt = string.format("Некорректный номер двигательного блока: \"%s\".", num)
                end
                return {
                    txt,
                    "Синтаксис:",
                    "status [номер двигательного блока]",
                    "Доступные номера двигательных блоков:",
                    tab[1], tab[2], tab[3], tab[4]
                }
            end
            if not load then
                return "$load"
            end
            all.deckcomp.done = true
            es.sound("error")
            return {
                "Внимание! Ошибка!",
                string.format("Двигательный блок \"%s\" не отвечает.", tab[num])
            }
        end
    },
    before_exit = function(s)
        if all.deckcomp.done and not snd.music_playing() then
            es.music("tragedy", 2)
            return false
        end
    end
}
-- endregion

-- region deck2
es.room {
    nam = "deck2",
    pic = "station/deck",
    disp = "Рубка",
    dsc = [[Я вижу всё, как при замедленной съёмке.
    ^Мицюкин с рёвом бросается на Григорьева, размахивая плазменным лучом, как секирой. Григорьев с трудом уворачивается, бьёт Мицюкина в подбородок, но тот даже не замечает удара. Он прижимает Григорьева к приборной панели и наваливается на него всем весом. Григорьев успевает вцепиться в резак. Они борются за оружие. Плазменный луч жжёт Григорьеву волосы.
    ^-- Олег, уходи! -- кричит мне Григорьев.]],
    enter = function(s)
        snapshot:make()
    end,
    onexit = function(s, t)
        if t.nam == "nearlab1" then
            p "Нет времени звать кого-то на помощь."
            return false
        end
    end,
    obj = { "option1", "option2", "deadbody", "skrewdriver" },
    way = {
        path { "Выйти", "nearlab1" }
    }
}

es.obj {
    nam = "option1",
    dsc = "Надо решать, что делать. Я могу попробовать {оттащить обезумевшего Мицюкина},",
    act = function(s)
        es.walkdlg("mitsukin.death1")
        return true
    end,
    used = function(s, w)
        if w.nam == "skrewdriver" then
            return "Я не хочу убивать Мицюкина, нужно просто его остановить."
        end
    end
}

es.obj {
    nam = "option2",
    dsc = "или перехватить {плазменный резак}.",
    act = function(s)
        es.walkdlg("mitsukin.death2")
        return true
    end,
    used = function(s, w)
        if w.nam == "skrewdriver" then
            es.walkdlg("mitsukin.win")
            return true
        end
    end
}

es.obj {
    nam = "deadbody",
    dsc = "Тело мёртвого оператора лежит на боку в луже крови."
}

es.obj {
    nam = "skrewdriver",
    disp = es.tool "Отвёртка",
    dsc = "Из глаза торчит {отвёртка}.",
    inv = "Испачканная в крови отвёртка.",
    tak = "Я вытаскиваю отвёртку."
}
-- endregion

-- region death1
es.room {
    nam = "death1",
    pic = "common/flash",
    disp = "Рубка",
    dsc = [[Глаза обжигает плазменной вспышкой, и в следующее мгновение я проваливаюсь в бесцветную пустоту.]],
    enter = function(s)
        es.music("cutter")
    end,
    next_disp = "RELOAD",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region deck3
es.room {
    nam = "deck3",
    pic = "common/blind",
    disp = "Рубка",
    dsc = [[Перед глазами всё темнеет, я почти ничего не вижу -- только всполохи света. Я словно чудом выбрался из преисподней.]],
    onexit = function(s, t)
        if t.nam == "nearlab1" then
            p "Я пытаюсь повернуться, но падаю на колени."
            return false
        end
    end,
    obj = { "comps", "pain" },
    way = {
        path { "Выйти", "nearlab1" }
    }
}

es.obj {
    nam = "comps",
    dsc = "Какие-то {аппараты} ещё работают, мигают индикаторы, шуршат жёсткие диски, процессоры производят расчёты для несуществующих двигательных блоков.",
    act = function(s)
        es.sound("break")
        es.walkdlg("me.step")
        return true
    end
}

es.obj {
    nam = "pain",
    dsc = "Из-за режущей {боли} в боку тяжело дышать.",
    act = function(s)
        es.sound("break")
        es.walkdlg("me.step")
        return true
    end
}
-- endregion

-- region deck4
es.room {
    nam = "deck4",
    pic = "station/blinddeck",
    disp = "Рубка",
    dsc = [[Я стою, покачиваясь, посреди рубки. Зрение понемногу возвращается, но в ушах стоит надсадный звон, как после контузии.]],
    onexit = function(s, t)
        if not have("cutter") then
            p "Мне почему-то кажется, что нужно обязательно забрать с собой резак."
            return false
        end
    end,
    obj = { "allblood", "deadpilot", "cutter" },
    way = {
        path { "Выйти", "nearlab1" }
    }
}

es.obj {
    nam = "allblood",
    dsc = "Весь пол залит кровью, от сладковатой вони выворачивает кишки. Я стараюсь не смотреть на изуродованное {тело Мицюкина}.",
    act = "У меня нет сил на это смотреть."
}

es.obj {
    nam = "deadpilot",
    done = false,
    dsc = "{Григорьев} лежит у приборки. Затылок у него тёмный от крови.",
    act = function(s)
        if not s.done then
            s.done = true
            return "Я опускаюсь на колени и касаюсь пальцами его шеи. Пульса нет."
        else
            return "Григорьев мёртв."
        end
    end
}

es.obj {
    nam = "cutter",
    disp = es.tool "Плазменный резак",
    dsc = "В руке у Григорьева зажат {плазменный резак}.",
    inv = "Стандартный плазменный резак. Чтобы включить, нужно дёрнуть за спусковой крючок.",
    tak = function(s)
        if not all.deadpilot.done then
            p "Он может быть ещё жив."
        else
            p "Он так вцепился в рукоятку, что я не могу разжать его пальцы."
        end
        return false
    end,
    used = function(s, w)
        if w.nam == "skrewdriver" and not all.deadpilot.done then
            return "Он может быть ещё жив."
        elseif w.nam == "skrewdriver" then
            purge("skrewdriver")
            take("cutter")
            return "Я аккуратно отжимаю отвёрткой пальцы Григорьева и забираю резак."
        end
    end
}
-- endregion

-- region nearlab1
es.room {
    nam = "nearlab1",
    pic = "station/debris4",
    disp = "Пролёт рядом с лабораторией",
    dsc = [[Потрескивает проводка, сыплятся искры с потолка. Пол качается под ногами, как на корабле в шторм. В ушах стоит дикий звон, словно кто-то врубил тревожный сигнал прямо у меня в черепной коробке. Мысли путаются. Я делаю несколько шагов и приваливаюсь плечом к переборке.]],
    enter = function(s)
        es.music("tragedy", 2, 0, 3000)
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "У меня нет сил идти."
            return false
        end
    end,
    obj = { "strength", "darkness1", "darkness2" },
    way = {
        path { "К лаборатории", "main" }
    }
}

es.obj {
    nam = "strength",
    dsc = "Я должен восстановить силы, я должен сделать что-то. {Что?}",
    act = "Я пытаюсь вспомнить, куда я шёл, но у меня не получается."
}

es.obj {
    nam = "darkness1",
    done = false,
    dsc = "Я вглядываюсь в наступающий на меня из коридора {сумрак}.",
    act = function(s)
        s.done = true
        return "Я всматриваюсь в темноту."
    end
}

es.obj {
    nam = "darkness2",
    cnd = "{darkness1}.done",
    dsc = "Ко мне из разверзшейся темноты, ведущей прямиком в космическое пространство, движутся длинные {тени}.",
    act = function(s)
        es.walkdlg("majorov.corridor")
        return true
    end
}
-- endregion

-- region stream1
local stream_base = {
    act = function(s)
        all.stream1.counter = all.stream1.counter + 1
        return s.txt
    end
}

es.room {
    nam = "stream1",
    counter = 0,
    pic = "station/debris1",
    disp = "Коридор",
    dsc = [[Мысли путаются.]],
    enter = function(s)
        es.music("premonition", 10, 0, 3000)
    end,
    decor = [[{#sc1|нуболиды} как {#sc2|вирус} они {#sc3|путешествуют} сквозь {#sc4|червоточины} наши {#sc5|червоточины полны червей} они {#sc6|пожирают} нас изнутри пока {#sc7|станция} сходит {#sc8|с орбиты} отказал последний {#sc9|двигательный блок} {#sc10|у нас} почти {#sc11|не осталось времени} мы {#sc12|не можем улететь} {#sc13|транспортная сеть легла} {#sc14|готовятся доклады} по минску и мурманску, надо {#sc15|немного подождать} но {#sc16|постарайтесь} не пить {#sc17|кофе} {#sc18|тонкий ленточный червь} плотно {#sc19|обвивает сердце} я {#sc20|хочу успеть} я {#sc21|должен верить}]],
    obj = { "faith" }
}:with {
    es.obj(stream_base) {
        nam = "#sc1",
        txt = "Они нас уничтожат."
    },
    es.obj(stream_base) {
        nam = "#sc2",
        txt = "Пандемия."
    },
    es.obj(stream_base) {
        nam = "#sc3",
        txt = "Открыли ящик Пандоны."
    },
    es.obj(stream_base) {
        nam = "#sc4",
        txt = "Проходят сквозь пространство."
    },
    es.obj(stream_base) {
        nam = "#sc5",
        txt = "Червоточины созданы для нуболидов."
    },
    es.obj(stream_base) {
        nam = "#sc6",
        txt = "Боль внутри."
    },
    es.obj(stream_base) {
        nam = "#sc7",
        txt = "Мы прилетели, чтобы всех убить."
    },
    es.obj(stream_base) {
        nam = "#sc8",
        txt = "Мы прилетели, чтобы всех убить по приказу комитета."
    },
    es.obj(stream_base) {
        nam = "#sc9",
        txt = "Мы прилетели, чтобы всех убить по приказу комитета и погибнуть сами."
    },
    es.obj(stream_base) {
        nam = "#sc10",
        txt = "Кто мы?"
    },
    es.obj(stream_base) {
        nam = "#sc11",
        txt = "Зачем нужно время?"
    },
    es.obj(stream_base) {
        nam = "#sc12",
        txt = "Мы прилетели всех убить."
    },
    es.obj(stream_base) {
        nam = "#sc13",
        txt = "Мы испугались червей."
    },
    es.obj(stream_base) {
        nam = "#sc14",
        txt = "Сотни погибших."
    },
    es.obj(stream_base) {
        nam = "#sc15",
        txt = "Но ведь времени нет."
    },
    es.obj(stream_base) {
        nam = "#sc16",
        txt = "Нет сил."
    },
    es.obj(stream_base) {
        nam = "#sc17",
        txt = "Почему именно кофе?"
    },
    es.obj(stream_base) {
        nam = "#sc18",
        txt = "Паразит."
    },
    es.obj(stream_base) {
        nam = "#sc19",
        txt = "Вот почему так болит в груди!"
    },
    es.obj(stream_base) {
        nam = "#sc20",
        txt = "Но у меня нет времени!"
    },
    es.obj(stream_base) {
        nam = "#sc21",
        txt = "Вера?"
    },
}

es.obj {
    nam = "faith",
    cnd = "{stream1}.counter > 12",
    dsc = "Я должен тебя спасти, {Вера}.",
    act = function(s)
        es.walkdlg("majorov.vera")
        return true
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pause = 60,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        gamefile("game/14.lua", true)
    end
}
-- endregion