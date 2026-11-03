## Agent launch rules

- Delegate implementation (code editing) to an implementation agent in Herdr.
  Give concrete file paths, requested changes, verification commands, and
  environment caveats. The main session focuses on research, planning, judging
  review results, and reporting.
- Give each agent the absolute path to the task worktree. Verify environment
  setup before editing; do not assume worktree hooks or direnv integration are
  configured.
- Delegate authorized branch creation, commit, push, and PR creation to agents
  in Herdr too. Specify branch names, commit messages, PR titles and bodies,
  files to stage, and constraints as applicable. Use parallel agents for
  independent repositories. Delegation does not authorize a commit or push that
  the user has not requested.
