hl.animations({
    enabled = true,
})

hl.bezier({
    { name = "defaultSmooth", value = "0.05, 0.9, 0.1, 1.05" },
})

hl.animation({
    { name = "windows",    enabled = true, speed = 7, curve = "defaultSmooth" },
    { name = "windowsOut", enabled = true, speed = 7, curve = "default" },
    { name = "fade",       enabled = true, speed = 7, curve = "default" },
    { name = "workspaces", enabled = true, speed = 6, curve = "default" },
})