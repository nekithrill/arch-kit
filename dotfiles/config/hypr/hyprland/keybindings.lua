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
hl.bind("Print",                hl.dsp.exec_cmd(apps.screenshot .. " -m output"))
hl.bind(mod .. " + Print",      hl.dsp.exec_cmd(apps.screenshot .. " -m region"))
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd(apps.screenshot .. " -m window"))

-- Window management
hl.bind(mod .. " + C",          hl.dsp.window.close())
hl.bind(mod .. " + F",          hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mod .. " + SHIFT + F",  hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + J",          hl.dsp.layout.toggle_split())

-- Focus — arrows
hl.bind(mod .. " + left",  hl.dsp.focus.move({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus.move({ direction = "r" }))
hl.bind(mod .. " + up",    hl.dsp.focus.move({ direction = "u" }))
hl.bind(mod .. " + down",  hl.dsp.focus.move({ direction = "d" }))

-- Focus — vim keys
hl.bind(mod .. " + H", hl.dsp.focus.move({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus.move({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus.move({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus.move({ direction = "d" }))

-- Move windows
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

-- Resize windows
hl.bind(mod .. " + ALT + left",  hl.dsp.window.resize({ x = -40, y = 0 }))
hl.bind(mod .. " + ALT + right", hl.dsp.window.resize({ x =  40, y = 0 }))
hl.bind(mod .. " + ALT + up",    hl.dsp.window.resize({ x = 0, y = -40 }))
hl.bind(mod .. " + ALT + down",  hl.dsp.window.resize({ x = 0, y =  40 }))

-- Mouse
hl.bindm(mod .. " + mouse:272", hl.dsp.window.move_interactive())
hl.bindm(mod .. " + mouse:273", hl.dsp.window.resize_interactive())

-- Workspaces
for i = 1, 9 do
    local ws = tostring(i)
    hl.bind(mod .. " + " .. ws,          hl.dsp.workspace.go({ name = ws }))
    hl.bind(mod .. " + SHIFT + " .. ws,  hl.dsp.workspace.move_window({ name = ws }))
end

-- Scroll workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.workspace.go({ relative = 1 }))
hl.bind(mod .. " + mouse_up",   hl.dsp.workspace.go({ relative = -1 }))

-- Special workspace
hl.bind(mod .. " + S",          hl.dsp.workspace.toggle_special({ name = "magic" }))
hl.bind(mod .. " + SHIFT + S",  hl.dsp.workspace.move_window({ name = "special:magic" }))

-- Media & brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"))