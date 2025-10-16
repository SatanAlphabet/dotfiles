#!/usr/bin/env bash

media_check() {
  status=$(playerctl status 2>/dev/null)
  if [[ -z ${status} ]]; then
    return 1
  else
    return 0
  fi
}

media_progress() {
  local current_pos
  local media_length
  current_pos=$(printf "%0.f" "$(playerctl position)")
  media_length=$(playerctl metadata mpris:length)
  local current_progress=$((current_pos * 100 * 1000000 / media_length))
  echo "$current_progress"
}

no_media_notif() {
  notify-send "No media found..." -e -r 1 -t 1500 -u low
}

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

case "$1" in
'next')
  if media_check -eq 0; then
    playerctl next 2>/dev/null
    notify-send -e -r 1 -t 1500 'Playing next track...'
  else
    no_media_notif
  fi
  ;;
'prev')
  if media_check -eq 0; then
    playerctl previous 2>/dev/null
    notify-send -e -r 1 -t 1500 'Playing previous track...'
  else
    no_media_notif
  fi
  ;;
'toggle')
  if media_check -eq 0; then
    media_data="$(playerctl metadata title)"
    playerctl play-pause
    if [[ ${status} = 'Playing' ]]; then
      notify-send -e -r 1 -t 1500 "Paused media [ 󰏤 ]" "$media_data" -h int:value:"$(media_progress)"
    elif [[ ${status} = 'Paused' ]]; then
      notify-send -e -r 1 -t 1500 "Playing media [ 󰝚 ]" "$media_data" -h int:value:"$(media_progress)"
    else
      no_media_notif
    fi
  fi
  ;;
*)
  echo "Invalid command (Available commands are \"prev\", \"next\" and \"toggle\")."
  ;;
esac
