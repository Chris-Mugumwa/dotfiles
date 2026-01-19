#!/bin/bash

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wall-cache"
THUMB_DIR="$CACHE_DIR/thumbs"
SYMLINK="$CACHE_DIR/current_wallpaper"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"
ROFI_CLIP="$HOME/.config/rofi/clipboard.rasi"

mkdir -p "$THUMB_DIR"
mkdir -p "$WALLPAPER_DIR"

# Show current wallpaper path
if [[ "$1" == "current" ]]; then
  [[ -L "$SYMLINK" && -e "$SYMLINK" ]] && readlink -f "$SYMLINK" || echo "❌ No wallpaper symlink found."
  exit $?
fi

[[ ! -d "$WALLPAPER_DIR" ]] && { echo "❌ Wallpaper folder not found: $WALLPAPER_DIR"; exit 1; }

# Find all wallpaper files
wallpaper_files=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null)

if [[ -z "$wallpaper_files" ]]; then
    notify-send "Wallpaper Switcher" "No wallpapers found in $WALLPAPER_DIR" -u normal
    exit 1
fi

# Check for missing thumbnails
missing_thumbs=()

while IFS= read -r img; do
  filename=$(basename "$img")
  name="${filename%.*}"
  thumb_path="$THUMB_DIR/${name}.thumb.png"
  [[ ! -f "$thumb_path" ]] && missing_thumbs+=("$img")
done <<< "$wallpaper_files"

# Generate missing thumbnails
if [[ ${#missing_thumbs[@]} -gt 0 ]]; then
  echo "🔄 Caching ${#missing_thumbs[@]} missing thumbnails..."

  for img in "${missing_thumbs[@]}"; do
    filename=$(basename "$img")
    name="${filename%.*}"
    thumb_path="$THUMB_DIR/${name}.thumb.png"

    # Generate thumbnail using imagemagick
    convert "$img"[0] -strip -resize 400x600^ -gravity center -extent 400x600 "$thumb_path" 2>/dev/null
  done
fi

# Build Rofi entries with thumbnails
ENTRIES=""
while IFS= read -r img; do
  filename=$(basename "$img")
  name="${filename%.*}"
  thumb_path="$THUMB_DIR/${name}.thumb.png"
  [[ -f "$thumb_path" ]] && ENTRIES+="$filename\x00icon\x1f$thumb_path\n"
done <<< "$wallpaper_files"

# Show Rofi selection
SELECTED_NAME=$(echo -e "$ENTRIES" | rofi -dmenu -show-icons -p "Select wallpaper" -theme "$ROFI_THEME")
[[ -z "$SELECTED_NAME" ]] && exit 1

SELECTED=$(find "$WALLPAPER_DIR" -type f -name "$SELECTED_NAME" | head -n 1)

# Start swww daemon if not running
pgrep -x swww-daemon >/dev/null || { swww-daemon & sleep 0.5; }

# Set wallpaper with swww
swww img "$SELECTED" --transition-type any --transition-duration 1

# Save symlink
ln -sf "$SELECTED" "$SYMLINK"

notify-send "Wallpaper Switcher" "Wallpaper set: $(basename "$SELECTED")" -t 2000
echo "✅ Wallpaper set: $SELECTED"
