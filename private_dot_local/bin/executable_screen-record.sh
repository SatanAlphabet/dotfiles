#!/usr/bin/env bash

if ! pgrep -f gpu-screen-recorder >/dev/null; then
  gpu-screen-recorder -w screen -o "$HOME/Videos/$(date "+%Y-%m-%d %H-%M-%S").mp4" >/dev/null 2>&1 &
  echo "screen-recorder.sh: starting screen recording"
else
  pkill -SIGINT -f gpu-screen-recorder
  echo "screen-recorder.sh: stopping recording"
  notify-send -a "Screen Recorder" "Screen Recorder" "Stopped video recording..." -e -t 3000 -i camera-video-symbolic
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+6 "waybar"
