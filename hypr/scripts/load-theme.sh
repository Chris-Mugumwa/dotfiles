#!/usr/bin/env bash

THEME_STATE="$HOME/.config/hypr/.current-theme"

# Create state file with default theme if it doesn't exist
if [ ! -f "$THEME_STATE" ]; then
    echo "everforest" > "$THEME_STATE"
fi

# Launch waybar - style.css already has the correct @import from last theme switch
waybar &
