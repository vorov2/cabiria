--terminal
local ABC = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890;.-"

local config = {
    fps = 5,
    font = "theme/dos.ttf",
    size = 22,
    bg = "black",
    fg = "#62A552",
    cols = 80,
    lines = 35,
    prompt = {
        fg = "#91F279"
    },
    cursor = {
        fg = "#1B2D16"
    },
    w = 700,
    h = 780
}
config.fnt = sprite.fnt(config.font, config.size)
config.fw,config.fh = config.fnt:size("W")

function keys:filter(press, key)
    return key ~= "escape"
end

function start(load)
    if load and here().load then
        here():load()
    end
end

local function processKey(key, text, cursor, history)
    if not history.pos then
        history.pos = #history.items
    end
    local ukey = string.upper(key)
    if not text then
        text = ""
    end
    local len = string.len(text)
    if string.find(ABC, ukey, 1, true) or ukey == "SPACE" then
        if ukey == "SPACE" then
            ukey = " "
        end
        if cursor == 0 then
            text = ukey..text
        elseif cursor == len then
            text = text..ukey
        else
            local chunk1 = text:sub(1, cursor)
            local chunk2 = text:sub(cursor + 1, len)
            text = chunk1..ukey..chunk2
        end
        cursor = cursor + 1
    elseif ukey == "BACKSPACE" then
        if cursor == len then
            text = text:sub(1, -2)
        elseif cursor > 0 then
            local chunk1 = text:sub(1, cursor - 1)
            local chunk2 = text:sub(cursor + 1, len)
            text = chunk1..chunk2
        end
        cursor = cursor - 1
        if cursor < 0 then
            cursor = 0
        end
    elseif ukey == "LEFT" then
        cursor = cursor - 1
        if cursor < 0 then
            cursor = 0
        end
    elseif ukey == "RIGHT" then
        cursor = cursor + 1
        if cursor > len then
            cursor = len
        end
    elseif ukey == "HOME" then
        cursor = 0
    elseif ukey == "END" then
        cursor = len
    elseif ukey == "UP" then
        if history.pos > 1 then
            history.pos = history.pos - 1
            text = history.items[history.pos] or ""
            cursor = string.len(text)
        end
    elseif ukey == "DOWN" then
        if history.pos < #history.items then
            history.pos = history.pos + 1
            text = history.items[history.pos] or ""
            cursor = string.len(text)
        end
    elseif ukey == "RETURN" then
        if string.trim(text) ~= "" then
            local cmd = string.lower(text)
            here():commandProcessor(cmd)
            table.insert(history.items, cmd)
            history.pos = #history.items + 1
        end
        text = ""
        cursor = 0
    end
    while #history.items > 10 do
        table.remove(history.items, 1)
    end
    if history.pos < 1 then
        history.pos = 1
    elseif history.pos > #history.items + 1 then
        history.pos = #history.items + 1
    end
    return cursor, text
end

function initializeProcessor()
    return {
        cursor = 0,
        text = "",
        history = {
            pos = false,
            items = {}
        },
        hdevice = false,
        cache = {},
        draw = function(s)
            if not s.hdevice then
                s.hdevice = es.sprite(config.w, 50, config.bg)
            else
                s.hdevice:fill(config.bg)
            end
            local prompt = ">"
            local cursor = s.cache.cursor
            if not cursor then
                cursor = es.sprite(config.fw, config.fh, config.fg, 60)
                s.cache.cursor = cursor
            end
            local app = config.fw * #prompt
            cursor:copy(s.hdevice, s.cursor * config.fw + app, 5)
            config.fnt:text(prompt, config.prompt.fg):draw(s.hdevice, 0, 5)
            local tt = string.lower(s.text)
            local len = #tt
            local shift = 0
            for i = 1, len do
                local c = string.sub(tt, i, i)
                local cz = s.cache[c]
                if not cz then
                    cz = config.fnt:text(c, config.fg)
                    s.cache[c] = cz
                end
                cz:draw(s.hdevice, app + shift, 5)
                shift = shift + config.fw
            end
            return s.hdevice
        end,
        processKey = function(s, press, key)
            if not press then
                return false
            end
            local cursor,text = processKey(key, s.text, s.cursor, s.history)
            if #text > 80 then
                return false
            end
            s.cursor,s.text = cursor,text
            return true
        end
    }
end

function initializeTerminal()
    return {
        newline = false,
        hdevice = false,
        input = initializeProcessor(),
        lines = {},
        drawn = false,
        device = function(s)
            if not s.hdevice then
                s.hdevice = es.sprite(config.w, config.h, config.bg)
            end
            return s.hdevice
        end,
        draw = function(s)
            if s.drawn then
                return s.drawn
            end
            s.drawn = s:device()
            s.drawn:fill(config.bg)
            for i,v in ipairs(s.lines) do
                if v == "`" then v = " " end
                if v == "-" then
                    sprite.new("theme/line.png"):
                        draw(s.drawn, 0, (i - 1) * config.fh + 6)
                elseif v == "~" then
                    sprite.new("theme/lock.png"):
                        draw(s.drawn, 0, (i - 1) * config.fh - 4)
                    config.fnt:text("Режим ограниченной функциональности",
                        config.fg):draw(s.drawn, 26, (i - 1) * config.fh - 2)
                elseif v:startsWith("<loading") then
                    local num = tonumber(v:sub(9, #v - 1))
                    local max,h = 20,config.fh / 2
                    local spr = es.sprite(20 * 8, h, config.fg)
                    spr:fill(1, 1, 20 * 8 - 2, h - 2, config.bg)
                    spr:fill(0, 0, num * 8, h, config.fg)
                    config.fnt:text("Подождите:", config.fg)
                        :draw(s.drawn, 0, (i - 1) * config.fh)
                    spr:draw(s.drawn, 10 * config.fw + 10,
                        (i - 1) * config.fh + 6)
                elseif v:startsWith("<boot") then
                    local num = tonumber(v:sub(6, #v - 1))
                    local max,h = 20,config.fh / 2
                    local spr = es.sprite(20 * 8, h, config.fg)
                    spr:fill(1, 1, 20 * 8 - 2, h - 2, config.bg)
                    spr:fill(0, 0, num * 8, h, config.fg)
                    spr:draw(s.drawn, 0, (i - 1) * config.fh + 6)
                else
                    config.fnt:text(v, config.fg)
                        :draw(s.drawn, 0, (i - 1) * config.fh)
                end
            end
            return s.drawn
        end,
        clear = function(s)
            s.drawn = false
            s.newline = false
            s.lines = {}
        end,
        write = function(s, str)
            s.drawn = false
            str = str or "`"
            if s.newline or #s.lines == 0 then
                table.insert(s.lines, str)
                s.newline = false
                if #s.lines > config.lines then
                    table.remove(s.lines, 1)
                end
            else
                s.lines[#s.lines] = s.lines[#s.lines]..str
            end
        end,
        writeLine = function(s, str)
            s:write(str)
            s.newline = true
        end,
        replaceLine = function(s, str)
            s.drawn = false
            s.lines[#s.lines] = str
        end,
        drawInput = function(s)
            return s.input:draw()
        end,
        processKey = function(s, press, key)
            return s.input:processKey(press, key)
        end,
        countLines = function(s)
            return #s.lines
        end
    }
end

function es.generateLog(seed, max)
    local function num(seed)
        return es.rnd(seed, 10, 1)
    end
    local function bignum(seed)
        return es.rnd(seed, 255, 1)
    end
    local content = {
        { "операция #%s завершена с кодом #%s", bignum, num },
        { "операция #%s приостановлена", bignum, num },
        { "операция #%s возобновлена", bignum, num },
        { "операция #%s", bignum },
        { "операция #%s завершена по таймауту", bignum },
        { "ошибка #%s", bignum },
        { "событие <ошибка при получении кода>" },
        { "операция #%s помещено в очередь", bignum }
    }
    local lines = {}
    local startI = es.rnd(seed, 1024)
    local seeds = es.rndArray(seed, max)
    local size = 0
    for i = 1, max do
        local s = seeds[i]
        local locs = es.rndArray(s, 3)
        local tpl = content[es.rnd(locs[1], #content)]
        local str = ""
        if #tpl == 1 then
            str = tpl[1]
        elseif #tpl == 2 then
            str = tpl[1]
            str = string.format(str, tpl[2](locs[2]))
        elseif #tpl == 3 then
            str = tpl[1]
            str = string.format(str, tpl[2](locs[2]), tpl[3](locs[3]))
        end
        table.insert(lines, string.format("[%06x] ", startI + i)..str)
        size = size + #str + 1
    end
    return lines, size
end

function es.terminal(tab)
    if not tab.header then
        tab.header = {
            "Управляющая оснастка НИОС Триангула",
            "Версия 7.4.1207",
            "-"
        }
        tab.commands_help = tab.commands_help or {}
        tab.commands = tab.commands or {}
        tab.commands["ver"] = function(s)
            return {
                "Триангула 7.4.1207",
                "Версия ядра 4.2.17"
            }
        end
    end
    tab.locked = tab.locked or (function(s)
        return false
    end)
    tab.loaded = false
    tab.disp = false
    tab.hdevice = false
    tab.noinv = true
    tab.fromLocation = false
    tab.terminal = initializeTerminal()
    tab.vars = tab.vars or {}
    tab.vars["timer"] = false
    tab.vars["anim"] = 1
    tab.vars["next"] = false
    tab.pic = function(s)
        es.setTheme("terminal")
        if not s.hdevice then
            s.hdevice = es.sprite(config.w, config.h, config.bg)
        end
        return s.hdevice
    end
    tab.enter = function(s)
        timer:set(math.floor(1000 / 10))
        if not s.loaded then
            s:loadOnlyData()
            s.loaded = true
        end
        if not tab.fromLocation then
            tab.fromLocation = s:from().nam
        end
        s.terminal:writeLine("Загрузка...")
        s.terminal:writeLine("<empty>")
        s.vars["timer"] = true
        s.vars["next"] = "$welcome"
    end
    tab.printAny = function(s, data)
        if type(data) == "table" then
            for i,v in ipairs(data) do
                if not v or v == "" then
                    s.terminal:writeLine()
                else
                    s.terminal:writeLine(v)
                end
            end
        else
            s.terminal:writeLine(tostring(data))
        end
    end
    tab.printWelcome = function(s)
        s:printHeader()
        if s.welcome then
            s:printAny(es.apply(s.welcome, s))
        else
            s.terminal:writeLine("help: вызов справки по доступным командам")
            s.terminal:writeLine("exit: завершение сессии")
        end
        if s:locked() then
            s.terminal:writeLine()
            s.terminal:writeLine("~")
        end
    end
    tab.save = function(s)
        local m = _("main")
        m.state[s.nam] = {
            fromLocation = s.fromLocation,
            buffer = s.terminal.lines,
            text = s.terminal.input.text,
            history = s.terminal.input.history,
            cursor = s.terminal.input.cursor
        }
        if s.vars then
            m.state[s.nam].vars = s.vars
        end
    end
    tab.load = function(s)
        if not s:loadOnlyData() then
            s:printWelcome()
        end
        s:save()
        s.loaded = true
    end
    tab.loadOnlyData = function(s)
        local m = _("main")
        if m.state and m.state[s.nam] then
            local st = m.state[s.nam]
            s.fromLocation = st.fromLocation
            s.terminal.lines = st.buffer
            s.terminal.input.text = st.text
            s.terminal.input.history = st.history
            s.terminal.input.cursor = st.cursor
            s.terminal.drawn = false
            if st.vars then
                s.vars = st.vars
            end
            return true
        else
            return false
        end
    end
    tab.drawOutput = function(s)
        local output = s.terminal:draw()
        if output then
            output:copy(s:pic(), 30, 20)
        end
        return output
    end
    tab.drawInput = function(s)
        if s.vars.timer then
            return false
        end
        local input = s.terminal:drawInput()
        if input then
            local w,h = input:size()
            input:copy(s:pic(), 30, config.h - 50)
        end
        return input
    end
    tab.timer = function(s)
        local ret = s:loading()
        local ret2 = s:drawOutput() and s:drawInput()
        if ret or ret2 then
            s:save()
        end
        return ret or ret2
    end
    tab.loading = function(s)
        if s.vars.timer then
            if s.vars.timer == true then
                s.vars.timer = 0
                if s.vars.next == "$welcome" then
                    es.sound("startup")
                else
                    es.sound("startup_short")
                end
            end
            s.vars.timer = s.vars.timer + 1
            s.vars.anim = s.vars.anim + 1
            if s.vars.next == "$welcome" then
                s.terminal:replaceLine("<boot"..tostring(s.vars.anim)..">")
            else
                s.terminal:replaceLine("<loading"..tostring(s.vars.anim)..">")
            end
            if s.vars.timer == 21 then
                s.vars.timer = 0
                s.vars.anim = 0
                s.vars.timer = false
                if s.vars.next then
                    local nxt = s.vars.next
                    s.vars.next = false
                    s:save()
                    s:commandProcessor(nxt, true)
                end
            end
            return true
        end
    end
    tab.onkey = function(s, press, key)
        if s.vars.timer then
            return false
        end
        if s.terminal:processKey(press, key) then
            return s:drawInput()
        end
        return false
    end
    tab.printHeader = function(s)
        if not s.header then
            return false
        end
        s:printAny(s.header)
        s.terminal:writeLine()
        return true
    end
    tab.outputPrefix = function(s, cmd)
        s.terminal:clear()
        s:printHeader()
        s.terminal:writeLine("> " .. cmd)
    end
    tab.arg = function(s, args, i)
        i = i or 1
        if args and #args >= i then
            return args[i]
        else
            return nil
        end
    end
    tab.reset = function(s)
        s.terminal:clear()
        s.hdevice = false
        s.terminal.input.text = ""
        s.terminal.input.cursor = 0
    end
    tab.beep = function(s)
        es.sound("error")
    end
    tab.error = function(s, txt)
        s:beep()
        return "Ошибка! "..txt
    end
    tab.commandProcessor = function(s, cmd, loaded)
        local arr = cmd:split(" ")
        local head = arr[1]
        table.remove(arr, 1)
        if head == "cls" then
            s.terminal:clear()
            s:printHeader()
            return true
        elseif head == "exit" then
            es.sound("shutdown")
            s:reset()
            s:save()
            if s.before_exit then
                local res = es.apply(s.before_exit, s)
                if not res then
                    walkout(s.fromLocation)
                end
            else
                walkout(s.fromLocation)
            end
            return true
        elseif head == "acl" then
            s:outputPrefix(cmd)
            if s:locked() then
                s.terminal:writeLine("Уровень доступа: ограниченный")
            else
                s.terminal:writeLine("Уровень доступа: стандартный пользователь")
            end
        elseif head == "netaddr" then
            s:outputPrefix(cmd)
            local arr = {}
            for i = 1, #s.nam, 1 do
                table.insert(arr, string.byte(s.nam:sub(i, i + 1)))
            end
            local len = #arr
            while len > 6 do
                arr[len - 1] = arr[len - 1] + arr[len]
                arr[len] = nil
                len = len - 1
            end
            s.terminal:writeLine("Сетевой адрес: " .. table.concat(arr, "::"))
        elseif head == "help" then
            s:outputPrefix(cmd)
            for k,v in pairs(s.commands_help) do
                s.terminal:write(k)
                s.terminal:write(": ")
                s.terminal:writeLine(v)
            end
            s.terminal:writeLine("ver: информация о версии")
            s.terminal:writeLine("help: вызов справки")
            s.terminal:writeLine("cls: очистка экрана")
            s.terminal:writeLine("acl: проверка уровня доступа")
            s.terminal:writeLine("netaddr: вывести сетевой адрес терминала")
            s.terminal:writeLine("exit: завершение сессии")
        elseif head == "$welcome" then
            s.terminal:clear()
            s:printWelcome()
        else
            if s.before_command then
                local res = s:before_command(cmd, arr, loaded)
                if res then
                    s:outputPrefix(cmd)
                    s.terminal:writeLine(res)
                    return true
                end
            end
            return s:commandExecutor(cmd, head, arr, loaded)
        end
        return false
    end
    tab.commandExecutor = function(s, cmd, head, arr, loaded)
        local cmdObj = s.commands[head]
        if not cmdObj then
            s:outputPrefix(cmd)
            s.terminal:writeLine(s:error("Неизвестная команда: " .. cmd))
            return true
        elseif head ~= "ver" and s:locked() and (not s.acl or not s.acl[head]) then
            s:outputPrefix(cmd)
            s.terminal:writeLine(s:error("Нет доступа!"))
            return true
        else
            local res = cmdObj(s, arr, loaded)
            s:outputPrefix(cmd)
            if res == "$load" then
                s.vars["timer"] = true
                s.vars["next"] = cmd
                s:printAny(".")
            else
                if res then
                    s:printAny(res)
                end
            end
            return true
        end
    end
    return room(tab)
end