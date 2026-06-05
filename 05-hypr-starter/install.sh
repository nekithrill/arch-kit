#!/usr/bin/env bash
# 05-hypr-starter/install.sh

set -euo pipefail

LAYER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LAYER_DIR/.." && pwd)"

source "$DOTFILES_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

header "05 - HYPRLAND STARTER"

install_packages "$LAYER_DIR/packages.txt"

link_config_dir "$LAYER_DIR/config"

enable_services geoclue

success "Layer completed successfully"
warn "If you have NVIDIA GPU — uncomment env-nvidia.lua in hyprland.lua"