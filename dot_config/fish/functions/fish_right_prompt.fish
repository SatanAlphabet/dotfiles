function fish_right_prompt
    if not contains -- --final-rendering $argv
        echo -n -s (set_color brblack) (date '+%H:%M:%S') (set_color normal)
    end
end
