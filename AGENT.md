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

## Claude Code configuration (`dot_claude/`)

- Skills under `dot_claude/skills/` are deployed by chezmoi. `grill-me` and
  `grilling` are vendored from [mattpocock/skills](https://github.com/mattpocock/skills)
  (MIT), and `empirical-prompt-tuning` is from
  [mizchi/skills](https://github.com/mizchi/skills) (MIT). Do not edit them by hand.
- `settings.json` carries `enabledPlugins` and `extraKnownMarketplaces` so a
  fresh machine restores its plugins on `chezmoi apply`. Claude Code writes the
  file itself, so follow the `chezmoi add` rule above.

## Codex configuration (`dot_codex/`)

- `modify_private_config.toml` manages portable user preferences and enables
  Codex hooks. Preserve the trusted projects, plugins, runtime paths,
  notifications, and UI state that Codex Desktop writes to
  `~/.codex/config.toml`.
- `private_hooks.json` and `executable_herdr-agent-state.sh` vendor Herdr's
  Codex SessionStart integration. After upgrading Herdr, run
  `herdr integration install codex`, inspect the generated files, and pull
  safe changes into chezmoi.
- `dot_codex/AGENTS.md` contains global instructions for Codex. Differences
  from `dot_claude/CLAUDE.md` are intentional.
