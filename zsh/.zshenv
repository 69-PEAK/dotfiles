# XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Tell Zsh to look for all other startup files here
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

