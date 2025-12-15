#!/usr/bin/env zsh

alias c='clear' \
    ..='cd ..' \
    ...='cd ../..' \
    .3='cd ../../..' \
    .4='cd ../../../..' \
    .5='cd ../../../../..' \
    mkdir='mkdir -p'
alias ff='fastfetch.sh'
export EDITOR='nvim'
export BAT_THEME='ansi'

if [[ ! "$(which yay)" && "$(which paru)" ]]; then
  alias yay='paru'
elif [[ ! "$(which paru)" && "$(which yay)" ]]; then
  alias paru='yay'
fi
