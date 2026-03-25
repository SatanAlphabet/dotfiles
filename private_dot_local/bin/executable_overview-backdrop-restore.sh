#!/usr/bin/env bash

# Workaround for https://codeberg.org/LGFae/awww/issues/521

for i in {1..10}; do
  echo "Setting overview backdrop image ($i)"
  if awww query -n overview; then
    blur_cache="${XDG_CACHE_HOME:-$HOME/.cache}/niri/overview"
    img_checksum="$(sha256sum "$(waypaper --list | jq -r '.[].wallpaper')" | awk '{print $1}')"
    cache_img="${blur_cache}"/"${img_checksum}"
    awww img "$cache_img" -n overview -t none
    break
  fi
  sleep 0.5
done
