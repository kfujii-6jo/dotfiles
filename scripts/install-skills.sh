#!/bin/bash
set -euo pipefail

# Keep ordinary chezmoi applies separate from network-backed skill installs.
chezmoi diff "$HOME/.apm/apm.yml" "$HOME/.apm/apm.lock.yaml"
chezmoi apply "$HOME/.apm/apm.yml" "$HOME/.apm/apm.lock.yaml"
mise exec -- apm install --global --frozen
