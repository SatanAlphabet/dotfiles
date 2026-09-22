if status is-interactive
    fzf --fish | source
    # Default fzf options
    set -gx FZF_DEFAULT_OPTS "   --border=rounded --border-label-pos=6 \
  --margin=0 --padding=1 --style=minimal\
  --layout=reverse --info=default \
  --marker=  --prompt='[$USER@fzf]\$ ' \
  --height=100% --list-label=' Result '\
  --bind='focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' \
  --preview-window=60%,border-rounded,right \
  --walker-skip .git,node_modules \
  "

    # Keybind-specific fzf options
    set -gx FZF_ALT_C_OPTS "--preview='tree -C {} | head -n 300' --border-label='| Change Directory |'"
    set -gx FZF_CTRL_R_OPTS "--border-label='| Command History |'"
    set -gx FZF_CTRL_T_OPTS "--border-label='| Search |'"
    set -gx FZF_CTRL_T_COMMAND 'fd -H -E .git -E node_modules -E .venv -E target'
    set -gx FZF_ALT_C_COMMAND 'fd -t d -H -E .git -E node_modules -E .venv -E target -E __pycache__'
end
