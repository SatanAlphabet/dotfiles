cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ $current_theme = "'prefer-dark'" ]; then
  matugen image "$1" -c ~/.config/matugen/main.toml -m dark
elif [ $current_theme = "'prefer-light'" ]; then
  matugen image "$1" -c ~/.config/matugen/main.toml -m light
fi

cp "$1" "${cache_dir}/noctalia/background"
