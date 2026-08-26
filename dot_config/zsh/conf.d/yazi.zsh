#!/usr/bin/env zsh

function _yazi_to_cwd() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	rm -f -- "$tmp"
}

alias y='_yazi_to_cwd'
