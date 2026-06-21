---
name: commit
description: Create a git commit. Use this skill when the user asks to commit changes.
model: haiku
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -20`

## Your task

Based on the above changes, create a single git commit.

### Commit message conventions

Review the recent commits above and follow the repository's existing conventions:
- Match the language used (English or Japanese)
- Match the format (e.g. Conventional Commits `type(scope): description`, or plain style)
- Match the level of detail and tone
- Use the same scope naming patterns if scopes are used

You have the capability to call multiple tools in a single response. Stage and create the commit using a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
