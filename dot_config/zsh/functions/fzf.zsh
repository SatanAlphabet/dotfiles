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
    selected_dir=$(find . -maxdepth $max_depth \( -name .git -o -name node_modules -o -name .venv -o -name target -o -name .cache \) -prune -o -type d -print 2>/dev/null | fzf "${fzf_options[@]}")

    if [[ -n "$selected_dir" && -d "$selected_dir" ]]; then
        cd "$selected_dir" || return 1
    else
        return 1
    fi
}

_fuzzy_edit_search_file_content() {
    # [f]uzzy [e]dit  [s]earch [f]ile [c]ontent
    local selected_file
    local fzf_options=()
    local preview_cmd
    if command -v "bat" &>/dev/null; then
        preview_cmd=('bat --color always --style=plain --paging=never {}')
    else
        preview_cmd=('cat {}')
    fi
    fzf_options+=(--layout=reverse --cycle --preview-window right:60% --preview ${preview_cmd[@]})
    selected_file=$(grep -irl "${1:-}" ./ | fzf "${fzf_options[@]}")

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
    local initial_query="$1"
    local selected_file
    local fzf_options=()
    fzf_options+=(--height "80%" --layout=reverse --preview-window right:60% --cycle)
    local max_depth=5

    if [[ -n "$initial_query" ]]; then
        fzf_options+=("--query=$initial_query")
    fi

    # -type f: only find files
    selected_file=$(find . -maxdepth $max_depth -type f 2>/dev/null | fzf "${fzf_options[@]}")

    if [[ -n "$selected_file" && -f "$selected_file" ]]; then
        if command -v "$EDITOR" &>/dev/null; then
            "$EDITOR" "$selected_file"
        else
            echo "EDITOR is not specified. using vim.  (you can export EDITOR in ~/.zshrc)"
            vim "$selected_file"
        fi
    else
        return 1
    fi
}

alias ffec='_fuzzy_edit_search_file_content' \
    ffcd='_fuzzy_change_directory' \
    ffe='_fuzzy_edit_search_file' 

export FZF_DEFAULT_OPTS=" --color=fg:#d4be98,bg:#141617,hl:#d3869b \
  --color=fg+:#89b482,bg+:#1d2021,hl+:#ea6962 \
  --color=info:#e78a4e,prompt:#ea6962,pointer:#7daea3 \
  --color=marker:#d3869b,spinner:#d8a657,header:#ea6962 \
  --color=separator:#504945,gutter:#141617,border:#504945 \
  --color=label:#928374 \
  --border=rounded --border-label-pos=6 \
  --color=input-border:#442e2d,list-border:#333e34,preview-border:#2e3b3b \
  --color=preview-label:#7daea3,list-label:#a9b665,input-label:#ea6962 \
  --margin=0 --padding=1 --style=full\
  --layout=reverse --info=default \
  --marker=  --prompt='[$USER@fzf]$ ' \
  --height=100% --list-label=' Result '\
  --bind='focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' \
  --preview-window=60%,border-rounded,right \
  --walker-skip .git,node_modules \
  "

export FZF_ALT_C_OPTS="--preview='tree -C {} | head -n 300' --border-label='| Change Directory |'"
export FZF_CTRL_R_OPTS="--border-label='| Command History |'"
export FZF_CTRL_T_OPTS="--border-label='| Search |'"





