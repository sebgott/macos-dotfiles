#!/usr/bin/env bash

# Wi-Fi plugin: updates SSID and shows popup menu with nearby networks

source "$HOME/.config/sketchybar/colors.sh"

AIRPORT_BIN="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
WIFI_HELPER="$HOME/.config/sketchybar/helper/wifi_helper"
POPUP_OFF="sketchybar --set wifi popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

get_device() {
  networksetup -listallhardwareports \
    | awk '/Wi-Fi|AirPort/{getline; print $2; exit}'
}

scan_networks() {
  # Scan for nearby networks and return formatted list
  
  # Method 1: Swift CoreWLAN (most reliable on modern macOS)
  if [ -f "$WIFI_HELPER" ]; then
    local networks
    networks=$("$WIFI_HELPER" scan 2>/dev/null | grep -v "SCAN_ERROR" | grep -v "NO_INTERFACE")
    if [ -n "$networks" ]; then
      echo "$networks"
      return
    fi
  fi
  
  # Method 2: airport (deprecated but sometimes works)
  local networks
  networks=$("$AIRPORT_BIN" -s 2>/dev/null | awk 'NR>1 && $1 != "" {printf "%s|%s\n", $1, $2}' | head -15)
  
  if [ -n "$networks" ]; then
    echo "$networks"
    return
  fi
  
  echo ""
}

connect_to_network() {
  local ssid="$1"
  local dev
  dev=$(get_device)
  
  # Attempt to join network (will prompt for password if needed)
  networksetup -setairportnetwork "$dev" "$ssid"
  
  # Wait a moment for connection
  sleep 1
  
  # Refresh the main wifi display
  "$0"
  
  # Close popup and clear state
  eval "$POPUP_OFF"
  rm -f /tmp/sketchybar_wifi_popup_state
}

populate_popup() {
  local current_ssid
  local dev
  dev=$(get_device)
  
  if [ -z "$dev" ]; then
    return
  fi
  
  # Get current SSID from Swift helper (faster)
  if [ -f "$WIFI_HELPER" ]; then
    current_ssid=$("$WIFI_HELPER" info 2>/dev/null)
    [ "$current_ssid" = "NOT_CONNECTED" ] && current_ssid=""
    [ "$current_ssid" = "NO_INTERFACE" ] && current_ssid=""
  else
    current_ssid=$(get_ssid "$dev")
  fi
  
  # Scan networks (run in background to speed up)
  local networks
  networks=$(scan_networks)
  
  if [ -z "$networks" ]; then
    sketchybar --add item wifi.network.none popup.wifi \
      --set wifi.network.none \
      icon="󰥶" \
      label="No networks found" \
      icon.color=$OVERLAY0 \
      label.color=$OVERLAY0 \
      icon.padding_left=10 \
      icon.padding_right=10
    return
  fi
  
  # Sort networks: current network first, then by signal strength
  local sorted_networks
  if [ -n "$current_ssid" ]; then
    # Get current network
    local current_line
    current_line=$(echo "$networks" | grep "^$current_ssid|" | head -1)
    
    # Get other networks sorted by signal (RSSI, higher = better)
    local other_networks
    other_networks=$(echo "$networks" | grep -v "^$current_ssid|" | sort -t'|' -k2 -rn)
    
    # Combine: current first, then others
    if [ -n "$current_line" ]; then
      sorted_networks=$(printf "%s\n%s" "$current_line" "$other_networks")
    else
      sorted_networks="$other_networks"
    fi
  else
    # No current network, just sort by signal
    sorted_networks=$(echo "$networks" | sort -t'|' -k2 -rn)
  fi
  
  # Add each network to popup
  local index=0
  local unknown_count=1
  while IFS='|' read -r ssid signal; do
    [ -z "$ssid" ] && continue
    
    local item_name="wifi.network.$index"
    local icon="󰖩"
    local color=$TEXT
    local display_name="$ssid"
    
    # If SSID is Unknown, show signal strength instead
    if [ "$ssid" = "Unknown" ]; then
      display_name="Network $unknown_count (${signal}dBm)"
      unknown_count=$((unknown_count + 1))
    fi
    
    # Highlight current network
    if [ "$ssid" = "$current_ssid" ] || ([ -z "$current_ssid" ] && [ $index -eq 0 ]); then
      icon="󰚪"
      color=$WIFI_COLOR
      display_name="Connected: $display_name"
    fi
    
    sketchybar --add item "$item_name" popup.wifi \
      --set "$item_name" \
      icon="$icon" \
      label="$display_name" \
      icon.color="$color" \
      label.color="$color" \
      icon.padding_left=10 \
      icon.padding_right=10 \
      click_script="$PLUGIN_DIR/wifi.sh connect \"$ssid\""
    
    index=$((index + 1))
  done <<< "$sorted_networks"
  
  # Add separator
  sketchybar --add item wifi.separator popup.wifi \
    --set wifi.separator \
    icon="──────────" \
    icon.color=$OVERLAY0 \
    label.drawing=off \
    icon.padding_left=10 \
    icon.padding_right=10
  
  # Add "Open Network Settings" option
  sketchybar --add item wifi.settings popup.wifi \
    --set wifi.settings \
    icon="󰢽" \
    label="Settings" \
    icon.color=$BLUE \
    label.color=$BLUE \
    icon.padding_left=10 \
    icon.padding_right=10 \
    click_script='open -b com.apple.systempreferences "x-apple.systempreferences:com.apple.preference.network"; sketchybar --set wifi popup.drawing=off; rm -f /tmp/sketchybar_wifi_popup_state'
}

toggle_popup() {
  # Use a state file to track if popup is open
  local state_file="/tmp/sketchybar_wifi_popup_state"
  
  if [ -f "$state_file" ]; then
    # Popup is open - just close it
    sketchybar --set wifi popup.drawing=off
    rm -f "$state_file"
  else
    # Popup is closed - show it immediately with a loading message
    sketchybar --remove '/wifi\.network\..*/' wifi.separator wifi.settings 2>/dev/null
    
    sketchybar --add item wifi.loading popup.wifi \
      --set wifi.loading \
      icon="󰔟" \
      label="Scanning networks..." \
      icon.color=$OVERLAY1 \
      label.color=$OVERLAY1 \
      icon.padding_left=10 \
      icon.padding_right=10
    
    sketchybar --set wifi popup.drawing=on
    touch "$state_file"
    
    # Populate in background
    (
      sleep 0.1
      sketchybar --remove wifi.loading 2>/dev/null
      populate_popup
    ) &
  fi
}

get_power() {
  local dev="$1"
  networksetup -getairportpower "$dev" | awk '{print $4}'
}

toggle_power() {
  local dev="$1"
  local p
  p=$(get_power "$dev")
  if [ "$p" = "On" ]; then
    networksetup -setairportpower "$dev" off
  else
    networksetup -setairportpower "$dev" on
  fi
}

get_ssid() {
  local dev="$1"
  
  # Try multiple methods to get SSID
  
  # Method 1: networksetup (sometimes works)
  local line
  line=$(networksetup -getairportnetwork "$dev" 2>/dev/null)
  if echo "$line" | grep -q "Current Wi-Fi Network:"; then
    echo "$line" | sed 's/^Current Wi-Fi Network: \(.*\)$/\1/'
    return
  fi
  
  # Method 2: system_profiler (more reliable)
  local ssid
  ssid=$(system_profiler SPAirPortDataType 2>/dev/null | 
         awk '/Current Network Information:/{getline; if($0 ~ /^[[:space:]]+[^:]+:/) {gsub(/^[[:space:]]+|:[[:space:]]*$/, ""); print; exit}}')
  if [ -n "$ssid" ] && [ "$ssid" != "Current Network Information" ] && [ "$ssid" != "<redacted>" ]; then
    echo "$ssid"
    return
  fi
  
  # Method 3: Check if interface has an IP (means connected)
  if ifconfig "$dev" | grep -q "inet "; then
    # Connected but can't get SSID - show "Connected"
    echo "Connected"
    return
  fi
  
  echo "Not connected"
}

get_rssi() {
  # Returns RSSI (negative dBm) or empty
  "$AIRPORT_BIN" -I 2>/dev/null | awk -F': ' '/agrCtlRSSI/{print $2; exit}'
}

bars_from_rssi() {
  local rssi="$1"
  # Map RSSI to 0-4 bars roughly
  # >= -55 -> 4, >= -65 -> 3, >= -75 -> 2, >= -85 -> 1, else 0
  if [ -z "$rssi" ]; then echo 0; return; fi
  if [ "$rssi" -ge -55 ] 2>/dev/null; then echo 4
  elif [ "$rssi" -ge -65 ] 2>/dev/null; then echo 3
  elif [ "$rssi" -ge -75 ] 2>/dev/null; then echo 2
  elif [ "$rssi" -ge -85 ] 2>/dev/null; then echo 1
  else echo 0; fi
}

main() {
  # Handle commands
  case "$1" in
    toggle_popup)
      toggle_popup
      exit 0
      ;;
    connect)
      connect_to_network "$2"
      exit 0
      ;;
    toggle)
      local dev
      dev=$(get_device)
      toggle_power "$dev"
      sleep 0.3
      ;;
  esac
  
  # Regular update
  local dev
  dev=$(get_device)
  [ -z "$dev" ] && sketchybar --set wifi label="No Wi-Fi device" icon.color=$OVERLAY0 label.color=$OVERLAY0 && exit 0

  local power ssid rssi bars
  power=$(get_power "$dev")
  if [ "$power" != "On" ]; then
    sketchybar --set wifi label="Off" icon.color=$OVERLAY0 label.color=$OVERLAY0
    exit 0
  fi

  ssid=$(get_ssid "$dev")
  if [ "$ssid" = "Not connected" ]; then
    sketchybar --set wifi label="Disconnected" icon.color=$OVERLAY0 label.color=$OVERLAY0
    exit 0
  fi

  rssi=$(get_rssi)
  bars=$(bars_from_rssi "$rssi")
  
  # Simple SSID display for Omarchy style
  sketchybar --set wifi label="$ssid" icon.color=$WIFI_COLOR label.color=$TEXT
}

main "$@"
