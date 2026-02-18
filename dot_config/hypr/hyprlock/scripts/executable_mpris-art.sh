#!/usr/bin/env bash

thumb_path="${XDG_CACHE_HOME:-$HOME/.cache}/mpris"
thumbnail="$(playerctl metadata mpris:artUrl)"
status="$(playerctl status)"

[ -d "$thumb_path" ] || mkdir -p "$thumb_path"

generate_thumbnail() {
  if [[ "$thumbnail" != "$(cat "$thumb_path/thumbnail.lnk")" ]]; then
    echo "$thumbnail" >"$thumb_path/thumbnail.lnk"
    curl -Lso "$thumb_path/thumbnail" "$thumbnail"
    mogrify -resize 200x200^ -gravity center -extent 200x200 "$thumb_path/thumbnail"
  fi
}

if [[ "$status" = "Playing" || "$status" = "Paused" ]]; then
  generate_thumbnail
  echo "$thumb_path/thumbnail"
else
  rm "$thumb_path/thumbnail" "$thumb_path/thumbnail.lnk"
  echo "$1"
fi
