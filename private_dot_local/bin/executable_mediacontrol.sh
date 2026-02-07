#!/usr/bin/env bash

media_progress() {
  local current_pos
  local media_length
  current_pos=$(printf "%0.f" "$(playerctl position)")
  media_length=$(playerctl metadata mpris:length)

  if [ $media_length -le 0 ]; then
    echo 0
  else
    echo $((current_pos * 100 * 1000000 / media_length))
  fi
}

usage() {
  cat <<USAGE
Options:
  play: Play current media
  pause: Pause current media
  toggle: Toggle play/pause on current media
  prev: Switch to previous track
  next: Switch to next track
USAGE
}

send_playing_notif() {
  notify-send -e -r 1 -t 1500 "Paused media..." "$(playerctl metadata title)" -h int:value:"$(media_progress)" -i media-playback-pause
}

send_paused_notif() {
  notify-send -e -r 1 -t 1500 "Playing media..." "$(playerctl metadata title)" -h int:value:"$(media_progress)" -i media-playback-start
}

[ $# -ne 1 ] && {
  usage
  exit 1
}

if [ -z "$(playerctl status 2>/dev/null)" ]; then
  notify-send "No media found..." -e -r 1 -t 1500 -u low
  exit 0
fi

case "$1" in
'next')
  playerctl next 2>/dev/null
  notify-send -e -r 1 -t 1500 'Playing next track...' -i media-skip-forward
  ;;
'prev')
  playerctl previous 2>/dev/null
  notify-send -e -r 1 -t 1500 'Playing previous track...' -i media-skip-backward
  ;;
'play')
  playerctl play 2>/dev/null
  send_playing_notif
  ;;
'pause')
  playerctl pause 2>/dev/null
  send_paused_notif
  ;;
'toggle')
  playerctl play-pause 2>/dev/null
  status="$(playerctl status 2>/dev/null)"
  if [ "$status" = 'Playing' ]; then
    send_playing_notif
  elif [ "$status" = 'Paused' ]; then
    send_paused_notif
  fi
  ;;
*)
  usage
  exit 1
  ;;
esac
