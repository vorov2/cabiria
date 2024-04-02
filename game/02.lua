-- Chapter 2
dofile "lib/es.lua"

es.main {
    chapter = "2",
    onenter = function(s)
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    disp = "Судовой отчёт",
    pic = "common/ship",
    onenter = function(s)
        es.music("grosni", 2) 
    end,
    dsc = [[<b>Корабль:</b> ГКМ "Грозный"^
    <b>Порт приписки:</b> Байконур^
    <b>Экипаж:</b> шесть человек^
    <b>Дееспособный экипаж:</b> пять человек^
    <b>Цикл навигатора:</b> четвёртый^
    <b>Груз:</b> пищевые рационы, медикаменты^
    <b>Пункт назначения:</b> Сантори-5, НИОС "Кабирия"^
    <b>Расчётное время полёта в червоточине:</b> 420 условных часов]],
    next = "intro2"
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    disp = "Судовой отчёт",
    pic = "common/ship",
    dsc = [[<b>Экипаж корабля:</b>^
    Майоров Сергей Владимирович, капитан, 38 лет^
    Григорьев Андрей Николаевич, эрц-пилот, 36 лет^
    Мерцель Елена Павлона, дейн-пилот, 46 лет^
    Кофман Аркадий Геннадиевич, эрц-инженер, 41 год^
    Вереснев Олег Викторович, дейн-инженер, 26 лет^
    Навигатор, четвёртый цикл, имя неизвестно]],
    next = "intro3"
}
-- endregion

-- region intro3
es.room {
    nam = "intro3",
    disp = "Судовой отчёт",
    pic = "common/ship",
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    tick = 1,
    times = {
        "{7 часов 59 минут}",
        "{7 часов 58 минут}",
        "{7 часов 57 минут}",
        "{7 часов 56 минут}",
        "{7 часов 55 минут}"
    },
    dsc = function(s)
        return "До выхода из червоточины осталось:^^" .. s.times[s.tick]
    end,
    act = function(s)
        if s.tick < 5 then
            if s.tick == 1 then
                es.stopMusic(2000)
            end
            s.tick = s.tick + 1
        else
            walkin("cabin")
        end
        return true
    end
}
-- endregion

-- region cabin
es.room {
    nam = "cabin",
    done = false,
    disp = "Каюта",
    pic = "ship/cabin",
    onenter = function(s)
        if not s.done then
            s.done = true
            es.music("fatigue2")
        end
    end,
    dsc = function(s)
        if all.lever2.done then
            return [[После узкой трубы душевой, где невозможно развернуться, каюта кажется даже просторной.]]
        else
            return [[Я какое-то время вишу под потолком в своей каюте, собираясь с мыслями. Кровь пульсирует в висках. Всё вокруг застилает муть, словно глаза мои смертельно устали от искусственного света.]]
        end
    end,
    onexit = function(s, t)
        if t.nam == "shower" and all.lever2.done then
            p "Сухая чистка -- не самая приятная процедура, нет смысла её повторять."
            return false
        elseif t.nam == "shower" and all.hatch.taken then
            p "Так я испачкаю комбинезон, лучше пока оставить его в каюте."
            return false
        elseif t.nam == "pause1" and not all.lever2.done then
            p "Я бы предпочёл сначала принять душ."
            return false
        elseif t.nam == "pause1" and not all.clothes.wear then
            p "Лучше сначала одеться."
            return false
        end
    end,
    obj = {
        "vigilate",
        "arrival",
        "order",
        "memo",
        "watch",
        "hatch",
        "amnion",
        "drobe",
        "showerdoor"
    },
    way = {
        path { "В коридор", "pause1" },
        path { "В душевую", "shower" }
    }
}

es.obj {
    nam = "vigilate",
    done = false,
    dsc = "Надо прийти в себя, начинается моя последняя {вахта} перед выходом из червоточины.",
    act = function(s)
        if not s.done then
            s.done = true
            walkin("disorder")
            return true
        else
            return "Впрочем, серьёзные сбои на кораблях дальнего следования случаются редко."
        end
    end
}

es.obj {
    nam = "arrival",
    done = false,
    dsc = "Сложно поверить, что скоро мы наконец куда-то прилетим. Кажется, я перестал верить в это уже {целую вечность} назад.",
    act = function(s)
        if not s.done then
            s.done = true
            walkin("long_flight")
            return true
        else
            return "Я впервые отправился в такой длительный полёт."
        end
    end
}

es.obj {
    nam = "order",
    done = false,
    dsc = "{Помню}, как я радовался назначению. Теперь я, наверное, всё бы отдал, чтобы просто вернуться домой.",
    act = function(s)
        if not s.done then
            s.done = true
            walkin("memory")
            return true
        else
            return [[На "Грозный" меня перевели в самый последний момент -- я так удивился, что решил, будто меня разыгрывают. Перестановки в экипаже обычно не делаются за несколько дней до вылета, да и опыта у меня для такого полёта маловато.]]
        end
    end
}

es.obj {
    nam = "memo",
    dsc = "^^Я невольно упираюсь взглядом в заламинированный {лист}",
    act = "Этот лист капитан в шутку повесил на переборку в моей каюте как напоминание, что я на корабле -- единственный, кто раньше не проходил через такой длительный дрейф."
}

es.obj {
    nam = "watch",
    dsc = "с {распорядком} вахты.",
    act = [[Первый пункт -- проверить навигатора, который пребывает в состоянии кареалогической фуги и, подобно живой фотонной машине, рассчитывает наш полёт в червоточине.
    ^Всё остальное потом.]]
}

es.obj {
    nam = "hatch",
    taken = false,
    dsc = function(s)
        if not s.taken then
            return "Справа от меня -- {люк} с отсеком для хранения, в который я спрятал форму, прежде чем залезть в"
        else
            return "Справа от меня -- {люк} с отсеком для хранения, куда я складываю форму, прежде чем залезть в"
        end
    end,
    act = function(s)
        if not s.taken then
            s.taken = true
            take("clothes")
            return "Я достаю из люка комбинезон."
        else
            return "Сейчас там ничего нет."
        end
    end,
    used = function(s, w)
        if w.nam == "clothes" then
            s.taken = false
            purge("clothes")
            return "Я возвращаю комбинезон обратно в люк."
        end
    end
}

es.obj {
    nam = "clothes",
    wear = false,
    disp = es.tool "Комбинезон",
    inv = function(s)
        if not all.lever2.done then
            return "Думаю, стоит сначала принять порошковый душ."
        else
            s.wear = true
            purge("clothes")
            return "Я облачился в комбинезон, неумело, точно ребёнок, барахтаясь в невесомости."
        end
        return true
    end
}

es.obj {
    nam = "amnion",
    dsc = "{спальник}, который теперь плавает под потолком, точно сброшенная кожа.",
    act = "Тот, кто придумал эту штуку, заслуживает попасть в ад. Спать в ней так же удобно, как с петлёй на шее."
}

es.obj {
    nam = "drobe",
    dsc = "Рядом с ним -- ещё одна {заслонка}, отмеченная по периметру броским красным пунктиром.",
    act = "Она закрывает нишу, в которой находится мой индивидуальный скафандр. Обычно во время полёта скафандр не требуется. Надеюсь, и этот раз не будет исключением."
}

es.obj {
    nam = "showerdoor",
    dsc = "У выхода из каюты -- сдвигающая гармошкой {дверца} в душевую с сухой чисткой.",
    act = [["Грозный" -- первый мой корабль, где в каждой каюте есть индивидуальная душевая. Правда, гальюн всё равно один на всех.]]
}
-- endregion

-- region memory
es.room {
    nam = "memory",
    pic = "common/orbit",
    disp = [[ГКМ "Грозный"]],
    dsc = [[На "Грозный" меня перевели в самый последний момент -- я так удивился, что решил, будто меня разыгрывают. Перестановки в экипаже обычно не делаются за несколько дней до вылета, да и опыта у меня для такого полёта маловато.
    ^Отказываться было, конечно, нельзя.
    ^Все меня стращали тем, что на партийной деке могут после таких выкрутасов вообще отстранить от полётов, а если я справлюсь и не свихнусь во время дрейфа, то мне наверняка повысят разряд.
    ^Отпуск даже обещали внеурочный.
    ^Я перед входом в червоточину рассказываю об этом Григорьеву, как наивный юноша, а тот хлопает меня по плечу, спрашивает, куда, дескать, в отпуск полетишь, а сам -- смеётся. Я тогда не понял, чего смешного. Зато теперь понимаю. Куда полечу, да. Снова лететь. Очень смешно.]],
    next = "cabin"
}
-- endregion

-- region disorder
es.room {
    nam = "disorder",
    pic = "ship/pc",
    disp = [[ГКМ "Грозный"]],
    dsc = [[Серьёзные сбои на кораблях дальнего следования случаются редко, обычно выходят из строя какие-нибудь сервоприводы, гидравлика, один раз, я слышал, накрылся БВА, и команде пришлось продолжать полёт без него. 
    ^Фотонные ВА в червоточинах отказываются работать, и за все бортовые системы корабля отвечает старая добрая механика. Сам БВА -- это простой интегратор без единой электронной платы, который умеет справляться далеко с не самыми сложными задачами.]],
    next = "cabin"
}
-- endregion

-- region long_flight
es.room {
    nam = "long_flight",
    pic = "common/space",
    disp = [[ГКМ "Грозный"]],
    dsc = [[Я впервые отправился в такой длительный полёт -- почти восемнадцать дней в червоточине. До этого самый долгий мой проход через нервные ткани вселенной длился чуть более дня.
    ^Время в полёте воспринимается совершенно иначе -- кажется, я десятки лет провёл на борту "Грозного", который хоть и считается самым продвинутым ГМК всесоюзного флота, запросто может свести с ума теснотой и многочисленными неудобствами.]],
    next = "cabin"
}
-- endregion

-- region shower
es.room {
    nam = "shower",
    pic = "ship/shower",
    disp = "Душевая",
    dsc = [[Я скидываю с себя нижнее бельё и забираюсь в узкую нишу, куда едва помещается взрослый человек. Дверца сама защёлкивается за мной -- со смачным звуком, как дорожный саквояж.]],
    onexit = function(s, t)
        if not all.lever2.done then
            p "Думаю, стоит всё-таки сначала помыться."
            return false
        else
            return true
        end
    end,
    obj = { "lever1", "lever2" },
    way = {
        path { "В каюту", "cabin" }
    }
}

es.obj {
    nam = "lever1",
    done = false,
    dsc = "На стене передо мной -- два рычага, в которые я едва не упираюсь носом. На {одном} -- круглая иконка, напоминающая то ли дождь, то ли снегопад.",
    act = function(s)
        if all.lever2.done then
            return "Думаю, повторять процедуру необязательно."
        elseif s.done then
            return "Ну уж нет, дополнительная доза порошка мне точно не потребуется."
        else
            s.done = true
            return "Я опускаю на рычаг, и из отверстия в потолке сыпется хлопьями, как искусственный снег, едкий, отдающий хлором порошок. Я несколько секунд втираю его в себя. Всё, теперь от меня пахнет так, словно я несколько часов кряду плавал в общественном бассейне."
        end
    end
}

es.obj {
    nam = "lever2",
    done = false,
    dsc = "На {втором} -- три волнистые линии.",
    act = function(s)
        if not all.lever1.done then
            p "Я дёргаю за второй рычаг, и меня обдаёт потоком затхлого воздуха. Кажется, спросони я перепутал рычаги."
        elseif s.done then
            p "Я закончил с банными процедурами."
        else
            s.done = true
            p "Я закрываю глаза, и плотная струя затхлого воздуха сбивает с меня остатки щёлочного порошка. Всё, мойка закончена. После подобной процедуры невольно чувствуешь себя механизмом, которому продули жиклёры."
        end
    end
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    pause = 50,
    enter = function(s)
        es.stopMusic(2000)
    end,
    next = "corridor"
}
-- endregion

-- region corridor
es.room {
    nam = "corridor",
    mus = 0,
    pic = "ship/corridor",
    disp = "Коридор",
    dsc = [[Я завис в коридоре, уцепившись за леер в стене. Потолок здесь низкий, и хотя лампы светят слабо, как на исходе заряда, мне всё равно режет глаза.]],
    onenter = function(s)
        if s.mus == 0 then
            s.mus = 1
            es.music("hope")
        elseif s.mus == 1 and all.counter.done then
            s.mus = 2
            es.music("anticipation")
        end
    end,
    onexit = function(s, t)
        if t.nam == "cabin" then
            p "Я провёл там уже достаточно времени, надо заняться своими обязанностями."
            return false
        end
    end,
    obj = {
        "majorov",
        "air",
        "pain",
        "cabindoors",
        "techdoor",
        "meddoor",
        "navdoor",
        "deckdoor"
    },
    way = {
        path { "В каюту", "cabin" },
        path { "В техотсек", "tech" },
        path { "В медотсек", "med" },
        path { "В навигационный отсек", "nav" },
        path { "В рубку", "deck" }
    }
}

es.obj {
    nam = "majorov",
    done = false,
    cnd = "{counter}.done and not s.done",
    dsc = "Передо мной, так же хватаясь за леер, парит {Сергей Владимирович Майоров}, капитан нашего корабля.^^"..fmt.nb(""),
    act = function(s)
        s.done = true
        es.walkdlg("majorov.head")
        return true
    end
}

es.obj {
    nam = "air",
    done = false,
    cnd = "not s.done",
    dsc = "Я расправляю плечи, потираю затёкшую шею -- суставы похрустывают так, словно я провисел в своём коконе для сна доброе десятилетие, а не несколько жалких часов. К тому же тяжёлое ощущение после сна так и не проходит -- {воздух} вокруг кажется вязким, как при отказе системе рециркуляции, и отдаёт металлическим привкусом, точно венозная кровь.",
    act = function(s)
        s.done = true
        return "Я прислушиваюсь -- нет, всё в порядке, из стен по-прежнему доносится настойчивый гул системы рециркуляции."
    end
}

es.obj {
    nam = "pain",
    done = false,
    dsc = function(s)
        local txt = "Невесомость -- не лучший союзник после тяжёлого сна, хочется вновь забраться в амнион и провалиться с головой в свои кошмары."
        if not s.done then
            return txt.." Надо бы посмотреть {таблетки} в медотсеке."
        else
            return txt
        end
    end,
    act = "Капитан говорил, что если принимать их слишком часто, эффекта практически не будет."
}

es.obj {
    nam = "cabindoors",
    dsc = es.br "{Двери} в каюты других членов экипажа идут по левой стороне коридора.",
    act = "Думаю, не стоит беспокоить коллег. Пусть отдыхают. Сейчас -- моя вахта."
}

es.obj {
    nam = "techdoor",
    dsc = "Справа -- {техничка}",
    act = "Осмотр технички входит в распорядок вахты, хотя, пока основные компьютеры не работают, делать там особо нечего. Основные проверки будем проводить вместе с Кофманом, после выхода из червоточины."
}

es.obj {
    nam = "meddoor",
    dsc = "и {медицинский отсек}.",
    act = "Медицинский отсек -- самый большой на корабле, но, к счастью, используется в основном как склад таблеток да различных тоников."
}

es.obj {
    nam = "navdoor",
    dsc = "В конце коридора -- единственная {дверь с иллюминатором}, который кажется каким-то издевательством, ведь человек, который там находится, никогда не сможет им воспользоваться.",
    act = "Это навигационный отсек -- самый важный пункт вахты во время дрейфа в червоточине."
}

es.obj {
    nam = "deckdoor",
    dsc = "За спиной у меня -- вход в {рубку}.",
    act = "Там, скорее всего, я и проведу большую часть времени до того, как проснутся другие члены экипажа."
}
-- endregion

-- region tech
es.room {
    nam = "tech",
    pic = "ship/tech",
    disp = "Технический отсек",
    dsc = [[Во время полёта в червоточине большая часть оборудования в техничке отключена. Даже потолочные лампы как-то неохотно роняют свет на пустые чёрные экраны и серые коробки мёртвых терминалов. Здесь всегда становится одиноко и неуютно -- мы идём в дрейфе сквозь ткань пространства, прокладывая невозможный с точки зрения нормального человеческого сознания курс, но при этом большая часть вычислительных аппаратов не работает.]],
    obj = { "modules", "key_holder" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "modules",
    dsc = "Единственный работающий модуль здесь -- это {БВА}, отвечающая за систему жизнеобеспечения.",
    act = "Все индикаторы зелёные -- аппарат работает, как часы."
}

es.obj {
    nam = "key_holder",
    taken = false,
    dsc = function(s)
        if not s.taken then
            return "Также на стене у двери висит металлический кронштейн, где хранится трёхгранный {ключ} -- главный сервисный инструмент на время вахты."
        else
            return "Также на стене у двери висит {кронштейн} для сервисного ключа."
        end
    end,
    act = function(s)
        if not s.taken then
            s.taken = true
            take("key")
            return "Я извлекаю из кронштейна ключ."
        else
            return "Надо не забыть вернуть сюда сервисный ключ. Один раз я всю вахту проносил его в кармане комбинезона, а это запрещено правилами."
        end
    end,
    used = function(s, w)
        if w.nam == "key" then
            s.taken = false
            purge("key")
            return "Я кладу ключ обратно в люк."
        end
    end
}

es.obj {
    nam = "key",
    disp = es.tool "Сервисный ключ",
    inv = "Трёхгранный ключ, который выглядит так, словно им нужно заводить как-нибудь причудливые механизмы. Люди на Земле даже не представляют, каким оборудованием нам приходится пользоваться во время полёта по червоточине."
}
-- endregion

-- region med
es.room {
    nam = "med",
    pic = "ship/med",
    disp = "Медицинский отсек",
    dsc = [[Наша медичка -- самая напрасная трата пространства, какую я видел на кораблях дальнего следования. Впрочем, "Грозный" совсем недавно вышел с верфи и проектировался по каким-нибудь обновлённым стандартам. Жаль, правда, что жилым отсекам не подкинули пару лишних кубометров.]],
    obj = { "capsule", "medbox" },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "capsule",
    dsc = "Своими исполинскими размерами отсек обязан медицинской {капсуле}, которая, к сожалению, с постановкой диагноза справляется куда лучше, чем с лечением -- как будто от этого диагноза есть какая-то польза за сотни световых лет от квалифицированной медицинской помощи.",
    act = "Ещё капсула выполняет роль реанимационного аппарата. К счастью, я ни разу не видел, как ей пользовались."
}

es.obj {
    nam = "medbox",
    taken = false,
    dsc = "Большинство проблем со здоровьем мы решаем с помощью медицинских препаратов в {аптечном шкафичке} на стене.",
    act = function(s)
        if all.pain.done then
            return "Не стоит перебарщивать с таблетками."
        elseif s.taken then
            return "Я уже взял таблетки."
        else
            s.taken = true
            take("pills")
            return "Я достаю из шкафичка таблетки от мигрени."
        end
    end,
    used = function(s, w)
        if w.nam == "pills" then
            purge("pills")
            s.taken = false
            return "Я возвращаю таблетки обратно в шкафчик. Не стоит перебарщивать с лекарствами."
        end
    end
}

es.obj {
    nam = "pills",
    disp = es.tool "Блистер с таблетками",
    inv = function(s)
        purge("pills")
        all.pain.done = true
        return "Я выдавливаю две последние таблетки из блистера и быстро их глотаю."
    end
}
-- endregion

-- region nav
es.room {
    nam = "nav",
    pic = "ship/nav",
    disp = "Отсек навигации",
    dsc = [[Свет медленно, как бы нехотя, зажигается, когда я вплываю в отсек. Правильно, навигатору ведь свет не нужен.]],
    obj = {
        "navbed",
        "navglass",
        "lifemachine",
        "fakemod1",
        "counter",
        "fakemod2",
        "checker",
        "ejector",
        "fakemod1_key",
        "counter_key",
        "fakemod2_key",
        "checker_key",
        "lever"
    },
    way = {
        path { "В коридор", "corridor" }
    }
}

es.obj {
    nam = "navbed",
    dsc = "В самом центре на металлическом пьедестале стоит стеклянный саркофаг, внутри которого лежит {навигатор}, введённый в состояние амбулаторной фуги.",
    act = "Я даже не знаю, как её зовут. Или правильнее сказать -- звали? Если после коротких полётов вред для мозга почти не ощущается, то уже на втором цикле у навигаторов вырабатывается так называемая \"звёздная болезнь\", которую проще всего сравнить с обычном аутизмом. На четвёртом цикле навигатор перестаёт быть человеком. Можно сказать, её сознание, личность, вытесняется навигационными расчётами."
}

es.obj {
    nam = "navglass",
    dsc = "{Стекло} капсулы мутное, будто человек внутри давно превратился в светящий пар.",
    act = "Я касаюсь стекла ладонью -- пальцы пронизывает холод, как от куска льда. Стекло на секунду проясняется, и я вижу женщину, упакованную в противоперегрузочный скафандр с алыми компрессионными мешками, похожими на вывернутые наружу мышцы. У неё молодое, красивое и мёртвое лицо. Глаза закрыты, изо рта торчит толстая резиновая трубка, напоминающая щупальце высасывающего жизнь паразита."
}

es.obj {
    nam = "lifemachine",
    dsc = "Толстые гофрированные трубки, выпростанные из пьедестала саркофага, вплетаются в массивный аппарат, который во время вынужденного отключения корабельных ВА отвечает за жизнеобеспечение навигатора. Его называют {ЦИАН} -- центральный интегральный анализатор. В верхней его части есть несколько контрольных панелей, подключаться к которым можно с помощью сервисного ключа:",
    act = "ЦИАН -- аппарат довольно сложный, но меня сейчас интересуют провизорный модуль и модуль сверки, обозначенные литерами \"Д\" и \"С\". Сначала нужно провести диагностику, а затем -- ввести в модуль сверки полученный результат.",
    used = function(s, w)
        if w.nam == "key" then
            return "Мне полагается провести проверку провизорного модуля и модуля сверки."
        end
    end
}

es.obj {
    nam = "fakemod1",
    key = false,
    dsc = "{\"Ж\"} с аналоговым циферблатом,",
    act = "Модуль \"Ж\" используется для настройки систем жизнеобеспечения.",
    used = function(s, w)
        if w.nam == "key" then
            purge("key")
            s.key = true
            return "Я вставляю ключ в разъём на панели \"Ж\"."
        end
    end
}

es.obj {
    nam = "counter",
    key = false,
    done = false,
    num = 0,
    dsc = "{\"Д\"}, где есть такой же цифeрблат, но с другой разметкой, а также",
    act = "Это -- провизорный модуль.",
    used = function(s, w)
        if w.nam == "key" then
            purge("key")
            s.key = true
            return "Я вставляю ключ в разъём на панели \"Д\"."
        end
    end
}

es.obj {
    nam = "fakemod2",
    key = false,
    dsc = "{\"А\"} и",
    act = "Модуль \"А\" отвечает за аварийный режим капсулы.",
    used = function(s, w)
        if w.nam == "key" then
            drop("key")
            s.key = true
            return "Я вставляю ключ в разъём на панели \"А\"."
        end
    end
}

es.obj {
    nam = "checker",
    key = false,
    dsc = "{\"С\"} c диодными индикаторами.",
    num = 0,
    act = "Это модуль сверки диагностических данных.",
    used = function(s, w)
        if w.nam == "key" and not s.key then
            s.key = true
            drop("key")
            return "Я вставляю ключ в разъём на панели \"С\"."
        end
    end
}

es.obj {
    nam = "ejector",
    dsc = function(s)
        local ch,c,f1,f2 =
            all.checker,all.counter,all.fakemod1,all.fakemod2
        if ch.key or c.key or f1.key or f2.key then
            local txt = es.para "{Ключ} теперь находится в разъёме "
            if f1.key then
                txt = txt .. "\"Ж\"."
            elseif f2.key then
                txt = txt .. "\"А\"."
            elseif c.key then
                txt = txt .. "\"Д\"."
            elseif ch.key then
                txt = txt .. "\"С\"."
            end
            return txt
        end
    end,
    act = function(s)
        take("key")
        local app = ""
        if all.checker.key then
            app = " Рычаг вдвигается в панель."
        end
        all.checker.num = 0
        all.checker.key = false
        all.fakemod1.key = false
        all.fakemod2.key = false
        all.counter.key = false
        return "Я слегка надавливаю на ключ, и тот со смачным щелчком прыгает мне в руку." .. app
    end
}

es.obj {
    nam = "lever",
    dsc = function(s)
        if all.checker.key then
            p "Из панели выдвигается {рычаг} -- надо будет опустить его, как только я закончу ввод диагностических данных."
        end
    end,
    act = function(s)
        local ch,c = all.checker,all.counter
        print("checker", ch.num)
        print("counter", c.num)
        if ch.num == 0 then
            p "Рано пока опускать рычаг, я же ещё не ввёл никаких данных."
        elseif c.num ~= ch.num then
            return [[ЦИАН издаёт рассерженный гудок -- кажется, что воздух под большим давлением прогоняется через пробитый патрон, -- и индикатор на панели загорается красным.
            ^Что это значит? Проблемы с капсулой? Такого за все мои полёты ещё не было.
            ^Я смотрю на заполненный белым дымом гроб посреди комнаты. Голова всё ещё тяжёлая после измытывающего сна.
            ^Может, я неправильно ввёл данные? Лучше проверить всё ещё разок, прежде чем будить экипаж.]]
        else
            c.done = true
            return [[Внутри анализатора что-то гулко щёлкает, как в огромном часовом механизме, а лампа на панели загорается зелёным.
            ^Всё в порядке, диагностика успешно пройдена.]]
        end
    end
}

es.obj {
    nam = "fakemod1_key",
    dsc = function(s)
        if all.fakemod1.key then
           return "Для взаимодействия с панелью его нужно {повернуть}."
        end
    end,
    act = "Не думаю, что мне стоит что-либо менять в системах жизнеобеспечения."
}

es.obj {
    nam = "counter_key",
    dsc = function(s)
        if all.counter.key then
           return "Для взаимодействия с панелью его нужно {повернуть}."
        end
    end,
    act = function(s)
        all.counter.done = true
        local n = rnd(4)
        local dsc = {
            "Наконец стрелка на табло медленно поднимается до отметки \"4\".",
            "Через секунду стрелка на приборе быстро прыгает до пятёрки.",
            "Вскоре стрелка поднимается до отметки \"2\", замирает на секунду, а затем быстро сокращает оставшееся расстояние до шестёрки.",
            "Стрелка резкими эпилептическими рывками поднимается сначала до девятки, а затем медленно оседает к отметке \"7\". Самый высокий показатель капсулы за всё время моей работы, хотя мне говорили, что нет смысла самому интерпретировать эти результаты."
        }
        all.counter.num = n + 3
        return "Я поворачиваю ключ до упора и жду. Анализатор сосредоточенно гудит, я чувствую исходящую от него вибрацию. " .. dsc[n]
    end
}

es.obj {
    nam = "fakemod2_key",
    dsc = function(s)
        if all.fakemod2.key then
           return "Для взаимодействия с панелью его нужно {повернуть}."
        end
    end,
    act = "Модуль отвечает за аварийный режим, что я собираюсь с ним делать?"
}

es.obj {
    nam = "checker_key",
    dsc = function(s)
        if all.checker.key then
           return "Eго нужно {поворачивать} для ввода данных."
        end
    end,
    act = function(s)
        all.checker.num = all.checker.num + 1
        local tab = {
            " Я повернул ключ.",
            " Я повернул ключ второй раз.",
            " Так, третий поворот ключа. Главное, не сбиться.",
            " Я повернул ключ в четвёртый раз.",
            " Пятый поворот. Какое значение выдала диагностика? Не запутаться бы, я до сих пор не пришёл в себя после сна.",
            " Поворачиваю ключ в шестой раз.",
            " Это уже седьмой поворот ключа."
        }
        if all.checker.num > 7 then
            return "Я всё продолжаю и продолжаю поворачивать ключ, как будто завожу странный часовый механизм."
        else
            return tab[all.checker.num]
        end
    end
}
-- endregion

-- region deck
es.room {
    nam = "deck",
    leave = false,
    pilot = false,
    mus = false,
    pic = "ship/deck",
    disp = "Рубка",
    onenter = function(s, t)
        if all.counter.done and have("key") then
            p "Ну вот! Опять я не положил на место сервисный ключ. Лучше сделать это сразу, чтобы не забыть."
            return false
        elseif not all.counter.done then
            p "Я бы всё-таки действовал согласно инструкции и сначала проверил состояние навигатора."
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("dali", 2)
        end
    end,
    onexit = function(s, t)
        if t.nam == "corridor" and not s.leave then
            es.walkdlg("grigoriev.leave")
            return false
        end
    end,
    dsc = [[Командная рубка -- самый большой отсек на корабле. Даже освещение здесь ярче, чем на остальном корабле -- на рубку не жалеют электричества.]],
    obj = {
        "pilot_seats",
        "seats",
        "extra_seat",
        "captain_seat",
        "porthole",
        "grigoriev"
    },
    way = {
        path { "В коридор", "corridor" }
    }
}

obj {
    nam = "pilot_seats",
    dsc = "У прикидывающегося иллюминатором панорамного экрана стоят массивные ложементы пилотов, оборудованные {рычагами управления} и командными терминалами.",
    act = "Когда-то я тоже хотел стать пилотом, но экзамен в полётную школу провалил. Впрочем, работа пилота на удивление не сильно отличается от моей. Вахта. Большую часть времени мы всё равно проводим в подпространственном дрейфе."
}

obj {
    nam = "seats",
    dsc = "Ещё {четыре ложемента} попроще придвинуты к стенам, окружая пилотов -- два по левой стороне и два по правой.",
    act = "Согласно, инструкциям все члены экипажа должны находиться в рубке во время любых манёвров. Обычно, впрочем, это пустая предосторожность -- стыковка со станциями производится настолько неторопливо, что можно заснуть от скуки. К тому же на корабле включаются гравитационные катушки. На планетарную посадку корабли класса ГМК и вовсе не способны -- у Земли мы стыкуемся с ГКС и спускаемся на планету на орбитальном лифте."
}

obj {
    nam = "extra_seat",
    dsc = "Один, {запасной}, всегда пуст.",
    act = "На самом деле, это ложемент навигатора -- просто я ни разу в жизни не летал с навигаторами на ранних циклах, когда они ещё похожи на живых людей, и привык видеть это место пустым."
}

obj {
    nam = "captain_seat",
    dsc = "У всех ложементов в подлокотник вмонтированы {терминалы} на подвижном кронштейне, напоминающем щупальцу.",
    act = "Терминалы сейчас отключены, мы идём в дрейфе."
}

obj {
    nam = "porthole",
    dsc = function(s)
        if not all.deck.pilot then
            return "Слаженную симметрию рубки нарушает небольшой одинокий {иллюминатор},"
        else
            return "Слаженную симметрию рубки нарушает небольшой одинокий {иллюминатор}."
        end
    end,
    act = function(s)
        if all.deck.pilot then
            es.walkdlg("grigoriev.tail")
            return true
        else
            return "За спиной Григорьева ничего не разглядеть."
        end
    end
}

obj {
    nam = "grigoriev",
    dsc = function(s)
        if not all.deck.pilot then
            return "у которого, придерживаясь за леер в стене, сосредоточенно всматривается в пустоту {Андрей Григорьев}, наш эрц-пилот."
        else
            return "{Григорьев} лежит в своём ложементе."
        end
    end,
    act = function(s)
        if all.deck.pilot then
            return "-- Посмотри, посмотри! -- улыбается Григорьев."
        elseif all.deck.leave then
            es.walkdlg("grigoriev.flight")
            return true
        else
            es.walkdlg("grigoriev.hello")
            return true
        end
    end
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.stopMusic(2000)
    end,
    next = function(s)
        gamefile("game/03.lua", true)
    end
}
-- endregion