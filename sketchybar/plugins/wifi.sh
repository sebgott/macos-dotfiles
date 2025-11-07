#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

WIFI_CONNECTED="󰤨"
WIFI_DISCONNECTED="󰤯"

is_connected_to_internet() {
  if ! route get default &>/dev/null 2>&1; then
    return 1
  fi
  
  if ping -c 1 -t 1 8.8.8.8 &>/dev/null 2>&1; then
    return 0
  fi
  
  if nslookup google.com &>/dev/null 2>&1; then
    return 0
  fi
  
  return 1
}

is_wifi_on() {
  local dev
  dev=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')
  
  if [ -z "$dev" ]; then
    return 1
  fi
  
  local power
  power=$(networksetup -getairportpower "$dev" 2>/dev/null | awk '{print $4}')
  
  if [ "$power" = "On" ]; then
    return 0
  fi
  
  return 1
}

main() {
  if ! is_wifi_on; then
    sketchybar --set wifi \
      icon="$WIFI_DISCONNECTED" \
      icon.color=$OVERLAY0
    exit 0
  fi
  
  if is_connected_to_internet; then
    sketchybar --set wifi \
      icon="$WIFI_CONNECTED" \
      icon.color=$WIFI_COLOR
  else
    sketchybar --set wifi \
      icon="$WIFI_DISCONNECTED" \
      icon.color=$OVERLAY0
  fi
}

main "$@"
