#!/usr/bin/env bash
# scripts/wallpaper.sh

WALLPAPER="$1"
hyprctl hyprpaper wallpaper ",$WALLPAPER"
matugen image "$WALLPAPER"