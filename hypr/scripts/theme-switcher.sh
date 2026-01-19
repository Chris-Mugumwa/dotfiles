#!/usr/bin/env bash

THEME_DIR="$HOME/.config"
THEME_STATE="$HOME/.config/hypr/.current-theme"

# Display names for rofi
DISPLAY_THEMES=("Autumn" "Catppuccin Mocha" "Crimson" "Everforest" "Graphite" "Gruvbox" "Kanagawa" "Nightowl" "Oxocarbon" "Rosepine")

# Map display names to config names
declare -A THEME_MAP
THEME_MAP["Autumn"]="autumn"
THEME_MAP["Catppuccin Mocha"]="catppuccin-mocha"
THEME_MAP["Crimson"]="crimson"
THEME_MAP["Everforest"]="everforest"
THEME_MAP["Graphite"]="graphite"
THEME_MAP["Gruvbox"]="gruvbox"
THEME_MAP["Kanagawa"]="kanagawa"
THEME_MAP["Nightowl"]="nightowl"
THEME_MAP["Oxocarbon"]="oxocarbon"
THEME_MAP["Rosepine"]="rosepine"

# Use rofi to select theme (show capitalized names)
SELECTED_DISPLAY=$(printf '%s\n' "${DISPLAY_THEMES[@]}" | rofi -dmenu -i -p "Select Theme" -theme-str 'window {width: 400px;}')

if [ -z "$SELECTED_DISPLAY" ]; then
    exit 0
fi

# Get the config name from display name
SELECTED_THEME="${THEME_MAP[$SELECTED_DISPLAY]}"

# Save selected theme to state file for persistence
echo "$SELECTED_THEME" > "$THEME_STATE"

# Update Rofi theme
ROFI_CONF="$THEME_DIR/rofi/config.rasi"
ROFI_POWERMENU_CONF="$THEME_DIR/rofi/powermenu/config.rasi"
ROFI_WALLPAPER_CONF="$THEME_DIR/rofi/wallpaper.rasi"
ROFI_GAMELAUNCHER_CONF="$THEME_DIR/rofi/gamelauncher/config.rasi"
ROFI_CLIPBOARD_CONF="$THEME_DIR/rofi/clipboard.rasi"
sed -i 's|@import "colorschemes/.*\.rasi"|@import "colorschemes/'"$SELECTED_THEME"'.rasi"|' "$ROFI_CONF"
sed -i 's|@import "colorschemes/.*\.rasi"|@import "colorschemes/'"$SELECTED_THEME"'.rasi"|' "$ROFI_POWERMENU_CONF"
sed -i 's|@import "colorschemes/.*\.rasi"|@import "colorschemes/'"$SELECTED_THEME"'.rasi"|' "$ROFI_WALLPAPER_CONF"
sed -i 's|@import "\.\./colorschemes/.*\.rasi"|@import "../colorschemes/'"$SELECTED_THEME"'.rasi"|' "$ROFI_GAMELAUNCHER_CONF"
sed -i 's|@import "\.\./colorschemes/.*\.rasi"|@import "../colorschemes/'"$SELECTED_THEME"'.rasi"|' "$ROFI_CLIPBOARD_CONF"

# Update Kitty theme
KITTY_CONF="$THEME_DIR/kitty/kitty.conf"
# Use catppuccin as fallback if theme doesn't exist for kitty
if [ -f "$THEME_DIR/kitty/themes/$SELECTED_THEME.conf" ]; then
    sed -i 's|^include themes/.*\.conf|include themes/'"$SELECTED_THEME"'.conf|' "$KITTY_CONF"
else
    sed -i 's|^include themes/.*\.conf|include themes/catppuccin-mocha.conf|' "$KITTY_CONF"
fi

# Reload Kitty config for all instances
killall -SIGUSR1 kitty 2>/dev/null

# Update Tmux theme
TMUX_CONF="$THEME_DIR/tmux/tmux.conf"
if [ -f "$THEME_DIR/tmux/colorschemes/$SELECTED_THEME.conf" ]; then
    sed -i 's|source-file ~/.config/tmux/colorschemes/.*\.conf|source-file ~/.config/tmux/colorschemes/'"$SELECTED_THEME"'.conf|' "$TMUX_CONF"
fi

# Reload tmux config if tmux is running
if command -v tmux &> /dev/null && tmux list-sessions &> /dev/null; then
    tmux source-file "$TMUX_CONF" 2>/dev/null
fi

# Update Swaync theme
SWAYNC_CSS="$THEME_DIR/swaync/style.css"
# Use everforest as fallback if theme doesn't exist for swaync
if [ -f "$THEME_DIR/swaync/colorschemes/$SELECTED_THEME.css" ]; then
    sed -i 's|@import "./colorschemes/.*\.css"|@import "./colorschemes/'"$SELECTED_THEME"'.css"|' "$SWAYNC_CSS"
else
    sed -i 's|@import "./colorschemes/.*\.css"|@import "./colorschemes/everforest.css"|' "$SWAYNC_CSS"
fi

# Restart swaync
pkill swaync
swaync &

# Update Waybar theme
WAYBAR_STYLE="$THEME_DIR/waybar/style.css"
sed -i 's|@import "colorschemes/.*\.css";|@import "colorschemes/'"$SELECTED_THEME"'.css";|' "$WAYBAR_STYLE"

# Update Wlogout theme
WLOGOUT_STYLE="$THEME_DIR/wlogout/style.css"
sed -i 's|@import "../waybar/colorschemes/.*\.css";|@import "../waybar/colorschemes/'"$SELECTED_THEME"'.css";|' "$WLOGOUT_STYLE"

# Update Spotify theme (if spicetify is installed)
if command -v spicetify &> /dev/null; then
    case $SELECTED_THEME in
        "autumn")
            spicetify config color_scheme TokyoNight 2>/dev/null || true
            ;;
        "catppuccin-mocha")
            spicetify config color_scheme CatppuccinMocha 2>/dev/null || true
            ;;
        "crimson")
            spicetify config color_scheme Dracula 2>/dev/null || true
            ;;
        "everforest")
            spicetify config color_scheme EverforestDarkMedium 2>/dev/null || true
            ;;
        "graphite")
            spicetify config color_scheme Solarized 2>/dev/null || true
            ;;
        "gruvbox")
            spicetify config color_scheme GruvboxDark 2>/dev/null || true
            ;;
        "kanagawa")
            spicetify config color_scheme Kanagawa 2>/dev/null || true
            ;;
        "nightowl")
            spicetify config color_scheme Nord 2>/dev/null || true
            ;;
        "oxocarbon")
            spicetify config color_scheme TokyoNightStorm 2>/dev/null || true
            ;;
        "rosepine")
            spicetify config color_scheme RosePine 2>/dev/null || true
            ;;
    esac
    spicetify apply 2>/dev/null || true
fi

# Restart waybar
pkill waybar
waybar &

# Update Hyprland border colors
case $SELECTED_THEME in
    "autumn")
        hyprctl keyword general:col.active_border "rgb(d47766)"
        hyprctl keyword general:col.inactive_border "rgb(1c1e26)"
        ;;
    "catppuccin-mocha")
        hyprctl keyword general:col.active_border "rgb(b4befe)"
        hyprctl keyword general:col.inactive_border "rgb(45475a)"
        ;;
    "crimson")
        hyprctl keyword general:col.active_border "rgb(d74e61)"
        hyprctl keyword general:col.inactive_border "rgb(16161c)"
        ;;
    "everforest")
        hyprctl keyword general:col.active_border "rgb(a7c080)"
        hyprctl keyword general:col.inactive_border "rgb(3d484d)"
        ;;
    "graphite")
        hyprctl keyword general:col.active_border "rgb(888888)"
        hyprctl keyword general:col.inactive_border "rgb(292929)"
        ;;
    "gruvbox")
        hyprctl keyword general:col.active_border "rgb(b8bb26)"
        hyprctl keyword general:col.inactive_border "rgb(3c3836)"
        ;;
    "kanagawa")
        hyprctl keyword general:col.active_border "rgb(7e9cd8)"
        hyprctl keyword general:col.inactive_border "rgb(223249)"
        ;;
    "nightowl")
        hyprctl keyword general:col.active_border "rgb(82aaff)"
        hyprctl keyword general:col.inactive_border "rgb(011627)"
        ;;
    "oxocarbon")
        hyprctl keyword general:col.active_border "rgb(78a9ff)"
        hyprctl keyword general:col.inactive_border "rgb(262626)"
        ;;
    "rosepine")
        hyprctl keyword general:col.active_border "rgb(c4a7e7)"
        hyprctl keyword general:col.inactive_border "rgb(191724)"
        ;;
esac

# Update Papirus folder colors
if command -v papirus-folders &> /dev/null; then
    case $SELECTED_THEME in
        "autumn")
            papirus-folders -C orange --theme Papirus-Dark 2>/dev/null
            ;;
        "catppuccin-mocha")
            papirus-folders -C violet --theme Papirus-Dark 2>/dev/null
            ;;
        "crimson")
            papirus-folders -C red --theme Papirus-Dark 2>/dev/null
            ;;
        "everforest")
            papirus-folders -C green --theme Papirus-Dark 2>/dev/null
            ;;
        "graphite")
            papirus-folders -C grey --theme Papirus-Dark 2>/dev/null
            ;;
        "gruvbox")
            papirus-folders -C yellow --theme Papirus-Dark 2>/dev/null
            ;;
        "kanagawa")
            papirus-folders -C indigo --theme Papirus-Dark 2>/dev/null
            ;;
        "nightowl")
            papirus-folders -C blue --theme Papirus-Dark 2>/dev/null
            ;;
        "oxocarbon")
            papirus-folders -C cyan --theme Papirus-Dark 2>/dev/null
            ;;
        "rosepine")
            papirus-folders -C pink --theme Papirus-Dark 2>/dev/null
            ;;
    esac
fi

notify-send "Theme Switcher" "Switched to $SELECTED_DISPLAY theme" -t 2000
