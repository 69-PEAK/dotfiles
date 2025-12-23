# Ensure runtime directories exist
mkdir -p "$XDG_DATA_HOME/zsh"
mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_STATE_HOME/zsh"

# History
export HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
# Force load history
fc -R "$HISTFILE"

# Source Completions plugin
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

# Completion system cache — moved to cache
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

#EZA COlORING CONFIG
export EZA_COLORS="di=1;94:fi=1;32:ln=1;96:ex=1;32:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31"

# Vivid Theme
export LS_COLORS="$(vivid generate tokyonight-night)"

# Source aliases
[ -f "$ZDOTDIR/.aliases" ] && source "$ZDOTDIR/.aliases"

# Source functions
[ -f "$ZDOTDIR/.functions" ] && source "$ZDOTDIR/.functions"

# Source Highlighting plugin
[ -f "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ---- zsh-syntax-highlighting style overrides ----
# Color syntax:
#   fg=<color>        foreground color (white, cyan, 8, 15, etc.)
#   bg=<color>        background color
#   bold              bold text
#   underline         underlined text
#   dim               dim / muted text
#   combine with commas → fg=white,bold

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'        # external commands (nvim, git)
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'      # shell builtins (cd, echo)
ZSH_HIGHLIGHT_STYLES[function]='fg=white,bold'     # shell functions
ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'        # shell aliases (cls, ll, gs)
ZSH_HIGHLIGHT_STYLES[unknown]='fg=red,bold'        # incorrect commands
ZSH_HIGHLIGHT_STYLES[arg]='fg=white,bold'          # normal arguments
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline,bold'          # valid filesystem paths
ZSH_HIGHLIGHT_STYLES[option]='fg=yellow,bold'      # flags (-la, --force)
ZSH_HIGHLIGHT_STYLES[operator]='fg=magenta,bold'   # | && || > <
ZSH_HIGHLIGHT_STYLES[variable]='fg=blue,bold'      # $HOME, $PATH
ZSH_HIGHLIGHT_STYLES[assignment]='fg=blue,bold'    # VAR=value
ZSH_HIGHLIGHT_STYLES[quoted]='fg=green,bold'       # "strings"
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold,dim'  # comments
ZSH_HIGHLIGHT_STYLES[subcommand]='fg=#f5c2e7,bold' 


# Source Autosuggestions plugin
[ -f "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ---- zsh-autosuggestions style ----
# Color syntax:
#   fg=<color>        foreground color (256-color or named)
#   bg=<color>        background color
#   bold              bold text
#   underline         underline text
#   dim               muted / low contrast
#   combine with commas → fg=8,dim

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white,dim'

# Source fzf
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
# Source fzf configuration
[ -f "$HOME/github/dotfiles/fzf/fzf.zsh" ] && source "$HOME/github/dotfiles/fzf/fzf.zsh"

# Source Starship
eval "$(STARSHIP_CONFIG="$HOME/github/dotfiles/starship/starship.toml" starship init zsh)"

# Tmuxinator path
export TMUXINATOR_CONFIG="$HOME/.config/tmux/tmuxinator"

# Luarocks paths for Neovim image support
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init. lua;;"
export LUA_CPATH="$HOME/.luarocks/lib/lua/5.1/?.so;;"

# Force non-Vi keybindings
bindkey -e
bindkey '^X^V' undefined-key
unset KEYTIMEOUT

# File limit
ulimit -n 10240

