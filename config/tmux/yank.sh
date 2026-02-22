#!/usr/bin/env bash
# tmux yank helper
# - Over SSH: writes to clipboard via OSC 52 (wrapped in DCS passthrough for tmux)
# - Locally:  pipes to pbcopy

buf=$(cat)

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    encoded=$(printf '%s' "$buf" | base64 | tr -d '\n')
    # We are always inside tmux here, so wrap OSC 52 in a DCS passthrough.
    # tmux strips one ESC layer, so the inner ESC must be doubled.
    printf '\033Ptmux;\033\033]52;c;%s\007\033\\' "$encoded"
else
    printf '%s' "$buf" | pbcopy
fi
