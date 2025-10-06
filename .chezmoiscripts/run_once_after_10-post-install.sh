#!/bin/bash

echo -e "===>  Starting post-setup configuration..."
echo -e "NOTE: This should be run inside niri to work properly."

pkg_path="$HOME/.local/share/chezmoi/assets/install"
wall_path="$HOME/Pictures/Wallpaper"

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
  systemctl --user daemon-reload
  for service in "${services[@]}"; do
    systemctl --user add-wants niri.service "$service" && echo "===>  Added ""$service"".service"
  done
fi

if [[ ! -d "$HOME/.cache/niri/landing" ]]; then
  echo -e "===>  Creating cache folder..."
  mkdir -p "$HOME/.cache/niri/landing/"
else
  echo -e "===>  Cache folder exist. Skipping..."
fi

if _install_confirm "Build xdg-menu cache? [Y/n] " -eq 0; then
  echo -e "===>  Building xdg-menu cache..."
  XDG_MENU_PREFIX=plasma- kbuildsyscoca6 --noincremental >/dev/null
fi

if _install_confirm "Change GTK settings? [Y/n] " -eq 0; then
  echo -e "===>  Changing GTK settings..."
  device_theme="prefer-light"
  cursor_theme="Bibata-Modern-Ice"
  font="Inter 10"
  gtk_theme="adw-gtk3"
  icon_theme="Adwaita"
  gsettings set org.gnome.desktop.interface color-scheme "${device_theme}" && echo -e "===>  Device theme set to ${device_theme}"
  gsettings set org.gnome.desktop.interface cursor-theme "${cursor_theme}" && echo -e "===>  Cursor theme set to ${cursor_theme}"
  gsettings set org.gnome.desktop.interface font-name "${font}" && echo -e "===>  Font set to ${font}"
  gsettings set org.gnome.desktop.interface gtk-theme "${gtk_theme}" && echo -e "===>  GTK theme set to ${gtk_theme}"
  gsettings set org.gnome.desktop.interface icon-theme "${icon_theme}" && echo -e "===>  Icon theme set to ${icon_theme}"
fi

if _install_confirm "Setup waypaper config? [Y/n] " -eq 0; then
  mkdir -p "$HOME/.config/waypaper/"
  cp "$pkg_path/waypaper-config.ini" "$HOME/.config/waypaper/config.ini" && echo -e "===>  Copied starting waypaper config..."
fi

if _install_confirm "Set default background and run matugen? (REQUIRES WAYPAPER CONFIGURED) [Y/n] " -eq 0; then
  echo -e "===>  Copying default background to wallpaper directory... (${wall_path})"
  mkdir -p "$wall_path/"
  cp "$pkg_path/default-bg.png" "$wall_path/default-bg.png"
  echo -e "===>  Applying changes with waypaper..."
  waypaper --wallpaper "$wall_path/default-bg.png"
fi

echo -e "===>  Basic setup completed."
echo -e "Setup your system theme with qt6ct & nwg-look and do a restart to run the services."
