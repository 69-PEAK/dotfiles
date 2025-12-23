#!/usr/bin/env bash

file="$1"

# Clear images using Kitty graphics protocol escape sequence directly
# This sends the "delete all images" command
printf '\033_Ga=d,d=A\033\\'

[[ -z "$file" ]] && exit 0

if file -b --mime-type "$file" 2>/dev/null | grep -q '^image/'; then
    kitten icat \
        --transfer-mode=memory \
        --stdin=no \
        --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" \
        "$file" 2>/dev/null
else
    bat --color=always --style=numbers "$file" 2>/dev/null || cat "$file"
fi