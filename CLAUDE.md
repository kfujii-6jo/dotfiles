# dotfiles

Personal dotfiles repository managed with chezmoi and mise.

## Project Overview

This repository contains personal configuration files (dotfiles) for development environments. It uses:
- **chezmoi**: Dotfile management tool that handles templates and multiple machines
- **mise**: Runtime version manager for runtimes and binary tools
- **ghq**: Repository management tool for organizing Git repositories

## Repository Structure

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
│       ├── clean_gone/         # Clean up [gone] branches
│       ├── grill-me/           # Relentless plan/design interview (vendored)
│       └── grilling/           # Interview engine behind grill-me (vendored)
├── dot_gitconfig               # ~/.gitconfig
├── dot_local/bin/              # ~/.local/bin (custom scripts)
│   ├── executable_trp          # Repository selection & tmux session launcher
│   └── executable_twt          # Git worktree selection & tmux window manager
├── dot_tmux.conf.tmpl          # ~/.tmux.conf (template)
├── dot_zshrc.tmpl              # ~/.zshrc (template)
└── private_dot_config/         # ~/.config
    ├── mise/
    │   └── config.toml         # mise tool versions
    ├── nvim/                   # Neovim configuration
    ├── nvim-dev/               # Neovim dev config
    ├── ghostty/                # Ghostty terminal configuration
    ├── lazygit/                # lazygit configuration
    ├── gitui/                  # gitui theme
    ├── karabiner/              # Karabiner-Elements configuration
    └── vscode-nvim/            # VSCode Neovim configuration
```

## Setup Process (macOS)

The `scripts/setup-macos.sh` automates the entire setup process:

1. **Install Homebrew** (if not present)
2. **Install base packages via Homebrew** — git, tmux, vim, neovim
3. **Install mise** — via curl from https://mise.run
4. **Install ghq via mise** — then clone dotfiles to `~/ghq/github.com/kfujii-6jo/dotfiles`
5. **Install mise-managed tools** — runs `mise install` from the dotfiles directory
6. **Apply dotfiles with chezmoi** — initializes and runs `chezmoi apply`
7. **Reload mise configuration** — runs `mise install` from home directory
8. **Install global npm packages** — reads `package.json` and runs `npm install -g`

## Managed Tools

### mise (`private_dot_config/mise/config.toml`)

**Languages & Runtimes:**
- go, node, python, rust, bun

**Binary Tools:**
- chezmoi, gh, ghq, delta, lazygit, fzf, ripgrep, bat, gcloud, stylua, tree-sitter

**Go Tools (via mise go backend):**
- `go:github.com/k1LoW/git-wt`

**Python Package Manager:**
- uv

### npm globals (`package.json`)

- `@anthropic-ai/claude-code`
- `@beads/bd`
- `@fission-ai/openspec`
- `@openai/codex`
- `pnpm`
- `takt`

## Key Features

### Shell (zsh)
- oh-my-zsh with agnoster theme
- Common aliases (vim→nvim, repository navigation)
- mise integration

### tmux
- Prefix key: `C-s`
- vi-mode key bindings
- macOS clipboard integration (pbcopy)
- Custom status bar

### Neovim
- Lazy.nvim plugin manager
- LSP support (mason, lspconfig)
- fzf integration
- Claude Code integration
- Custom keymaps

### Custom Scripts
- **trp**: Repository selection & tmux session launcher (ghq/fzf)
- **twt**: Git worktree selection & tmux window manager

### Claude Code Skills

Custom skills (vendored in `dot_claude/skills/`, deployed by chezmoi):
- **commit**: Create a git commit following repository conventions (model: haiku)
- **commit-push-pr**: Commit, push, and open a PR with Summary/Test plan format (model: haiku)
- **clean_gone**: Clean up locally stale [gone] branches (model: haiku)
- **grill-me** / **grilling**: Relentless one-question-at-a-time interview to stress-test a plan or design before building. `grill-me` is user-invoked (`/grill-me`) and delegates to `grilling`. Vendored from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

### Claude Code Plugins (marketplaces)

Enabled via `dot_claude/settings.json` (`enabledPlugins` + `extraKnownMarketplaces`), so a fresh machine restores them on `chezmoi apply`:
- **example-skills** — marketplace `anthropic-agent-skills` ([anthropics/skills](https://github.com/anthropics/skills)): sample skills (skill-creator, mcp-builder, design/art, webapp-testing, etc.)
- **feature-dev** — marketplace `claude-plugins-official` ([anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)): feature development agents (code-architect, code-explorer, code-reviewer)
- **ponytail** — marketplace `ponytail` ([DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)): "lazy senior dev" mode (YAGNI, stdlib first)

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

### Adding npm Global Packages
1. Add to `package.json` dependencies
2. Run `npm install -g <package>`
3. Commit and push

### Adding mise Tools
1. Edit `private_dot_config/mise/config.toml`
2. Run `mise install`
3. Commit and push

## Important Notes

- **Dotfiles location**: Always at `~/ghq/github.com/kfujii-6jo/dotfiles` (managed by ghq)
- **chezmoi source**: Points to the ghq-managed directory
- **Template files**: Files with `.tmpl` extension are processed by chezmoi
- **Private files**: Files prefixed with `private_dot_` are not tracked in git history
- **Tool management split**: mise handles runtimes and binary tools; npm globals are tracked in `package.json`

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
```
