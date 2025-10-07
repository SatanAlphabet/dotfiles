#!/usr/bin/env zsh

if [[ -r $ZDOTDIR/.p10k.zsh && -f $ZDOTDIR/.p10k.zsh ]]; then
  # ===== START Initialize Powerlevel10k theme =====
  source $ZDOTDIR/.p10k.zsh
    # ===== END Initialize Powerlevel10k theme =====
elif command -v starship &>/dev/null; then
  # ===== START Initialize Starship prompt =====
  eval "$(starship init zsh)"
  export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
  export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
  # ===== END Initialize Starship prompt =====
fi
