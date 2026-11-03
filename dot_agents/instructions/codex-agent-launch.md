## Agent launch rules

- Delegate implementation (code editing) to subagents. Give concrete file paths,
  requested changes, verification commands, and environment caveats. The main
  session focuses on research, planning, judging review results, and reporting.
- When parallel edits, risky changes, or checkout constraints require isolation,
  give each implementation agent a separate worktree and its absolute path.
  Use the runtime's native worktree isolation when available; otherwise use the
  repository's existing worktree tooling. Verify environment setup before editing.
- Delegate authorized branch creation, commit, push, and PR creation to subagents
  too. Use a lighter available model for mechanical work. Specify branch names,
  commit messages, PR titles and bodies, files to stage, and constraints as
  applicable. Use parallel subagents for independent repositories. Delegation
  does not authorize a commit or push that the user has not requested.
