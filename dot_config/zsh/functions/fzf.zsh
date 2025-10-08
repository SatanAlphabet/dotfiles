# best fzf aliases ever
_fuzzy_change_directory() {
    local initial_query="$1"
    local selected_dir
    local fzf_options=('--preview=tree -C {} | head -n 100')
    fzf_options+=(--layout=reverse --preview-window right:60% --cycle)
    local max_depth=7

    if [[ -n "$initial_query" ]]; then
        fzf_options+=("--query=$initial_query")
    fi

    #type -d
    selected_dir=$(fd -t d -H -d $max_depth -E .git -E node_modules -E .venv -E target -E .cache -E __pycache__ 2>/dev/null | fzf "${fzf_options[@]}")

    if [[ -n "$selected_dir" && -d "$selected_dir" ]]; then
        cd "$selected_dir" || return 1
    else
        return 1
    fi
}

_fuzzy_edit_search_file_content() {
    local initial_query="$@"
    local selected_file
    local fzf_options=()
    local preview_cmd
    local max_depth=5

    if [[ -n "$initial_query" ]]; then
        fzf_options+=("--query=$initial_query")
    fi

    if command -v "bat" &>/dev/null; then
        preview_cmd=('bat --color always --style=plain --paging=never {}')
    else
        preview_cmd=('cat {}')
    fi

    fzf_options+=(--layout=reverse --cycle --preview-window right:60% --preview ${preview_cmd[@]})
    selected_file=$(fd -H -t f -d $max_depth 2>/dev/null | fzf "${fzf_options[@]}")

    if [[ -n "$selected_file" ]]; then
        if command -v "$EDITOR" &>/dev/null; then
            "$EDITOR" "$selected_file"
        else
            echo "EDITOR is not specified. using vim.  (you can export EDITOR in ~/.zshrc)"
            vim "$selected_file"
        fi

    else
        echo "No file selected or search returned no results."
    fi
}

_fuzzy_edit_search_file() {
    local initial_query="$@"
    local selected_file
    local fzf_options=()
    fzf_options+=(--layout=reverse --preview-window right:60% --cycle)
    local max_depth=5

    if [[ -n "$initial_query" ]]; then
        fzf_options+=("--query=$initial_query")
    fi

    # -type f: only find files
    selected_file=$(fd -H -d $max_depth -t f 2>/dev/null | fzf "${fzf_options[@]}")

    if [[ -n "$selected_file" && -f "$selected_file" ]]; then
        if command -v "$EDITOR" &>/dev/null; then
            "$EDITOR" "$selected_file"
        else
            echo "EDITOR is not specified. using vim.  (you can export EDITOR in ~/.zshrc)"
            vim "$selected_file"
        fi
    else
        echo "No file selected or search returned no results."
    fi
}

alias ffec='_fuzzy_edit_search_file_content' \
    ffe='_fuzzy_edit_search_file' 

# Default fzf options
export FZF_DEFAULT_OPTS="   --border=rounded --border-label-pos=6 \
  --margin=0 --padding=1 --style=minimal\
  --layout=reverse --info=default \
  --marker=  --prompt='[$USER@fzf]$ ' \
  --height=100% --list-label=' Result '\
  --bind='focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' \
  --preview-window=60%,border-rounded,right \
  --walker-skip .git,node_modules \
  "

# Keybind-specific fzf options
export FZF_ALT_C_OPTS="--preview='tree -C {} | head -n 300' --border-label='| Change Directory |'"
export FZF_CTRL_R_OPTS="--border-label='| Command History |'"
export FZF_CTRL_T_OPTS="--border-label='| Search |'"

export FZF_CTRL_T_COMMAND='fd -H -E .git -E node_modules -E .venv -E target'
export FZF_ALT_C_COMMAND='fd -t d -H -E .git -E node_modules -E .venv -E target -E __pycache__'



