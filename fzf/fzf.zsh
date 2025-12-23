# ============================================
# FZF Configuration
# ============================================

# --------------------------------------------
# Function wrapper to ensure images are cleared
# --------------------------------------------
fzf_with_preview() {
  fzf "$@"  # Run FZF with any arguments
  kitten icat --clear 2>/dev/null  # Clear images after FZF exits
}

# --------------------------------------------
# Catppuccin Mocha theme for fzf
# --------------------------------------------
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --multi
  --height=80%
  --layout=reverse
  --border=rounded
  --preview-window=right:60%:wrap
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-u:preview-half-page-up'
  --bind='ctrl-d:preview-half-page-down'
  --bind='esc:abort'
  --prompt='  '
  --pointer='▶'
  --marker='✓'
  --preview='~/.config/fzf/preview.sh {}'
"

# --------------------------------------------
# Use fd instead of find
# --------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --------------------------------------------
# CTRL-T: File search with preview
# --------------------------------------------
export FZF_CTRL_T_OPTS="
  --preview '~/.config/fzf/preview.sh {}'
  --preview-window=right:60%:wrap
"

# --------------------------------------------
# CTRL-R: Command history search
# --------------------------------------------
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window=down:3:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Press CTRL-Y to copy command into clipboard'
"

# --------------------------------------------
# ALT-C: Directory search with tree preview
# --------------------------------------------
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always {} | head -200'
  --preview-window=right:60%:wrap
"

# --------------------------------------------
# Aliases using the wrapper function
# --------------------------------------------

# Search in current directory with preview (images + text)
alias fzfp='fzf_with_preview --preview "~/.config/fzf/preview.sh {}"'

# Directory search with tree preview
alias fzfd='fd --type d --hidden --follow --exclude .git | fzf_with_preview --preview "eza --tree --level=2 --color=always {} | head -200"'

# Live grep search with ripgrep
alias fzfg='echo "" | fzf_with_preview --disabled --ansi \
  --bind "change:reload: rg --line-number --no-heading --color=always --smart-case --hidden --follow --glob \"!.git/*\" --glob \"!node_modules/*\" --glob \"!Library/*\" {q} || true" \
  --delimiter ":" \
  --preview "bat --color=always --style=numbers --highlight-line {2} {1} 2>/dev/null" \
  --preview-window "down:60%:wrap:+{2}-5" \
  --prompt="Search: " \
  --bind "ctrl-y:execute-silent(echo {} | pbcopy)"'
