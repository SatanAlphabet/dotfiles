#!/usr/bin/env bash

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
style_path="$config_dir/styles"

_change_rofi_style() {
  if [[ ! -f "$style_path/$1.rasi" ]]; then
    echo -e "Error: Rofi theme not found." >&2
    exit 1
  fi

  ln -sf "$style_path/$1.rasi" "$config_dir/current-theme.rasi" && echo "Switched rofi theme to $1"
}

_select_from_rofi() {
  mapfile -t files < <(
    find "$style_path" -maxdepth 1 -type f,l -name "*.rasi" -print0 | xargs -0 -I{} basename "{}" .rasi | sort
  )

  if [ -n "$(pgrep rofi)" ]; then
    pkill rofi
    exit
  fi

  selected_presets=$(
    printf "%s\n" "${files[@]}" | rofi -dmenu \
      -theme-str 'entry {placeholder: "Select rofi presets...";}' \
      -theme-str 'mode-switcher {enabled: false;}' \
      -theme-str 'configuration {show-icons: false;}'
  )
  if [ -n "$selected_presets" ]; then
    echo "$selected_presets"
  else
    return 1
  fi
}

if [ -n "$1" ]; then
  _change_rofi_style "$1"
else
  _change_rofi_style "$(_select_from_rofi)"
fi
