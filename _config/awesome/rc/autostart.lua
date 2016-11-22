local lucasb = require("lib/lucasb")

-- Doing it the lua way instead of spawn_with_shell because the latter depends
-- on which shell the user is using.
function run_once(cmd, args, pname)
    args = args or ""
    pname = pname or cmd
    local out = awful.util.pread("pgrep " .. pname)
    if out:len() == 0 then
        awful.util.spawn(cmd .. " " .. args)
    end
end

-- These probably have a better place to live, outside of awesomewm.
awful.util.spawn("setxkbmap -variant altgr-intl")
awful.util.spawn("synclient HorizTwoFingerScroll=1 VertScrollDelta=-101 HorizScrollDelta=-101")

-- run_once("xscreensaver", "-nosplash", nil)
run_once("nm-applet")
run_once("redshift-gtk", "-l 50.47:6.51", "redshift")  -- Los-Angeles: 34.00:-118.46
run_once("volumeicon")
run_once("taralli")
run_once("dropbox")

-- Goes through wallpapers in ~/.config/wallpapers
local wp_timer = timer({timeout = 5*60})
wp_timer:connect_signal("timeout", function()
    local wp = get_wallpaper_file()
    if wp ~= '' then
        gears.wallpaper.maximized(wp)
    end
end)
wp_timer:start()
wp_timer:emit_signal("timeout")
