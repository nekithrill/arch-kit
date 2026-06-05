#!/usr/bin/env bash
# scripts/main.sh — loads all script modules
# Usage: source "$(dirname "${BASH_SOURCE[0]}")/../scripts/main.sh"

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPTS_DIR/colors.sh"
source "$SCRIPTS_DIR/packages.sh"
source "$SCRIPTS_DIR/symlinks.sh"
source "$SCRIPTS_DIR/system.sh"
