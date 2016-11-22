local lucasb = {}

local center = function(rect)
    return {x = rect.x + rect.width/2, y = rect.y + rect.height/2}
end

local from_to = function(from, to)
    return {x = to.x - from.x, y = to.y - from.y}
end

local from_center_to_center = function(from_rect, to_rect)
    return from_to(center(from_rect), center(to_rect))
end

local direction_to_angle = function(dir)
    return dir == "down" and   math.pi/2 or
           dir == "left" and   math.pi   or
           dir == "up"   and 3*math.pi/2 or
                                  0
end

local angle = function(vec)
    return math.atan2(vec.y, vec.x)
end

local anglediff = function(rad1, rad2)
    local rawdiff = ((math.abs(rad2 - rad1)/math.pi*180) % 360)/180*math.pi
    if rawdiff > math.pi then
        return 2*math.pi - rawdiff
    else
        return rawdiff
    end
end

-- Generates a function that does the same as the new awful function sharing
-- the same name.
lucasb.focus_global_bydirection = function (dir)
    if awful.client.focus.global_bydirection then
        return function ()
            awful.client.focus.global_bydirection(dir)
        end
    end

    return function ()
        local currc = client.focus
        awful.client.focus.bydirection(dir)

        -- If the focus didn't change window, we may need to change screen.
        if currc == client.focus then
            local best = {angle=math.huge, client=nil}
            local mid = center(currc:geometry())
            local adir = direction_to_angle(dir)

            -- Go through all the clients and check which one is "the chosen One"
            for cid, c in ipairs(client.get()) do
                if c:isvisible() and c ~= currc then
                    -- "The chosen One" being the one whose center connected 
                    -- to the center of the current one forms an angle the most
                    -- similar to "dir". Wow that was bad.
                    local line = from_to(mid, center(c:geometry()))
                    local da = anglediff(angle(line), adir)
                    -- pi/2.1 because pi/2 is slightly too "precise"
                    -- (going down might go left/right if there's nothing below)
                    if da < best.angle and da < math.pi/2.1 then
                        best.angle = da
                        best.client = c
                    end
                end
            end

            if best.client then
                client.focus = best.client
                awful.screen.focus(best.client.screen)
            end
        end
    end
end

lucasb.file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

lucasb.random_file = function(directories, types)
    dir = ""
    if type(directories) == "table" then
        dir = table.concat(directories, " ")
    elseif type(directories) == "string" then
        dir = directories
    end

    filt = ""
    if type(types) == "table" then
        filt = "-name '" .. table.concat(types, "' -o -name '") .. "'"
    elseif type(types) == "string" then
        filt = "-name '" .. types .. "'"
    end

    return awful.util.pread("find " .. dir .. " -maxdepth 1 -type f " .. filt .. " | shuf -n 1 | xargs echo -n")
end

-- Totally undocumented, but the return value of these functions is used
-- by the menu: https://github.com/awesomeWM/awesome/blob/0f02ed0e/lib/awful/menu.lua.in#L259-L270
-- false/nil = close menu, true = redraw menu.
lucasb.lockscreen = function(imgfile)
    -- spawn returns a pid on success, a string on fail.
    if type(awful.util.spawn("xscreensaver-command -lock")) == "number" then
        return
    elseif type(awful.util.spawn("i3lock -i '" .. imgfile .. "'")) == "number" then
        return
    elseif type(awful.util.spawn("gnome-screensaver-command --lock")) == "number" then
        return
    end
end

lucasb.standby = function()
    -- Necessary to avoid a crash on next usage of `optirun` after waking up on my laptop.
    awful.util.spawn("systemctl stop bumblebeed.service")

    -- Another option is `echo mem > /sys/power/state
    awful.util.spawn("systemctl suspend")
end

lucasb.hibernate = function()
    -- Another option is `echo disk > /sys/power/state
    awful.util.spawn("systemctl hibernate")
end

-- Battery stuff

lucasb.batt_percent = function()
    local fcap = io.open("/sys/class/power_supply/BAT0/capacity", "r")
    if fcap then
        cap = tonumber(fcap:read())
        io.close(fcap)
        return cap
    end
    return 0
end

lucasb.batt_status = function()
    local fstat = io.open("/sys/class/power_supply/BAT0/status", "r")
    if fstat then
        stat = fstat:read()
        io.close(fstat)
        return stat
    end
    return "Unknown"
end

lucasb.batt_info = function()
    -- Try with `upower` first.
    batt_info = awful.util.pread(
        "upower -i `upower -e grep BAT`" .. -- info about the battery
        "| grep -E 'state|time to|percent'" .. -- only the info we want
        "| awk '{$1=$1};1'" .. -- condense all whitespace to a single one
        "| head -c-1" -- remove single trailing newline.
    )
    if batt_info ~= '' then
        return batt_info
    end

    -- Alternatively, get less info from `/sys`.
    return lucasb.batt_percent() .. "%, " .. lucasb.batt_status()
end

return lucasb
