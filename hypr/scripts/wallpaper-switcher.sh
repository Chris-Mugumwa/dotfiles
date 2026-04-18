#!/bin/bash

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wall-cache"
THUMB_DIR="$CACHE_DIR/thumbs"
SYMLINK="$CACHE_DIR/current_wallpaper"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"

mkdir -p "$THUMB_DIR"
mkdir -p "$WALLPAPER_DIR"

# Show current wallpaper path
if [[ "$1" == "current" ]]; then
  [[ -L "$SYMLINK" && -e "$SYMLINK" ]] && readlink -f "$SYMLINK" || echo "No wallpaper symlink found."
  exit $?
fi

[[ ! -d "$WALLPAPER_DIR" ]] && { echo "Wallpaper folder not found: $WALLPAPER_DIR"; exit 1; }

# Find all wallpaper files recursively
mapfile -t wallpaper_files < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null | sort)

if [[ ${#wallpaper_files[@]} -eq 0 ]]; then
    notify-send "Wallpaper Switcher" "No wallpapers found in $WALLPAPER_DIR" -u normal
    exit 1
fi

# Encode relative path as thumb filename (replace / with __ to avoid collisions)
encode_thumb_name() {
    local rel="${1#$WALLPAPER_DIR/}"
    local name="${rel%.*}"
    echo "${name//\//__}.thumb.png"
}

# Generate missing thumbnails
for img in "${wallpaper_files[@]}"; do
    thumb_path="$THUMB_DIR/$(encode_thumb_name "$img")"
    if [[ ! -f "$thumb_path" ]]; then
        magick "$img"[0] -strip -resize 400x600^ -gravity center -extent 400x600 "$thumb_path" 2>/dev/null
    fi
done

# Build Rofi entries — display "Subfolder/filename", icon from thumb
ENTRIES=""
for img in "${wallpaper_files[@]}"; do
    rel="${img#$WALLPAPER_DIR/}"
    thumb_path="$THUMB_DIR/$(encode_thumb_name "$img")"
    [[ -f "$thumb_path" ]] && ENTRIES+="$rel\x00icon\x1f$thumb_path\n"
done

# Show Rofi selection
SELECTED_REL=$(echo -e "$ENTRIES" | rofi -dmenu -show-icons -p "Select wallpaper" -theme "$ROFI_THEME")
[[ -z "$SELECTED_REL" ]] && exit 1

SELECTED="$WALLPAPER_DIR/$SELECTED_REL"

# Start awww daemon if not running
pgrep -x awww-daemon >/dev/null || { awww-daemon & sleep 0.5; }

# Set wallpaper with awww
awww img "$SELECTED" --transition-type any --transition-duration 1

# Save symlink
ln -sf "$SELECTED" "$SYMLINK"

notify-send "Wallpaper Switcher" "Wallpaper set: $(basename "$SELECTED")" -t 2000
