#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
if [ $current_theme = "'prefer-dark'" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Light'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  sed -i 's/dark/light/' ~/.config/waybar/style.css
  sed -i 's/dark/light/' ~/.config/rofi/colors.rasi
  notify-send -e -t 3000 "Switched to light mode"
elif [ $current_theme = "'prefer-light'" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  sed -i 's/light/dark/' ~/.config/waybar/style.css
  sed -i 's/light/dark/' ~/.config/rofi/colors.rasi
  notify-send -e -t 3000 "Switched to dark mode"
fi
