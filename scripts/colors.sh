#!/usr/bin/env bash
# scripts/colors.sh — color definitions and logging functions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'


log()     { echo -e "${BLUE}${BOLD}[*]${NC} $*"; }
success() { echo -e "${GREEN}${BOLD}[+]${NC} $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[!]${NC} $*"; }
error()   { echo -e "${RED}${BOLD}[-]${NC} $*"; }
die()     { error "$*"; exit 1; }
header()  { echo -e "\n${PURPLE}${BOLD}[>] $* ${NC}\n"; }

# Usage: banner "$BLUE" << 'EOF'
#   _  _  ___  __  __ ___
#  ...
# EOF
banner() {
    local color="${1:-$BLUE}"
    echo -e "${BOLD}${color}"
    while IFS= read -r line; do
        echo "$line"
    done
    echo -e "${NC}"
}
