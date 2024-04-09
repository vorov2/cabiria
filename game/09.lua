-- Chapter 9
dofile "lib/es.lua"

es.main {
    chapter = "9",
    onenter = function(s)
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    noinv = true,
    pause = 50,
    enter = function(s)
        es.music("whatif", 2, 0, 2000)
    end,
    next = "intro2"
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    noinv = true,
    pic = "station/cabin1",
    dsc = [[Я старался не спать всю ночь, чтобы не видеть кошмаров, но всё же провалился в сон незадолго до утреннего сигнала и проснулся из-за того, что выламывал себе кисть.
    ^Я едва нашёл силы, чтобы подняться.
    ^По голове словно били кувалдой. Я долго сидел на кровати и соображал, где нахожусь. Таблетки не помогали. Свет резал глаза.
    ^Я собрался позже, чем обычно. И долго брёл по коридору, как пьяный, едва перебирая ногами.]],
    next = function(s)
        walkin("intro3")
    end
}
-- endregion

-- region intro3
es.room {
    nam = "intro3",
    seconds = 31,
    pic = "common/station",
    enter = function(s)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds + 1
        if s.seconds == 38 then
            timer:stop()
            walkin("corridor1")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    txt = "НИОС \"Кабирия\"^День пятый^^",
    dsc = function(s)
        return string.format("%s09:12:%s", s.txt, all.intro3.seconds)
    end
}
-- endregion

-- region corridor1
es.room {
    nam = "corridor1",
    pic = "station/corridor1",
    disp = "Коридор",
    dsc = [[Коридор привычно пуст. Можно подумать, я -- единственный брожу по станции в такой час.]],
    onexit = function(s, t)
        if t.nam == "block_c1" and not all.marytan.done then
            p [[Может, и правда вернуться? Наверняка меня снова затянуло в вязкий омут ночной кошмара, только вместе тёмного озеро передо мной -- сумеречный коридор.
            ^Однако я почему-то всё равно продолжаю идти вперёд.]]
            return false
        elseif t.nam == "corridor2" and not all.blood1.done then
            p "Я делаю несколько шагов и останавливаюсь, закрываю глаза. Головная боль сводит с ума."
            return false
        else
            all.pain.done = true
            all.handpain.done = true
            all.vigil.done = true
        end
    end,
    obj = {
        "pain",
        "handpain",
        "vigil",
        "windows",
        "blood1",
        "card"
    },
    way = {
        path { "К лифту", "corridor2" },
        path { "К жилым блокам", "block_c1" }
    }
}

es.obj {
    nam = "pain",
    done = false,
    cnd = "not s.done",
    dsc = "Я несколько раз останавливаюсь и опираюсь о переборку. Голова раскалывается от {боли}.",
    act = function(s)
        s.done = true
        return "Если постоять несколько секунд, закрыв глаза, то становится легче, но облегчение не длится долго -- стоит поднять веки, как боль вместе со светом вливается под черепную коробку."
    end
}

es.obj {
    nam = "handpain",
    done = false,
    cnd = "not s.done",
    dsc = "{Кисть}, которую я пытался сломать во время сна, ноет, как от подагры.",
    act = function(s)
        s.done = true
        return "Странно, но я совершенно не помню сон, хотя последние кошмары калёным железом отпечатываются в памяти. Может, это потому, что я так и не проснулся?"
    end
}

es.obj {
    nam = "vigil",
    done = false,
    cnd = "not s.done",
    dsc = "Я пытаюсь {отвлечься}, подумать о чём-то, кроме кошмаров и боли, смотрю по сторонам, но глазу не за что зацепиться. Узкий туннель пуст и окутан тишиной, как бесконечное озеро из моих кошмаров.",
    act = function(s)
        s.done = true
        return "Из-за головной боли сложно на чём-то сосредоточиться."
    end
}

es.obj {
    nam = "windows",
    cnd = "not {marytan}.done",
    dsc = "Мне кажется, что в {иллюминаторах} мреют, как мираж, звёзды. Можно подумать, что станция сошла с орбиты, вырвалась из притяжения Сантори, и дрейфует в открытом космосе, проваливаясь в темноту.",
    act = function(s)
        all.blood1.show = true
        return "Я подхожу ближе, и иллюзия мгновенно развеивается. Это лишь игра света, отблески мерцающих ламп, шальные отражения -- или у меня просто начинаются галлюцинации из-за бессоницы."
    end
}

es.obj {
    nam = "blood1",
    show = false,
    examed = false,
    done = false,
    cnd = "s.show",
    dsc = function(s)
        if all.marytan.done then
            return "Кровавый след от руки Марутяна проступает на обшивке. Звёзд в иллюминаторе больше не видно -- меня как обычно медленно и неотвратимо окружает темнота."
        elseif s.examed then
            return "^^Я приглядываюсь и замечаю кое-что ещё -- кто-то оставил на стене тёмный {отпечаток} руки, как след на прощание."
        else
            return "^^Я приглядываюсь и замечаю {кое-что ещё}."
        end
    end,
    act = function(s)
        if not s.examed then
            s.examed = true
            return "На серебристой переборке чуть ниже иллюминатора отчётливо проступает тёмное пятно в виде человеческое ладони."
        elseif s.examed then
            s.done = true
            return "Это кровь! Я моргаю, тру глаза в надежде, что мне мерещится. Я же просто сплю, и очередный безумный кошмар закончится так же, как остальные -- падением в чёрную воду или алыми червями, пожирающими меня изнутри."
        end
    end
}

es.obj {
    nam = "card",
    disp = es.tool "Карта Марутяна",
    cnd = "{marytan}.done",
    dsc = "В глазах у меня немного прояснилось, и я замечаю, что из стыка между напольными панелями {что-то} торчит.",
    act = "Руками подцепить не получается.",
    inv = "Ключ-карта от каюты Марутяна.",
    used = function(s, w)
        if w.nam == "paper" then
            return "Карточка слишком хлипка и подцепить её не получается."
        elseif w.nam == "pen" then
            take("card")
            return "После пары неудачных попыток я просовываю стрежень ручки в стык между панелями и поддеваю предмет. Это магнитная карта от жилого модуля. Скорее всего, её обронил здесь Марутян."
        end
    end
}
-- endregion

-- region corridor1a
es.room {
    nam = "corridor1a",
    seen = false,
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Пожалуй, не нужно было никуда сегодня ходить. У меня галлюцинации от головной боли -- я вижу погасшие звёзды и кровавые пятна на стенах. Я даже не уверен, куда я иду.]],
    onexit = function(s, t)
        if t.nam == "main" then
            p "Я замираю посреди коридора, забыв на секунду, куда шёл."
            return false
        end
    end,
    obj = { "handspot" },
    way = {
        path { "#elevator", "К лифту", "corridor2" }:disable(),
        path { "#block", "К жилым блокам", "main" }:disable()
    }
}

es.obj {
    nam = "handspot",
    dsc = "Я останавливаюсь, чтобы передохнуть -- короткий сон так вымотал меня, что даже несколько шагов даются с трудом -- и приваливаюсь к стене, упираюсь в переборку ладонью. В следующую же секунд я отдёргиваю {руку}, как обжёгшись.",
    act = function(s)
        all.corridor1a.seen = true
        enable "#elevator"
        enable "#block"
        return "Я невольно присматриваюсь к стене, как будто хочу убедиться, что не оставил на ней кровавый отпечаток."
    end
}
-- endregion

-- region corridor2
es.room {
    nam = "corridor2",
    mus = false,
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Эти коридоры, по которым я брожу всего лишь несколько дней, успели опостылеть мне больше, чем душные клетки на "Грозном".]],
    onenter = function(s)
        if not all.corridor1a.seen then
            walkout("corridor1a")
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("nightmare", 2, 0, 3000)
        end
    end,
    onexit = function(s, t)
        if not all.marytan.done then
            p "Я не могу просто уйти отсюда."
            return false
        elseif t.nam == "main" then
            p "Надо вызвать помощь и бежать к жене Марутяна. Может, я смогу ей чем-то помочь, что бы здесь ни происходило."
            return false
        end
    end,
    obj = { "blood2", "marytan" },
    way = {
        path { "К лифту", "main" },
        path { "К жилым блокам", "corridor1" }
    }
}

es.obj {
    nam = "blood2",
    dsc = function(s)
        if all.marytan.exam then
            return "В обшивку стены въелся толстый {багровый росчерк} -- видимо, Марутян привалился здесь к стене спиной, сполз на пол от бессилия, но потом всё же нашёл в себе силы идти дальше."
        else
            return "В обшивку стены въелся толстый {багровый росчерк} -- как будто кто-то привалился к стене спиной, сполз на пол от бессилия, оставляя после себя кровавый след, но потом каким-то образом всё же нашёл в себе силы идти дальше."
        end
    end,
    act = function(s)
        if not all.marytan.exam then
            return "Я точно знаю, что это сон. Сейчас погаснет свет, а я найду сверкающую сферу, которая потянет меня в темноту."
        else
            return "Всё это не имеет ни малейшего смысла. Я точно сплю."
        end
    end
}

es.obj {
    nam = "marytan",
    exam = false,
    done = false,
    dsc = function(s)
        if s.exam then
            return "Хватило его, впрочем, ненадолго -- {Марутян} сделал буквально несколько шагов и рухнул на пол."
        else
            return "Чуть поодаль, в тени, которая накрывает его, точно саваном, лежит {человек}."
        end
    end,
    act = function(s)
        if not s.exam then
            s.exam = true
            return "Я подхожу ближе и застываю от ужаса -- это Марутян!"
        elseif not s.done then
            s.done = true
            es.walkdlg("marytan.head")
        else
            return "Сейчас я ничего не смогу для него сделать. Надо вызвать помощь."
        end
    end
}

es.obj {
    nam = "paper",
    seen = false,
    disp = function(s)
        if s.seen then
            return es.tool "Бумажная карта"
        else
            return es.tool "Ключ-карта Марутяна"
        end
    end,
    inv = function(s)
        local base = 
            [[простая пластиковая визитка, на обратной стороне которой плотным судорожным почерком нацарапано:
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^Цвет чернил -- красный, и в первую секунду я даже думаю, что надпись сделана кровью.]]
        if not s.seen then
            s.seen = true
            return [[Я наконец-то решаю посмотреть на карточку в руке -- это вовсе не магнитный ключ, а ]] .. base
        else
            return "Это "..base
        end
    end,
    used = function(s, w)
        if w.nam == "pen" then
            return "Видимо, странные надписи сделаны именно этой ручкой. Но зачем? И что это всё означает?"
        end
    end
}
-- endregion

-- region block_c1
es.room {
    nam = "block_c1",
    pic = "station/block_c",
    disp = "Жилой блок C",
    dsc = [[Потолочные лампы как назло светят по-разному -- или из-за головной боли всё плывёт перед глазами.]],
    onexit = function(s, t)
        if not all.alarm.done then
            p "Я должен обязательно включить тревожную сигнал. Возможно, Марутяна ещё смогут спасти."
            return false
        elseif t.nam == "main" then
            p "Я зачем-то захожу в свою каюту, смотрю несколько секунд в закрытый иллюминатор, словно могу видеть сквозь железный заслон, и возвращаюсь в коридор."
            return false
        end
    end,
    obj = { "alarm" },
    way = {
        path { "В модуль С1", "main" },
        path { "В жилой блок D", "block_d1" },
        path { "В коридор", "corridor1" },
    }
}

es.obj {
    nam = "alarm",
    done = false,
    try = false,
    dsc = "На стене под щитком -- кнопка {включения} тревожной сигнализации.",
    act = function(s)
        if not s.try then
            s.try = true
            return "Руки дрожат от волнения. У меня не получается с первого раза содрать щиток. Надо попробовать ещё раз."
        elseif not s.done then
            s.done = true
            return "Со второго раза я срываю щиток и бью кулаком по кнопке. Из стальных недр станции прорывается протяжный, как на издыхающем заряде, гудок."
        else
            return "Я уже включил сигнализацию."
        end
    end,
    used = function(s, w)
        if not s.done and w.nam == "pen" then
            return "Вряд ли здесь поможет ручка."
        end
    end
}
-- endregion

-- region block_d1
es.room {
    nam = "block_d1",
    mus = false,
    pic = "station/block_d",
    disp = "Жилой блок D",
    dsc = [[Жилые блоки почти не отличаются друг от друга. Можно подумать, что я хожу кругами.]],
    onexit = function(s, t)
        if t.nam == "cell1" and all.celldoor.blocked then
            p "Дверь в каюту Марутяна закрыта."
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("premonition", 1, 0, 3000)
        end
    end,
    obj = { "marytan_splatter", "cabin_door", "pen" },
    way = {
        path { "В жилой модуль D5", "d5a" },
        path { "В жилой блок C", "block_c1" }
    }
}

es.obj {
    nam = "marytan_splatter",
    dsc = "Здесь я снова замечаю {пятна} тёмной крови на полу у двери в пятый модуль -- в модуль Марутяна.",
    act = "Значит, Марутян уже был ранен, когда вышел из каюты."
}

es.obj {
    nam = "cabin_door",
    blocked = true,
    dsc = "Пятна тянутся дорожкой к {двери} в каюту Марутяня.",
    act = function(s)
        if s.blocked then
            return "Дверь закрыта. Видимо, она закрылась автоматически после того, как Марутян выбрался из каюты."
        else
            return "Дверь больше не заблокирована, я могу зайти."
        end
    end,
    used = function(s, w)
        if w.nam == "card" and s.blocked then
            s.blocked = false
            return "Я касаюсь картой считывателя, и дверь открывается."
        elseif w.nam == "card" then
            return "Дверь уже открыта."
        elseif w.nam == "paper" and not all.paper.seen then
            return all.paper:inv()
        end
    end
}

es.obj {
    nam = "pen",
    disp = es.tool "Ручка",
    dsc = "На полу у двери валяется заляпанный кровью {продолговатый предмет}.",
    tak = "Я поднимаю непонятный предмет с пола. Оказывается, что это ручка с красным стержнем -- видимо, ей Марутян и сделал эти непонятные записи на карточке.",
    inv = "Заляпанная в крови ручка -- не очень-то хочется её рассматривать."
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    noinv = true,
    seen = false,
    pic = "station/cabinw",
    disp = "Каюта Марутяна",
    dsc = [[На секунду мне кажется, что весь отсек залит обжигающим светом, как от лазерной вспышки. Черепную коробку тут же пробивает волной боли. Я отшатываюсь и зажмуриваю глаза. Я жду несколько секунд, поднимаю веки, и всё вокруг начинает медленно проступать уродливыми пятнами, как в проявителе.]],
    enter = function(s)
        es.music("death")
    end,
    next = function(s)
        s.seen = true
        walk("d5a")
    end
}
-- endregion

-- region d5a
es.room {
    nam = "d5a",
    mus = false,
    pic = "station/cabinw",
    disp = "Жилой модуль D5",
    dsc = [[В каюте стоит уже знакомый металлический запах. Меня чуть не выворачивает, я пошатываюсь, задеваю за что-то рукой, и трубка коммуникатора со звоном слетает со стены.]],
    onenter = function(s)
        if not all.interlude1.seen then
            walkin("interlude1")
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("violin", 1, 0, 3000)
        end
    end,
    obj = { "view", "body", "communicator", "vomit" },
    way = {
        path { "Выйти", "needbreak" }
    }
}

es.obj {
    nam = "view",
    dsc = "Страшная белизна всё ещё застилает мне глаза, и первое, что я вижу -- это не кровь. (Я уже знаю, что каюта залита кровью до того, как вижу её). Сквозь слепое марево проступает открытый {иллюминатор} с сияющим, как картинка, видом, на Сантори-5.",
    act = "Ураган становится всё сильнее."
}

es.obj {
    nam = "body",
    done = false,
    dsc = "Потом я вижу {тело женщины}, которое лежит, раскинув руки, у кровати, точно изображает фигуру на распятии.",
    act = function(s)
        if not s.done then
            s.done = true
            return "Я даже не хочу осознавать, что я вижу. Всё тело покрыто мелкими ранами, как от шила. Вместо глаз -- кровавая пелена. Мне хватает секунды, и я сразу же отворачиваюсь."
        else
            return "Я больше не могу на это смотреть."
        end
    end
}

es.obj {
    nam = "communicator",
    dsc = "Трубка {коммуникатора} покачивается на проводе и бьётся о стену.",
    act = function(s)
        es.stopMusic(3000)
        es.walkdlg("mitsukin.communicator")
        return true
    end
}

es.obj {
    nam = "vomit",
    dsc = "Горло стискивает от {рвотных позывов}.",
    act = "У меня нет сил на это смотреть. Я отворачиваюсь к двери."
}
-- endregion

-- region needbreak
es.room {
    nam = "needbreak",
    pic = "station/block_d",
    disp = "Жилой блок D",
    dsc = [[Я понимаю, что мне нужно выйти, отдышаться. Я больше не могу там находиться. Кишки крутит от вони, глаза слезятся от невозможного света, хотя в каюте наверняка приглушённое освещение. Я смотрю на запястью своей руки, на которой остался синяк, и почему-то это пугает меня не меньше, чем то, что я увидел в каюте.
    ^Но я должен возвращаться, надо позвонить по коммуникатору.]],
    way = {
        path { "В жилой модуль D5", "d5a" }
    }
}
-- endregion

-- region interlude2
es.room {
    nam = "interlude2",
    noinv = true,
    pic = "station/cabinw",
    disp = "Каюта Марутяна",
    dsc = [[Я сижу рядом с иллюминатором, опустив голову, пряча глаза от света, ведь они проникают в нас сквозь зрачки. В ушах звенит, как после контузии. Кто-то говорит, нависая надо мной угрожающей тенью, но я ничего не слышу. Я не хочу ничего слышать. Я вытираю с рук кровь, чужую кровь. Но как на них попала кровь?
    ^Кто-то трясёт меня за плечо.]],
    enter = function(s)
        es.music("bass")
        purge("paper")
        purge("card")
        purge("pen")
    end,
    next = function(s)
        es.walkdlg {
            dlg = "mitsukin",
            branch = "interrogation",
            pic = "station/cabinw",
            disp = "Жилой блок D5",
        }
        return true
    end
}
-- endregion

-- region d5b
es.room {
    nam = "d5b",
    pic = "station/cabinw",
    disp = "Жилой блок D5",
    dsc = [[Свет в каюте выкручен на полную мощность, точно все набившиеся сюда люди -- актеры на сцене и дают абсурдное представление. Я уже понимаю, что происходящее -- не сон, но до сих пор хочу проснуться.]],
    obj = {
        "stains",
        "deadbody",
        "minaeva",
        "mitsukin",
        "andreev"
    },
    way = {
        path { "Выйти", "block_d2" }
    }
}

es.obj {
    nam = "stains",
    dsc = "Пятна крови на полу присыпали каким-то {белым порошком}.",
    act = "Резкого металлического запаха больше нет, но теперь в каюте стоит кислотная вонь, разъедающая слизистую."
}

es.obj {
    nam = "deadbody",
    dsc = "{Труп} накрыт чёрным мешком,",
    act = "У меня нет никакого желания разглядывать тело."
}

es.obj {
    nam = "minaeva",
    done = false,
    dsc = "около него суетится {Минаева}.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("minaeva.head")
            return true
        else
            return "Думаю, я всё же обойдусь без посещения медотсека."
        end
    end
}

es.obj {
    nam = "mitsukin",
    dsc = "Сам {Мицукин} разговаривает о чём-то с",
    act = "Не думаю, что нам есть, о чём сейчас говорить. У меня нет сил ещё раз пересказывать. Я бы и правда лучше вернулся в свою каюту."
}

es.obj {
    nam = "andreev",
    done = false,
    dsc = "{Андреевым}, оттащив его ближе к двери.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("andreev.head")
            return true
        else
            return "Я поговорю с ним потом, сейчас ему не до меня."
        end
    end
}
-- endregion

-- region block_d2
es.room {
    nam = "block_d2",
    mus = false,
    pic = "station/block_d",
    disp = "Жилой блок D",
    dsc = [[Свет в коридоре уже не такой яркий, и я наконец могу дать отдохнуть глазам. У каюты Марутяна собралась целая толпа -- кажется, что сюда стеклось всё население станции.]],
    onexit = function(s, t)
        if t.nam == "d5b" then
            es.walkdlg("lysanov.head")
            return false
        elseif t.nam == "block_c2" and not all.mercel1.done then
            p "Мерцель махает мне рукой. Кажется, она хочет о чём-то поговорить."
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("juxtaposition")
        end
    end,
    obj = {
        "security",
        "kofman",
        "majorov",
        "mercel1",
        "simonova",
        "alexin",
        "stains2"
    },
    way = {
        path { "В каюту Марутяна", "d5b" },
        path { "В жилой блок C", "block_c2" }
    }
}

es.obj {
    nam = "security",
    done = false,
    dsc = [[У входа стоят {несколько человек}, которых я уже видел в шлюзе сразу после стыковки, серых и безликих, которые материализуются на станции только во время чрезвычайных ситуаций. Одно я даже узнаю -- это Михаил Лысанов, помощник Мицюкина.]],
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("lysanov.head")
            return true
        else
            return "Вряд ли они настроены на дружескую беседу."
        end
    end
}

es.obj {
    nam = "kofman",
    done = false,
    dsc = "{Кофман}, раскрасневшийся, как во время аварии на \"Грозном\", нетерпеливо расхаживает взад-вперёд, сцепив руки за спиной.",
    act = function(s)
        if s.done then
            return "Я ещё успею поговорить с Кофманом."
        else
            s.done = true
            es.walkdlg("kofman.head")
            return true
        end
    end
}

es.obj {
    nam = "majorov",
    done = false,
    dsc = "{Майоров} говорит о чём-то с незнакомым сутулым мужчиной, который отвечает ему отрывистыми кивками.",
    act = function(s)
        if s.done then
            return "Мне больше нечего ему сказать."
        else
            s.done = true
            es.walkdlg("majorov.head")
            return true
        end
    end
}

es.obj {
    nam = "mercel1",
    done = false,
    dsc = "{Мерцель}, сузив глаза, высматривает кого-то хищным взглядом. Она выглядит постаревшей, осунувшейся, как будто со дня нашей последней встречи прошло не пару дней, а множество лет.",
    act = function(s)
        if s.done then
            return "Надо будет заглянуть к ней сегодня."
        else
            s.done = true
            es.walkdlg("mercel.invite")
            return true
        end
    end
}

es.obj {
    nam = "simonova",
    done = false,
    dsc = "{Симонова} из лаборатории тоже боязливо поглядывает по сторонам, прижимаясь к стенке.",
    act = function(s)
        if s.done then
            return "Я устал от разговоров."
        else
            s.done = true
            es.walkdlg("simonova.head")
            return true
        end
    end
}

es.obj {
    nam = "alexin",
    dsc = "Даже {Алексин} здесь.",
    act = "Голова уже идёт кругом от этих бесконечных разговоров."
}

es.obj {
    nam = "stains2",
    dsc = "{Следы крови} здесь не стали присыпать белым порошком, и они, как ржавчина, въелись в затоптанный пол.",
    act = "Можно подумать, что они специально оставили их здесь -- как напоминание."
}
-- endregion

-- region block_c2
es.room {
    nam = "block_c2",
    pic = "station/block_c",
    disp = "Жилой блок C",
    dsc = [[Здесь всё ещё слышен гомон голосов столпившихся в соседнем жилом блоке людей. Я вдруг думаю, что стоило всё же заглянуть в медотсек, попросить какой-нибудь энергетик, чтобы разогнать сонную усталость.]],
    onexit = function(s, t)
        if t.nam == "block_d2" then
            p "Я не хочу туда возвращаться."
            return false
        elseif t.nam == "c1a" and not all.vera1.done then
            p "Мне кажется, Вера хочет о чём-то поговорить."
            return false
        end
    end,
    obj = { "vera1" },
    way = {
        path { "В жилой модуль C1", "c1a" },
        path { "В жилой блок D", "block_d2" }
    }
}

es.obj {
    nam = "vera1",
    done = false,
    hidden = false,
    dsc = function(s)
        if not s.hidden then
            return "Неподалёку от входа в мою каюту стоит {Вера}. Заметив меня, она улыбается, но тут же тупит взгляд и опускает голову."
        end
    end,
    act = function(s)
        if s.done then
            return "Она не хочет продолжать разговор в коридоре."
        else
            s.done = true
            es.walkdlg("vera.head")
            return true
        end
    end
}
-- endregion

-- region c1a
es.room {
    nam = "c1a",
    pic = "station/cabin1",
    disp = "Жилой модуль С1",
    dsc = [[В каюте приятно шелестят воздуховоды, и их шум действует на меня успокаивающе. На секунду возникает безумная мысль, что вот сейчас я проглочу ещё одну бессмысленную таблетку, запью её водой из диспенсера, поправлю трубку коммуникатора, которая как-то криво висит на стене, выйду в коридор -- и день, начавшись с неудачной попытки, перезапустится заново.]],
    enter = function(s)
        all.vera1.hidden = true
        es.music("santorum")
    end,
    obj = { "porthole", "vera2" },
    way = {
        path { "Выйти", "block_c2" }
    }
}

es.obj {
    nam = "porthole",
    dsc = "{Иллюминатор} открыт, но виден лишь тонкий серп Сантори, тонущей в безбрежной темноте.",
    act = "Я почему-то думаю -- может, ураган скоро закончится?"
}

es.obj {
    nam = "vera2",
    dsc = "{Вера} подходит к иллюминатору и садится рядом с ним так же, как я сидел в каюте Марутяна.",
    act = function(s)
        es.walkdlg("vera.main")
        return true
    end
}
-- endregion

-- region interlude3
es.room {
    nam = "interlude3",
    noinv = true,
    pic = "station/cabin1",
    disp = "Жилой модуль С1",
    dsc = [[После того, как ушла Вера, я съел пищевой брикет, который прищатил с "Грозного" -- есть, несмотря на всё произошедшее, всё равно хотелось, даже слегка дрожали от слабости руки, -- и заснул, сидя у иллюминатора, понял, что сплю, испугался и проснулся с резким хрипом -- точно выплыл из водоворота на поверхность.
    ^Сантори-5 немного поднялся над рамой иллюминатора, как огромная синяя луна.]],
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = "c1b"
}
-- endregion

-- region c1b
es.room {
    nam = "c1b",
    pic = "station/cabin1",
    disp = "Жилой модуль С1",
    dsc = [[Судя по времени, я спал не больше часа, но ощущение такое, что день уже закончился, как на ускоренной перемотке, и начался новый. Я вдруг понял, что боюсь каждого нового дня.]],
    onexit = function(s)
        if not all.communicator2.done then
            p "Надо поднять трубку коммуникатора, возможно, мне кто-то звонит."
            return false
        end
    end,
    obj = { "porthole2", "communicator2" },
    way = {
        path { "Выйти", "pause1" }
    }
}

es.obj {
    nam = "porthole2",
    locked = false,
    dsc = function(s)
        if s.locked then
            return "{Иллюминатор} закрыт, но из-за этого мой жилой модуль напоминает теперь тюремную камеру."
        else
            return "Когда я смотрю в {иллюминатор}, на выплывающий из-за рамы Сантори-5, то начинает кружиться голова -- словно станция, потеряв управление, медленно заваливается на бок, как тонущий корабль."
        end
    end,
    act = function(s)
        if not s.locked then
            s.locked = true
            return "У меня нет сил больше любоваться космическими видами, от близости этой странной планеты идёт кругом голова. Я щёлкаю кнопкой на стене, и диафграма иллюминатора закрывается, шелестя металлическими пластинами."
        else
            s.locked = false
            return "Я зачем-то вновь открываю иллюминатор, и ярко-голубой серп Сантори-5 тут же врезается в глаза."
        end
    end
}

es.obj {
    nam = "communicator2",
    done = false,
    dsc = "Кажется, я слышу приглушённый звон, будто бы доносящийся из-за стены звон {интеркома}.",
    act = function(s)
        s.done = true
        return "Я беру коммуникатор, но слышу лишь металлический шорох и хрип, как будто кто-то на другом конце линии дышит в трубку."
    end
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    pause = 100,
    enter = function(s)
        es.music("overcome")
    end,
    next = "interlude4"
}
-- endregion

-- region interlude4
es.room {
    nam = "interlude4",
    noinv = true,
    pic = "station/corridor1",
    disp = "Коридор",
    dsc = [[По пути в жилой блок я едва не столкнулся с незнакомым мужчиной в технической форме, который настороженно глянул на меня и поприветствовал кивком. Из-за этой мимолётной встречи я даже чувствую некоторое воодушевление -- станция живёт, на ней есть люди, я не плутаю в лабиринтах ночных кошмаров.]],
    next = "block_b1"
}
-- endregion

-- region block_b1
es.room {
    nam = "block_b1",
    pic = "station/block_b",
    disp = "Жилой блок B",
    dsc = [[Блок B -- такая же безликая клетка с жилыми ячейками, как и все остальные.]],
    onexit = function(s, t)
        if t.nam == "b3a" and not all.door3.done then
            p "Дверь в модуль закрыта."
            return false
        elseif t.nam == "b3a" then
            es.walkdlg {
                dlg = "mercel",
                branch = "entrance",
                disp = "Жилой модуль B3",
                pic = "station/cabin4"
            }
            return false
        elseif t.nam == "main" then
            p "Можно, конечно, просто уйти, но всё-таки Мерцель просила к ней заглянуть."
            return false
        end
    end,
    enter = function(s)
        snapshots:make()
    end,
    obj = { "door3" },
    way = {
        path { "В жилой модуль B3", "b3a" },
        path { "В коридор", "main" }
    }
}

es.obj {
    nam = "door3",
    try = false,
    done = false,
    dsc = "Я стою перед {дверью} в третий модуль -- здесь живёт Мерцель.",
    act = function(s)
        if not s.try then
            s.try = true
            return "Звонок у двери выломан. Можно подумать, что предыдущий жилец страшно не любил гостей. Я стучу в дверь костяшками пальцев, но никто не открывает."
        elseif s.try and not s.done then
            s.done = true
            return "Стоило, наверное, сначала набрать Мерцель по коммуникатору? Возможно, её вообще нет в блоке. Я едва соображаю после короткого сна. Может, уйти? Но я решаю напоследок постучать ещё разок, дверь щёлкает и открывается, но никто не выходит меня встречать."
        else
            return "Дверь открыта, стучать уже нет смысла."
        end
    end
}
-- endregion

-- region b3a
es.room {
    nam = "b3a",
    pic = "station/cabin4",
    disp = "Жилой модуль B3",
    dsc = [[Модуль почти не отличается от моего -- только кровать у другой стены, как и дверь в санузел. Если бы не стойкий запах лекарств и мутный снимок, прилепленный над кроватью, можно было бы подумать, что я оказался в зеркальной копии собственной каюты.]],
    onexit = function(s, t)
        if t.nam == "block_b1" then
            es.walkdlg {
                dlg = "mercel",
                branch = "exit",
                pic = "station/cabin4",
                disp = "Жилой модуль B3",
                owner = "mercel2"
            }
            return false
        end
    end,
    obj = {
        "photo",
        "mercel2",
        "box",
        "cupholder",
        "roomcomm",
        "pot",
        "potplate",
        "pot_cold",
        "pot_hot"
    },
    way = {
        path { "В жилой блок B", "block_b1" },
        path { "В санузел", "b3a_latrine" }
    }
}

es.obj {
    nam = "photo",
    done = false,
    dsc = "У {снимка} -- не слишком удачного, видимо, сделанного через иллюминатор пристыкованного к орбитальной верфи корабля -- замяты уголки, и сгиб протёрся так, что космический вид дробит попалам белая полоса, словно выеденная червями.",
    act = function(s)
        if s.done then
            return "Я так и не сохранил никаких фотографий своего первого корабля. Мне тогда это даже в голову не пришло."
        else
            s.done = true
            es.walkdlg {
                dlg = "mercel",
                branch = "photo",
                disp = "Жилой блок С3",
                pic = "station/cabin4",
                owner = "mercel2"
            }
            return true
        end
    end
}

-- region mercel2
es.obj {
    nam = "mercel2",
    visit = false,
    pills = false,
    water = false,
    points = 0,
    madness = 0,
    dsc = "{Мерцель} всё так же сидит у иллюминатора, загораживая костлявой спиной звёзды.",
    act = function(s)
        if not s.visit then
            s.visit = true
            es.walkdlg {
                dlg = "mercel",
                branch = "visit",
                disp = "Жилой блок С3",
                pic = "station/cabin4",
                owner = "mercel2"
            }
            return true
        elseif s.visit and not s.pills then
            es.walkdlg {
                dlg = "mercel",
                branch = "findpills",
                disp = "Жилой блок С3",
                pic = "station/cabin4",
                owner = "mercel2"
            }
            return true
        elseif s.visit and s.pills and not s.water then
            es.walkdlg {
                dlg = "mercel",
                branch = "givewater",
                disp = "Жилой блок С3",
                pic = "station/cabin4",
                owner = "mercel2"
            }
            return true
        else
            return "Мерцель смотрит сквозь меня остекленевшими глазами."
        end
    end,
    point = function(s)
        s.points = s.points + 1
    end,
    mad = function(s)
        s.madness = s.madness + 1
    end,
    used = function(s, w)
        if w.nam == "pills" and not s.visit then
            es.walkdlg("mercel.nopills")
            return true
        elseif w.nam == "pills" then
            purge("pills")
            s.pills = true
                es.walkdlg {
                    dlg = "mercel",
                    branch = "pills",
                    disp = "Жилой блок С3",
                    pic = "station/cabin4",
                    owner = "mercel2"
                }
            return true
        elseif w.nam == "cup" then
            if not s.pills and w.hot == 0 and w.cold == 0 then
                es.walkdlg("mercel.cup")
                return true
            elseif not s.pills then
                es.walkdlg("mercel.badwater")
                return true
            elseif (w.cold == 5 and w.hot == 1) or (w.cold == 4 and w.hot == 2) then
                purge("cup")
                s.water = true
                es.walkdlg {
                    dlg = "mercel",
                    branch = "afterpills",
                    disp = "Жилой блок С3",
                    pic = "station/cabin4",
                    owner = "mercel2"
                }
                return true
            elseif w.cold == 0 and w.hot == 0 then
                s:point()
                es.walkdlg("mercel.emptycup")
                return true
            elseif w.cold > w.hot then
                s:point()
                es.walkdlg("mercel.coldwater")
                return true
            else
                s:point()
                es.walkdlg("mercel.hotpot")
                return true
            end
        end
    end
}
-- endregion

es.obj {
    nam = "box",
    locked = true,
    hascup = true,
    dsc = function(s)
        if s.locked then
            return "У стены примостился {шкафчик}, в точной копии которого в своём модуле я не обнаружил ничего, кроме посуды."
        else
            return "Дверцы маленького {шкафчика} у стены приоткрыты."
        end
    end,
    act = function(s)
        if s.locked then
            s.locked = false
            return "Я открываю дверцы шкафчика."
        else
            s.locked = true
            return "Я закрываю шкафчик."
        end
    end,
    used = function(s, w)
        if w.nam == "cup" then
            if s.locked then
                return "Не получится положить кружку в закрытый шкаф."
            else
                purge("cup")
                all.box.hascup = true
                return "Я возвращаю кружку на место."
            end
        end
    end
}

es.obj {
    nam = "cupholder",
    cnd = es.eval("not {box}.locked and {box}.hascup"),
    dsc = "Внутри лежит на боку одинокая треснувшая {кружка}.",
    act = function(s)
        take("cup")
        all.box.hascup = false
        return "Я беру кружку."
    end
}

es.obj {
    nam = "cup",
    max = 6,
    cold = 0,
    hot = 0,
    disp = es.tool "Кружка",
    inv = function(s)
        if s.hot + s.cold == 0 then
            return "Обычная пустая кружка, ничего интересного. "
        else
            local app = ""
            if (s.cold == 2 and s.hot == 1) or (s.cold == 3 and s.hot == 2) then
                app = " Вода не горячая и не холодная."
            end
            return s.full[s.hot+s.cold]..app
        end
    end,
    full = {
        "Воды в кружке на самом донышке.",
        "Воды в кружке примерно на треть.",
        "Кружка уже наполовину полная.",
        "Кружка заполнена чуть больше, чем на половину.",
        "Кружка почти полная.",
        "Кружка заполнена до краёв."
    },
    fill = function(s, hot)
        if s.cold + s.hot == s.max then
            es.walkdlg {
                dlg = "mercel",
                branch = "water",
                disp = "Жилой блок С3",
                pic = "station/cabin4",
                owner = "mercel2"
            }
            return true
        elseif hot then
            s.hot = s.hot + 1
            return "Я добавляю в кружку немного горячей воды. "..s.full[s.hot+s.cold]
        else
            s.cold = s.cold + 1
            return "Я добавляю в кружку немного холодной воды. "..s.full[s.hot+s.cold]
        end
    end
}

es.obj {
    nam = "roomcomm",
    done = false,
    dsc = function(s)
        if not s.done then
            return "Трубка {интеркома} у двери в коридор снята с рычагов и сиротливо свисает на длинном проводе."
        else
            return "Бакелитовый корпус {интеркома} тихо поблёскивает в полумраке модуля. У меня возникает ощущение, что мы оба сидим здесь не потому, что хотим о чём-то поговорить, а просто ждём очень важного, решающего всю жизнь звонка."
        end
    end,
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("mercel.comm")
            return true
        else
            return "Звонить мне некому."
        end
    end
}

es.obj {
    nam = "pot",
    cup = false,
    dsc = "^На столике в глу стоит потрёпанный, прослуживший не один год {диспенсер} для воды.",
    act = "Такой же есть и у меня в модуле -- он подключён к проточной воде.",
    used = function(s, w)
        if w.nam == "cup" then
            s.cup = true
            purge("cup")
            return "Я ставлю кружку в диспенсер."
        end
    end
}

es.obj {
    nam = "potplate",
    cnd = es.eval("{pot}.cup"),
    dsc = "^^В диспенсер вставлена {кружка}.",
    act = function(s)
        all.pot.cup = false
        take("cup")
        return "Я убираю кружку из диспенсера."
    end
}

es.obj {
    nam = "pot_cold",
    cnd = es.eval("{pot}.cup"),
    dsc = "Здесь есть кнопка для {холодной} и",
    act = function(s)
        return all.cup:fill(false)
    end
}

es.obj {
    nam = "pot_hot",
    cnd = es.eval("{pot}.cup"),
    dsc = "{горячей} воды.",
    act = function(s)
        return all.cup:fill(true)
    end
}
-- endregion

-- region b3a_latrine
es.room {
    nam = "b3a_latrine",
    pic = "station/toilet1",
    disp = "Санузел",
    dsc = [[Лампа в саунзеле мерцает и раздражающе трещит. Интересно, почему Мерцель не сообщила, чтобы ей заменили лампу?]],
    obj = { "medbox", "sink", "sinkholder", "pills" },
    way = {
        path { "Выйти", "b3a" }
    }
}

es.obj {
    nam = "medbox",
    dsc = "На стене -- привычная до боли в глазах {аптечка}, выкрашенная в больничный белый цвет.",
    act = "Аптечка -- пуста. Внутри валяется лишь несколько разорванных блистеров."
}

es.obj {
    nam = "sink",
    dsc = "На {раковину} синхронно с мерцанием лампы падает угловатая тень.",
    act = "Обычная раковина, ничего интересного.",
    used = function(s, w)
        if w.nam == "cup" and (w.cold > 0 or w.hot > 0) then
            if not all.pills.taken then
                return "В раковине что-то лежит."
            else
                w.cold = 0
                w.hot = 0
                return "Я сливаю воду из чашки."
            end
        elseif w.nam == "cup" then
            return "Чашка и так пуста."
        elseif w.nam == "pills" then
            return "Зачем мне выбрасывать таблетку в раковину?"
        end
    end
}

es.obj {
    nam = "sinkholder",
    cnd = "{pills}.hidden",
    dsc = "У стока {что-то} лежит.",
    act = function(s)
        all.pills.hidden = false
        return "Я приглядываюсь и вижу таблетку в синей облатке."
    end
}

es.obj {
    nam = "pills",
    disp = es.tool "Таблетка",
    hidden = true,
    taken = false,
    dsc = function(s)
        if not s.hidden then
            return "У стока лежит {таблетка} в синей облатке."
        end
    end,
    tak = function(s)
        s.taken = true
        return "Я беру таблетку из раковины."
    end,
    inv = "Обычное обезболивающее вроде того, что совсем не помогало мне."
}
-- endregion

-- region usecomm
es.room {
    nam = "usecomm",
    noinv = true,
    pic = "station/cabin4",
    disp = "Жилой модуль B3",
    dsc = [[Я подхожу к интеркому, беру трубку и почему-то начинаю набирать номер жилого модуля, в котором нахожусь.
    ^Мысли путаются. Куда я вообще хотел позвонить?
    ^В свой модуль? Но какой в этом смысл, там же никого нет? В лаборатории? Нет. В медчасть. Да, я должен позвонить в медчасть, Мерцель явно не в себе, ей требуется помощь.]],
    enter = function(s)
        es.music("premonition")
    end,
    next = function(s)
        if all.mercel2.points >= 6 then
            es.walkdlg("mercel.rage")
        else
            es.walkdlg("mercel.tired_call")
        end
    end
}
-- endregion

-- region golab
es.room {
    nam = "golab",
    noinv = true,
    pic = "station/cabin4",
    disp = "Жилой модуль B3",
    dsc = [[Я подхожу к двери и думаю, что надо было сразу идти в лабораторию. Там бы перестала болеть голова, там бы нам куда проще было бы поговорить.
    ^Но Мерцель почему-то не торопится. Возможно, до закрытия лаборатории остаются считанные секунды.]],
    enter = function(s)
        es.music("premonition")
    end,
    next = function(s)
        if all.mercel2.points >= 6 then
            es.walkdlg("mercel.rage")
        else
            es.walkdlg("mercel.tired_lab")
        end
    end
}
-- endregion

-- region death1
es.room {
    nam = "death_intro1",
    pause = 40,
    enter = function(s)
        es.stopMusic(300)
    end,
    next = "death1"
}

es.room {
    nam = "death1",
    noinv = true,
    pic = "station/cabin4",
    disp = "Жилой модуль B3",
    dsc = [[Всё перед глазами затягивает кровавая пелена. Я бросаюсь на Мерцель, как полоумный -- и тут же с головой падаю в чёрный водоворот.
    ^Я прихожу в себя в луже крови. Мерцель смотрит остекленевшими глазами в потолок. Шея её изорвана, точно клыками животного. В руке моей зажат окровавленный осколок кружки.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "Последняя точка сохранения",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region interlude5
es.room {
    nam = "interlude5",
    noinv = true,
    pic = "station/block_b",
    disp = "Жилой блок B",
    dsc = [[Я выхожу из модуля, и мне вдруг становится страшно -- казалось, ещё секунду назад голова кружилась от сотен мыслей, планов, задуманных дел, но теперь я с трудом понимаю, где нахожусь и что собираюсь делать.
    ^Надо вернуться к Мерцель, убедить её сходить в медблок. Зачем я вообще ушёл? С ней же что-то не так. Впрочем, как и со всеми нами.
    ^Я просто хочу вернуться к себе и свалиться в кровать, выспаться впервые за множество дней.
    ^Можно позвонить по интеркому, в коридоре должен быть интерком.
    ^Но у меня нет сил...]],
    enter = function(s)
        es.music("bass", 2, 0, 3000)
    end,
    next = function(s)
        snapshots:make()
        walkin("block_b2")
    end
}
-- endregion

-- region block_b2
es.room {
    nam = "block_b2",
    pic = "station/block_b",
    disp = "Жилой блок B",
    dsc = [[Я стою, привалившись плечом к стене, рядом с дверью в третий жилой модуль и не понимаю, что должен делать.]],
    onexit = function(s, t)
        if t.nam == "b3a" then
            p "Я стучу в дверь, но никто не открывает. Может, Мерцель спит?"
            return false
        end
    end,
    obj = { "b3_comm" },
    way = {
        path { "В жилой модуль B3", "b3a" },
        path { "#ablock", "В жилой блок A", "pause2" }:disable(),
        path { "В жилой блок C", "death_intro2" }
    }
}

es.obj {
    nam = "b3_comm",
    dsc = "На противоположной стене, которая кажется такой далёкой из-за чёрной прогалины на полу, висит {интерком}.",
    act = function(s)
        enable "#ablock"
        return "Я поднимаю трубку интеркома, нажимая несколько кнопок и тут же дёргаю за рычаги. Кому я собирался звонить? Может, Вере? Она утром говорила такие странные вещи. Но зачем ей звонить? Ведь её жилой модуль рядом."
    end
}
-- endregion

-- region death_intro2
es.room {
    nam = "death_intro2",
    noinv = true,
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Я пробираюсь сквозь полумрак коридоров, точно сквозь плотный туман. Свет за спиной гаснет, я стараюсь идти быстрее.]],
    enter = function(s)
        es.music("premonition")
    end,
    next = "death_block"
}

es.room {
    nam = "death_block",
    pic = "station/block_c",
    disp = "Жилой блок C",
    dsc = [[Наконец я оказываюсь у двери в свой модуль, я добрался! Меня ждёт сон.]],
    obj = { "death_door", "search_card" }
}

es.obj {
    nam = "death_door",
    unlocked = false,
    dsc = function(s)
        if all.search_card.hidden and s.unlocked then
            return "Теперь {дверь} в мой модуль открыта."
        elseif all.search_card.hidden and not s.unlocked then
            return "{Дверь} в мой модуль закрыта."
        else
            return "{Дверь} закрыта, а я почему-то никак не могу найти свою ключ-карту. Не мог же я её обронить?"
        end
    end,
    act = function(s)
        if s.unlocked then
            walkin("death2")
        else
            return "Дверь закрыта, нужна карта."
        end
    end,
    used = function(s, w)
        if w.nam == "fake_card" and not w.done then
            w.done = true
            drop("fake_card")
            return [[Дверь не открывается. Раздаётся сердитый гудок, лампа над над замком мигает.
            ^Я приглядываюсь к карте в руке и вдруг понимаю, что это воовбще не магнитный ключ, это клочок бумаги, на котором кровью написано:
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ ОНИУМЕНЯВГОЛОВЕ
            ^Я вздрагиваю и роняю карту на пол.]]
        elseif w.nam == "fake_card" then
            s.unlocked = true
            purge("fake_card")
            return "Наконец-то! Карта сработала, дверь открылась!"
        end
    end
}

es.obj {
    nam = "search_card",
    hidden = false,
    cnd = "not s.hidden",
    dsc = "Я продолжаю {ощупывать} карманы.",
    act = function(s)
        s.hidden = true
        take("fake_card")
        return "Наконец я нахожу карту в кармане. Как хорошо, что не придётся возвращаться в темноту и искать её."
    end
}

es.obj {
    nam = "fake_card",
    done = false,
    disp = es.tool "Ключ-карта",
    dsc = "На полу валяется моя {ключ-карта}.",
    tak = "Я поднимаю карту.",
    inv = function(s)
        drop("fake_card")
        return "Руки трясутся, карточка выскальзывает из пальцев и проваливается в темноту под ногами."
    end
}
-- endregion

-- region death2
es.room {
    nam = "death2",
    pic = "common/report",
    noinv = true,
    dsc = [[Отчёт Елены Викторны Ефимовой, главного врача НИОС "Кабирия"
    ^День 3871, 16:22 у.в.
    ^^Вереснев Олег Викторович, техник ГМК "Грозный", 26 полных лет, был обнаружен сегодня мёртвым в своей каюте. Причина смерти -- кровоизлияние в мозг. Предрасположенностей для кровоизлияния не имел. Проводится детальный химический анализ крови.]], 
    enter = function(s)
        es.music("death")
    end,
    next_disp = "Последняя точка сохранения",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    pause = 40,
    next = "block_a1"
}
-- endregion

-- region block_a1
es.room {
    nam = "block_a1",
    pic = "station/block_a",
    disp = "Жилой блок A",
    dsc = [[Я стою перед вторым модулем в блоке А. Здесь живёт Вера. Я даже не помню, как дошёл сюда, но внезапно понимаю, что сделал всё правильно, что я именно там, где и должен быть. Но откроет ли она мне?]],
    obj = { "a2_ring" },
    way = {
        path { "К другим жилым модулям", "death_intro2" }
    }
}

es.obj {
    nam = "a2_ring",
    dsc = "{Кнопка} звонка у двери на сей раз не сломана.",
    act = function(s)
        es.walkdlg {
            dlg = "vera",
            branch = "visit",
            pic = "station/cabin3",
            disp = "Жилой модуль A2"
        }
        return true
    end
}
-- endregion

-- region a2
es.room {
    nam = "a2",
    mus = false,
    pic = "station/cabin3",
    disp = "Жилой модуль A2",
    dsc = function(s)
        local app = "Мы стоим посреди модуля. "
        if all.vera3.hug then
            app = ""
        end
        return app.."Кажется, что внутри меня поднимается какая-то волна, кровь вскипает в жилах -- я тону в омуте безумия, и огромными усилиями удерживаюсь на поверхности, как утопающий, которого подводные течения утаскивают в глубину."
    end,
    onexit = function(s,t)
        if t.nam == "a2_latrine" and not all.vera3.hug then
            all.vera3.hug = true
            es.walkdlg("vera.hug")
            return false
        elseif t.nam == "main" and all.vera3.sleep then
            es.walkdlg("vera.leave")
            return false
        elseif t.nam == "main" then
            es.walkdlg("vera.runaway")
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("overcome", 2, 0, 3000)
        end
    end,
    obj = {
        "vera3",
        "wound",
        "wound2",
        "splinters",
        "veracomm",
        "porthole3" 
    },
    way = {
        path { "Выйти", "main" },
        path { "В санузел", "a2_latrine" }
    }
}

es.obj {
    nam = "vera3",
    comm = false,
    decide = false,
    hug = false,
    sleep = false,
    dsc = function(s)
        if s.sleep then
            return "{Вера} спит на кровати, уткнувшись лицом в подушку."
        elseif s.hug then
            return "{Вера} сидит на кровати, обречённо повесив голову."
        else
            return "{Вера} прижимается ко мне и дрожит, как от озноба."
        end
    end,
    act = function(s)
        if s.sleep then
            return "Лучше её не трогать, пусть спит."
        elseif s.decide then
            es.walkdlg("vera.decide2")
            return true
        else
            es.walkdlg("vera.decide1")
            return true
        end
    end,
    used = function(s, w)
        local cure = w.nam == "bandage" or w.nam == "bandage_piece"
            or w.nam == "wool" or w.nam == "wool_piece" or w.nam == "bottle"
        if cure and not all.wound2.treat then
            return "Надо обработать рану Веры."
        elseif cure and all.wound2.trest then
            return "Я уже обработал порез."
        end
    end
}

es.obj {
    nam = "wound",
    done = false,
    cnd = "not {vera3}.hug",
    dsc = "{Кровь} из раны заливает ей шею.",
    act = function(s)
        s.done = true
        return "Надо обязательно обработать рану."
    end
}

es.obj {
    nam = "wound2",
    treat = false,
    cnd = "{vera3}.hug and not {vera3}.sleep",
    dsc = "Теперь {порез} на её щеке кажется ещё больше.",
    act = function(s)
        if not s.treat then
            return "Порез надо сначала обработать, а потом заклеить бинтом."
        else
            return "Я уже обработал порез, теперь можно заклеить его бинтом."
        end
    end,
    used = function(s, w)
        if w.nam == "bottle" then
            return "Не буду же я поливать открытую рану фурацилином из бутылки."
        elseif w.nam == "wool" then
            return "Вату надо сначала достать из упаковки."
        elseif w.nam == "wool_piece" and not w.moist then
            return "Вата -- сухая. Что я собираюсь делать?"
        elseif w.nam == "bandage" then
            return "Я собираюсь делать с целой упаковкой бинтов?"
        elseif w.nam == "bandage_piece" and not s.treat then
            return "Рану надо сначала обработать."
        elseif w.nam == "wool_piece" and w.moist and not s.treat then
            s.treat = true
            purge("wool_piece")
            es.walkdlg("vera.treat")
            return true
        elseif w.nam == "wool_piece" and w.moist and s.treat then
            return "Я уже обработал рану."
        elseif w.nam == "bandage_piece" and s.treat then
            all.vera3.sleep = true
            es.walkdlg("vera.sleep")
            return true
        end
    end
}

es.obj {
    nam = "splinters",
    dsc = "На полу валяются {осколки} зеркала.",
    act = function(s)
        if all.vera3.sleep then
            return "Сейчас не до сих, осколки можно убрать потом."
        else
            es.walkdlg("vera.glass")
            return true
        end
    end
}

es.obj {
    nam = "veracomm",
    dsc = "Трубка {интеркома} слетела с рычагов. Наверное, Вера тоже хотела кому-то позвонить, но не смогла набрать номер так же, как и я.",
    act = function(s)
        if all.vera3.sleep then
            es.stopMusic(3000)
            es.walkdlg("comm.head")
            return true
        elseif all.vera3.hug then
            es.walkdlg("vera.comm3")
            return true
        elseif all.vera3.comm then
            es.walkdlg("vera.comm2")
            return true
        else
            es.walkdlg("vera.comm1")
            return true
        end
    end
}

es.obj {
    nam = "porthole3",
    locked = false,
    dsc = function(s)
        if s.locked then
            return "{Иллюминатор} закрыт."
        else
            return "{Иллюминатор} открыт, но в него как обычна видно лишь темноту, в которой тонут редкие слабые звёзды."
        end
    end,
    act = function(s)
        if all.vera3.hug and s.locked then
            s.locked = false
            return "По какой-то причине я опять открываю иллюминатор."
        elseif all.vera3.hug and not s.locked then
            s.locked = true
            return "Я закрываю иллюминатор, клацнув кнопкой на стене, но мне не становится спокойнее."
        else
            return "Кажется, что вид на эту безраздельную тьму и сводит нас с ума."
        end
    end
}
-- endregion

-- region a2_latrine
es.room {
    nam = "a2_latrine",
    pic = "station/toilet2",
    disp = "Санузел",
    dsc = [[Под ногами хрустят осколки. Вера разнесла их по всему модулю. С какой же яростью надо было уничтожать единственное в модуле зеркало!]],
    obj = {
        "mirror",
        "medbox2",
        "medbox_holder",
        "bottle_holder",
        "wool_holder",
        "bandage_holder"
    },
    way = {
        path { "Выйти", "a2" }
    }
}

es.obj {
    nam = "mirror",
    dsc = "Теперь вместо него -- {разбитая панель}, из которой торчат блестящие зеркальные заусенцы.",
    act = "Я даже рад, что не могу видеть своего отражения."
}

es.obj {
    nam = "medbox2",
    locked = true,
    dsc = "Но всё, что мне здесь нужно -- это {аптечка} на стене.",
    act = function(s)
        if s.locked then
            s.locked = false
            return "Я открываю дверцу аптечки."
        else
            s.locked = true
            return "Я закрываю аптечку."
        end
    end,
    used = function(s, w)
        if s.locked then
            return "Нельзя положить что-то в закрытую аптечку."
        elseif w.nam == "bottle" then
            purge("bottle")
            all.bottle_holder.taken = false
            return "Я кладу фурацилин обратно в аптечку."
        elseif w.nam == "wool" then
            purge("wool")
            all.wool_holder.taken = false
            return "Я кладу бинт обратно в аптечку."
        elseif w.nam == "bandage" then
            purge("bandage")
            all.bandage_holder.taken = false
            return "Я кладу бинт обратно в аптечку."
        end
    end
}

es.obj {
    nam = "medbox_holder",
    cnd = "not {medbox2}.locked",
    dsc = function(s)
        if not all.wool_holder.taken or not all.bandage_holder.taken
            or not all.bottle_holder.taken then
            return "Внутри --"
        else
            return "В аптечке ничего нет."
        end
    end
}

es.obj {
    nam = "bottle_holder",
    taken = false,
    cnd = "not {medbox2}.locked and not s.taken",
    dsc = function(s)
        if all.wool_holder.taken and all.bandage_holder.taken then
            return "{флакон с фурацилином}."
        elseif all.bandage_holder.taken or all.wool_holder.taken then
            return "{флакон с фурацилином}"
        else
            return "{флакон с фурацилином},"
        end
    end,
    act = function(s)
        s.taken = true
        take("bottle")
        return "Я беру из аптечки флакон с фурацилином."
    end
}

es.obj {
    nam = "wool_holder",
    taken = false,
    cnd = "not {medbox2}.locked and not s.taken",
    dsc = function(s)
        if all.bottle_holder.taken and all.bandage_holder.taken then
            return "{упаковка ваты}."
        elseif all.bandage_holder.taken then
            return "и {упаковка ваты}."
        else
            return "{упаковка ваты}"
        end
    end,
    act = function(s)
        s.taken = true
        take("wool")
        return "Я беру из аптечки упаковку ваты."
    end
}

es.obj {
    nam = "bandage_holder",
    taken = false,
    cnd = "not {medbox2}.locked and not s.taken",
    dsc = function(s)
        if all.bottle_holder.taken and all.wool_holder.taken then
            return "{самоклеющийся бинт}."
        else
            return "и {самоклеющийся бинт}."
        end
    end,
    act = function(s)
        s.taken = true
        take("bandage")
        return "Я беру из аптечки самоклеющийся бинт."
    end
}

es.obj {
    nam = "bottle",
    disp = es.tool "Бутылка с фурацилином",
    inv = "Фурацилионом надо обработать рану.",
    used = function(s, w)
        if w.nam == "wool" then
            return "Надо сначала достать кусочек ваты из упаковки."
        elseif w.nam == "wool_piece" and w.moist then
            return "Я уже смочил кусочек ваты фурацилином."
        elseif w.nam == "wool_piece" and not w.moist then
            w.moist = true
            return "Я смочил ватку фурацилином."
        end
    end
}

es.obj {
    nam = "wool",
    disp = es.tool "Упаковка ваты",
    inv = function(s)
        if have("wool_piece") then
            return "Мне хватит и одного куска ваты."
        else
            take("wool_piece")
            return "Я достаю кусочек ваты из упаковки."
        end
    end,
    used = function(s, w)
        if w.nam == "bottle" then
            return "Надо сначала достать кусочек ваты из упаковки."
        end
    end
}

es.obj {
    nam = "wool_piece",
    moist = false,
    disp = function(s)
        if not s.moist then
            return es.tool("Кусок ваты")
        else
            return es.tool("Вата с фурацилином")
        end
    end,
    inv = function(s)
        if s.moist then
            return "Кусок ваты, смоченный фурацилином."
        else
            return "Сухой кусок ваты."
        end
    end,
    used = function(s, w)
        if w.nam == "bottle" and s.moist then
            return "Я уже смочил кусочек ваты фурацилином."
        elseif w.nam == "bottle" and not s.moist then
            s.moist = true
            return "Я смочил ватку фурацилином."
        end
    end
}

es.obj {
    nam = "bandage",
    disp = es.tool "Упаковка бинтов",
    inv = function(s)
        if have("bandage_piece") then
            return "Мне хватит и одного бинта."
        else
            take("bandage_piece")
            return "Я достал самоклеющийся бинт из упаковки."
        end
    end
}

es.obj {
    nam = "bandage_piece",
    disp = es.tool "Самоклеющийся бинт",
    inv = "Бинтом можно заклеить рану -- но только после обработки."
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    enter = function(s)
        es.music("note")
    end,
    dsc = [[-- Давно таких деньков не было!
    ^...
    ^-- Я схожу искупнусь, ты только не скучай!
    ^...
    ^-- Я быстро, не волнуйся.]],
    next = function(s)
        gamefile("game/10.lua", true)
    end
}
-- endregion