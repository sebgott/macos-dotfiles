#!/usr/bin/env sh

# Omarchy-style workspaces on the left (background only on active)

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$sid" left \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
        icon="$sid" \
        icon.padding_left=10 \
        icon.padding_right=10 \
        icon.font="$FONT:Bold:15.0" \
        icon.color=$WORKSPACE_INACTIVE \
        icon.highlight_color=$WORKSPACE_ACTIVE \
        label.drawing=off \
        background.color=$MODULE_BG_FOCUSED \
        background.corner_radius=10 \
        background.height=26 \
        background.drawing=off \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospacer.sh $sid"
done
