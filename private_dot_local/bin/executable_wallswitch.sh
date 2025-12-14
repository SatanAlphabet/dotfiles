#!/usr/bin/env bash
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
blur_img="${cache_dir}/niri/landing/blur"
blur_cache="${cache_dir}/niri/overview"
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

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
    if [ "$current_theme" = "'prefer-dark'" ]; then
      matugen image "$1" -m dark
    elif [ "$current_theme" = "'prefer-light'" ]; then
      matugen image "$1" -m light
    fi
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
    systemctl --user restart overview-blur.service
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
