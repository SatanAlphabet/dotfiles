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

idx=$(niri msg -j keyboard-layouts | jq '.current_idx')
current_layout=$(niri msg -j keyboard-layouts | jq .names["$idx"] | sed 's/"//g')

notify-send -a "keyboard-layout" -r 1 -e -t 2000 "Current layout: $current_layout"
