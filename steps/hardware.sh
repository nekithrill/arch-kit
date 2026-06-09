#!/usr/bin/env bash
# steps/hardware.sh - audio, bluetooth, laptop profile

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

banner "$ORANGE" << 'EOF'
   __ __            __                   
  / // /__ ________/ /    _____ ________ 
 / _  / _ `/ __/ _  / |/|/ / _ `/ __/ -_)
/_//_/\_,_/_/  \_,_/|__,__/\_,_/_/  \__/ 
EOF

# --- Fallback for DEVICE var -------------------------------------------------

if [[ -z "${DEVICE:-}" ]]; then
    log "Running in standalone mode. Detecting hardware profile..."
    DEVICE=$(ask "Select device type for this step:" "desktop" "laptop")
fi

# --- Common hardware packages ------------------------------------------------

log "Checking for JACK conflicts..."
sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true

install_packages "$ROOT_DIR/packages/hardware.txt"

# --- Laptop profile ----------------------------------------------------------

if [[ "${DEVICE:-}" == "laptop" ]]; then
    log "Installing laptop packages..."
    install_packages "$ROOT_DIR/packages/hardware-laptop.txt"
    enable_services acpid power-profiles-daemon
else
    log "Desktop - skipping laptop packages"
fi

# --- Services ----------------------------------------------------------------

enable_services bluetooth

success "Hardware step complete"