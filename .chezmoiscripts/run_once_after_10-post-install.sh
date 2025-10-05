#!/bin/bash

echo -e "===>  Starting post-setup configuration...\n"

_install_confirm() {
  local response
  echo -n -e "$1"
  read -r response

  if [[ "$response" =~ ^[Yy]$|^$ ]]; then
    return 0
  else
    return 1
  fi
}

services=(swayidle-niri wl-clip-persist niriusd wl-paste-text-niri wl-paste-image-niri)
if _install_confirm "Add necessary systemd services? [Y/n] " -eq 0; then
  echo -e "===>  Adding necessary user services..."
  for service in "${services[@]}"; do
    echo "- Adding: ""$service"".service"
    systemctl --user add-wants niri.service "$service"
  done
fi

if [[ ! -d "$HOME/.cache/niri/landing" ]]; then
  echo -e "===>  Creating cache folder..."
  mkdir -p "$HOME/.cache/niri/landing/"
else
  echo -e "===>  Cache folder exist. Skipping..."
fi

if _install_confirm "Build xdg-menu cache? [Y/n] " -eq 0; then
  echo -e "===> Building xdg-menu cache..."
  XDG_MENU_PREFIX=plasma- kbuildsyscoca6 --noincremental >/dev/null
fi

if _install_confirm "Change GTK settings? [Y/n] " -eq 0; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
  gsettings set org.gnome.desktop.interface font-name 'Inter 10'
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
  gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
fi

echo -e "===>  Basic setup installed."
echo -e "Add 'post_command = ~/.scripts/wallswitch.sh \$wallpaper' to your waypaper's config.ini"
echo -e "Also setup your system theme with qt6ct & nwg-look and do a restart to run the services."
