# dotfiles

Personal dotfiles repository managed with chezmoi and mise.

## Project Overview

This repository contains personal configuration files (dotfiles) for development environments. It uses:
- **chezmoi**: Dotfile management tool that handles templates and multiple machines
- **mise**: Runtime version manager (replaces asdf) for managing development tools
- **ghq**: Repository management tool for organizing Git repositories

## Repository Structure

```
dotfiles/
├── scripts/
│   ├── setup-macos.sh       # Automated setup script for macOS
│   └── setup-ubuntu.sh      # Setup script for Ubuntu
├── dot_claude/              # ~/.claude (Claude Code configuration)
│   ├── agents/              # Custom Claude Code agents
│   ├── commands/            # Slash commands
│   └── skills/              # Reusable skills
├── dot_local/bin/           # ~/.local/bin (custom scripts)
│   ├── repo                 # Repository selection with ghq/fzf
│   └── wt                   # Git worktree management
├── dot_tmux.conf.tmpl       # ~/.tmux.conf (template)
├── dot_zshrc.tmpl           # ~/.zshrc (template)
└── private_dot_config/      # ~/.config
    ├── mise/
    │   └── config.toml      # mise tool versions
    └── nvim/                # Neovim configuration
        └── lua/
```

## Setup Process (macOS)

The `scripts/setup-macos.sh` automates the entire setup process:

1. **Install Homebrew** (if not present)
   - Adds Homebrew to PATH for current session (Apple Silicon/Intel support)

2. **Install base packages via Homebrew**
   - git, tmux, vim, neovim

3. **Install mise**
   - Downloaded via curl from https://mise.run
   - Adds mise activation to ~/.zshrc

4. **Install ghq via mise**
   - Uses `mise use -g ghq@latest` to install globally

5. **Clone dotfiles repository**
   - Uses `ghq get github.com/kfujii-6jo/dotfiles`
   - Stored at `~/ghq/github.com/kfujii-6jo/dotfiles`

6. **Install mise-managed tools (first pass)**
   - Runs `mise install` in the cloned dotfiles directory
   - Installs tools defined in the repository's config.toml

7. **Apply dotfiles with chezmoi**
   - Initializes chezmoi with dotfiles as source
   - Runs `chezmoi apply` to deploy configuration files

8. **Reload mise configuration**
   - Runs `mise install` again from home directory
   - Ensures tools are installed using the applied ~/.config/mise/config.toml

## Managed Tools (via mise)

All tools are defined in `private_dot_config/mise/config.toml`:

**Languages & Runtimes:**
- go
- node
- python

**Development Tools:**
- chezmoi (dotfile management)
- gh (GitHub CLI)
- ghq (repository management)
- fzf (fuzzy finder)
- ripgrep (fast grep)
- bat (cat with syntax highlighting)
- gitui (Git TUI)

**Node.js Tools:**
- @anthropic-ai/claude-code
- turbo
- @fission-ai/openspec
- pnpm

**Go Tools:**
- github.com/k1LoW/git-wt (Git worktree helper)

**Other:**
- uv (Python package manager)
- stylua (Lua formatter)
- zellij (terminal multiplexer)

## Key Features

### Shell (zsh)
- oh-my-zsh with agnoster theme
- OS-specific aliases (Linux: open, pbcopy, pbpaste emulation)
- Common aliases (vim→nvim, repository navigation)
- mise integration

### tmux
- Prefix key: `C-q` (macOS only)
- vi-mode key bindings
- OS-specific clipboard integration
- Custom status bar

### Neovim
- Lazy.nvim plugin manager
- LSP support (mason, lspconfig)
- fzf integration
- Claude Code integration
- Custom keymaps

### Custom Scripts
- **repo**: Repository selection & tmux session launcher (ghq/fzf)
- **wt**: Git worktree management with tmux integration

## Usage

### Fresh macOS Setup
```bash
curl -fsSL https://raw.githubusercontent.com/kfujii-6jo/dotfiles/main/scripts/setup-macos.sh | bash
source ~/.zshrc
```

### Updating Dotfiles
```bash
cd ~/ghq/github.com/kfujii-6jo/dotfiles
git pull
chezmoi apply
```

### Adding New mise Tools
1. Edit `private_dot_config/mise/config.toml`
2. Commit and push changes
3. Run `mise install` on target machines

## Important Notes

- **Dotfiles location**: Always at `~/ghq/github.com/kfujii-6jo/dotfiles` (managed by ghq)
- **chezmoi source**: Points to the ghq-managed directory
- **Dual mise install**: Setup runs `mise install` twice - once from repo, once after chezmoi applies config
- **Template files**: Files with `.tmpl` extension are processed by chezmoi (e.g., OS-specific configs)
- **Private files**: Files prefixed with `private_dot_` are not tracked in git history

## Chezmoi Commands Reference

```bash
# View changes before applying
chezmoi diff

# Apply dotfiles
chezmoi apply

# Edit a file (opens template)
chezmoi edit ~/.zshrc

# Add a new file to dotfiles
chezmoi add ~/.newfile

# Update from repository
cd ~/ghq/github.com/kfujii-6jo/dotfiles
git pull
chezmoi apply
```

## Git Workflow

Since dotfiles are managed via ghq, the workflow is:

```bash
# Navigate to dotfiles
cd ~/ghq/github.com/kfujii-6jo/dotfiles

# Make changes
chezmoi edit ~/.zshrc

# See what changed
chezmoi diff

# Apply locally
chezmoi apply

# Commit and push
git add .
git commit -m "Update zshrc"
git push
```
