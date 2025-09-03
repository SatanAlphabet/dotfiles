#!/bin/sh

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

notify-send -t 1000 -a ${0##*/} -r 2 -e "Volume level: ${volume}%"
