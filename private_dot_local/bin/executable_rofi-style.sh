#!/usr/bin/env bash

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
new_preset="$1"

err() {
  echo -e "$1" >&2
}

if [[ $# -ne 1 ]]; then
  err "Error: Invalid number of arguments. (1 required, $# provided)"
  exit 1
fi

if [[ ! -f "$config_dir/rofi/styles/$new_preset.rasi" ]]; then
  err "Error: Rofi theme not found."
  exit 1
fi

ln -sf "$config_dir/rofi/styles/$new_preset.rasi" "$config_dir/rofi/current-theme.rasinc" && echo "Switched rofi theme to $1"
