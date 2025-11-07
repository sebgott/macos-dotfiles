#!/bin/bash

# Omarchy-style workspace highlighting (background only on active)
source "$HOME/.config/sketchybar/colors.sh"

# Get the workspace ID from the first argument
WORKSPACE_ID="$1"

# Get the currently focused workspace from Aerospace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)

# Determine if this workspace is focused
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
        icon.color=$WORKSPACE_ACTIVE \
        background.color=$MODULE_BG_FOCUSED \
        background.drawing=on
else
    sketchybar --set $NAME \
        icon.color=$WORKSPACE_INACTIVE \
        background.drawing=off
fi

