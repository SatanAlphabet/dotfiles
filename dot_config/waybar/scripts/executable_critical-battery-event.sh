#!/usr/bin/env bash

crit_notification=$(notify-send -a 'Battery' -u critical 'Critical Battery...' 'Please charge your device immediately.' -i battery-level-0-symbolic -A 'SHUTDOWN=Shut Down')

case "$crit_notification" in
'SHUTDOWN')
  shutdown now
  ;;
esac
