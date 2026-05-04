#!/usr/bin/env sh

# Omarchy-style battery module

sketchybar --add item battery right \
  --set battery \
  update_freq=120 \
  script="$PLUGIN_DIR/battery.sh" \
  icon.font="$FONT:Bold:14.0" \
  icon.color=$TEXT \
  label.font="$FONT:Medium:13.0" \
  label.color=$TEXT \
  background.drawing=off
