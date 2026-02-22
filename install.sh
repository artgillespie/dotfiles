#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        echo "  SKIP (real file exists, remove manually): $dst"
        return
    fi
    ln -sf "$src" "$dst"
    echo "  linked: $dst"
}

echo "Installing dotfiles from $DOTFILES ..."

# ── shell ──────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/zshrc"    "$HOME/.zshrc"
symlink "$DOTFILES/zprofile" "$HOME/.zprofile"

# ── git ────────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/gitconfig" "$HOME/.gitconfig"

# ── tmux ───────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/tmux.conf"              "$HOME/.tmux.conf"
symlink "$DOTFILES/config/tmux/yank.sh"   "$HOME/.config/tmux/yank.sh"

# ── nvim ───────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/config/nvim"            "$HOME/.config/nvim"

# ── ghostty ────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/config/ghostty/config"  "$HOME/.config/ghostty/config"
if [[ "$(uname)" == "Darwin" ]]; then
    symlink "$DOTFILES/config/ghostty/config" \
        "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
fi

echo ""
echo "Done."
echo ""
echo "Don't forget to create ~/.gitconfig.local with your identity:"
echo "  [user]"
echo "      name  = Your Name"
echo "      email = you@example.com"
