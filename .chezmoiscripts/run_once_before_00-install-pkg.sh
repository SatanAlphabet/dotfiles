#!/bin/bash

echo -e "===>  Starting setup installation...\n"

pkg_path="$HOME/.local/share/chezmoi/assets/install"

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
  echo -e "===>  paru is not installed. Installing paru..."
  sudo pacman -S --needed base-devel
  git clone https://aur.archlinux.org/paru-bin.git ./paru
  cd paru || exit 1
  makepkg -si
  cd ..
  rm -rf paru
else
  echo -e "===>  paru is installed. Skipping..."
fi

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
