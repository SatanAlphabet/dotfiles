#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ $current_theme = "'prefer-dark'" ]; then

  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Light'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'

  sed -i 's/dark/light/' ~/.config/waybar/style.css
  sed -i 's/dark/light/' ~/.config/rofi/colors.rasi
  sed -i 's/dark/light/' ~/.config/wlogout/style_1.css
  sed -i 's/dark.css/light.css/' ~/.config/swaync/style.css

  cat ~/.config/cava/themes/gruv-mat-light >~/.config/cava/config
  pkill -SIGUSR1 cava

  swaync-client -rs

  notify-send -e -t 3000 "Switched to light mode"

elif [ $current_theme = "'prefer-light'" ]; then

  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  sed -i 's/light/dark/' ~/.config/waybar/style.css
  sed -i 's/light/dark/' ~/.config/rofi/colors.rasi
  sed -i 's/light/dark/' ~/.config/wlogout/style_1.css
  sed -i 's/light.css/dark.css/' ~/.config/swaync/style.css

  cat ~/.config/cava/themes/gruv-mat-dark >~/.config/cava/config
  pkill -SIGUSR1 cava

  swaync-client -rs

  notify-send -e -t 3000 "Switched to dark mode"

fi
