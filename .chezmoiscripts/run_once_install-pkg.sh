#!/bin/bash

echo -e "\n===>  Starting setup installation...\n"

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

if ! command -v paru &>/dev/null; then
  echo -e "\n===>  paru is not installed. Installing paru...\n"
  sudo pacman -S --needed base-devel
  git clone https://aur.archlinux.org/paru-bin.git ./paru
  cd paru || exit 1
  makepkg -si
  cd ..
  rm -rf paru
else
  echo -e "\n===>  paru is installed. Skipping...\n"
fi

pkg_path="$HOME/.local/share/chezmoi"
if _install_confirm "Install base packages? [Y/n] " -eq 0; then
  echo -e "\n===>  Installing base packages...\n"
  paru -S --needed - <"$pkg_path/package.list"
fi

if _install_confirm "Install AUR packages? [Y/n] " -eq 0; then
  echo -e "\n===>  Installing AUR packages...\n"
  paru -S --needed --confirm - <"$pkg_path/package-aur.list"
fi

if _install_confirm "Switch shell to zsh? [Y/n] " -eq 0; then
  echo -e "\n===>  Switching shell to zsh...\n"
  chsh -s "$(which zsh)"
fi

services=(swayidle-niri wl-clip-persist niriusd wl-paste-text-niri wl-paste-image-niri)
if _install_confirm "Add necessary systemd services? [Y/n] " -eq 0; then
  echo -e "\n===>  Adding necessary user services...\n"
  for service in "${services[@]}"; do
    echo "- Adding: ""$service"".service"
    systemctl --user add-wants niri.service "$service"
  done
fi

if [[ ! -d "$HOME/.cache/niri/landing" ]]; then
  echo -e "\n===>  Creating cache folder..."
  mkdir -p "$HOME/.cache/niri/landing/"
else
  echo -e "\n===<  Cache folder exist. Skipping..."
fi

echo -e "\n===>  Basic setup installed."
echo -e "\nAdd 'post_command = ~/.scripts/wallswitch.sh \$wallpaper' to your waypaper's config.ini"
sed -i 's|post_command =|post_command = ~/.scripts/wallswitch.sh $wallpaper|' ~/.config/waypaper/config.ini
