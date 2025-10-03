#!/usr/bin/env bash

case "$1" in
+)
  pactl set-sink-volume @DEFAULT_SINK@ +"${2}"%
  ;;
-)
  pactl set-sink-volume @DEFAULT_SINK@ -"${2}"%
  ;;
*)
  exit 1
  ;;
esac

# Get the volume level and convert it to a percentage
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d\n", $2*100}')

notify-send -t 2000 -a "volume" -r 2 -e "Volume level: ${volume}%" -h int:value:"$volume"
