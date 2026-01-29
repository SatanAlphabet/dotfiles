#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

switch_to_light_mode() {
  matugen image "$1" -m light
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  notify-send -e -t 3000 "Switched to light mode..." -i weather-clear-symbolic
}

switch_to_dark_mode() {
  matugen image "$1" -m dark
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  notify-send -e -t 3000 "Switched to dark mode..." -i weather-clear-night-symbolic
}

change_theme() {

  if [ ! -f "$1" ]; then
    echo "Error: image '$1' was not found."
    exit 1
  fi

  if [[ "$current_theme" != "'prefer-dark'" && "$current_theme" != "'prefer-light'" ]]; then
    echo "Invalid color-scheme found. Falling back to light mode..."
    switch_to_light_mode "$1"
  fi

  if [ "$current_theme" = "'prefer-dark'" ]; then
    switch_to_light_mode "$1"
  elif [ "$current_theme" = "'prefer-light'" ]; then
    switch_to_dark_mode "$1"
  fi

}

while true; do
  case "$1" in
  -t | --theme)
    case "$2" in
    "dark")
      current_theme="'prefer-light'"
      ;;
    "light")
      current_theme="'prefer-dark'"
      ;;
    *)
      echo "Invalid options: (Valid options are 'dark' and 'light')"
      exit 1
      ;;
    esac
    shift 2
    ;;
  *)
    change_theme "$1"
    break
    ;;
  esac
done
