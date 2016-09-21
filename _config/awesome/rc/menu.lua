local keydoc = require("lib/keydoc")
local lucasb = require("lib/lucasb")

local icondir = awful.util.getdir("config") .. "/themes/"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "&hotkeys", keydoc.display, icondir .. "hotkey.png" },
   { "&restart", awesome.restart, icondir .. "reboot.png" },
   { "&quit", awesome.quit, icondir .. "account-logout.png" }
}

powermenu = {
    { "&shutdown", "systemctl poweroff", icondir .. "poweroff.png" },
    { "&reboot", "systemctl reboot", icondir .. "reboot.png" },
    { "s&uspend", lucasb.standby, icondir .. "suspend.png" },
    { "&lock", lucasb.lockscreen, icondir .. "lock.png" },
    { "l&ock & suspend", function() lucasb.lockscreen() lucasb.standby() end, icondir .. "lock-suspend.png" },
}

mymainmenu = awful.menu.new({ items = {
    { "&awesome", myawesomemenu, icondir .. "awesome.png" }, -- beautiful.awesome_icon },
    { "&power", powermenu, icondir .. "poweroff.png" },
    { "&terminal", terminal, icondir .. "terminal.png" }
  }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
