#!/usr/bin/env bash

pactl "$@"

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d\n", $2*100}')"%"
mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%s\n", $3}')
priority="normal"

if [ "$volume" -le 35 ]; then
  audio_icon="audio-volume-low"
elif [ "$volume" -le 70 ]; then
  audio_icon="audio-volume-medium"
else
  audio_icon="audio-volume-high"
fi

volume_text="<b>$volume</b>"

if [[ "$mute_status" == "[MUTED]" ]]; then
  volume_text="Muted"
  priority="low"
  audio_icon="audio-volume-muted"
fi

notify-send -t 2000 -a "volume" -u "$priority" -r 2 -e "Audio" "Volume level: <b>${volume_text}</b>" -h int:value:"$volume" -i "$audio_icon"
