#!/usr/bin/env bash
# =============================================================================
# dotfiles.sh — apply dotfiles to the current system
# Usage: ./dotfiles.sh
# =============================================================================

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/scripts/main.sh"

require_non_root

header "DOTFILES SETUP"

# --- Packages ----------------------------------------------------------------

log "Installing Hyprland ecosystem packages..."
install_packages "$ROOT_DIR/packages/hyprland.txt"

# --- Symlinks ----------------------------------------------------------------

link_config_dir "$ROOT_DIR/dotfiles/config"
link_home_files "$ROOT_DIR/dotfiles/home"

# --- Done --------------------------------------------------------------------

header "Done"
success "Dotfiles applied successfully"