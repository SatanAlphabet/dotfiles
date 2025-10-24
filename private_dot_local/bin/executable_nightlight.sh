#!/usr/bin/bash

temp=${1:-4000}

if pgrep -x wlsunset >/dev/null; then
  pkill wlsunset && notify-send -a "Night Light" -e -t 2000 -r 1 "Night Light Disabled..."
else
  wlsunset -t "$temp" >/dev/null 2>&1 &
  notify-send -a "Night Light" -e -t 2000 -r 1 "Night Light Enabled..." "Temperature: ${temp}K"
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+8 "waybar"
