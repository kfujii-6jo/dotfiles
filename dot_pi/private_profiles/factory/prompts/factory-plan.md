---
description: Create or revise a local implementation plan without starting implementation
argument-hint: "<request, feedback, or existing plan path and answers>"
---

Prepare a local factory plan for the following input:

$@

Do this work in the main session. Do not implement product changes, delegate a
review, run an improvement sweep, or start /factory-run. Respect the active
profile: if it forbids writing, explain that a writable profile such as factory
is required; do not switch profiles or widen tools yourself.

## Investigate and triage

Read the applicable repository instructions, relevant code, existing tests, and
provided feedback. Reuse the project's existing commands and conventions.
Classify concrete requests as bug, feature, enhancement, or chore. Combine
duplicate reports while preserving their sources; distinguish verified facts
from hypotheses. Do not fetch external feedback or invent new backlog items.

For each request, identify acceptance criteria, affected areas, dependencies,
priority, and decisions that could change its scope. Reproduction steps matter
for bugs. Within this plan, prioritize blocking bugs and dependencies before
independent features; do not pull unrelated work from the repository backlog.

Branch explicitly:
- Missing facts or ambiguous requirements: record specific questions and set
  status to needs-input. Ask only questions needed to make the plan executable.
- A new product decision, scope expansion, or unapproved consequential change
  (for example auth behavior, schema/data migration, or a public API break):
  describe the choice and its impact, and record the pending decision. Existing
  explicit authorization counts; do not repeatedly request the same approval.
- Sufficient information and a defined scope: set status to ready. Ready means
  ready for the user to start execution, not permission to execute now.
- Answers to an existing plan: update that plan and re-evaluate every pending
  question. A reply is not automatically an approval. Preserve unresolved items,
  previous execution evidence, and repair counts; invalidate stale acceptance
  or review claims when requirements change.

Increment the scope revision when requirements, acceptance criteria, or planned
work change. Record which revision the user authorized; do not carry approval
for an old scope over to newly added work. Clarifying an already approved detail
does not require asking for the same authorization again.

## Save one plan

Create `.pi/plans/<short-slug>.md`, or update the explicitly selected plan.
Do not overwrite a different plan. Keep small tasks short and use the user's
language. Store the following information; sections may be combined when brief:

```markdown
# <Goal>

## Control
- Status: draft | needs-input | ready | running | reviewing | interrupted | done
- Project: <absolute working directory>
- Scope revision: 1
- Execution authorization: not started
- Repair cycles used: 0 / 2
- Next action: <one concrete action>

## Request and scope
<Input/source, intended behavior, included work, explicit non-goals>

## Acceptance and validation
<Observable acceptance criteria and how to check each one>
<Actual commands, relevant UI checks, environment prerequisites>

## Decisions and questions
<Question, why it matters, answer/authorization, resolved or pending>

## Tasks
| ID | Type / priority | Work and acceptance | Depends on | Status |
|---|---|---|---|---|
| T1 | <type / priority> | <bounded change> | none | pending |

## Execution record
<Initially empty. Later: baseline, changed paths, checkpoints, failures,
validation commands/exit codes, review run IDs/results, deferred findings>
```

Use task statuses pending, in-progress, implemented, blocked, and done.
Implemented means the code and task checks are ready; done additionally requires
the whole plan's final validation and independent review. Check for missing
dependencies and cycles. Define a feasible validation method rather than
promising tests that do not exist; record genuinely unavailable checks.

Finish with the plan path, unresolved decisions, and (only when ready) the exact
`/factory-run <plan-path>` command. Planning itself does not trigger review.
