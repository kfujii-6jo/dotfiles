# dotfiles

Personal dotfiles for macOS.

## Structure

```
dotfiles/
├── .claude/
│   ├── agents/             # Claude Code custom agents
│   │   ├── performance-reviewer.md
│   │   └── security-reviewer.md
│   ├── commands/           # Claude Code slash commands
│   │   ├── commit.md
│   │   ├── debug.md
│   │   ├── explain.md
│   │   ├── quick-review.md
│   │   └── refactor.md
│   └── skills/             # Claude Code skills
│       ├── clean-code/
│       └── git-workflow/
├── .config/
│   └── nvim/               # Neovim configuration
├── .tmux.conf              # tmux configuration
└── README.md
```

## What's included

### Claude Code (.claude)

Custom configurations for Claude Code CLI:

- **agents/**: Custom agents for specialized tasks
  - `security-reviewer.md`: Security review agent
  - `performance-reviewer.md`: Performance review agent
- **commands/**: Slash commands for quick actions
  - `/commit`: Generate commit messages
  - `/debug`: Debug assistance
  - `/explain`: Code explanation
  - `/quick-review`: Quick code review
  - `/refactor`: Refactoring suggestions
- **skills/**: Reusable skills
  - `clean-code`: Clean code practices
  - `git-workflow`: Git workflow patterns

### Neovim (.config/nvim)

- Lazy.nvim plugin manager
- LSP support
- fzf integration
- Custom keymaps

### tmux (.tmux.conf)

- Custom key bindings
- Status bar configuration
