abbr -a -- lg lazygit
abbr -a -- ff fastfetch
abbr -a -- ... cd ../..
abbr -a -- .3 cd ../../..
abbr -a -- .4 cd ../../../..
abbr -a -- .5 cd ../../../../..
abbr -a -- mkdir mkdir -p

if ! command -v yay >/dev/null; and command -v paru >/dev/null
    abbr -a -- yay paru
else if ! command -v paru >/dev/null; and command -v yay >/dev/null
    abbr -a -- paru yay
end

abbr -a -- ffe fuzzy_edit_search_file
