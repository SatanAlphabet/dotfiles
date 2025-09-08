cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"

pkill waypaper
matugen image "$1" -c ~/.config/matugen/main.toml
cp -f "$1" ${cache_dir}/niri/landing/background
magick "$1" -blur 20x10 ${cache_dir}/niri/landing/blur
systemctl --user restart overview-blur.service
notify-send -e -r 2 -t 2000 "Wallpaper switch successful..." "$1"
