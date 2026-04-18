#!/usr/bin/env bash
# Start swayidle with lock / monitor-off / sleep-lock timers.
# Spawned by niri config.kdl.

pgrep -x swayidle >/dev/null && exit 0

exec swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 420 'niri msg action power-off-monitors' \
        resume 'niri msg action power-on-monitors' \
    before-sleep 'swaylock -f'
