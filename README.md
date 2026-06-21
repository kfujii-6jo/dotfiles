# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Requirements

For macOS, no prerequisites are required as the setup script will install everything automatically.

For manual setup, the following are required:
- [chezmoi](https://www.chezmoi.io/install/)
- [mise](https://mise.jdx.dev/) (for runtime version management)
- [ghq](https://github.com/x-motemen/ghq) (for repository management)

## Setup

### macOS

On a fresh macOS environment, run this one-liner to set up everything:

```bash
curl -fsSL https://raw.githubusercontent.com/kfujii-6jo/dotfiles/main/scripts/setup-macos.sh | bash
```

This script will automatically:
1. Install **Homebrew**
2. Install base packages (git, tmux, vim, neovim)
3. Install and configure **mise**
4. Install **ghq** and clone dotfiles to `~/ghq/github.com/kfujii-6jo/dotfiles`
5. Install all mise-managed tools
6. Apply dotfiles with **chezmoi**
7. Install global npm packages from `package.json`

After completion, reload your shell:

```bash
source ~/.zshrc
```

## Structure

```
dotfiles/
├── package.json                # Global npm packages
├── scripts/
│   └── setup-macos.sh          # Automated setup script for macOS
├── dot_claude/                 # ~/.claude (Claude Code configuration)
│   ├── settings.json           # Claude Code settings
│   └── skills/                 # Custom skills
│       ├── commit/             # Create a git commit
│       ├── commit-push-pr/     # Commit, push, and open a PR
│       └── clean_gone/         # Clean up [gone] branches
├── dot_gitconfig               # ~/.gitconfig
├── dot_local/bin/              # ~/.local/bin
│   ├── executable_trp          # Repository selection & tmux session launcher
│   └── executable_twt          # Git worktree selection & tmux window manager
├── dot_tmux.conf.tmpl          # ~/.tmux.conf (template)
├── dot_zshrc.tmpl              # ~/.zshrc (template)
└── private_dot_config/         # ~/.config
    ├── mise/
    │   └── config.toml         # mise tool versions (runtimes & binary tools)
    ├── nvim/                   # Neovim configuration
    ├── nvim-dev/               # Neovim dev config
    ├── ghostty/                # Ghostty terminal configuration
    ├── lazygit/                # lazygit configuration
    ├── gitui/                  # gitui theme
    ├── karabiner/              # Karabiner-Elements configuration
    └── vscode-nvim/            # VSCode Neovim configuration
```

## What's included

### zsh (dot_zshrc.tmpl)

- oh-my-zsh with agnoster theme
- Common aliases (vim→nvim, repo navigation with ghq/fzf)
- mise integration

### tmux (dot_tmux.conf.tmpl)

- Prefix key: `C-s`
- vi-mode key bindings
- macOS clipboard integration (pbcopy)
- Custom status bar

### Neovim (private_dot_config/nvim)

- Lazy.nvim plugin manager
- LSP support (mason, lspconfig)
- fzf integration
- Claude Code integration
- Custom keymaps

### mise (private_dot_config/mise/config.toml)

Manages runtimes and binary tools:

**Languages & Runtimes:** go, node, python, rust, bun

**Binary Tools:** chezmoi, gh, ghq, delta, lazygit, fzf, ripgrep, bat, gcloud, stylua, tree-sitter

**Go Tools:** github.com/k1LoW/git-wt

### npm globals (package.json)

Global npm packages managed via `package.json`:
- `@anthropic-ai/claude-code`
- `@beads/bd`
- `@fission-ai/openspec`
- `@openai/codex`
- `pnpm`
- `takt`

### Claude Code (dot_claude)

- **settings.json**: permissions, model (opus), plugins
- **skills/commit**: Create a git commit following repository conventions
- **skills/commit-push-pr**: Commit, push, and open a PR
- **skills/clean_gone**: Clean up locally stale [gone] branches

### .local/bin (dot_local/bin)

- **trp**: Repository selection & tmux session launcher (ghq/fzf integration)
- **twt**: Git worktree selection & tmux window manager
