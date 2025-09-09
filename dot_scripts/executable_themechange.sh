#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
wallpaper=$(waypaper --list | jq '.[].wallpaper' | sed 's/"//g')

if [ $current_theme = "'prefer-dark'" ]; then

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  matugen image ${wallpaper} -c ~/.config/matugen/main.toml -m light

  #sed -i 's/dark/light/' ~/.config/waybar/style.css
  #sed -i 's/dark/light/' ~/.config/rofi/colors.rasi
  #sed -i 's/dark/light/' ~/.config/wlogout/style_1.css
  #sed -i 's/dark.css/light.css/' ~/.config/swaync/style.css

  notify-send -e -t 3000 "Switched to light mode"

elif [ $current_theme = "'prefer-light'" ]; then

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  matugen image ${wallpaper} -c ~/.config/matugen/main.toml -m dark

  #sed -i 's/light/dark/' ~/.config/rofi/colors.rasi
  #sed -i 's/light/dark/' ~/.config/wlogout/style_1.css
  #sed -i 's/light.css/dark.css/' ~/.config/swaync/style.css

  notify-send -e -t 3000 "Switched to dark mode"

fi
