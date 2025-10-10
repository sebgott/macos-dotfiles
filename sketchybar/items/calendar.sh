#!/usr/bin/env sh

# Omarchy-style clock module (combined date and time)

sketchybar --add item clock right \
  --set clock \
  update_freq=10 \
  script="$PLUGIN_DIR/clock.sh" \
  icon="󰥔" \
  icon.font="$FONT:Bold:15.0" \
  icon.color=$TEXT \
  label.font="$FONT:Medium:13.0" \
  label.color=$TEXT \
  background.drawing=off \
  click_script="open -a Calendar"
