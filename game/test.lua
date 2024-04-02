dofile "lib/es.lua"

es.main {
    chapter = "test",
    onenter = function(s)
        walkin("credits_roll")
    end
}

local config = {
    fps = 20,
    font = "theme/sans.ttf",
    size = 19,
    bg = "#1F1F1F",
    fg = "lightgray"
}

es.room {
    nam = "credits_roll",
    bg = "clean",
    enter = function(s)
        es.music("premonition")
        timer:set(1000/config.fps)
    end,
    offset = 0,
    {
        cache = false,
        height = false
    },
    credits = {
        "",
        "ПЛАТФОРМА INSTEAD",
        "Пётр Косых",
        "",
        "",
        "СЦЕНАРИЙ",
        "Василий Воронков",
        "",
        "",
        "ПРОГРАММИРОВАНИЕ",
        "Василий Воронков",
        "",
        "",
        "МУЗЫКАЛЬНОЕ ОФОРМЛЕНИЕ",
        "Василий Воронков",
        "",
        "",
        "ТЕСТИРОВАНИЕ",
        "Иван Иванов",
        "",
        "",
        "ЗВУКОВЫЕ ЭФФЕКТЫ (freesound.org)",
        "gabemille74 (BreathOfDeath)",
        "StephenSaldanha (SRS_Cinematic_Hit)",
        "GowlerMusic (Computer Sound)",
        "Breviceps (Error Signal 1)",
        "facuarmo (286 startup)",
        "",
        "",
        "СИЛУЭТЫ ПЕРСОНАЖЕЙ",
        "NACreative @ Freepik",
        "",
        "",
        "ГРАФИЧЕСКОЕ ОФОРМЛЕНИЕ",
        "Garry's Mod",
        "Шедеврум",
        "Кандинский",
        "",
        "",
        "",
        "",
        "МОСКВА 2024",
        ""
    },
    make = function(s)
        local len = #s.credits
        local fnt = sprite.fnt(config.font, config.size)
        local height = fnt:height() * 1.2
        local theight = height * len
        local spr = es.sprite(400, theight, config.bg)
        local shift = 0
        for i,v in ipairs(s.credits) do
            if v ~= "" then
                fnt:text(v, config.fg):draw(spr, 0, shift)
            end
            shift = shift + height
        end
        return spr,theight
    end,
    timer = function(s)
        if not snd.music_playing() then
            timer:stop()
            walkin("outro1")
        end
        s.offset = s.offset + 1
        if not s.cache then
            s.cache,s.height = s:make()
        end
        s.cache:copy(0, s.height - s.offset, 400, s.offset, sprite.scr(), 50, 0)
        return true
    end
}

es.room {
    nam = "outro1"
}