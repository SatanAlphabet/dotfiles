#!/usr/bin/bash

case "$1" in
+)
  brightnessctl s +"${2}"%
  ;;
-)
  brightnessctl s "${2}"%-
  ;;
*)
  exit 1
  ;;
esac

cur_brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)

percent_brightness=$((cur_brightness * 100 / max_brightness))%

notif="Brightness level: ""${percent_brightness}"

notify-send -r 7 -t 800 -e "$notif"
