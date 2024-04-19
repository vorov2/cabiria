-- Chapter 10
dofile "lib/es.lua"

es.main {
    chapter = "11",
    onenter = function(s)
        es.music("rush")
        walkin("intro1")
    end
}

-- region intro1
es.room {
    nam = "intro1",
    noinv = true,
    pause = 50,
    next = "intro2"
}
-- endregion

-- region intro2
es.room {
    nam = "intro2",
    seconds = 41,
    pic = "common/station",
    enter = function(s)
        timer:set(1000)
    end,
    timer = function(s)
        s.seconds = s.seconds - 1
        if s.seconds == 36 then
            es.stopMusic(4000)
            timer:stop()
            walkin("med1")
        end
        return true
    end,
    obj = { "clock" }
}

es.obj {
    nam = "clock",
    txt = "НИОС \"Кабирия\"^^",
    dsc = function(s)
        return string.format("%sОсталось до схода с орбиты: 04:18:%d", s.txt, all.intro2.seconds)
    end
}
-- endregion

-- region med1
es.room {
    nam = "med1",
    mus = false,
    pic = "station/med1",
    disp = "Медотсек 01",
    dsc = [[Белые стены медотсека давят, не дают дышать. Если долго смотришь в одну точку, всё вокруг рассеивается в предобморочном шуме, и глаза заливает белизна.]],
    preact = function(s)
        if not s.mus then
            s.mus = true
            es.music("juxtaposition", 3, 0, 3000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "reception" and not all.minaeva.task then
            es.walkdlg("minaeva.noexit1")
            return false
        elseif t.nam == "reception" and all.minaeva.task and not all.minaeva.done then
            es.walkdlg("minaeva.noexit2")
            return false
        end
    end,
    obj = {
        "bandage",
        "thirsty",
        "bottles",
        "trash",
        "meds",
        "antiseptic",
        "minaeva",
        "andreev"
    },
    way = {
        path { "Выйти", "reception" }
    }
}

es.obj {
    nam = "bandage",
    cnd = "not {minaeva}.done",
    dsc = "Я сижу у стены с {перебинтованной головой}. В ушах звенит, как после контузии.",
    act = "Повязку у меня на голове сменили, а перед этим залили рану едким медицинским клеем, из-за чего теперь кажется, что череп у меня расходится трещинами, как битый шар для боулинга."
}

es.obj {
    nam = "thirsty",
    cnd = "{bottle}.full == 3",
    dsc = "{Горло} воспалилось от жажды.",
    act = "Нужен хотя бы глоток воды."
}

es.obj {
    nam = "bottles",
    taken = false,
    dsc = [[На полу валяется разодранная полиэтиленовая {пачка бутылок} с обогащённой кислородом водой, которую, видимо, притащили с "Грозного".]],
    act = function(s)
        if not s.taken then
            s.taken = true
            take("bottle")
            return "Я вытаскиваю из пачки бутылку."
        else
            return "Стоит поберечь воду."
        end
    end
}

es.obj {
    nam = "bottle",
    full = 3,
    disp = es.tool "Бутылка воды",
    inv = function(s)
        if s.full == 0 then
            return "Бутылка пуста."
        end
        s.full = s.full - 1
        if s.full == 2 then
            return "Я жадно присасываюсь к бутылке. Со стороны, наверное, можно подумать, что я не пил несколько дней."
        elseif s.full == 1 then
            return "Я делаю ещё несколько глотков."
        elseif s.full == 0 then
            return "Быстро, судорожными глотками я допиваю содержимое бутылки."
        end
    end
}

es.obj {
    nam = "trash",
    dsc = "Рядом с ней примостился мусорный {контейнер}, доверху заваленный окровавленными бинтами.",
    act = "Нет у меня желания разглядывать его содержимое.",
    used = function(s, w)
        if w.nam == "bottle" and w.full > 0 then
            return "В бутылке ещё есть вода, зачем её выбрасывать?"
        elseif w.nam == "bottle" then
            purge("bottle")
            return "Я бросаю пустую бутылку в контейнер."
        end
    end
}

es.obj {
    nam = "meds",
    need = false,
    found = false,
    dsc = "Чуть дальше от меня, на шатком столике, стоит открытый металлический {ящик} с множеством склянок.",
    act = function(s)
        if not all.minaeva.task then
            return "Мне там ничего не нужно."
        elseif not s.found then
            s.found = true
            return "Я долго копаюсь в содержимом ящика, прежде чем мне попадается маленький пузырёк с антисептиком."
        else
            return "Сколько же здесь лекарств!"
        end
    end
}

es.obj {
    nam = "antiseptic",
    taken = false,
    cnd = "{meds}.found",
    disp = es.tool "Антисептик",
    dsc = "{Пузырёк с антисептиком} -- броский из-за яркой оранжевой этикетки -- провалился на самое дно ящика.",
    inv = "Пузырёк с антисептиком, надо отдать его Минаевой.",
    tak = function(s)
        s.taken = true
        return "Я беру пузырёк с антисептиком."
    end
}

es.obj {
    nam = "minaeva",
    task = false,
    done = false,
    simonova = false,
    dsc = "^{Минаева} прижигает каким-то вонючим раствором рану на голове",
    act = function(s)
        if s.done and (not all.simonova.done or s.simonova) then
            return "Ей и без меня есть чем заняться."
        elseif all.bottle.full == 3 then
            return "Горло у меня едва не кровоточит, надо сделать хотя бы пару глотков воды."
        elseif all.simonova.done and not s.simonova then
            s.simonova = true
            es.walkdlg("minaeva.simonova")
            return true
        elseif s.task and not s.done then
            es.walkdlg("minaeva.noexit2")
        else
            s.task = true
            es.walkdlg("minaeva.task")
            return true
        end
    end,
    used = function(s, w)
        if w.nam == "bottle" then
            es.walkdlg("minaeva.bottle")
            return true
        elseif w.nam == "antiseptic" then
            s.done = true
            purge("antiseptic")
            es.walkdlg("minaeva.antiseptic")
            return true
        end
    end
}

es.obj {
    nam = "andreev",
    dsc = "{Андреева}, которого перед этим щедро напичкали обезболивающим, и он вперился в стену мутным взглядом, как слепой или контуженный.",
    act = "Он никак на меня не реагирует.",
    used = function(s, w)
        if w.nam == "bottle" then
            return "Никакой реакции. Сколько же ему вкололи?"
        elseif w.nam == "antiseptic" then
            return "Лучше отдать это Минаевой."
        end
    end
}
-- endregion

-- region reception
es.room {
    nam = "reception",
    stage = false,
    mus = false,
    pic = "station/medhall",
    disp = "Приёмная",
    dsc = function(s)
        if not s.stage then
            return [[Приёмная заполнена людьми. Я будто оказался в поликлинике в шумный рабочий день.]]
        else
            return [[В приёмной стало спокойнее, можно подумать, что в медблоке начался тихий час. Я и сам не понимаю, что ещё здесь делаю.]]
        end
    end,
    enter = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("whatif", 2, 0, 3000)
        end
    end,
    onexit = function(s, t)
        if t.nam == "med2" and not s.stage then
            p "Не думаю, что будет вежливо проталкиваться ко входу в отсек, где мне к тому же ничего не нужно."
            return false
        elseif t.nam == "interlude1" and not s.stage then
            s.stage = true
            es.walkdlg("majorov.argue")
            return false
        elseif t.nam == "interlude1" and s.stage and not all.vera.done then
            all.vera.done = true
            es.walkdlg("vera.wait")
            return false
        elseif t.nam == "interlude1" then
            es.walkdlg("vera.wait2")
            return false
        end
    end,
    obj = {
        "majorov",
        "mitsukin",
        "trash2",
        "simonova",
        "vera"
    },
    way = {
        path { "В коридор", "interlude1" },
        path { "В медотсек 01", "med1" },
        path { "В медотсек 02", "med2" },
        path { "В медотсек 03", "med3" }
    }
}

es.obj {
    nam = "majorov",
    cnd = "not {reception}.stage",
    dsc = "{Майоров}",
    act = "Он так увлечён спором, что даже меня не замечает."
}

es.obj {
    nam = "mitsukin",
    cnd = "not {reception}.stage",
    dsc = "и {Мицюкин} шумно спорят о чём-то у выхода в коридор, и на них раздражённо поглядывают другие посетители.",
    act = "Честно говоря, нет у меня желания вступать в перепалку с Мицюкиным."
}

es.obj {
    nam = "trash2",
    dsc = "На скамейке напротив {урны}",
    act = "Нет у меня желания туда заглядывать.",
    used = function(s, w)
        if w.nam == "bottle" and w.full > 0 then
            return "В бутылке ещё есть вода, зачем её выбрасывать?"
        elseif w.nam == "bottle" then
            purge("bottle")
            return "Я бросаю пустую бутылку в контейнер."
        end
    end
}

es.obj {
    nam = "simonova",
    task = false,
    done = false,
    dsc = "сидит {Симонова}, прикрывая ладонью лицо.",
    act = function(s)
        if not s.task then
            s.task = true
            es.walkdlg("simonova.med")
        elseif not all.patient.done and s.task then
            es.walkdlg("simonova.wait")
        elseif all.patient.done and not s.done then
            s.done = true
            es.walkdlg("simonova.patient")
        else
            es.walkdlg("simonova.notalk")
        end
        return true
    end
}

es.obj {
    nam = "vera",
    done = false,
    dsc = function(s)
        if not all.reception.stage then
            return "{Вера} о чём-то перешёптывается с Ефимовой у двери во второй медотсек, поддерживая её за локоть."
        else
            return "Ефимова ушла, и {Вера} нервно расхаживает у двери во второй медотсек."
        end
    end,
    act = function(s)
        if not all.reception.stage then
            return "Не стоит ей пока мешать."
        else
            s.done = true
            es.walkdlg("vera.investigation")
            return true
        end
    end
}
-- endregion

-- region med2
es.room {
    nam = "med2",
    pic = "station/med2",
    disp = "Медотсек 02",
    dsc = [[Во втором медотсеке стоит гул от работающих аппаратов.]],
    obj = { "machine", "efimova" },
    way = {
        path { "Выйти", "reception" }
    }
}

es.obj {
    nam = "machine",
    done = false,
    dsc = "В {капсуле для плазмофереза} кто-то лежит.",
    act = function(s)
        s.done = true
        return "Я подхожу ближе и узнаю в прозрачном забрале лицо Кофмана."
    end
}

es.obj {
    nam = "efimova",
    dsc = "{Ефимова} внимательно наблюдает за скачущими показаниями на экране.",
    act = function(s)
        es.walkdlg("efimova.head")
        return true
    end
}
-- endregion

-- region med3
es.room {
    nam = "med3",
    mus = false,
    pic = "station/med3",
    disp = "Медотсек 03",
    dsc = [[Я решаю заглянуть в третий медотсек. Внутри -- всё та же обжигающая белизна.]],
    enter = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("tragedy", 2)
        end
    end,
    obj = { "patient", "patient2", "sinitsin" },
    way = {
        path { "Выйти", "reception" }
    }
}

es.obj {
    nam = "patient",
    done = false,
    branch = "patient",
    dsc = "На койке лежит {перебинтованный человек}, из руки которого торчит катетер. Экран рядом с кроватью показывает сбивчивый сердечный ритм, похожий на сейсмические колебания.",
    act = function(s)
        es.walkdlg("sinitsin.patient")
        return true
    end
}

es.obj {
    nam = "patient2",
    dsc = "{Ещё один} пострадавший сидит у стены,",
    act = "Лицо его кажется мне смутно знакомым, но я не могу вспомнить, где его видел."
}

es.obj {
    nam = "sinitsin",
    done = false,
    dsc = "и {Синицын} из лаборатории накладывает ему повязку на руку.",
    act = function(s)
        if not s.done then
            s.done = true
            es.walkdlg("sinitsin.med")
        else
            es.walkdlg("sinitsin.notalk")
        end
        return true
    end
}
-- endregion

-- region interlude1
es.room {
    nam = "interlude1",
    pic = "station/corridor4",
    disp = "Коридор",
    dsc = [[Разговор с Мицюкиным тяготит, точно проклятие, утягивает в темноту, которая и так преследует нас с каждым шагом. Всё, что мы делаем с Верой, может оказаться бессмысленным, если оператор в рубке ошибётся -- или люди в машинном отделении не справятся с починкой, не смогут оживить основные двигательные блоки.
    ^Я бреду по коридору, как зомби.
    ^Вера дёргает меня за рукав.]],
    enter = function(s)
        es.music("doom", 1, 0, 3000)
    end,
    next = function(s)
        purge("bottle")
        es.walkdlg {
            dlg = "vera",
            branch = "gather",
            disp = "Коридор"
        }
    end
}
-- endregion

-- region pause1
es.room {
    nam = "pause1",
    noinv = true,
    pause = 60,
    enter = function(s)
        es.stopMusic(4000)
    end,
    next = function(s)
        es.walkdlg {
            dlg = "vera",
            branch = "chem",
            disp = "Химическая лаборатория",
            pic = "station/chem1"
        }
    end
}
-- endregion

-- region chem1
es.room {
    nam = "chem1",
    mus = false,
    pic = "station/chem1",
    disp = "Химическая лаборатория",
    dsc = [[Помещение лаборатории ненамного больше личных модулей, и здесь тесно даже вдвоём. Дышать почти нечем, хотя воздуховоды работают, и шею холодит лёгкий ветерок. Возможно, во всём виноват стойкий и едкий запах, словно здесь что-то растворяли в кислоте. Не представляю, как можно работать в такой обстановке весь день, а Вера провела здесь два года.]],
    onexit = function(s, t)
        if t.nam == "chem_corridor" then
            es.walkdlg("vera.needbreak")
            return false
        end
    end,
    enter = function(s)
        if not s.mus then
            s.mus = true
            es.music("lotus", 2)
        end
    end,
    obj = {
        "vera2",
        "photo",
        "comp",
        "analyzer",
        "desk",
        "tube1_holder",
        "tube2_holder",
        "tube3_holder",
        "filler",
        "react1",
        "react2",
        "react3",
    },
    way = {
        path { "В коридор", "chem_corridor" },
        path { "В подсобный отсек", "chem2" }
    }
}

es.obj {
    nam = "tcard",
    disp = es.tool "Ключ-карта",
    inv = "Именная ключ-карта Андрея Верховенцева."
}

es.obj {
    nam = "vera2",
    flash = false,
    branch = "midtalk",
    dsc = "{Вера} стоит, ссутулившись перед лупатым монитором, и пролистывает ритмично щёлкающими кнопками результаты химических анализов.",
    act = function(s)
        es.walkdlg("vera.midtalk")
        return true
    end,
    used = function(s, w)
        if w.kind == "tube" then
            if not w.reagent then
                es.walkdlg("vera.reagent1")
                return true
            elseif w.reagent and not w.bad then
                es.walkdlg("vera.reagent2")
                return true
            else
                es.walkdlg("vera.bad")
                return true
            end
        elseif w.nam == "tcard" then
            return "Зачем отдавать ей карту? Мне она ещё пригодится."
        elseif w.kind == "r" and not w.hide then
            es.walkdlg("vera.reagent3")
            return true
        elseif w.kind == "r" and w.hide then
            es.walkdlg("vera.reagent4")
            return true
        end
    end
}

es.obj {
    nam = "photo",
    done = false,
    dsc = "На стене рядом с ней висит в застеклённой рамке мутный {снимок} песчаного берега у спокойной реки или озера, над которой тают в омытом светом небе редкие облака.",
    act = function(s)
        if s.done then
            return "У нас нет времени на эти разговоры."
        end
        s.done = true
        es.stopMusic(2000)
        es.walkdlg("vera.photo")
        return true
    end
}

es.obj {
    nam = "comp",
    unlocked = false,
    problem = false,
    react = {
        react1 = 0,
        react2 = 2,
        react3 = 0
    },
    dsc = "^Два рабочих места разнесены по противоположным стенам так, чтобы люди у терминалов стояли друг к другу спиной. Каждому отводится узкий шатающийся столик и массивный {терминал} со встроенным химическим",
    act = function(s)
        s.unlocked = false
        walkin("chem.terminal")
        return true
    end,
    used = function(s, w)
        if w.kind == "tube" then
            return "Пробирку нужно вставить в анализатор."
        elseif w.nam == "tcard" then
            s.unlocked = true
            walkin("chem.terminal")
            return true
        end
    end
}

es.obj {
    nam = "analyzer",
    tube = false,
    dsc = function(s)
        if not s.tube then
            return "{анализатором}."
        else
            return "анализатором (сейчас в него вставлена {пробирка с пометкой \""
                .. _(s.tube):dsc() .. "\"})."
        end
    end,
    act = function(s)
        if not s.tube then
            return "Сюда нужно вставить пробирку."
        else
            take(s.tube)
            local tn = s.tube
            s.tube = false
            return string.format("Я достаю пробирку \"%s\" из анализатора.", _(tn):dsc())
        end
    end,
    used = function(s, w)
        if w.kind == "tube" and s.tube then
            return "В анализаторе уже стоит пробирка."
        elseif w.kind == "tube" and w.reagent then
            return "Судя по цвету воды в пробирке, я уже проводил её анализ."
        elseif w.kind == "tube" then
            s.tube = w.nam
            purge(w.nam)
            return string.format("Я вставляю пробирку \"%s\" в анализатор.", w:dsc())
        end
    end
}

es.obj {
    nam = "desk",
    tubes = {
        "tube1_holder",
        "tube2_holder",
        "tube3_holder"
    },
    takenCount = function(s)
        local count = 0
        for i,v in ipairs(s.tubes) do
            if _(v).taken then
                count = count + 1
            end
        end
        return count
    end,
    dsc = function(s)
        local c = s:takenCount()
        local txt = "Рядом с анализатором разместился тяжёлый металлический {штатив}"
        if c < 2 then
            return txt..", в котором стоят пробирки с пометками"
        elseif c == 2 then
            return txt..", в котором стоит пробирка с пометкой"
        else
            return txt.."."
        end
    end,
    act = "Здесь, очевидно, хранятся пробирки.",
    used = function(s, w)
        if w.kind == "tube" then
            _(w.nam.."_holder").taken = false
            purge(w.nam)
            return string.format("Я возвращаю пробирку \"%s\" в штатив.", w.dsc)
        end
    end
}

es.obj {
    nam = "tube1_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = function(s)
        local c = all.desk:takenCount()
        if c == 1 then
            return "{A} и"
        elseif c == 2 then
            return "{A}."
        else
            return "{A},"
        end
    end,
    act = function(s)
        s.taken = true
        take("tube1")
        return "Я беру пробирку с пометкой \"A\"."
    end
}

es.obj {
    nam = "tube2_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = function(s)
        local c = all.desk:takenCount()
        if c == 2 or (c == 1 and all.tube3_holder.taken) then
            return "{B}."
        elseif c == 0 or (c == 1 and all.tube1_holder.taken) then
            return "{B} и"
        end
    end,
    act = function(s)
        s.taken = true
        take("tube2")
        return "Я беру пробирку с пометкой \"B\"."
    end
}

es.obj {
    nam = "tube3_holder",
    taken = false,
    cnd = "not s.taken",
    dsc = "{C}.",
    act = function(s)
        s.taken = true
        take("tube3")
        return "Я беру пробирку с пометкой \"C\"."
    end
}

es.obj {
    nam = "filler",
    unlocked = false,
    dsc = "Сбоку на анализаторе есть {рычаг}.",
    act = function(s)
        if s.unlocked then
            s.unlocked = false
            return "Я поднимаю рычаг, и отверстия закрываются."
        else
            s.unlocked = true
            return "Я опускаю рычаг, и в аппарате открываются три круглых отверстия."
        end
    end
}

local react_template = {
    cnd = "{filler}.unlocked",
    act = function(s)
        local app = " Сейчас резервуар заполнен."
        if all.comp.react[s.nam] == 0 then
            app = " Данный резервуар пустой."
        end
        return string.format("Видимо, сюда нужно заливать реактив на %s ЕЭ/мг.", s.aff)
            .. app
    end,
    used = function(s, w)
        local tm = all.comp.react
        if w.kind == "r" and tm[s.nam] > 0 then
            return "Этот резервуар уже заполнен реактивом."
        elseif w.kind == "r" then
            drop(w.nam)
            tm[s.nam] = w.content
            all.comp.problem = false
            all.vera2.flash = true
            return "Я залил содержимое пузырька в резервуар анализатора."
        elseif w.kind == "tube" then
            return "Не стоит заливать туда содержимое пробирки."
        end
    end
}

es.obj(react_template) {
    nam = "react1",
    aff = "0.25",
    dsc = "^^Сейчас рычаг опущен, и на аппарате открыты три круглых отверстия с пометками -- {0.25},"
}

es.obj(react_template) {
    nam = "react2",
    aff = "0.35",
    dsc = "{0.35} и"
}

es.obj(react_template) {
    nam = "react3",
    aff = "0.50",
    dsc = "{0.50}."
}

local base_tube = {
    kind = "tube",
    disp = function(s)
        return es.tool(string.format("Пробирка \"%s\"", es.apply(s.dsc, s)))
    end,
    inv = function(s)
        local str = string.format("Пробирка с наклейкой \"%s\".", es.apply(s.dsc, s))
        if s.bad then
            return str.."^Вода в пробирке ярко-синяя. Вот чёрт! Видимо, я испортил образец!"
        elseif s.reagent then
            return str.."^Вода в пробирке бледно-голубого цвета -- значит реактив уже применён."
        else
            return str.."^Вода -- прозрачная, значит этот образец я пока не исследовал."
        end
    end
}

es.obj(base_tube) {
    nam = "tube1",
    bad = false,
    reagent = false,
    degas = false,
    dsc = "А",
    content = {
        ca = 14,
        mg = 3,
        n = 91,
        k = 9,
        cl = 51,
        so = 9.4,
        f = 1.1,
        hco3 = 137
    }
}

es.obj(base_tube) {
    nam = "tube2",
    bad = false,
    reagent = false,
    degas = false,
    dsc = "B",
    content = {
        ca = 11,
        mg = 4,
        n = 112,
        k = 5,
        cl = 65,
        so = 11.2,
        f = 1.9,
        hco3 = 119
    },
}

es.obj(base_tube) {
    nam = "tube3",
    bad = false,
    reagent = false,
    degas = false,
    dsc = "C",
    content = {
        ca = 7,
        mg = 6,
        n = 83,
        k = 6,
        cl = 24,
        so = 12.3,
        f = 1.2,
        hco3 = 127
    }
}

-- region chem.terminal
es.terminal {
    nam = "chem.terminal",
    locked = function(s)
        return not all.comp.unlocked
    end,
    content = {
        ["ca"] = "кальций (мг/л)",
        ["mg"] = "магний (мг/л)",
        ["n"] = "натрий (мг/л)",
        ["k"] = "калий (мг/л)",
        ["cl"] = "хлориды",
        ["so"] = "сульфаты (мг/л)",
        ["f"] = "фториды (мг/л)",
        ["hco3"] = "гидрокарбонаты (мг/л)"
    },
    commands_help = {
        analyze = "Общий химический анализ образца.",
        reagent = "Ввод реактива.",
        degas = "Дегазация образца.",
        drain = "Слив реактива."
    },
    test = function(s)
        if not all.analyzer.tube then
            return "Ошибка! В анализаторе отсутствует образец."
        end
        local tube = _(all.analyzer.tube)
        if tube.bad then
            return "Ошибка! В анализаторе непригодный образец."
        end
    end,
    rname = function(s, r)
        local rstr = "0.25"
        if r == 2 then
            rstr = "0.35"
        elseif r == 3 then
            rstr = "0.50"
        end
        return rstr
    end,
    fakes = { 0.2, 1.5, 0.65, 1.9, 3.2, 0.6, 0.7, 2.1, 0.4, 1.1 },
    commands = {
        drain = function(s, args, loaded)
            local arg = s:arg(args)
            local n = tonumber(arg)
            if not arg or not n or n < 1 or n > 3 then
                local err = "Не указан номер реактива."
                if arg then
                    err = "Некорректный номер реактива."
                end
                return {
                    string.format("%s Допустимые значения:", err),
                    "[1] 0.25 ЕЭ/мл",
                    "[2] 0.35 ЕЭ/мл",
                    "[3] 0.50 ЕЭ/мл",
                    "",
                    "Синтаксис:",
                    "drain [номер реактива]"
                }
            end
            local rnam = "react"..tostring(n)
            if all.comp.react[rnam] == 0 then
                return "В резервуаре отсутствует реактив."
            end
            if not loaded then
                return "$load"
            end
            all.comp.react[rnam] = 0
            return string.format("Слив реактива на %s ЕЭ/мг завершён.", s:rname(n))
        end,
        degas = function(s, args, loaded)
            local res = s:test()
            if res then
                return res
            end
            if not loaded then
                return "$load"
            end
            local tube = _(all.analyzer.tube)
            tube.degas = true
            return "Произведена дегазация образца."
        end,
        analyze = function(s, args, loaded)
            local res = s:test()
            if res then
                return res
            end
            if not loaded then
                return "$load"
            end
            local tube = _(all.analyzer.tube)
            local len = 26
            local tab = {
                "Общий химический анализ воды:"
            }
            for k,v in pairs(s.content) do
                local value = tube.content[k]
                if not tube.degas then
                    value = value*s.fakes[rnd(#s.fakes)]
                end
                local str = v
                local ul = string.len(v)
                local app = string.make(".", len - ul)
                str = str..app..tostring(value)
                table.insert(tab, str)
            end
            return tab
        end,
        reagent = function(s, args, loaded)
            local res = s:test()
            if res then
                return res
            end
            local arg = s:arg(args)
            local r = tonumber(arg)
            if not arg or not r or r < 1 or r > 3 then
                local str = "Не указан тип реактива."
                if arg then
                    str = "Некорректное значения для типа реактива."
                end
                return {
                    string.format("%s Допустимые значения:", str),
                    "[1] 0.25 ЕЭ/мл",
                    "[2] 0.35 ЕЭ/мл",
                    "[3] 0.50 ЕЭ/мл",
                    "",
                    "Синтаксис:",
                    "reagent [номер реактива]"
                }
            end
            local rnam = "react"..tostring(r)
            if all.comp.react[rnam] == 0 then
                all.comp.problem = true
                return string.format("Закончился реактив на %s ЕЭ/мг.", s:rname(r))
            end
            r = all.comp.react[rnam]
            if not loaded then
                return "$load"
            end
            local tube = _(all.analyzer.tube)
            local weight = 1
            if tube.content.mg > 5 then
                weight = weight + 1
            end
            if tube.content.so > 10 then
                weight = weight + 1
            end
            if tube.reagent or r ~= weight then
                tube.reagent = true
                tube.bad = true
            else
                tube.reagent = true
            end
            return string.format("В образец введён реактив на %s ЕЭ/мг.", s:rname(r))
        end
    }
}
-- endregion
-- endregion

-- region chem2
es.room {
    nam = "chem2",
    mus = false,
    pic = "station/chem2",
    disp = "Подсобный отсек лаборатории",
    enter = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("juxtaposition", 2)
        end
    end,
    dsc = [[Этот отсек ещё меньше предыдущего. Можно подумать, что на химиках здесь экономят место? сдвигают поближе стены. За освещение к тому же отвечает единственная пыльная лампа.]],
    obj = { "shelf", "r025_holder", "r050_holder", "r035_holder" },
    way = {
        path { "Выйти", "chem1" }
    }
}

es.obj {
    nam = "shelf",
    unlocked = false,
    dsc = "У стены стоит массивный {металлический шкаф}, напоминающий бронированный сейф для хранения оружия.",
    act = function(s)
        if not s.unlocked then
            return "Просто так он не откроется, здесь есть магнитный замок."
        else
            return "Шкаф уже открыт."
        end
    end,
    used = function(s, w)
        if w.nam == "tcard" and not s.unlocked then
            s.unlocked = true
            return "Я касаюсь картой замка, и дверца бодро отщёлкивается."
        elseif w.nam == "tcard" then
            return "Дверь шкафа уже открыта."
        end
    end
}

local rholder_base = {
    cnd = "{shelf}.unlocked",
    act = function(s)
        if have(s.aff) then
            return "У меня уже есть пузырёк с этим реактивом."
        else
            take(s.aff)
            if not s.hide then
                return string.format("Я беру из коробки пузырёк с реактивом на %s ОЭ/мг.",
                    _(s.aff).aff)
            else
                return "Я беру из коробки пузырёк. Понятия не имею, какой это реактив. Надо разобраться, прежде чем его заливать."
            end
        end
    end,
    used = function(s, w)
        if w.kind == "r" and w.nam ~= s.aff then
            return "Кажется, я брал этот пузырёк из другой коробки. Лучше ничего не перепутать, здесь и так хватает путаницы."
        elseif w.kind == "r" then
            purge(w.nam)
            return "Я возвращаю пузырёк с реактивом в коробку."
        end
    end
}

es.obj(rholder_base) {
    nam = "r025_holder",
    aff = "r025",
    hide = false,
    dsc = "Внутри -- множество пластиковых коробок с пузырьками. Я читаю налепленные на них пометки: {\"0.25\"},"
}

es.obj(rholder_base) {
    nam = "r050_holder",
    aff = "r050",
    hide = true,
    dsc = "{\"Реактив\"} и"
}

es.obj(rholder_base) {
    nam = "r035_holder",
    aff = "r035",
    hide = true,
    dsc = "{\"Реактив!!!\"}."
}

local r_base = {
    kind = "r",
    disp = function(s)
        if s.hide then
            return es.tool("Реактив")
        else
            return es.tool(string.format("Реактив на %s ОЭ/мг", s.aff))
        end
    end,
    inv = function(s)
        local txt = "Жидкость внутри светлая, прозрачно-голубая."
        if s.aff == "0.35" then
            txt = "Жидкость внутри голубого цвета."
        elseif s.aff == "0.50" then
            txt = "Жидкость внутри насыщенного синего цвета."
        end
        if not s.hide then
            return string.format("На пузырьке наклеена этикетка: %s ОЭ/мг. ", s.aff) .. txt
        else
            return txt
        end
    end
}

es.obj(r_base) {
    nam = "r025",
    aff = "0.25",
    hide = false,
    content = 1
}

es.obj(r_base) {
    nam = "r035",
    aff = "0.35",
    hide = true,
    content = 2
}

es.obj(r_base) {
    nam = "r050",
    aff = "0.50",
    hide = true,
    content = 3
}
-- endregion

-- region chem_corridor
es.room {
    nam = "chem_corridor",
    mus = false,
    pic = "station/corridor3",
    disp = "Коридор",
    enter = function(s)
        if not s.mus and not snd.music_playing() then
            s.mus = true
            es.music("doom")
        end
    end,
    dsc = [[Я стою в коридоре, закрыв глаза. Сил уже почти не осталась. Кажется, что черепная коробка сейчас расколется от боли.
    ^Света здесь мало. Воздух всё ещё пронизывает едкая гарь. Можно подумать, что станция уже умерла, что нет смысла за что-то бороться.
    ^Мне вдруг хочется просто уйти, бросить всё, вернуться в свой модуль, свалиться в кровать и заснуть.
    ^Я гоню от себя эти мысли.]],
    way = {
        path { "В химическую лабораторию", "chem1" }
    }
}
-- endregion

-- region chem_restart
es.room {
    nam = "chem_restart",
    noinv = true,
    pic = "station/corridor4",
    disp = "* * *",
    enter = function(s)
        es.music("doom", 1, 0, 3000)
    end,
    dsc = [[Из-за моей невнимательности пришлось тратить драгоценное время.
    ^Я постарался собрать нужные образцы как можно быстрее и вернулся в химическую лабораторию.]],
    onenter = function(s)
        for i = 1, 3, 1 do
            local nm = "tube"..tostring(i)
            local o = _(nm)
            o.bad = false
            o.reagent = false
            o.degas = false
            purge(nm)
            _(nm.."_holder").taken = false
        end
    end,
    next = "chem1"
}
-- endregion

-- region outro1
es.room {
    nam = "outro1",
    noinv = true,
    pause = 20,
    enter = function(s)
        es.stopMusic(1000)
    end,
    next = function(s)
        gamefile("game/12.lua", true)
    end
}
-- endregion
