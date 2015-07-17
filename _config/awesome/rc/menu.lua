local lucasb = require("lib/lucasb")

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome", "/usr/share/icons/oxygen/16x16/actions/help-contents.png" },
   { "restart", awesome.restart, "/usr/share/icons/oxygen/16x16/actions/view-refresh.png" },
   { "quit", awesome.quit, "/usr/share/icons/oxygen/16x16/actions/system-log-out.png" }
}

powermenu = {
    { "shutdown", "systemctl poweroff", "/usr/share/icons/oxygen/16x16/actions/system-shutdown.png" },
    { "reboot", "systemctl reboot", "/usr/share/icons/oxygen/16x16/actions/system-reboot.png" },
    { "suspend", lucasb.standby, "/usr/share/icons/oxygen/16x16/actions/system-suspend.png" },
    { "hibernate", lucasb.hibernate, "/usr/share/icons/oxygen/16x16/actions/system-suspend-hibernate.png" },
    { "lock", lucasb.lockscreen, "/usr/share/icons/oxygen/16x16/actions/system-lock-screen.png" },
    { "lock & suspend", function() lucasb.lockscreen() lucasb.standby() end, "/usr/share/icons/oxygen/16x16/actions/system-lock-screen.png" },
    { "lock & hibernate", function() lucasb.lockscreen() lucasb.hibernate() end, "/usr/share/icons/oxygen/16x16/actions/system-lock-screen.png" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "power", powermenu, "/usr/share/icons/oxygen/16x16/actions/quickopen.png" },
                                    { "terminal", terminal, "/usr/share/icons/oxygen/16x16/apps/utilities-terminal.png" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
