#!/bin/bash
set -euo pipefail

: "${HERDR_ACTIVE_PANE_ID:?No active Herdr pane}"

scrollback_file=$(mktemp "${TMPDIR:-/tmp}/herdr-scrollback.XXXXXX")
trap 'rm -f "$scrollback_file"' EXIT

"${HERDR_BIN_PATH:-herdr}" pane read "$HERDR_ACTIVE_PANE_ID" \
    --source recent-unwrapped --lines 1000000 > "$scrollback_file"

nvim -R -i NONE \
    -c 'setlocal buftype=nofile bufhidden=wipe noswapfile' \
    -c 'normal! G' \
    "$scrollback_file"
