#!/usr/bin/env bash
# arch-install/steps/base.sh — keyring, yay, base packages, zsh, dotfiles

set -euo pipefail

STEP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${ROOT_DIR:-$(cd "$STEP_DIR/.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

banner "$ORANGE" << 'EOF'
   ____         __              _      _ __ 
  / __/_ _____ / /____ __ _    (_)__  (_) /_
 _\ \/ // (_-</ __/ -_)  ' \  / / _ \/ / __/
/___/\_, /___/\__/\__/_/_/_/ /_/_//_/_/\__/ 
    /___/                                                             
EOF

# --- Keyring -----------------------------------------------------------------

log "Updating archlinux-keyring..."
sudo pacman -Sy --noconfirm archlinux-keyring
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

# --- oh-my-zsh ---------------------------------------------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
    success "oh-my-zsh installed"
else
    success "oh-my-zsh already installed"
fi

# --- Default shell -----------------------------------------------------------

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    log "Setting zsh as default shell..."
    sudo chsh -s "$(command -v zsh)" "$USER"
    success "zsh set as default shell"
else
    success "zsh already default shell"
fi

success "Base step complete"
warn "Log out and back in for shell change to take effect"