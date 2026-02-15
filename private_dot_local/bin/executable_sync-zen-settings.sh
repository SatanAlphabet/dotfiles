#!/usr/bin/env bash

style_path="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/zen-browser"
[ -d "$HOME/.zen" ] && zen_dir="$HOME/.zen" || zen_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zen"
zen_settings="$zen_dir/installs.ini"
zen_profile="$(awk -F "=" "/Default/"'{printf $2}' "$zen_settings")"
if [[ -n "$zen_profile" && -d "$zen_dir/$zen_profile" ]]; then
  chrome_path="$zen_dir/$zen_profile/chrome"
  if [ "$(readlink -f "$chrome_path/userChrome.css")" != "$style_path/userChrome.css" ]; then
    ln -sf "$style_path/userChrome.css" "$chrome_path/userChrome.css"
  fi
  if [ "$(readlink -f "$chrome_path/userContent.css")" != "$style_path/userContent.css" ]; then
    ln -sf "$style_path/userContent.css" "$chrome_path/userContent.css"
  fi
fi
