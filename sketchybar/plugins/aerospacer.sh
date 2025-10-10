#!/bin/bash

# Omarchy-style workspace highlighting (background only on active)
source "$HOME/.config/sketchybar/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
        icon.color=$WORKSPACE_ACTIVE \
        background.color=$MODULE_BG_FOCUSED \
        background.drawing=on
else
    sketchybar --set $NAME \
        icon.color=$WORKSPACE_INACTIVE \
        background.drawing=off
fi

