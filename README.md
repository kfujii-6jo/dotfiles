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
4. Install **ghq**
5. Clone dotfiles to `~/ghq/github.com/kfujii-6jo/dotfiles`
6. Install all mise-managed tools (defined in config.toml)
7. Apply dotfiles with **chezmoi**

After completion, reload your shell:

```bash
source ~/.zshrc
```

## Structure

```
dotfiles/
├── dot_claude/                 # ~/.claude
│   ├── agents/                 # Custom agents
│   │   └── reviewer/           # Review agents
│   ├── commands/               # Slash commands
│   ├── skills/                 # Reusable skills
│   └── settings.json
├── dot_local/bin/              # ~/.local/bin
│   ├── repo
│   └── wt
├── dot_tmux.conf.tmpl          # ~/.tmux.conf (template)
├── dot_zshrc.tmpl              # ~/.zshrc (template)
└── private_dot_config/         # ~/.config
    ├── mise/
    └── nvim/
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

### mise (private_dot_config/mise)

- Runtime version management configuration

### .local/bin (dot_local/bin)

- **repo**: Repository selection & tmux session launcher (ghq/fzf integration)
- **wt**: git worktree management (create/select/delete, tmux integration)

### Claude Code (dot_claude)

- **agents/**: Custom agents
  - api-designer, database-architect, devops-engineer
  - documentation-expert, refactoring-advisor, test-strategist
  - reviewer/ (architecture, maintainability, performance, security)
- **commands/**: Slash commands
  - /commit, /quick-review, /deep-review
  - /docs-sync, /start-impl, /start-research
- **skills/**: Reusable skills
  - clean-code, git-workflow
  - error-handling, logging-observability, security-checklist
