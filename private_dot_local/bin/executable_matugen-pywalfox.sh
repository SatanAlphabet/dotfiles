#!/usr/bin/env bash
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if ! pgrep -x firefox >/dev/null; then
  exit 1
fi

if [ "$current_theme" = "'prefer-dark'" ]; then
  pywalfox dark
elif [ "$current_theme" = "'prefer-light'" ]; then
  pywalfox light
fi

pywalfox update
