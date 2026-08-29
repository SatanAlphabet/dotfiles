#!/usr/bin/env bash

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
landing_cache="${cache_dir}/niri/landing"
blur_cache="${cache_dir}/niri/overview"
blur_img="${landing_cache}/blur"
waypaper_config=${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini

_parse_waypaper_config() {
  local output
  output="$(awk -F "=" "/$1/"'{printf $2}' "$waypaper_config" | tr -d ' ')"
  [ -n "$output" ] && echo "$output" || return 1
}

# waypaper config still use swww_*, but awww_* support is added just in case
_get_awww_args() {
  type="$(_parse_waypaper_config "swww_transition_type" || _parse_waypaper_config "awww_transition_type")"
  duration="$(_parse_waypaper_config "swww_transition_duration" || _parse_waypaper_config "awww_transition_duration")"
  step="$(_parse_waypaper_config "swww_transition_step" || _parse_waypaper_config "awww_transition_step")"
  angle="$(_parse_waypaper_config "swww_transition_angle" || _parse_waypaper_config "awww_transition_angle")"
  fps="$(_parse_waypaper_config "swww_transition_fps" || _parse_waypaper_config "awww_transition_fps")"
  [ -n "$type" ] && awww_args+=("--transition-type" "$type")
  [ -n "$duration" ] && awww_args+=("--transition-duration" "$duration")
  [ -n "$step" ] && awww_args+=("--transition-step" "$step")
  [ -n "$angle" ] && awww_args+=("--transition-angle" "$angle")
  [ -n "$fps" ] && awww_args+=("--transition-fps" "$fps")
}

switch_wallpaper() {

  local wallpaper="$1" theme="$2" scheme="$3"

  if [[ ! -f "$wallpaper" ]]; then
    echo "ERROR: $wallpaper is not a valid file" >&2
    exit 1
  fi

  [ ! -d "$cache_dir/niri/landing" ] && mkdir -p "$cache_dir/niri/landing"
  if [[ "$wallpaper" != "$(readlink -f "$cache_dir/niri/landing/background")" ]]; then

    # fallback to prefer-light if color-scheme is default
    if [ "$theme" = "'default'" ]; then
      gsettings set org.gnome.desktop.interface color-scheme prefer-light
      theme="'prefer-light'"
    fi

    if [ "$(matugen -V | awk '{printf $2}' | cut -d. -f1)" -ge 4 ]; then
      matugen image "$wallpaper" -m "$(grep -oe 'light' -oe 'dark' -oe 'smart' <<<"$theme")" --source-color-index 0 -t "$scheme" >/dev/null 2>&1 &
    else
      matugen image "$wallpaper" -m "$(grep -oe 'light' -oe 'dark' <<<"$theme")" -t "$scheme" >/dev/null 2>&1 &
    fi

    [ ! -d "$landing_cache" ] && mkdir -p "$landing_cache"
    ln -sf "$wallpaper" "$landing_cache/background"

    img_checksum="$(sha256sum "$wallpaper" | awk '{print $1}')"
    cache_img="${blur_cache}"/"${img_checksum}"
    [ ! -d "$blur_cache" ] && mkdir -p "$blur_cache"
    if [[ ! -e "$cache_img" || "$(basename "$cache_img")" != "$img_checksum" ]]; then
      magick "$wallpaper" -blur 30x10 "$cache_img"
    fi
    ln -sf "$cache_img" "$blur_img"

    notify-send -i "$wallpaper" -e -r 2 -t 2000 "Wallpaper" "Current Wallpaper: <b>$(basename "$wallpaper")</b>"
  else
    echo "Same wallpaper detected. Skipping matugen & caching..."
  fi

  if [[ ! "$SKIP_OVERVIEW" || "$FORCE_RESTART_OVERVIEW" ]]; then
    if [ ! "$FORCE_RESTART_OVERVIEW" ]; then
      systemctl --user is-active overview-backdrop >/dev/null || systemctl --user restart overview-backdrop.service
    else
      systemctl --user restart overview-backdrop.service
    fi
    _get_awww_args
    awww img -n overview "${awww_args[@]}" "$blur_img"
  else
    echo "Skipping overview reloading..."
  fi

}

theme=$(gsettings get org.gnome.desktop.interface color-scheme)
scheme=${scheme:-"scheme-tonal-spot"}

while true; do
  case "$1" in
  --skip-overview | -Os)
    SKIP_OVERVIEW=1
    shift
    ;;
  --force | -Of)
    FORCE_RESTART_OVERVIEW=1
    shift
    ;;
  --scheme | -s)
    if [ -z "$2" ]; then
      echo "Error: no scheme type given" >&2
      exit 1
    fi
    scheme="scheme-$2"
    shift 2
    ;;
  --smart | -S)
    theme="smart"
    shift
    ;;
  *)
    if [ -z "$1" ]; then
      echo "Error: no wallpaper path provided" >&2
      exit 1
    fi
    echo "Switching wallpaper: $1"
    switch_wallpaper "$1" "$theme" "$scheme"
    break
    ;;
  esac
done
