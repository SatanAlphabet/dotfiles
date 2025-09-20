#!/usr/bin/env zsh

if command -v starship &>/dev/null; then
    # ===== START Initialize Starship prompt =====
    eval "$(starship init zsh)"
    export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
    export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
# ===== END Initialize Starship prompt =====
elif [ -f $ZDOTDIR/.p10k.zsh ]; then
    # ===== START Initialize Powerlevel10k theme =====
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
# ===== END Initialize Powerlevel10k theme =====
fi
