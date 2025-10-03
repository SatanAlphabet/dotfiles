#!/usr/bin/env bash
status=$(playerctl status 2>/dev/null)

if [[ -z ${status} ]]; then
  notify-send "No meadia found..." -e -r 4 -t 1500
  exit 0
fi

media_data="$(playerctl metadata title)"
current_pos=$(printf "%0.f" $(playerctl position))
media_length=$(playerctl metadata mpris:length)

media_length=$((media_length / 60 / 1000 / 1000))
media_progress=$((current_pos / 60 * 100 / media_length))

if [[ "$1" = 'next' ]]; then
  playerctl next 2>/dev/null
  notify-send -e -r 4 -t 1500 'Playing next track...'
elif [[ "$1" = 'prev' ]]; then
  playerctl previous 2>/dev/null
  notify-send -e -r 4 -t 1500 'Playing previous track...'
elif [[ "$1" = 'toggle' ]]; then
  playerctl play-pause
  if [[ ${status} = 'Playing' ]]; then
    notify-send -e -r 4 -t 1500 "Paused media [ 󰏤 ]" "$media_data" -h int:value:"$media_progress"
  elif [[ ${status} = 'Paused' ]]; then
    notify-send -e -r 4 -t 1500 "Playing media [ 󰝚 ]" "$media_data" -h int:value:"$media_progress"
  fi
else
  echo "Invalid command (Available commands are \"prev\", \"next\" and \"toggle\")."
fi
