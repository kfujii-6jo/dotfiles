#!/bin/bash
set -euo pipefail

echo "=== Ubuntu Setup Script ==="

# Install packages
echo "Installing packages..."
sudo apt update
sudo apt install -y git tmux vim xclip

# Install Neovim (nightly)
echo "Installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# Add Neovim to PATH if not already
if ! grep -q '/opt/nvim-linux-x86_64/bin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >> ~/.zshrc
fi

# Install mise
echo "Installing mise..."
curl https://mise.run | sh

# Add mise activation to zshrc if not already
if ! grep -q 'mise activate' ~/.zshrc 2>/dev/null; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
fi

echo "=== Setup complete ==="
echo "Run 'source ~/.zshrc' or restart your shell"
