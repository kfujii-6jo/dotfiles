## Agent workflow

- The main session stays in its original tab and handles research, planning,
  dispatch, review routing, and reporting.
- Delegate implementation (code editing) to an implementation agent in the left
  pane of a new Herdr task tab, with a review agent in the right pane. Changes to
  executable code, tests, or scripts always go through this flow; the main
  session may make small wording edits to documentation and prompts itself.
- After implementation and verification, the main session runs `gev guide review`,
  prepares bounded evidence, and runs `gev eval` following the guide. Jev is an
  external model; the main session interprets its result and owns review routing.
- The main session instructs the right-pane reviewer when review is needed and
  coordinates implementation follow-ups. The reviewer checks correctness first,
  uses the `lazy` skill only when applicable to changed TypeScript, and verifies
  any resulting edits.
- Both implementation and review agents inherit the main session's model and
  reasoning effort unless the user specifies otherwise. Pass them explicitly as
  native agent arguments, for example `herdr agent start <name> --kind claude
  --pane <id> -- --model <model> --effort <level>`, or for Codex
  `-- -m <model> -c model_reasoning_effort=<level>`.
- An agent started in a new worktree can stop at a folder-trust prompt
  (`agent_not_ready`). Read the pane and ask the user before approving it.
- Give each agent the absolute path to the task worktree, concrete file paths,
  requested changes or review scope, verification commands, and environment
  caveats. Verify environment setup before editing; do not assume worktree hooks
  or direnv integration are configured.
- When the task is finished, close the Herdr task tab you created. Report any
  scratch files the agents left behind that you could not remove.
