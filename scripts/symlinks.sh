#!/usr/bin/env bash
# scripts/symlinks.sh — symlink management functions

link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "Backing up existing target: $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi

    ln -sfn "$src" "$dst"
    success "  linked: $dst"
}

link_config_dir() {
    local config_dir="$1"
    [[ -d "$config_dir" ]] || return

    log "Linking configs from $config_dir..."
    for item in "$config_dir"/*/; do
        [[ -e "$item" ]] || continue
        local name
        name=$(basename "$item")
        link "$item" "$HOME/.config/$name"
    done
}

link_home_files() {
    local home_dir="$1"
    [[ -d "$home_dir" ]] || return

    log "Linking home dotfiles..."
    for f in "$home_dir"/.*; do
        [[ -f "$f" ]] || continue
        local name
        name=$(basename "$f")
        [[ "$name" == "." || "$name" == ".." ]] && continue
        link "$f" "$HOME/$name"
    done
}
