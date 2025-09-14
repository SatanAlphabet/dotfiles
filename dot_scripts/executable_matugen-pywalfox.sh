current_theme=$(dconf read /org/gnome/desktop/interface/color-scheme)

if [ $current_theme = "'prefer-dark'" ]; then
  pywalfox dark
elif [ $current_theme = "'prefer-light'" ]; then
  pywalfox light
fi

pywalfox update
