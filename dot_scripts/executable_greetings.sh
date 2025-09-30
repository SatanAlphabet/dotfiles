#!/usr/bin/env zsh

repo_updates=$(checkupdates | wc -l)
aur_updates=$(paru -Quaq | wc -l)
total_updates=($repo_updates + $aur_updates)

if [[ $total_updates = 0 ]]; then
  notify-send "Welcome back, $USER." "All packages are up to date." -e -t 10000
else
  notify-send "Welcome back, $USER." "You have $total_updates updates available." -e -t 10000
fi
