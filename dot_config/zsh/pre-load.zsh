#  Startup 
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
if [[ $- == *i* ]]; then
   # This is a good place to load graphic/ascii art, display system information, etc.
fi

#  Plugins 
plugins=(sudo git zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
ZSH_THEME="powerlevel10k/powerlevel10k"
