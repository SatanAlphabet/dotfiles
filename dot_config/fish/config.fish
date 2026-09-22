if status is-interactive
    set -U fish_greeting
    set -g fish_transient_prompt 1
end

fish_add_path -P $HOME/.local/bin

set -gx EDITOR nvim
set -gx BAT_THEME ansi
