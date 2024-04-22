--Extensions to instead
function es.setTheme(bg)
    bg = bg or "bg"
    if es.bg ~= bg then
        es.bg = bg
        if bg == "menu" then
            theme.set("win.fnt.size", 20)
            theme.set("win.col.fg", "gray")
            theme.set("win.col.link", "gray")
            theme.set("win.col.alink", "white")
        elseif bg == "credits" or bg == "chapters" or bg == "version" then
            theme.set("win.fnt.size", 20)
            theme.set("win.col.fg", "gray")
            theme.set("win.col.link", "#C0C0C0")
            theme.set("win.col.alink", "white")
        else
            theme.set("win.fnt.size", 18)
            theme.set("win.col.fg", "lightgray")
            theme.set("win.col.link", "#649BC1")
            theme.set("win.col.alink", "#0094FF")
        end
        if not string.find(bg, "/") then
            bg = "theme/"..bg..".jpg"
        else
            bg = "gfx/"..bg..".jpg"
        end
        theme.gfx.bg(bg)
    end
end

function es.room(tab)
    if tab.pause then
        local enter = tab.enter
        tab.bg = tab.bg or "clean"
        tab.counter = 0
        tab.enter = function(s)
            if enter then
                es.apply(enter, s)
            end
            timer:set(50)
        end
        tab.timer = function(s)
            s.counter = s.counter + 1
            if s.counter == s.pause then
                timer:stop()
                local nx = s.next
                if type(nx) == "string" then
                    walkin(nx)
                    return true
                else
                    local ret = es.apply(nx, s)
                    if ret then
                        walkin(ret)
                    end
                    return true
                end
            end
        end
    end
    if tab.next and not tab.pause then
        local act = tab.next
        if type(act) == "string" then
            act = function()
                walkin(tab.next)
            end
        else
            local oldact = act
            act = function()
                return oldact(here())
            end
        end
        local next_disp = tab.next_disp
        if not next_disp then
            next_disp = "{• • •}"
        elseif next_disp and next_disp:startsWith("--") then
            next_disp = fmt.img("theme/bluedot.png").."{"..next_disp.."}"
        elseif next_disp == "RELOAD" then
            next_disp = "{• Последняя точка сохранения}"
        else
            next_disp = "{"..next_disp.."}"
        end
        tab.onkey = function(s, press, key)
            if press then
                if string.upper(key) == "SPACE" then
                    _("#next"):act()
                    return true
                end
            end
            return false
        end
        tab.obj = {
            obj {
                nam = "#next",
                dsc = next_disp,
                act = act
            }
        }
    end
    local pic = tab.pic
    tab.pic = function(s)
        local retval = nil
        if pic then
            local file = es.apply(pic, s)
            if file and type(file) == "string" then
                file = "gfx/" .. file .. ".jpg"
                local spr = sprite.new(file)
                retval = es.frame(spr)
            elseif file then
                retval = file
            end
        end
        es.setTheme(s.bg)
        return retval
    end
    return room(tab)
end

function es.inherit(bas)
    return function(tab)
        return es.obj(tab, bas)
    end
end

function es.obj(tab, tpl)
    if not tab.nam then
        return function(tab1)
            return es.obj(tab1, tab)
        end
    end
    local act,cnd,dsc,used,dlg = tab.act,tab.cnd,tab.dsc,tab.used,tab.dlg
    if tpl then
        dsc = dsc or tpl.dsc
        used = used or tpl.used
        cnd = cnd or tpl.cnd
        act = act or tpl.act
        for k,v in pairs(tpl) do
            if not tab[k] then
                tab[k] = v
            end
        end
    end
    tab.dlg = tab.nam .. ".dlg"
    tab.dsc = function(s)
        local res = true
        if cnd and type(cnd) == "string" then
            res = es.eval(cnd, s)()
        elseif cnd then
            res = es.apply(cnd, s)
        end
        if res then
            return es.apply(dsc, s)
        end
    end
    tab.act = function(s)
        local rm = here()
        if rm.preact then
            local ret = es.apply(rm.preact, rm, tab, "act")
            if ret then
                return ret
            end
        end
        local retval = es.apply(act,s)
        if rm.postact then
            es.apply(rm.postact, rm, tab, "act")
        end
        if retval then
            return retval
        end
    end
    tab.used = function(s, w)
        local rm = here()
        if rm.preact then
            local ret = es.apply(rm.preact, rm, tab, "used")
            if ret then
                return ret
            end
        end
        if used then
            local ret = used(s, w)
            if rm.postact then
                es.apply(rm.postact, rm, tab, "used")
            end
            if ret then
                return ret
            end
        end
        if w.default then
            return es.apply(w.default, w)
        else
            return "Лучше этого не делать."
        end
    end
    if dlg then
        es.dialog {
            nam = tab.nam .. ".dlg",
            disp = tab.dlg_disp,
            dlg = dlg,
            owner = tab.nam,
            branch = tab.branch
        }
    end
    return obj(tab)
end

function es.main(tab)
    local onenter = tab.onenter
    tab.nam = "main"
    tab.state = {}
    tab.spr = false
    tab.onenter = function(s)
        if s.chapter then
            prefs.chapters[s.chapter] = true
            prefs:store()
        end
        return es.apply(onenter, s)
    end
    es.dialog {
        nam = "system.dlg",
        branch = false,
        param_dlg = false,
        param_disp = false,
        param_key = false,
        param_pic = false,
        owner = false,
        reset = function(s)
            s.dyndisp = false
            s.branch = false
            s.param_dlg = false
            s.param_disp = false
            s.param_key = false
            s.param_pic = false
            s.owner = false
            s.cache_map = false
            s.cache_branches = false
            s.npc = false
            s.img = false
            s.currentId = false
            s.oldDsc = false
        end,
        dlg = function(s)
            local prefix = tab.chapter
            if #prefix == 1 then
                prefix = "0"..prefix
            end
            return prefix .. "/" .. s.param_dlg
        end,
        disp = function(s)
            if s.param_disp then
                return es.apply(s.param_disp, s)
            else
                return es.apply(s:from().disp, s:from())
            end
        end
    }
    return room(tab)
end