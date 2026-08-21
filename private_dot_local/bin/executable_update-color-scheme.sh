#!/usr/bin/env bash

color_scheme="$1"

# Refresh color-scheme twice to update GTK apps like nautilus
if [ "$color_scheme" = "light" ]; then
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  gsettings set org.gnome.desktop.interface color-scheme prefer-light
elif [ "$color_scheme" = "dark" ]; then
  gsettings set org.gnome.desktop.interface color-scheme prefer-light
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
  echo "Error: unknown color scheme" >&2
  exit 1
fi
