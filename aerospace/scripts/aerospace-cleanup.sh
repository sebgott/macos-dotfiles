#!/bin/bash

# List all windows with id, app, and title
aerospace list-windows --all --format "%{window-id}|%{app-name}|%{window-title}" |
  while IFS="|" read -r id app title; do
    # Trim whitespace
    trimmed=$(echo "$title" | xargs)
    if [[ "$app" == "Ghostty" ]]; then
      continue
    fi
    # Condition: empty title → likely ghost
    if [[ -z "$trimmed" ]]; then
      echo "Closing ghost window: $id ($app)"
      aerospace close --window-id "$id"
    fi
  done
