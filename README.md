# dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).
Runtimes and CLI tools, including npm packages, use [mise](https://mise.jdx.dev/).

Includes zsh, tmux, Neovim, Ghostty, lazygit, gitui, Karabiner-Elements,
Zed, Herdr, Claude Code, Codex, Pi, and oh-my-pi.

## Setup

On a fresh Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/kfujii-6jo/dotfiles/main/scripts/setup-macos.sh | bash
source ~/.zshrc
```

The script installs Homebrew, mise, and managed tools, and keeps the checkout
at `~/ghq/github.com/kfujii-6jo/dotfiles`.

For manual setup, install [chezmoi](https://www.chezmoi.io/install/), mise,
and [ghq](https://github.com/x-motemen/ghq), then:

```bash
ghq get github.com/kfujii-6jo/dotfiles
cd ~/ghq/github.com/kfujii-6jo/dotfiles
chezmoi init --source="$PWD"
chezmoi apply
mise install
```

## Update

```bash
cd ~/ghq/github.com/kfujii-6jo/dotfiles
git pull
chezmoi diff
chezmoi apply
mise install
```

Edit managed files in this repository. For settings rewritten by an app,
inspect the diff before choosing `chezmoi add` to import or `chezmoi apply`
to deploy. See [repository conventions](AGENTS.md).

## Shared skills

APM deploys the pinned skills to `~/.claude/skills` and `~/.agents/skills`
(Codex and Pi). From the checkout, after `mise install`:

```bash
gh auth login                    # if needed for the private skills repository
bash scripts/install-skills.sh   # restore pinned versions
```

To update upstream versions, run `bash scripts/update-skills.sh`, then review
and commit the lockfile diff. Ordinary `chezmoi apply` does not install skills.
Edit skills upstream, not in APM's deployed directories. To roll back, restore
the previous manifest and lockfile, then run the install script again.

## Agents

Run `pi` or `omp` directly. Use `pp research` for read-only research or
`pp default` for ordinary Pi. Run `/login` separately in the research profile;
do not copy OAuth credentials between environments. See the
[research instructions](dot_pi/private_profiles/research/AGENTS.md).

After installing or upgrading Herdr, install the integrations you use:

```bash
herdr integration install codex
herdr integration install pi
herdr integration install omp
herdr integration status
```

Herdr owns these integration files; `chezmoi apply` does not install them.
Start new Pi/OMP sessions inside Herdr after installation.

## Configuration

| Area | Source |
| --- | --- |
| Runtimes and CLI tools | [mise config](private_dot_config/mise/config.toml) |
| App settings | [private_dot_config/](private_dot_config/) |
| Shell and tmux | [zsh](dot_zshrc.tmpl), [tmux](dot_tmux.conf.tmpl) |
| Launchers | [dot_local/bin/](dot_local/bin/) |
| Agent defaults | [Codex](.chezmoitemplates/codex-config.toml), [Pi](dot_pi/private_agent/modify_private_settings.json), [OMP](.chezmoitemplates/omp-config.yml) |
| Agent instructions | [shared fragments](dot_agents/instructions/) |
| Skills | [APM manifest](dot_apm/apm.yml) |
