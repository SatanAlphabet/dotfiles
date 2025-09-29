#!/usr/bin/env bash

command="
        fastfetch
        echo '''

 ===>  Beginning system update...

        '''
        paru -Syu
        echo '''

 ===>  Checking for flatpak updates...
        
        '''
        flatpak update
        echo '''

 ===>  Running post-installation checks...

        '''
        sudo checkservices
        notify-send 'System update completed...'
        read -n 1 -p 'Press any key to exit...'
        "

kitty --class "sysupdate" --title "System Update" sh -c "${command}"
exit 0
