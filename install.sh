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

echo -e "\n===>  Installing oh-my-zsh...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "\n===>  Installing powerlevel10k...\n"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
echo -e "\n===>  Installing zsh-autosuggestions...\n"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
echo -e "\n===>  Installing zsh-syntax-highlighting...\n"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

echo -e "\n===>  Basic setup installed."
echo -e "\nAdd 'post_command = ~/.scripts/wallswitch.sh \$wallpaper' to your waypaper's config.ini"
