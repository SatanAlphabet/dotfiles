#!/usr/bin/env bash

video="${XDG_VIDEOS_DIR:-$HOME/Videos}/$(date "+%Y-%m-%d %H-%M-%S").mp4"
rec_args=(-a default_output -o "$video")
recording_lockfile="/tmp/screen-recording"
recording_proc="$(pgrep -f gpu-screen-recorder)"

if [[ ! -e "$recording_lockfile" && "$recording_proc" ]]; then
  pkill -SIGINT -f gpu-screen-recorder || true
fi

if [[ -e "$recording_lockfile" && ! "$recording_proc" ]]; then
  rm "$recording_lockfile" || true
fi

if [ ! -e "$recording_lockfile" ]; then
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
  touch "$recording_lockfile"
  echo "screen-record.sh: started recording"
else
  pkill -SIGINT -f gpu-screen-recorder || true
  rm "$recording_lockfile" || true
  echo "screen-record.sh: stopped recording"
  notify-send -a "Screen Recorder" "Screen Recorder" "Stopped video recording..." -e -t 3000 -i camera-video-symbolic
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+6 "waybar"
