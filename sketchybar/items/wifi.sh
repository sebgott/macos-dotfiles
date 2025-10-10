#!/usr/bin/env sh

# Omarchy-style Wi-Fi module with popup menu

WIFI_ICON="󰖩"

sketchybar --add item wifi right \
  --set wifi \
    update_freq=10 \
    script="$PLUGIN_DIR/wifi.sh" \
    icon="$WIFI_ICON" \
    icon.font="$FONT:Bold:16.0" \
    icon.color=$WIFI_COLOR \
    label.font="$FONT:Medium:13.0" \
    label.color=$TEXT \
    background.drawing=off \
    click_script="$PLUGIN_DIR/wifi.sh toggle_popup" \
    popup.horizontal=off \
    popup.align=right
