#!/usr/bin/bash

temp=${1:-4000}

if pgrep -x wlsunset >/dev/null; then
  pkill wlsunset && notify-send -a "Night Light" -e -t 2000 -r 1 "Night Light" "Night light is <b>disabled</b>" -i night-light-symbolic
else
  wlsunset -S 00:00 -s 00:00 -t "$temp" >/dev/null 2>&1 &
  notify-send -a "Night Light" -e -t 2000 -r 1 "Night Light " "Enabled night light (<b>${temp}K</b>)" -i night-light-symbolic
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+8 "waybar"
