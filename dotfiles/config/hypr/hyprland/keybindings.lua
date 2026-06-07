-- keybindings.lua

-- Applications
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(apps.terminal))
hl.bind(mod .. " + R",      hl.dsp.exec_cmd(apps.menu))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(apps.filemanager))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd(apps.files))
hl.bind(mod .. " + M",      hl.dsp.exec_cmd(apps.logout))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd(apps.lock))
hl.bind(mod .. " + V",      hl.dsp.exec_cmd(apps.clipboard))
hl.bind(mod .. " + P",      hl.dsp.exec_cmd(apps.colorpicker))
hl.bind(mod .. " + A",      hl.dsp.exec_cmd(apps.volume))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(apps.bluetooth))
hl.bind(mod .. " + N",      hl.dsp.exec_cmd(apps.network))

-- Screenshots
hl.bind("Print",                   hl.dsp.exec_cmd(apps.screenshot .. " -m output"))
hl.bind(mod .. " + Print",         hl.dsp.exec_cmd(apps.screenshot .. " -m region"))
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd(apps.screenshot .. " -m window"))

-- Window management
hl.bind(mod .. " + C",             hl.dsp.window.close())
hl.bind(mod .. " + F",             hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + J",             hl.dsp.layout("togglesplit"))

-- Focus — arrows
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Focus — vim keys
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Resize windows
hl.bind(mod .. " + ALT + left",  hl.dsp.window.resize({ x = -40, y = 0 }))
hl.bind(mod .. " + ALT + right", hl.dsp.window.resize({ x =  40, y = 0 }))
hl.bind(mod .. " + ALT + up",    hl.dsp.window.resize({ x = 0,  y = -40 }))
hl.bind(mod .. " + ALT + down",  hl.dsp.window.resize({ x = 0,  y =  40 }))

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces
for i = 1, 9 do
    hl.bind(mod .. " + " .. i,          hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i,  hl.dsp.window.move({ workspace = i }))
end

-- Scroll workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Special workspace
hl.bind(mod .. " + S",          hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S",  hl.dsp.window.move({ workspace = "special:magic" }))

-- Media & brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })