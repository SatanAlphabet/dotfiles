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
  if [[ "$1" != "$(readlink -f "$cache_dir/niri/landing/background")" ]]; then

    # fallback to prefer-light if color-scheme is default
    if [ "$current_theme" = "'default'" ]; then
      gsettings set org.gnome.desktop.interface color-scheme prefer-light
    fi
    matugen image "$1" -m "$(grep -oe 'light' -oe 'dark' <<<"$current_theme")" &
    ln -sf "$1" "$cache_dir/niri/landing/background"

    cache_img="$blur_cache"/"$(basename "$1")"
    [ ! -d "$blur_cache" ] && mkdir -p "$blur_cache"
    if [[ ! -e "$cache_img" || "$(basename "$cache_img")" != "$(basename "$1")" ]]; then
      magick "$1" -blur 20x10 "$cache_img"
    fi
    ln -sf "$cache_img" "$blur_img"

    notify-send -e -r 2 -t 2000 "Wallpaper switch successful..." "Current Wallpaper: $(basename "$1")"
  else
    echo "Same wallpaper detected. Skipping matugen & caching..."
  fi

  if [ ! "$SKIP_OVERVIEW" ]; then
    _get_swww_args
    systemctl --user is-active overview-backdrop || systemctl --user restart overview-backdrop.service
    swww img -n overview "${swww_args[@]}" "$blur_img"
  else
    echo "Skipping overview reloading..."
  fi

}

while true; do
  case "$1" in
  --skip-overview)
    SKIP_OVERVIEW=1
    shift
    ;;
  *)
    echo "Switching wallpaper: $1"
    switch_wallpaper "$1"
    break
    ;;
  esac
done
