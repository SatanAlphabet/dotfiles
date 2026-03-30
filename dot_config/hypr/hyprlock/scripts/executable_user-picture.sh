#!/usr/bin/env bash

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hyprlock"
cache_img="$cache_dir/user-icon"

if [ -e "$HOME/.face" ]; then
  user_img="$HOME/.face"
elif [ -e "$HOME/.face.icon" ]; then
  user_img="$HOME/.face.icon"
else
  user_img="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprlock/assets/default-icon"
fi

[ ! -d "$cache_dir" ] && mkdir -p "$cache_dir"
[ ! -e "$cache_img" ] && ln -s "$user_img" "$cache_img"
echo "$cache_img"
