#!/usr/bin/env bash

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

echo -e "\n===>  Installing base packages...\n"
paru -S --needed - <"package.list"

echo -e "\n===>  Installing AUR packages...\n"
paru -S --needed - <"package.aur-list"

echo -e "\n===>  Switching shell to zsh...\n"
chsh -s "$(which zsh)"

if ! command -v chezmoi &>/dev/null; then
  echo -e "\n===>  chezmoi is not installed. Installing...\n"
  sudo pacman -S chezmoi
fi
echo -e "\n===>  Setting up config with chezmoi...\n"
chezmoi init SatanAlphabet
chezmoi apply

services=(swayidle-niri wl-clip-persist nirius wl-paste-text-niri wl-paste-image-niri)
echo -e "\n===>  Adding necessary user services...\n"
for service in "${services[@]}"; do
  echo "- Adding: ""$service"".service"
  systemctl --user add-wants niri.service "$service"
done

echo -e "\n===>  Basic setup installed."
echo -e "\nAdd 'post_command = ~/.scripts/wallswitch.sh \$wallpaper' to your waypaper's config.ini"
