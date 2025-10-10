#!/usr/bin/env sh

# Spotify item: shows current track and allows play/pause and next via clicks

sketchybar --add item spotify right \
  --set spotify \
    update_freq=2 \
    script="$PLUGIN_DIR/spotify.sh" \
    icon=$SPOTIFY_PLAY_PAUSE \
    icon.color=$SPOTIFY_GREEN \
    click_script='osascript -e "tell application \"Spotify\" to playpause"' \
    right_click_script='osascript -e "tell application \"Spotify\" to next track"'
