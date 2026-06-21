---
name: commit-push-pr
description: Commit, push, and open a PR. Use this skill when the user wants to commit changes, push to remote, and create a pull request in one step.
model: haiku
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -20`

## Your task

Based on the above changes:

1. Create a new branch if on main
2. Create a single commit following the repository's existing conventions (match language, format, and style from recent commits)
3. Push the branch to origin
4. Create a pull request using `gh pr create` with the following format:

```
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
- <bullet point summary of changes>

## Test plan
- [ ] <what to verify>
EOF
)"
```

5. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
