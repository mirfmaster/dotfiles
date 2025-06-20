--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local mytable        = awful.util.table or gears.table -- 4.{0,1} compatibility
local explorer       = "nautilus"

local screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots/"
os.execute("mkdir -p " .. screenshot_dir)

-- Helper function for screenshot with save and copy
local function screenshot_with_copy(cmd)
    return function()
        local filename = screenshot_dir .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
        -- Execute screenshot command and save file
        awful.spawn.easy_async(cmd .. " '" .. filename .. "'", function()
            -- Copy the saved file to clipboard
            awful.spawn.easy_async("xclip -selection clipboard -t image/png -i '" .. filename .. "'", function()
                naughty.notify({
                    title = "Screenshot taken",
                    text = "Saved to " .. screenshot_dir .. " and copied to clipboard",
                    timeout = 2
                })
            end)
        end)
    end
end
-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function(err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
    awful.spawn.once("xmodmap ~/.Xmodmap")
    awful.spawn.with_shell("~/.config/awesome/touchpad-fix.sh")
    awful.spawn.with_shell("xinput set-prop 9 332 1")
    awful.spawn.with_shell('[ -n "$SSH_AUTH_SOCK" ] || eval `ssh-agent`')
    awful.spawn.with_shell('ssh-add ~/.ssh/zot_id_ed25519')
    awful.spawn.with_shell('ssh -T git@gitlab.zero-one-group.com')

    awful.spawn.with_shell(
        '[ -f ~/Applications/superProductivity.AppImage ] && ~/Applications/superProductivity.AppImage')
    awful.spawn.with_shell("~/.config/awesome/monitor-handler.sh")
end

run_once({
    -- "urxvtd",
    "unclutter -root", -- NOTE: Hide cursor while not used
    "nm-applet",       -- NOTE: Applet for showing network manager
    "blueman-applet",  -- NOTE: Applet for managing bluetooth
})

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

local themes                           = {
    "blackburn",       -- 1
    "copland",         -- 2
    "dremora",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "rainbow",         -- 8
    "steamburn",       -- 9
    "vertex"           -- 10
}

local chosen_theme                     = themes[7]
local modkey                           = "Mod4"
local altkey                           = "Mod1"
local terminal                         = "kitty"
local vi_focus                         = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev                       = true  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor                           = os.getenv("EDITOR") or "nvim"
local browser                          = "brave-browser"

awful.util.terminal                    = terminal
awful.util.tagnames                    = { "1", "2", "3", "4", "5", "6", "7" }
awful.layout.layouts                   = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

awful.util.taglist_buttons             = mytable.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
    { "Hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "Manual",      string.format("%s -e man awesome", terminal) },
    { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "Restart",     awesome.restart },
    { "Quit",        function() awesome.quit() end },
}

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- Hide the menu when the mouse leaves it
--[[
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not awful.util.mymainmenu.active_child or
       (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
       awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        awful.util.mymainmenu:hide()
    else
        awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
                awful.util.mymainmenu:hide()
            end
        end)
    end
end)
--]]

-- Set the Menubar terminal for applications that require it
--menubar.utils.terminal = terminal

-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and adak it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
    awful.button({}, 3, function() awful.util.mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = mytable.join(
-- NOTE: Custom
    awful.key({}, "Print", screenshot_with_copy("scrot"),
        { description = "take screenshot of entire screen, save and copy", group = "screenshot" }),

    -- Shift + Print Screen: Capture selected area
    awful.key({ "Shift" }, "Print", screenshot_with_copy("scrot -s"),
        { description = "take screenshot of selection, save and copy", group = "screenshot" }),

    -- Ctrl + Print Screen: Capture current window
    awful.key({ "Control" }, "Print", screenshot_with_copy("scrot -u"),
        { description = "take screenshot of active window, save and copy", group = "screenshot" }),

    -- Show help
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    -- Tag browsing
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    -- Non-empty tag browsing
    -- awful.key({ altkey }, "Left", function() lain.util.tag_view_nonempty(-1) end,
    --     { description = "view  previous nonempty", group = "tag" }),
    -- awful.key({ altkey }, "Right", function() lain.util.tag_view_nonempty(1) end,
    --     { description = "view  previous nonempty", group = "tag" }),

    -- Default client focus
    awful.key({ modkey, "Control" }, "l",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, "Control", }, "h",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- By-direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }),

    -- Menu
    awful.key({ modkey, }, "w", function() awful.util.mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "cycle with previous/go back", group = "client" }),

    -- Show/hide wibox
    awful.key({ modkey }, "z", function()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        { description = "toggle wibox", group = "awesome" }),

    -- On-the-fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function() lain.util.useless_gaps_resize(1) end,
        { description = "increment useless gaps", group = "tag" }),
    awful.key({ altkey, "Control" }, "-", function() lain.util.useless_gaps_resize(-1) end,
        { description = "decrement useless gaps", group = "tag" }),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function() lain.util.add_tag() end,
        { description = "add new tag", group = "tag" }),
    awful.key({ modkey, "Shift" }, "r", function() lain.util.rename_tag() end,
        { description = "rename tag", group = "tag" }),
    awful.key({ modkey, "Shift" }, "Left", function() lain.util.move_tag(-1) end,
        { description = "move tag to the left", group = "tag" }),
    awful.key({ modkey, "Shift" }, "Right", function() lain.util.move_tag(1) end,
        { description = "move tag to the right", group = "tag" }),
    awful.key({ modkey, "Shift" }, "d", function() lain.util.delete_tag() end,
        { description = "delete tag", group = "tag" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    -- Combined keys for both master width factor and floating window size
    awful.key({ modkey }, "-", function()
        if client.focus and client.focus.floating then
            -- Decrease floating window size
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                width = math.max(20, geo.width - 20),
                height = math.max(20, geo.height - 20)
            })
        else
            -- Increase master width factor
            awful.tag.incmwfact(0.05)
        end
    end, { description = "decrease floating window size or increase master width factor", group = "client" }),
    awful.key({ modkey }, "=", function()
        if client.focus and client.focus.floating then
            -- Increase floating window size
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                width = geo.width + 20,
                height = geo.height + 20
            })
        else
            -- Decrease master width factor
            awful.tag.incmwfact(-0.05)
        end
    end, { description = "increase floating window size or decrease master width factor", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", awful.tag.viewprev,
        { description = "view next tag", group = "tag" }),
    awful.key({ modkey, "Shift" }, "l", awful.tag.viewnext,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "/", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
    awful.key({ modkey }, "n", function()
        -- Get the oldest/current notification
        local notification = naughty.notifications[1]
        if notification and notification.box then
            -- Simulate a click on the notification
            notification.box:emit_signal("button::press", 1, 1, 1)
            notification.box:emit_signal("button::release", 1, 1, 1)
        end
    end, { description = "open current notification", group = "custom" }),
    awful.key({ modkey, "Control" }, "n", function()
        naughty.destroy_all_notifications()
    end, { description = "close all notifications", group = "custom" }),
    awful.key({ modkey, "Control" }, "m", function()
        if client.focus then
            -- If there's a focused window
            if client.focus.minimized then
                -- If it's minimized, restore it
                client.focus:emit_signal("request::activate", "key.unminimize", { raise = true })
                client.focus.minimized = false
            else
                -- If it's not minimized, minimize it
                client.focus.minimized = true
            end
        else
            -- If no window is focused, try to restore the last minimized window
            local c = awful.client.restore()
            if c then
                c:emit_signal("request::activate", "key.unminimize", { raise = true })
            end
        end
    end, { description = "toggle minimize window", group = "client" }),
    awful.key({ modkey, "Shift" }, "o", function()
        awful.spawn.with_shell("~/.labs/scripts/utils/rofi-otp.sh")
    end, { description = "OTP menu", group = "launcher" }),

    -- User programs
    awful.key({ modkey }, "b", function() awful.spawn(browser) end,
        { description = "run browser", group = "launcher" }),

    awful.key({ modkey }, "q", function()
            if client.focus then
                client.focus:kill()
            end
        end,
        { description = "Kill client", group = "client" }),

    -- NOTE: CUSTOM
    awful.key({ modkey }, "space",
        function()
            awful.spawn(
                "rofi -show-icons -sidebar-mode -show drun -terminal alacritty -theme ~/.config/rofi/config.rasi")
        end,
        { description = "show rofi", group = "launcher" }),
    awful.key({ modkey }, "e",
        function()
            awful.spawn(explorer)
        end,
        { description = "open file explorer", group = "launcher" }),
    awful.key({ modkey }, "[",
        function()
            awful.spawn.with_shell("kitty -d \"/home/mirf/Documents/Vaults/The Second Brain\" nvim")
        end,
        { description = "open second brain", group = "launcher" }),

    awful.key({ modkey }, "]",
        function()
            awful.spawn.with_shell(
                "kitty -d \"/home/mirf/Documents/Vaults/The Second Brain/01 Personal/Trash Notes\" nvim")
        end,
        { description = "open trash notes", group = "launcher" }),

    -- NOTE: sudo usermod -aG video mirf
    awful.key({ modkey }, "F11",
        function()
            awful.util.spawn_with_shell("brightnessctl set 5%- -n 1")
            awful.util.spawn_with_shell(
                "if [ $(brightnessctl g) -lt $(( $(brightnessctl m) / 10 )) ]; then brightnessctl set 5%; fi")
        end),

    awful.key({ modkey }, "F12",
        function()
            awful.util.spawn_with_shell("brightnessctl set +5% -n 1")
            awful.util.spawn_with_shell(
                "if [ $(brightnessctl g) -gt $(brightnessctl m) ]; then brightnessctl set 100%; fi")
        end),

    -- If you also want function key bindings without Super:
    awful.key({}, "XF86MonBrightnessDown",
        function()
            awful.util.spawn_with_shell("brightnessctl set 5%- -n 1")
            awful.util.spawn_with_shell(
                "if [ $(brightnessctl g) -lt $(( $(brightnessctl m) / 10 )) ]; then brightnessctl set 5%; fi")
        end),

    awful.key({}, "XF86MonBrightnessUp",
        function()
            awful.util.spawn_with_shell("brightnessctl set +5% -n 1")
            awful.util.spawn_with_shell(
                "if [ $(brightnessctl g) -gt $(brightnessctl m) ]; then brightnessctl set 100%; fi")
        end),

    -- NOTE: SOUND
    awful.key({ "Mod4" }, "F3",
        function()
            awful.util.spawn_with_shell([[
                current_vol=$(amixer get Master | grep -o "[0-9]*%" | head -1 | tr -d '%')
                if [ $current_vol -lt 100 ]; then
                    amixer -q sset Master 5%+
                else
                    amixer -q sset Master 100%
                fi
            ]])
        end),

    -- Super + F2: Volume Down (min 0%)
    awful.key({ "Mod4" }, "F2",
        function()
            awful.util.spawn_with_shell([[
                current_vol=$(amixer get Master | grep -o "[0-9]*%" | head -1 | tr -d '%')
                if [ $current_vol -gt 0 ]; then
                    amixer -q sset Master 5%-
                fi
            ]])
        end),

    -- Super + F1: Toggle Mute
    awful.key({ "Mod4" }, "F1",
        function()
            awful.util.spawn_with_shell("amixer -q sset Master toggle")
        end),

    -- Optional: Function key bindings
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            awful.util.spawn_with_shell([[
                current_vol=$(amixer get Master | grep -o "[0-9]*%" | head -1 | tr -d '%')
                if [ $current_vol -lt 100 ]; then
                    amixer -q sset Master 5%+
                else
                    amixer -q sset Master 100%
                fi
            ]])
        end),

    awful.key({}, "XF86AudioLowerVolume",
        function()
            awful.util.spawn_with_shell([[
                current_vol=$(amixer get Master | grep -o "[0-9]*%" | head -1 | tr -d '%')
                if [ $current_vol -gt 0 ]; then
                    amixer -q sset Master 5%-
                fi
            ]])
        end),

    awful.key({}, "XF86AudioMute",
        function()
            awful.util.spawn_with_shell("amixer -q sset Master toggle")
        end),

    awful.key({ modkey }, "y", nil, function()
            local grabber = awful.keygrabber.run(function(mod, key, event)
                if event == "release" then return end

                -- Stop the grabber immediately after a key is pressed
                awful.keygrabber.stop(grabber)

                -- System commands
                if key == "l" then
                    os.execute(scrlocker)
                elseif key == "s" then
                    awful.spawn("systemctl poweroff")
                elseif key == "r" then
                    awful.spawn("systemctl reboot")
                elseif key == "u" then
                    awful.spawn("systemctl suspend")
                    -- elseif key == "h" then
                    --     awful.spawn("systemctl hibernate")
                end
            end)
        end,
        { description = "system commands (l=lock, s=shutdown, r=reboot, u=suspend)", group = "system" }),
    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),
    awful.key({ modkey }, "t", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, ".", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey }, ",", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" })

-- awful.key({ modkey }, "x",
--     function()
--         awful.prompt.run {
--             prompt       = "Run Lua code: ",
--             textbox      = awful.screen.focused().mypromptbox.widget,
--             exe_callback = awful.util.eval,
--             history_path = awful.util.get_cache_dir() .. "/history_eval"
--         }
--     end,
--     { description = "lua execute prompt", group = "awesome" })
--]]
)



local last_minimized_by_tag = {}
clientkeys = mytable.join(
    awful.key({ altkey, "Shift" }, "m", lain.util.magnify_client,
        { description = "magnify client", group = "client" }),
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    -- Floating and toggling
    awful.key({ modkey }, "g", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "space",
        function(c)
            local t = c.screen.selected_tag
            local tag_index = t.index

            if last_minimized_by_tag[tag_index] and
                last_minimized_by_tag[tag_index].valid and
                last_minimized_by_tag[tag_index].minimized then
                -- If there's a tracked minimized client for this tag, maximize it
                local min_c = last_minimized_by_tag[tag_index]
                min_c.minimized = false
                min_c.floating = true
                min_c:raise()
                client.focus = min_c
                last_minimized_by_tag[tag_index] = nil
            else
                -- Otherwise minimize current client and track it for this tag
                last_minimized_by_tag[tag_index] = c
                c.minimized = true
            end
        end,
        { description = "toggle minimize/maximize tracked window per tag", group = "client" }),
    -- Navigate through all windows (including minimized) with Mod+Ctrl+h/l
    awful.key({ modkey, "Control" }, "l", function()
        local tag = awful.screen.focused().selected_tag
        local all_clients = tag:clients()
        if #all_clients == 0 then return end

        -- Find current focused client index
        local current_index = 1
        for i, c in ipairs(all_clients) do
            if client.focus == c then
                current_index = i
                break
            end
        end

        -- Move to next client (with wrap-around)
        local next_index = (current_index % #all_clients) + 1
        local next_client = all_clients[next_index]

        -- Restore if minimized and focus
        if next_client.minimized then
            next_client.minimized = false
        end
        client.focus = next_client
        next_client:raise()
    end, { description = "navigate to next window (including minimized)", group = "client" }),
    awful.key({ modkey, altkey }, "=", function()
        if client.focus and client.focus.floating then
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                width = geo.width + 20,
                height = geo.height + 20
            })
        end
    end, { description = "increase floating window size", group = "client" }),
    awful.key({ modkey, altkey }, "-", function()
        if client.focus and client.focus.floating then
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                width = math.max(20, geo.width - 20),
                height = math.max(20, geo.height - 20)
            })
        end
    end, { description = "decrease floating window size", group = "client" }),

    -- Move floating windows with keyboard
    awful.key({ modkey, altkey }, "h", function()
        if client.focus and client.focus.floating then
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                x = geo.x - 40,
                y = geo.y
            })
        end
    end, { description = "move floating window left", group = "client" }),

    awful.key({ modkey, altkey }, "l", function()
        if client.focus and client.focus.floating then
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                x = geo.x + 40,
                y = geo.y
            })
        end
    end, { description = "move floating window right", group = "client" }),

    awful.key({ modkey, altkey }, "k", function()
        if client.focus and client.focus.floating then
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                x = geo.x,
                y = geo.y - 40
            })
        end
    end, { description = "move floating window up", group = "client" }),

    awful.key({ modkey, altkey }, "j", function()
        if client.focus and client.focus.floating then
            local c = client.focus
            local geo = c:geometry()
            c:geometry({
                x = geo.x,
                y = geo.y + 40
            })
        end
    end, { description = "move floating window down", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    -- awful.key({ modkey, }, "n",
    --     function(c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end,
    --     { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = mytable.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = mytable.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            -- placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            placement = awful.placement.centered,
            size_hints_honor = false
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer" },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {
            floating = true,
        }
    },

    {
        rule_any = {
            class = { "floating_term" },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {
            floating = true,
            sticky = true,
            ontop = true,
            width = 600,
            height = 450,
            placement = awful.placement.centered,
        }
    },


    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = mytable.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 16 }):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {     -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- NOTE: CUSTOM
-- Handle any client that becomes floating
client.connect_signal("property::floating", function(c)
    if c.floating then
        -- Save the client's original geometry
        c.floating_geometry = c:geometry()

        -- Apply properties for floating windows
        c.width = 650 -- adjust size as needed
        c.height = 400
        awful.placement.centered(c)
        c.sticky = false -- change to true if you want it visible on all tags
        c.ontop = true   -- keep floating windows on top

        -- Optional: add minimal size constraints
        c.size_hints_honor = false
        c.minimized = false
    else
        -- Restore original geometry when returning to tiled mode
        if c.floating_geometry then
            c:geometry(c.floating_geometry)
            c.floating_geometry = nil
        end
        c.ontop = false
    end
end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}
