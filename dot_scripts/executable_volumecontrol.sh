#!/usr/bin/env bash

case "$1" in
+)
  pactl set-sink-volume @DEFAULT_SINK@ +"${2}"%
  ;;
-)
  pactl set-sink-volume @DEFAULT_SINK@ -"${2}"%
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
  ;;
unmute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  ;;
toggle-mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  ;;
*)
  exit 1
  ;;
esac

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d\n", $2*100}')"%"
mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%s\n", $3}')
priority="normal"

if [[ "$mute_status" == "[MUTED]" ]]; then
  volume="$volume"" (Muted)"
  priority="low"
fi

notify-send -t 2000 -a "volume" -u "$priority" -r 2 -e "Volume level: ${volume}" -h int:value:"$volume"
