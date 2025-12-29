# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Requirements

- [chezmoi](https://www.chezmoi.io/install/)
- [mise](https://mise.jdx.dev/) (for runtime version management)

## Setup

```bash
git clone https://github.com/kfujii-6jo/dotfiles.git
cd dotfiles

# Ubuntu
./scripts/setup-ubuntu.sh

# macOS
./scripts/setup-macos.sh
```

**Ubuntu:** git, tmux, vim, xclip, Neovim (nightly), mise

**macOS:** Homebrew, git, tmux, vim, neovim, mise

## Installation

```bash
chezmoi init https://github.com/kfujii-6jo/dotfiles.git
chezmoi apply
```

## Structure

```
dotfiles/
├── dot_claude/                 # ~/.claude
│   ├── agents/
│   ├── commands/
│   └── skills/
├── dot_local/bin/              # ~/.local/bin
│   ├── claude.d/
│   └── launchws
├── dot_tmux.conf.tmpl          # ~/.tmux.conf (template)
├── dot_zshrc.tmpl              # ~/.zshrc (template)
└── private_dot_config/         # ~/.config
    ├── mise/
    └── nvim/
```

## What's included

### zsh (dot_zshrc.tmpl)

- oh-my-zsh with agnoster theme
- OS-specific aliases (Linux: open, pbcopy, pbpaste)
- Common aliases (vim→nvim, repo navigation with ghq/fzf)
- mise integration

### tmux (dot_tmux.conf.tmpl)

- Prefix key: `C-q` (macOS only)
- vi-mode key bindings
- OS-specific clipboard integration
- Custom status bar

### Neovim (private_dot_config/nvim)

- Lazy.nvim plugin manager
- LSP support (mason, lspconfig)
- fzf integration
- Claude Code integration
- Custom keymaps

### mise (private_dot_config/mise)

- Runtime version management configuration

### .local/bin (dot_local/bin)

- **launchws**: tmux workspace launcher (ghq/fzf integration)
- **claude.d/**: Claude CLI helper scripts
  - `commit`: Generate commit message and commit staged changes
  - `flow`: Review → commit workflow
  - `pr`: PR review helper
  - `review`: Code review helper

### Claude Code (dot_claude)

- **agents/**: Custom agents (security-reviewer, performance-reviewer)
- **commands/**: Slash commands (/commit, /debug, /explain, /quick-review, /refactor)
- **skills/**: Reusable skills (clean-code, git-workflow)
