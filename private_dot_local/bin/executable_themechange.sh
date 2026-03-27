#!/bin/bash

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

switch_to_light_mode() {
  if [ "$(matugen -V | awk '{printf $2}' | cut -d. -f1)" -ge 4 ]; then
    matugen image "$1" -m light --source-color-index 0
  else
    matugen image "$1" -m light
  fi
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  notify-send -e -t 3000 "System Theme" "Switched to <b>light</b> mode" -i weather-clear-symbolic
}

switch_to_dark_mode() {
  if [ "$(matugen -V | awk '{printf $2}' | cut -d. -f1)" -ge 4 ]; then
    matugen image "$1" -m dark --source-color-index 0
  else
    matugen image "$1" -m dark
  fi
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  notify-send -e -t 3000 "System Theme" "Switched to <b>dark</b> mode" -i weather-clear-night-symbolic
}

change_theme() {

  if [ -n "$1" ]; then
    img="$1"
  else
    echo "WARNING: No image provided. Using current wallpaper from waypaper..." >&2
    img="$(waypaper --list | jq -r '.[].wallpaper')"
  fi

  if [ ! -f "$img" ]; then
    echo "Error: image '$img' was not found."
    exit 1
  fi

  if [[ "$current_theme" != "'prefer-dark'" && "$current_theme" != "'prefer-light'" ]]; then
    echo "Invalid color-scheme found. Falling back to light mode..."
    switch_to_light_mode "$img"
  fi

  if [ "$current_theme" = "'prefer-dark'" ]; then
    switch_to_light_mode "$img"
  elif [ "$current_theme" = "'prefer-light'" ]; then
    switch_to_dark_mode "$img"
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
