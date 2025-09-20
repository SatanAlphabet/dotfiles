#!/usr/bin/env zsh

function _load_common() {

    # Load all custom function files // Directories are ignored
    for file in "${ZDOTDIR:-$HOME/.config/zsh}/functions/"*.zsh; do
        [ -r "$file" ] && source "$file"
    done

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
if ! source ${ZDOTDIR}/conf.d/src/prompt.zsh > /dev/null 2>&1; then
    [[ -f $ZDOTDIR/conf.d/src/prompt.zsh ]] && source $ZDOTDIR/conf.d/src/prompt.zsh
fi

}

# ZSH Plugin Configuration


ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# # History configuration
HISTFILE=${HISTFILE:-$ZDOTDIR/.zsh_history}
if [[ -f $HOME/.zsh_history ]] && [[ ! -f $HISTFILE ]]; then
    echo "Please manually move $HOME/.zsh_history to $HISTFILE"
    echo "Or move it somewhere else to avoid conflicts"
fi

export HISTFILE ZSH_AUTOSUGGEST_STRATEGY


[[ -r $ZDOTDIR/user.zsh ]] && source $ZDOTDIR/user.zsh
[[ -r $ZDOTDIR/.zshrc ]] && source $ZDOTDIR/.zshrc

_load_compinit

[[ -r $HOME/.oh-my-zsh/oh-my-zsh.sh ]] && source $HOME/.oh-my-zsh/oh-my-zsh.sh

_load_prompt
_load_common



alias c='clear' \
    ..='cd ..' \
    ...='cd ../..' \
    .3='cd ../../..' \
    .4='cd ../../../..' \
    .5='cd ../../../../..' \
    mkdir='mkdir -p'
