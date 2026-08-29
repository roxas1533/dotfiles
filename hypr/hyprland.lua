-- Hyprland 0.56 Lua config

local mainMod     = "SUPER"
local terminal    = "wezterm"
local fileManager = "thunar"
local menu        = "noctalia msg panel-toggle launcher"
local screenshot  = [[grim -g "$(slurp -b '#00000080' -s '#00000000')" - | wl-copy]]

--------------------
---- MONITORS ----
--------------------

hl.monitor({ output = "DP-1",     mode = "1920x1080@60", position = "-1920x0", scale = 1 })
hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "0x0",     scale = 1 })

--------------------
---- ENVIRONMENT ----
--------------------

hl.env("XCURSOR_THEME",          "Adwaita")
hl.env("XCURSOR_SIZE",           "24")
hl.env("HYPRCURSOR_SIZE",        "24")
hl.env("GTK_THEME",              "Fluent-round-Dark")
hl.env("ADW_DEBUG_COLOR_SCHEME", "prefer-dark")
hl.env("QT_QPA_PLATFORMTHEME",   "adwaita")
hl.env("QT_STYLE_OVERRIDE",      "adwaita-dark")

--------------------
---- AUTOSTART ----
--------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl plugin load " .. os.getenv("HOME") .. "/.config/hypr/plugins/hyprexpo.so")
    hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("amixer -c Generic_1 sset 'Input Source' 'Line' && amixer -c Generic_1 sset 'Capture' 50% cap && amixer -c Generic_1 sset 'Line Boost' 0% && pw-link alsa_input.pci-0000_0d_00.6.analog-stereo:capture_FL alsa_output.pci-0000_01_00.1.hdmi-stereo:playback_FL && pw-link alsa_input.pci-0000_0d_00.6.analog-stereo:capture_FR alsa_output.pci-0000_01_00.1.hdmi-stereo:playback_FR")
end)

--------------------
---- LOOK & FEEL ----
--------------------

hl.config({
    general = {
        gaps_in         = 5,
        gaps_out        = 5,
        border_size     = 2,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "scrolling",
        snap = {
            enabled     = true,
            window_gap  = 10,
            monitor_gap = 10,
        },
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled            = true,
            size               = 1,
            passes             = 2,
            vibrancy           = 0.1696,
            brightness         = 0.7,
            popups             = true,
            popups_ignorealpha = 0.2,
            input_methods                = true,
            input_methods_ignorealpha    = 0.2,
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },


    input = {
        kb_layout    = "jp",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = { natural_scroll = false },
    },
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 }    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 }    } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 }       } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 }    } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 }     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default"      })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick"        })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick"        })

--------------------
---- GESTURE / DEVICE ----
--------------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

--------------------
---- KEYBINDINGS ----
--------------------

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + TAB", function() return hl.plugin.hyprexpo.expo("toggle") end)

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind("CTRL + SHIFT + Escape",   hl.dsp.exec_cmd("missioncenter"))

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Switch / move workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0",         hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Scrolling layout
hl.bind(mainMod .. " + SHIFT + left",       hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + right",      hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + mouse_right",        hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + mouse_left",         hl.dsp.layout("move +col"))

-- Mouse drag / resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness (repeat while held)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"),                        { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),                        { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------
---- LAYER RULES ----
--------------------

hl.layer_rule({ name = "noctalia-bg-blur",  match = { namespace = "noctalia-background-.*"  }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ name = "noctalia-bar-blur", match = { namespace = "noctalia-bar-content-.*" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ name = "fcitx-blur",        match = { namespace = "fcitx"                   }, blur = true, ignore_alpha = 0.2 })

--------------------
---- WINDOW RULES ----
--------------------

hl.window_rule({
    name  = "file-manager-opacity",
    match = { class = "^(org.gnome.Nautilus|thunar)$" },
    opacity = "0.7 0.7",
})
hl.window_rule({
    name  = "pinned-border",
    match = { pin = true },
    border_color = { colors = { "rgb(ff9500)", "rgb(cc7700)" } },
})
hl.window_rule({
    name  = "no-focus-empty-xwayland",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
hl.window_rule({
    name  = "pip-aspect",
    match = { title = "^(ピクチャーインピクチャー|Picture.in.[Pp]icture)$" },
    keep_aspect_ratio = true,
    size = "960 540",
})
hl.window_rule({
    name  = "thunar-rename-float",
    match = { class = "^(thunar)$", title = ".+の名前を変更$" },
    float = true,
})
hl.window_rule({
    name  = "thunar-progress-float",
    match = { class = "^(thunar)$", title = "^ファイル操作の進捗$" },
    float = true,
    size  = "570 420",
})
hl.window_rule({
    name  = "remmina-float",
    match = { class = "^(org.remmina.Remmina)$", title = "^main$" },
    float     = true,
    size      = "3840 1080",
    workspace = "special:magic",
    move      = "0 0",
})
