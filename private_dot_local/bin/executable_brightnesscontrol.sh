#!/usr/bin/bash

brightnessctl "$@" >/dev/null

cur_brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)

percent_brightness=$((cur_brightness * 100 / max_brightness))

notif="Brightness level: $percent_brightness%"

notify-send -r 1 -t 2000 -e "$notif" -h int:value:"$percent_brightness" -i display-brightness-symbolic
