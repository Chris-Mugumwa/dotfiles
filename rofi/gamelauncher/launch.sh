#!/usr/bin/env bash

STEAM_PATH="$HOME/.local/share/Steam/steamapps"
dir="$HOME/.config/rofi/gamelauncher"

# Parse installed games from Steam's appmanifest files
get_games() {
    for acf in "$STEAM_PATH"/appmanifest_*.acf; do
        if [[ -f "$acf" ]]; then
            name=$(grep -Po '"name"\s*"\K[^"]+' "$acf")
            appid=$(grep -Po '"appid"\s*"\K[^"]+' "$acf")
            # Skip Proton/Steam runtime entries
            [[ "$name" =~ ^(Proton|Steam\ Linux|Steamworks) ]] && continue
            echo "$name|$appid"
        fi
    done | sort
}

# Rofi menu
selected=$(get_games | cut -d'|' -f1 | rofi -dmenu -i -p "Games" \
    -theme "$dir/config.rasi")

[[ -z "$selected" ]] && exit 0

# Get appid for selected game
appid=$(get_games | grep "^$selected|" | cut -d'|' -f2)

# Launch game
steam steam://rungameid/"$appid"
