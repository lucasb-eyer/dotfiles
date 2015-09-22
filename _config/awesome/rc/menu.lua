local keydoc = require("lib/keydoc")
local lucasb = require("lib/lucasb")

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "hotkeys", keydoc.display, "/home/beyer/.config/awesome/themes/hotkey.png" },
   { "restart", awesome.restart, "/home/beyer/.config/awesome/themes/reboot.png" },
   { "quit", awesome.quit, "/home/beyer/.config/awesome/themes/account-logout.png" }
}

powermenu = {
    { "shutdown", "systemctl poweroff", "/home/beyer/.config/awesome/themes/poweroff.png" },
    { "reboot", "systemctl reboot", "/home/beyer/.config/awesome/themes/reboot.png" },
    { "suspend", lucasb.standby, "/home/beyer/.config/awesome/themes/suspend.png" },
    { "lock", lucasb.lockscreen, "/home/beyer/.config/awesome/themes/lock.png" },
    { "lock & suspend", function() lucasb.lockscreen() lucasb.standby() end, "/home/beyer/.config/awesome/themes/lock-suspend.png" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, "/home/beyer/.config/awesome/themes/awesome.png" }, -- beautiful.awesome_icon },
                                    { "power", powermenu, "/home/beyer/.config/awesome/themes/poweroff.png" },
                                    { "terminal", terminal, "/home/beyer/.config/awesome/themes/terminal.png" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
