#!/bin/sh

notify-send -t 999999 -r 2 -e -u low "Picking color..."
color=$(niri msg pick-color | awk '$1 == "Hex:" { printf "%s", $2 }')

if [ -n "$color" ]; then
  wl-copy $color
  notify-send -e -r 2 -t 5000 "Copied color: ""${color}"
else
  notify-send -t 2000 -e -r 2 -u low "No color picked."
fi
