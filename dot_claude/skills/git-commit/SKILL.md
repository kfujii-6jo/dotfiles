---
name: git-commit
description: >
  Generate high-quality git commit messages following Conventional Commits format.
  Use this skill when the user asks to commit changes, mentions "コミット", says
  "create a commit message", or explicitly invokes /git-commit. Analyzes staged and
  unstaged changes, reviews recent commit history for style consistency, and
  generates appropriate commit messages with the correct type prefix (feat, fix,
  docs, style, refactor, etc.) and optional scope. Automatically detects whether
  to use English or Japanese based on project context.
---

# Commit Message Generator

This skill helps generate well-structured commit messages following the Conventional Commits specification while maintaining consistency with the repository's existing commit style.

## Workflow

When invoked, follow this sequence:

### 1. Analyze Current Changes

Run these commands in parallel to understand what's being committed:

```bash
git status
git diff --staged
git diff
```

If there are no staged changes but there are unstaged changes, inform the user and ask if they want to stage specific files or all changes before proceeding.

### 2. Review Commit History

Check recent commit messages to understand the repository's conventions:

```bash
git log --oneline -20
```

Pay attention to:
- Commit message language (English vs Japanese)
- Use of scopes (e.g., `feat(nvim):` vs `feat:`)
- Level of detail in commit messages
- Common patterns or preferences

### 3. Generate Commit Message

Create a commit message following Conventional Commits format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Commit Types

Choose the most appropriate type:

- **feat**: New feature or functionality
- **fix**: Bug fix
- **docs**: Documentation changes only
- **style**: Code style changes (formatting, missing semicolons, etc.) that don't affect behavior
- **refactor**: Code changes that neither fix bugs nor add features
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Build process, tooling, or dependency updates
- **ci**: CI/CD configuration changes
- **revert**: Reverting a previous commit

#### Scope (Optional)

Include a scope in parentheses if the changes affect a specific component or area:
- `feat(nvim):` for Neovim configuration changes
- `fix(tmux):` for tmux-related fixes
- `chore(mise):` for mise tool configuration

Only include a scope if it adds meaningful context. Skip it for changes that affect the entire project.

#### Description

Write a concise description (50-72 characters ideally) that:
- Uses imperative mood ("add feature" not "added feature" or "adds feature")
- Starts with lowercase (unless it's a proper noun)
- Has no period at the end
- Clearly explains what the commit does

#### Language Selection

Choose the language based on context:

- **English**: Default choice for most commits, especially for:
  - Public or international projects
  - Technical changes with English code/comments
  - Following existing English commit patterns

- **Japanese**: Use when:
  - Recent commits are primarily in Japanese
  - Changes involve Japanese documentation or comments
  - The codebase/team is Japanese-focused
  - User explicitly requests Japanese

When in doubt, check the recent commit history and match the predominant language.

#### Body (Optional)

Add a body if the change requires more explanation:
- Leave a blank line after the description
- Wrap lines at 72 characters
- Explain what and why, not how
- Include motivation for the change and contrast with previous behavior

#### Footer (Optional)

Include footers for:
- Breaking changes: `BREAKING CHANGE: <description>`
- Issue references: `Closes #123`, `Fixes #456`
- Co-authors: `Co-authored-by: Name <email>`

### 4. Present the Commit Message

Show the generated commit message to the user clearly formatted. For example:

```
feat(nvim): add neo-tree plugin for file exploration

Replace oil.nvim with neo-tree.nvim to provide better
file tree visualization and navigation capabilities.
```

Explain your reasoning briefly, such as:
- Which type you chose and why
- Whether you included a scope
- Language choice rationale

### 5. Confirm and Execute

Ask the user: "Does this commit message look good? I can commit these changes now, or we can revise the message."

If the user approves, execute the commit:

```bash
git add <files-to-stage-if-needed>
git commit -m "<commit-message>"
```

If the commit message has a body or footers, use a heredoc format:

```bash
git commit -m "$(cat <<'EOF'
<full-commit-message>
EOF
)"
```

After committing successfully, show the commit hash and message for confirmation.

## Edge Cases

### No Changes to Commit

If `git status` shows no changes, inform the user: "There are no changes to commit. The working directory is clean."

### Untracked Files Only

If there are only untracked files, list them and ask: "These files are untracked. Would you like to add any of them?"

### Large Number of Changes

If the diff is very large (hundreds of lines across many files), provide a summary instead of trying to describe every change. Focus on the main purpose or theme of the changes.

### Merge Commits

For merge commits, suggest using Git's default merge message or a simple description like `Merge branch 'feature-name'`.

## Examples

**Example 1: Adding a new feature**
```
Changes: Added Neovim plugin configuration for LSP
Output: feat(nvim): configure LSP with mason and lspconfig
```

**Example 2: Fixing a bug**
```
Changes: Fixed tmux prefix key configuration for macOS
Output: fix(tmux): correct prefix key binding for macOS
```

**Example 3: Documentation update**
```
Changes: Updated README with installation instructions
Output: docs: add installation instructions to README
```

**Example 4: Refactoring with body**
```
Changes: Reorganized shell utility functions
Output:
refactor(shell): reorganize utility functions for clarity

Move git-related functions to a separate section and group
tmux utilities together to improve maintainability.
```

**Example 5: Breaking change**
```
Changes: Changed mise configuration format
Output:
feat(mise): migrate to new configuration format

BREAKING CHANGE: mise config.toml now uses version 2 format.
Users must update their config files following the migration guide.
```

## Notes

- Always read the actual git diff before generating the message—don't guess or assume what changed
- Match the repository's existing commit style and language preferences
- Keep the description line under 72 characters when possible
- Use imperative mood consistently
- When changes span multiple types, choose the most significant one or consider splitting into multiple commits
- Don't add unnecessary footers like "🤖 Generated with Claude Code" unless the user requests it
