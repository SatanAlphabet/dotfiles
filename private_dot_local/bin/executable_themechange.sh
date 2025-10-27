#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
wallpaper=$(waypaper --list | jq -r '.[].wallpaper')

if [ "$current_theme" = "'prefer-dark'" ]; then

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  matugen image "${wallpaper}" -m light
  notify-send -e -t 3000 "Switched to light mode"

elif [ "$current_theme" = "'prefer-light'" ]; then

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  matugen image "${wallpaper}" -m dark
  notify-send -e -t 3000 "Switched to dark mode"

fi
