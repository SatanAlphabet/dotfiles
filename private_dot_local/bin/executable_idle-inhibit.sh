#!/usr/bin/env bash

if pgrep -f "systemd-inhibit --what=idle sleep infinity" >/dev/null; then
  pkill -f "systemd-inhibit --what=idle sleep infinity" && notify-send -a "Idle Inhibitor" -e -t 2000 -r 1 "Inhibitor" "Idle Inhibitor <b>disabled.</b>" -u low
else
  systemd-inhibit --what=idle sleep infinity &
  notify-send -a "Idle Inhibitor" -e -t 2000 -r 1 "Inhibitor" "Idle Inhibitor <b>enabled.</b>"
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+7 "waybar"
