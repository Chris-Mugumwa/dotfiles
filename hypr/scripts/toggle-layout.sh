#!/bin/bash
# Toggle between hyprscroller and dwindle layouts

current=$(hyprctl getoption general:layout -j | jq -r '.str')

if [ "$current" = "scroller" ]; then
    hyprctl keyword general:layout dwindle
    notify-send "Layout" "Switched to Dwindle"
else
    hyprctl keyword general:layout scroller
    notify-send "Layout" "Switched to Scroller"
fi
