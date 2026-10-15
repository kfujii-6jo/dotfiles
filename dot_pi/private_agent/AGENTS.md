# Pi implementation completion review

For the primary agent, completing an implementation task includes an independent
review. Once the requested implementation and relevant validation are complete,
use pi-subagents to delegate the completed changes to reviewer before reporting
the task finished. If only subagents_enable is exposed, activate it first. Wait
for the reviewer to finish; do not dispatch review and report completion while
it is still running.

Give reviewer the user's requirements, the files and diff belonging to this task,
and the validation results. Request a read-only review: report actionable bugs,
missing requirements, inadequate verification, and unnecessary complexity with
concrete evidence and minimal fixes. The primary agent owns all file changes.

Fix material findings and rerun the relevant validation. Request a focused
follow-up review only when those fixes or unresolved findings need verification.
Include the review outcome and any remaining limitations in the final report.
If review cannot run, disclose that explicitly instead of claiming it completed.

Start review only when the requested implementation is ready for completion.
Do not trigger it for questions, discussion, planning, progress updates,
clarification requests, interrupted work, or incomplete implementation. Do not
repeat a completed review for later conversational replies unless implementation
changes. Do not install or enable a continuous review hook for this workflow.

Respect explicit task instructions. If delegation is explicitly forbidden,
obey that instruction and report that independent review was skipped. When acting
as a child agent, finish the assigned task without launching another completion
reviewer.
