#!/usr/bin/env bash
set -euo pipefail

# Install zsh and switch the current user's login shell to it
if ! command -v zsh >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y zsh
fi

ZSH_PATH="$(command -v zsh)"
if ! grep -qx "${ZSH_PATH}" /etc/shells; then
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells >/dev/null
fi

if [ "${SHELL:-}" != "${ZSH_PATH}" ]; then
    sudo chsh -s "${ZSH_PATH}" "$(whoami)"
    echo "Login shell changed to ${ZSH_PATH} (effective on next login)"
fi
