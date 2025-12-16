#!/usr/bin/env bash

logo_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/logo"

fastfetch --logo "$(find -L "$logo_dir" -maxdepth 1 -type f -name "*.png" -o -name "*.jpg" 2>/dev/null | shuf -n 1)"
