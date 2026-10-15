# Local factory workflow

This environment owns the factory workflow. Follow repository instructions and
the user's authorized scope. The main agent owns planning, implementation,
validation, and recovery; delegate only completed implementation to
factory-reviewer.

- `/factory-plan` creates or revises a plan. Planning does not authorize implementation.
- `/factory-run` executes or resumes an approved plan and owns its completion
  review, bounded repair, and recovery. Do not also launch a generic reviewer.
- `/factory-improve` investigates improvements only on explicit request.

Do not start implementation from discussion or a plan alone. Preserve unresolved
questions, approval boundaries, dependencies, and interrupted-work recovery in the
plan. Persist progress at task boundaries, not on every conversational reply.

Finish local validation and independent review before reporting implementation
complete. Questions, planning, and progress updates do not trigger review. If a
review cannot run, report that limitation. When acting as a child agent, finish
the assigned task without launching another completion reviewer.

Do not enable watchdog, turn-end review, background scheduling, or automatic
commit/push/PR/merge/deploy. Publishing requires authorization for that action;
honor authorization already provided by the user and repository instructions.
