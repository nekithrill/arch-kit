#!/usr/bin/env bash
# steps/system-init.sh - multilib, keyring, yay, base packages

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

banner "$ORANGE" << 'EOF'
   ____         __               _      _ __ 
  / __/_ _____ / /____ __ _     (_)__  (_) /_
 _\ \/ // (_-</ __/ -_)  ' \   / / _ \/ / __/
/___/\_, /___/\__/\__/_/_/_/  /_/_//_/_/\__/ 
    /___/                                                             
EOF

# --- Multilib Activation -----------------------------------------------------

if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    log "Activating multilib repository..."
    sudo sed -i '/^#\[multilib\]/ { s/^#//; n; s/^#//; }' /etc/pacman.conf
    success "Multilib repository activated"
    sudo pacman -Syu --noconfirm
else
    success "Multilib repository is already active"
fi

# --- Keyring -----------------------------------------------------------------

log "Updating archlinux-keyring..."
sudo pacman -S --noconfirm archlinux-keyring
success "Keyring updated"

# --- yay ---------------------------------------------------------------------

if ! command -v yay &>/dev/null; then
    log "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    success "yay installed"
else
    success "yay already installed"
fi

# --- Packages ----------------------------------------------------------------

install_packages "$ROOT_DIR/packages/system-init.txt"


success "Base step complete"