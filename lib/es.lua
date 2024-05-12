require "fmt"
require "sprite"
require "timer"
require "noinv"
require "snapshots"
require "keys"
require "click"
require "snd"
require "theme"
require "prefs"

local es = {}
es.bg = false
declare "es" (es)

--common
std.phrase_show = false
std.phrase_prefix = ""
std.strip_call = false
fmt.para = false

instead.get_title = function(s)
    s = s or here()
    local txt = es.apply(s.disp or s.title, s)
    if not txt or txt == "" then
        txt = " "
    end
    local fnt = sprite.fnt("theme/sans-b.ttf", 24)
    local w,h = fnt:size(txt)
    local spr = sprite.new(w, h)
    fnt:text(txt, "#649BC1"):draw(spr)
    return fmt.img(spr)
end

fmt.filter = function(s, state)
    if state then
        return fmt.img("theme/bigdot.png") .. "\n" .. s
    end
    return s
end

--initialization
dofile "lib/stead.lua"
dofile "lib/util.lua"
dofile "lib/dialog.lua"

if instead.tiny then
    dofile "lib/ps_terminal.lua"
else
    dofile "lib/terminal.lua"
end

prefs.chapters = {}

--addressing
local all = {}
declare "all" (all)

local mt_all = {
    __index = function(s, k)
        local el = rawget(s, k)
        if not k:startsWith("__") and el == nil then
            return _(k)
        end
        return el
    end
}
setmetatable(all, mt_all)
game.display = es.display