#!/usr/bin/env bash

style_path="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/zen-browser"
zen_settings="$HOME/.zen/installs.ini"
zen_profile="$(awk -F "=" "/Default/"'{printf $2}' "$zen_settings")"
if [[ -n "$zen_profile" && -d "$HOME/.zen/$zen_profile" ]]; then
  chrome_path="$HOME/.zen/$zen_profile/chrome"
  if [ "$(readlink -f "$chrome_path/userChrome.css")" != "$style_path/userChrome.css" ]; then
    ln -sf "$style_path/userChrome.css" "$chrome_path/userChrome.css"
  fi
  if [ "$(readlink -f "$chrome_path/userContent.css")" != "$style_path/userContent.css" ]; then
    ln -sf "$style_path/userContent.css" "$chrome_path/userContent.css"
  fi
fi
