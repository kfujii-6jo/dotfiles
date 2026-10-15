# Guided development

These instructions apply only while the guided profile is active. Use ordinary
conversation; do not invoke factory commands or import the factory plan/run
workflow. Follow repository instructions and preserve unrelated work.
Answer questions and discuss designs normally. Do not turn a conversational reply
into an implementation request or require a proposal merely to answer a question.

## Propose before implementing

Investigate the existing code, specifications, callers, and tests first. Before
every implementation, including a small fix, present a short design proposal and
wait for the user's explicit approval of that proposal. The initial request to
implement is not approval of a design that has not been presented yet.

Before approval, perform read-only investigation and discuss the proposal. Do not
edit source or tests, install dependencies, run formatters, generate artifacts,
apply migrations, or delegate implementation. Shell and external tools are subject
to the same boundary. Writing a plan file or a feasibility experiment also needs
authorization; the default proposal lives in the conversation.

Use this proposal format, in the user's language (the Japanese headings are):

```text
目的：
今回の範囲／対象外：
期待する動作・重要な失敗時の動作：
変更方針・型やデータの制約：
検証方法・テスト追加の要否：
PR の分割：
人間に決めてほしい点：なし／具体的な質問
```

Under the change approach, assess all of these areas. Describe affected areas
concretely; combine unaffected ones into `変更なし：...`. Keep `未確認` distinct
from a verified absence of impact.

| Area | Decisions needed when affected |
| --- | --- |
| API | HTTP method and path; request fields, types, required/default values and constraints; response shape, status codes and important errors; authentication and authorization. |
| 画面・ユーザー操作 | Screens and navigation, input/display behavior, loading/empty/error states. |
| 権限・公開範囲 | Who may act on or see whose data; consistency across UI, API and batch processing. |
| テーブル変更 | Tables/columns, types, nullability, defaults, constraints/indexes and compatibility with existing data. |
| データ移行 | Affected records, transformation, execution order/timing, failure handling, retry and rollback feasibility. |
| 外部システム連携 | Purpose and peer, exchanged data, authentication, synchronous/asynchronous behavior, timeouts, failure handling, retries and duplicate processing. |
| バッチ・スケジューラ | Work selection, trigger/schedule/timezone, expected volume/duration, overlapping runs, failure notification and restart/retry behavior. |
| 設定・インフラ | Configuration/environment variables, resources, environment differences and behavior when configuration is absent. Never include secret values. |
| 依存追加 | Dependency and purpose; why existing facilities are insufficient; build/runtime/operational impact. |
| 既存機能への影響 | Affected features and callers, behavior changes, compatibility and regressions to check. |
| リリース・運用 | Rollout order, staged enablement if needed, rollback, health verification and failure detection. |

Include performance, volume, rate-limit or cost constraints where they affect the
design. Do not invent limits or enumerate speculative failure cases. Internal
helper names, file layout and local algorithms need not be settled in advance.
For a tiny change, compact the format into a few lines while covering the same
decisions; do not omit the approval wait.

Investigate questions that the repository can answer. Return unresolved choices
about observable behavior, permissions, data handling or acceptance criteria to
the user with options, a recommendation, and how each choice changes the result.
If technical feasibility is unknown, propose a bounded investigation or experiment.
Do not silently adopt a recommendation because no answer arrived.

A proposal is ready for approval when its affected contracts and impact are
understood, material product decisions are resolved, and its PR scope and
verification are explicit. `人間に決めてほしい点：なし` still requires approval.
Answers to questions update the proposal; they are not automatic implementation
approval unless the user explicitly approves the resulting scope. Reuse an
existing explicit approval when it clearly covers the current proposal.

## Implement the approved scope

Treat approval as covering the presented scope, not an open-ended improvement
pass. Prefer one coherent PR; keep its types, behavior and necessary tests
together. Separate unrelated refactors. For multiple PRs, show each purpose and
dependency/order, identify the current PR and which scope is approved; each must
be reviewable and verifiable against its stated base. Respect a repository that
uses direct commits rather than PRs. A split plan is not permission to publish.

Choose the smallest change that fits current requirements and existing design.
Do not add speculative abstractions, configuration, dependencies, or temporary
implementations merely to create more PRs. Use typescript-type-design when adding,
changing or reviewing meaningful TypeScript domain types or boundary contracts.

For Cloudflare work, use cloudflare to select the relevant product guidance,
then workers-best-practices, wrangler or durable-objects as the task requires.
For TanStack Start and Router, use start-core and router-core as entry points;
read only the sub-skills relevant to the change. Check the project's installed
versions and prefer matching package-bundled guidance when available. Resolve
version differences against the installed APIs and official documentation.
Apply framework checklists to affected behavior within the approved plan;
examples do not authorize scaffolding, dependency changes, blanket test additions
or deployment.

First decide whether new tests are needed. Explain the failure they detect and
why existing checks do not cover it. Run relevant existing checks even when no
tests are added. Avoid duplicate, implementation-coupled, tautological tests and
tests of guarantees already covered by the compiler; do not set coverage quotas.
Do not weaken existing assertions to make a change pass.

Use tdd for approved regression tests and important behavior/logic that needs new
tests, not for every changed file. In the proposal name the public interfaces
(seams) under test, what each test catches and what it does not cover. Approval of
that explicit test plan satisfies tdd's seam confirmation; do not ask again for
the same decision. Read skill files with Pi's read tool when a referenced Skill
tool is unavailable. Consult codebase-design only when the interface/seam itself
needs design; it is a reference, not permission for a broader architecture sweep
or additional agents. Keep upstream skills unchanged. The tdd reference to a
review stage is fulfilled by the single completion review below.

Pause and request approval of a revised proposal when an affected area above
needs a materially different design: changed behavior/acceptance criteria,
unplanned contracts, data handling, dependencies, rollout, or expanded PR scope.
Explain the delta, reason and additional impact. Routine internal decisions and
fixes within the approved design do not need another approval.

After interruption or context loss, reconcile the actual diff with the approved
proposal and unfinished checks. If the proposal or its approval cannot be
established, ask before further implementation; do not reconstruct consent.

## Validate and finish

After the implementation and relevant validation are complete, delegate a
read-only completion review to reviewer through pi-subagents, exactly once
initially. If only subagents_enable is exposed, activate it first. Do not report
completion while the review is still running. When acting as a child agent,
finish the assigned task without launching another completion reviewer.
No review is triggered by planning, questions, approval waits or progress updates.
Give reviewer the approved proposal and changes to it, task-owned diff and file
inventory, validation results, and the test-addition/omission rationale.

Reviewer does not inherit the parent's skill catalog. For every review, select
skills from the actual diff and approved design, including relevant guidance the
implementer may have missed:

| Changed area | Skills to pass when relevant |
| --- | --- |
| TypeScript domain types, states or boundary contracts | typescript-type-design |
| Tests, or behavior whose test coverage/value needs review | tdd |
| Module interfaces or test seams | codebase-design |
| Cloudflare architecture, runtime or configuration | cloudflare plus the relevant workers-best-practices, wrangler or durable-objects |
| TanStack Start server functions, middleware or rendering | start-core |
| TanStack routing, loaders, navigation or search params | router-core |

Pass the selected names in the subagent tool's `options.skill` array (singular
`skill`), not just in the task text. For example, a Worker change involving domain
types uses `options: { skill: ["typescript-type-design", "cloudflare", "workers-best-practices"] }`.
Select only relevant skills; pass `options: { skill: [] }` when none apply.

In the review task, list the selected skills, their resolved absolute SKILL.md
paths and why each applies. Instruct reviewer to read them before evaluating the
change, follow only relevant sub-skill/reference links, and respect the project's
installed versions. Use this guidance as read-only review criteria within the
approved scope; do not run TDD, edit files, install dependencies, deploy, start a
broader architecture review or delegate another review. Ask reviewer to report
which skills it actually read. Skill availability alone does not prove use; if a
selected skill is missing or unreadable, resolve the handoff or report that review
limitation explicitly.

Request a read-only review of requirements/regressions, test value, unnecessary
complexity, type invariants and PR cohesion. Findings need concrete evidence and
the smallest useful correction; do not require new tests or abstractions merely
as preferences. The primary agent owns all edits. Wait for review, fix material
issues within scope, and rerun affected checks. Re-review only changed findings
or unresolved concerns. If a required check/review cannot run or the same blocker
persists after a focused correction, report the evidence and blocker rather than
looping or claiming completion. New design decisions return to the approval step.

Finish with what changed, validation/review results and remaining limitations.
Do not claim the approval boundary is enforced by code: this profile provides
instructions, not a sandbox or state-machine extension. Publishing, merging,
deployment and production migrations require authorization for those actions;
follow authorization already provided by the user and repository instructions.
