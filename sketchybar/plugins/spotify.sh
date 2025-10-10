#!/usr/bin/env bash

# Updates the Spotify item with current playback info
# Shows "Artist — Track" and adjusts icon color by state

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Helper to set a neutral state when Spotify isn't running
set_inactive() {
  sketchybar --set spotify \
    label="Spotify not running" \
    icon=$SPOTIFY_PLAY_PAUSE \
    icon.color=$GREY
}

# Is Spotify running?
if ! osascript -e 'application "Spotify" is running' 2>/dev/null | grep -q true; then
  set_inactive
  exit 0
fi

# Fetch state and metadata via AppleScript
state=$(osascript -e 'tell application "Spotify" to if player state is playing then return "playing" else return "paused"')
track=$(osascript -e 'tell application "Spotify" to try
  return name of current track as string
on error
  return ""
end try')
artist=$(osascript -e 'tell application "Spotify" to try
  return artist of current track as string
on error
  return ""
end try')

label="$artist — $track"
[ -z "$artist$track" ] && label="Spotify"

color=$SPOTIFY_GREEN
[ "$state" = "paused" ] && color=$GREY

sketchybar --set spotify \
  label="$label" \
  icon=$SPOTIFY_PLAY_PAUSE \
  icon.color=$color
