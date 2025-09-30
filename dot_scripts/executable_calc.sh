#!/usr/bin/env bash

rofi_running=$(pidof rofi)
rofi_style="style_4"
if [[ -n "$1" ]]; then
  rofi_style="$1"
fi

if [ -n "$rofi_running" ]; then
  pkill -SIGUSR2 rofi
else
  rofi -modi calc -show calc -no-show-match -no-sort -theme "${rofi_style}" \
    -theme-str "entry { placeholder: \"Calculate...\"; }" \
    -calc-command "echo -n '{result}' | wl-copy && notify-send \"Result copied to clipboard...\" -e" \
    -theme-str "configuration { calc { hint-welcome: \" Ctrl-Enter to copy current result to clipboard.\"; } } " \
    -theme-str "mode-switcher { enabled: false; } "
fi
