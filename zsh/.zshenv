# XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Skip the global compinit that creates the unwanted dotted .zcompdump
skip_global_compinit=1

# Tell Zsh to look for all other startup files here
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$JAVA_HOME/bin:$PATH"

# Python (Homebrew)
export PATH="/opt/homebrew/bin:$PATH"

