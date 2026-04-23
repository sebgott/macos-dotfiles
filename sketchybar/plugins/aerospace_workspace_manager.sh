#!/usr/bin/env sh

set -eu

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
AEROSPACE_BIN="/opt/homebrew/bin/aerospace"

# shellcheck disable=SC1090
. "$HOME/.config/sketchybar/colors.sh"

FOCUSED_WORKSPACE="$("$AEROSPACE_BIN" list-workspaces --focused 2>/dev/null || true)"
if [ -z "${FOCUSED_WORKSPACE}" ]; then
  exit 0
fi

ITEM="space.${FOCUSED_WORKSPACE}"

if ! sketchybar --query "$ITEM" >/dev/null 2>&1; then
  sketchybar --add item "$ITEM" left \
    --subscribe "$ITEM" aerospace_workspace_change \
    --set "$ITEM" \
    icon="$FOCUSED_WORKSPACE" \
    icon.padding_left=10 \
    icon.padding_right=10 \
    icon.font="SF Pro:Bold:15.0" \
    icon.color=$WORKSPACE_ACTIVE \
    icon.highlight_color=$WORKSPACE_ACTIVE \
    label.drawing=off \
    background.color=$MODULE_BG_FOCUSED \
    background.corner_radius=10 \
    background.height=26 \
    background.drawing=on \
    click_script="aerospace workspace $FOCUSED_WORKSPACE" \
    script="$PLUGIN_DIR/aerospacer.sh $FOCUSED_WORKSPACE"
fi

# Keep only "used" workspaces in the bar:
# - non-empty workspaces
# - plus the currently focused workspace
KEEP_WORKSPACES="$(
  {
    "$AEROSPACE_BIN" list-workspaces --monitor all --empty no
    printf '%s\n' "$FOCUSED_WORKSPACE"
  } 2>/dev/null | sort -u
)"

for item_name in $(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))'); do
  workspace_id="${item_name#space.}"
  if ! printf '%s\n' "$KEEP_WORKSPACES" | grep -Fxq "$workspace_id"; then
    sketchybar --remove "$item_name" >/dev/null 2>&1 || true
  fi
done

# Keep workspace items ordered as:
# 1) numeric IDs ascending
# 2) alphabetical IDs ascending
ORDERED_SPACE_ITEMS="$(
  sketchybar --query bar \
    | jq -r '.items[] | select(startswith("space."))' \
    | awk '
      {
        id = substr($0, 7)
        if (id ~ /^[0-9]+$/) {
          printf("0\t%020d\t%s\n", id + 0, $0)
        } else {
          printf("1\t%s\t%s\n", toupper(id), $0)
        }
      }
    ' \
    | sort -t "$(printf '\t')" -k1,1 -k2,2 \
    | awk -F "$(printf '\t')" '{print $3}'
)"

if [ -n "$ORDERED_SPACE_ITEMS" ]; then
  # shellcheck disable=SC2086
  sketchybar --reorder $ORDERED_SPACE_ITEMS
fi

