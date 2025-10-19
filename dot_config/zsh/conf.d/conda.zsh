#!/usr/bin/env zsh
_micromamba_init_setup() {
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/usr/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/wowlolxdddd/.local/share/mamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
}

_miniconda_init_setup() {
  if [[ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]]; then
    source "/opt/miniconda3/etc/profile.d/conda.sh"
  fi
}

alias micromamba-start='_micromamba_init_setup'
alias miniconda-start='_miniconda_init_setup'
