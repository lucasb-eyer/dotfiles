-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/" .. themes[itheme] .. "/theme.lua")

function switchtheme()
    itheme = itheme + 1
    if not themes[itheme] then
        itheme = 1
    end

    loadrc("appearance")
    loadrc("menu")
    loadrc("wibox")
end

