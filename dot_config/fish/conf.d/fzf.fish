if status is-interactive
    fzf --fish | source
    # Default fzf options
    set -gx FZF_DEFAULT_COMMAND fd --strip-cwd-prefix -E .git -E node_modules -E target -E __pycache__
    set -gx FZF_DEFAULT_OPTS --border=rounded --border-label-pos=6 \
        --margin=0 --padding=1 --style=minimal \
        --layout=reverse --info=default \
        --marker= --prompt="'[$USER@fzf]\$ '" \
        --height=100% --list-label="' Result '" \
        --bind="'focus:transform-preview-label:test -n {}; and  printf \" Previewing [%s] \" {}'" \
        --preview-window=60%,border-rounded,right \
        --color=base16,info:magenta,pointer:magenta \
        --color=hl:blue,hl+:bright-blue:underline,

    # Keybind-specific fzf options
    set -gx FZF_ALT_C_OPTS --preview='"tree -C {} | head -n 300"' --border-label='"| Change Directory |"'
    set -gx FZF_CTRL_R_OPTS --border-label='"| Command History |"'
    set -gx FZF_CTRL_T_OPTS --border-label='"| Search |"' --preview='"bat --color=always --paging=never --wrap=never --style=plain {}"'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND -t f
    set -gx FZF_ALT_C_COMMAND $FZF_DEFAULT_COMMAND -t d
    set -gx FZF_COMPLETION_OPTS --border-label='"| Completion |"'
end
