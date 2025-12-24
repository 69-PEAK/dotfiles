#!/bin/zsh

# Set PATH explicitly (launchd doesn't load from . zshrc)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin: $PATH"

# Organized folder structure
BACKUP_DIR="$HOME/backup/brew"
MARKER_FILE="$BACKUP_DIR/.backup_done_today"
TODAY=$(date +%Y-%m-%d)

# Only run once per day
if [ -f "$MARKER_FILE" ] && [ "$(cat "$MARKER_FILE" 2>/dev/null)" = "$TODAY" ]; then
    echo "$(date): Backup already done today" >&2
    exit 0
fi

# Create directory structure
mkdir -p "$BACKUP_DIR"

# Output file
OUTPUT_FILE="$BACKUP_DIR/brew_backup.csv"

# Delete old CSV
[ -f "$OUTPUT_FILE" ] && rm "$OUTPUT_FILE"

# CSV header
echo "Name,Type,Version" > "$OUTPUT_FILE"

# Backup formulas
brew list --formula --versions 2>/dev/null | while read -r line; do
    NAME=$(echo "$line" | awk '{print $1}')
    VERSION=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
    echo "\"$NAME\",\"Formula\",\"$VERSION\"" >> "$OUTPUT_FILE"
done

# Backup casks
brew list --cask --versions 2>/dev/null | while read -r line; do
    NAME=$(echo "$line" | awk '{print $1}')
    VERSION=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
    echo "\"$NAME\",\"Cask\",\"$VERSION\"" >> "$OUTPUT_FILE"
done

# Mark as done
echo "$TODAY" > "$MARKER_FILE"

exit 0