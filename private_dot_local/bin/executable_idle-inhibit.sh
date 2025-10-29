#!/usr/bin/env bash

if pgrep -f "systemd-inhibit --what=idle sleep infinity" >/dev/null; then
  pkill -f "systemd-inhibit --what=idle sleep infinity" && notify-send -a "Idle Inhibitor" -e -t 2000 -r 1 "Idle Inhibitor disabled..."
else
  systemd-inhibit --what=idle sleep infinity &
  notify-send -a "Idle Inhibitor" -e -t 2000 -r 1 "Idle Inhibitor enabled..."
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+7 "waybar"
