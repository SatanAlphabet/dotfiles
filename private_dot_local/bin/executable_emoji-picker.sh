#!/usr/bin/env bash

rofi_running=$(pidof rofi)
rofi_style="style_2"
if [[ -n "$1" ]]; then
  rofi_style="$1"
fi

if [[ -n "$rofi_running" ]]; then
  pkill -SIGUSR2 rofi
  exit 0
else
  rofi -modi emoji -show emoji \
    -theme-str "mode-switcher { enabled: false; }" \
    -theme-str "element-icon { enabled: false; }" \
    -kb-secondary-copy "" -kb-custom-1 Ctrl+c \
    -emoji-mode menu \
    -theme "$rofi_style" 2>/dev/null
fi
