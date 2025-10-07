_conda_setup_init() {
# >>> conda initialize >>>
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
  echo -e " ==> Starting conda..."
  eval "$__conda_setup"
else
  if [ -f "/usr/etc/profile.d/conda.sh" ]; then
    . "/usr/etc/profile.d/conda.sh"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<
}

alias conda-start='_conda_setup_init'
