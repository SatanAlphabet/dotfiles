#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
if [ $current_theme = "'prefer-dark'" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Light'
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-light"'
  notify-send -e -t 3000 "Switched to light mode"
elif [ $current_theme = "'prefer-light'" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
  dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
  notify-send -e -t 3000 "Switched to dark mode"
fi
