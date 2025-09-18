#!/usr/bin/env bash

rofi_running=$(pidof rofi)

if [ "$rofi_running" -ne 0 ]; then
  pkill rofi
else
  rofi -modi calc -show calc -no-show-match -no-sort -theme style_4 \
    -theme-str "entry { placeholder: \"Calculate...\"; }" \
    -calc-command "echo -n '{result}' | wl-copy && notify-send \"Result copied to clipboard...\" -e" \
    -theme-str "configuration { calc { hint-welcome: \" Ctrl-Enter to copy current result to clipboard.\"; } } " \
    -theme-str "mode-switcher { enabled: false; } "
fi
