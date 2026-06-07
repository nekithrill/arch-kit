mod = "SUPER"

apps = {
    terminal    = "kitty",
    filemanager = "thunar",
    files       = "kitty -e yazi",
    menu        = "rofi -show drun",
    logout      = "wlogout",
    lock        = "hyprlock",
    colorpicker = "hyprpicker -a",
    screenshot  = "hyprshot",
    clipboard   = "cliphist list | rofi -dmenu | cliphist decode | wl-copy",
    volume      = "pavucontrol",
    bluetooth   = "blueman-manager",
    network     = "nm-connection-editor",
}