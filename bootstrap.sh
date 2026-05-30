#!/usr/bin/env bash
# bootstrap.sh — install all tools needed for the dotfiles to work
#
# Run on a fresh machine BEFORE install.sh:
#   git clone git@github.com:artgillespie/dotfiles ~/src/dotfiles
#   ~/src/dotfiles/bootstrap.sh
#   ~/src/dotfiles/install.sh
#
# Safe to re-run: every step is idempotent.
set -euo pipefail

# ── helpers ────────────────────────────────────────────────────────────────────

info()  { echo "  → $*"; }
ok()    { echo "  ✓ $*"; }

has()   { command -v "$1" &>/dev/null; }
apt_ok() { dpkg -s "$1" &>/dev/null; }

is_linux()  { [[ "$(uname)" == "Linux" ]]; }
is_macos()  { [[ "$(uname)" == "Darwin" ]]; }

# ── 1. zsh ─────────────────────────────────────────────────────────────────────

if ! has zsh; then
    info "Installing zsh ..."
    if is_linux; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq zsh
    elif is_macos; then
        brew install zsh
    fi
    ok "zsh installed"
else
    ok "zsh already installed"
fi

# Change login shell to zsh (skip if already set)
CURRENT_SHELL=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')
if [[ "$CURRENT_SHELL" != */zsh ]]; then
    info "Setting login shell to zsh ..."
    sudo chsh -s "$(which zsh)" "$USER"
    ok "login shell changed"
else
    ok "login shell already zsh"
fi

# ── 2. Oh My Zsh ──────────────────────────────────────────────────────────────

ZSH="${ZSH:-$HOME/.oh-my-zsh}"
if [[ ! -d "$ZSH" ]]; then
    info "Installing Oh My Zsh ..."
    # RUNZSH=no  = don't auto-launch zsh at end of installer
    # CHSH=no    = we already handled chsh above
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh My Zsh installed"
else
    ok "Oh My Zsh already installed"
fi

# ── 3. Oh My Zsh plugins and themes ───────────────────────────────────────────

ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    info "Installing zsh-autosuggestions ..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    ok "zsh-autosuggestions installed"
else
    ok "zsh-autosuggestions already installed"
fi

# zsh-completions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]]; then
    info "Installing zsh-completions ..."
    git clone --depth=1 https://github.com/zsh-users/zsh-completions \
        "$ZSH_CUSTOM/plugins/zsh-completions"
    ok "zsh-completions installed"
else
    ok "zsh-completions already installed"
fi

# powerlevel10k
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    info "Installing powerlevel10k ..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
    ok "powerlevel10k installed"
else
    ok "powerlevel10k already installed"
fi

# ── 4. Neovim (latest, not the ancient apt version) ────────────────────────────

NVIM_VERSION="v0.12.2"  # bump this when a new stable release drops
NVIM_SHA256="31cf85945cb600d96cdf69f88bc68bec814acbff50863c5546adef3a1bcef260"
NVIM_DIR="/opt/nvim-linux-x86_64"
NVIM_BIN="/usr/local/bin/nvim"

if has nvim && nvim --version | head -1 | grep -q "$NVIM_VERSION"; then
    ok "neovim $NVIM_VERSION already installed"
elif [[ -d "$NVIM_DIR" ]] && "$NVIM_DIR/bin/nvim" --version 2>/dev/null | head -1 | grep -q "$NVIM_VERSION"; then
    # Dir exists and has the right version — just ensure the symlink is there
    sudo ln -sf "$NVIM_DIR/bin/nvim" "$NVIM_BIN"
    ok "neovim $NVIM_VERSION symlink refreshed"
else
    info "Installing neovim $NVIM_VERSION ..."
    TMPDIR=$(mktemp -d)
    curl -fSL -o "$TMPDIR/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
    echo "${NVIM_SHA256}  $TMPDIR/nvim.tar.gz" | sha256sum --check --status || {
        echo "checksum mismatch for nvim-linux-x86_64.tar.gz" >&2
        rm -rf "$TMPDIR"
        exit 1
    }
    sudo rm -rf "$NVIM_DIR"
    sudo tar xzf "$TMPDIR/nvim.tar.gz" -C /opt/
    sudo ln -sf "$NVIM_DIR/bin/nvim" "$NVIM_BIN"
    rm -rf "$TMPDIR"
    ok "neovim $NVIM_VERSION installed"
fi

# Remove apt's neovim if present (avoids version confusion)
if apt_ok neovim 2>/dev/null; then
    info "Removing apt neovim (we use the /opt build) ..."
    sudo apt-get remove -y -qq neovim neovim-runtime 2>/dev/null || true
    ok "apt neovim removed"
fi

# ── 5. lazygit ────────────────────────────────────────────────────────────────

LAZYGIT_VERSION="0.50.0"  # bump when a new release drops
LAZYGIT_DIR="/opt/lazygit"
LAZYGIT_BIN="/usr/local/bin/lazygit"

if has lazygit && lazygit --version 2>/dev/null | grep -q "$LAZYGIT_VERSION"; then
    ok "lazygit $LAZYGIT_VERSION already installed"
else
    info "Installing lazygit $LAZYGIT_VERSION ..."
    TMPDIR=$(mktemp -d)
    curl -fSL -o "$TMPDIR/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo rm -rf "$LAZYGIT_DIR"
    sudo mkdir -p "$LAZYGIT_DIR"
    sudo tar xzf "$TMPDIR/lazygit.tar.gz" -C "$LAZYGIT_DIR" lazygit
    sudo ln -sf "$LAZYGIT_DIR/lazygit" "$LAZYGIT_BIN"
    rm -rf "$TMPDIR"
    ok "lazygit $LAZYGIT_VERSION installed"
fi

# ── 6. Misc build essentials ───────────────────────────────────────────────────

if is_linux; then
    PKGS=(git curl fzf tmux ripgrep fd-find unzip build-essential)
    MISSING=()
    for p in "${PKGS[@]}"; do
        apt_ok "$p" || MISSING+=("$p")
    done
    if [[ ${#MISSING[@]} -gt 0 ]]; then
        info "Installing apt packages: ${MISSING[*]} ..."
        sudo apt-get install -y -qq "${MISSING[@]}"
        ok "apt packages installed"
    else
        ok "all apt packages already installed"
    fi

    # fd is installed as `fdfind` on Ubuntu — create the `fd` symlink if missing
    if has fdfind && ! has fd; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
        ok "fd symlink created"
    fi
fi

# ── done ───────────────────────────────────────────────────────────────────────

echo ""
echo "Bootstrap complete! Next steps:"
echo ""
echo "  1. Run:   ~/src/dotfiles/install.sh"
echo "  2. Create ~/.gitconfig.local with your identity"
echo "  3. Log out and back in (or exec zsh) to start using zsh + p10k"
echo ""
