#!/usr/bin/env bash
status=$(playerctl status 2>/dev/null)

if [[ -z ${status} ]]; then
  notify-send "No media found..." -e -r 4 -t 1500 -u low
  exit 0
fi

media_data="$(playerctl metadata title)"
current_pos=$(printf "%0.f" "$(playerctl position)")
media_length=$(playerctl metadata mpris:length)

media_progress=$((current_pos * 100 * 1000000 / media_length))

## WIP
# length_sec=$((media_length / 1000000))
# length_min=$((media_length / 1000000 / 60))
# parsed_sec=$((length_sec - (length_min * 60)))
# pos_min=$((current_pos / 60))
# pos_sec=$((current_pos - (pos_min * 60)))
# if [[ $pos_sec -lt 10 ]]; then
#   pos_sec="0${pos_sec}"
# fi
# if [[ $parsed_sec -lt 10 ]]; then
#   parsed_sec="0${parsed_sec}"
# fi

if [[ "$1" = 'next' ]]; then
  playerctl next 2>/dev/null
  notify-send -e -r 4 -t 1500 'Playing next track...'
elif [[ "$1" = 'prev' ]]; then
  playerctl previous 2>/dev/null
  notify-send -e -r 4 -t 1500 'Playing previous track...'
elif [[ "$1" = 'toggle' ]]; then
  playerctl play-pause
  if [[ ${status} = 'Playing' ]]; then
    notify-send -e -r 4 -t 1500 -u low "Paused media [ 󰏤 ]" "$media_data" -h int:value:"$media_progress"
  elif [[ ${status} = 'Paused' ]]; then
    notify-send -e -r 4 -t 1500 "Playing media [ 󰝚 ]" "$media_data" -h int:value:"$media_progress"
  fi
else
  echo "Invalid command (Available commands are \"prev\", \"next\" and \"toggle\")."
fi
