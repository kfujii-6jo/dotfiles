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
│   ├── agents/                 # カスタムエージェント
│   │   └── reviewer/           # レビュー系エージェント
│   ├── commands/               # スラッシュコマンド
│   ├── skills/                 # 再利用可能スキル
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

- **repo**: リポジトリ選択・tmuxセッション起動 (ghq/fzf integration)
- **wt**: git worktree管理 (新規作成/選択/削除、tmux連携)

### Claude Code (dot_claude)

- **agents/**: カスタムエージェント
  - api-designer, database-architect, devops-engineer
  - documentation-expert, refactoring-advisor, test-strategist
  - reviewer/ (architecture, maintainability, performance, security)
- **commands/**: スラッシュコマンド
  - /commit, /quick-review, /deep-review
  - /docs-sync, /start-impl, /start-research
- **skills/**: 再利用可能スキル
  - clean-code, git-workflow
  - error-handling, logging-observability, security-checklist
