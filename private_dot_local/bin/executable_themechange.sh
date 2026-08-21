#!/bin/bash

current_theme=$(gsettings get org.gnome.desktop.interface color-scheme | grep -oe 'light' -oe 'dark')

switch_to_light_mode() {
  if [ "$(matugen -V | awk '{printf $2}' | cut -d. -f1)" -ge 4 ]; then
    matugen image "$1" -m light --source-color-index 0 -t "$scheme"
  else
    matugen image "$1" -m light
  fi
  notify-send -e -t 3000 "System Theme" "Switched to <b>light</b> mode" -i weather-clear-symbolic
}

switch_to_dark_mode() {
  if [ "$(matugen -V | awk '{printf $2}' | cut -d. -f1)" -ge 4 ]; then
    matugen image "$1" -m dark --source-color-index 0 -t "$scheme"
  else
    matugen image "$1" -m dark
  fi
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

  if [ "$current_theme" = "dark" ]; then
    switch_to_light_mode "$img"
  elif [ "$current_theme" = "light" ]; then
    switch_to_dark_mode "$img"
  else
    echo "Invalid color-scheme found. Falling back to light mode..."
    switch_to_light_mode "$img"
  fi

}

while true; do
  case "$1" in
  -t | --theme)
    case "$2" in
    "dark")
      current_theme="light"
      ;;
    "light")
      current_theme="dark"
      ;;
    *)
      echo "Invalid options: (Valid options are 'dark' and 'light')"
      exit 1
      ;;
    esac
    shift 2
    ;;
  -s | --scheme)
    if [ -z "$2" ]; then
      echo "Error: no scheme type given" >&2
      exit 1
    fi
    scheme="scheme-$2"
    shift 2
    ;;
  *)
    scheme="${scheme:-"scheme-tonal-spot"}"
    change_theme "$1"
    break
    ;;
  esac
done
