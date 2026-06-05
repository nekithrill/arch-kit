#!/usr/bin/env bash
# 01-system-init/install.sh

set -euo pipefail

LAYER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LAYER_DIR/.." && pwd)"

source "$DOTFILES_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

header "01 - SYSTEM INITIALIZATION"

# Keyring
log "Updating keyring..."
sudo pacman -Sy --noconfirm archlinux-keyring
success "Keyring updated"

# yay
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

# Packages
install_packages "$LAYER_DIR/packages.txt"

# oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
    success "oh-my-zsh installed"
else
    success "oh-my-zsh already installed"
fi

# Default shell
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    log "Setting zsh as default shell..."
    sudo chsh -s "$(command -v zsh)" "$USER"
    success "zsh set as default shell"
else
    success "zsh already set as default shell"
fi

# Symlinks
link_config_dir "$LAYER_DIR/config"
link_home_files "$LAYER_DIR/home"


success "Layer completed successfully"
warn "Log out and back in for shell change to take effect"