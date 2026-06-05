#!/usr/bin/env bash
# scripts/packages.sh — package installation functions

install_packages() {
    local pkgfile="$1"
    [[ -f "$pkgfile" ]] || { warn "Package file not found: $pkgfile"; return; }

    local pacman_pkgs=()
    local aur_pkgs=()

    while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
        local line
        line=$(echo "$raw_line" | sed 's/#.*//' | xargs)
        [[ -z "$line" ]] && continue

        if [[ "$line" == AUR:* ]]; then
            aur_pkgs+=("${line#AUR:}")
        else
            pacman_pkgs+=("$line")
        fi
    done < "$pkgfile"

    if [[ ${#pacman_pkgs[@]} -gt 0 ]]; then
        log "Installing ${#pacman_pkgs[@]} packages via pacman..."
        sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
    fi

    if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
        if command -v yay &>/dev/null; then
            log "Installing ${#aur_pkgs[@]} AUR packages via yay..."
            yes | yay -S --needed --noconfirm --answerdiff None --answerclean None "${aur_pkgs[@]}"
        else
            warn "yay not found — skipping AUR packages: ${aur_pkgs[*]}"
        fi
    fi

    success "Packages installed successfully"
}
