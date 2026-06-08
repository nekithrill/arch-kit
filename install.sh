#!/usr/bin/env bash
# =============================================================================
# arch-install/install.sh — orchestrator
# Usage:
#   ./arch-install/install.sh
#   ./arch-install/install.sh --device laptop --drivers amd
# =============================================================================

set -euo pipefail

ARCH_INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$ARCH_INSTALL_DIR"
STEPS_DIR="$ARCH_INSTALL_DIR/steps"

source "$ROOT_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

# --- Argument parsing --------------------------------------------------------

DEVICE=""
DRIVERS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --device)   DEVICE="$2";  shift 2 ;;
        --drivers)  DRIVERS="$2"; shift 2 ;;
        *) die "Unknown argument: $1" ;;
    esac
done

# --- Interactive selection ---------------------------------------------------

banner "$BLUE" << 'EOF'
   ___           __           __    _ __      _          __       ____       
  / _ | ________/ /    ____  / /__ (_) /_    (_)__  ___ / /____ _/ / /__ ____
 / __ |/ __/ __/ _ \  /___/ /  '_// / __/   / / _ \(_-</ __/ _ `/ / / -_) __/
/_/ |_/_/  \__/_//_/       /_/\_\/_/\__/   /_/_//_/___/\__/\_,_/_/_/\__/_/   
EOF

[[ -z "$DEVICE" ]]  && DEVICE=$(ask  "Device type:"  "desktop" "laptop")
[[ -z "$DRIVERS" ]] && DRIVERS=$(ask "GPU drivers:"  "amd" "nvidia" "amd-nvidia" "none")

# --- Summary -----------------------------------------------------------------

header "Installation summary"
echo -e "  Device:  ${BOLD}$DEVICE${NC}"
echo -e "  Drivers: ${BOLD}$DRIVERS${NC}"
echo ""
read -rp "Proceed? [y/N]: " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { log "Aborted."; exit 0; }

# --- Export for steps --------------------------------------------------------

export ROOT_DIR
export DEVICE
export DRIVERS

# --- Run steps ---------------------------------------------------------------

header "Starting installation"

run_step() {
    local name="$1"
    local script="$STEPS_DIR/$name.sh"

    if [[ ! -f "$script" ]]; then
        die "Step not found: $script"
    fi

    header "$name"
    bash "$script"
}

run_step "01-system-init"
run_step "02-hardware"
run_step "03-drivers"
run_step "04-postinstall"


# --- Done --------------------------------------------------------------------

header "Installation complete"
success "All steps finished successfully"
warn "Reboot your system to apply all changes"