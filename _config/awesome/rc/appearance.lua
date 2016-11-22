-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/" .. themes[itheme] .. "/theme.lua")

function get_wallpaper_file()
    return lucasb.random_file({"~/.config/wallpapers", "~/.config/wallpapers/nsfw"})
end

function switchtheme()
    itheme = itheme + 1
    if not themes[itheme] then
        itheme = 1
    end

    loadrc("appearance")
    loadrc("menu")
    loadrc("wibox")
end

