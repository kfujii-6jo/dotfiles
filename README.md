# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).
Runtimes and binary tools are managed with [mise](https://mise.jdx.dev/);
global npm packages are tracked in `package.json`.

Configured: zsh, tmux, Neovim, Ghostty, lazygit, gitui, Karabiner-Elements,
Zed, herdr, Claude Code, Codex, Pi, and oh-my-pi.

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
skills, tracking each upstream's default branch. `dot_apm/private_apm.lock.yaml`
pins resolved commits and records files and deployment ownership. APM deploys to
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

To update all skills to the latest upstream versions and save the resulting
lockfile back into this repository:

```bash
bash scripts/update-skills.sh
```

The script runs `apm update --global --yes`, then `chezmoi add` for the lockfile.
Review and commit the resulting diff. To preview available updates, run
`mise exec -- apm update --global --dry-run`.
Ordinary `chezmoi apply` does not install or update skills. To roll back,
restore the previous manifest and lockfile and run the install script again.
Do not edit APM's deployed copies.

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

After installing Herdr on a new machine, and after each Herdr upgrade, install
its Codex integration with the official command:

```bash
herdr integration install codex
herdr integration status
```

Herdr owns `~/.codex/herdr-agent-state.sh` and `~/.codex/hooks.json`.
Both are excluded from chezmoi; do not copy them into this repository.
`chezmoi apply` does not install or update this integration.

## Pi

[Pi](https://github.com/earendil-works/pi) is tracked as an npm global in
`package.json`. Install it on an existing machine with:

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Run `pi` in a project directory, use `/login` to connect a model provider,
then `/model` to choose a model. Resume the latest session with `pi --continue`.

## oh-my-pi

[oh-my-pi](https://github.com/can1357/oh-my-pi) is installed as a release binary
through mise, pinned in `private_dot_config/mise/config.toml`.
Install it on an existing machine with:

```bash
chezmoi diff ~/.config/mise/config.toml
chezmoi apply ~/.config/mise/config.toml
mise install github:can1357/oh-my-pi
```

Run `omp` to start. Use `omp config list` to inspect available settings, or
`/settings` inside a session. Global settings live in `~/.omp/agent/config.yml`;
project settings live in `.omp/config.yml`. These are separate from Pi's settings.

`dot_omp/private_agent/private_config.yml` tracks the global settings, including
`advisor.enabled: true`. OMP writes this file itself; after changing settings in
OMP, run `chezmoi add ~/.omp/agent/config.yml` to capture them before applying
dotfiles again. Credentials, databases, and session history are not tracked.

`dot_omp/private_agent/WATCHDOG.yml` deploys the user-wide advisor roster to
`~/.omp/agent/WATCHDOG.yml`: Advisor Astra uses
`openai-codex/gpt-6-astra:xhigh` and reviews final yields (`agent-end`), with the
default interval of 1 and asynchronous review (`syncBacklog: off`).
Project rosters can override advisors with the same name.
Use `/advisor status` to inspect the runtime; `/advisor on` and `/advisor off`
only change the current session, not the saved enabled setting.
