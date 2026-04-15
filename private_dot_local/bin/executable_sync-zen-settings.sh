#!/usr/bin/env bash

file="$1"

style_path="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/zen-browser"
[ -d "$HOME/.zen" ] && zen_dir="$HOME/.zen" || zen_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zen"
zen_settings="$zen_dir/installs.ini"
zen_profile="$(awk -F "=" "/Default/"'{printf $2}' "$zen_settings")"
if [[ -n "$zen_profile" && -d "$zen_dir/$zen_profile" ]]; then
  chrome_path="$zen_dir/$zen_profile/chrome"
  if [ "$(readlink -f "$chrome_path/$file")" != "$style_path/$file" ]; then
    ln -sf "$style_path/$file" "$chrome_path/$file"
  fi
fi
