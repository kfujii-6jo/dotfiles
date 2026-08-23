# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).
Runtimes and binary tools are managed with [mise](https://mise.jdx.dev/);
global npm packages are tracked in `package.json`.

Configured: zsh, tmux, Neovim, Ghostty, lazygit, gitui, Karabiner-Elements,
Zed, herdr, and Claude Code.

## Setup

### macOS

No prerequisites — the script installs Homebrew, mise, ghq, every mise-managed
tool, applies the dotfiles, and installs the npm globals:

```bash
curl -fsSL https://raw.githubusercontent.com/kfujii-6jo/dotfiles/main/scripts/setup-macos.sh | bash
source ~/.zshrc
```

### Manual

Install [chezmoi](https://www.chezmoi.io/install/),
[mise](https://mise.jdx.dev/) and [ghq](https://github.com/x-motemen/ghq),
clone this repo to `~/ghq/github.com/kfujii-6jo/dotfiles`, then:

```bash
mise install
chezmoi init --source="$PWD"
chezmoi apply
```

## Updating

```bash
cd ~/ghq/github.com/kfujii-6jo/dotfiles
git pull
chezmoi apply
```

Run `chezmoi diff` first to see what would change in your home directory.
