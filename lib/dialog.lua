local function openFile(p)
    return assert(io.open(p, "r"),
        string.format("Error loading file: %s.", p))
end

local function copyTable(self, other)
    for k,v in pairs(self) do
        if other[k] == nil then
            other[k] = v
        end
    end
end

local function calculateIndent(s)
    local count = 0
    for i = 1, #s, 1 do
        local b = string.byte(s, i)
        if b == 32 then
            count = count + 1
        else
            break
        end
    end
    return math.floor(count / 4), s:trim()
end

local function readFile(path)
    local file = openFile(path)
    local ret = {}
    local prev = {
        indent = 0,
        lines = {}
    }
    local nl = false
    for line in file:lines() do
        local indent, trimmedLine = calculateIndent(line)
        if #trimmedLine ~= 0 then
            local attr = (trimmedLine:charAt(1) == "[")
            if prev.indent == indent and not nl and not attr then
                table.insert(prev.lines, trimmedLine)
            else
                nl = false
                if #prev.lines > 0 then
                    table.insert(ret, prev)
                end
                prev = {
                    indent = indent,
                    lines = { trimmedLine }
                }
            end
        else
            nl = true
        end
    end
    io.close(file)
    if #prev.lines > 0 then
        table.insert(ret, prev)
    end
    return ret
end

local function processAttributes(v)
    local replica = {
        id = 0,
        indent = v.indent,
        key = false,
        cnd = false,
        act = false,
        eval = false,
        back = false,
        always = false,
        jump = false,
        disp = false,
        mute = false,
        music = false,
        loop = false,
        fadein = false,
        fadeout = false,
        walkdlg = false,
        aux = false,
        pic = false,
        lines = {},
        children = {},
        npc = false,
        parent = false,
        reply = false
    }
    for i,v in ipairs(v.lines) do
        local len = #v
        if string.byte(v, 1) == 91 and string.byte(v, len) == 93 then
            local tv = v:sub(2, len - 1)
            for j,w in ipairs(tv:split(",")) do
                local attr,val = w:pair(":")
                if attr == "always" then
                    replica.always = true
                elseif attr == "back" then
                    replica.back = true
                elseif attr == "mute" then
                    replica.mute = true
                elseif attr == "aux" then
                    replica.aux = true
                elseif attr == "npc" then
                    replica.npc = val:split("+")
                else
                    replica[attr] = val
                end
            end
        else
            table.insert(replica.lines, v)
        end
    end
    return replica
end

local function processLines(lines, prefix)
    local branches = {}
    local map = {}
    local par = nil
    local id = 0
    for i,v in ipairs(lines) do
        id = id + 1
        local fid = prefix..tostring(id)
        local crep = processAttributes(v)
        crep.parent = par
        crep.id = fid
        map[fid] = crep
        if crep.key then
            map[crep.key] = crep
        end
        if v.indent == 0 then
            crep.reply = true
            par = crep
            table.insert(branches, par)
        elseif v.indent == par.indent then
            crep.reply = par.reply
            table.insert(par.parent.children, crep)
            par = crep
        elseif v.indent > par.indent then
            crep.reply = not par.reply
            table.insert(par.children, crep)
            par = crep
        else
            while par.indent >= crep.indent do
                par = par.parent
            end
            crep.parent = par
            crep.reply = not par.reply
            table.insert(par.children, crep)
            par = crep
        end
    end
    return branches, map
end

local function isAvailable(replica)
    return not replica.cnd or es.eval(replica.cnd, _(here().owner))()
end

local function hasChildren(replica)
    if not replica or #replica.children == 0 then
        return false
    end
    local hw = here()
    for i,v in ipairs(replica.children) do
        if v.always or (not hw.seen[v.id] and isAvailable(v)) then
            return true
        end
    end
    return false
end

local function backReplica()
     return obj {
        nam = "#replica_back",
        dsc = function(s)
            local hw = here()
            local replica = hw:replica()
            local hasChildren = false
            for i,r in ipairs(replica.children) do
                local ava = isAvailable(r)
                if (r.always and ava) or (not hw.seen[r.id] and ava) then
                    hasChildren = true
                end
            end
            if not hasChildren then
                return "{• • •}"
            end
        end,
        act = function(s)
            walk(here():from())
            return true
        end
    }
end

local function makeReplica(index)
    return obj {
        nam = "#replica_"..tostring(index),
        index = index,
        dsc = function(s)
            local hw = here()
            local replica = hw:replica()
            if #replica.children >= s.index then
                local r = replica.children[s.index]
                local ava = isAvailable(r)
                if (r.always and ava) or (not hw.seen[r.id] and ava) then
                    if #r.lines == 1 and (r.lines[1] == "next" or r.lines[1] == "...") then
                        return "{• • •}"
                    else
                        local alltext = table.concat(r.lines, "^")
                        local dot = "bluedot"
                        if r.aux then
                            dot = "graydot"
                        end
                        return fmt.img("theme/"..dot..".png")..
                            string.format("{%s}^%s^", alltext, fmt.img("blank:1x15"))
                    end
                end
            end
        end,
        isNext = function(s)
            local hw = here()
            local replica = hw:replica()
            local r = replica.children[s.index]
            return r and isAvailable(r)
                and #r.lines == 1 and (r.lines[1] == "next" or r.lines[1] == "...")
        end,
        isAvailable = function(s)
            local hw = here()
            local replica = hw:replica()
            if #replica.children < s.index then
                return false
            end
            local r = replica.children[s.index]
            local ava = isAvailable(r)
            return (r.always and ava) or (not hw.seen[r.id] and ava)
        end,
        hasAlways = function(s, replica)
            local rp = replica
            while rp ~= nil do
                if rp.always then
                    return true
                end
                rp = rp.parent
            end
            return false
        end,
        act = function(s)
            local hw = here()
            local owner = _(hw.owner)
            hw.reaction = false
            local replica = hw:replica().children[s.index]
            hw.seen[replica.id] = true
            if replica.act then
                es.apply(owner[replica.act], owner)
            end
            if replica.npc then
                here().npc = replica.npc
            end
            if replica.pic then
                here().img = replica.pic
            end
            if replica.disp then
                here().dyndisp = replica.disp
            end
            if replica.set then
                local a,b = replica.set:pair(".")
                if a and b then
                    _(a)[b] = true
                else
                    owner[replica.set] = true
                end
            end
            if replica.take then
                take(replica.take)
            end
            if replica.purge then
                purge(replica.purge)
            end
            if replica.reaction then
                hw.reaction = replica.reaction
            end
            if replica.mute then
                es.stopMusic(replica.fadeout or 2000)
            end
            if replica.music then
                local lp = tonumber(replica.loop)
                es.music(replica.music, lp or 1, replica.fadein, replica.fadeout)
            end
            if replica.back then
                walk(here():from())
            elseif replica.walk then
                walk(replica.walk)
            elseif replica.walkdlg then
                es.walkdlg(replica.walkdlg)
            elseif replica.jump then
                local child = replica.children[1]
                local tar = hw.cache_map[replica.jump]
                hw.currentId = tar.id
                if child and child.lines then
                    hw.oldDsc = table.concat(child.lines, "^")
                else
                    hw.oldDsc = false
                end
                me():need_scene(true)
            else
                local child = replica.children[1]
                if hasChildren(child) then
                    hw.currentId = child.id
                    hw.oldDsc = false
                else
                    if child and child.lines and #child.lines > 0 then
                        hw.oldDsc = table.concat(child.lines, "^")
                    end
                    local par = replica.parent
                    while par ~= nil do
                        if par.reply and hasChildren(par) then
                            hw.currentId = par.id
                            break
                        end
                        par = par.parent
                    end
                end
                me():need_scene(true)
            end
        end
    }
end

local function parseDialog(path, prefix)
    local data = readFile(path)
    return processLines(data, prefix)
end

function es.dialog(tab)
    local ret = {
        nam = tab.nam,
        {
            cache_map = false,
            cache_branches = false
        },
        dyndisp = false,
        img = false,
        npc = false,
        noinv = true,
        currentId = false,
        branch = tab.branch,
        oldDsc = false,
        reaction = false,
        dlg = tab.dlg,
        owner = tab.owner or tab.nam,
        seen = {},
        pic = function(s)
            local pic = tab.pic or s.param_pic
            local spr = nil
            if s.img then
                pic = s.img
            end
            if pic then
                local file = es.apply(pic, s)
                spr = sprite.new("gfx/"..file..".jpg")
            else
                spr = es.apply(s:from().pic, s:from())
            end
            if s.npc then
                local stepping = 10
                for i,v in ipairs(s.npc) do
                    if v ~= "nil" then
                        local npc = sprite.new("gfx/npc/"..v..".png")
                        local w,h = npc:size()
                        npc:compose(spr, stepping, 340 - h)
                        stepping = stepping + w + 10
                    end
                end
            end
            es.setTheme()
            return es.frame(spr)
        end,
        disp = function(s)
            if s.cache_map and s.cache_map[s.currentId] and s.cache_map[s.currentId].disp then
                return s.cache_map[s.currentId].disp
            end
            if s.dyndisp then
                return s.dyndisp
            elseif tab.disp then
                return es.apply(tab.disp, s)
            else
                return es.apply(s:from().disp, s:from())
            end
        end,
        onkey = function(s, press, key)
            if press and string.upper(key) == "SPACE" then
                for i = 1, 10, 1 do
                    local r = _("#replica_"..tostring(i))
                    if r:isNext() then
                        r:act()
                        return true
                    end
                end
            end
            return false
        end,
        replica = function(s)
            s:loadDialog()
            return s.cache_map[s.currentId]
        end,
        loadDialog = function(s)
            if not s.cache_map then
                local dlg = es.apply(s.dlg, s)
                s.cache_branches, s.cache_map =
                    parseDialog("game/dlg/"..dlg..".txt", s.param_key or "id")
            end
            if not s.currentId and s.branch then
                local setBranch = es.apply(s.branch, _(s.owner))
                for i,v in ipairs(s.cache_branches) do
                    if v.key == setBranch then
                        s.currentId = v.id
                        break
                    end
                end
                if not s.currentId and setBranch then
                    error(string.format("Unable to find branch \"%s\".", setBranch))
                end
                if not setBranch then
                    s.currentId = s.cache_branches[1].id
                end
            elseif not s.currentId then
                s.currentId = s.cache_branches[1].id
            end
            if s.cache_map and s.cache_map[s.currentId] and s.cache_map[s.currentId].npc then
                s.npc = s.cache_map[s.currentId].npc
            end
        end,
        decor = function(s)
            s:loadDialog()
            local app = ""
            if s.reaction then
                app = "<i>" .. s.reaction .. "^^</i>"
            end
            if s.oldDsc then
                return app..s.oldDsc
            else
                local replica = s.cache_map[s.currentId]
                return app..table.concat(replica.lines, "^")
            end
        end,
        obj = {}
    }
    for i = 1, 10, 1 do
        table.insert(ret.obj, makeReplica(i))
    end
    table.insert(ret.obj, backReplica())
    copyTable(tab, ret)
    return room(ret)
end

function es.walkdlg(dat)
    local dlg,branch,disp,key,pic,owner = false,false,false,false,false,false
    if type(dat) == "table" then
        dlg,branch,disp,pic,owner = dat.dlg,dat.branch,dat.disp,dat.pic,dat.owner
        key = dlg .. "." .. branch
    else
        dlg,branch = dat:pair(".")
        key = dat
    end
    local hw = _("system.dlg")
    hw:reset()
    hw.param_dlg = dlg
    hw.branch = branch
    hw.param_disp = disp
    hw.param_key = key
    hw.owner = owner or here().nam
    hw.param_pic = pic
    walkin(hw.nam)
    return true
end