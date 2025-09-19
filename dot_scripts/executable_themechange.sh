#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
cache_dir="$HOME/.cache"

if [ $current_theme = "'prefer-dark'" ]; then

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  matugen image "${cache_dir}/noctalia/background" -c ~/.config/matugen/main.toml -m light

  #sed -i 's/dark/light/' ~/.config/waybar/style.css
  #sed -i 's/dark/light/' ~/.config/rofi/colors.rasi
  #sed -i 's/dark/light/' ~/.config/wlogout/style_1.css
  #sed -i 's/dark.css/light.css/' ~/.config/swaync/style.css

elif [ $current_theme = "'prefer-light'" ]; then

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  matugen image "${cache_dir}/noctalia/background" -c ~/.config/matugen/main.toml -m dark

  #sed -i 's/light/dark/' ~/.config/rofi/colors.rasi
  #sed -i 's/light/dark/' ~/.config/wlogout/style_1.css
  #sed -i 's/light.css/dark.css/' ~/.config/swaync/style.css

fi
