#!/usr/bin/env bash
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
blur_img="${cache_dir}/niri/landing/blur"
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ "$current_theme" = "'prefer-dark'" ]; then
  matugen image "$1" -c ~/.config/matugen/main.toml -m dark
elif [ "$current_theme" = "'prefer-light'" ]; then
  matugen image "$1" -c ~/.config/matugen/main.toml -m light
fi

cp -sf "$1" "${cache_dir}"/niri/landing/background
magick "$1" -blur 20x10 "${blur_img}"
# waypaper doesn't work properly with multiple swww-daemon instances
# swww img -n overview --transition-duration 2 -t fade "${blur_img}"
systemctl --user restart overview-blur.service
notify-send -e -r 2 -t 2000 "Wallpaper switch successful..." "$1"
