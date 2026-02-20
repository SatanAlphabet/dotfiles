#!/usr/bin/env bash
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
blur_img="${cache_dir}/niri/landing/blur"
blur_cache="${cache_dir}/niri/overview"
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
waypaper_config=${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini

_parse_waypaper_config() {
  awk -F "=" "/$1/"'{printf $2}' "$waypaper_config" | tr -d ' '
}

_get_swww_args() {
  type="$(_parse_waypaper_config "swww_transition_type")"
  duration="$(_parse_waypaper_config "swww_transition_duration")"
  step="$(_parse_waypaper_config "swww_transition_step")"
  angle="$(_parse_waypaper_config "swww_transition_angle")"
  fps="$(_parse_waypaper_config "swww_transition_fps")"
  [ -n "$type" ] && swww_args+=("--transition-type" "$type")
  [ -n "$duration" ] && swww_args+=("--transition-duration" "$duration")
  [ -n "$step" ] && swww_args+=("--transition-step" "$step")
  [ -n "$angle" ] && swww_args+=("--transition-angle" "$angle")
  [ -n "$fps" ] && swww_args+=("--transition-fps" "$fps")
}

switch_wallpaper() {

  if [[ ! -f "$1" ]]; then
    echo "ERROR: $1 is not a valid file" >&2
    exit 1
  fi

  [ ! -d "$cache_dir/niri/landing" ] && mkdir -p "$cache_dir/niri/landing"
  if [[ "$1" != "$(readlink -f "$cache_dir/niri/landing/background")" || "$scheme" ]]; then
    scheme=${scheme:-"scheme-tonal-spot"}

    # fallback to prefer-light if color-scheme is default
    if [ "$current_theme" = "'default'" ]; then
      gsettings set org.gnome.desktop.interface color-scheme prefer-light
      current_theme="'prefer-light'"
    fi
    if [ $(matugen -V | awk '{printf $2}' | cut -d. -f1) -ge 4 ]; then
      matugen image "$1" -m "$(grep -oe 'light' -oe 'dark' <<<"$current_theme")" --source-color-index 0 -t "$scheme" >/dev/null 2>&1 &
    else
      matugen image "$1" -m "$(grep -oe 'light' -oe 'dark' <<<"$current_theme")" -t "$scheme" >/dev/null 2>&1 &
    fi
    ln -sf "$1" "$cache_dir/niri/landing/background"

    cache_img="$blur_cache"/"$(basename "$1")"
    [ ! -d "$blur_cache" ] && mkdir -p "$blur_cache"
    if [[ ! -e "$cache_img" || "$(basename "$cache_img")" != "$(basename "$1")" ]]; then
      magick "$1" -blur 30x10 -brightness-contrast -10 "$cache_img"
    fi
    ln -sf "$cache_img" "$blur_img"

    notify-send -i "$1" -e -r 2 -t 2000 "Wallpaper switch successful..." "Current Wallpaper: $(basename "$1")"
  else
    echo "Same wallpaper detected. Skipping matugen & caching..."
  fi

  if [[ ! "$SKIP_OVERVIEW" || "$FORCE_RESTART_OVERVIEW" ]]; then
    _get_swww_args
    if [ ! "$FORCE_RESTART_OVERVIEW" ]; then
      systemctl --user is-active overview-backdrop >/dev/null || systemctl --user restart overview-backdrop.service
    else
      systemctl --user restart overview-backdrop.service
    fi
    swww img -n overview "${swww_args[@]}" "$blur_img"
  else
    echo "Skipping overview reloading..."
  fi

}

while true; do
  case "$1" in
  --skip-overview | -S)
    SKIP_OVERVIEW=1
    shift
    ;;
  --force | -F)
    FORCE_RESTART_OVERVIEW=1
    shift
    ;;
  --scheme | -s)
    scheme="scheme-$2"
    shift 2
    ;;
  *)
    echo "Switching wallpaper: $1"
    switch_wallpaper "$1"
    break
    ;;
  esac
done
