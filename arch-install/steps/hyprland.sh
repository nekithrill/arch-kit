#!/usr/bin/env bash
# arch-install/steps/hyprland.sh — Hyprland ecosystem + dotfiles symlinks

set -euo pipefail

STEP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${ROOT_DIR:-$(cd "$STEP_DIR/../.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

# --- Packages ----------------------------------------------------------------

install_packages "$ROOT_DIR/packages/hyprland.txt"

# --- Services ----------------------------------------------------------------

enable_services geoclue

# --- Symlinks ----------------------------------------------------------------

link_config_dir "$ROOT_DIR/dotfiles/config"
link_home_files "$ROOT_DIR/dotfiles/home"

success "Hyprland step complete"

if [[ "${DRIVERS:-}" == "nvidia" || "${DRIVERS:-}" == "amd-nvidia" ]]; then
    warn "NVIDIA detected — uncomment env-nvidia.lua in dotfiles/config/hypr/hyprland.lua"
fi