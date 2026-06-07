#!/usr/bin/env bash
# arch-install/steps/drivers.sh — GPU drivers + NVIDIA kernel config

set -euo pipefail

STEP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${ROOT_DIR:-$(cd "$STEP_DIR/../.." && pwd)}"

source "$ROOT_DIR/scripts/main.sh"

# --- Skip if no drivers ------------------------------------------------------

if [[ "${DRIVERS:-}" == "none" ]]; then
    log "No drivers selected — skipping"
    exit 0
fi

# --- Package selection -------------------------------------------------------

case "${DRIVERS:-}" in
    amd)
        PKG_FILE="$ROOT_DIR/packages/gpu-amd.txt"
        IS_NVIDIA=false
        ;;
    nvidia)
        PKG_FILE="$ROOT_DIR/packages/gpu-nvidia.txt"
        IS_NVIDIA=true
        ;;
    amd-nvidia)
        PKG_FILE="$ROOT_DIR/packages/gpu-amd-nvidia.txt"
        IS_NVIDIA=true
        ;;
    *)
        die "Unknown driver profile: ${DRIVERS}"
        ;;
esac

install_packages "$PKG_FILE"

# --- NVIDIA kernel configuration ---------------------------------------------

if [[ "$IS_NVIDIA" == "true" ]]; then

    # Early KMS
    MKINITCPIO_CONF="/etc/mkinitcpio.conf"

    if [[ -f "$MKINITCPIO_CONF" ]]; then
        if ! grep -qE '^MODULES=\([^)]*nvidia' "$MKINITCPIO_CONF"; then
            log "Adding NVIDIA modules to mkinitcpio.conf..."
            CURRENT=$(grep -E '^MODULES=\(' "$MKINITCPIO_CONF" | sed -E 's/^MODULES=\((.*)\)/\1/')
            NEW="MODULES=(${CURRENT:+$CURRENT }nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
            sudo sed -i -E "s/^MODULES=\(.*\)/$NEW/" "$MKINITCPIO_CONF"
            sudo mkinitcpio -P
            success "mkinitcpio.conf updated"
        else
            success "NVIDIA modules already in mkinitcpio.conf"
        fi
    else
        warn "$MKINITCPIO_CONF not found — skipping Early KMS"
    fi

    # Bootloader
    if [[ -d "/boot/loader/entries/" ]]; then
        log "systemd-boot detected — adding nvidia_drm.modeset=1..."
        find /boot/loader/entries/ -type f -name "*.conf" | while read -r entry; do
            if ! grep -q "nvidia_drm.modeset=1" "$entry"; then
                sudo sed -i '/^options / s/$/ nvidia_drm.modeset=1/' "$entry"
                log "  updated: $(basename "$entry")"
            fi
        done
        success "systemd-boot entries updated"

    elif [[ -f "/etc/default/grub" ]]; then
        log "GRUB detected — adding nvidia_drm.modeset=1..."
        if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
            sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.modeset=1"/' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
            success "GRUB updated"
        else
            success "GRUB already has nvidia_drm.modeset=1"
        fi

    else
        warn "Bootloader not detected — add 'nvidia_drm.modeset=1' to kernel parameters manually"
    fi

fi

success "Drivers step complete"