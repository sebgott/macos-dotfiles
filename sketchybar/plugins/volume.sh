#!/usr/bin/env bash

# Omarchy-style volume plugin

source "$HOME/.config/sketchybar/colors.sh"

# Toggle mute if requested
if [[ "$1" == "toggle" ]]; then
    osascript -e "set volume output muted not (output muted of (get volume settings))"
fi

# Get current volume and mute status
VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

# Determine icon based on volume level and mute status
if [[ "$MUTED" == "true" ]]; then
    ICON="󰝟"
    COLOR=$OVERLAY0
elif [[ $VOLUME -ge 70 ]]; then
    ICON="󰕾"
    COLOR=$VOLUME_COLOR
elif [[ $VOLUME -ge 30 ]]; then
    ICON="󰖀"
    COLOR=$VOLUME_COLOR
elif [[ $VOLUME -gt 0 ]]; then
    ICON="󰕿"
    COLOR=$VOLUME_COLOR
else
    ICON="󰝟"
    COLOR=$OVERLAY0
fi

sketchybar --set volume \
    icon="$ICON" \
    label="${VOLUME}%" \
    icon.color=$COLOR \
    label.color=$TEXT
