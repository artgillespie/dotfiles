#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "  backed up existing file: $dst -> $backup"
  fi
  ln -sf "$src" "$dst"
  echo "  linked: $dst"
}

echo "Installing dotfiles from $DOTFILES ..."

# ── shell ──────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/zshrc" "$HOME/.zshrc"
symlink "$DOTFILES/zprofile" "$HOME/.zprofile"
symlink "$DOTFILES/p10k.zsh" "$HOME/.p10k.zsh"

# ── git ────────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/gitconfig" "$HOME/.gitconfig"

# ── tmux ───────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
symlink "$DOTFILES/config/tmux/yank.sh" "$HOME/.config/tmux/yank.sh"

# ── nvim ───────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/config/nvim" "$HOME/.config/nvim"

# ── ghostty ────────────────────────────────────────────────────────────────────
symlink "$DOTFILES/config/ghostty/config" "$HOME/.config/ghostty/config"
if [[ "$(uname)" == "Darwin" ]]; then
  symlink "$DOTFILES/config/ghostty/config" \
    "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
fi

symlink "$DOTFILES/src/dotfiles/.local/bin/scopy" "$HOME/src/dotfiles/.local/bin/scopy"

echo ""
echo "Done."
echo ""
echo "Don't forget to create ~/.gitconfig.local with your identity:"
echo "  [user]"
echo "      name  = Your Name"
echo "      email = you@example.com"
