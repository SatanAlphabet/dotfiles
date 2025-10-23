#!/usr/bin/env bash

if [[ -n "$(pgrep -x rofi)" ]]; then
  pkill rofi
else
  if [[ -n $1 ]]; then
    rofi -theme "$1" -show
  else
    rofi -show
  fi
fi
