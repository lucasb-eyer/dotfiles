-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Simple function to load additional LUA files from rc/.
function loadrc(name, mod)
    -- Which file? In rc/ or in lib/?
    local path = awful.util.getdir("config") .. (mod and "/lib/" or "/rc/") .. name .. ".lua"

    -- If the module is already loaded, don't load it again
    if mod and package.loaded[mod] then return package.loaded[mod] end

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

    -- Is it a module?
    if mod then
        return package.loaded[mod]
    end

    return result
end

loadrc("errors")

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
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

loadrc("appearance")
loadrc("tags")
loadrc("menu")
loadrc("wibox")
loadrc("bindings")
loadrc("rules")
loadrc("signals")
loadrc("autostart")
