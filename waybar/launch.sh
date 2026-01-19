#!/usr/bin/env bash

WAYBAR_DIR="$HOME/.config/waybar"
STYLE_CSS="$WAYBAR_DIR/style.css"

# Update the @import line in style.css based on selected theme
case $1 in
    --nightowl)
        sed -i '' 's|@import "colorschemes/.*\.css";|@import "colorschemes/nightowl.css";|' "$STYLE_CSS"
        ;;
    --everforest)
        sed -i '' 's|@import "colorschemes/.*\.css";|@import "colorschemes/everforest.css";|' "$STYLE_CSS"
        ;;
    *)
        sed -i '' 's|@import "colorschemes/.*\.css";|@import "colorschemes/catppuccin-mocha.css";|' "$STYLE_CSS"
        ;;
esac

# Launch waybar (it will use style.css by default)
waybar
