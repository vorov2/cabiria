
--[[
local function traverse(storeKey, makeLoop, tab)
    local prefix = here().nam
    local s,key = _("main").state,prefix.."_"..storeKey
    local st = nil
    if not s["traverse"] then
        st = {}
        s["traverse"] = st
    else
        st = s["traverse"]
    end
    local ix = st[key]
    local len = #tab
    if not ix then
        ix = 1
        st[key] = ix
    end
    if ix > len and makeLoop then
        ix = 1
    elseif ix > len then
        ix = len
    end
    local ret = tab[ix]
    st[key] = ix + 1
    return ret
end

function es.keys(tab)
    local keyset = {}
    for k,v in pairs(tab) do
        table.insert(keyset, k)
    end
    return keyset
end

es.justOnce = function(storeKey)
    if type(storeKey) == "table" then
        return traverse("dsc", false, storeKey)
    else
        return function(tab)
            return function()
                return traverse(storeKey, false, tab)
            end
        end
    end
end

es.loop = function(storeKey, tab)
    return traverse(storeKey, true, tab)
end

es.justRnd = function(tab)
    return function()
        local ix = rnd(1, #tab)
        return es.apply(tab[ix])
    end
end

es.walkin = function(room)
    return function()
        walkin(room)
    end
end

es.walk = function(room)
    return function()
        walk(room)
    end
end

es.gamefile = function(nam)
    return function()
        gamefile("game/"..nam..".lua", true)
    end
end]]