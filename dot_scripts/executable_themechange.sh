#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
if [ $current_theme = "'prefer-dark'" ]; then
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-light"'
  # gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Light'
  notify-send -e -t 3000 "Switched to light mode"
elif [ $current_theme = "'prefer-light'" ]; then
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
  # gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
  notify-send -e -t 3000 "Switched to dark mode"
fi
