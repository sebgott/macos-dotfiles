#!/usr/bin/env bash

# Omarchy-style battery plugin

source "$HOME/.config/sketchybar/colors.sh"

# Get battery percentage
PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

# Determine battery icon based on level
if [[ $PERCENTAGE -ge 90 ]]; then
    ICON="󰁹"
elif [[ $PERCENTAGE -ge 80 ]]; then
    ICON="󰂂"
elif [[ $PERCENTAGE -ge 70 ]]; then
    ICON="󰂁"
elif [[ $PERCENTAGE -ge 60 ]]; then
    ICON="󰂀"
elif [[ $PERCENTAGE -ge 50 ]]; then
    ICON="󰁿"
elif [[ $PERCENTAGE -ge 40 ]]; then
    ICON="󰁾"
elif [[ $PERCENTAGE -ge 30 ]]; then
    ICON="󰁽"
elif [[ $PERCENTAGE -ge 20 ]]; then
    ICON="󰁼"
elif [[ $PERCENTAGE -ge 10 ]]; then
    ICON="󰁻"
else
    ICON="󰁺"
fi

# Add charging icon if charging
if [[ -n $CHARGING ]]; then
    ICON="󰂄"
    COLOR=$BATTERY_CHARGING
elif [[ $PERCENTAGE -lt 20 ]]; then
    COLOR=$BATTERY_LOW
else
    COLOR=$TEXT
fi

sketchybar --set battery \
    icon="$ICON" \
    label="${PERCENTAGE}%" \
    icon.color=$COLOR \
    label.color=$COLOR
