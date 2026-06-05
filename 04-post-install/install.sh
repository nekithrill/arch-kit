#!/usr/bin/env bash
# 04-post-install/install.sh

set -euo pipefail

LAYER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LAYER_DIR/.." && pwd)"

source "$DOTFILES_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

header "04 - POST INSTALL"

# Packages
install_packages "$LAYER_DIR/packages.txt"

# pacman.conf
log "Configuring pacman..."

sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
sudo sed -i '/^ParallelDownloads/a ILoveCandy' /etc/pacman.conf

success "pacman.conf updated"

# makepkg.conf
log "Configuring makepkg..."

sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf

success "makepkg.conf updated"

# Mirrors
log "Updating mirrors..."

read -rp "Enter your country for mirror selection (e.g. Germany, France, Poland): " COUNTRY
sudo reflector --country "$COUNTRY" --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
success "Mirrorlist updated"

# Enable automatic mirror refresh
sudo systemctl enable reflector.timer
success "reflector.timer enabled"

# Firewall
log "Configuring firewall..."

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
enable_services ufw

success "Firewall configured"

# SSD: fstrim
log "Enabling fstrim timer..."
sudo systemctl enable fstrim.timer
success "fstrim.timer enabled"

# XDG user directories
log "Updating XDG user directories..."
xdg-user-dirs-update
success "XDG user directories updated"

# Fontconfig
link_config_dir "$LAYER_DIR/config"
success "Fontconfig linked"

success "Layer completed successfully"
