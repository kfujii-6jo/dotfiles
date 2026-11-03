## Agent launch rules

- Delegate implementation (code editing) to subagents. Give concrete file paths,
  requested changes, verification commands, and environment caveats. The main
  session focuses on research, planning, judging review results, and reporting.
- When parallel edits, risky changes, or checkout constraints require isolation,
  launch the subagent with `isolation: worktree` from the start rather than
  manually creating a worktree first. Verify environment setup before editing;
  do not assume worktree hooks or direnv integration are configured.
- Delegate authorized branch creation, commit, push, and PR creation to subagents
  too. Use a lighter available model for mechanical work. Specify branch names,
  commit messages, PR titles and bodies, files to stage, and constraints as
  applicable. Use parallel subagents for independent repositories. Delegation
  does not authorize a commit or push that the user has not requested.
