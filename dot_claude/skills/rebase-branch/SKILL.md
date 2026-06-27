---
name: rebase-branch
description: Rebase the current branch onto the latest main. Use this skill when the user wants to update a stale branch.
model: haiku
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Ahead/behind main: !`git fetch origin main --quiet 2>/dev/null; git rev-list --left-right --count origin/main...HEAD`

## Your task

Rebase the current branch onto the latest `origin/main`.

### Steps

1. **Check for uncommitted changes**
   If `git status --short` shows any changes, stop and tell the user to commit or stash them first.

2. **Check not on main**
   If the current branch is `main`, stop and tell the user to switch to a feature branch first.

3. **Fetch and rebase**
   Execute:
   ```bash
   git fetch origin main && git rebase origin/main
   ```

4. **Report the result**
   - On success: report how many commits were rebased and that the branch is now up to date with main.
   - On conflict: tell the user which files conflict and that they need to resolve conflicts, then run `git rebase --continue`.

Do not push. Do not do anything else.
