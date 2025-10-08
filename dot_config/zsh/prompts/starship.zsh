#!/usr/bin/env zsh

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
  export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
  export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
fi
