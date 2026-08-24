# dotfiles

Personal dotfiles managed with chezmoi. Runtimes and binary tools come from
mise (`private_dot_config/mise/config.toml`); npm globals are tracked in
`package.json`. `scripts/setup-macos.sh` bootstraps a fresh machine.

## Conventions

- **The repo is the source of truth, not `~`.** Edit files here and run
  `chezmoi apply`. Do not edit the deployed copy in the home directory.
- **Exception: files the app owns.** Karabiner-Elements, Claude Code, and
  similar apps rewrite their own config. When the home copy is ahead, pull it
  in with `chezmoi add <path>`; running `chezmoi apply` would overwrite it.
  Check the direction with `chezmoi diff` before either.
- **This clone must stay at `~/ghq/github.com/kfujii-6jo/dotfiles`.** The
  chezmoi source directory points here.
- Filename prefixes are chezmoi's: `dot_` → `.`, `private_` → not
  world-readable, `executable_` → `+x`, `.tmpl` → templated.
- **Unless told otherwise, commit on `main` and push straight to it** — do not
  branch or open a PR.

## Applying changes

```bash
chezmoi diff                      # what would change in ~ (- is ~, + is here)
chezmoi apply                     # deploy everything
chezmoi apply ~/.config/nvim/init.lua   # deploy one file
chezmoi add ~/.claude/settings.json     # pull an app-written file back in
git pull && chezmoi apply         # update this machine from the remote
```

`chezmoi apply` prompts before overwriting a file that changed in `~` since
chezmoi last wrote it. Confirm the diff is safe, then re-run with `--force`.

## Adding tools

- mise tool: edit `private_dot_config/mise/config.toml`, then `mise install`.
- npm global: add to `package.json`, then `npm install -g <package>`.

## Claude Code config (`dot_claude/`)

- Skills under `dot_claude/skills/` are deployed by chezmoi. `grill-me` and
  `grilling` are vendored from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT),
  `empirical-prompt-tuning` from [mizchi/skills](https://github.com/mizchi/skills) (MIT) — do not edit them by hand.
- `settings.json` carries `enabledPlugins` and `extraKnownMarketplaces` so a
  fresh machine restores its plugins on `chezmoi apply`. Claude Code writes
  this file itself, so it follows the `chezmoi add` rule above.
