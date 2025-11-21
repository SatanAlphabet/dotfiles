#!/usr/bin/env bash
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
blur_img="${cache_dir}/niri/landing/blur"
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [[ ! -f "$1" ]]; then
  echo "ERROR: $1 is not a valid file" >&2
  exit 1
fi

if [[ "$1" != "$(readlink -f "$cache_dir/niri/landing/background")" ]]; then
  if [ "$current_theme" = "'prefer-dark'" ]; then
    matugen image "$1" -m dark
  elif [ "$current_theme" = "'prefer-light'" ]; then
    matugen image "$1" -m light
  fi

  ln -sf "$1" "${cache_dir}"/niri/landing/background
  magick "$1" -blur 20x10 "${blur_img}"
  # waypaper doesn't work properly with multiple swww-daemon instances
  # swww img -n overview --transition-duration 2 -t fade "${blur_img}"
  notify-send -e -r 2 -t 2000 "Wallpaper switch successful..." "Current Wallpaper: $(basename "$1")"
else
  echo "Same wallpaper detected. Skipping matugen & caching..."
fi

systemctl --user restart overview-blur.service
