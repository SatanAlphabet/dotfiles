#!/usr/bin/env bash

ORANGE='\033[0;33m'
NC='\033[0m' # No Color

pkg_text=" - System packages updated."
flatpak_text=" - Flatpak packages updated."
post_upd_text=" - Post-update checks completed."

upd_command=pacman

upd_flags=(-Syu)
flatpak_flags=(-u --system)
post_upd_flags=(-i "sddm.service" -i "gdm.service") # Ignore display manager services to avoid nuking the current session

fastfetch.sh

if [ "$1" = "-y" ]; then
  upd_flags+=(--noconfirm)
  flatpak_flags+=(-y)
  post_upd_flags+=(-a)
  echo -e " ${ORANGE}WARNING:${NC} Skipping confirmation prompts..."
fi

echo -e "\n ${ORANGE}===>${NC}  Beginning system update...\n"

if which paru >/dev/null 2>&1; then
  upd_command=paru
elif which yay >/dev/null 2>&1; then
  upd_command=yay
fi

if ! $upd_command "${upd_flags[@]}"; then
  failed_update=true
  pkg_text=" [!] Failed to update system packages."
fi

echo -e "\n${ORANGE}===>${NC}  Checking for flatpak updates...\n"

if ! flatpak update "${flatpak_flags[@]}"; then
  failed_update=true
  flatpak_text=" [!] Failed to update flatpak packages."
fi

echo -e "\n${ORANGE}===>${NC}  Running post-installation checks...\n"

if ! sudo checkservices "${post_upd_flags[@]}"; then
  failed_update=true
  post_upd_text=" [!] Failed to run post-service checks."
fi

notif_msg="$pkg_text\n$flatpak_text\n$post_upd_text"

if [ "$failed_update" ]; then
  notify-send 'System update failed...' "$notif_msg" -a 'System Update' -u critical -i dialog-warning-symbolic
else
  notify-send 'System update completed...' "$notif_msg" -a 'System Update' -i object-select-symbolic
fi

read -r -n 1 -p 'Press any key to exit...'
