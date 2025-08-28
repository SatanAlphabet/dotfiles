#!/usr/bin/env bash

rofi_running=$(pidof rofi)

if [ "$rofi_running" -ne 0 ]; then
  pkill rofi
else
  rofi -theme style_3 -show
fi
