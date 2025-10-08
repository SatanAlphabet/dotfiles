#!/usr/bin/env zsh
# --- Startup --- #
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
# This is a good place to load graphic/ascii art, display system information, etc.
if [[ $- == *i* ]]; then
fi

# --- Plugins --- #
# Supported settings: omz, zinit
ZSH_PLUGIN_FRAMEWORK="zinit"
