-- Standard awesome libs
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
menubar = require("menubar")

-- Simple function to load additional LUA files from rc/.
function loadrc(name)
    local path = awful.util.getdir("config") .. "/rc/" .. name .. ".lua"

    -- Execute the RC/module file
    local success
    local result
    success, result = pcall(function() return dofile(path) end)
    if not success then
        naughty.notify({
            title = "Error while loading an RC file",
            text = "When loading `" .. name .. "`, got the following error:\n" .. result,
            preset = naughty.config.presets.critical
        })
        return print("E: error loading RC file '" .. name .. "': " .. result)
    end

    return result
end

loadrc("errors")
lucasb = dofile(awful.util.getdir("config") .. "/lib/lucasb.lua")
xrandr = loadrc("multihead")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    --awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

-- TODO: Automatically determine from folders in themes folder.
themes =
{
    "solarized-dark",
    "solarized-light"
}
itheme = 1

-- Focus automatically following the mouse.
require("awful.autofocus")

loadrc("appearance")
loadrc("tags")
loadrc("menu")
loadrc("wibox")
loadrc("bindings")
loadrc("rules")
loadrc("signals")
loadrc("autostart")
