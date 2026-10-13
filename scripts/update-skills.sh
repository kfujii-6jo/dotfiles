#!/bin/bash
set -euo pipefail

# Follow upstream branches and save the resolved versions for other machines.
chezmoi diff "$HOME/.apm/apm.yml"
chezmoi apply "$HOME/.apm/apm.yml"
mise exec -- apm update --global --yes
chezmoi add "$HOME/.apm/apm.lock.yaml"
