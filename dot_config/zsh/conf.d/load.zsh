#!/usr/bin/env zsh

# shellcheck disable=SC1091
if ! . "$ZDOTDIR/conf.d/src/env.zsh"; then
    echo "Error: Could not source $ZDOTDIR/conf.d/src/env.zsh"
    return 1
fi

if [ -t 1 ] && [ -f "$ZDOTDIR/conf.d/src/terminal.zsh" ]; then
    . "$ZDOTDIR/conf.d/src/terminal.zsh" || echo "Error: Could not source $ZDOTDIR/conf.d/src/terminal.zsh"
fi
