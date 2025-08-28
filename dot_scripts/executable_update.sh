#!/usr/bin/env sh

command="
        fastfetch --logo-type kitty
        paru -Syu
        flatpak update
        sudo checkservices
        read -n 1 -p 'Press any key to exit...'
        "

kitty --class "sysupdate" --title "System Update" sh -c "${command}"
exit 0
