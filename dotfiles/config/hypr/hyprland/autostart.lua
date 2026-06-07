-- Auto-Start System Core Services 
-- Launch graphical desktop ecosystem components
hl.exec_once("waybar")
hl.exec_once("hyprpaper")
hl.exec_once("mako")

-- Polkit authentication bridge for system actions
hl.exec_once("hyprpolkitagent")

-- Clipboard historical monitoring services
hl.exec_once("wl-paste --type text --watch cliphist store")
hl.exec_once("wl-paste --type image --watch cliphist store")

-- Crucial network and hardware system tray components
hl.exec_once("nm-applet --indicator")
hl.exec_once("blueman-applet")
hl.exec_once("hypridle")
