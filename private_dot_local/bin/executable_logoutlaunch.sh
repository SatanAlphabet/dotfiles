#!/usr/bin/env bash

#// Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
  pkill -x "wlogout"
  exit 0
fi

config_path="${XDG_CONFIG_HOME:-$HOME/.config}"
template="${config_path}/wlogout/style.css"

#// detect monitor res
get_output() {
  local outputs current_mode current_output current_height current_width
  outputs=$(niri msg -j outputs | jq '.[]')
  current_mode=$(echo "${outputs}" | jq '.current_mode')
  current_output=$(echo "${outputs}" | jq .modes["${current_mode}"])

  current_height=$(echo "${current_output}" | jq '.height')
  current_width=$(echo "${current_output}" | jq '.width')

  case "$1" in
  width)
    echo "${current_width}"
    ;;
  height)
    echo "${current_height}"
    ;;
  *)
    echo "Invalid parameter (use 'width' or 'height')."
    return 1
    ;;
  esac
}

#// scale config layout and style
y_mon=$(get_output height)
wlColms=6
export mgn=$((y_mon / 5))
export hvr=$((y_mon / 6))

if [ "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-dark'" ]; then
  export BtnCol="white"
else
  export BtnCol="black"
fi

#// eval border radius
border="4"
export active_rad=$((border * 5))
export button_rad=$((border * 8))

#// eval config files
wlStyle="$(envsubst <"${template}")"

#// launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --css <(echo "${wlStyle}") --protocol layer-shell
