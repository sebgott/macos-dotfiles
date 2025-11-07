#!/usr/bin/env sh

sketchybar --add item wifi right \
  --set wifi \
    update_freq=5 \
    script="$PLUGIN_DIR/wifi.sh" \
    icon.font="$ICON_FONT:Semibold:11.0" \
    icon.color=$WIFI_COLOR \
    label.drawing=off \
    background.drawing=off
