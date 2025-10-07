#!/usr/bin/env sh

# Source colors
source "$HOME/.config/sketchybar/colors.sh"

# Get current time and date formatted for vertical layout
TIME=$(date '+%H:%M')
DATE_COMPACT=$(date '+%d/%m')

# Update the clock item with time (stacked vertically)
sketchybar --set clock \
           label="$TIME" \
           icon.color=$WHITE \
           label.color=$WHITE

# Update the date item with compact date (DD/MM)
sketchybar --set date \
           label="$DATE_COMPACT" \
           icon.color=$WHITE \
           label.color=$WHITE
