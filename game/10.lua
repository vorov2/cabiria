-- Chapter 10
dofile "lib/es.lua"

es.main {
    chapter = "10",
    onenter = function(s)
        es.loopMusic("santorum", 3000)
        walkin("lake1")
    end
}

-- region lake1
es.room {
    nam = "lake1",
    pic = "dream/lake1",
    disp = "Озеро",
    dsc = [[Я сам не понимаю, как заплыл так далеко. Стемнело быстро, словно день поставили на ускоренную перемотку, и берег теперь едва виден в густеющей темноте.]],
    obj = { "swim1", "await" },
    way = {
        path { "#swim1", "К берегу", "lake2" }:disable()
    }
}

es.obj {
    nam = "swim1",
    try = false,
    done = false,
    dsc = "Надо {плыть} обратно.",
    act = function(s)
        if not s.try then
            s.try = true
            return "Удивительно, что с сумерками ожили подводные течения. Можно подумать, что в недрах озера поднялся настоящий ураган. Я пытаюсь плыть по самому короткому пути -- и не могу, что-то отталкивает меня, не пускает к берегу."
        elseif s.try and not s.done then
            s.done = true
            enable "#swim1"
            return "Со второй попытки я умудряюсь увернуться от подводного потока и начинаю мощными резкими бросками плыть к берегу. Надо поторопиться. Скоро, я уверен, станет совсем темно."
        else
            return "Мне стоит поторопиться, скоро станет совсем темно."
        end
    end
}

es.obj {
    nam = "await",
    dsc = "Меня {ждут} и наверняка волнуются.",
    act = "Но кто меня ждёт? С кем я пришёл на пряж? Я пытаюсь вспомнить -- и не могу. Наверняка это из-за преждевременных сумерек -- они всегда способствуют лёгкой забывчивости."
}
-- endregion

-- region lake2
es.room {
    nam = "lake2",
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Я вымотался из сил, мышцы едва не сводит судорогой, однако берег не стал ближе. Напротив, берег как будто постоянно удаляется от меня. Я ложусь ненадолго на спину, чтобы отдохнуть, восстановить дыхание.]],
    obj = { "moon1", "foam", "swim2" },
    way = {
        path { "#swim2", "К берегу", "lake3" }:disable()
    }
}

es.obj {
    nam = "moon1",
    dsc = "Огромная синяя {Луна} такая яркая, что слепит, как солнце в полдень, однако свет её вовсе не расходится волнами по небу. Напротив, вокруг меня собирается темнота.",
    act = "Я и не помню, чтобы здесь по начам была такая Луна!"
}

es.obj {
    nam = "foam",
    dsc = "{Вода} здесь необычно пенится.",
    act = "Не представляю, что это может означать. Надо запомнить, что лучше не плавать в этом озере в сумерки."
}

es.obj {
    nam = "swim2",
    done = false,
    dsc = "Надо выбрать, в какую сторону {плыть}, чтобы вновь не сражаться с течением.",
    act = function(s)
        if not s.done then
            s.done = true
            enable "#swim2"
            return "Кажется, если плыть вдоль берега, туда, где игриво плещутся на волнах блики от синей Луны, то течение почти не чувствуется. Придётся плыть дольше, но я хотя бы не буду так выбиваться из сил. Правда, вода там вся затянута пеной."
        else
            return "Я уже достаточно отдохнул."
        end
    end
}
-- endregion

-- region lake3
es.room {
    nam = "lake3",
    pic = "dream/lake1",
    disp = "Озеро",
    dsc = [[Я заплываю в пенящиеся волны, и что-то мигом утаскивает меня под воду, в кромешную темноту. Я пытаюсь выплыть, сражаясь с жуткой стихией, тянущей меня на дно. У меня ничего не получается. Я делаю последний рывок, на который трачу все оставшиеся силы, и всё умудряюсь подняться над поверхностью.]],
    enter = function(s)
        es.music("nightmare", 10, 3000, 3000)
    end,
    obj = { "rest" },
    way = {
        path { "#swim3", "К берегу", "lake4" }:disable()
    }
}

es.obj {
    nam = "rest",
    done = false,
    dsc = "Мне снова приходится {отдыхать}.",
    act = function(s)
        if not s.done then
            s.done = true
            enable "#swim3"
            return "Я ложусь на спину и щуруюсь от света синей Луны. Теперь я понимаю, что стоит избегать тех мест, где кружится пена. Видимо, там, глубоко под поверхностью, образовались омуты, которые вмиг утянут к смерти неопытного пловца. Днём они, наверное, боятся солнечного света."
        else
            return "Нужно плыть дальше."
        end
    end
}
-- endregion

-- region lake4
es.room {
    nam = "lake4",
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Берег всё ещё пугающе далеко. Но я должен постараться. Я же точно знаю, что меня ждут. Надо только понять, в какую сторону плыть.]],
    obj = { "ahead1", "left1", "right1" },
    way = {
        path { "Левее", "lake5" },
        path { "Прямо к берегу", "death_intro1" },
        path { "Правее", "death_intro1" }
    }
}

es.obj {
    nam = "ahead1",
    dsc = "Вариантов немного -- {плыть напролом}, по самому короткому пути,",
    act = "Так будет, конечно, быстрее, но всё впереди затянуто пеной."
}

es.obj {
    nam = "left1",
    dsc = "забрать {чуть левее}, где чувствуются подводные потоки, но я, возможно, смогу их пересилить",
    act = "Следов водоворотов я в этом направлении не вижу."
}

es.obj {
    nam = "right1",
    dsc = "или {повернуть направо}, выбрать самый длинный заплыв сквозь темноту, где однако нет никакого сопротивления.",
    act = "Кажется, вода в этом направлении тоже немного пенится, но, возможно, пену занёс поднявшийся ветер. Почему-то не рискнуть?"
}
-- endregion

-- region lake5
es.room {
    nam = "lake5",
    pic = "dream/lake1",
    disp = "Озеро",
    dsc = [[Я уже сомневаюсь, что смогу выплыть. Силы стремительно кончаются, а чёрная вода не отпускает меня. Берег же теперь и вовсе кажется миражом, который отдаляется от меня с каждым взмахом рук.]],
    obj = { "ahead2", "left2", "right2" },
    way = {
        path { "Левее", "lake_rnd" },
        path { "Прямо к берегу", "lake6" },
        path { "Правее", "lake_rnd" }
    }
}

es.obj {
    nam = "ahead2",
    dsc = "Мне опять надо выбирать -- плыть {прямо},",
    act = "Я приглядываюсь, и мне кажется, что я замечаю тусклый огонёк, который зовёт меня сберега, подсказывает мне правильный путь. А ещё я вижу пену, которая бурлит прямо передо мной."
}

es.obj {
    nam = "left2",
    dsc = "свернуть {левее} или",
    act = "Следов водоворотов я в этом направлении не вижу."
}

es.obj {
    nam = "right2",
    dsc = "{правее}.",
    act = "Вода в этой стороне чистая и даже течения я не чувствую."
}

es.obj {
    nam = "moon2",
    dsc = "А можно просто {лечь на воду} и любоваться Луной.",
    act = "Я не должен сдаваться. У меня ещё есть шанс. Главное выбрать, куда плыть."
}
-- endregion

-- region lake_rnd
es.room {
    nam = "lake_rnd",
    swim = 1,
    pic = "dream/lake.deep2",
    disp = "Озеро",
    alldsc = {
        "Я всё же не выдерживаю и ненадолго ложусь звездой, чтобы собраться с силами, закрываю глаза и чувствую, как медленно ухожу под воду. Нет! Мне надо плыть!",
        "Вокруг меня на поднявшихся из-за ветра волнах играют яркие отблески Луны.",
        "Кажется, берег так далеко, что скоро и вовсе исчезнет из вида. Может, зря я сражаюсь с этими течениями? Может, они хотят помочь мне, вернуться меня на сушу?",
        "Я обязательно должен выплыть, я же -- отличный пловец. К тому же меня ждут. Меня точно ждут. Она наверняка уже волнуется.",
        "Такое ощущение, что плаваю здесь несколько дней подряд.",
        "Становится совсем темно, как глубокой ночью, усиливается ветер, обдавая меня брызнами и пеной. Меня начинает трясти от холода."
    },
    dsc = function(s)
        local idx,max = s.swim,#s.alldsc
        if idx > max then
            idx = idx % max
        end
        return s.alldsc[idx]
    end,
    onenter = function(s)
        s.swim = s.swim + 1
    end,
    enter = function(s)
        disable "#rnd1"
        disable "#rnd2"
        disable "#rnd3"
        disable "#rnd4"
    end,
    obj = { "destination", "goback" },
    way = {
        path { "#rnd1", "К лунным бликам", "lake_rnd" }:disable(),
        path { "#rnd2", "В темноту", "lake_rnd" }:disable(),
        path { "#rnd3", "К берегу", "lake_rnd" }:disable(),
        path { "#rnd4", "Плыть назад", "lake_rnd_hub" }:disable()
    }

}

es.obj {
    nam = "destination",
    dsc = "Надо {выбрать}, куда плыть.",
    alldsc = {
        "Луна услужливо подсвечивает мне путь -- там, где играют её блики, нет ни пены, ни сильных течений.",
        "Мне придётся нырнуть в темноту. Хотя навстречу и идёт сильное течение, это -- единственный выход отсюда.",
        "Кажется, я могу немного приблизиться к берегу. Но надо быть осторожным и не попасть в водоворот."
    },
    act = function(s)
        local w = rnd(3)
        if w == 1 then
            enable "#rnd1"
        elseif w == 2 then
            enable "#rnd2"
        elseif w == 3 then
            enable "#rnd3"
        end
        return s.alldsc[w]
    end
}

es.obj {
    nam = "goback",
    dsc = "Или, может, стоит {повернуть назад}.",
    act = function(s)
        enable "#rnd4"
        return "Я не уверен, что смогу вернуться, но можно попробовать."
    end
}

es.room {
    nam = "lake_rnd_hub",
    enter = function(s)
        if all.lake_rnd.swim > #all.lake_rnd.alldsc then
            walkin("death_intro2")
        else
            walkin("lake5")
        end
    end
}
-- endregion

-- region lake6
es.room {
    nam = "lake6",
    pic = "dream/lake2",
    disp = "Озеро",
    dsc = [[Я начинаю плыть вперёд, и спасительный свет становится ярче. Он как будто придаёт мне сил.
    ^И тут же течение утягивает меня в темноту.
    ^Я пытаюсь вырваться из его объятий, которые с невероятной силой толкают меня на дно, но воздуха в лёгких не хватает.]],
    next_disp = "Пытаться выплыть",
    next = function(s)
        es.music("horn")
        walkin("wakeup1")
    end
}
-- endregion

-- region death_intro1
es.room {
    nam = "death_intro1",
    noinv = true,
    pic = "dream/lake.deep3",
    disp = "Озеро",
    dsc = [[Я не успеваю сделать и несколько взмахов руками, как меня утаскивает под воду, в бурлящую темноту. Я пытаюсь вырваться из ледяных объятий мрака, но не могу. Мышцы сводит судорогой, и я сдаюсь стихии.]],
    next = "death1"
}
-- endregion

-- region death_intro2
es.room {
    nam = "death_intro2",
    noinv = true,
    pic = "dream/lake.deep3",
    disp = "Озеро",
    dsc = [[Я не могу больше плыть, не могу сопротивляться этому настойчивому потоку, который тянет меня всё дальше от берега, затаскивает в темноту. Я пытаюсь лечь на воду, чтобы восстановить силы, но вместо этого медленно ухожу под воду.]],
    next = "death1"
}
-- endregion

-- region death1
es.room {
    nam = "death1",
    noinv = true,
    pic = "common/report",
    dsc = [[Отчёт Елены Викторны Ефимовой, главного врача НИОС "Кабирия"
    ^День 3872, 04:13 у.в.
    ^^Вереснев Олег Викторович, техник ГМК "Грозный", 26 полных лет, умер во время промывания крови в медблоке станции. Точные причины смерти устанавливаются.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "Последняя точка сохранения",
    next = function(s)
        gamefile("game/10.lua", true)
    end
}
-- endregion

-- region wakeup1
es.room {
    nam = "wakeup1",
    pic = "station/medceil",
    disp = "Неизвестное место",
    dsc = [[С резким хрипом, как утопающий, я выныриваю из сна. Лёгкие раздирает от боли. В глаза тут же бьёт пронизывающий свет. Я прикрываюсь ладонью и тут же падаю на какую-то твёрдую поверхность, ударившись бедром.
    ^Руку тут же пробивает яростным разрядом боли -- кажется, что на предплечье лопается кожа, и из него вытягивают все жилы.
    ^Спустя пару секунд я наконец прихожу в себя и понимаю, что лежу на полу рядом с койкой, а из моей руки торчит толстая трубка катетера.]],
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        es.music("descend")
        walkin("intro1")
    end
}
-- endregion

-- region intro1
es.room {
    nam = "intro1",
    seconds = 13,
    pic = "common/station",
    enter = function(s)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds + 1
        if s.seconds == 17 then
            timer:stop()
            walkin("med1")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    txt = "НИОС \"Кабирия\"^День шестой^^",
    dsc = function(s)
        return string.format("%s07:21:%d", s.txt, all.intro1.seconds)
    end
}
-- endregion

-- region med1
es.room {
    nam = "med1",
    mus = false,
    pic = "station/med1",
    disp = "Отсек",
    dsc = [[Я нахожусь в небольшом отсеке с привинченной к полу койкой у стены. С потолка на меня взирает сферический глазок камеры.]],
    preact = function(s)
        if not s.mus then
            s.mus = true
            es.music("doom", 3, 0, 6000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            if not all.catheter.done then
                p "Для начала нужно избавиться от катетера. С ним я как будто привязан к этой койке."
                return false
            else
                p "Дверь закрыта."
                return false
            end
        end
    end,
    obj = {
        "robe",
        "door1",
        "panel1",
        "smell1",
        "catheter",
        "patch",
        "putty"
    },
    way = {
        path { "Выйти", "main" }
    }
}

es.obj {
    nam = "robe",
    dsc = "Холодно. На мне -- лёгкий медицинский {халат}, надетый на голое тело.",
    act = "Я совсем не помню, как здесь оказался, кто меня переодел."
}

es.obj {
    nam = "door1",
    dsc = "Единственная {дверь} -- глухая, как в тюремной камере. И наверняка усиленная.",
    act = function(s)
        if all.catheter.done then
            return "Дверь, разумеется, заперта. Может, я и правда в тюрьме? В голове -- сплошная мешанина из кошмарных снов и воспоминаний. Надеюсь, я никому не навредил."
        else
            return "Надо сначала избавиться от катетера. Хотя я не сомневаюсь в том, что дверь заперта."
        end
    end,
    used = function(s, w)
        if not all.catheter.done then
            return "Я ничего не могу сделать, пока не снял катетер."
        elseif w.nam == "putty" then
            return "Это даже не смешно."
        end
    end
}

es.obj {
    nam = "panel1",
    dsc = "Рядом с дверным проёмом есть небольшой, едва заметный {лючок}, который словно специально пытались спрятать от глаз.",
    act = function(s)
        if not all.catheter.done then
            return "Я ничего не могу сделать, пока не снял катетер."
        else
            return "Руками открыть лючок не получится. По идее здесь нужен стандартный сервисный ключ, но, возможно, получится обойтись и без него."
        end
    end,
    used = function(s, w)
        if not all.catheter.done then
            return "У меня пока что есть другие заботы."
        elseif w.nam == "putty" then
            purge("putty")
            es.stopMusic(4000)
            es.walkdlg("minaeva.head")
            return true
        end
    end
}

es.obj {
    nam = "smell1",
    dsc = "Воздух насквозь пропитан обжигающей лёгкие {химией}, как будто здесь травили паразитов -- или пытались избавиться от других запахов.",
    act = "Меня подташнивает от этой вони."
}

es.obj {
    nam = "catheter",
    done = false,
    cnd = "not s.done",
    dsc = "Я по-прежнему не могу отойти от кровати. {Трубку катетера} точно припаяли к нервам, вся рука немеет от боли.",
    act = function(s)
        if not all.patch.done then
            return "Я пытаюсь выдернуть трубку и не могу -- руку тут же обжигает волной нестерпимой боли."
        else
            s.done = true
            return "Трубка катетера теперь снимается без усилий. Рука, правда, ноет так, словно сломаны все кости."
        end
    end,
    used = function(s, w)
        if w.nam == "putty" then
            return "Не думаю, что эта штука здесь поможет. Катетер фиксируется пластырем, а перерезать его этой лопаткой я точно не смогу."
        end
    end
}

es.obj {
    nam = "patch",
    edge = false,
    done = false,
    cnd = "not s.done",
    dsc = "{Пластырь} на предплечье, фиксирующий трубку, потемнел от крови.",
    act = function(s)
        if not s.edge then
            return "Содрать пластырь не так просто, он, как паразит, вцепился в кожу. Надо что-то придумать."
        else
            s.done = true
            return "Я набираю побольше воздуха в грудь и со всей силы дёргаю пластырь. Меня окатывает волной боли. На освобождённой коже тут же выступает кровь."
        end
    end,
    used = function(s, w)
        if w.nam == "putty" and not s.edge then
            s.edge = true
            return "Я осторожно подцепляю пластырь инструментом -- и словно сдираю этой стальной лопаткой собственную кожу. Сделать это быстро, одним махом не получается. Больно так, как если бы я и правда пытался сам себя освежевать, но пластырь отклеился лишь наполовину."
        elseif w.nam == "putty" and s.edge then
            return "Теперь этот инструмент уже не нужен. Можно попробовать отодрать пластырь пальцами."
        end
    end
}

es.obj {
    nam = "putty",
    disp = es.tool "Желобоватый зонд",
    dsc = "На полу рядом со мной валяется непонятный {инструмент}, похожий на миниатюрный шпатель с длинной ручкой.",
    inv = "Понятия не имею, для чего эта штука используется.",
    tak = [[Дотянуться до этой штуки не так просто, приходится натянуть трубку катетера, из-за чего рука отзывается такой болью, что темнеет в глазах.
    ^Но странный инструмент наконец-то у меня.]]
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv= true,
    pause = 50,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        es.walkdlg {
            dlg = "lysanov",
            branch = "head",
            pic = "station/corridor2",
            disp = "Коридор"
        }
    end
}
-- endregion

-- region pause2
es.room {
    nam = "pause2",
    noinv= true,
    pause = 50,
    next = function(s)
        es.walkdlg {
            dlg = "vera",
            branch = "head",
            pic = "station/cabin4",
            disp = "Жилой модуль B1"
        }
    end
}
-- endregion

-- region b1
es.room {
    nam = "b1",
    mus = false,
    emergency = false,
    madness = false,
    saved = false,
    pic = function(s)
        if s.emergency then
            return "station/cabine"
        else
            return "station/cabin4"
        end
    end,
    disp = "Жилой модуль B1",
    dsc = function(s)
        if not s.emergency then
            return [[Модуль большой, как и у Марутяна, только вместо одной широкой кровати -- две, стоящие у противоположных стен. Лампа и правда мерцает, а в воздухе стоит запах пыли -- сразу становится ясно, что здесь давно никто не жил.]]
        else
            return [[Из-за вопящей сирены голова становится тяжёлой, как после нескольких ночей без сна. Лампа на потолке теперь светит красным и по-прежнему мерцает, бросая на стены кривые извивающиеся тени.]]
        end
    end,
    preact = function(s)
        if s.emergency and not s.mus then
            s.mus = true
            es.music("bass", 1, 0, 3000)
        end
    end,
    onenter = function(s)
        if not s.saved then
            s.saved = true
            snapshots:make()
        elseif not s.madness and all.mirror.broken then
            s.madness = true
            es.music("premonition")
            es.walkdlg {
                dlg = "vera",
                branch = "madness",
                pic = "station/cabin4",
                disp = "Жилой модуль B1"
            }
        end
    end,
    onexit = function(s, t)
        if t.nam == "main" then
            p "Выйти отсюда не получится."
            return false
        elseif t.nam == "b1_latrin" and all.switch.wire then
            all.switch.wire = false
            p "Я вытащил шнур из выключателя света."
        end
    end,
    obj = {
        "switch",
        "b1_door",
        "bed1",
        "glove_holder",
        "bed2",
        "tape_holder",
        "comm",
        "dirtybox",
        "socket",
        "vera1",
        "porthole",
        "glass"
    },
    way = {
        path { "В жилой блок", "main" },
        path { "В санузел", "b1_latrin" }
    }
}

es.obj {
    nam = "switch",
    done = false,
    wire = false,
    dsc = function(s)
        if s.wire then
            return "Из стены -- там, где раньше был выключатель света -- торчат {провода}."
        elseif s.done then
            return "С {выключателя света} содран пластиковый корпус."
        elseif all.b1.emergency then
            return "{Выключатель света} на стене свет не выключает, и взбесившаяся лампа заливает глаза кровавыми всполохами."
        else
            return "{Выключатель света} на стене с запавшей кнопкой намекает на то, что выключить мерцающую лампу не получится, даже если мы захотим насладиться темнотой."
        end
    end,
    act = function(s)
        if s.wire then
            s.wire = false
            return "Я вытаскиваю провод из выключателя."
        elseif s.done then
            return "Надеюсь, мне это чем-то поможет."
        else
            return "Такое ощущение, что над нами издеваются."
        end
    end,
    used = function(s, w)
        if w.nam == "hairpin" and s.done then
            return "Всё уже сделано."
        elseif w.nam == "hairpin" and not s.done then
            return "Заколкой тут ничего не сделаешь."
        elseif w.nam == "splinter" and s.done then
            return "Всё уже сделано."
        elseif w.nam == "splinter" and not s.done then
            s.done = true
            return "Я сдираю пластиковый корпус с выключателя, оголяя провода."
        elseif w.nam == "wire" and not s.done then
            return "Надо снять с выключателя корпус, чтобы получить доступ к проводам."
        elseif w.nam == "wire" then
            return "Не уверен, что я делаю всё в правильном порядке."
        elseif w.nam == "wirepin" and not s.done then
            return "Надо снять с выключателя корпус, чтобы получить доступ к проводам."
        elseif w.nam == "wirepin" and not s.wire then
            s.wire = true
            return "Я соединяю провода. Теперь у меня в руке длинный шнур с заколкой на конце."
        elseif w.nam == "wirepin" and s.wire then
            return "Всё уже подключено."
        end
    end
}

es.obj {
    nam = "b1_door",
    dsc = function(s)
        if all.b1.emergency then
            return "Глазок магнитного замка на {двери} по-прежнему горит красным."
        else
            return "Глазок магнитного замка на {двери} горит красным -- видимо, это означает, что дверь заблокирована снаружи."
        end
    end,
    act = function(s)
        if all.b1.emergency then
            return "Надо придумать, как открыть эту чёртову дверь!"
        else
            es.walkdlg("vera.prison")
            return true
        end
    end
}

es.obj {
    nam = "bed1",
    dsc = function(s)
        if all.b1.emergency then
            return [[С {кровати} у левой стены содрали матрас, и по её голому каркасу пляшут кровавые отблески.]]
        else
            return "Обе кровати, разделённые падающей клином тенью, напоминают жёсткие больничные койки. На той, которая {слева}, зачем-то содрали матрас."
        end
    end,
    act = function(s)
        if not all.glove_holder.examed then
            all.glove_holder.examed = true
            return "У кровати что-то лежит."
        else
            return "Не на что тут смотреть."
        end
    end,
    used = function(s, w)
        if w.nam == "glove" then
            purge("glove")
            all.glove_holder.taken = false
            return "Я бросаю резиновую перчатку на пол. Не знаю, зачем я вообще её подобрал."
        end
    end
}

es.obj {
    nam = "glove_holder",
    examed = false,
    found = false,
    taken = false,
    cnd = "s.examed and not s.taken",
    dsc = function(s)
        if not s.examed then
            return "Я замечаю, что у кровати {что-то} лежит."
        else
            return "У кровати валяется {резиновая перчатка}."
        end
    end,
    act = function(s)
        if not s.examed then
            s.examed = true
            return "Это резиновая перчатка. Видимо, кто-то её обронил."
        else
            take("glove")
            s.taken = true
            return "Я поднимаю перчатку."
        end
    end
}

es.obj {
    nam = "glove",
    fixed = false,
    wear = false,
    disp = es.tool "Резиновая перчатка",
    inv = function(s)
        if s.fixed and s.wear then
            s.wear = false
            return "Кисть начинает потеть, и я снимаю перчатку."
        elseif s.fixed and not s.wear then
            s.wear = true
            return "Я натягиваю перчатку на руку, лента вроде пока держится."
        else
            return "Перчатка порвана, думаю, если попытаться нацепить её на руку, она совсем расползётся."
        end
    end,
    used = function(s, w)
        if w.nam == "tape" then
            return "Лента на удивление крепкая. Не получается разорвать её даже зубами. Надо что-то придумать."
        elseif w.nam == "hairpin" then
            return "Тут нужно что-то острое."
        elseif w.nam == "splinter" then
            return "Зачем мне резать перчатку?"
        elseif w.nam == "tape_piece" then
            return w:used(s)
        end
    end
}

es.obj {
    nam = "bed2",
    dsc = function(s)
        if all.b1.emergency then
            return "До {второй кровати} доживающая последние минуты лампа уже не дотягивается, а словно рассеивается в тени."
        else
            return "{Вторая кровать} не тронута."
        end
    end,
    act = "Обычная кровать, ничего тут разглядывать.",
    used = function(s, w)
        if w.nam == "tape" then
            purge("tape")
            all.tape_holder.taken = false
            return "Я бросаю ленту обратно на кровать."
        end
    end
}

es.obj {
    nam = "tape_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = function(s)
        if all.b1.emergency then
            return "Я едва замечаю на матрасе {рулон с клейкой лентой}."
        else
            return "На ней лежит {рулон с клейкой лентой} -- жёлтого цвета, с чёрной штриховкой."
        end
    end,
    act = function(s)
        s.taken = true
        take("tape")
        return "Я поднимаю с кровати ленту."
    end
}

es.obj {
    nam = "tape",
    disp = es.tool "Клейкая лента",
    inv = "Жёлтая лента с разметкой, такой обычно заклеивают двери, которые нельзя открывать. Видимо, модули хотели опечатать, но забыли или передумали.",
    used = function(s, w)
        if w.nam == "splinter" and have("tape_piece") then
            return "У меня уже есть отрезок ленты."
        elseif w.nam == "splinter" and all.glove.fixed then
            return "Я уже проклеил перчатку."
        elseif w.nam == "splinter" then
            take("tape_piece")
            return "Я отрезаю от ленты небольшой кусок."
        end
    end
}

es.obj {
    nam = "tape_piece",
    disp = es.tool "Отрезок ленты",
    inv = "Небольшой отрезок клейкой ленты.",
    used = function(s, w)
        if w.nam == "glove" then
            w.fixed = true
            purge("tape_piece")
            return "Я проклеиваю разрыв на перчатке лентой -- теперь она должна выдержать."
        end
    end
}

es.obj {
    nam = "comm",
    done = false,
    broken = false,
    dsc = function(s)
        if s.broken then
            return "Из обезображенного {интеркома} торчит кусок витого провода."
        elseif all.b1.emergency then
            return "Трубка {интеркома} качается на проводе, ритмично постукивая по стене."
        else
            return "Рядом поблёскивает бакелитовая трубка {интеркома} -- с неё даже удосужились вытереть пыль."
        end
    end,
    act = function(s)
        if s.broken then
            return "Теперь интеркомом уже не воспользоваться."
        elseif all.b1.emergency and not s.broken then
            s.broken = true
            es.walkdlg("vera.brake")
            take("handset")
            return true
        elseif all.porthole.done and not s.done then
            s.done = true
            es.walkdlg("vera.call")
            return true
        elseif all.porthole.done and s.done then
            all.b1.emergency = true
            es.music("rush", 1, 0, 4000)
            es.walkdlg("vera.emergency")
            return true
        else
            es.walkdlg("vera.comm")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "wool" and not all.b1.emergency then
            return "У меня нет настроения заниматься уборкой."
        elseif w.nam == "wool" then
            return "Сейчас не до этого."
        elseif w.nam == "wire" then
            return "Боюсь, напряжение на интеркоме слишком низкое, чтобы вызвать короткое замыкание.Надо поискать другие варианты."
        end
    end
}

es.obj {
    nam = "handset",
    disp = es.tool "Трубка интеркома",
    inv = "Для того, чтобы выдрать её, потребовалось не так уж и много усилий. Кстати, если схватить её за конец провода, то получится импровизированное оружие. Только вот сражаться не с кем."
}

es.obj {
    nam = "dirtybox",
    examed = false,
    dsc = "У стены неподалёку от двери валяется массивная пластиковая {коробка}.",
    act = function(s)
        s.examed = true
        return "Я заглядываю в неё из любопытства -- ничего. Как будто кто-то хотел собрать вещи для переезда, но потом вспомнил, что вещей у него нет."
    end
}

es.obj {
    nam = "socket",
    cnd = "{dirtybox}.examed",
    dsc = "За коробкой прячется {розетка}, к которой ничего не подключено.",
    act = function(s)
        if not all.b1.emergency then
            return "Розетка как розетка, нечего тут рассматривать."
        else
            return "Возможно, получится устроить короткое замыкание."
        end
    end,
    used = function(s, w)
        if w.nam == "splinter" then
            return "Розетка сделана из толстого крепкого пластика и словно бы впаяна в стену. Содрать её осколком стекла не получится."
        elseif w.nam == "wire" then
            return "Я не смогу подсоединить провод напрямую к розетке."
        elseif w.nam == "hairpin" and not w.done then
            return "Я толкаю заколку в розетку -- никакого эффекта."
        elseif w.nam == "hairpin" and w.done then
            return [[Я завываю заколку в розетку, и вздрагиваю, когда меня мелкой дрожь пробивает разряд тока.
            ^-- Осторожнее! -- кричит Вера.
            ^И правда, не стоило быть настолько безрассудным. К тому же дверь по-прежнему закрыта.]]
        elseif w.nam == "wirepin" then
            if not all.switch.wire and not all.glove.wear then
                return "Я толкаю заколку в розетку -- никакого эффекта."
            elseif not all.switch.wire and all.glove.wear then
                return [[Я завываю заколку в розетку, и вздрагиваю, когда меня мелкой дрожь пробивает разряд тока.
                ^-- Осторожнее! -- кричит Вера.
                ^И правда, не стоило быть настолько безрассудным. К тому же дверь по-прежнему закрыта.]]
            elseif all.switch.wire and not all.glove.wear then
                walkin("death3")
                return true
            elseif all.switch.wire and all.glove.wear then
                purge("wirepin") --left in room
                purge("splinter") --don't want to take
                purge("tape") --?
                purge("wool") --dispose after use?
                purge("glove")
                es.stopMusic(4000)
                es.walkdlg("vera.escape")
                return true
            end
        end
    end
}

es.obj {
    nam = "vera1",
    toxin = false,
    suspect = false,
    crisis = false,
    dsc = function(s)
        if all.b1.emergency then
            return "{Вера} нервно ходит по модулю, раздражённо поглядывая на трещащую лампу, которая омывает её красным светом."
        elseif all.glass.clean then
            return "{Вера} сидит на кровати, зябко втянув голову в плечи."
        else
            return "{Вера} сидит"
        end
    end,
    act = function(s)
        if not s.crisis and all.b1.emergency then
            s.crisis = true
            es.walkdlg("vera.crisis")
            return true
        elseif all.b1.emergency then
            es.walkdlg("vera.getout")
            return true
        elseif not s.toxin then
            s.toxin = true
            es.walkdlg {
                dlg = "vera",
                branch = "toxin",
                pic = "station/cabin4",
                disp = "Жилой модуль B1",
                owner = "vera1"
            }
            return true
        else
            es.walkdlg("vera.bad")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "handset" then
            return "Я что, с ума сошёл?"
        elseif w.nam == "splinter" then
            w.try = true
            return "Нет! О чём я вообще думаю? Я никогда её не трону. Я, скорее, убью себя."
        end
    end
}

es.obj {
    nam = "porthole",
    examed = false,
    done = false,
    dsc = function(s)
        if all.b1.emergency then
            return "По {иллюминатору} проносятся красные блики."
        elseif all.glass.clean then
            return "В {иллюминатор}, после того, как я отчистил его от пыли, теперь можно хоть что-то разглядеть."
        else
            return "у {иллюминатора} и смотрит на что-то сквозь своё отражение."
        end
    end,
    act = function(s)
        if all.b1.emergency then
            return "Сейчас не время наслаждаться видами."
        elseif s.done then
            return "Сейчас не до этого."
        elseif all.glass.clean then
            s.done = true
            es.walkdlg("vera.storm")
            return true
        elseif s.examed then
            return "Вера вздыхает, смотрит невидящим взглядом в иллюминатор."
        else
            s.examed = true
            es.walkdlg("vera.porthole")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "wool" and not all.glass.clean and s.examed then
            return "Да, можно попробовать протереть стекло."
        elseif w.nam == "wool" and not all.glass.clean then
            s.examed = true
            es.walkdlg("vera.porthole")
            return true
        end
    end
}

es.obj {
    nam = "glass",
    clean = false,
    cnd = "{porthole}.examed and not s.clean",
    dsc = "{Стекло} заросло пылью.",
    act = "Всё в пыли, едва работает свет... Кажется, что мы с Верой -- на заброшенной станции, которая сходит с орбиты.",
    used = function(s, w)
        if w.nam == "wool" and not w.powder then
            return "Грязь так сильно въелась в стекло, что оттереть её не получается."
        elseif w.nam == "wool" and w.powder then
            purge(w.nam)
            s.clean = true
            es.walkdlg("vera.planet")
            return true
        end
    end
}

es.obj {
    nam = "hairpin",
    done = false,
    disp = es.tool "Заколка",
    inv = function(s)
        if not s.done then
            return "Заколка покрыта эмалью, надо её сначала соскоблить."
        else
            return "Заколка для волос с соскобленной эмалью, отлично проводит ток."
        end
    end,
    used = function(s, w)
        if w.nam == "wire" then
            return w:used(s)
        elseif w.nam == "splinter" then
            s.done = true
            return "Я соскабливаю эмаль с заколки. Теперь всё готово."
        end
    end
}

es.obj {
    nam = "wirepin",
    disp = es.tool "Провод с заколкой",
    inv = function(s)
        if all.switch.wire then
            return "Провод поведён к тому, что осталось от выключателя света и теперь над напряжением. Остался последний шаг."
        else
            return "Провод от коммуникатора с примотанной к нему заколкой -- всё готово для саботажа электросети."
        end
    end
}
-- endregion

-- region b1_latrin
es.room {
    nam = "b1_latrin",
    pic = "station/toilet1",
    disp = "Санузел",
    dsc = function(s)
        if all.b1.emergency then
            return "Здесь чуть тише, надрывный вой сирены становится приглушённым, а дверь отрезает тебя от бешёной лампы, расплёскивающей повсюду кровавый свет."
        else
            return "Санузел выглядит точно так же, как и в моём жилом блоке."
        end
    end,
    obj = {
        "medbox",
        "wool_holder",
        "mirror",
        "splinters",
        "wire",
        "sink"
    },
    way = {
        path { "Выйти", "b1" }
    }
}

es.obj {
    nam = "medbox",
    unlocked = false,
    dsc = function(s)
        if all.b1.emergency then
            return "На стене -- стандартная {аптечка}."
        else
            return "Даже настенная {аптечка} висит на том же месте."
        end
    end,
    act = function(s)
        if s.unlocked then
            s.unlocked = false
            return "Я закрываю аптечку."
        else
            s.unlocked = true
            return "Всё содержимое аптечки старательно выгребли, осталась лишь пара смятых нетканных салфеток. Неужели кто-то боялся, что мы можем наглотаться таблетками?"
        end
    end
}

es.obj {
    nam = "wool_holder",
    cnd = "{medbox}.unlocked",
    taken = false,
    dsc = "Дверца приоткрыта, и видно, что на нижней полке валяется несколько нетканных {салфеток}.",
    act = function(s)
        if not s.taken then
            s.taken = true
            take("wool")
            return "Я беру одну салфетку."
        else
            return "Я как-то не планировал коллекционировать салфетки."
        end
    end
}

es.obj {
    nam = "wool",
    powder = false,
    disp = es.tool "Нетканная салфетка",
    inv = function(s)
        if s.powder then
            return "На салфетке есть немного чистящего порошка."
        else
            return "Обычная нетканная салфетка."
        end
    end
}

es.obj {
    nam = "mirror",
    broken = false,
    dsc = function(s)
        if s.broken then
            return "Разбитое {зеркало} превратилось в чёрный квадрат с зазубренными краями."
        else
            return "{Зеркало} недавно протирали, и на его поверхности остались разводы."
        end
    end,
    act = function(s)
        if s.broken then
            return "Зеркало теперь выглядит так же, как и в модуле Веры."
        else
            return "Тяжело смотреть на своё отражение, я похож на живого мертвеца, и едва могу себя узнать."
        end
    end,
    used = function(s, w)
        if w.nam == "wool" then
            return "У меня нет сейчас желания чистить зеркало."
        elseif w.nam == "handset" then
            s.broken = true
            purge("handset")
            return [[Из зеркала на меня смотрит человек с серой неживой кожей и тёмными запавшими глазами, в которых почти не осталось жизни. Я хватаю трубку интеркома за провод и бью по зеркалу наотмашь, как в лицо смертельного врага.
            ^Зеркало вместе с трубкой разлетаются волной осколков. Я едва успеваю отвернуться, но всё равно чувствую, как что-то режет меня по щеке.]]
        end
    end
}

es.obj  {
    nam = "splinters",
    taken = false,
    cnd = "{mirror}.broken",
    dsc = function(s)
        if all.wire.taken then
            return "На полу валяются {осколки}."
        else
            return "На полу валяются {осколки} и"
        end
    end,
    act = function(s)
        if s.taken then
            return "Зачем мне ещё один осколок."
        else
            s.taken = true
            take("splinter")
            return "Я разгребаю осколки ногой, выбираю тот, что покрупнее."
        end
    end,
    used = function(s, w)
        if w.nam == "splinter" then
            purge("splinter")
            s.taken = false
            return "Я бросаю осколок на пол."
        end
    end
}

es.obj {
    nam = "wire",
    taken = false,
    disp = es.tool "Витой провод",
    cnd = "{mirror}.broken",
    dsc = "{витой провод} с оголённым концом.",
    tak = function(s)
        s.taken = true
        return "Я поднимаю провод."
    end,
    inv = function(s)
        if all.switch.wire then
            return "Витой провод подключён одним концом к тому, что осталось от выключателя света."
        else
            return "Это просто витой провод с оголённым концом."
        end
    end,
    used = function(s, w)
        if w.nam == "hairpin" and not w.done then
            return "Надо сначала содрать изоляцию с заколки, а потом уже приматывать к ней провод."
        elseif w.nam == "hairpin" then
            purge("wire")
            purge("hairpin")
            take("wirepin")
            return "Я приматываю провод к заколке -- получается что-то странное, наводящее на мысли об устройстве для пыток. Господи! Надеюсь, я не убьюсь."
        end
    end
}

es.obj {
    nam = "splinter",
    try = false,
    disp = es.tool "Осколок зеркала",
    inv = function(s)
        if s.try then
            walkin("death2")
            return true
        elseif all.b1.madness then
            s.try = true
            return "Я смотрю на осколок зеркала в руке, сжимая его так сильно, что он начинает резать кожу и думаю -- может, и правда токсин ещё у меня в крови?"
        else
            return "Острый осколок зеркало, таким при желании можно перерезать горло."
        end
    end,
    used = function(s, w)
        if w.nam == "glove" or w.nam == "tape" or w.nam == "hairpin" then
            return w:used(s)
        end
    end
}

es.obj {
    nam = "sink",
    dsc = "В {умывальнике} видны следы чистящего порошка.",
    act = "Здесь явно пытались уничтожить следы человеческого присутствия, но как-то нехотя и впопыхах.",
    used = function(s, w)
        if w.nam == "wool" and not w.powder then
            w.powder = true
            return "Я провожу салфеткой по раковине, и на ней остаётся немного чистящего порошка."
        else
            return "На салфетке уже есть порошок."
        end
    end
}
-- endregion

-- region death2
es.room {
    nam = "death2",
    pic = "common/redrum",
    disp = "Жилой модуль B2",
    dsc = [[Рука сама сжимает осколок, кровь течёт по запястью. Я вдруг думаю, как будет приятно избавиться от этого воя, красного света, от этой боли, от всех этих людей. Нужно лишь потерпеть одно мгновение...
    ^И я вонзаю осколок себе в шею.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "Последняя точка сохранения",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region death3
es.room {
    nam = "death3",
    pic = "common/electricity",
    disp = "Жилой модуль B2",
    dsc = [[Я набираю побольше воздуха в грудь и засовываю шпильку в розетку. В ту же секунду в сердце мне врезается огромный таран. Меня отбрасывает на спину, и я проваливаюсь в темноту.]],
    enter = function(s)
        es.music("death")
    end,
    next_disp = "Последняя точка сохранения",
    next = function(s)
        snapshots:restore()
    end
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    noinv = true,
    pic = "station/corridor_red1",
    disp = "Коридор",
    enter = function(s)
        es.music("doom", 2)
    end,
    dsc = [[Мы вылетели из модуля.
    ^Сирена уже сходила на нет, превращаясь в растянутый низкий вой, который заглушали толстые стены, но лампы всё ещё отливали красным.]],
    next = "interlude2"
}
-- endregion

-- region interlude2
es.room {
    nam = "interlude2",
    noinv = true,
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Мы выбежали из жилого блока в коридор, и сирена захлебнулась, сменившись звоном в ушах, как от контузии из-за навалившейся тишины. Аварийный режим отключился. Свет теперь горел ровно и ярко.
    ^В воздухе витала мерцающая пыль.]],
    next = "corridor1"
}
-- endregion

-- region corridor1
es.room {
    nam = "corridor1",
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Мы остановились ненадолго, чтобы отдышаться -- и решить, куда дальше идти. Коридор оглушительно пуст, как будто всё население станции эвакуировалось, пока орала сирена, бросив нас здесь одних.]],
    onexit = function(s, t)
        if t.nam == "main" then
            es.walkdlg("vera.wrongway")
            return false
        end
    end,
    obj = { "vera2", "sunlight" },
    way = {
        path { "К жилому блоку B", "main" },
        path { "#elevator", "К лифтовой площадке", "platform" }:disable()
    }
}

es.obj {
    nam = "vera2",
    done = false,
    dsc = "{Вера} стоит у переборки, касаясь её ладонью так, словно прислушивается к пульсу.",
    branch = function(s)
    end,
    act = function(s)
        enable "#elevator"
        if s.done then
            es.walkdlg("vera.needgo")
        else
            s.done = true
            es.walkdlg("vera.pulse")
        end
        return true
    end
}

es.obj {
    nam = "sunlight",
    dsc = "Узкий, словно обведённый жирной полоской спёкшейся грязи {иллюминатор}, поймал луч звезды Сантори, и тот настойчиво бьёт в глаза.",
    act = "Странно, но до этого я ни разу не видел в иллюминатор местную звезду, она словно пряталась от меня в складках темноты, утаскивая за собой все звёзды."
}
-- endregion

-- region platform
es.room {
    nam = "platform",
    done = false,
    pic = "station/elevator",
    disp = "Лифтовая площадка",
    dsc = [[Свет на лифтовой площадке горит ярче, точно на сцене, из-за чего возникает гнетущее чувство, что все мы учавствуем в какой-то абсурдной постановке на орбите захватившего нас гравитационным приливом газового гиганта, в тысячах световых лет от Земли.]],
    onexit = function(s, w)
        if w.nam == "corridor2" and not s.done then
            s.done = true
            es.walkdlg("andreev.bye")
            return false
        end
    end,
    obj = { "andreev", "vera3", "elevator", "stairs" },
    way = {
        path { "К блоку C", "corridor2" }:disable()
    }
}

es.obj {
    nam = "andreev",
    wake = false,
    dsc = function(s)
        if not s.wake then
            return "На полу лежит чьё-то грузное бесформенное тело, раскинув руки, как пловец, отдыхающий на воде. Я не сразу узнаю {Андреева}."
        else
            return "{Андреев} сидит на полу, привалившись к стене и бесчувственно свесив голову."
        end
    end,
    act = function(s)
        if s.wake then
            return "Я думаю, лучше оставить его в покое. Наверняка у него сотрясение мозга. Пока мы ему ничем не может помочь."
        else
            es.music("doom", 2)
            s.wake = true
            es.walkdlg("andreev.wake")
            return true
        end
    end
}

es.obj {
    nam = "vera3",
    done = false,
    dsc = function(s)
        if not all.andreev.wake then
            return "{Вера} нерешительно замерла перед распростёршимся телом, словно, как и я, перестаёт верить в реальность происходящего."
        else
            return "{Вера} примостилась рядом с ним и аккуратно стирает кровь со лба платком."
        end
    end,
    finish = function(s)
        s.done = true
        all.platform.way[1]:enable()
    end,
    act = function(s)
        if not all.andreev.wake then
            return "Надо сначала помочь Андрееву."
        elseif s.done then
            return "Лучше поторопиться."
        else
            es.walkdlg {
                dlg = "vera",
                branch = "stairs",
                pic = "station/elevator",
                disp = "Лифтовая площадка",
                owner = "vera3"
            }
            return true
        end
    end
}

es.obj {
    nam = "elevator",
    dsc = "{Кнопка} вызова лифта не светится -- видимо, по протоколу безопасности все лифты на станции отключены, -- причём по табло над сомкнутыми дверями видно, что лифт стоит на этом уровне.",
    act = function(s)
        if not all.andreev.wake then
            return "Сейчас не до того, надо помочь Андрееву."
        else
            es.walkdlg("vera.elevator")
            return true
        end
    end
}

es.obj {
    nam = "stairs",
    done = false,
    dsc = "Выход на лестничную клетку открыт, но сама {лестница} опасно перекосилась.",
    act = function(s)
        if not all.andreev.wake then
            return "Я бы сначала проверил, что случилось с Андреевым."
        elseif not s.done then
            s.done = true
            return "Часть креплений сорвана, и лестница шатается, лязгая о металлическую переборку, стоит лишь слегка её покачать. Лучше здесь не подниматься."
        else
            return "Нет, подниматься здесь не стоит, надо найти другой путь."
        end
    end
}
-- endregion

-- region corridor2
es.room {
    nam = "corridor2",
    pic = "station/corridor2",
    disp = "Коридор",
    dsc = [[Я ходил по коридору, соединяющему жилые блоки, уже несколько дней, но сейчас он кажется невыносимо длинным, точно мы идём по кругу мимо бесконечно одинаковых переборок.]],
    onexit = function(s, t)
        if t.nam == "interlude3" and not all.vera4.done then
            p "Думаю, Вере нужно отдохнуть."
            return false
        end
    end,
    obj = { "sunshine", "sunshadow", "vera4" },
    way = {
        path { "К блоку C", "interlude3" }
    }
}

es.obj {
    nam = "sunshine",
    done = false,
    dsc = "Сантори, огромная звезда класса Вольфа-Райе, вновь заглядывает в {иллюминатор}, и я невольно прикрываюсь от её света ладонью.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.sunshine")
            return true
        else
            return "Не хочу жечь себе глаза."
        end
    end
}

es.obj {
    nam = "sunshadow",
    dsc = "На полу перед нами, точно непререкаемая граница, вытягивается длинная {звездная тень}.",
    act = "Можно подумать, что она и правда преграждает нам путь."
}

es.obj {
    nam = "vera4",
    done = false,
    dsc = "{Вера} останавливается.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.stop")
            return true
        else
            return "Надо идти."
        end
    end
}
-- endregion

-- region interlude3
es.room {
    nam = "interlude3",
    pic = "station/block_d",
    disp = "Жилой блок D",
    dsc = [[Мы проходим мимо моего модуля, и я с трудом сдерживаюсь от того, чтобы предложить Вере запереться там, спрятаться от всего происходящего и просто ждать, когда всё разрешится само собой.
    ^Или разбить ещё одно зеркало.
    ^^-- Пойдём! -- Вера тянет меня за рукав.]],
    next_disp = "-- Пойдём!",
    next = "pause3"
}
-- endregion

-- region pause3
es.room {
    nam = "pause3",
    noinv = true,
    pause = 50,
    next = "block_c"
}
-- endregion

-- region block_c
es.room {
    nam = "block_c",
    pic = "station/block_c",
    disp = "Жилой блок C",
    dsc = [[В жилом блоке всё пусто, как на вымершей станции, но хотя бы Сантори больше не слепит глаза.]],
    preact = function(s, w)
        if all.vera5.dofix and w.nam ~= "vera_work" then
            return "Я сейчас немного занят."
        end
    end,
    onexit = function(s, t)
        if all.vera5.dofix then
            p "Я сейчас немного занят."
            return false
        elseif t.nam == "interlude4" and not all.stairdoor.unlocked then
            p "Дверь на лестничную клетку закрыта."
            return false
        elseif t.nam == "interlude2" then
            es.walkdlg("vera.flee")
            return false
        end
    end,
    obj = {
        "window",
        "pane",
        "stairdoor",
        "stairlock",
        "wires",
        "vera5",
        "vera_work"
    },
    way = {
        path { "К жилому блоку D", "interlude2" },
        path { "На лестничную клетку", "interlude4" }
    }
}

es.obj {
    nam = "window",
    dsc = "В единственный {иллюминатор}, узкий, как бойница, не видно ничего, кроме темноты.",
    act = function(s)
        if not all.vera5.tofix then
            return "Я бы предпочёл сначала проверить дверь."
        elseif all.pane.found then
            return "Нет у меня желания смотреть в темноту."
        else
            all.pane.found = true
            return "Я подхожу ближе и замечаю, что над панель воздуховода над иллюминатором почти слетела с петель."
        end
    end
}

es.obj {
    nam = "pane",
    found = false,
    toofar = false,
    cnd = "s.found",
    dsc = "{Панель} воздуховода над ним почти слетела с петель.",
    act = function(s)
        s.toofar = true
        return "Панель слишком высоко, не могу до неё дотянуться. Я поворачиваюсь к Вере."
    end
}

es.obj {
    nam = "stairdoor",
    unlocked = false,
    dsc = function(s)
        if s.unlocked then
            return "{Дверь} на лестничную клетку отмечена характерной пиктограммой."
        else
            return "{Дверь} на лестничную клетку отмечена характерной пиктограммой и -- закрыта."
        end
    end,
    act = function(s)
        if s.unlocked then
            walkin("interlude4")
            return true
        else
            return "Дверь закрыта, проблема в замке."
        end
    end
}

es.obj {
    nam = "stairlock",
    cracked = false,
    dsc = function(s)
        if not s.cracked then
            return "На {магнитном замке} часто мигает красный светодиод."
        else
            return "Корпус {магнитного замка} сбит панелью от воздуховода,"
        end
    end,
    act = function(s)
        if not all.vera5.tofix then
            all.vera5.tofix = true
            es.walkdlg("vera.tofix")
            return true
        elseif not s.cracked then
            return "Надо как-то снять корпус замка. Наверняка я смогу его починить."
        elseif s.cracked then
            return "Нужно заняться починкой."
        end
    end,
    used = function(s, w)
        if w.nam == "pane_piece" then
            purge("pane_piece")
            s.cracked = true
            return "Я сбиваю панелью от воздуховода коробку замка, оголяя проводку. Достаточно быстрого осмотра, чтобы понять причину неполадки -- видимо, из-за тряски разошлись два проводка."
        end
    end
}

es.obj {
    nam = "wires",
    cnd = "{stairlock}.cracked",
    dsc = "и наружу торчит {проводка}.",
    act = function(s)
        if all.stairdoor.unlocked then
            return "Всё уже сделано."
        elseif not all.glove.wear then
            return "Я касаюсь порвавшегося проводка и вздрагиваю от удара током. Нет, так не пойдёт."
        else
            all.stairdoor.unlocked = true
            return "Всего-то и нужно скрутить два проводка -- огонёк светодиода тут же сменяется на зелёный. Дверь открыта."
        end
    end
}

es.obj {
    nam = "vera5",
    tofix = false,
    dofix = false,
    cnd = "not s.dofix",
    dsc = "{Вера} с надеждой смотрит на меня.",
    act = function(s)
        if not s.tofix then
            s.tofix = true
            es.walkdlg("vera.tofix")
            return true
        else
            es.walkdlg("vera.fixing")
            return true
        end
    end
}

es.obj {
    nam = "vera_work",
    try = 1,
    cnd = "{vera5}.dofix",
    dsc = "^^Я поднял {Веру} над иллюминатором. Она ухватилась за панель воздуховода и пытается её сорвать.",
    fixing = function(s)
        s.try = s.try + 1
    end,
    end_fixing = function(s)
        all.vera5.dofix = false
    end,
    act = function(s)
        if s.try == 1 then
            es.walkdlg {
                dlg = "vera",
                branch = "fixing1",
                pic = "station/block_c",
                disp = "Жилой блок C",
                owner = "vera_work"
            }
            return true
        elseif s.try == 2 then
            es.walkdlg {
                dlg = "vera",
                branch = "fixing2",
                pic = "station/block_c",
                disp = "Жилой блок C",
                owner = "vera_work"
            }
            return true
        elseif s.try == 3 then
            es.walkdlg {
                dlg = "vera",
                branch = "fixing3",
                pic = "station/block_c",
                disp = "Жилой блок C",
                owner = "vera_work"
            }
            return true
        end
    end
}

es.obj {
    nam = "pane_piece",
    disp = es.tool "Панель воздуховода",
    inv = "Смятая панель воздуховода."
}
-- endregion

-- region interlude4
es.room {
    nam = "interlude4",
    pic = "station/tonnel",
    disp = "Лестничная клетка",
    dsc = [[Я полез первым и попросил Веру подождать меня внизу -- после того, как даже падающий сквозь иллюминаторы свет начал вызывать безотчётный страх, я от всего ждал подвоха. Лестница поскрипывала и шаталась -- не уверен, что она бы выдержала, если бы станцию вновь начало трясти.
    ^Я поднялся на верхний уровень и оказался в узком, как санузел, отсеке -- перед закрытой дверью.]],
    enter = function(s)
        es.stopMusic("juxtaposition")
    end,
    next = function(s)
        es.walkdlg {
            dlg = "vera",
            branch = "closed",
            pic = "station/staircase",
            disp = "Лестничная клетка"
        }
        return true
    end
}
-- endregion

-- region staircase
es.room {
    nam = "staircase",
    pic = "station/staircase",
    disp = "Лестничная клетка",
    dsc = [[Здесь темно, точно в забытой кладовке. Единственный источник света -- маленькая лампочка над головой -- не работает.]],
    obj = { "sdoor", "find_button" }
}

es.obj {
    nam = "sdoor",
    dsc = "Я упираюсь в закрытую {дверь}.",
    act = "Где-то здесь должна быть кнопка для открытия двери. Если бы только горел свет..."
}

es.obj {
    nam = "find_button",
    dsc = "Дверь на лестничной клетке не может быть заблокирована намертво -- {где-то здесь} должна быть кнопка или рычаг.",
    act = function(s)
        es.music("bam")
        es.walkdlg("vera.boom")
        return true
    end
}
-- endregion

-- region corridor3
es.room {
    nam = "corridor3",
    mus = false,
    pic = "station/corridor4",
    disp = "Коридор",
    dsc = [[Всё вокруг дрожит, как в припадке, словно станция падает в плотные слои атмосферы. Гравитационные катушки едва тянут, сначала мне кажется, что я вот-вот оторвусь от пола и поплыву в невесмости, а спустя секунду ноги становятся свинцовыми, и я чуть не падаю на колени.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.loopMusic("countdown")
        end
    end,
    onexit = function(s, t)
        if t.nam == "staircase" then
            p "Надо сначала разобраться, что здесь происходит."
            return false
        end
    end,
    obj = { "noalarm", "sun", "figures" },
    way = {
        path { "На лестничную клетку", "staircase" }
    }
}

es.obj {
    nam = "noalarm",
    dsc = "Однако {сигнализации нет}, и аварийные люминофоры тоже не горят.",
    act = "Отказала система тревожного оповещения? Насколько же плохо у нас дела, если даже сигнализация не работает!"
}

es.obj {
    nam = "sun",
    dsc = "Зато {Сантори} вновь заглядывает в бойницу иллюминатора, вычерчивая на стенах цветные тени.",
    act = "Я отвожу глаза."
}

es.obj {
    nam = "figures",
    dsc = "Я замечаю в глубине коридора {двух людей}, похожих на вытянутые, как в сумерки, тени -- один режет какую-то дверь плазменным резаком, отворачиваясь от снопа искр, а второй, точно в приступе бешенства, барабанит по ней кулаком.",
    act = function(s)
        es.walkdlg("crowd.shadows")
        return true
    end
}
-- endregion

-- region interlude5
es.room {
    nam = "interlude5",
    pic = "station/impact1",
    disp = "Коридор",
    dsc = [[Что-то наотмашь бьёт меня под ноги, с такой силой, что темнеет в глазах. Я падаю в хаотичное зарево из мелькающий огней, выжигающего звёздного света и нарастающего штормовой волной гвалта.
    ^Всё происходит, как при замедленной съёмке.
    ^Стена передо мной лопается, точно бумажный лист, и наружу, как органы освежёванного животного, вываливаются мотки проводки и рвущиеся со стоном трубы. Что-то вздрывается фонтаном огненных брызг, полоска огня быстро взбирается по стене. По воздуху разливается запах химической гари.
    ^Меня снова швыряет на какую-то поверхность -- я уже не различаю пол с потолком, -- и я проваливаюсь в темноту.]],
    next = "interlude6"
}
-- endregion

-- region interlude6
es.room {
    nam = "interlude6",
    pic = "station/impact2",
    disp = "Коридор",
    dsc = [[Я прихожу в себя, пытаюсь встать. Тело обжигает волной боли. От едкой гари выворачивает кишки. Всё перед глазами затянуто красным маревом. Я думаю, что это -- огонь, но нет, заработали аварийные люминофоры. Я встаю, но неуёмная сила тут же сбивает меня с ног.
    ^Кто-то кричит -- надрывно, отчаянно, -- растрачивая последний воздух в лёгких.]],
    next = "interlude7"
}
-- endregion

-- region interlude7
es.room {
    nam = "interlude7",
    pic = "station/impact3",
    disp = "Коридор",
    dsc = [[Я снова теряю сознание.
    ^Прихожу в себя на полу -- я лежу, распростёршись, как пловец отдыхающий после долго заплыва. Рядом валяются бессвязные обломки, куски обшивки, смятые трубы, погнутые панели. Затылок горит от боли. Кажется голова пробита насквозь металлическим штырём.
    ^Я приподнимаюсь на дрожащих руках -- сил не хватает, чтобы удержать вес собственного тела. Я снова растягиваюсь не полу -- лучше пока не двигаться.
    ^Что-то бьёт по стенам, точно гигантский маятник, отсчитывающий последние секунды.]],
    next = "interlude8"
}
-- endregion

-- region interlude8
es.room {
    nam = "interlude8",
    pic = "station/impact4",
    disp = "Коридор",
    dsc = [[Я поворачиваюсь и вижу Алексина.
    ^Он лежит рядом, на боку, поджав под себя ноги, как будто спит, но глаза у него открыты, и он смотрит на меня тяжёлым невидящим взглядом.
    ^Я что-то говорю ему, но слова как-то путаются, цепляются друг за друга, утрачивая в моём бессвязаном мычании даже тень смысла. Я говорю долго -- так, по крайней мере, кажется. Я всё пытаюсь ему что-то объяснить, какие-то модули, нуболиды, прочность камеры для содержания. 
    ^Он не отвечает.
    ^Я трясу его за плечо. Потом понимаю, что он мёртв.]],
    next = "interlude9"
}
-- endregion

-- region interlude9
es.room {
    nam = "interlude9",
    pic = "station/impact5",
    disp = "Коридор",
    dsc = [[С потолка что-то сыплется, как град, я невольно прикрываю голову. Раздаётся плавный неживой голос системы оповещения:
    ^-- В случае отказа двигательных установок, схода с орбиты или другой эквивалентной катастрофы... -- Механический голос срывается на звон, сбивается и начинает заново: -- В случае отказа двигательных установок, схода с орбиты или другой эквивалентой катастрофы...
    ^Мимо меня кто-то тащит за руки окровавленное тело.]],
    next = "interlude10"
}
-- endregion

-- region interlude10
es.room {
    nam = "interlude10",
    pic = "station/impact6",
    disp = "Коридор",
    dsc = [[Кто-то подхватывает меня под руки. Я не сопротивляюсь. Мне хочется сказать, что я ещё жив, но я не могу разлепить рот. Наверное, сейчас меня потащат куда-то в красное марево, как другие трупы. Когда умираешь, всё вокруг застилает кровавый туман.
    ^Меня усаживают у стены. Надо мной склоняется мужчина с впалыми, как у больного, щёками. Это Мицюкин.]],
    next = function(s)
        es.stopMusic(6000)
        es.walkdlg {
            dlg = "mitsukin",
            branch = "help",
            pic = "station/corridor_red2",
            disp = "Коридор"
        }
    end
}
-- endregion

-- region redcor1
es.room {
    nam = "redcor1",
    mus = false,
    pic = "station/corridor_red2",
    disp = "Коридор",
    dsc = [[По сравнению]]..fmt.img("theme/1.png").. [[с тем, что я вижу, кошмары во время дрейфа кажутся просто дурным сном. Кто-то стонет. Подыхающие люминофоры расплескивают повсюду свет, напоминающий зарево пожара. Где-то и правда горит.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("bass", 2)
        end
    end,
    onexit = function(s, t)
        if t.nam == "deck" and all.deck.done then
            p "Не думаю, что меня там хотят видеть."
            return false
        end
    end,
    obj = {
        "alexin",
        "stick_holder",
        "grayman",
        "vera6",
        "phosphor",
        "mitsukin",
        "fire1",
        "lysanov",
        "crackdoor",
        "fire2",
        "deckdoor"
    },
    way = {
        path { "К лестничной клетке", "nearstair" },
        path { "#deck", "В рубку", "deck" }:disable(),
        path { "Вглубь коридора", "redcor2" }
    }
}

es.obj {
    nam = "alexin",
    done = false,
    dsc = "{Тело Алексина} прикрыли красным пластиковым мешком, из которого выпросталась бледная и тонкая рука, похожая на конечность сломанного манекена.",
    act = function(s)
        if not s.done then
            s.done = true
            walkin("alexin_scene")
            return true
        else
            return "Я опускаюсь на колени, касаюсь чёрного полиэтилена и тут же отдёргиваю руку. Нет, я не могу больше на это смотреть."
        end
    end
}

es.obj {
    nam = "stick_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = "Из раскроенной стены торчит кусок погнутой {арматуры}, один конец которой потемнел от крови.",
    act = [[Я каким-то чудом не налетел на неё, когда меня отбросило после удара.
    ^Я обхватываю арматуру обеими руками, тяну. За переборкой что-то надрывно трещит, ноги скользят по липкому полу. Нет, так её не вытащить.]],
    inv = "Толстый и крепкий кусок арматуры, испачканный кровью.",
    used = function(s, w)
        if w.nam == "cutter" then
            s.taken = true
            take("stick")
            return "Я срезаю резаком кусок арматуры."
        end
    end
}

es.obj {
    nam = "stick",
    disp = es.tool "Арматура",
    inv = "Толстый и крепкий кусок арматуры, испачканный кровью."
}

es.obj {
    nam = "grayman",
    done = false,
    cnd = "not {mitsukin}.done",
    dsc = function(s)
        if not s.done then
            return "{Лысанов} делает кому-то искусственное дыхание, резко, с надрывом давит на грудную клетку. Пот стекает у него по лицу."
        else
            return "{Лысанов} сидит у грузного тела мужчины с почерневшим от ожогов лицом и смотрит в пустоту неподвижным взглядом."
        end
    end,
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("lysanov.deadfriend")
            return true
        else
            return "Я никак не могу помочь."
        end
    end
}

es.obj {
    nam = "vera6",
    done = false,
    dsc = "{Вера} поит какую-то женщину водой из бутылки.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("vera.debris1")
        else
            es.walkdlg("vera.debris2")
        end
        return true
    end
}

es.obj {
    nam = "phosphor",
    dsc = "Над ней мигает самый яркий в коридоре {аварийный люминофор}, как маяк, передающий бинарный код сквозь загустевший от гари воздух.",
    act = "Я какое-то время смотрю на это гипнотизирующее мерцание, как если бы сходящая с ума электрика и правда передавала мне какое-то послание. Я вдруг думаю, что есть единственно правильный способ действовать, способ мыслить, благодаря которому она -- хотя бы она -- останется жива."
}

es.obj {
    nam = "mitsukin",
    ask = false,
    done = false,
    cnd = "not s.done",
    dsc = function(s)
        if not s.ask then
            return "^^{Мицюкин} сражается с пробивающимся сквозь трещины в стенах огнём, поливая его слабеющей струёй из огнетушителя."
        elseif s.ask and not s.done then
            return "^^{Мицюкин} корчится, точно в приступах боли. Он зажимает рот рукой и вздрагивает от кашля."
        end
    end,
    act = function(s)
        if not s.ask then
            s.ask = true
            es.walkdlg("mitsukin.task1")
        elseif s.ask and not have("extinguisher") then
            es.walkdlg("mitsukin.task2")
        elseif s.ask and have("extinguisher") then
            es.walkdlg("mitsukin.task3")
        else
            return "Больше я ничем не могу помочь."
        end
        return true
    end,
    used = function(s, w)
        if w.nam == "extinguisher" then
            return s:act()
        end
    end
}

es.obj {
    nam = "fire1",
    try = 0,
    cnd = "{mitsukin}.ask and not {mitsukin}.done",
    dsc = function(s)
        if s.try == 0 then
            return "{Пламя} яростно вырывается из расселины в стене, окатывая адовым жаром."
        elseif s.try == 1 then
            return "{Огонь} из трещины в стене лижет обшивку."
        elseif s.try == 2 then
            return "{Огонь} уже заметно ослаб, отступил, но всё ещё рвётся сквозь чёрный разлом в стене."
        end
    end,
    act = function(s)
        if s.try < 3 then
            return "Здесь нужен огнетушитель."
        else
            return "Наверняка на этом уровне есть ещё возгорания."
        end
    end,
    used = function(s, w)
        if w.nam == "extinguisher" then
            s.try = s.try + 1
            if s.try == 1 then
                return "Я поливаю пламя жидкой пеной, которая мгновенно испаряется, но огонь упорно пробивается сквозь трещину."
            elseif s.try == 2 then
                return "Я продолжаю окатывать пеной трещину в стене, но огонь всё ещё горит."
            elseif s.try == 3 then
                all.mitsukin.done = true
                es.walkdlg("mitsukin.newtask")
                return true
            end
        end
    end
}

es.obj {
    nam = "lysanov",
    ask = false,
    fire = false,
    firefixed = false,
    done = false,
    cnd = "{mitsukin}.done and not s.done",
    dsc = function(s)
        if s.fire and not s.firefixed then
            return "^^{Мицюкин} вместе с Лысановым стоит у перекошенной двери в какой-то отсек, громко переругиваясь."
        else
            return "^^{Мицюкин} вместе с Лысановым выламывают заевшую "
        end
    end,
    act = function(s)
        if not s.ask then
            s.ask = true
            es.walkdlg("lysanov.break_in")
            return true
        elseif not s.fire and have("stick") then
            s.done = true
            es.walkdlg("lysanov.open_door")
            return true
        elseif not s.fire and have("cutter") and not s.firefixed then
            s.fire = true
            es.walkdlg("lysanov.fire")
            return true
        elseif s.fire and not s.firefixed then
            return "Нет у меня желания участвовать в их оживлённой дискуссии, надо просто потушить огонь."
        else
            return "Надо бы им помочь."
        end
    end,
    used = function(s, w)
        if w.nam == "extinguisher" and s.fire and not s.firefixed then
            es.walkdlg("lysanov.fixfire")
            return true
        elseif w.nam == "extinguisher" then
            return "Сомневаюсь, что им поможет второй огнетушитель."
        elseif w.nam == "cutter" and not s.fire and not s.firefixed then
            s.fire = true
            es.walkdlg("lysanov.fire")
            return true
        elseif w.nam == "cutter" and s.fire and not s.firefixed then
            return "Резаком тут не поможешь, будет лишь новое возгорание."
        elseif w.nam == "cutter" and s.firefixed then
            return "Лучше обойтись без плазменного резака."
        elseif w.nam == "stick" then
            s.done = true
            enable "#deck"
            es.walkdlg("lysanov.open_door")
            return true
        end
    end
}

es.obj {
    nam = "crackdoor",
    cnd = "(not {lysanov}.fire or {lysanov}.firefixed) and {mitsukin}.done and not {lysanov}.done",
    dsc = "{дверь} в какой-то отсек, пытаясь отжать её от стены пустым огнетушителем.",
    act = "Голыми руками здесь ничего не сделаешь.",
    used = function(s, w)
        return all.lysanov:used(w)
    end
}

es.obj {
    nam = "fire2",
    cnd = "{lysanov}.fire and not {lysanov}.firefixed",
    dsc = "Из щели над дверью вырываются коптящие языки {пламени}.",
    act = "Без огнетушителя здесь не обойтись.",
    used = function(s, w)
        if w.nam == "extinguisher" then
            all.lysanov.firefixed = true
            return "Я поливаю пламя мощной струёй пены, которая шипит, расползается, точно зараза, по стене и быстро испаряется. Огонь гаснет."
        elseif w.nam == "cutter" then
            return "Вряд ли можно потушить огонь с помощью плазменного резака."
        end
    end
}

es.obj {
    nam = "deckdoor",
    cnd = "{lysanov}.done and not {deck}.done",
    dsc = "^^Заклинившую {дверь в рубку} получилось отжать от стены.",
    act = "Теперь здесь можно пролезть.",
    used = function(s, w)
        if w.nam == "extinguisher" then
            return "Здесь ничего не горит."
        elseif w.nam == "stick" then
            return "Мы уже сдвинули дверь на достаточное расстояние, в отсек теперь можно пролезть."
        elseif w.nam == "cutter" and all.lysanov.fire then
            return "Один раз я это уже попробовал, и пришлось пожар тушить."
        elseif w.nam == "cutter" then
            return "Зачем это делать? Проход в отсек уже открыт."
        end
    end
}
-- endregion

-- region alexin_scene
es.room {
    nam = "alexin_scene",
    noinv = true,
    pic = "station/body",
    disp = "Коридор",
    dsc = [[Я стараюсь не думать о том, что человек, с которым я недавно вместе искал ошибки в работе лабораторных модулей, теперь мёртв. Меня даже не пугает, что я мог бы оказаться на его месте. Меня пугает то, что я остался жив, что теперь мне придётся что-то делать, а я даже не знаю -- что.
    ^Я опускаюсь на колени, касаюсь полиэтилена и тут же отдёргиваю руку. Нет, я не могу больше смотреть в его мёртвые глаза.]],
    next = "redcor1"
}
-- endregion

-- region deck
es.room {
    nam = "deck",
    done = false,
    pic = "station/deck",
    disp = "Рубка",
    dsc = [[Рубка пострадала куда меньше коридора -- то ли стены здесь крепче, чем в других отсеках, то ли таково было направление удара.]],
    obj = { "destruction", "terminals", "body" },
    way = {
        path { "Выйти", "redcor1" }
    }
}

es.obj {
    nam = "destruction",
    dsc = "Пару ламп полопались. Судя по подпалинам на потолке, небольшие {возгорания} здесь были тоже.",
    act = "К счастью, огонь не перекинулся на технику."
}

es.obj {
    nam = "terminals",
    dsc = "Однако даже терминалы, выстроенные полукругом перед тремя креслами, по-прежнему работают.",
    act = "По экранам бегут угрожающие сообщения об ошибках."
}

es.obj {
    nam = "body",
    branch = "body",
    dsc = "В одном из кресел сидит {мужчина}, на нас он никак не реагирует и смотрит в мерцающий монитор.",
    act = function(s)
        all.deck.done = true
        es.walkdlg("mitsukin.body")
        return true
    end
}
-- endregion

-- region redcor2
es.room {
    nam = "redcor2",
    pic = "station/corridor_red3",
    disp = "Коридор",
    dsc = [[От криков, стонов, треска проводки идёт кругом голова. Ноги подгибаются от усталости, под череп словно заливают расплавленный свинец.]],
    onexit = function(s, t)
        if t.nam == "redcor3" and 
            not (all.deck.done and all.minaeva.done and all.kofman.done) then
            p "Я делаю несколько шагов и останавливаюсь. Сантори зло светит в глаза. Надо сначала помочь пострадавшим, я не могу просто взять и уйти."
            return false
        end
    end,
    obj = {
        "hangings",
        "flinders",
        "bendpanel",
        "cutter",
        "bloodspot",
        "fire3",
        "minaeva",
        "injured_person",
        "kofman",
        "wreck",
        "dying_person"
    },
    way = {
        path { "К лестничной клетке", "redcor1" },
        path { "К лаборатории", "redcor3" }
    }
}

es.obj {
    nam = "hangings",
    done = false,
    dsc = function(s)
        if not s.done then
            return "Потолок здесь словно пробило молотом -- над головой ощерилась огромная чёрная дыра, из которой свисает запутавшаяся в проводах решётчатая {панель}."
        else
            return "{Дыра} в потолоке такая большая и чёрная, что кажется, что корпус станции пробило насквозь."
        end
    end,
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("crowd.hangings")
            return true
        else
            return "Лучше держаться от неё подальше."
        end
    end
}

es.obj {
    nam = "flinders",
    dsc = "Под ногами {что-то} хрустит, как скорлупа.",
    act = "Куски изоляции, разбитые плафоны, раскрошившиеся пластиковые детали -- весь пол здесь завален этим мусором."
}

es.obj {
    nam = "bendpanel",
    examed = false,
    cnd = "not s.examed",
    dsc = "Я задеваю за что-то ногой, опускаю глаза. Под куском сорванной обшивки лежит {какой-то предмет}.",
    act = function(s)
        s.examed = true
        return "Я не сразу решаюсь приподнять кусок обшивки -- мало ли, что я там найду. Наконец отбрасываю его мыском. Под ним прячется плазменный резак."
    end
}

es.obj {
    nam = "cutter",
    disp = es.tool "Плазменный резак",
    cnd = "{bendpanel}.examed",
    dsc = "В куче мусора валяется брошенный {плазменный резак}.",
    tak = "Я поднимаю резак.",
    inv = [[Обычный плазменный резак. Судя по индикации на баллоне, газа ещё много.]]
}

es.obj {
    nam = "bloodspot",
    done = false,
    dsc = "На переборке под иллюминатором темнеет {кровавое пятно}, от которого тянется к полу длинная дорожка.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("crowd.loneman")
            return true
        else
            return "Тяжело на это смотреть."
        end
    end
}

es.obj {
    nam = "fire3",
    done = false,
    cnd = "not s.done",
    dsc = "Рядом прямо на полу полыхает {пламя} -- видимо, горит какой-то разлившийся конденсат.",
    act = "Тут потребуется огнетушитель.",
    used = function(s, w)
        if w.nam == "extinguisher" then
            s.done = true
            return "Я заливаю пол пеной из огнетушителя, и огонь гаснет."
        end
    end
}

es.obj {
    nam = "minaeva",
    ask = false,
    done = false,
    dsc = "{Минаева} заботится об очередном пострадавшем",
    act = function(s)
        if s.done then
            return "Лучше ей не мешать."
        elseif not s.ask then
            s.ask = true
            es.walkdlg("minaeva.task1")
            return true
        elseif s.ask and not have("pills") then
            es.walkdlg("minaeva.task2")
            return true
        elseif s.ask and have("pills") then
            purge("pills")
            s.done = true
            es.walkdlg("minaeva.done")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "pills" then
            return s:act()
        end
    end
}

es.obj {
    nam = "injured_person",
    done = false,
    dsc = "-- {женщине средних лет} с перепачканными кровью волосами, которая смотрит на разрушенный коридор безумным взглядом.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("crowd.madwoman")
            return true
        else
            return "Мне кажется, она не в себе. Впрочем, это не удивительно после произошедшего."
        end
    end,
    used = function(s, w)
        if w.nam == "pills" then
            return "Лучше отдать таблетки Минаевой."
        end
    end
}

es.obj {
    nam = "kofman",
    done = false,
    ask = false,
    cnd = "not {kofman}.done",
    dsc = "Чуть дальше, отступая в тень, которая растёт и крепнет по мере того, как становится меньше источников света, стоит на коленях {Кофман} и пытается поднять толстый кусок арматурной сетки, вывалившейся из расколотой стены.",
    act = function(s)
        if not s.ask then
            s.ask = true
            es.walkdlg("kofman.help")
        else
            es.walkdlg("kofman.chat")
        end
        return true
    end,
    used = function(s, w)
        if w.nam == "stick" then
            return "Может, с помощью этой штуки получится приподнять арматурную решётку."
        elseif w.nam == "cutter" then
            return "Можно попробовать аккуратно срезать часть придавившей человека решётки."
        end
    end
}

es.obj {
    nam = "wreck",
    tool = false,
    cnd = "not {kofman}.done",
    dsc = "Под {сеткой} кто-то лежит.",
    act = "Голыми руками тут ничего не сделаешь. Надо что-нибудь придумать.",
    used = function(s, w)
        if w.nam == "stick" then
            es.walkdlg("kofman.stick")
        elseif w.nam == "cutter" then
            all.kofman.done = true
            es.walkdlg("kofman.cutter")
        end
        return true
    end
}

es.obj {
    nam = "dying_person",
    cnd = "not {kofman}.done",
    dsc = "Я вдруг понимаю, что именно {этот человек} и кричал, но сил у него теперь не осталось даже на крик.",
    act = "Он никак на меня не реагирует."
}
-- endregion

-- region nearstair
es.room {
    nam = "nearstair",
    pic = "station/corridor_red4",
    disp = "У лестничной клетки",
    dsc = [[Разрушений у лестничной клетки меньше, но с потолка, сквозь длинные, точно прорезанные автогеном щели, всё равно свисает проводка. Пару ламп ещё чудом горит, подкрашивая красным стены.]],
    obj = { "deadwires", "firebox", "extinguisher_holder", "baddoor" },
    way = {
        path { "На лестничную клетку", "stair" },
        path { "Вглубь коридора", "redcor1" }
    }
}

es.obj {
    nam = "deadwires",
    dsc = "От вида {вырванных с мясом проводов} становится не по себе.",
    act = "Видимо, большая часть электрики на этом уровне перестала работать."
}

es.obj {
    nam = "firebox",
    unlocked = false,
    dsc = "У стены притулился {короб} яркого пожарного цвета.",
    act = function(s)
        if not s.unlocked then
            s.unlocked = true
            return "Я открываю дверцу короба."
        else
            s.unlocked = false
            return "Я закрываю короб."
        end
    end,
    used = function(s, w)
        if w.nam == "extinguisher" then
            purge("extinguisher")
            all.extinguisher_holder.taken = false
            return "Я кладу огнетушитель обратно в короб."
        end
    end
}

es.obj {
    nam = "extinguisher_holder",
    taken = false,
    cnd = "{firebox}.unlocked and not s.taken",
    dsc = "Внутри валяется сорвавшийся с крюков химический {огнетушитель}. Больше ничего нет.",
    act = function(s)
        s.taken = true
        take("extinguisher")
        return "Я беру огнетушитель."
    end
}

es.obj {
    nam = "extinguisher",
    disp = es.tool "Огнетушитель",
    inv = "Корпус немного помялся, но с огнетушителем всё в порядке."
}

es.obj {
    nam = "baddoor",
    unlocked = false,
    dsc = "Гидравлическая {дверь}, ведущая к лестница, открыта.",
    act = "Хорошо хоть эту дверь не заблокировало."
}
-- endregion

-- region stair
es.room {
    nam = "stair",
    pic = "station/staircase",
    disp = "Лестничная клетка",
    dsc = [[Света на лестничной клетке по-прежнему нет, и если бы не выломанная дверь в коридор, я бы ничего не смог разглядеть.]],
    onexit = function(s, t)
        if t.nam == "main" and not all.meds.taken then
            p "Стоит сначала осмотреться."
            return false
        elseif t.nam == "main" and all.meds.taken then
            p "Кажется, я нашёл нужные таблетки."
            return false
        end
    end,
    obj = { "meds" },
    way = {
        path { "На нижний уровень", "main" },
        path { "В коридор", "nearstair" }
    }
}

es.obj {
    nam = "meds",
    examed = false,
    taken = false,
    cnd = "not s.taken",
    dsc = function(s)
        if not s.examed then
            return "Под ногами лежит {что-то блестящее}."
        else
            return "Под ногами валяется {блистер} с таблетками."
        end
    end,
    act = function(s)
        if not s.examed then
            s.examed = true
            return "Похоже, это блистер с таблетками."
        else
            s.taken = true
            take("pills")
            return "Я поднимаю блистер."
        end
    end
}

es.obj {
    nam = "pills",
    disp = es.tool "Блистер с таблетками",
    inv = "Блистер с таблетками -- обезболивающее."
}
-- endregion

-- region redcor3
es.room {
    nam = "redcor3",
    mus = false,
    pic = "station/corridor_red5",
    disp = "Коридор у лаборатории",
    dsc = [[Я неторопливо бреду на ватных ногах, не слишком понимая, что собираюсь делать. В ушах стоит звон от голосов.]],
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("juxtaposition", 2)
        end
    end,
    onexit = function(s, t)
        if t.nam == "lab_hall" and not all.labdoor.unlocked then
            p "Дверь закрыта, у меня должна быть с собой карта доступа. Надеюсь, я её не потерял."
            return false
        end
    end,
    obj = { "lowdebris", "santory", "labdoor", "card_search" },
    way = {
        path { "К рубке", "redcor2" },
        path { "В лабораторию", "lab_hall" }
    }
}

es.obj {
    nam = "lowdebris",
    dsc = "{Разрушений} в этой части коридора меньше. Правда воздух заполнен едкой гарью, и большинство ламп полопалось.",
    act = "Кажется, стоит сделать ещё несколько шагов, и этот кошмар закончится, станция восстановится, загрузится из резервной копии, в коридоре появятся беззаботные люди, которые будет приветствовать меня улыбкой."
}

es.obj {
    nam = "santory",
    dsc = "Здесь было бы совсем темно, если бы не {Сантори}, которая насквозь прорезает станцию лучами, оставляя на стенах ровные, точно выверенные по линейке, цветные тени.",
    act = "Местная звезда будто бы хочет испепелить станцию. Нам здесь не рады."
}

es.obj {
    nam = "labdoor",
    examed = false,
    unlocked = false,
    dsc = "{Дверь} в лабораторию выглядит неповреждённой.",
    act = function(s)
        if s.unlocked then
            return "Огонёк на магнитном замке светится зелёным."
        else
            s.examed = true
            return "Дверь закрыта, но где-то у меня должна быть карта."
        end
    end,
    used = function(s, w)
        if w.nam == "extinguisher" then
            return "Здесь ничего не горит."
        elseif w.nam == "stick" or w.nam == "cutter" then
            return "Зачем? Где-то у меня должна быть ключ-карта."
        elseif w.nam == "mycard" and not s.unlocked then
            s.unlocked = true
            return "Я открываю дверь картой -- замок издаёт сердитый гудок, и красный огонёк на нём сменяется на зелёный."
        elseif w.nam == "mycard" then
            return "Дверь уже открыта."
        end
    end
}

es.obj {
    nam = "card_search",
    cnd = "{labdoor}.examed and not have('mycard')",
    dsc = es.para "{Я ощупываю} карманы в поисках ключ-карты.",
    act = function(s)
        take("mycard")
        return "Слава богу, карту я не потерял."
    end
}

es.obj {
    nam = "mycard",
    disp = es.tool "Ключ-карта",
    inv = "Моя ключ-карта, должна подойти к двери в лабораторию."
}
-- endregion

-- region lab_hall
es.room {
    nam = "lab_hall",
    pic = "station/hall_bright",
    disp = "Холл",
    dsc = [[Освещение в холле лаборатории работает, и свет кажется таким ярким, что я даже прикрываю ладонью глаза.]],
    onenter = function(s, t)
        if all.lab_main.done and not all.mitsukin2.nubolids then
            all.mitsukin2.nubolids = true
            es.walkdlg {
                dlg = "mitsukin",
                branch = "nubolids",
                pic = "station/hall",
                disp = "Холл"
            }
            return false
        end
    end,
    onexit = function(s, t)
        if t.nam == "redcor3" and all.lab_main.done then
            p "Я думаю, что стоит сначала поговорить с Мицюкиным."
            return false
        end
    end,
    obj = { "santory5", "mitsukin2", "vera7" },
    way = {
        path { "В инженерный отсек", "lab_tech" },
        path { "В лабораторию", "lab_main" },
        path { "В коридор", "redcor3" }
    }
}

es.obj {
    nam = "santory5",
    locked = false,
    dsc = function(s)
        if s.locked and not all.mitsukin2.nubolids then
            return "Огромный панорамный иллюминатор закрыт плотной металлической шторой, не пропускающей свет -- теперь можно представить на мгновение, что ничего не случилось, что вяло течёт обычный скучный день на орбитальной ситуации, а я просто проснулся после кошмарного сна."
        elseif s.locked then
            return "Огромный панорамный иллюминатор закрыт плотной металлической шторой, не пропускающей свет."
        else
            return "В огромном панорамном иллюминаторе переливается синевой {Сантори-5} -- ослепительная, точно невероятная луна."
        end
    end,
    act = function(s)
        if s.locked then
            return "Я не хочу открывать иллюминатор, я боюсь смотреть на планету."
        elseif all.mitsukin2.nubolids then
            return [[От поверхности тянутся десятки протуберанцев -- планета, точно народившаяся звезда, испускает в темноту смертоносные лучи. Это пугает до дрожи и в то же время как-то необъяснимо красиво, будто бы посреди творящегося хаоса и смерти рождается новая жизнь.]]
        else
            s.locked = true
            return [[От поверхности тянутся десятки протуберанцев -- планета, точно народившаяся звезда, испускает в темноту смертоносные лучи. Это пугает до дрожи и в то же время как-то необъяснимо красиво, будто бы посреди творящегося хаоса и смерти рождается новая жизнь.
            ^Я смотрю в иллюминатор долго, как в трансе, пока рука сама не находит на стене переключатель, и опустившаяся металлическая штора скрывает бушующую планету.]]
        end
    end
}

es.obj {
    nam = "mitsukin2",
    nubolids = false,
    cnd = "{lab_main}.done",
    dsc = "{Мицюкин} стоит у выхода в коридор и о чём-то разговаривает с Михаилом.",
    act = function(s)
        if not s.nubolids then
            s.nubolids = true
            es.walkdlg("mitsukin.nubolids")
        else
            es.walkdlg("mitsukin.end")
        end
        return true
    end
}

es.obj {
    nam = "vera7",
    done = false,
    cnd = "{lab_main}.done",
    dsc = "{Вера} подошла к иллюминатору.",
    act = function(s)
        if s.done then
            return "Стоит пока оставить её одну."
        elseif all.santory5.locked then
            s.done = true
            es.walkdlg("vera.final_locked")
            return true
        else
            s.done = true
            es.walkdlg("vera.final")
            return true
        end
    end
}
-- endregion

-- region lab_main
es.room {
    nam = "lab_main",
    done = false,
    pic = "station/lab",
    disp = "Лаборатория",
    dsc = [[В лаборатории на удивлении спокойно и тихо, её почти не коснулась пронёсшаяся по станции волна разрушений.]],
    obj = { "nubolids", "labcomp" },
    way = {
        path { "Выйти", "lab_hall" }
    }
}

es.obj {
    nam = "nubolids",
    dsc = "{Камера с нуболидами} задёрнута тенью, скрывающей её обитателей от глаз.",
    act = function(s)
        if not all.lab_main.done then
            all.lab_main.done = true
            walkin("interlude11")
            return true
        else
            return "Я уже насмотрелся на нуболидов."
        end
    end
}

es.obj {
    nam = "labcomp",
    dsc = "На экране {терминала} рядом с камерой истерически дёргаются какие-то сообщения.",
    act = function(s)
        walkin("lab.terminal")
        return true
    end,
    used = function(s, w)
        if w.nam == "mycard" then
            return "Терминал издаёт негодующий гудок -- доступ мне прописать так и не успели."
        end
    end
}

es.terminal {
    nam = "lab.terminal",
    welcome = [[Внимание! Критическая ошибка! Нарушены условия содержания в камере!]]
}
-- endregion

-- region lab_tech
es.room {
    nam = "lab_tech",
    pic = "station/tech",
    disp = "Инженерный отсек",
    dsc = [[Я захожу в инженерный отсек, и в груди что-то болезненно сжимается. Здесь темно, свет наполовину вышел. Слышно, как пощёлкивает в полумраке работающий терминал.]],
    obj = { "modules", "alexin_terminal", "my_terminal" },
    way = {
        path { "Выйти", "lab_hall" }
    }
}

es.obj {
    nam = "modules",
    dsc = "{Стойку с модулями} не трогали с тех пор, как я занимался диагностикой.",
    act = "Даже провод, которым я соединял пятый и шестой модули, до сих пор торчит из разъёмов, свешиваясь до самого пола."
}

es.obj {
    nam = "alexin_terminal",
    dsc = "{Терминал Алексина} не подаёт признаков жизни.",
    act = "Судя по заплывшему угольной чернотой экрану, включить его уже не получится.",
    used = function(s, w)
        if w.nam == "mycard" then
            return "Терминал мёртв, да и моя карта в любом случае не дала бы к нему доступа."
        end
    end
}

es.obj {
    nam = "my_terminal",
    dsc = "А вот экран на {моём} светится так, словно я оставил рабочее место несколько секунд назад.",
    act = function(s)
        walkin("comp.terminal")
        return true
    end,
    used = function(s, w)
        if w.nam == "mycard" then
            return "Терминал издаёт негодующий гудок -- доступ мне прописать так и не успели."
        end
    end
}

es.terminal {
    nam = "comp.terminal",
    locked = function(s)
        return true
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
    commands = {
        circ = true,
        volt = true,
        elock = true,
        readlog = true,
        diag = true,
        read = true,
        files = true,
        modres = true,
        status = true
    }
}
-- endregion

-- region interlude11
es.room {
    nam = "interlude11",
    noinv = true,
    pic = "common/nubolids2",
    disp = "Лаборатория",
    dsc = [[Кажется, нуболиды чувствуют моё присутствие. Они сплетаются в огромный клубок, похожий на кровавое щупальце и бьют по стеклу, размахиваются, снова бьют, с нарастающим темпом, с какой-то бешеной яростью пытаются проломить разделяющий нас заслон.
    ^Через несколько секунд они останавливаются, щупальце замирает, расплетается мириадой красных нитей и начинает плавно, как под воздействием невидимых волн, складываться во что-то похожее на человеское лицо.
    ^Я не выдерживаю, щёлкаю переключателем, и на нуболидов падает чёрная тень.]],
    enter = function(s)
        es.music("santorum")
    end,
    next = "lab_main"
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    onenter = function(s)
        gamefile("game/11.lua", true)
    end
}
-- endregion
