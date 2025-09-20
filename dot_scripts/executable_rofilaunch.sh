#!/usr/bin/env bash

rofi_running=$(pidof rofi)
rofi_style=style_3
[[ -n "$1" ]]
rofi_style="$1"

if [ -n "$rofi_running" ]; then
  pkill -SIGUSR2 rofi
else
  if [[ -n $1 ]]; then
    rofi -theme "$1" -show
  else
    rofi -theme style_3 -show
  fi
fi
