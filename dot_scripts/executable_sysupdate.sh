#!/usr/bin/env bash

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
notify-send 'System update completed...' -a 'System Update'
read -r -n 1 -p 'Press any key to exit...'
