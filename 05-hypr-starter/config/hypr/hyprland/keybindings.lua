-- keybindings.lua
-- All keybindings are defined here using variables from variables.lua

-- Applications
hl.bind(mod,         "Return", "exec", apps.terminal)
hl.bind(mod,         "R",      "exec", apps.menu)
hl.bind(mod,         "E",      "exec", apps.filemanager)
hl.bind(mod .. " SHIFT", "E",  "exec", apps.files)
hl.bind(mod,         "M",      "exec", apps.logout)
hl.bind(mod,         "L",      "exec", apps.lock)
hl.bind(mod,         "V",      "exec", apps.clipboard)
hl.bind(mod,         "P",      "exec", apps.colorpicker)
hl.bind(mod,         "A",      "exec", apps.volume)
hl.bind(mod,         "B",      "exec", apps.bluetooth)
hl.bind(mod,         "N",      "exec", apps.network)

-- Screenshots
hl.bind("",          "Print",          "exec", apps.screenshot .. " -m output")
hl.bind(mod,         "Print",          "exec", apps.screenshot .. " -m region")
hl.bind(mod .. " SHIFT", "Print",      "exec", apps.screenshot .. " -m window")

-- Window management
hl.bind(mod,         "C",      "killactive")
hl.bind(mod,         "F",      "fullscreen",      "0")
hl.bind(mod .. " SHIFT", "F",  "fullscreen",      "1")
hl.bind(mod .. " SHIFT", "Space", "togglefloating")
hl.bind(mod,         "J",      "togglesplit")

-- Focus — arrows
hl.bind(mod, "left",  "movefocus", "l")
hl.bind(mod, "right", "movefocus", "r")
hl.bind(mod, "up",    "movefocus", "u")
hl.bind(mod, "down",  "movefocus", "d")

-- Focus — vim keys
hl.bind(mod, "H", "movefocus", "l")
hl.bind(mod, "L", "movefocus", "r")
hl.bind(mod, "K", "movefocus", "u")
hl.bind(mod, "J", "movefocus", "d")

-- Move windows
hl.bind(mod .. " SHIFT", "left",  "movewindow", "l")
hl.bind(mod .. " SHIFT", "right", "movewindow", "r")
hl.bind(mod .. " SHIFT", "up",    "movewindow", "u")
hl.bind(mod .. " SHIFT", "down",  "movewindow", "d")

-- Resize windows
hl.bind(mod .. " ALT", "left",  "resizeactive", "-40 0")
hl.bind(mod .. " ALT", "right", "resizeactive",  "40 0")
hl.bind(mod .. " ALT", "up",    "resizeactive",  "0 -40")
hl.bind(mod .. " ALT", "down",  "resizeactive",  "0  40")

-- Mouse
hl.bindm(mod, "mouse:272", "movewindow")
hl.bindm(mod, "mouse:273", "resizewindow")

-- Workspaces
for i = 1, 9 do
    local ws = tostring(i)
    hl.bind(mod,             ws, "workspace",        ws)
    hl.bind(mod .. " SHIFT", ws, "movetoworkspace",  ws)
end

-- Switch workspaces with scroll
hl.bind(mod, "mouse_down", "workspace", "e+1")
hl.bind(mod, "mouse_up",   "workspace", "e-1")

-- Special workspace (scratchpad)
hl.bind(mod,             "S", "togglespecialworkspace", "magic")
hl.bind(mod .. " SHIFT", "S", "movetoworkspace",        "special:magic")

-- Media & brightness (repeat + lockscreen passthrough)
hl.bind("", "XF86AudioRaiseVolume",  "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",  { e = true, l = true })
hl.bind("", "XF86AudioLowerVolume",  "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",  { e = true, l = true })
hl.bind("", "XF86AudioMute",         "exec", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { l = true })
hl.bind("", "XF86AudioMicMute",      "exec", "wpctl set-mute @DEFAULT_SOURCE@ toggle",     { l = true })

hl.bind("", "XF86MonBrightnessUp",   "exec", "brightnessctl set 5%+", { e = true, l = true })
hl.bind("", "XF86MonBrightnessDown", "exec", "brightnessctl set 5%-", { e = true, l = true })

hl.bind("", "XF86AudioPlay",  "exec", "playerctl play-pause")
hl.bind("", "XF86AudioNext",  "exec", "playerctl next")
hl.bind("", "XF86AudioPrev",  "exec", "playerctl previous")