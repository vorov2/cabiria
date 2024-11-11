-- $Name: Бездна света$
-- $Version: 1.3$
-- $Author: Василий Воронков$
-- $Info: Текстовая игра для платформы INSTEAD (https://instead.hugeping.ru)$
dofile "lib/es.lua"

room {
    nam = "main",
    enter = function(s)
        walkin("menu")
    end
}

local function getVersion()
    local file = io.open("main3.lua", "r")
    for line in file:lines() do
        if line:startsWith("-- $Version:") then
            local idx = line:find(":")
            line = line:sub(idx + 1, #line)
            line = line:sub(1, #line - 1)
            io.close(file)
            return "Версия: ".. line
        end
    end
    io.close(file)
end

es.room {
    nam = "menu",
    bg = "menu",
    enter = function(s)
        es.loopMusic("spring")
    end,
    decor = function(s)
        local ret = string.format(
            "{#new_game|%s} • {#select_chapter|%s} • {#tutorial|%s} • {#credits|%s}",
            "<b>Новая игра</b>",
            "<b>Главы</b>",
            "<b>Обучение</b>",
            "<b>Создатели</b>"
        )
        local version = getVersion()
        return
            "^^^^^"..
            fmt.tab("44%", "center")..ret..
            "^^^^^^^^^^^^^^^^^^^^^^^"..
            "{#version|"..fmt.b(version).."}"
    end
}:with {
    es.obj {
        nam = "#new_game",
        act = function(s)
            gamefile("game/01.lua", true)
        end
    },
    es.obj {
        nam = "#select_chapter",
        act = function(s)
            walkin("chapters")
            return true
        end
    },
    es.obj {
        nam = "#tutorial",
        act = function(s)
            gamefile("game/tutorial.lua", true)
        end
    },
    es.obj {
        nam = "#credits",
        act = function(s)
            walkin("credits")
            return true
        end
    },
    es.obj {
        nam = "#version",
        act = function(s)
            walkin("version")
            return true
        end
    }
}

-- region credits
es.room {
    nam = "credits",
    bg = "credits",
    dsc = [[
        <b>Платформа INSTEAD:</b> Пётр Косых^
        <b>Сюжет и программирование:</b> Василий Воронков^
        <b>Тестирование:</b> Олег Бош, Пётр Косых^
        <b>Музыкальное оформление:</b> Василий Воронков^

        ^<b>Графическое оформление:</b>^
        Garry's Mod^
        Шедеврум^
        Кандинский^

        ^<b>Звуковые эффекты:</b>^
        freesound.org^

        ^Подробная информация содержится в файле readme.txt, который должен быть приложен к игре.^

        ^Москва, 2024
    ]],
    obj = { "back" }
}

es.obj {
    nam = "back",
    dsc = "{• Вернуться в меню}",--"{" .. fmt.img("theme/prev.png") .. "}",
    act = function(s)
        walkin("menu")
        return true
    end
}
-- endregion

-- region chapters
local debugMode = false

es.room {
    nam = "chapters",
    bg = "chapters",
    dsc = [[
    Выберите главу из списка для загрузки. Доступны только открытые в процессе прохождения главы.]],
    obj = {
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16",
        "nb",
        "back"
    }
}

es.room {
    nam = "transition",
    pause = 70,
    chapter = false,
    enter = function(s)
        es.stopMusic(3000)
    end,
    next = function(s)
        gamefile("game/"..s.chapter..".lua", true)
    end
}

local chapter_template = {
    dsc = function(s)
        if (prefs.chapters and prefs.chapters[s.nam]) or s.nam == "1" or debugMode then
            return string.format("{Глава %s. \"%s\"}", s.nam, s.title) .. "^" .. fmt.nb("")
        else
            return "Глава " .. s.nam .. "^" .. fmt.nb("")
        end
    end,
    act = function(s)
        local nam = s.nam
        if #nam == 1 then
            nam = "0"..nam
        end
        all.transition.chapter = nam
        walkin("transition")
        return true
    end
}

es.obj {
    nam = "nb",
    dsc = "^"
}

es.obj(chapter_template) {
    nam = "1",
    title = "Озеро",
}
es.obj(chapter_template) {
    nam = "2",
    title = "Грозный",
}
es.obj(chapter_template) {
    nam = "3",
    title = "Выход",
}
es.obj(chapter_template) {
    nam = "4",
    title = "Стыковка",
}
es.obj(chapter_template) {
    nam = "5",
    title = "Кабирия",
}
es.obj(chapter_template) {
    nam = "6",
    title = "Вера",
}
es.obj(chapter_template) {
    nam = "7",
    title = "Нуболиды",
}
es.obj(chapter_template) {
    nam = "8",
    title = "Буря",
}
es.obj(chapter_template) {
    nam = "9",
    title = "Безумие",
}
es.obj(chapter_template) {
    nam = "10",
    title = "Столкновение",
}
es.obj(chapter_template) {
    nam = "11",
    title = "След",
}
es.obj(chapter_template) {
    nam = "12",
    title = "Паразит",
}
es.obj(chapter_template) {
    nam = "13",
    title = "Возмездие",
}
es.obj(chapter_template) {
    nam = "14",
    title = "Эвакуация",
}
es.obj(chapter_template) {
    nam = "15",
    title = "Фуга",
}
es.obj(chapter_template) {
    nam = "16",
    title = "Пляж",
}
-- endregion

-- region version
es.room {
    nam = "version",
    bg = "version",
    dsc = function(s)
        local file = io.open("version.txt", "r")
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end
        io.close(file)
        return table.concat(lines, "^")
    end,
    obj = { "back" }
}
-- endregion