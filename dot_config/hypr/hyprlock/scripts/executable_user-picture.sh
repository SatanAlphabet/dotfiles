#!/usr/bin/env bash

if [ -e "$HOME/.face" ]; then
  echo "$HOME/.face"
elif [ -e "$HOME/.face.icon" ]; then
  echo "$HOME/.face.icon"
else
  echo "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprlock/assets/default-icon"
fi
