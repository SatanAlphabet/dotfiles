#!/usr/bin/env bash

rofi_running=$(pidof rofi 2>/dev/null)

if [ -n "$rofi_running" ]; then
  pkill -SIGUSR2 rofi
else
  if [[ -n $1 ]]; then
    rofi -theme "$1" -show
  else
    rofi -theme style_3 -show
  fi
fi
