#!/usr/bin/env sh

# Vertical SketchyBar - Date (top) + Clock (bottom)
# Clean spacing + proper centering

# DATE
sketchybar --add item date right \
  --set date \
  update_freq=30 \
  script="$PLUGIN_DIR/clock.sh" \
  click_script="open -a Calendar" \
  icon=$CALENDAR \
  icon.color=$WHITE \
  icon.font="$FONT:Bold:12.0" \
  icon.align=center \
  icon.padding_left=0 \
  icon.padding_right=0 \
  icon.y_offset=0 \
  label.font="$FONT:Medium:9.0" \
  label.color=$WHITE \
  label.align=center \
  label.padding_left=0 \
  label.padding_right=0 \
  label.y_offset=0 \
  width=50 \
  background.color=0x44ffffff \
  background.height=46 \
  background.corner_radius=14 \
  background.padding_left=6 \
  background.padding_right=6 \
  y_offset=120

# CLOCK
sketchybar --add item clock right \
  --set clock \
  update_freq=1 \
  script="$PLUGIN_DIR/clock.sh" \
  icon=$CLOCK \
  icon.color=$WHITE \
  icon.font="$FONT:Bold:13.0" \
  icon.align=center \
  icon.padding_left=0 \
  icon.padding_right=0 \
  icon.y_offset=0 \
  label.font="$FONT:Heavy:10.0" \
  label.color=$WHITE \
  label.align=center \
  label.padding_left=0 \
  label.padding_right=0 \
  label.y_offset=0 \
  width=50 \
  background.color=0x44ffffff \
  background.height=46 \
  background.corner_radius=14 \
  background.padding_left=6 \
  background.padding_right=6 \
  y_offset=60
