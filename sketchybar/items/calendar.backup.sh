#!/usr/bin/env sh

# Clock component - optimized for vertical bar
sketchybar --add item clock right \
  --set clock update_freq=1 \
  script="$PLUGIN_DIR/clock.sh" \
  icon=$CLOCK \
  icon.color=$WHITE \
  icon.font="$FONT:Bold:13.0" \
  icon.align=center \
  icon.padding_left=0 \
  icon.padding_right=0 \
  icon.y_offset=8 \
  label.font="$FONT:Heavy:10.0" \
  label.color=$WHITE \
  label.align=center \
  label.padding_left=0 \
  label.padding_right=0 \
  label.y_offset=-8 \
  width=40 \
  background.color=0x44ffffff \
  background.height=50 \
  background.corner_radius=14 \
  background.padding_left=8 \
  background.padding_right=8 \
  y_offset=70 \
  \
  --add item date right \
  --set date update_freq=30 \
  script="$PLUGIN_DIR/clock.sh" \
  click_script="open -a Calendar" \
  icon=$CALENDAR \
  icon.color=$WHITE \
  icon.font="$FONT:Bold:12.0" \
  icon.align=center \
  icon.padding_left=0 \
  icon.padding_right=0 \
  icon.y_offset=6 \
  label.font="$FONT:Medium:9.0" \
  label.color=$WHITE \
  label.align=center \
  label.padding_left=0 \
  label.padding_right=0 \
  label.y_offset=-6 \
  width=40 \
  background.color=0x44ffffff \
  background.height=42 \
  background.corner_radius=14 \
  background.padding_left=8 \
  background.padding_right=8 \
  y_offset=10
