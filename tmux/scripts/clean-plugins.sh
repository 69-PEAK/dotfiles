#!/usr/bin/env bash

# Tmux plugin cleaner - removes unused plugins in tmux conf

TMUX_CONF="$HOME/.config/tmux/tmux.conf"
PLUGIN_DIR="$HOME/.config/tmux/plugins"

# Check if config exists
if [ ! -f "$TMUX_CONF" ]; then
  echo "❌ Tmux config not found at:  $TMUX_CONF"
  exit 1
fi

# Check if plugin directory exists
if [ ! -d "$PLUGIN_DIR" ]; then
  echo "❌ Plugin directory not found at: $PLUGIN_DIR"
  exit 1
fi

# Get list of plugins from config
declared_plugins=$(grep "set -g @plugin" "$TMUX_CONF" | sed "s/.*'\(.*\)'.*/\1/" | sed "s/.*\"\(.*\)\".*/\1/" | awk -F'/' '{print $NF}')

# Collect removed plugins
removed_plugins=()

# Loop through installed plugins
for plugin_path in "$PLUGIN_DIR"/*; do
  [ -d "$plugin_path" ] || continue
  
  plugin_name=$(basename "$plugin_path")
  
  # Skip tpm itself
  if [ "$plugin_name" = "tpm" ]; then
    continue
  fi
  
  # Check if plugin is declared in config
  if ! echo "$declared_plugins" | grep -q "^${plugin_name}$"; then
    rm -rf "$plugin_path"
    removed_plugins+=("$plugin_name")
  fi
done

# Only show output if plugins were removed
if [ ${#removed_plugins[@]} -gt 0 ]; then
  echo "🧹 Cleaned plugins: ${removed_plugins[*]}"
fi