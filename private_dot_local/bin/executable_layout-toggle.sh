#!/usr/bin/env bash

case "$1" in
"prev")
  niri msg action switch-layout prev
  ;;
"next")
  niri msg action switch-layout next
  ;;
*)
  echo "Invalid options. (Supported options are \"next\" and \"prev\")." >&2
  exit 1
  ;;
esac

current_layout=$(niri msg -j keyboard-layouts | jq -r '.names[.current_idx]')
notify-send -a "keyboard-layout" -r 1 -e -t 2000 "Current layout: $current_layout" -i input-keyboard-symbolic
