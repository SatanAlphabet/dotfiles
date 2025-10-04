#!/usr/bin/env zsh

function _load_function() {
    # Load all custom function files // Directories are ignored
    for file in "${ZDOTDIR:-$HOME/.config/zsh}/functions/"*.zsh; do
        [ -r "$file" ] && source "$file"
    done
}

function _load_completion() {
    for file in "${ZDOTDIR:-$HOME/.config/zsh}/completions/"*.zsh; do
        [ -r "$file" ] && source "$file"
    done
  }

function _load_compinit() {
    # Initialize completions with optimized performance
    autoload -Uz compinit

    # Enable extended glob for the qualifier to work
    setopt EXTENDED_GLOB

    # Fastest - use glob qualifiers on directory pattern
    if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+${ZSH_COMPINIT_CHECK:-1}) ]]; then
        compinit
    else
        compinit -C
    fi

    _comp_options+=(globdots) # tab complete hidden files
}

function _load_prompt() {
    # Try to load prompts immediately
if ! source ${ZDOTDIR}/src/prompt.zsh > /dev/null 2>&1; then
    [[ -f $ZDOTDIR/src/prompt.zsh ]] && source $ZDOTDIR/src/prompt.zsh
fi
}

# # History configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
HISTFILE=${HISTFILE:-$ZDOTDIR/.zsh_history}
if [[ -f $HOME/.zsh_history ]] && [[ ! -f $HISTFILE ]]; then
    echo "Please manually move $HOME/.zsh_history to $HISTFILE"
    echo "Or move it somewhere else to avoid conflicts"
fi
HISTSIZE=10000
SAVEHIST=10000

export HISTFILE ZSH_AUTOSUGGEST_STRATEGY HISTSIZE SAVEHIST
export ZSH="$HOME/.oh-my-zsh"

# main stuff
[[ -r $ZDOTDIR/.zshrc ]] && source $ZDOTDIR/.zshrc
_load_compinit
[[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
_load_prompt
_load_function
_load_completion
