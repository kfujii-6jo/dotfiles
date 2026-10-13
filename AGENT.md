# dotfiles agent instructions

Personal dotfiles are managed with chezmoi. Runtimes and binary tools come
from mise (`private_dot_config/mise/config.toml`); npm globals are tracked in
`package.json`. `scripts/setup-macos.sh` bootstraps a fresh machine.

## Conventions

- **The repository is the source of truth, not `~`.** Edit files here and run
  `chezmoi apply`. Do not edit the deployed copy in the home directory.
- **Exception: app-owned files.** Karabiner-Elements, Claude Code, and similar
  apps rewrite their own configuration. When the home copy is ahead, pull it
  in with `chezmoi add <path>`; `chezmoi apply` would overwrite it. Check the
  direction with `chezmoi diff` before either.
- This clone must stay at `~/ghq/github.com/kfujii-6jo/dotfiles`, because the
  chezmoi source directory points here.
- Filename prefixes are chezmoi's: `dot_` becomes `.`, `private_` is not
  world-readable, `executable_` becomes executable, and `.tmpl` is templated.
- Unless told otherwise, commit on `main` and push directly to it; do not
  create a branch or pull request.

## Applying changes

```bash
chezmoi diff
chezmoi apply
chezmoi apply ~/.config/nvim/init.lua
chezmoi add ~/.claude/settings.json
git pull && chezmoi apply
```

`chezmoi apply` prompts before overwriting a file that changed in `~` since
chezmoi last wrote it. Confirm the diff is safe, then re-run with `--force`.

## Adding tools

- mise tool: edit `private_dot_config/mise/config.toml`, then run `mise install`.
- npm global: add it to `package.json`, then run `npm install -g <package>`.

## Shared skills and Claude Code configuration

- All user skills are managed by APM through `dot_apm/apm.yml` and
  `dot_apm/private_apm.lock.yaml`. Edit self-authored skills in
  `~/ghq/github.com/kfujii-6jo/skills`; update external skills at their upstream.
- Run `bash scripts/install-skills.sh` to restore the pinned versions into
  `~/.claude/skills` and `~/.agents/skills` (Codex and Pi). Do not add deployed
  skills to chezmoi or recreate separate copies under `~/.codex/skills`.
- Run `bash scripts/update-skills.sh` to update all skills from their upstream
  branches and save the new lockfile into chezmoi. Review and commit the diff.
- `dot_claude/settings.json` carries `enabledPlugins` and
  `extraKnownMarketplaces`. Claude Code writes it itself, so follow the
  `chezmoi add` rule above. Plugin-provided skills keep their plugin lifecycle.

## Codex configuration (`dot_codex/`)

- `.chezmoitemplates/codex-config.toml` declares portable Codex defaults.
  `modify_private_config.toml` merges them into `~/.codex/config.toml` and
  enables Codex hooks, while preserving the trusted projects, plugins, runtime
  paths, notifications, and UI state that Codex Desktop writes.
- `dot_codex/private_rules/default.rules` holds the shared command allow/deny
  policy. Update it alongside `dot_claude/settings.json` when the policy changes.
- Herdr owns `~/.codex/herdr-agent-state.sh` and `~/.codex/hooks.json`;
  both are excluded from chezmoi. After installing or upgrading Herdr, run
  `herdr integration install codex`. Do not vendor or `chezmoi add` these files.
- `dot_codex/AGENTS.md` contains global instructions for Codex. Differences
  from `dot_claude/CLAUDE.md` are intentional.
