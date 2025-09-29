cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ $current_theme = "'prefer-dark'" ]; then
  matugen image "$1" -c ~/.config/matugen/main.toml -m dark
elif [ $current_theme = "'prefer-light'" ]; then
  matugen image "$1" -c ~/.config/matugen/main.toml -m light
fi

cp -sf "$1" ${cache_dir}/niri/landing/background
magick "$1" -blur 20x10 ${cache_dir}/niri/landing/blur
systemctl --user restart overview-blur.service
notify-send -e -r 2 -t 2000 "Wallpaper switch successful..." "$1"
