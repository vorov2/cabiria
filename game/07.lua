-- Chapter 7
dofile "lib/es.lua"

es.main {
    chapter = "7",
    onenter = function(s)
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    pic = "common/station",
    seconds = 12,
    enter = function(s)
        es.music("hope", 2)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds + 1
        if s.seconds == 17 then
            timer:stop()
            walkin("c1a")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    template = "НИОС \"Кабирия\"^День третий^^09:12:%s",
    dsc = function(s)
        return string.format(s.template, all.intro1.seconds)
    end
}
-- endregion

-- region c1a
es.room {
    nam = "c1a",
    pic = "station/cabin1",
    disp = "Жилой модуль C1",
    dsc = [[Вечерний кофе помог. Снов мне больше не снилось -- по крайней мере, я их не помню. Что ж, будем считать, что эти запоздалые кошмары были чем-то вроде кесонной болезни после выхода из червоточины.]],
    onexit = function(s, t)
        if t.nam == "main" then
            return all.knock:act()
        end
    end,
    obj = { "furniture", "porthole", "knock" },
    way = {
        path { "В санузел", "c1a_latrine" },
        path { "В коридор", "main" }
    }
}

es.obj {
    nam = "furniture",
    dsc = "Хоть каюта и большая, обстановка в ней {бедная}, как в камере.",
    act = "Впрочем, обстановка меня мало волнует."
}

es.obj {
    nam = "porthole",
    opened = false,
    dsc = function(s)
        local txt = "Если бы не прямоугольный {иллюминатор}, личное окно на орбиту Сантори-5, я бы и правда чувствовал себя, как узник в жестяной клетке."
        if s.opened then
            return txt.." Иллюминатор открыт, но всё равно ничего не видно."
        else
            return txt.." Сейчас иллюминатор закрыт."
        end
    end,
    act = function(s)
        if s.opened then
            s.opened = false
            return "Я закрываю иллюминатор."
        else
            s.opened = true
            return "Я нажимаю кнопку на стене, шторка иллюминатора опускается, и взгляд упирается в пустоту. Я ничего не вижу -- ни планеты, ни звёзд, лишь муаровую темноту космического пространства."
        end
    end
}

obj {
    nam = "knock",
    dsc = "Со стороны двери раздаётся надрывная монотонная {мелодия}, похожая на технический шум. Я не сразу понимаю, что ко мне пришли гости.",
    act = function(s)
        es.stopMusic(4000)
        es.walkdlg {
            dlg = "marytan",
            branch = "head",
            pic = "station/cabin1",
            disp = "Жилой модуль C1"
        }
        return true
    end
}
-- endregion

-- region c1a_latrine
es.room {
    nam = "c1a_latrine",
    pic = "station/toilet1",
    disp = "Санузел",
    dsc = [[Места в санузле чуть ли не больше, чем в моей каюте на "Грозном".]],
    obj = { "sink" },
    way = {
        path { "Выйти", "c1a" }
    }
}

es.obj {
    nam = "sink",
    done = false,
    dsc = "До сих пор не могу поверить, что в раковине есть {кран} с настоящей водой, а не отдающем хлоркой порошком, разъедающим кожу.",
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

-- region corridor1
es.room {
    nam = "corridor1",
    pic = "station/corridor1",
    disp = "Коридор",
    dsc = [[В коридорах между жилыми блоками куда больше света, чем на нижних палубах с пристанями. Я невольно осматриваюсь.]],
    onenter = function(s)
        es.music("anticipation")
    end,
    obj = { "portholes", "noise", "talk" }
}

es.obj {
    nam = "portholes",
    dsc = "Узкие {иллюминаторы} в стенах не закрыты жалюзями, но я всё равно не вижу ничего, кроме темноты.",
    act = "Хотелось бы уже увидеть эту знаменитую Сантори-5."
}

es.obj {
    nam = "noise",
    dsc = "Из стен исходит едва ощутимая {вибрация} -- биение сердца станции, -- от работы тысяч машин, благодаря которым мы не падаем в газовый океан под нами.",
    act = "Меня всегда успокаивал гул от работы систем жизнеобеспечения и гравитационных катушек, а тишина, напротив, пугала. Тишина -- это системный сбой."
}

es.obj {
    nam = "talk",
    dsc = "{Марутян} оживлённо разговаривет с Симоновой, которая сосредоточенно морщится и кивает, глядя на него так, словно ей не терпится поскорее отправиться по своим делам. Впрочем, перебивать руководителя она не решается.",
    act = function(s)
        es.walkdlg("marytan.simonova")
        return true
    end
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    pic = "station/diner",
    disp = "Столовая",
    enter = function(s)
        es.stopMusic(3000)
    end,
    dsc = [[Марутян заводит меня в довольно мрачную столовую с решётчатым полом и металлическими панелями на стенах, где из-за рябящих ламп начинает болеть голова.
    ^-- Автомат у стены, -- говорит Марутян. -- Выбирайте, что хотите.]],
    next = "diner1"
}
-- endregion

-- region diner1
es.room {
    nam = "diner1",
    mus = false,
    pic = "station/diner",
    disp = "Столовая",
    onexit = function(s, t)
        if t.nam == "main" then
            es.walkdlg {
                dlg = "marytan",
                branch = "leave1",
                pic = "station/diner",
                disp = "Столовая"
            }
            return false
        elseif t.nam == "vending" and all.tray.taken then
            p "Думаю, мне хватит одного завтрака."
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("lotus", 3, 0, 2000)
        end
    end,
    dsc = [[В столовой нет никого, кроме нас -- видимо, остальные сотрудники лаборатории уже успели позавтракать, или же мы, напротив, заметно опережаем график.]],
    obj = { "marytan1", "desk" },
    way = {
        path { "В коридор", "main" },
        path { "К автомату", "vending" }
    }
}

es.obj {
    nam = "marytan1",
    sit = false,
    dsc = function(s)
        if not s.sit then
            return "{Марутян} стоит у продуктового аппарата и покачивает указательным пальцем, глядя на таблички с названиями, словно отсчитывает про себя музыкальный ритм."
        else
            return "{Марутян} сидит за"
        end
    end,
    act = function(s)
        if not s.sit then
            s.sit = true
            return "Мой новый коллега наконец что-то выбирает и, удовлетворённо улыбаясь, отправляется к столику с подносом."
        else
            return "Марутян смотрит на меня, улыбается и поднимает пластиковый стаканчик с таким видом, как будто предлагает тост."
        end
    end
}

es.obj {
    nam = "desk",
    cnd = "{marytan1}.sit",
    dsc = "{столиком} неподалёку от дверей.",
    act = function(s)
        if not all.tray.taken then
            return "Надо бы и правда взять себе что-нибудь поесть."
        else
            purge("tray")
            es.walkdlg {
                dlg = "marytan",
                branch = "diner1",
                pic = "station/diner",
                disp = "Столовая"
            }
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "tray" then
            return s:act()
        end
    end
}
-- endregion

-- region vending
es.room {
    nam = "vending",
    drink = false,
    pic = "station/diner",
    disp = "Автомат",
    dsc = [[Продуктовый автомат больше всего напоминает промышленный рефрижератор и время от времени издаёт такой же низкочастотный гул.]],
    enter = function(s)
        all.marytan1.sit = true
    end,
    exit = function(s)
        if have("key") then
            purge("key")
            p "Я оставляю ключ от продуктового автомата."
            all.key_holder.taken = false
        end
    end,
    onexit = function(s)
        if have("breakfast") and s.drink and not have("tray") then
            p "Лучше положить всё на поднос."
            return false
        end
    end,
    obj = {
        "option1",
        "option2",
        "option3",
        "coffee_holder",
        "tea_holder",
        "compote_holder",
        "key_holder",
        "tray_holder"
    },
    way = {
        path { "Отойти", "diner1" }
    }
}

local option_base = {
    act = function(s)
        return string.format([[На табличке написано: "%s".]], s.cont)
    end,
    used = function(s, w)
        if w.nam == "key" then
            all.breakfast.opt = s.idx
            all.breakfast.taken = true
            all.key_holder.taken = false
            purge("key")
            take("breakfast")
            return 
                [[Я несколько раз поворачиваю ключ против часовой стрелки, словно завожу внутри продуктового аппарата шестерёнчатый механизм. Ключ с каждым оборотом движется всё тяжелее, пока наконец не замирает, до предела натянув невидимую пружину.
                ^Аппарат дрожит. В его недрах что-то металлически позвякивает, даже светящаяся надпись "Завтрак" на секунду мигает. Раздаётся бодрый звонок, загорается тусклое пожелание "Приятного аппетита" -- как бы опережая события, словно внутри механизма что-то разладилось, -- и спустя ещё несколько секунд на открывшемся лотке появляется пластиковый контейнер.]]
        end
    end
}

es.obj(option_base) {
    nam = "option1",
    idx = 1,
    dsc = [[Лицевая панель устройства разделена на четыре секции, первые три из которых соответствуют тому или иному приёму пищи, а последняя -- напиткам. Сейчас подсвечиваются только "Завтрак" с напитками. Выбор на завтрак -- самый скудный. Под затёртой выштамповкой "комплексное питание" размещены серенькие таблички с прорезями для винтового ключа (завтрак {№1},]],
    cont = "Сырник, джем, тостовый хлеб"
}

es.obj(option_base) {
    nam = "option2",
    idx = 2,
    dsc = "{№2} и",
    cont = "Омлет, овощной мусс, тостовый хлеб"
}

es.obj(option_base) {
    nam = "option3",
    idx = 3,
    dsc = "{№3})",
    cont = "Протеиновая каша, джем, тостовый хлеб"
}

es.obj {
    nam = "breakfast",
    taken = false,
    opt = 0,
    disp = es.tool "Контейнер с завтраком",
    inv = function(s)
        if s.opt == 1 then
            return "Завтрак №1: сырник, джем и кусок серого картона."
        elseif s.opt == 2 then
            return "Завтрак №2: омлет, овощной мусс и странная серая масса, которую здесь называют хлебом."
        elseif s.opt == 3 then
            return "Завтрак №3: протеиновая каша, джем и обломок черепицы, видимо, тостовый хлеб."
        end
    end
}

es.obj {
    nam = "coffee_holder",
    dsc = "да россыпь алюминиевых кнопок с напитками -- {кофе},",
    act = function(s)
        if not all.vending.drink then
            all.vending.drink = "coffee"
            take("coffee")
            return "Я выбираю кофе -- неплохо бы проснуться."
        else
            return "Мне достаточно одного напитка."
        end
    end
}

es.obj {
    nam = "tea_holder",
    dsc = "{чай}",
    act = function(s)
        if not all.vending.drink then
            all.vending.drink = "tea"
            take("tea")
            return "После долгих раздумий я останавливаю выбор на чае."
        else
            return "Мне достаточно одного напитка."
        end
    end
}

es.obj {
    nam = "compote_holder",
    dsc = "и {компот}.",
    act = function(s)
        if not all.vending.drink then
            all.vending.drink = "compote"
            take("compote")
            return "Компот? Почему бы и нет!"
        else
            return "Мне достаточно одного напитка."
        end
    end
}

es.obj {
    nam = "coffee",
    bev = true,
    drink = 0,
    cnd = "{vending}.drink == 'coffee' and s.drink < 5",
    disp = es.tool "Стаканчик кофе",
    inv = "Стакан с горячим кофе.",
    dsc = "Над {пластиковым стаканчиком} с чёрной, похожей на отработанное масло жидкостью понимается едва различимый пар.",
    act = function(s)
        s.drink = s.drink + 1
        if s.drink == 1 then
            return "Я делаю осторожный глоток. Кофе совсем не горячий, но пронзительно горький, и я невольно кривлюсь, как будто глотнул рвотного. Но, странным образом, мне нравится вкус -- тяжёлый и резкий, как у лекарства, которое излечивает от сонливости."
        elseif s.drink == 5 then
            return "Пластиковый стаканчик пуст, а во рту стоит такая едкая горечь, как будто я наглотался технической жидкости."
        else
            return "Я делаю ещё один глоток кофе."
        end
    end
}

es.obj {
    nam = "tea",
    bev = true,
    drink = 0,
    cnd = "{vending}.drink == 'tea' and s.drink < 5",
    disp = es.tool "Стаканчик чая",
    inv = "Стакан с горячим чаем.",
    dsc = "Над {пластиковым стаканчиком} с водянистым чаем понимается едва различимый пар.",
    act = function(s)
        s.drink = s.drink + 1
        if s.drink == 1 then
            return "Я пригубил чай. Вкуса у него почти нет, я словно пью пустой кипяток, в котором едва угадывается лёгкий травяной аромат."
        elseif s.drink == 5 then
            return "Я допиваю остатки чая."
        else
            return "Я делаю ещё один глоток чая."
        end
    end
}

es.obj {
    nam = "compote",
    bev = true,
    drink = 0,
    cnd = "{vending}.drink == 'compote' and s.drink < 5",
    disp = es.tool "Стаканчик компота",
    inv = "Стакан с компотом.",
    dsc = "Бледно-розовый компот в {пластиковом стаканчике} напоминает техническую жидкость, вроде средства для чистки стёкол.",
    act = function(s)
        s.drink = s.drink + 1
        if s.drink == 1 then
            return "Я делаю несколько глотков компота. Он на удивление сладкий, от вяжущей приторности сводит рот. Можно подумать, я взял не компот, а чистый раствор сахарного сиропа."
        elseif s.drink == 5 then
            return "Я допиваю приторную жижу, которую здесь называют компотом."
        else
            return "Я делаю ещё один глоток компота."
        end
    end
}

es.obj {
    nam = "key_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = "Сам {ключ} висит на верёвке сбоку от аппарата.",
    act = function(s)
        if not all.breakfast.taken then
            take("key")
            s.taken = true
            return "Я беру ключ."
        else
            return "Ключ мне уже не потребуется."
        end
    end
}

es.obj {
    nam = "key",
    disp = es.tool "Винтовой ключ",
    inv = "Винтовой ключ для продовольственного аппарата."
}

es.obj {
    nam = "tray_holder",
    taken = false,
    dsc = [[На металлическом столике рядом лежат {подносы}.]],
    act = function(s)
        if not s.taken and (not have("breakfast") or not all.vending.drink) then
            return "Я бы взял сначала завтрак и напиток, а потом уже положил всё на поднос."
        elseif not s.taken and have("breakfast") and not all.vending.drink then
            return "Надо ещё выбрать напиток."
        elseif not s.taken and not have("breakfast") and all.vending.drink then
            return "Одного напитка для завтрака будет мало."
        elseif not s.taken then
            s.taken = true
            all.tray.taken = true
            purge("breakfast")
            purge("coffee")
            purge("tea")
            purge("compote")
            take("tray")
            return "Я кладу на поднос контейнер с едой и пластиковый стаканчик."
        else
            return "Достаточно одного подноса."
        end
    end,
    used = function(s, w)
        if w.nam == "tray" then
            return "Зачем мне ставить сюда поднос с едой?"
        elseif w.nam == "breakfast" and not all.vending.drink then
            return "Надо ещё выбрать напиток."
        elseif w.nam == "breakfast" and all.vending.drink then
            return s:act()
        elseif w.bev and not have("breakfast") then
            return "Одного напитка для завтрака будет мало."
        elseif w.bev and have("breakfast") then
            return s:act()
        end
    end
}

es.obj {
    nam = "tray",
    taken = false,
    disp = es.tool "Поднос с завтраком",
    inv = function(s)
        local txt = ""
        if all.breakfast.opt == 1 then
            txt = "Завтрак под номером один и"
        elseif all.breakfast.opt == 2 then
            txt = "Завтрак под номером два и"
        elseif all.breakfast.opt == 3 then
            txt = "Завтрак под номером три и"
        end
        if all.vending.drink == "coffee" then
            txt = txt .. " стаканчик кофе."
        elseif all.vending.drink == "tea" then
            txt = txt .. " стаканчик чая."
        elseif all.vending.drink == "compote" then
            txt = txt .. " стаканчик компота."
        end
        return txt
    end
}
-- endregion

-- region diner2
es.room {
    nam = "diner2",
    pic = "station/diner",
    disp = "Столовая",
    dsc = [[Мы сидим за столиком у двери. Темы для беседы начинают иссякать.]],
    enter = function(s)
        es.music("fatigue2", 1, 0, 3000)
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            es.walkdlg {
                dlg = "marytan",
                branch = "leave2",
                pic = "station/diner",
                disp = "Столовая"
            }
            return false
        elseif t.nam == "vending" then
            p "Думаю, мне хватит одного завтрака."
            return false
        end
    end,
    obj = {
        "grigoriev",
        "marytan2",
        "food",
        "coffee",
        "tea",
        "compote"
    },
    way = {
        path { "В коридор", "main" },
        path { "К автомату", "vending" }
    }
}

es.obj {
    nam = "grigoriev",
    done = false,
    cnd = "not s.done",
    dsc = "По крайней мере, мы уже не одни. В столовой появляются Григорьев с Минаевой. Вначале я думаю, что они тоже пришли на поздний завтрак, но {Григорьев} добывает из трещащего продуктового аппарата пару стаканчиков с каким-то напитком, и они даже не садятся за стол.",
    act = function(s)
        s.done = true
        es.walkdlg("grigoriev.head")
        return true
    end
}

es.obj {
    nam = "marytan2",
    dsc = "{Марутян} со скучающим видом помешивает серую массу в контейнере.",
    act = function(s)
        es.walkdlg("marytan.diner2")
        return true
    end
}

es.obj {
    nam = "food",
    dsc = "{Еда в контейнере} совсем не вызывает аппетита.",
    act = function(s)
        local txt = "Я даже не помню, что взял. "
        if all.breakfast.opt == 1 then
            txt = txt.."Сырник с джемом?"
        elseif all.breakfast.opt == 2 then
            txt = txt.."Омлет с овощным муссом?"
        elseif all.breakfast.opt == 3 then
            txt = txt.."Кашу и джем?"
        end
        return txt
    end
}
-- endregion

-- region interlude2
es.room {
    nam = "interlude2",
    pic = "station/elevator",
    disp = "Лифт",
    enter = function(s)
        es.music("hope", 1, 0, 3000)
    end,
    dsc = [[Мы поднимаемся на самом медленном на моей памяти лифте на уровень, где находится лаборатория Марутяна.
    ^Марутян снова тянет меня за плечо.]],
    next = "interlude3"
}
-- endregion

-- region interlude3
es.room {
    nam = "interlude3",
    pic = "station/hall",
    disp = "Холл лаборатории",
    dsc = [[Наконец мы заходим в прямоугольное помещение с широким иллюминатором, которое Марутян называет "холлом".]],
    next = function(s)
        es.walkdlg("marytan.hall")
    end
}
-- endregion

-- region hall1
es.room {
    nam = "hall1",
    pic = "station/hall",
    disp = "Холл лаборатории",
    dsc = [[Холл кажется довольно тесным для главной достопримечательности станции.]],
    onexit = function(s, t)
        if t.nam == "interlude1" then
            p "Я ведь только пришёл."
            return false
        elseif t.nam == "interlude2" then
            p "Туда мне пока что не нужно."
            return false
        elseif t.nam == "lab1" then
            p "Надо подождать Марутяна."
            return false
        end
    end,
    obj = { "marytan3", "planet1" },
    way = {
        path { "В коридор", "interlude1" },
        path { "В инженерный отсек", "interlude2" },
        path { "В лабораторию", "lab1" }
    }
}

es.obj {
    nam = "marytan3",
    dsc = "{Марутян} стоит у двери в лабораторию и смотрит на меня, хитро прищуриваясь.",
    act = function(s)
        if not all.planet1.done then
            es.walkdlg("marytan.golook")
            return true
        else
            es.walkdlg("marytan.golab")
            return true
        end
    end
}

es.obj {
    nam = "planet1",
    done = false,
    dsc = "{Иллюминатор} закрыт плотными металлическими жалюзями, которые не пропускают даже лучика света. Можно подумать, что здешние обитатели боятся долго смотреть на планету.",
    act = function(s)
        if not s.done then
            s.done = true
            walkin("pause1")
            return true
        else
            return "Думаю, на первый раз достаточно."
        end
    end

}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    pause = 50,
    enter = function(s)
        es.music("ocean", 1, 0, 3000)
    end,
    next = "planetview"
}
-- endregion

-- region planetview
es.room {
    nam = "planetview",
    pic = "common/planet1",
    disp = "Холл лаборатории",
    dsc = [[Я нажимаю тугую кнопку на стене, металлические жалюзи со скрипом поднимаются, и пыльный воздух в отсеке тут же рассекает стремительный, как лезвие, свет.
    ^Я прикрываюсь ладонью, отступаю, словно передо мной не газовый гигант, а звезда, и она затягивает к себе горящую в плазме станцию.
    ^Проходит несколько секунд, прежде чем я решаюсь посмотреть.
    ^Глаза быстро привыкают, планета уже не кажется такой невыносимо яркой. Теперь я вижу, что её омывает световой прилив -- поднимается широкой волной из пустоты и, подчиняясь гравитации, несётся над поверхностью искрящимся шлейфом, пока не смешивается с темнотой.
    ^Сантори-5 напоминает гигантскую планету-океан, только застывшую во времени. Ураганный ветер гоняет над её вечными волнами лентикулярные облака, похожие на космические корабли, созданные из пара. Она восхищает и угнетает. Не знаю, почему, но мне сложно долго на неё смотреть.
    ^Я опускаю железную штору.]],
    next = "hall1"
}
-- endregion

-- region lab1
es.room {
    nam = "lab1",
    mus = false,
    pic = "station/lab",
    disp = "Лаборатория",
    dsc = [[Лаборатория напоминает проявочную в фотоателье, тонущую в треске вычислительных аппаратов. Всё вокруг заливает плотный красный свет.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("juxtaposition", 2, 0, 3000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "hall1" then
            p "Не думаю, что будет вежливо уйти."
            return false
        end
    end,
    obj = {
        "marytan4",
        "simonova1",
        "sinitsin",
        "chamber",
        "comp"
    },
    way = {
        path { "В холл", "hall1" }
    }
}

es.obj {
    nam = "card",
    disp = es.tool "Ключ-карта",
    inv = "Обычная ключ-карта для доступа к терминалу."
}

es.obj {
    nam = "marytan4",
    done = false,
    dsc = "{Марутян} стоит, сцепив на груди руки, и хитро посматривает на меня, сдвинув кустистые брови, из которых толстыми остями торчат седые волоски.",
    act = function(s)
        if all.comp.done then
            es.walkdlg("marytan.nubolids")
            return true
        else
            s.done = true
            es.walkdlg("marytan.lab")
            return true
        end
    end
}

es.obj {
    nam = "simonova1",
    done = false,
    dsc = "{Симонова}, с которой мы столкнулись в коридоре перед завтраком, сидит за своим терминалом и страшно горбится, неуклюже нажимая на клавиши.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("simonova.head")
            return true
        else
            return "Думаю, не стоит ей мешать."
        end
    end
}

es.obj {
    nam = "sinitsin",
    done = false,
    cnd = "{chamber}.touch == 2",
    dsc = "За соседним столом работает {Синицын}.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("sinitsin.head")
            return true
        else
            return "У него и без меня хватает дел."
        end
    end
}

-- region terminal
es.terminal {
    nam = "lab.terminal",
    locked = function(s)
        return not all.comp.unlocked
    end,
    vars = {
        kray = 0,
        ion = 0,
    },
    commands_help = {
        ion = "настройка ионизации воздуха",
        reset = "сброс всех настроек",
        kray = "излучение Крайченко"
    },
    commands = {
        kray = function(s, args, load)
            local lvl = s:arg(args)
            local tab = {
                "уровень излучения по умолчанию",
                "уровень излучения 1 (+300 кр)",
                "уровень излучения 2 (+500 кр)",
                "уровень излучения 3 (+1000 кр)"
            }
            if not lvl then 
                return {
                    "Текущий уровень излучения:",
                    tab[s.vars.kray + 1],
                    "",
                    "Синтаксис:",
                    "kray [уровень излучения]",
                    "Допустимые значения уровня излучения: от 0 до 3"
                }
            elseif not tonumber(lvl) or tonumber(lvl) < 0
                or tonumber(lvl) > 3 then
                return {
                    "Недопустимое значение уровня излучения.",
                    "Допустимые значения уровня излучения: от 0 до 3"
                }
            elseif not load then
                return "$load"
            else
                s.vars.kray = tonumber(lvl)
                return {
                    "Уровень излучения успешно изменён.",
                    "Текущий уровень излучения:",
                    tab[s.vars.kray + 1]
                }
            end
        end,
        ion = function(s, args, load)
            local lvl = s:arg(args)
            local tab = {
                "уровень ионизации по умолчанию",
                "уровень ионизации 1",
                "уровень ионизации 2",
                "уровень ионизации 3"
            }
            if not lvl then 
                return {
                    "Текущий уровень ионизации:",
                    tab[s.vars.ion + 1],
                    "",
                    "Синтаксис:",
                    "ion [уровень ионизации]",
                    "Допустимые значения уровня ионизации: от 0 до 3"
                }
            elseif not tonumber(lvl) or tonumber(lvl) < 0
                or tonumber(lvl) > 3 then
                return {
                    "Недопустимое значение уровня ионизации.",
                    "Допустимые значения уровня ионизации: от 0 до 3"
                }
            elseif not load then
                return "$load"
            else
                s.vars.ion = tonumber(lvl)
                return {
                    "Уровень ионизации успешно изменён.",
                    "Текущий уровень ионизации:",
                    tab[s.vars.ion + 1]
                }
            end
        end,
        reset = function(s, args, load)
            if not load then
                return "$load"
            end
            s.vars.ion = 0
            s.vars.kray = 0
            return "Настройки излучения Крайченко и ионизации сброшены."
        end
    },
    before_exit = function(s)
        if s.vars.kray + s.vars.ion > 0 then
            all.comp.done = true
            walkin("nubolids")
            return true
        end
    end
}
-- endregion

es.obj {
    nam = "chamber",
    unbar = false,
    touch = 0,
    dsc = function(s)
        if not s.unbar then
            return "^^Главная роль здесь отводится {камере содержания} -- огромной колонне с непрозрачным стеклом, затянутым тенью."
        else
            return "^^Главная роль здесь отводится {камере содержания} -- огромной колонне с толстым стеклом, собирающем множество алых отражений."
        end
    end,
    act = function(s)
        if not s.unbar then
            s.unbar = true
            if not all.marytan4.done then
                all.marytan4.done = true
                es.walkdlg("marytan.pre_unbar")
            else
                es.walkdlg("marytan.unbar")
            end
            return true
        elseif s.touch == 0 then
            s.touch = 1
            es.music("ocean", 1, 0, 3000)
            es.walkdlg("marytan.touch1")
            return true
        elseif s.touch == 1 then
            s.touch = 2
            es.walkdlg("marytan.touch2")
            return true
        elseif s.touch > 1 then
            return "Лучше воспользоваться терминалом."
        end
    end
}

es.obj {
    nam = "comp",
    done = false,
    unlocked = false,
    dsc = "В камеру вмонитрован {вычислительный аппарат}.",
    used = function(s, t)
        if t.nam == "card" then
            s.unlocked = true
            walkin("lab.terminal")
            return true
        end
    end,
    act = function(s)
        if not all.marytan4.done then
            return "Лучше сначала поговорить с Марутяном."
        else
            s.unlocked = false
            walkin("lab.terminal")
            return true
        end
    end
}
-- endregion

-- region nubolids
es.room {
    nam = "nubolids",
    noinv = true,
    mus = false,
    pic = "common/nubolids4",
    disp = "Лаборатория",
    effects = {
        ["1x0"] = nil,
        ["2x0"] = "Нуболиды как-то необычно сгруппировались, как будто камера стала меньше, и напоминают теперь плотные заросли ламинариев.",
        ["3x0"] = "Нуболиды яростно сплелились друг с другом, образовав некое подобие извилистого ствола, прорастающиего по центру камеры. Глядя на них, кажется, что это -- лишённая кожного покрова конечность, судорожное переплетние мышц и жил.",
        ["0x1"] = nil,
        ["1x1"] = "Кажется, нуболидов раскачивают невидимые волны, всё сильнее и сильнее, пока они вдруг не замирают на зыбкое мгновение -- изображают стоп-кадр на видео-записи, -- и вновь продолжают свой странный танец с неровным ритмом.",
        ["2x1"] = "Часть нуболидов сжалась в маленький клубок, зависший посреди аквариума, пока другие носятся вокруг алыми лентами, изображая движение электронов.",
        ["3x1"] = nil,
        ["0x2"] = nil,
        ["1x2"] = "Нуболиды облепили стёкла камеры, как будто что-то выталкивает их изнутри, и теперь до отвращения напоминают ленточных червей.",
        ["2x2"] = nil,
        ["3x2"] = "Нуболиды похожи на огромное сердце, которое резко пульсирует, то сжимается в крепкий клубок, то расплетается наружу, врезаясь тонкими отростками в стекло, чтобы через мгновение вновь собраться воедино.",
        ["0x3"] = "Нуболиды бешено носятся в камере, закручиваясь спиралью. Можно подумать, что их количество увеличилось, как будто они размножаются под воздействием ионизации.",
        ["1x3"] = "Нуболиды летают по камере, иногда сплетаясь вместе и образуя дёргающие, как при агонии конечности. Кажется, что какое-то разорванное на части создание пытается вновь собраться воедино, и никак не может.",
        ["2x3"] = nil,
        ["3x3"] = nil
    },
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("premonition", 2, 0, 2000)
        end
        local tm = _("lab.terminal").vars
        local key = string.format("%dx%d", tm.kray, tm.ion)
        if not s.effects[key] then
            tm.kray = 0
            tm.ion = 0
            es.walkdlg {
                dlg = "nubolids",
                branch = key,
                disp = "Лаборатория",
                pic = "common/nubolids3"
            }
        end
    end,
    dsc = function(s)
        local tm = _("lab.terminal").vars
        local key = string.format("%dx%d", tm.kray, tm.ion)
        tm.kray = 0
        tm.ion = 0
        return s.effects[key]
    end,
    next = "lab1"
}
-- endregion

-- region interlude4
es.room {
    nam = "interlude4",
    pic = "common/nubolids2",
    disp = "Лаборатория",
    dsc = [[Марутян без слов подходит к терминалу и вставляет карту в приёмник.
    ^Несколько секунд ничего не происходит. Потом нуболиды сжимаются в клубок и -- исчезают.
    ^Я поражённо смотрю на Марутяна, на Симонову, но они молчат.
    ^Камеру заполняют световые блики, не имеющие источника. Через секунду ткань пространства разрывается, и из образовавшейся прорехи вываливается мерзкая копошащаяся масса алых червей.]],
    enter = function(s)
        es.music("hemisphere")
    end,
    next_disp = "-- Что это?",
    next = function(s)
        purge("card")
        es.walkdlg {
            dlg = "marytan",
            branch = "wormhole",
            pic = "station/lab",
            disp = "Лаборатория"
        }
    end
}
-- endregion

-- region hall2
es.room {
    nam = "hall2",
    mus = false,
    pic = "station/hall",
    disp = "Холл лаборатории",
    dsc = [[Я всё ещё не могу отойти после произошедшего. Марутян явно понимал, какой эффект произведёт его презентация и не стал сразу загружать новыми обязанностями, предложив понаблюдать в холле за Сантори-5.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("fatigue2")
        end
    end,
    onexit = function(s, t)
        if t.nam == "interlude1" then
            p "Ещё рано уходить."
            return false
        elseif t.nam == "interlude2" then
            p "Туда мне пока что не нужно."
            return false
        elseif t.nam == "lab1" then
            p "На сегодня я, пожалуй, уже наигрался с нуболидами."
            return false
        end
    end,
    obj = { "simonova2", "planet2", "alexin1" },
    way = {
        path { "В коридор", "interlude1" },
        path { "В инженерный отсек", "interlude2" },
        path { "В лабораторию", "lab1" }
    }
}

es.obj {
    nam = "simonova2",
    done = false,
    dsc = "{Симонова} решила ко мне присоединиться. Она стоит у иллюминатора, мечтательно обняв себя за плечи и смотрит",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("simonova.planet")
            return true
        else
            es.walkdlg("simonova.look")
            return true
        end
    end
}

es.obj {
    nam = "planet2",
    done = false,
    dsc = "на огромного {синего гиганта} в обрамлении глубокой темноты.",
    act = function(s)
        if not all.simonova2.done then
            return "Одинокий газовый гигант -- без колец и спутников, что даже при моих познаниях в астрономии, кажется необъяснимым феноменом, -- похож на планету-океан из фантастической книги."
        else
            s.done = true
            walkin("storm")
            return true
        end
    end
}

es.obj {
    nam = "alexin1",
    cnd = "{planet2}.done",
    dsc = "^^В холл выходит невысокий бородатый {мужчина} и приветливо мне кивает.",
    act = function(s)
        es.stopMusic(3000)
        es.walkdlg("alexin.head")
        return true
    end
}
-- endregion

-- region storm
es.room {
    nam = "storm",
    pic = "common/planet2",
    disp = "Холл",
    dsc = [[Кажется, что планету возмущают наши эксперименты над нуболидами -- её синяя атмосфера вскипает, и в густых наслоениях облаков прорезается глаз бури, напоминающий эхо от далёкого взрыва.]],
    enter = function(s)
        es.music("santorum", 1, 0, 2000)
    end,
    next = "hall2"
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    pause = 60,
    enter = function(s)
        es.music("whatif", 2, 2000, 3000)
    end,
    next = "corridor2"
}
-- endregion

-- region corridor2
es.room {
    nam = "corridor2",
    done = false,
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = function(s)
        if s.done then
            return [[Согласно часам, ещё только ранний вечер, конец рабочего дня, но можно подумать, что скоро уже включится ночной режим.]]
        else
            return [[После смены я устал так, как будто работал, не разгибаясь, несколько дней. По часам на станции, показывающим какое-то фальшивое время, ещё ранний вечер, но всё, чего мне хочется -- вернуться в модуль и провалиться в сон.]]
        end
    end,
    onexit = function(s)
        s.done = true
    end,
    obj = { "lonely", "shadow" },
    way = {
        path { "К иллюминатору", "near_porthole" }
    }
}

es.obj {
    nam = "lonely",
    dsc = "Свет в коридоре наконец приглушили, как бы намекая обитателям, что пора уже потихоньку разбредаться по клеткам. Впрочем, я никого и не вижу. Я один спустился на лифте и один бреду по {сумеречному коридору} в жилой модуль.",
    act = "Местные распорядки мне никто не объяснял, но можно подумать, что люди большую часть времени предпочитают одиночество, или же проводят свободные часы в местах, куда мне пока не дали доступа."
}

es.obj {
    nam = "shadow",
    dsc = "Впрочем, неподалёку от своего отсека я замечаю {Веру}, которая смотрит в узкий иллюминатор на темноту.",
    act = "Она так погружена в себя, что даже меня не замечает."
}
-- endregion

-- region near_porthole
es.room {
    nam = "near_porthole",
    disp = "Рядом с иллюминатором",
    pic = "station/corridor2",
    dsc = [[В узкую полоску иллюминатора как обычно ничего не получается разглядеть. Можно подумать, стёкла здесь совсем не пропускают свет, чтобы не отвлекать обитателей станции.]],
    obj = { "howl", "vera" },
    way = {
        path { "Отойти", "corridor2" }
    }
}

es.obj {
    nam = "howl",
    dsc = "Из стен доносится раздражающий монотонный {гул}, который срывается на протяжное завывание, словно даже переборки стонут от одиночества.",
    act = "Этот ритуал повторяется каждый день в один и тот же час -- видимо, так здесь работает система рециркуляции."
}

es.obj {
    nam = "vera",
    dsc = "{Вера} замечает меня, оборачивается и приветливо улыбается.",
    act = function(s)
        es.music("faith", 1, 0, 4000)
        es.walkdlg("vera.head")
        return true
    end
}
-- endregion

-- region pause3
es.room {
    nam = "pause3",
    pause = 50,
    enter = function(s)
        es.music("rythm", 1, 0, 3000)
    end,
    next = "anim1"
}
-- endregion

-- region anim
es.room {
    nam = "anim1",
    pause = 60,
    bg = "bg",
    pic = "station/walk1",
    disp = "НИОС \"Кабирия\"",
    decor = [[19:02]],
    next = "anim2"
}

es.room {
    nam = "anim2",
    pause = 60,
    bg = "bg",
    pic = "station/walk2",
    disp = "НИОС \"Кабирия\"",
    decor = [[19:13]],
    next = "anim4"
}

es.room {
    nam = "anim3",
    pause = 60,
    bg = "bg",
    pic = "station/walk3",
    disp = "НИОС \"Кабирия\"",
    decor = [[19:27]],
    next = "anim4"
}

es.room {
    nam = "anim4",
    pause = 60,
    bg = "bg",
    pic = "station/diner",
    disp = "НИОС \"Кабирия\"",
    decor = [[19:48]],
    next = "anim5"
}

es.room {
    nam = "anim5",
    pause = 100,
    bg = "bg",
    pic = "station/corridor1",
    disp = "НИОС \"Кабирия\"",
    decor = [[20:17]],
    next = "pause4"
}
-- endregion

-- region pause4
es.room {
    nam = "pause4",
    pause = 100,
    enter = function(s)
        es.music("bam", 1, 0, 2000)
    end,
    next = "interlude5"
}
-- endregion

-- region interlude5
es.room {
    nam = "interlude5",
    pic = "station/cabin1",
    disp = "Каюта",
    dsc = [[Заснуть я не мог. Стоило мне прилечь на кровать, как сердце начинало молотить с бешеным ритмом, а страшная темнота, напоминающая о кошмарах, затягивала в себя, словно чёрный омут.
    ^Всю ночь я бродил по каюте.]],
    enter = function(s)
        es.music("bass", 2)
    end,
    next = "c1b"
}
-- endregion

-- region c1b
es.room {
    nam = "c1b",
    pic = "station/cabin1",
    disp = "Жилой модуль C1",
    dsc = [[Жилой модуль, который недавно казался мне огромным по сравнению с душными отсеками "Грозного", напоминает теперь тюремную камеру.]],
    onexit = function(s, t)
        if t.nam == "block_c1" and all.pain.feel < 2 then
            p "Надо бы избавиться от головной боли, прежде чем отправляться на прогулку."
            return false
        end
    end,
    obj = {
        "pain",
        "outside",
        "mybed",
        "mybox",
        "window",
        "planet_view"
    },
    way = {
        path { "В коридор", "block_c1" },
        path { "В санузел", "c1b_latrine" }
    }
}

es.obj {
    nam = "pain",
    feel = 0,
    dsc = function(s)
        if s.feel == 0 then
            return "{Головная боль} превратилась в жестокую пытку. Думаю, стоит завтра заглянуть в медблок."
        elseif s.feel == 1 then
            return "Головная боль немного отпустила, но всё ещё не проходит."
        end
    end,
    act = "Надеюсь, здесь есть какие-нибудь таблетки. Или что-нибудь ещё. Я так долго не выдержу."
}

es.obj {
    nam = "outside",
    cnd = "not {glare}.done",
    dsc = "Из-за бессонницы каюта стала казаться тесной, как гроб. Я едва не задеваю за стены плечами. Быть может, и головная боль разыгралась из-за этой давящей {тесноты}. Хочется выйти наружу.",
    act = "Я понимаю теперь, почему Вера хочет сбежать со станции. Как она прожила здесь два года? Кажется, ещё несколько дней -- и я сойду с ума."
}

es.obj {
    nam = "mybed",
    dsc = "Утлая {кроватка} с жёсткой подушкой бессовестно дразнит меня, напоминая о том, что я не могу уснуть.",
    act = function(s)
        if all.pain.feel == 2 then
            return [[Я несколько минут лежу на кровати, как пациент перед обследованием.
            ^Сна нет.]]
        else
            return "Быть может, если избавиться от головной боли, я смогу хотя бы пару часов поспать."
        end
    end
}

es.obj {
    nam = "mybox",
    dsc = "{Колонка} для личных вещей прячется в тени рядом с кроватью.",
    act = "Самый бесполезный предмет здесь, лишь занимает пространство. Ведь у меня нет никаких личных вещей."
}

es.obj {
    nam = "window",
    done = false,
    dsc = function(s)
        if not s.done then
            return "Закрытый {иллюминатор} напоминает окно в тюремной камере, в которое позволено смотреть лишь в избранные часы."
        end
    end,
    act = function(s)
        if not all.glare.done then
            return "Мне сейчас не до этого."
        else
            s.done = true
            return "Я клацаю кнопкой на стене, и иллюминатор открывается, точно механический глаз, шелестя стальными складками."
        end
    end
}

es.obj {
    nam = "planet_view",
    done = false,
    cnd = "{window}.done",
    dsc = "^^В иллюминатор видно планету -- её яркий до боли в глазах нимб, как при рассвете. Я замечаю {шторм}, на который показала мне Симонова днём.",
    act = function(s)
        if not s.done then
            s.done = true
            return "Шторм разыгрался, вихрь со слепым глазом в центре стал больше и грозится захватить теперь всю поверхность планеты. Я продолжаю смотреть."
        else
            snapshots:make()
            walkin("pause5")
            return true
        end
    end
}
-- endregion

-- region c1b_latrine
es.room {
    nam = "c1b_latrine",
    pic = "station/toilet1",
    disp = "Санузел",
    dsc = [[Санузел на станции предоставляет роскошные по сравнению с кораблями дальнего следования удобства.]],
    obj = { "medbox", "shower", "handwash" },
    way = {
        path { "Выйти", "c1b" }
    }
}

es.obj {
    nam = "medbox",
    done = false,
    dsc = "Привычная на вид {аптечка} висит рядом с дверью.",
    act = function(s)
        if s.done then
            return "Не стоит перебарщивать с таблетками."
        else
            take("meds")
            s.done = true
            return "Я нахожу в шкафчике блистер с обезболивающим. Как раз то, что мне нужно сейчас."
        end
    end
}

es.obj {
    nam = "meds",
    disp = es.tool "Таблетки",
    inv = function(s)
        purge(s)
        all.pain.feel = all.pain.feel + 1
        if all.pain.feel == 2 then
            es.stopMusic(3000)
        end
        return "Я глотаю пару капсул. Надеюсь, они скоро подействуют."
    end
}

es.obj {
    nam = "shower",
    dsc = "В {душевую кабинку} едва может поместиться взрослый мужчина.",
    act = "Интересно, как принимает душ Андреев, который раза в два больше меня? Должно быть, у него каюта с особыми удобствами."
}

es.obj {
    nam = "handwash",
    done = false,
    dsc = "Зеркало на стене рядом с {умывальником} отливает чернотой, точно выгорев изнутри. Я заглядываю в него, как в иллюминатор, и на меня -- как бы нехотя проявляясь на глянцевой поверхности -- смотрит в ответ сумрачное лицо, которое едва получается узнать.",
    act = function(s)
        if not s.done then
            s.done = true
            all.pain.feel = all.pain.feel + 1
            if all.pain.feel == 2 then
                es.stopMusic(3000)
            end
            return [[После порошка для сухой чистки, разъедающем кожу похлеще кислоты, я не могу нарадоваться настоящей, пусть и отдающей какой-то мерзкой химией воде.
            ^Я открываю кран и промываю лицо, с удовольствием жмуря глаза. Мне становится чуть лучше.]]
        else
            return "Лучше поберечь воду. Всё же лимиты здесь довольно жёсткие."
        end
    end
}
-- endregion

-- region block_c1
es.room {
    nam = "block_c1",
    pic = "station/dark_corridor1",
    disp = "Коридор",
    dsc = [[Света в коридоре почти нет, и из-за этого он кажется бесконечным. Узкие прорези выгоревших ламп, похожие на трещины в сводах, медленно, шаг за шагом, сливаются с темнотой. Перед глазами у меня тянется длинный туннель с угасающим светом. Я почему-то уверен, что, если пойду вперёд, то тут же провалюсь в чёрную бездну, как в моих кошмарах.]],
    obj = { "silence", "glare" },
    way = {
        path { "В каюту", "c1b" }
    }
}

es.obj {
    nam = "silence",
    dsc = "Если раньше меня раздражал шум воздуховодов, то теперь пугает {тишина}.",
    act = "Такая же глубокая и мёртвая, как в кошмарах. Можно подумать, что я сплю, и мне снится коридор с убывающим светом на пустой орбитальной станции, которая медленно падает в газовый океан."
}

es.obj {
    nam = "glare",
    done = false,
    cnd = "not s.done",
    dsc = "Я замечаю какой-то смутный отблеск в ближайшем {иллюминаторе}.",
    act = function(s)
        s.done = true
        return "Нет, показалось. Из узкого, как бойница, иллюминатора лишь вливается в коридор густая темнота. Мне хочется увидеть хоть что-то, кроме голых переборок и умирающего света. Я вспоминаю про иллюминатор в модуле."
    end
}
-- endregion

-- region pause5
es.room {
    nam = "pause5",
    pause = 100,
    enter = function(s)
        es.music("note")
    end,
    next = "dream1"
}
-- endregion

-- region dream1
es.room {
    nam = "dream1",
    pic = "dream/lake.boat1",
    disp = "Озеро",
    dsc = [[Я сижу в лодке. Темнота позади подгоняет вперёд, дышит в спину холодом.]],
    onexit = function(s, t)
        if not have("orb") or not _("orb").active then
            p "Я оборачиваюсь, и тут же всякое желание плыть куда-либо пропадает. Света нет, а я не хочу нырять с головой в эту безраздельную темноту."
            return false
        end
    end,
    enter = function(s)
        es.music("nightmare", 2)
    end,
    obj = { "darkness", "orb" },
    way = {
        path { "Плыть назад", "dream2" },
        path { "Плыть вперёд", "dream1_wrong" }
    }
}

es.room {
    nam = "dream1a",
    pic = "dream/lake.boat1",
    disp = "Озеро",
    dsc = [[Меня с обеих сторон окружает темнота.]],
    obj = { "darkness" },
    way = {
        path { "Плыть назад", "death_intro" },
        path { "Плыть вперёд", "dream2" }
    }
}

es.obj {
    nam = "darkness",
    dsc = "Я напряжённо вглядываюсь в плотную поволоку темноты, в которой различается какое-то смутное {движение}, игра теней.",
    act = "Я даже не хочу думать, что это.",
    used = function(s, w)
        if w.nam == "orb" and w.active then
            return "Луч фонаря не дотягивается до темноты."
        elseif w.nam == "orb" then
            return "Фонарь погас."
        end
    end
}

es.obj {
    nam = "orb",
    active = false,
    disp = es.tool "Фонарь",
    dsc = "Наконец, я замечаю в воде небольшую, размером с ладонь, {сферу}, вокруг которой разгорается очажок дрожащего слабого света.",
    tak = [[Я поднимаю сферу, сжимаю её в ладони и тут же понимаю, что это обычный карманный фонарь. Светит он слабо, но всё же придаёт мне уверенности -- возможно, с ним я всё же смогу проплыть сквозь темноту.
    ^Я направляю фонарь на собравшийся вокруг мрак, и тот сразу гаснет.]],
    inv = function(s)
        if s.active then
            s.active = false
            return "Я зачем-то выключаю фонарь, сдаюсь на милость темноте."
        else
            s.active = true
            return "Я включаю фонарь. Его луч прорезает собравшийся вокруг меня мрак."
        end
    end
}
-- endregion

-- region dream1_wrong
es.room {
    nam = "dream1_wrong",
    pic = "dream/lake1",
    disp = "Озеро",
    dsc = [[По какой-то причине я всё же решаю плыть вперёд, хотя мне пора возвращаться. Если, конечно, я ещё могу куда-то вернуться.]],
    obj = { "close_darkness" },
    way = {
        path { "Плыть назад", "dream1a" },
        path { "Плыть вперёд", "death_intro" }
    }
}

es.obj {
    nam = "close_darkness",
    done = false,
    dsc = "{Ожившая темнота} становится ближе.",
    act = "Может, и правда стоит повернуть назад?",
    used = function(s, w)
        if w.nam == "orb" and w.active then
            if not s.done then
                s.done = true
                all.orb.active = false
                return "Я взмахиваю фонарём. Фонарь гаснет. В лицо мне бьёт темнота."
            else
                return "Света моего слабенького фонарика не хватает, чтобы разгонать темноту."
            end
        elseif w.nam == "orb" then
            return "Фонарь не включён."
        end
    end
}
-- endregion

-- region dream2
es.room {
    nam = "dream2",
    pic = "dream/lake.boat2",
    disp = "Озеро",
    dsc = [[Я сам не уверен, куда плыву. Не уверен, что могу ещё куда-нибудь вернуться, что есть ещё место, которое меня примет.]],
    onexit = function(s, t)
        if t.nam == "dream3" then
            p "Я не могу плыть дальше. Кажется, темнота передо мной соткана из тысяч щупалец, которая преграждают мне путь."
            return false
        end
    end,
    obj = { "final_darkness" },
    way = {
        path { "Плыть назад", "death_intro" },
        path { "Плыть вперёд", "wakeup1" }
    }
}

es.obj {
    nam = "final_darkness",
    count = 0,
    exam = false,
    dsc = "{Темнота} вокруг наполнена страшной жизнью, обретающей силу, когда тускнеет свет. Она не даст мне пройти, весь этот мир теперь принадлежит только ей. Я здесь -- чужеродный элемент, в моих руках -- последняя искорка света, и скоро я тоже стану темнотой.",
    act = function(s)
        if not s.exam then
            s.exam = true
            s.count = 0
            return [[Я приглядываюсь и понимаю, что страшна вовсе не темнота, а то, что она за собой скрывает -- пронизанных ненавистью к свету существ, которые только и ждут, чтобы наброситься на меня и разорвать на части.
            ^Стена темноты стала чуть ближе.]]
        else
            walkin("death_intro")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "orb" and w.active then
            if s.count == 2 then
                walkin("wakeup1")
                return true
            else
                s.count = s.count + 1
                all.orb.active = false
                if s.count == 1 then
                    return "Фонарь внезапно отключается в моей дрожащей руке."
                else
                    return "Я поднимаю фонарь, но он как назло мерцает и гаснет."
                end
            end
        elseif w.nam == "orb" then
            return "Надо бы сначала включить фонарь."
        end
    end
}
-- endregion

-- region wakeup1
es.room {
    nam = "wakeup1",
    noinv = true,
    pic = "common/nubolids2",
    disp = "Озеро",
    dsc = [[Я направляю луч фонаря в бурлящую темноту, что-то вспыхивает алыми искрами, и тут же я вижу клубок красных червей, которые с гортанным воем, как у ураганного ветра, бросаются на мой свет.]],
    enter = function(s)
        purge("orb")
        es.music("fear")
    end,
    next = "pause6"
}
-- endregion

-- region pause6
es.room {
    nam = "pause6",
    pause = 60,
    next = "wakeup2"
}
-- endregion

-- region wakeup2
es.room {
    nam = "wakeup2",
    noinv = true,
    pic = "station/cabin1",
    disp = "Каюта",
    enter = function(s)
        es.music("premonition")
    end,
    dsc = [[Я просыпаюсь в поту. Судя по времени, спал я не больше часа, но мне кажется, что я провёл в холодном мраке множество часов. И сон, точно наваждение, не торопится меня отпускать.
    ^Лучше бы я вовсе не ложился. Бессонница куда лучше, чем этот непрекращающийся кошмар.]],
    next = "outro1"
}
-- endregion

-- region death_intro
es.room {
    nam = "death_intro",
    noinv = true,
    pic = "dream/lake.deep3",
    disp = "Неизвестное место",
    dsc = [[Темнота набрасывается на меня, полностью застилая последние источники света.
    ^Фонарь гаснет.
    ^Я тону во тьме, точно в ледяном водовороте. Пытаюсь подняться на поверхность, но у меня ничего не получается. Что-то сковывает мои движения, оплетая руки и ноги.]],
    next = "death"
}
-- endregion

-- region death
es.room {
    nam = "death",
    noinv = true,
    pic = "common/report",
    enter = function(s)
        es.music("death")
    end,
    dsc = [[Отчёт Елены Викторны Ефимовой, главного врача НИОС "Кабирия"
    ^День 3869, 08:11 у.в.
    ^^Вереснев Олег Викторович, техник ГКМ "Грозный", 26 полных лет, был обнаружен сегодня мёртвым в своём модуле. Причина смерти -- кровоизлияние в мозг. Предрасположенностей для кровоизлияния не имел. Проводится детальный химический анализ крови.]], 
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
    pause = 50,
    next = function(s)
        gamefile("game/08", true)
    end
}
-- endregion
