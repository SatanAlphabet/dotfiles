#!/usr/bin/env bash

if [[ -n "$(pgrep -x rofi)" ]]; then
  pkill rofi
  exit 0
else
  rofi -modi emoji -show emoji \
    -theme-str "mode-switcher { enabled: false; }" \
    -theme-str "element-icon { enabled: false; }" \
    -kb-secondary-copy "" -kb-custom-1 Ctrl+c \
    -emoji-mode menu \
    -theme "${1:-"menu"}" 2>/dev/null
fi
