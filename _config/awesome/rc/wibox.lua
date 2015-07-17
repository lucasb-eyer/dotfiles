-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a battery widget on laptops
mybattery = nil
mybattery_timer = nil
if lucasb.file_exists("/sys/class/power_supply/BAT0/status") then
    mybattery = awful.widget.progressbar()
    mybattery:set_width(13)
    mybattery:set_vertical(true)
    mybattery_tip = awful.tooltip({objects = {mybattery}})
    lastalarm = 0

    if not mybattery_timer then
        battery_timer = timer({timeout = 1})
        battery_timer:connect_signal("timeout", function()
            local fcap = io.open("/sys/class/power_supply/BAT0/capacity", "r")
            local fstat = io.open("/sys/class/power_supply/BAT0/status", "r")
            if fcap and fstat then
                local cap = tonumber(fcap:read())
                local stat = fstat:read()
                io.close(fcap)
                io.close(fstat)

                mybattery:set_value(cap/100.0)
                mybattery_tip:set_text(cap .. "%, " .. stat)

                if stat == "Charging" or stat == "Full" then
                    mybattery:set_color(beautiful.bg_focus)
                else
                    if cap >= 3 then
                        mybattery:set_color(beautiful.colors.yellow)
                    else
                        mybattery:set_color(beautiful.bg_urgent)

                        -- Don't spam that thing, that'd be annoying
                        if lastalarm == 0 then
                            naughty.notify({
                                preset = naughty.config.presets.critical,
                                title = "Low Battery",
                                text = "Battery's almost empty! (" .. cap .. "% left)",
                                font = "Liberation 20",
                                timeout = 30
                            })
                        end
                        lastalarm = lastalarm + 1
                        if lastalarm > 30 then lastalarm = 0 end
                    end
                end
            end
        end)
        battery_timer:start()
        battery_timer:emit_signal("timeout")
    end
end

-- Create a systray
--mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}

-- Define the actions of the mouse buttons on the taglist.
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

-- Define the actions of the mouse buttons on the tasklist.
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    if mybattery then right_layout:add(mybattery) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
