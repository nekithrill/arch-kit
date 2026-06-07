#!/usr/bin/env bash
# arch-install/steps/postinstall.sh — pacman, mirrors, firewall, fstrim, xdg

set -euo pipefail

STEP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${ROOT_DIR:-$(cd "$STEP_DIR/../.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

# --- Packages ----------------------------------------------------------------

install_packages "$ROOT_DIR/packages/post-install.txt"

# --- pacman.conf -------------------------------------------------------------

log "Configuring pacman..."
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
grep -q 'ILoveCandy' /etc/pacman.conf || \
    sudo sed -i '/^ParallelDownloads/a ILoveCandy' /etc/pacman.conf
success "pacman.conf updated"

# --- makepkg.conf ------------------------------------------------------------

log "Configuring makepkg..."
sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf
success "makepkg.conf updated"

# --- Mirrors -----------------------------------------------------------------

log "Updating mirrors..."
read -rp "  Country for mirror selection (e.g. Germany, Poland): " COUNTRY
sudo reflector --country "$COUNTRY" --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.timer
success "Mirrors updated"

# --- Firewall ----------------------------------------------------------------

log "Configuring firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
enable_services ufw
success "Firewall configured"

# --- SSD ---------------------------------------------------------------------

sudo systemctl enable fstrim.timer
success "fstrim.timer enabled"

# --- XDG user directories ----------------------------------------------------

xdg-user-dirs-update
success "XDG directories updated"

success "Post-install step complete"