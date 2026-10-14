---
description: Execute or resume a local plan through validation and completion review
argument-hint: "<plan-path> [answers or requested scope clarification]"
---

Execute or resume the explicitly selected local factory plan:

$@

The main agent owns all planning decisions, edits, checks, and recovery. Use one
read-only factory-reviewer after the entire requested implementation is ready.
This workflow owns the completion review; do not also run the generic reviewer
from global AGENTS.md. Do not launch implementation workers, automatic
improvement sweeps, background schedules, or turn-end/watchdog reviews.
Do not commit, push, create PRs, merge, or deploy unless separately instructed.
Respect the active profile and repository instructions. If required tools are
not allowed (including ask/research profiles), stop without bypassing them.

## 1. Resolve the plan and recover its state

Require an unambiguous existing plan path; if missing, ask for it rather than
guessing which work to start. Read the plan and applicable repository rules.
Verify its project directory matches the current working directory. The user's
explicit /factory-run invocation authorizes the plan's described scope, not
unresolved choices, scope expansion, or unrelated tasks. Record that authorization
against the scope revision; reuse it when resuming unchanged work.

Re-evaluate questions using any answers provided. A comment or answer is not
automatically approval of a different scope. If a required decision, prerequisite,
or validation method remains unresolved, record needs-input and the next action,
then stop with a specific question. Do not repeatedly ask about settled choices.

Before editing, inspect the working tree and existing execution records. Preserve
staged, unstaged, and untracked work. Do not reset, stash, clean, switch branches,
or create a worktree merely to make the tree clean. If this plan was interrupted,
inspect its partial changes, check results, and any recorded reviewer run before
continuing. Reuse a still-running review instead of launching a duplicate. Do not
reset repair counts or claim a pending check passed because the session resumed.

If the plan is done and its requirements and implementation files are unchanged
from the recorded successful review, report its existing result without another
review. New requirements need a revised plan; changed implementation needs fresh
validation and appropriate review. Never interpret a follow-up question as a
request to restart implementation.

## 2. Preserve evidence and implement

Keep durable evidence in `.pi/plans/<plan-slug>.evidence/` beside the plan.
Follow repository conventions for local artifacts; do not auto-commit them.
Do not copy credentials or secrets into evidence. If the baseline cannot be
reconstructed after an interruption, record that gap and resolve the scope
before claiming to review only this task's changes.

At the initial start, record the current branch/HEAD (if Git is available),
working-tree status, and pre-existing changes. Before the first edit of each
target file, preserve its original contents or absence in the evidence directory.
Keep that original baseline across resumes. For non-Git projects, use these file
snapshots. Track files added, deleted, renamed, or modified by this task.

Set the plan to running. Choose only tasks whose dependencies are implemented
and whose prerequisites are satisfied; prioritize blocking bugs within this
plan. Work sequentially with one writer. Mark each task in-progress before
editing, then implemented after its required checks pass. Record changed paths,
commands, exit codes, and relevant results at each task boundary. When an
individual task check fails, apply the shared repair-cycle limit in step 4
before making another corrective pass; there is no separate uncapped inner loop.
When an
unexpected requirement or consequential unapproved decision appears, checkpoint
the partial work, set needs-input, and ask; do not expand the scope yourself.

On an interruption or tool/environment failure, save the last completed step,
partial changes, exact failure, and next action when possible; mark interrupted
or needs-input and stop. A hard process exit may prevent that checkpoint, so
reconcile actual files and run status on the next invocation. No idle polling or
automatic stale-task reset is needed.

## 3. Validate the completed implementation

When all planned tasks are implemented, check every acceptance criterion and run
the relevant final checks from the plan. Use the repository's actual commands;
do not add unrelated tests or suppress failing checks to obtain a pass. For UI
changes, perform the planned local visual/interaction checks. Required checks
that cannot run are blockers, not successes; record why they are unavailable.

Build a review handoff containing the requirements, plan path, exact task-owned
diff against the saved baseline, changed-file inventory (including untracked and
deleted files), and validation evidence. A plain `git diff HEAD` is insufficient
when unrelated changes already existed. Include original file snapshots when
needed to separate overlapping prior edits. Exclude only this run's bookkeeping,
not product/config changes that happen to live under `.pi/`.

Record the content hashes and presence/absence of all implementation files in
the handoff. These identify the version being validated and reviewed. Stop
editing implementation files while review is running.

## 4. Review once, then repair only what matters

Activate subagents_enable if that is the available entry point. Launch exactly
one native Pi child using the following shape, substituting the real project
directory and handoff paths:

```json
{
  "agent": "factory-reviewer",
  "task": "Review the completed implementation. Read <plan> and <handoff>; inspect the actual changed files. Report concrete defects, missing requirements, and verification gaps. Do not edit files or delegate.",
  "cwd": "<absolute project directory>",
  "async": true,
  "options": { "context": "fresh", "agentScope": "user" }
}
```

Record the run ID and set reviewing. The launch receipt is not a completed
review. Let native completion wake the parent and consume the finished result
before reporting completion; do not busy-poll. If review fails or is interrupted,
record the exact failure and stop. Do not silently substitute self-review,
another model, an external CLI, or another execution protocol.

Save the review result in the evidence directory and summarize it in the plan.
Evaluate findings against the actual code and agreed requirements. Fix concrete
defects within scope; defer optional polish with a reason. Unresolved material
findings block completion. If a finding needs a new product/scope decision,
record needs-input and return to planning with that question.

The entire plan allows at most TWO automatic repair cycles, shared by validation
failures and review findings. Initial implementation is not a repair cycle.
Persist and increment the count BEFORE starting each corrective pass. Each pass
fixes the known issues, reruns affected checks, and refreshes review evidence.
After code changes, request a focused follow-up from factory-reviewer covering
the fixes and their regression surface. If review has not run yet because checks
failed, run the first review once all checks pass. Do not restart the count on
resume, and do not spend cycles on speculative improvements. If a third repair
would be needed, record needs-input and report what remains; do not mark done.

## 5. Complete and stop

Before marking done, verify that all acceptance criteria and required checks
passed, the completed independent review covers the current implementation, and
no material findings remain. Compare current target paths/content hashes with
the reviewed handoff, including additions and deletions. If anything changed,
invalidate the affected evidence and validate/review the new version first.

Mark tasks and the plan done. Report the changes, checks and their results,
review outcome, repair cycles used, and any explicitly deferred notes. Record
the final file fingerprints and evidence paths for future resume checks.
End here: later conversation alone does not launch another review or improvement
scan. Never report completion while a reviewer or required check is pending.
