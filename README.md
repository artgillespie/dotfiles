# dotfiles

Personal dotfiles for macOS and Linux, managed with symlinks.

## What's tracked

```
install.sh              — run on a fresh machine to set up all symlinks
bin/add_to_dotfiles     — utility to add new configs safely
zshrc / zprofile        — portable shell config
tmux.conf               — tmux config
config/tmux/yank.sh
config/nvim/            — lazyvim config
config/ghostty/config   — ghostty config (macOS Library path handled by install.sh)
gitconfig               — includes ~/.gitconfig.local for machine identity
```

## What stays local (gitignored, never tracked)

| File | Purpose |
|---|---|
| `~/.zshrc.local` | Machine-specific shell config (aliases, completions, etc.) |
| `~/.zprofile.local` | Machine-specific profile (e.g. brew shellenv on macOS) |
| `~/.gitconfig.local` | Git identity (name, email) |

The tracked files source the `.local` variants if present, and are silent no-ops
if they don't exist — so a fresh clone works before any locals are created.

## Fresh machine setup

```sh
git clone git@github.com:artgillespie/dotfiles ~/src/dotfiles
~/src/dotfiles/install.sh
```

Then create the machine-local files manually:

**`~/.gitconfig.local`**
```ini
[user]
    name  = Your Name
    email = you@example.com
```

**`~/.zprofile.local`** (macOS/Homebrew)
```sh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

**`~/.zshrc.local`** — anything machine-specific: Docker completions, app aliases, etc.

## Adding a new config

```sh
add_to_dotfiles ~/.config/some-tool/config
```

This will:
1. Scan the file (or directory) for secrets using `pi`
2. Move it into `~/src/dotfiles/`, mirroring its path relative to `$HOME`
3. Symlink the original location back to dotfiles
4. Append the symlink call to `install.sh`

Then review and commit:
```sh
git -C ~/src/dotfiles diff
git -C ~/src/dotfiles commit -am "add some-tool config"
```

## Machine topology

| Machine | Configs used |
|---|---|
| Home mac mini | zsh, tmux, nvim, git |
| Home MBA | zsh, ghostty |
| Work Linux workstation | zsh, tmux, nvim, git |
| Work MacBook Pro | zsh, ghostty |

Work and home share the same tracked configs. All machine-specific and
credential differences live in the gitignored `.local` files.
