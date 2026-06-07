# =============================================================================
# base/home/.zprofile
# Session initialization profile executed at login
# =============================================================================

# If we are logging into the first virtual console (TTY1) and Hyprland is available, start it automatically
if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
    if command -v Hyprland &>/dev/null; then
        exec Hyprland
    fi
fi
