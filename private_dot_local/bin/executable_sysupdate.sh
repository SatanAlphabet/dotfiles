#!/usr/bin/env bash

ORANGE='\033[0;33m'
NC='\033[0m' # No Color

pkg_text=" - System packages updated."
flatpak_text=" - Flatpak packages updated."
post_upd_text=" - Post-update checks completed."
upd_command=pacman

fastfetch.sh
echo -e """

 ${ORANGE}===>${NC}  Beginning system update...

        """
if which paru >/dev/null 2>&1; then
  upd_command=paru
elif which yay >/dev/null 2>&1; then
  upd_command=yay
fi

if ! $upd_command -Syu; then
  failed_update=true
  pkg_text=" [!] Failed to update system packages."
fi
echo -e """

 ${ORANGE}===>${NC}  Checking for flatpak updates...
        
        """
if ! flatpak update; then
  failed_update=true
  flatpak_text=" [!] Failed to update flatpak packages."
fi
echo -e """

 ${ORANGE}===>${NC}  Running post-installation checks...

        """
if ! sudo checkservices; then
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
