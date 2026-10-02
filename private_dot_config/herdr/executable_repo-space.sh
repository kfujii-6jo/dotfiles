#!/bin/sh
set -eu

repo_root=$(ghq root)
repo=$(ghq list | fzf \
    --no-multi \
    --layout=reverse \
    --prompt='Repository > ' \
    --header='Enter: open a new Space | Esc: cancel') || exit 0

[ -n "$repo" ] || exit 0

exec "${HERDR_BIN_PATH:-herdr}" workspace create \
    --cwd "$repo_root/$repo" \
    --label "${repo##*/}" \
    --focus >/dev/null
