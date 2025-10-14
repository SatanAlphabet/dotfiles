#!/usr/bin/env zsh

#  ------|  Startup  |------  #
# Commands to execute on startup (before the prompt is shown)
# This is a good place to load graphic/ascii art, display system information, etc.

# Check if the interactive shell option is set
if [[ $- == *i* ]]; then
fi

#  ------|  Plugins  |------  #
# Supported settings: omz, zinit
ZSH_PLUGIN_FRAMEWORK="zinit"

#  ------|  Prompts  |------  #
# Supported settings: p10k, starship, oh-my-posh
ZSH_PROMPT="p10k"

# Use emacs-style bindings
# Switch to bindkey -v for vi-style bindings
bindkey -e

# Additional settings may be placed in conf.d
