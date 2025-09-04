cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"

pkill waypaper
cp -f "$1" ${cache_dir}/niri/landing/background
magick "$1" -blur 20x10 ${cache_dir}/niri/landing/blur
systemctl --user restart overview-blur.service
