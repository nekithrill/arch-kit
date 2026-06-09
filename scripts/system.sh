#!/usr/bin/env bash
# scripts/system.sh — system and environment functions

# Check that script is not running as root
require_non_root() {
    if [[ "$EUID" -eq 0 ]]; then
        die "Do not run this script as root"
    fi
}

# Keep sudo session alive in the background
# Call once at the start of a long-running script
sudo_keep_alive() {
    sudo -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" 2>/dev/null || exit
    done &
    KEEP_ALIVE_PID=$!
    trap 'kill "$KEEP_ALIVE_PID" 2>/dev/null' EXIT
}

# Interactive prompt — returns selected option
ask() {
    local prompt="$1"
    shift
    local options=("$@")

    echo -e "${BOLD}$prompt${NC}" >&2
    for i in "${!options[@]}"; do
        echo "  $((i+1))) ${options[$i]}" >&2
    done

    local choice
    while true; do
        read -rp "Choice [1-${#options[@]}]: " choice <&2 || read -rp "Choice [1-${#options[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
            echo "${options[$((choice-1))]}"
            return
        fi
        warn "Enter a number between 1 and ${#options[@]}" >&2
    done
}

# Enable and start systemd services
enable_services() {
    local services=("$@")
    for svc in "${services[@]}"; do
        log "Enabling service: $svc"
        sudo systemctl enable --now "$svc"
    done
}
