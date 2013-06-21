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

return lucasb
