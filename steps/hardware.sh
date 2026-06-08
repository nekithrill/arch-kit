#!/usr/bin/env bash
# arch-install/steps/hardware.sh — audio, bluetooth, laptop profile

set -euo pipefail

STEP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${ROOT_DIR:-$(cd "$STEP_DIR/.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

banner "$ORANGE" << 'EOF'
   __ __            __                   
  / // /__ ________/ /    _____ ________ 
 / _  / _ `/ __/ _  / |/|/ / _ `/ __/ -_)
/_//_/\_,_/_/  \_,_/|__,__/\_,_/_/  \__/ 
EOF

# --- Common hardware packages ------------------------------------------------

install_packages "$ROOT_DIR/packages/hardware.txt"

# --- Laptop profile ----------------------------------------------------------

if [[ "${DEVICE:-}" == "laptop" ]]; then
    log "Installing laptop packages..."
    install_packages "$ROOT_DIR/packages/hardware-laptop.txt"
    enable_services acpid power-profiles-daemon
else
    log "Desktop — skipping laptop packages"
fi

# --- Services ----------------------------------------------------------------

enable_services bluetooth

success "Hardware step complete"