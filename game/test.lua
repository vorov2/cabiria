dofile "lib/es.lua"

es.main {
    chapter = "14",
    onenter = function(s)
        walkin("test")
    end
}

es.room {
    nam = "test",
    {
        title = false,
        light = false,
        black = false
    },
    bg = "black",
    disp = "",
    shift = 0,
    enter = function(s)
        timer:set(50)
    end,
    timer = function(s)
        s.shift = s.shift + 8

        if s.shift == 80 then
            es.music("title")
        elseif s.shift > 1100 then
            s.shift = 0
            timer:stop()
            walkin("test")
            return false
        end

        if not s.title then
            s.title = sprite.new("theme/title.png")
            s.light = sprite.new("theme/light.png")
            s.black = sprite.new("1200x900,black")
        end
        local title = s.title:dup()
        --local bg = s.black:dup()
        local spr = s.light:draw(title, s.shift, 0)
        spr:draw(sprite.scr(), 0, 0)

        --bg:copy(sprite.scr(), 0, 0)
        return true
    end
}