set -q XDG_CONFIG_HOME || set XDG_CONFIG_HOME $HOME/.config

if test -f "$XDG_CONFIG_HOME/lazygit/matugen-theme.yml"
    set -gx LG_CONFIG_FILE "$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/matugen-theme.yml"
end
