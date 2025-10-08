#!/usr/bin/env zsh

# Oh My Zsh settings
ZSH="$HOME/.oh-my-zsh"
plugins=(sudo git zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_CACHE_DIR="$ZSH/cache"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# Plugin-specific settings
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# --- Source OMZ --- #
[[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

