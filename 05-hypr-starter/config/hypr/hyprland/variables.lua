mod = "SUPER"

apps = {
    terminal    = "kitty",
    filemanager = "thunar",
    files       = "kitty -e yazi",
    menu        = "fuzzel",
    logout      = "wlogout",
    lock        = "hyprlock",
    colorpicker = "hyprpicker -a",
    screenshot  = "hyprshot",
    clipboard   = "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy",
    volume      = "pavucontrol",
    bluetooth   = "blueman-manager",
    network     = "nm-connection-editor",
}