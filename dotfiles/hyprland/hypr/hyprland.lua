--------------------
---- MONITORS ------
--------------------

-- Parse monitors.conf (old hyprlang format written by hyprdynamicmonitors)
-- Each line: monitor=<output>,<mode>,<position>,<scale>,transform,<t>,vrr,<v>
local function load_monitors(path)
    local f = io.open(path, "r")
    if not f then
        -- Fallback: auto-detect everything
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
        return
    end
    local found = false
    for line in f:lines() do
        local stripped = line:match("^%s*(.-)%s*$")
        if stripped:sub(1, 8) == "monitor=" then
            local rest = stripped:sub(9)
            local parts = {}
            for part in rest:gmatch("[^,]+") do
                parts[#parts + 1] = part
            end
            -- parts: [1]=output [2]=mode [3]=position [4]=scale [5]=transform [6]=t_val [7]=vrr [8]=vrr_val
            if #parts >= 4 then
                local mon = {
                    output   = parts[1],
                    mode     = parts[2],
                    position = parts[3],
                    scale    = tonumber(parts[4]) or parts[4],
                }
                if #parts >= 6 and parts[5] == "transform" then
                    mon.transform = tonumber(parts[6]) or 0
                end
                if #parts >= 8 and parts[7] == "vrr" then
                    mon.vrr = tonumber(parts[8]) or 0
                end
                hl.monitor(mon)
                found = true
            end
        end
    end
    f:close()
    if not found then
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
    end
end

-- __file_dir is the directory containing this lua file (~/.config/hypr/)
local config_dir = __file_dir or os.getenv("HOME") .. "/.config/hypr"
load_monitors(config_dir .. "/monitors.conf")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 5,

        border_size = 2,

        col = {
            active_border   = "rgba(fe8019ee)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    group = {
        col = {
            border_active          = "rgba(fe8019ee)",
            border_inactive        = "rgba(595959aa)",
            border_locked_active   = "rgba(fb4934ee)",
            border_locked_inactive = "rgba(cc241daa)",
        },

        groupbar = {
            font_size          = 12,
            font_weight_active = "bold",
            gradients          = true,
            height             = 20,
            gradient_rounding  = 5,
            text_color          = "rgba(282828ff)",
            text_color_inactive = "rgba(a89984ff)",
            col = {
                active          = "rgba(fe8019ff)",
                inactive        = "rgba(3c3836cc)",
                locked_active   = "rgba(fb4934cc)",
                locked_inactive = "rgba(3c3836cc)",
            },
            gaps_in        = 3,
            gaps_out       = 2,
            keep_upper_gap = false,
        },
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Animations
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


-----------------------
---- LAYOUTS ----------
-----------------------

hl.config({
    dwindle = {
        preserve_split = true,
        force_split    = 2,
    },

    master = {
        new_status = "master",
    },
})

-- Keep special workspace layout stable across toggles
hl.workspace_rule({ workspace = "special:ghost", persistent = true })


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        focus_on_activate       = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us, bg",
        kb_variant = ", phonetic",
        kb_model   = "",
        kb_options = "grp:lwin_toggle,ctrl:nocaps",
        kb_rules   = "",

        follow_mouse = 0,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod  = "ALT"
local terminal = "kitty"
local launcher = "~/.config/rofi/bin/apps.sh"
local powermenu = "~/.config/rofi/bin/powermenu.sh"
local clipboard = "~/.config/rofi/bin/clipboard.sh"

-- Applications
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + Return",        hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + CTRL + Q",      hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + CTRL + V",      hl.dsp.exec_cmd(clipboard))

-- Screenshot
hl.bind("Print",       hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000'))

-- Window management
hl.bind(mainMod .. " + Q",  hl.dsp.window.close())
hl.bind(mainMod .. " + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + F",  hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.layout("swapsplit"))

-- Move window (HJKL, J/K use smart-move script)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("~/.config/hypr/scripts/smart-move.sh d"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/smart-move.sh u"))
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })

-- Move window focus (HJKL)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Resize window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + right", hl.dsp.window.resize({ x = 100,  y = 0 }))
hl.bind(mainMod .. " + left",  hl.dsp.window.resize({ x = -100, y = 0 }))
hl.bind(mainMod .. " + down",  hl.dsp.window.resize({ x = 0,    y = 100 }))
hl.bind(mainMod .. " + up",    hl.dsp.window.resize({ x = 0,    y = -100 }))

-- Window groups
hl.bind(mainMod .. " + G",             hl.dsp.group.toggle())
hl.bind(mainMod .. " + I",             hl.dsp.group.prev())
hl.bind(mainMod .. " + O",             hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ into_group = "d" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ into_group = "u" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ into_group = "r" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("ghost"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:ghost" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Move workspace to monitor
hl.bind(mainMod .. " + CTRL + H", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.workspace.move({ monitor = "d" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.workspace.move({ monitor = "u" }))

-- Cycle through workspaces on active monitor
hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))

-- Open next empty workspace
hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "empty" }))

-- Fn keys: volume (pactl)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))

-- Fn keys: media (playerctl)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"))

-- Fn keys: brightness
hl.bind("code:238",             hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237",             hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -q s +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"))


----------------------------------
---- WINDOWS AND WORKSPACES ------
----------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
