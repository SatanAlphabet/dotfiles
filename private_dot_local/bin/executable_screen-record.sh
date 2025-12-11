#!/usr/bin/env bash

video="${XDG_VIDEOS_DIR:-$HOME/Videos}/$(date "+%Y-%m-%d %H-%M-%S")"
rec_args=(-c mp4 -o "$video")

if ! pgrep -f gpu-screen-recorder >/dev/null; then
  case "$1" in
  region)
    region="$(slurp -f "%wx%h+%x+%y")"
    if [ -z "$region" ]; then
      echo "screen-record.sh: no region selected."
      exit 1
    fi
    rec_args+=(-w region -region "$region")
    ;;
  screen | *)
    rec_args+=(-w screen)
    ;;
  esac
  gpu-screen-recorder "${rec_args[@]}" >/dev/null 2>&1 &
  echo "screen-record.sh: started recording"
else
  pkill -SIGINT -f gpu-screen-recorder
  echo "screen-record.sh: stopped recording"
  notify-send -a "Screen Recorder" "Screen Recorder" "Stopped video recording..." -e -t 3000 -i camera-video-symbolic
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+6 "waybar"
