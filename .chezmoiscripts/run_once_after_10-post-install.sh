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

services=(waybar swaync swayidle waypaper overview-blur wl-clip-persist niriusd wl-paste polkit-niri)
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

if _install_confirm "Setup missing auto-generated colors? [Y/n] " -eq 0; then
  # Directories should be handled by chezmoi, but just in case.
  mkdir -p "$HOME/.local/share/color-schemes/"
  mkdir -p "$HOME/.config/waybar/"
  mkdir -p "$HOME/.config/rofi/"
  mkdir -p "$HOME/.config/niri/"
  mkdir -p "$HOME/.config/swaync/"
  mkdir -p "$HOME/.config/wlogout/"
  cp "$pkg_path/Matugen.colors" "$HOME/.local/share/color-schemes/Matugen.colors" && echo -e "===>  Copied colorscheme..."
  cp "$pkg_path/waybar-colors.css" "$HOME/.config/waybar/colors.css" && echo -e "===>  Copied waybar colors..."
  cp "$pkg_path/wlogout-colors.css" "$HOME/.config/wlogout/colors.css" && echo -e "===>  Copied waybar colors..."
  cp "$pkg_path/niri-colors.kdl" "$HOME/.config/niri/matugen-colors.kdl" && echo -e "===>  Copied niri colors..."
  cp "$pkg_path/swaync-colors.css" "$HOME/.config/swaync/colors.css" && echo -e "===>  Copied SwayNC colors..."
  cp "$pkg_path/rofi-colors.rasi" "$HOME/.config/rofi/colors.rasi" && echo -e "===>  Copied rofi colors..."
fi

if _install_confirm "Install VSCode themes for matugen? [Y/n] " -eq 0; then
  codium --install-extension "$pkg_path/matugen-vscode-1.1.0.vsix" && echo -e "===>  Theme installed successfully..."
fi

if _install_confirm "Setup waypaper config? [Y/n] " -eq 0; then
  echo -e "===>  Copying default background to wallpaper directory... (${wall_path})"
  mkdir -p "$wall_path/"
  cp "$pkg_path/default-bg.png" "$wall_path/default-bg.png" && echo -e "===>  Copied background..."
  mkdir -p "$HOME/.config/waypaper/"
  echo -e "===>  Copying initial waypaper config..."
  cp "$pkg_path/waypaper-config.ini" "$HOME/.config/waypaper/config.ini" && echo -e "===>  Copied starting waypaper config..."
fi

echo -e "===>  Basic setup completed..."
echo -e "===>  Restart your system to apply changes."
