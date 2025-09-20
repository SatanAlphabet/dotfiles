function no_such_file_or_directory_handler {
    local red='\e[1;31m' reset='\e[0m'
    printf "${red}zsh: no such file or directory: %s${reset}\n" "$1"
    return 127
}

# ------------------------------------------------------------

# # Warn if the shell is slow to load
# add-zsh-hook -Uz precmd _slow_load_warning #! try to not use for now as we already move zshrc
