# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).
Runtimes and binary tools are managed with [mise](https://mise.jdx.dev/);
global npm packages are tracked in `package.json`.

Configured: zsh, tmux, Neovim, Ghostty, lazygit, gitui, Karabiner-Elements,
Zed, herdr, Claude Code, and Codex.

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

## Shared skills (APM)

APM 0.33.0 is installed through mise. `dot_apm/apm.yml` declares all 26 user
skills, pinned to full Git commit hashes. `dot_apm/private_apm.lock.yaml`
records resolved files and deployment ownership. APM deploys to
`~/.claude/skills/` and `~/.agents/skills/` (shared by Codex and Pi).
All user skill directories are excluded from chezmoi; edit skills at their
upstream repository instead. Built-in and plugin-provided skills remain owned
by their respective applications.

Sources: `kfujii-6jo/skills` (5 Git workflows), `cloudflare/skills` (11),
`mattpocock/skills` (2), `subsy/ralph-tui` (4), and one each from
`mizchi/skills`, `herdrdev/herdr`, `coji/natural-japanese`, and `vercel-labs/skills`.
`clean_gone` is now `clean-gone`. The old `sandbox-sdk` is replaced by
`sandbox-stable`, `sandbox-next`, and `sandbox-migrate-to-next`.
`finish-branch`, `learning-check`, and Sanity skills have been removed.

After applying the mise configuration and running `mise install`, authenticate
GitHub access with `gh auth login` if needed (the personal skills repo is private),
then restore the pinned skills:

```bash
bash scripts/install-skills.sh
```

Ordinary `chezmoi apply` does not install or update skills. To update intentionally,
change the full commit pin in `dot_apm/apm.yml`, apply that manifest, then run
`apm install --global` and `chezmoi add ~/.apm/apm.lock.yaml`. Review and commit
the manifest and lockfile together. To roll back, restore their previous versions
and run the install script again. Do not edit APM's deployed copies.

Installation and discovery are verified separately from workflow behavior.
Some upstream skills still use agent-specific instructions; APM deploys them
without translating those instructions.

## Codex

`.chezmoitemplates/codex-config.toml` declares the portable Codex defaults.
`dot_codex/modify_private_config.toml` merges them into `~/.codex/config.toml`
using chezmoi's built-in TOML functions, preserving settings written by Codex
Desktop. Add settings to the defaults file; the merge template needs no changes.
Routine workspace operations run automatically; operations needing approval
go through AI review (`approvals_reviewer = "auto_review"`).
`dot_codex/private_rules/default.rules` carries the shared command allow/deny
policy.
`dot_codex/AGENTS.md` provides the global working agreements for Codex.

## Pi

[Pi](https://github.com/earendil-works/pi) is tracked as an npm global in
`package.json`. Install it on an existing machine with:

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Run `pi` in a project directory, use `/login` to connect a model provider,
then `/model` to choose a model. Resume the latest session with `pi --continue`.
