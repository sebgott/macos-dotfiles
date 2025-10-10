#!/usr/bin/env sh

# Omarchy-style clock plugin

source "$HOME/.config/sketchybar/colors.sh"

# Get current time and date
TIME=$(date '+%H:%M')
DATE=$(date '+%a %d %b')

# Update the clock item with combined date and time
sketchybar --set clock \
           label="$DATE $TIME" \
           icon.color=$TEXT \
           label.color=$TEXT
