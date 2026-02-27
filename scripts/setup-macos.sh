#!/bin/bash
set -euo pipefail

echo "=== macOS Setup Script ==="

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for current session
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Install packages
echo "Installing packages..."
brew install \
  git \
  tmux \
  vim \
  neovim \
  xwmx/taps/nb \
  bash

# Install mise
echo "Installing mise..."
curl https://mise.run | sh

# Add mise activation to zshrc if not already
if ! grep -q 'mise activate' ~/.zshrc 2>/dev/null; then
  echo 'eval "$(~/.local/bin/mise activate zsh)"' >>~/.zshrc
fi

# Install ghq first to clone dotfiles
echo "Installing ghq..."
~/.local/bin/mise use -g ghq@latest

# Clone dotfiles repository with ghq
echo "Cloning dotfiles repository..."
DOTFILES_REPO="github.com/kfujii-6jo/dotfiles"
if [ ! -d ~/ghq/$DOTFILES_REPO ]; then
  ~/.local/bin/mise exec -- ghq get $DOTFILES_REPO
fi

DOTFILES_DIR=~/ghq/$DOTFILES_REPO

# Install mise-managed tools from dotfiles config
echo "Installing mise-managed tools..."
cd "$DOTFILES_DIR"
~/.local/bin/mise install

# Initialize and apply chezmoi
echo "Applying dotfiles with chezmoi..."
if [ ! -d ~/.local/share/chezmoi ]; then
  echo "Initializing chezmoi with $DOTFILES_DIR"
  ~/.local/bin/mise exec -- chezmoi init --source="$DOTFILES_DIR"
fi

echo "Running chezmoi apply..."
~/.local/bin/mise exec -- chezmoi apply

# Reload mise config and install tools again after chezmoi apply
echo "Reloading mise configuration from dotfiles..."
cd ~
~/.local/bin/mise install

echo "=== Setup complete ==="
echo "Run 'source ~/.zshrc' or restart your shell"
