#!/usr/bin/env bash

#// Check if wlogout is already running

if pgrep -x "wlogout" >/dev/null; then
  pkill -x "wlogout"
  exit 0
fi

#// set file variables

[ -n "${1}" ] && wlogoutStyle="${1}"
wlogoutStyle=1
confDir="${confDir:-$HOME/.config}"
wLayout="${confDir}/wlogout/layout_${wlogoutStyle}"
wlTmplt="${confDir}/wlogout/style_${wlogoutStyle}.css"
echo "wlogoutStyle: ${wlogoutStyle}"
echo "wLayout: ${wLayout}"
echo "wlTmplt: ${wlTmplt}"

if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ]; then
  echo "ERROR: Config ${wlogoutStyle} not found..."
  wlogoutStyle=1
  wLayout="${confDir}/wlogout/layout_${wlogoutStyle}"
  wlTmplt="${confDir}/wlogout/style_${wlogoutStyle}.css"
fi

#// detect monitor res

x_mon=16
y_mon=9
hypr_scale=1
#// scale config layout and style

case "${wlogoutStyle}" in
1)
  wlColms=6
  export mgn=$((y_mon * 28 / hypr_scale))
  export hvr=$((y_mon * 23 / hypr_scale))
  ;;
2)
  wlColms=2
  export x_mgn=$((x_mon * 35 / hypr_scale))
  export y_mgn=$((y_mon * 25 / hypr_scale))
  export x_hvr=$((x_mon * 32 / hypr_scale))
  export y_hvr=$((y_mon * 20 / hypr_scale))
  ;;
esac

#// scale font size

export fntSize=$((y_mon * 2 / 100))

#// detect wallpaper brightness

cacheDir="${HYDE_CACHE_HOME}"
dcol_mode="${dcol_mode:-dark}"
# shellcheck disable=SC1091
[ -f "${cacheDir}/wall.dcol" ] && source "${cacheDir}/wall.dcol"

current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
if [ "$current_theme" = "'prefer-dark'" ]; then
  export BtnCol="white"
else
  export BtnCol="black"
fi
#// eval hypr border radius

border="4"
export active_rad=$((border * 5))
export button_rad=$((border * 8))

#// eval config files

wlStyle="$(envsubst <"${wlTmplt}")"

#// launch wlogout

wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
