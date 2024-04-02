--string
function string.len(s)
    return #(s):gsub("[\128-\191]", "")
end

function string.charAt(s, n)
    return string.char(s:byte(n))
end

function string.make(c, times)
    local arr = {}
    for i = 1, times, 1 do
        table.insert(arr, c)
    end
    return table.concat(arr)
end

function string.startsWith(self, start)
   return self:sub(1, #start) == start
end

function string.endsWith(self, ending)
   return ending == "" or self:sub(-#ending) == ending
end

function string.split(self, sep)
    local t = {}
    for s in string.gmatch(self, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

function string.any(s, tab)
    for i,v in ipairs(tab) do
        if v == s then
            return true
        end
    end
    return false
end

function string.trim(self)
   return self:gsub("^%s*(.-)%s*$", "%1")
end

function string.parse(s, apply)
  return string.gsub(s, "\\?[\\{}]", { ["{"] = "\001", ["}"] = "\002" })
    :gsub("\001([^\002]+)\002", apply);
end

function string.pair(self, sep)
    local arr = self:split(sep)
    local a,b = arr[1]:trim(),arr[2]
    if b then
        b = arr[2]:trim()
    end
    return a,b
end

function string.triple(self, sep)
    local arr = self:split(sep)
    local a,b,c = arr[1]:trim(),arr[2],arr[3]
    if b then
        b = arr[2]:trim()
    end
    if c then
        c = arr[3]:trim()
    end
    return a,b,c
end

--other
function es.tool(text)
    return fmt.img("theme/inv.png") .. " " .. text
end

function es.act(field) --to delete
    return function()
        local s = here()
        return es.apply(s[field], s)
    end
end

function es.keys(tab)
    local keyset = {}
    for k,v in pairs(tab) do
        table.insert(keyset, k)
    end
    return keyset
end

function es.apply(functor, arg1, arg2, arg3)
    arg1 = arg1 or here()
    if type(functor) == "function" then
        local ret = functor(arg1, arg2, arg3)
        return es.apply(ret, arg1, arg2, arg3)
    else
        return functor
    end
end

function es.rnd(seed, max, min)
    if not min then
        min = 1
    end
    if not max then
        max = 2147483647
    end
    rnd_seed(seed)
    return rnd(min, max)
end

function es.rndArray(seed, num, max, min)
    local arr = {}
    for i=1, num do
        local v = es.rnd(seed, max, min)
        seed = v
        table.insert(arr, v)
    end
    return arr
end

function es.eval(src, so)
    return function()
        src = src:parse(function(s)
            return "_(\"" .. s .. "\")"
        end)
        local fn = loadstring("return function(s) return ("..src..") end")()
        return fn(so or here())
    end
end

--graphics
function es.para(text) --to delete
    return fmt.img("theme/dot.png") .. "^^" .. text
end

function es.br(text) --to delete
    return fmt.img("theme/dot.png") .. "^" .. text
end

function es.sprite(w, h, col, alpha)
    local str = string.format("box:%dx%d,%s", w, h, col)
    if alpha then
        str = str..","..alpha
    end
    return sprite.new(str)
end

function es.large(txt) --to delete
    local fnt = sprite.fnt("theme/sans.ttf", 20)
    local w,h = fnt:size(txt)
    local spr = sprite.new(w, h)
    fnt:text(txt, "lighgray"):draw(spr)
    return fmt.img(spr)
end

function es.frame(spr)
    if spr then
        local w,h = spr:size()
        local vs = es.sprite(16, h, "#37566B", 60)
        vs:compose(spr, 0, 0)
        vs:compose(spr, 824, 0)
        local hs = es.sprite(840, 1, "#37566B", 100)
        hs:compose(spr, 0, 0)
        hs:compose(spr, 0, h - 1)
        return spr
    end
end

--music
function es.music(file, loop, fadein, fadeout)
    snd.music_fading(fadeout or 0, fadein or 0)
    snd.music("sfx/"..file..".ogg", loop or 1)
    return true
end

function es.loopMusic(file, fadein)
    return es.music(file, 1024, fadein)
end

function es.stopMusic(fadeout)
    snd.music_fading(fadeout or 2000)
    snd.stop_music()
end

function es.sound(file)
    snd.play("sfx/"..file..".ogg")
end