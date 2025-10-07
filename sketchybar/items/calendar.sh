#!/usr/bin/env sh

# Horizontal SketchyBar - Clock (rightmost) + Date (left of clock)

# CLOCK (rightmost)
sketchybar --add item clock right \
  --set clock \
  update_freq=1 \
  script="$PLUGIN_DIR/clock.sh" \
  icon=$CLOCK \
  icon.color=$WHITE \
  icon.font="$FONT:Bold:13.0" \
  icon.padding_left=6 \
  icon.padding_right=6 \
  label.font="$FONT:Heavy:12.0" \
  label.color=$WHITE \
  background.drawing=off

# DATE (to the left of clock)
sketchybar --add item date right \
  --set date \
  update_freq=30 \
  script="$PLUGIN_DIR/clock.sh" \
  click_script="open -a Calendar" \
  icon=$CALENDAR \
  icon.color=$WHITE \
  icon.font="$FONT:Bold:12.0" \
  icon.padding_left=4 \
  icon.padding_right=4 \
  label.font="$FONT:Medium:12.0" \
  label.color=$WHITE \
  background.drawing=off
