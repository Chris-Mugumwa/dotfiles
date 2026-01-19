#!/bin/bash
# Simple calendar popup using rofi

cal | rofi -dmenu -p "📅" -theme-str 'window {width: 300px;}'
