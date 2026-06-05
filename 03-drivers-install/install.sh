#!/usr/bin/env bash
# 03-drivers-install/install.sh

set -euo pipefail

LAYER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LAYER_DIR/.." && pwd)"

source "$DOTFILES_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

header "03 - DRIVERS INSTALLATION"

# GPU selection
DRIVER=$(ask "GPU drivers:" "amd" "nvidia" "amd + nvidia (hybrid)")

IS_NVIDIA=false

case "$DRIVER" in
    "amd")
        PKG_FILE="$LAYER_DIR/profiles/amd/packages.txt"
        ;;
    "nvidia")
        PKG_FILE="$LAYER_DIR/profiles/nvidia/packages.txt"
        IS_NVIDIA=true
        ;;
    "amd + nvidia (hybrid)")
        PKG_FILE="$LAYER_DIR/profiles/amd-nvidia/packages.txt"
        IS_NVIDIA=true
        ;;
esac

# Package installation
install_packages "$PKG_FILE"

# Early KMS & Bootloader configuration for NVIDIA
if [[ "$IS_NVIDIA" == "true" ]]; then
    log "Configuring kernel modules (Early KMS) for NVIDIA..."

    MKINITCPIO_CONF="/etc/mkinitcpio.conf"

    if [[ -f "$MKINITCPIO_CONF" ]]; then
        if ! grep -qE '^MODULES=\([^)]*nvidia' "$MKINITCPIO_CONF"; then
            log "Adding nvidia modules to mkinitcpio.conf..."

            CURRENT_MODULES=$(grep -E '^MODULES=\(' "$MKINITCPIO_CONF" | sed -E 's/^MODULES=\((.*)\)/\1/')
            NEW_MODULES="MODULES=(${CURRENT_MODULES:+$CURRENT_MODULES }nvidia nvidia_modeset nvidia_uvm nvidia_drm)"

            sudo sed -i -E "s/^MODULES=\(.*\)/$NEW_MODULES/" "$MKINITCPIO_CONF"

            log "Regenerating initramfs..."
            sudo mkinitcpio -P
            success "mkinitcpio.conf updated"
        else
            log "NVIDIA modules already present in mkinitcpio.conf, skipping"
        fi
    else
        warn "$MKINITCPIO_CONF not found, skipping KMS setup"
    fi

    # Bootloader configuration
    log "Checking bootloader configuration..."

    if [[ -d "/boot/loader/entries/" ]]; then
        log "systemd-boot detected"

        find /boot/loader/entries/ -type f -name "*.conf" | while read -r entry; do
            if ! grep -q "nvidia_drm.modeset=1" "$entry"; then
                log "Adding parameter to: $(basename "$entry")"
                sudo sed -i '/^options / s/$/ nvidia_drm.modeset=1/' "$entry"
            fi
        done
        success "systemd-boot entries updated"

    elif [[ -f "/etc/default/grub" ]]; then
        log "GRUB detected"

        if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
            log "Adding parameter to /etc/default/grub..."
            sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.modeset=1"/' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
            success "GRUB configuration updated"
        else
            log "NVIDIA kernel parameters already present in GRUB, skipping"
        fi
    else
        warn "Bootloader not identified — add 'nvidia_drm.modeset=1' to kernel parameters manually"
    fi
fi

success "Layer completed successfully"