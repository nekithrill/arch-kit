hl.dwindle({
    pseudotile = true,
    preserve_split = true,
})

-- 1. Заставляем системные утилиты открываться в ПЛАВАЮЩЕМ режиме
hl.windowrulev2("float", "class:^(nm-connection-editor)$")
hl.windowrulev2("float", "class:^(blueman-manager)$")
hl.windowrulev2("float", "class:^(org.pulseaudio.pavucontrol)$")

-- 2. Задаем фиксированный размер для этих плавающих окон
hl.windowrulev2("size 600 400", "class:^(org.pulseaudio.pavucontrol)$")
hl.windowrulev2("size 700 500", "class:^(blueman-manager)$")

-- 3. Центрируем их при открытии
hl.windowrulev2("center", "class:^(org.pulseaudio.pavucontrol)$")
hl.windowrulev2("center", "class:^(blueman-manager)$")

-- 4. Правило для предотвращения зависания экрана при полноэкранных играх
hl.windowrulev2("suppressmaximize", "class:.*")
