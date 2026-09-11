# Global Instructions

## Git

- **Never commit or push on your own**: do not run `git commit` / `git push`
  until explicitly told to. Leave changes in the working tree and just report
  what is ready to be committed.
- **Run lint / typecheck / test before committing**: detect how the repository
  runs them, in this order:
  1. A hook manager config at the repo root: `lefthook.yml` / `lefthook.yaml`,
     `.pre-commit-config.yaml`, `.husky/`, or `simple-git-hooks` /
     `lint-staged` in `package.json`. Follow it, and never bypass the hooks
     (do not use `--no-verify`).
  2. `git config core.hooksPath`: if set, the hooks in that directory run on
     commit even when there is no hook manager config.
  3. Otherwise, the repository's own commands: `package.json` scripts,
     `mise.toml` tasks, `justfile`, `Makefile`, README.

## Looking up repositories

- **Check `~/ghq` before going to the remote**: when you need to read code from
  another repository, look for an existing clone under `~/ghq` first and read
  it locally instead of fetching from GitHub.
