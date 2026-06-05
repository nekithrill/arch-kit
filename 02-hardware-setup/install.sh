#!/usr/bin/env bash
# 02-hardware-setup/install.sh

set -euo pipefail

LAYER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LAYER_DIR/.." && pwd)"

source "$DOTFILES_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

header "02 - HARDWARE SETUP"

# Device type 
DEVICE=$(ask "Device type:" "laptop" "desktop")

# Common packages
install_packages "$LAYER_DIR/packages.txt"

# Device-specific packages
if [[ "$DEVICE" == "laptop" ]]; then
    log "Installing laptop-specific packages..."
    install_packages "$LAYER_DIR/profiles/laptop/packages.txt"
else
    log "Desktop — skipping laptop-specific packages"
fi

# Services
enable_services bluetooth

success "Layer completed successfully"