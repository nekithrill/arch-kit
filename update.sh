#!/usr/bin/env bash
# =============================================================================
# update.sh — update system packages, dotfiles and clean cache
# Usage: ./update.sh
# =============================================================================

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

banner "$BLUE" << 'EOF'
   ___           __           __    _ __                   __     __         
  / _ | ________/ /    ____  / /__ (_) /_    __ _____  ___/ /__ _/ /____ ____
 / __ |/ __/ __/ _ \  /___/ /  '_// / __/   / // / _ \/ _  / _ `/ __/ -_) __/
/_/ |_/_/  \__/_//_/       /_/\_\/_/\__/    \_,_/ .__/\_,_/\_,_/\__/\__/_/   
                                               /_/    
EOF

# --- Git pull -------------------------------------------------------------

log "Checking for local changes..."

cd "$ROOT_DIR"

if ! git diff --quiet || ! git diff --cached --quiet; then
    warn "Uncommitted changes detected — skipping git pull to avoid conflicts"
else
    log "Pulling latest changes..."
    git pull --rebase origin "$(git rev-parse --abbrev-ref HEAD)"
    success "Repository updated"
fi

# --- System packages ------------------------------------------------------

header "System update"

log "Updating pacman packages..."
sudo pacman -Syu --noconfirm
success "System packages updated"

# --- AUR packages ---------------------------------------------------------

if command -v yay &>/dev/null; then
    log "Updating AUR packages..."
    yes | yay -Sua --noconfirm --answerdiff None --answerclean None
    success "AUR packages updated"
else
    warn "yay not found — skipping AUR update"
fi

# --- Cache cleanup --------------------------------------------------------

header "Cache cleanup"

if command -v paccache &>/dev/null; then
    log "Cleaning pacman cache (keeping last 2 versions)..."
    sudo paccache -rk2
    success "Pacman cache cleaned"
else
    warn "paccache not found — install pacman-contrib to enable cache cleanup"
fi

if [[ -d "$HOME/.cache/yay" ]]; then
    log "Clearing yay build cache..."
    rm -rf "$HOME/.cache/yay"
    success "yay cache cleared"
fi

# --- Done --------------------------------------------------------------------

header "Done"
success "System and dotfiles are up to date"