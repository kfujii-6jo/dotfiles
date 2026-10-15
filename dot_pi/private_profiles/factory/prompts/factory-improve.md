---
description: Investigate improvement candidates on request without implementing them
argument-hint: "<area or user flow to inspect>"
---

Investigate improvement opportunities only in the explicitly requested area:

$@

Work in the main session. Read repository instructions and relevant code; inspect
the existing local UI when useful and available. If no area is specified, ask
for one. This command authorizes investigation and proposals, not implementation,
autonomous backlog execution, product mutations through a UI, or deployment.

Report at most three concrete candidates, with evidence, expected user benefit,
affected areas, and a way to verify the improvement. Distinguish an observed bug
from an enhancement and from a hypothesis. Explain consequential decisions such
as auth/schema changes or scope expansion rather than silently approving them.
Do not invent findings to fill the quota, collect external feedback, or launch
subagents or a completion reviewer.

Return the proposals in chat. Do not modify product files or existing plans.
Only after the user selects a candidate should /factory-plan turn it into a
scoped plan; selection alone does not start implementation. Never run this
command automatically after another task finishes. Respect read-only profiles
and do not widen tools to inspect a UI that is unavailable.
