#!/usr/bin/env bash
# =============================================================================
# install.sh — orchestrator
# Usage:
#   ./install.sh
#   ./install.sh --device laptop --drivers amd --mirrors Poland
# =============================================================================

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STEPS_DIR="$ROOT_DIR/steps"

source "$ROOT_DIR/scripts/main.sh"

require_non_root
sudo_keep_alive

banner "$BLUE" << 'EOF'
   ___           __           __    _ __      _          __       ____       
  / _ | ________/ /    ____  / /__ (_) /_    (_)__  ___ / /____ _/ / /__ ____
 / __ |/ __/ __/ _ \  /___/ /  '_// / __/   / / _ \(_-</ __/ _ `/ / / -_) __/
/_/ |_/_/  \__/_//_/       /_/\_\/_/\__/   /_/_//_/___/\__/\_,_/_/_/\__/_/   
EOF

# --- Argument parsing --------------------------------------------------------

DEVICE=""
DRIVERS=""
MIRROR_COUNTRY=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --device)   DEVICE="$2";  shift 2 ;;
        --drivers)  DRIVERS="$2"; shift 2 ;;
        --mirrors)  MIRROR_COUNTRY="$2"; shift 2 ;;
        *) die "Unknown argument: $1" ;;
    esac
done

# --- Interactive selection ---------------------------------------------------

[[ -z "$DEVICE" ]]  && DEVICE=$(ask  "Device type:"  "desktop" "laptop")
[[ -z "$DRIVERS" ]] && DRIVERS=$(ask "GPU drivers:"  "amd" "nvidia" "amd-nvidia" "intel-nvidia" "none")

# --- Summary -----------------------------------------------------------------

header "Installation summary"
echo -e "  Device:  ${BOLD}$DEVICE${NC}"
echo -e "  Drivers: ${BOLD}$DRIVERS${NC}"
if [[ -n "$MIRROR_COUNTRY" ]]; then
    echo -e "  Mirrors: ${BOLD}$MIRROR_COUNTRY${NC}"
fi
echo ""
read -rp "Proceed? [y/N]: " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { log "Aborted."; exit 0; }

# --- Export for steps --------------------------------------------------------

export ROOT_DIR
export DEVICE
export DRIVERS
export MIRROR_COUNTRY

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

run_step "system-init"
run_step "hardware"
run_step "drivers"
run_step "post-install"


# --- Done --------------------------------------------------------------------

header "Installation complete"
success "All steps finished successfully"
warn "Reboot your system to apply all changes"
