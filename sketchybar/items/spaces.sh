#!/usr/bin/env sh

# Omarchy-style workspaces on the left (background only on active)

sketchybar --add event aerospace_workspace_change

sketchybar --add item aerospace.workspace_manager left \
  --subscribe aerospace.workspace_manager aerospace_workspace_change \
  --set aerospace.workspace_manager \
  drawing=on \
  width=0 \
  padding_left=0 \
  padding_right=0 \
  background.drawing=off \
  icon.drawing=off \
  label.drawing=off \
  updates=on \
  script="$PLUGIN_DIR/aerospace_workspace_manager.sh"

# Only show "used" workspaces:
# - non-empty ones (have windows)
# - plus the currently focused one (so a newly-created empty workspace appears only after you switch to it)
for sid in $(
  { aerospace list-workspaces --monitor all --empty no; aerospace list-workspaces --focused; } 2>/dev/null \
    | sort -u
); do
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
        script="$PLUGIN_DIR/aerospacer.sh $sid"
done
