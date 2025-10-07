#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change
RED=0xffed8796
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$sid" left \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
        icon="$sid"\
                              icon.padding_left=10                          \
                              icon.padding_right=10                         \
                              label.padding_right=12                        \
                              icon.highlight_color=$RED                     \
                              background.color=0x44ffffff \
                              background.corner_radius=5 \
                              background.height=24 \
                              background.drawing=off                         \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.background.height=24                    \
                              label.background.drawing=on                   \
                              label.background.color=0xff494d64             \
                              label.background.corner_radius=7              \
                              label.drawing=off                             \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospacer.sh $sid"
done

sketchybar   --add item       separator left                          \
             --set separator  icon=                                  \
                              icon.font="Hack Nerd Font:Regular:16.0" \
                              background.padding_left=8              \
                              background.padding_right=8             \
                              label.drawing=off                       \
                              associated_display=active               \
                              icon.color=$WHITE
