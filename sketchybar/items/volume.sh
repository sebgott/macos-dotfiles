#!/usr/bin/env sh

# Omarchy-style volume module

sketchybar --add item volume right \
  --set volume \
  update_freq=5 \
  script="$PLUGIN_DIR/volume.sh" \
  icon.font="$FONT:Bold:14.0" \
  icon.color=$VOLUME_COLOR \
  label.font="$FONT:Medium:13.0" \
  label.color=$TEXT \
  background.drawing=off \
  click_script="$PLUGIN_DIR/volume.sh toggle" \
  --subscribe volume volume_change
