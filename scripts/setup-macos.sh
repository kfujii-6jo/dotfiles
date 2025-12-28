#!/bin/bash
set -euo pipefail

echo "=== macOS Setup Script ==="

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages
echo "Installing packages..."
brew install git tmux vim neovim

# Install mise
echo "Installing mise..."
curl https://mise.run | sh

# Add mise activation to zshrc if not already
if ! grep -q 'mise activate' ~/.zshrc 2>/dev/null; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
fi

echo "=== Setup complete ==="
echo "Run 'source ~/.zshrc' or restart your shell"
