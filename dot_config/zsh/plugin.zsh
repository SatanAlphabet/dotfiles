#!/usr/bin/env zsh

# Plugin settings (Oh My Zsh)
plugins=(sudo git zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_CACHE_DIR="$ZSH/cache"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# --- Source OMZ --- #

[[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
