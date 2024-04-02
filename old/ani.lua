


local function large2(txt)
    local fnt = sprite.fnt("theme/dos.ttf", 50)
    local w,h = fnt:size(txt)
    local spr = sprite.new(w, h)
    fnt:text(txt, "lighgray"):draw(spr)
    return fmt.img(spr)
end

room {
    nam = "ani",
    num = 0,
    enter = function(s)
        timer:set(2000)
    end,
    timer = function(s)
        print("s.num", s.num)
        s.num = s.num + 1
        walk(here())
    end,
    dsc = function(s)
        local tab = {
            "  А         ",
            "  А   И   И ",
            "  А   И Р И ",
            "К А   И Р И ",
            "К А   И Р И Я",
            "К А Б И Р И Я"
        }
        if s.num > #tab then
            s.num = #tab
        end
        if s.num > 0 then
            p(large2(tab[s.num]))
        end
    end
}