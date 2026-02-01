#!/usr/bin/env bash
# Independent workspace switching per monitor
# DP-1 uses workspaces 1-5, HDMI-A-1 uses workspaces 11-15

action="$1"
num="$2"

focused=$(hyprctl activeworkspace -j | jq -r '.monitor')

if [[ "$focused" == "HDMI-A-1" ]]; then
    ws=$((num + 10))
    ws_min=11
    ws_max=15
else
    ws=$num
    ws_min=1
    ws_max=9
fi

case "$action" in
    switch)
        hyprctl dispatch workspace "$ws"
        ;;
    move)
        hyprctl dispatch movetoworkspace "$ws"
        ;;
    movesilent)
        hyprctl dispatch movetoworkspacesilent "$ws"
        ;;
    cycle)
        current=$(hyprctl activeworkspace -j | jq '.id')
        if [[ "$2" == "next" ]]; then
            next=$((current + 1))
            [[ $next -gt $ws_max ]] && next=$ws_min
        else
            next=$((current - 1))
            [[ $next -lt $ws_min ]] && next=$ws_max
        fi
        hyprctl dispatch workspace "$next"
        ;;
esac
