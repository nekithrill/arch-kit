#!/usr/bin/env bash
# steps/post-install.sh - pacman, mirrors, firewall, fstrim, xdg

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

banner "$ORANGE" << 'EOF'
   ___           __     _          __       ____
  / _ \___  ___ / /_   (_)__  ___ / /____ _/ / /
 / ___/ _ \(_-</ __/  / / _ \(_-</ __/ _ `/ / / 
/_/   \___/___/\__/  /_/_//_/___/\__/\_,_/_/_/  
EOF

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

if [[ -z "${MIRROR_COUNTRY:-}" ]] && [[ -t 0 ]]; then
    echo
    echo -e "${ORANGE}=== Mirror Optimization (Optional) ===${NC}"
    read -rp "  Enter country for faster mirrors (e.g. Germany, Poland) [Leave empty to SKIP]: " MIRROR_COUNTRY
fi

if [[ -n "${MIRROR_COUNTRY:-}" ]]; then
    log "Updating package mirrors for $MIRROR_COUNTRY..."
    sudo reflector --country "$MIRROR_COUNTRY" --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
    sudo systemctl enable reflector.timer
    success "Mirrors updated successfully"
else
    log "Skipping mirror optimization (using current system mirrors)"
fi

# --- Firewall ----------------------------------------------------------------

log "Configuring firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
enable_services ufw
success "Firewall configured"

# --- SSD ---------------------------------------------------------------------

enable_services fstrim.timer
success "fstrim.timer enabled"

# --- XDG user directories ----------------------------------------------------

xdg-user-dirs-update
success "XDG directories updated"

# --- Font configuration ------------------------------------------------------

log "Configuring font rendering presets..."
FONT_DIR="$HOME/.config/fontconfig"

mkdir -p "$FONT_DIR"

if [[ -f "$ROOT_DIR/fonts.conf" ]]; then
    cp "$ROOT_DIR/fonts.conf" "$FONT_DIR/fonts.conf"
    success "Fonts configured successfully"
else
    warn "fonts.conf not found in root directory - skipping configuration"
fi

success "Post-install step complete"