---
name: cleanup-branch
description: Switch to main, pull latest, and delete the work branch. Use this when the user has finished work on a branch (merged or no longer needed).
model: haiku
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Merged status: !`git branch --merged main 2>/dev/null | grep -v "^\*\|^  main$" | head -5`

## Your task

Clean up after finishing work on a branch: switch to main, pull, and delete the branch.

### Steps

1. **Check for uncommitted changes**
   If `git status --short` shows any changes, stop and tell the user to commit or stash them first.

2. **Check not already on main**
   If the current branch is `main`, stop and tell the user there is no work branch to delete.

3. **Save the branch name**, then switch to main and pull:
   ```bash
   BRANCH=$(git branch --show-current) && git checkout main && git pull origin main
   ```

4. **Check if the branch was merged**
   ```bash
   git branch --merged main | grep -q "^\s*${BRANCH}$"
   ```
   - If merged: delete the branch silently.
   - If NOT merged: warn the user that the branch has not been merged into main, and ask for confirmation before deleting.

5. **Delete the branch (if confirmed or merged)**
   ```bash
   git branch -d $BRANCH
   ```
   Use `-D` only if the user explicitly confirms deletion of an unmerged branch.

Report which branch was deleted and that main is now up to date.
