#!/bin/bash

echo -e "\n===>  Starting setup installation...\n"

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
echo -e "\n===>  Installing base packages...\n"
paru -S --needed - <"$pkg_path/package.list"

echo -e "\n===>  Installing AUR packages...\n"
paru -S --needed --confirm - <"$pkg_path/package-aur.list"

echo -e "\n===>  Switching shell to zsh...\n"
chsh -s "$(which zsh)"

services=(swayidle-niri wl-clip-persist niriusd wl-paste-text-niri wl-paste-image-niri)
echo -e "\n===>  Adding necessary user services...\n"
for service in "${services[@]}"; do
  echo "- Adding: ""$service"".service"
  systemctl --user add-wants niri.service "$service"
done

echo -e "\n===>  Creating cache folder..."
mkdir -p "$HOME/.cache/niri/landing/"

echo -e "\n===>  Basic setup installed."
echo -e "\nAdd 'post_command = ~/.scripts/wallswitch.sh \$wallpaper' to your waypaper's config.ini"
