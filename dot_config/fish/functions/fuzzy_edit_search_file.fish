function fuzzy_edit_search_file
    set -l max_depth 5

    if command -v bat >/dev/null
        set -f preview_cmd bat --color always --style=plain --paging=never {}
    else
        set -f preview_cmd cat {}
    end

    set -l fzf_options --layout=reverse --cycle --preview-window right:60% --preview "$preview_cmd"

    if test -n "$argv"
        set -a fzf_options --query="$argv"
    end

    set -l selected_file (fd -H -t f -d $max_depth 2>/dev/null | fzf $fzf_options)

    if test -n "$selected_file"
        if command -v $EDITOR >/dev/null
            $EDITOR $selected_file
        else
            echo "EDITOR is not specified. Using vim."
        end
    else
        echo "No file selected or search returned no results."
    end
end
