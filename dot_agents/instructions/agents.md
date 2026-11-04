## Agent workflow

- Delegate implementation (code editing) to an implementation agent launched
  in a new Herdr tab. Give concrete file paths, requested changes, verification
  commands, and environment caveats. The main session focuses on research,
  planning, and reporting.
- Implementation agents inherit the parent's model and reasoning effort unless
  the user specifies otherwise.
- Give each implementation agent the absolute path to the task worktree. Verify
  environment setup before editing; do not assume worktree hooks or direnv
  integration are configured.
