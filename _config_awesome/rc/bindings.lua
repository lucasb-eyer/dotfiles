local keydoc = loadrc("keydoc", "vbe/keydoc")
local lucasb = require("lib/lucasb")

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    keydoc.group("Navigation"),
    awful.key({ modkey }, "s", function () awful.screen.focus_relative(1) end, "Focus next screen"),

    -- Clients
    awful.key({ modkey }, "j", lucasb.focus_global_bydirection("down"), "Focus client below"),
    awful.key({ modkey }, "k", lucasb.focus_global_bydirection("up"), "Focus client above"),
    awful.key({ modkey }, "h", lucasb.focus_global_bydirection("left"), "Focus client on the left"),
    awful.key({ modkey }, "l", lucasb.focus_global_bydirection("right"), "Focus client on the right"),

    -- Tags
    awful.key({ modkey }, "Left",   awful.tag.viewprev, "View left tag"),
    awful.key({ modkey }, "Right",  awful.tag.viewnext, "View right tag"),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, "View previous tag"),

    keydoc.group("Layout manipulation"),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end, "Rotate clients left"),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end, "Rotate clients right"),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto, "Focus first urgent client"),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end,
        "Focus previously focused client"
    ),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    --awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    --awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    keydoc.group("Multimedia"),
    awful.key({ modkey }, "F10", function () awful.util.spawn ("amixer -q sset Master 2dB-") end, "Decrease sound volume"),
    awful.key({ modkey }, "F11", function () awful.util.spawn ("amixer -q sset Master 2dB+") end, "Increase sound volume"),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn ("amixer -q sset Master 2dB-") end, "Decrease sound volume"),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn ("amixer -q sset Master 2dB+") end, "Increase sound volume"),

    keydoc.group("Misc"),
    awful.key({ }, "Scroll_Lock", function () awful.util.spawn("xscreensaver-command -lock") end, "Lock the session"),
    awful.key({ }, "Print", function () awful.util.spawn('gm import -window root "' .. os.getenv("HOME") .. os.date('/%Y-%m-%d_%H:%M:%S.png"')) end, "Screenshot"),
    awful.key({ modkey }, "w", function () mymainmenu:show({keygrabber=true}) end, "Open the menu"),
    awful.key({ modkey }, "F1", keydoc.display)
)

clientkeys = awful.util.table.join(
    keydoc.group("FooBar"),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Start xscreensaver daemon
awful.util.spawn("xscreensaver -nosplash")

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
