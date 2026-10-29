# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).
Runtimes and binary tools are managed with [mise](https://mise.jdx.dev/);
global npm packages are tracked in `package.json`.

Configured: zsh, tmux, Neovim, Ghostty, lazygit, gitui, Karabiner-Elements,
Zed, herdr, Claude Code, Codex, Pi, and oh-my-pi.

## Setup

### macOS

No prerequisites — the script installs Homebrew, mise, ghq, every mise-managed
tool, applies the dotfiles, and installs the npm globals:

```bash
curl -fsSL https://raw.githubusercontent.com/kfujii-6jo/dotfiles/main/scripts/setup-macos.sh | bash
source ~/.zshrc
```

### Manual

Install [chezmoi](https://www.chezmoi.io/install/),
[mise](https://mise.jdx.dev/) and [ghq](https://github.com/x-motemen/ghq),
clone this repo to `~/ghq/github.com/kfujii-6jo/dotfiles`, then:

```bash
mise install
chezmoi init --source="$PWD"
chezmoi apply
```

## Updating

```bash
cd ~/ghq/github.com/kfujii-6jo/dotfiles
git pull
chezmoi apply
```

Run `chezmoi diff` first to see what would change in your home directory.

### eMudhra CA incident (October 2026)

The [incident tracker](https://emudhra.we-have-a-problem.com/) lists patched
versions and test endpoints. Update Homebrew's `ca-certificates`, mise, uv,
Claude Code and rustup as well as applying the pinned runtime versions.
Applying the mise configuration does not install those runtimes; run
`mise install` afterward.

The zsh configuration directs OpenSSL clients, curl, Git, Requests and pip to
Homebrew's patched CA bundle. Open a new shell after applying it. These overrides
only cover processes inheriting that shell's environment; they do not change
`/etc/ssl/cert.pem` or independent application trust stores.

Bun is pinned to 1.4.4; with the CA configuration above, it rejects both public
test endpoints with `CERT_REVOKED`. Bun 1.4.3 still accepted the compromised
intermediates. Updating Python does not update certifi or pip inside existing
virtual environments; update those dependencies separately.

## Shared skills (APM)

APM 0.33.0 is installed through mise. `dot_apm/apm.yml` declares the user
skills, tracking each upstream's default branch. `dot_apm/private_apm.lock.yaml`
pins resolved commits and records files and deployment ownership. APM deploys to
`~/.claude/skills/` and `~/.agents/skills/` (shared by Codex and Pi).
All user skill directories are excluded from chezmoi; edit skills at their
upstream repository instead. Built-in and plugin-provided skills remain owned
by their respective applications.

Sources: `kfujii-6jo/skills` (Git workflows, TypeScript type design, and meta
context), `cloudflare/skills` (11),
`mattpocock/skills` (2), `subsy/ralph-tui` (4), and one each from
`mizchi/skills`, `herdrdev/herdr`, `coji/natural-japanese`, and `vercel-labs/skills`.
`clean_gone` is now `clean-gone`. The old `sandbox-sdk` is replaced by
`sandbox-stable`, `sandbox-next`, and `sandbox-migrate-to-next`.
`finish-branch`, `learning-check`, and Sanity skills have been removed.

After applying the mise configuration and running `mise install`, authenticate
GitHub access with `gh auth login` if needed (the personal skills repo is private),
then restore the pinned skills:

```bash
bash scripts/install-skills.sh
```

To update all skills to the latest upstream versions and save the resulting
lockfile back into this repository:

```bash
bash scripts/update-skills.sh
```

The script runs `apm update --global --yes`, then `chezmoi add` for the lockfile.
Review and commit the resulting diff. To preview available updates, run
`mise exec -- apm update --global --dry-run`.
Ordinary `chezmoi apply` does not install or update skills. To roll back,
restore the previous manifest and lockfile and run the install script again.
Do not edit APM's deployed copies.

Installation and discovery are verified separately from workflow behavior.
Some upstream skills still use agent-specific instructions; APM deploys them
without translating those instructions.

## Orchestrating agents with Herdr

Use `hr` from a shell inside Herdr:

```bash
hr                            # show help
hr create "ログイン改善"       # create a Space in the current directory and switch to it
hr create                     # prompt for the name; empty input cancels
hr create "調査" --cwd ~/work  # use another working directory
hr repo                       # pick a ghq repository and open or focus its Space
hr repo dotfiles              # specify a unique name, ghq path, or absolute path
hr close "ログイン改善"        # close one Space by exact name or ID
hr close w2 w3                # close multiple Spaces by exact names or IDs
hr close                      # select Spaces to close; Tab selects multiple
```

Repository and Space names must match uniquely; use a ghq path or Space ID
when names overlap. With `close`, all arguments are resolved before any Space
is closed, and repeated targets are closed only once.

`Ctrl+S` then `s` opens the same repository picker as `hr repo`.
The old `hrp` and `hs` commands are replaced by `hr`.

Use the installed `herdr` skill inside a Herdr pane. The official
[agent automation recipes](https://herdr.dev/docs/agent-automation/#recipes)
cover creating a helper pane, starting an agent, submitting work, waiting, and
reading its response. No additional orchestrator package is required.
Claude Code, Codex, and Pi guided/factory already have the skill available.
For example, ask the parent agent:

> Use the Herdr skill to start a Codex reviewer in a sibling pane. Ask it to
> review the current diff without editing files, wait for it, and summarize its
> findings. Keep focus here. Do not commit or push.

The parent owns task assignment and result collection. Give each child a clear
scope; use separate worktrees when multiple agents need to edit the same files.
Creating worktrees or child workspaces is a separate request.

For manual use, first run `herdr agent list` and choose an unused agent name.
This example uses `reviewer`; replace it throughout if already taken. Split
right for a wide pane or down for a narrow/tall pane:

```bash
split=$(herdr pane split --current --direction down --cwd "$PWD" --no-focus)
review_pane=$(printf '%s\n' "$split" | jq -r '.result.pane.pane_id')
herdr agent start reviewer --kind codex --pane "$review_pane"
herdr agent prompt reviewer "Review the current diff without editing files. Do not commit or push." --wait --timeout 120000
herdr agent read reviewer --source recent-unwrapped --lines 120
```

Inspect each command's result before continuing. `agent prompt --wait` settles
on `idle`, `done`, or `blocked`; read the response to confirm what happened.
If startup or a prompt is blocked, inspect the dialog and let the user resolve
it. After a timeout or stalled prompt, read the agent before retrying to avoid
duplicate submissions. Keep the helper available for follow-up, or close only
the pane created for this task when finished.

### Review plans and replies with Herdr Annotate

Install the Full plugin on each machine:

```bash
herdr plugin install plannotator/herdr-annotate
```

The managed Herdr config uses `Ctrl+S` as its prefix. Press it, then `a` to
annotate selected terminal text, `m` to manage annotations, `o` to review
Markdown documents, or `Shift+O` to review recent agent replies. `Shift+A`
copies annotations as Markdown. In document review, use Send to return
comments to the agent, or `q` to close.

After applying the config, run `herdr config check` and
`herdr server reload-config`. Plugin binaries and data are owned by Herdr.
See the [upstream guide](https://github.com/plannotator/herdr-annotate#readme).

## Carrying meta context into a worktree

To carry a note or conversation into an existing worktree, pass the absolute
source path when opening a pane:

```bash
note="$HOME/ghq/github.com/kfujii-6jo/meta/explorations/your-topic.md"
worktree="/absolute/path/to/your-worktree"
herdr pane split --current --direction right --cwd "$worktree" \
  --env "META_CONTEXT=$note" --focus
```

Start an agent in the new pane and ask it to read the source file, recover the
goal and decisions, and state the next action. Give the absolute path in the
prompt even when `META_CONTEXT` is set. The agent stays in the destination
worktree and follows that repository's instructions. Notes and conversation
histories are read without modification; progress logging is a separate request.

## Codex

`.chezmoitemplates/codex-config.toml` declares the portable Codex defaults.
`dot_codex/modify_private_config.toml` merges them into `~/.codex/config.toml`
using chezmoi's built-in TOML functions, preserving settings written by Codex
Desktop. Add settings to the defaults file; the merge template needs no changes.
Routine workspace operations run automatically; operations needing approval
go through AI review (`approvals_reviewer = "auto_review"`).
`dot_codex/private_rules/default.rules` carries the shared command allow/deny
policy.
User-scoped instruction fragments live in `dot_agents/instructions/` and deploy
to `~/.agents/instructions/`. `dot_codex/AGENTS.md.tmpl` and
`dot_claude/CLAUDE.md.tmpl` assemble the relevant fragments into each agent's
global instruction file during `chezmoi apply`. The generated files contain
the full instructions, so agents receive them without following file links.
Git, repository lookup, and code-style rules are shared; CLI/authentication
rules belong to Codex. Agent launch rules are assembled
separately for each runtime; required reviews go through Herdr to the other AI
(Claude Code to Codex, Codex to Claude Code).

After installing Herdr on a new machine, and after each Herdr upgrade, install
its Codex integration with the official command:

```bash
herdr integration install codex
herdr integration status
```

Herdr owns `~/.codex/herdr-agent-state.sh` and `~/.codex/hooks.json`.
Both are excluded from chezmoi; do not copy them into this repository.
`chezmoi apply` does not install or update this integration.

## Pi

[Pi](https://github.com/earendil-works/pi) is tracked as an npm global in
`package.json`. Install it on an existing machine with:

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Run `pi` in a project directory, use `/login` to connect a model provider,
then `/model` to choose a model. Resume the latest session with `pi --continue`.

`dot_pi/private_agent/modify_private_settings.json` pins the Pi packages: `pi-web-access`,
`pi-lens`, `pi-subagents`, `pi-mcp-adapter`, `pi-interactive-shell`,
`pi-rewind-hook`, and `@narumitw/pi-caffeinate` (prevents sleep during agent
work). It merges these defaults into `~/.pi/agent/settings.json`, preserving
Pi-owned state and model selections. Apply with:

```bash
chezmoi diff ~/.pi/agent/settings.json
chezmoi apply ~/.pi/agent/settings.json
```

Pi installs missing configured packages on startup. Check the package list with:

```bash
pi list
```

Restart Pi after installing packages. Use `/mcp-adapter setup` to configure MCP
servers and ask Pi to use `scout` or `reviewer` for subagent work. Shared user
skills remain managed by APM in `~/.agents/skills`; package-provided resources
stay with their Pi packages.

`dot_pi/private_agent/AGENTS.md` adds a completion review workflow for the
primary Pi agent: finish implementation and relevant validation, delegate the
task's completed changes to `reviewer`, wait for findings, then fix material issues
and rerun validation before reporting completion. Questions, planning, progress
updates, and incomplete implementation do not trigger review. This is an agent
instruction, not a turn-end hook. Apply with
`chezmoi apply ~/.pi/agent/AGENTS.md` and start a new Pi session.
This applies to ordinary `pi` and `pp default`. Named profiles have
their own AGENTS.md and do not inherit this file. `research` does not load
pi-subagents.

Install Herdr's Pi integration after installing or upgrading Herdr:

```bash
herdr integration install pi
herdr integration status
```

Herdr owns `~/.pi/agent/extensions/herdr-agent-state.ts`, which is excluded from
chezmoi. Start a new Pi session inside Herdr to load it. The `research`
profile also includes this integration; keep `herdr-agent-state` in extension
allowlists when defining more profiles.

### Pi profiles

`dot_local/bin/executable_pp` is a small Bash launcher for Pi's native
`PI_CODING_AGENT_DIR`. Named environments in `dot_pi/private_profiles/` deploy to
`~/.pi/profiles/`; each owns its instructions, settings, installed packages,
subagent definitions, prompt templates, and session history.

```bash
pp guided    # approve a short design before each implementation
pp factory   # local planning, implementation, validation, and review
pp research  # code/web discussion; no shell, editing, or subagents
pp default   # ordinary ~/.pi/agent configuration and existing history
pp guided -- --continue
```

A profile name is required; no arguments prints help. Switch environments by
exiting and launching another profile. `/profile` commands from the old extension
are no longer installed. Use Pi's `/reload` to reload the current environment.

The launcher preserves the working directory, sets a profile-local session root,
and disables MCP and project `.pi` configuration/resources with `--no-mcp` and
`--no-approve`. Repository/ancestor AGENTS.md files still load. Project skills,
extensions, model overrides, and prompt templates do not load automatically.
These are configuration boundaries, not an OS sandbox; explicit Pi CLI options
can change a launch's configuration.

Authentication is independent too. Run `/login` once inside each named profile;
subsequent launches reuse that profile's login. Pi owns each profile's `auth.json`,
which is not managed by chezmoi or tracked in git. Ordinary Pi keeps its existing
`~/.pi/agent/auth.json`. Do not link or copy OAuth credentials between profiles:
separate files need separate logins to avoid competing token refreshes.

Selected supporting resources are shared. Herdr's extension remains owned by
Herdr and is referenced explicitly. APM keeps
skill files in `~/.agents/skills`: guided enables selected skills, including
Herdr; factory enables that catalog, and research excludes it. Skills are not
copied. Inside a Herdr pane, guided and factory can use `/skill:herdr` to inspect
panes, start agents, submit work, and read results through the Herdr CLI.
Run `/reload` in an existing Pi session after applying skill changes.
Packages are pinned and installed separately in each environment by native Pi.
All three initially use `openai/gpt-6.1-sol` and medium thinking. Each profile's
`modify_private_settings.json` merges managed resources into the current settings:
packages, extensions, skills, tools, and declared subagent options come from
dotfiles. Pi's saved model/provider/thinking choices, device ID, changelog version,
and other preferences survive `chezmoi apply`. Missing model preferences receive
the initial defaults. These settings remain independent of ordinary Pi; do not
copy runtime metadata into the source files with `chezmoi add`.

When migrating from pi-profile-switch, first remove its old global executable
with `npm uninstall -g pi-profile-switch`.
After applying the files below, run `rehash` in an existing zsh.
`command -v pp` should resolve to `~/.local/bin/pp`.

Apply and initialize from this checkout:

```bash
chezmoi diff ~/.local/bin/pp ~/.pi
chezmoi apply ~/.local/bin/pp ~/.pi
# Pi installs missing pinned packages on the first profile launch.
pp guided
# Inside Pi, run /login. Repeat once for factory and research.
```

A full `chezmoi apply` also removes the retired `~/.pi-profile-switch/` directory,
the old `~/.local/bin/pi-profile` launcher, and shared factory files listed in
`.chezmoiremove`. Existing sessions remain in
`~/.pi/agent/sessions` and are available through ordinary `pi` or
`pp default`; new named-profile sessions are stored separately.

### Local factory workflow

The `factory` profile adapts the [Software Factory flow](https://www.software-factory.dev/sdlc)
to local work. The main agent plans, implements, validates, and recovers
interrupted work; one fresh-context `factory-reviewer` checks the completed
implementation. Its tool allowlist is `read`, `grep`, `find`, and `ls`, with no
ambient extensions, inherited skills, shell, editing, or nested delegation.
The profile retains web research, caffeinate, and Herdr integration. MCP and
project configuration/resources are disabled by the launcher; repository
AGENTS.md instructions still apply.

Factory initially uses `openai/gpt-6.1-sol` with medium thinking; the reviewer
inherits the active model with high thinking. The ordinary Pi model settings are
independent.

From this dotfiles checkout, apply the managed files, then start the profile:

```bash
chezmoi diff ~/.pi/profiles/factory
chezmoi apply ~/.pi/profiles/factory ~/.local/bin/pp
pp factory
```

The factory AGENTS.md, `/factory-*` prompt templates, and `factory-reviewer`
definition live only in `~/.pi/profiles/factory`. Use `/reload` after changing
those files, or start a new session.

```text
/factory-plan Add password reset to the login screen
/factory-run .pi/plans/password-reset.md
/factory-improve Inspect the login screen for accessibility improvements
```

- `/factory-plan` investigates a request or supplied feedback and writes
  `.pi/plans/<slug>.md`. It records acceptance criteria, validation commands,
  task priorities/dependencies, and unresolved decisions. Missing information
  returns to questions; unapproved scope changes wait for a decision. Answers
  update the same plan and are re-evaluated, not treated as automatic approval.
  Planning does not implement changes or launch review.
- `/factory-run <plan>` starts or resumes that plan. It checks the actual partial
  diff and recorded runs, preserves existing work, and selects dependency-ready
  tasks within the approved scope. It validates individual tasks, then validates
  the whole implementation before launching the independent review. Concrete
  findings return to the main agent for correction. At most two automatic repair
  cycles are shared across validation and review failures; the count survives
  resumption. Missing decisions, unavailable required checks, failed reviewers,
  and exhausted repair cycles stop with a recorded reason instead of success.
- `/factory-improve <area>` investigates only when requested and returns at most
  three evidence-backed proposals. Selecting a proposal leads to planning; it
  does not start implementation or an automatic post-task improvement sweep.

The plan records scope authorization, progress, checkpoints, next actions, check
results, and review run IDs. `.pi/plans/<slug>.evidence/` holds original file
snapshots, the task-owned patch, validation evidence, and review results. Keep
these local artifacts under the project's existing ignore conventions if needed.
Do not put secrets in them. Done requires passing acceptance checks and a finished
review of the current implementation. Unchanged completed plans and conversational
follow-ups reuse that result instead of launching another reviewer.

This is a prompt-directed workflow, not a code-enforced state machine or a
background scheduler. Checkpoints are written at task boundaries; after a hard
exit the next run reconciles actual files and subagent status. The managed Pi
defaults explicitly disable main/child watchdog reviews. Project or session
overrides can take precedence; inspect `/subagents-watchdog status` if unexpected
reviews occur. The global completion-review instruction defers to the factory
workflow, so it does not add a second generic reviewer.

GitHub issue/PR automation, automatic commit/push/merge/deploy, production
monitoring, scheduled performance/automation audits, metrics, recaps, and social
posts are outside this workflow. UI verification and task-specific performance
checks remain part of local validation when required by the plan.

### Guided development

`guided` is an independent, conversational development profile. Start it with
`pp guided`, describe the change normally, review its short proposal, and
explicitly approve it before implementation starts. Even a small fix or a proposal
with no unresolved questions waits for approval. Answers to specification questions
alone do not authorize implementation. No additional slash commands are needed.

The proposal uses these headings:

```text
目的：
今回の範囲／対象外：
期待する動作・重要な失敗時の動作：
変更方針・型やデータの制約：
検証方法・テスト追加の要否：
PR の分割：
人間に決めてほしい点：なし／具体的な質問
```

The change approach covers API contracts, screens/user interactions, permissions
and data visibility, table changes, data migration, external integrations,
batch/scheduled work, configuration/infrastructure, dependencies, existing-feature
impact, and rollout/operations. Explain affected areas; group unaffected areas
under `変更なし`. Unknown impact remains `未確認`, not “no impact.” Include relevant
performance or volume constraints without inventing targets.

The approved scope includes the test decision and named public test interfaces.
The profile uses the APM-managed `typescript-type-design` skill for TypeScript
domain and boundary types, and Matt Pocock's `tdd` only when new behavior or
regression tests are justified. `codebase-design` is available as its conditional
interface-design reference. Existing checks can be sufficient; tests, abstractions
and dependencies are not added for their own sake. The custom type skill's source
is `~/ghq/github.com/kfujii-6jo/skills/typescript-type-design`.

Cloudflare work can use the official `cloudflare`, `workers-best-practices`,
`wrangler` and `durable-objects` skills. TanStack's official `start-core` and
`router-core` skills cover Start and routing, with bundled sub-skills read only
when relevant. They are pinned through APM from `TanStack/router`. Check the
project's installed versions and prefer matching package-bundled guidance when
available. Framework checklists stay within the approved scope and test decision.

One coherent PR is the default unit. Keep related types, implementation and tests
together, and show dependencies when multiple PRs are needed. Repository-specific
direct-commit workflows still apply. A materially changed design or expanded scope
returns to approval; ordinary internal implementation choices do not. After an
interruption, recover the approved proposal and reconcile the actual diff before
continuing. Missing approval is not inferred.

The existing generic `reviewer` checks completed implementation and validation
against the approved proposal, including test value, type invariants, unnecessary
complexity and PR cohesion. There is no planning review or second factory review.
The reviewer does not inherit the parent's skill catalog. Each review passes only
the relevant skills through `options.skill`, together with resolved SKILL.md paths
and their purpose in the review task. Reviewer reads them as review criteria and
reports which ones it used; implementation workflows such as TDD do not run inside
the read-only review. Missing or unreadable skills are reported as limitations.
This profile does not invoke factory commands. Use a new session when starting an
independent task. Each environment keeps its own conversation history.

`dot_pi/private_profiles/guided/AGENTS.md` holds the complete guided workflow;
its settings select skills, web access, pi-subagents, caffeinate, and Herdr.
It initially uses `openai/gpt-6.1-sol` with medium thinking, and the reviewer uses
`openai/gpt-6-astra` with high thinking. Factory's prompts, reviewer definition,
and workflow instructions are not loaded.

Restore the locked skills and apply the environment, then start a new session:

```bash
bash scripts/install-skills.sh
chezmoi diff ~/.pi/profiles/guided
chezmoi apply ~/.pi/profiles/guided ~/.local/bin/pp
pp guided
```

Use `/subagents-models reviewer` to inspect the reviewer model. After editing
instructions or settings, apply them with chezmoi and use `/reload` or restart.
The design-approval rule is instruction-based; no state-machine extension or
continuous review hook is installed.

### Explicit Jev review in guided

The `guided` profile loads `dot_pi/private_extensions/jev-review.ts` as
`~/.pi/extensions/jev-review.ts` and exposes the `jev_review` tool. It sends
bounded questions and selected evidence to the
[TypeSafe HTTP API](https://docs.typesafe.ai/api). The `jev-review` skill prepares
the questions and checks the results against code and tests. It covers design,
comment necessity and change scope, including separating independent refactors.
It does not replace guided's approval step or completion reviewer.

The skill's source is `~/ghq/github.com/kfujii-6jo/skills/jev-review/SKILL.md`.
APM installs `kfujii-6jo/skills/jev-review#main` at the commit pinned in the
lockfile, so installation does not require a local skills checkout. Edit the
source skill, not the APM-deployed copies.

To try this worktree before applying shared settings, launch from its root:

```bash
pp guided -- --extension "$PWD/dot_pi/private_extensions/jev-review.ts" \
  --skill "$HOME/.agents/skills/jev-review" \
  --tools +jev_review
```

These explicit resources also let a trial continue when another dotfiles checkout
manages the shared guided settings. `+jev_review` adds to the profile's selected
tools. Use ordinary `pp guided` after the managed configuration is applied.

From this checkout, preview and apply only the integration's managed files
(use the explicit `--source` so a worktree does not read main's configuration):

```bash
chezmoi --source "$PWD" diff ~/.apm/apm.yml ~/.apm/apm.lock.yaml \
  ~/.pi/extensions ~/.pi/profiles/guided/settings.json
chezmoi --source "$PWD" apply ~/.apm/apm.yml ~/.apm/apm.lock.yaml \
  ~/.pi/extensions ~/.pi/profiles/guided/settings.json
mise exec -- apm install --global --frozen
pp guided
```

Set `TYPESAFE_API_KEY` through your usual credential setup in the environment
that launches Pi; do not put it in dotfiles, skill text or chat. After adding a
key to the launch environment, restart Pi. Use `/reload` for resource changes in
an existing process. Then ask, for example:

```text
/skill:jev-review 今回の差分について、コメントの制約が実装で守られているかと、コメントを省いても情報が伝わるかを別々に確認して。
```

Each call accepts an objective, scope, source-labelled evidence and up to eight
independent questions with yes/no criteria. It returns `yes`, `no`, or
`insufficient_evidence`, probabilities, confidence, actual model, token usage and
request latency. The default is pinned to `jev-1.13.0`; set `JEV_MODEL` in the
launch environment to compare another version. There is no acceptance threshold
or automatic action. Model confidence and the primary agent's explanation remain
distinct from evidence of correctness.

The local request limit is 64 KiB; oversized inputs are rejected, never truncated.
Calls time out after 15 seconds and are not retried automatically. Missing keys,
invalid results, HTTP failures and cancellation return `unavailable`, not a pass.
Only the supplied packet is sent; the extension does not collect files or session
history. Normal Pi tool-call history contains the packet and result. Jev returns
classifications, so any textual explanation comes from the reviewing agent.

Run `npm run test:jev` with the repo's global Pi and TypeScript installations.
This checks the installed Pi loader/types and mocked HTTP behavior without a key
or API calls. It does not establish review accuracy or savings. Before expanding
to automatic checks, compare a small set of clear, ambiguous and evidence-missing
examples against human judgments, including paraphrases and preparation effort.
Risk checks, completion verification, skill/tool selection, context retention and
model routing remain candidates for later work.

## oh-my-pi

[oh-my-pi](https://github.com/can1357/oh-my-pi) is installed as a release binary
through mise, pinned in `private_dot_config/mise/config.toml`.
Install it on an existing machine with:

```bash
chezmoi diff ~/.config/mise/config.toml
chezmoi apply ~/.config/mise/config.toml
mise install github:can1357/oh-my-pi
```

Run `omp` to start. Use `omp config list` to inspect available settings, or
`/settings` inside a session. Global settings live in `~/.omp/agent/config.yml`;
project settings live in `.omp/config.yml`. These are separate from Pi's settings.

`.chezmoitemplates/omp-config.yml` declares the portable OMP settings, including
`advisor.enabled: true`. `dot_omp/private_agent/modify_private_config.yml`
deep-merges them into `~/.omp/agent/config.yml`, with declared settings taking
precedence and undeclared settings preserved. OMP-owned state such as
`setupVersion`, consent choices, and machine-specific settings stays local.
Credentials, databases, and session history are not tracked.

Edit the defaults file to persist a setting across machines, then run
`chezmoi diff ~/.omp/agent/config.yml` and `chezmoi apply ~/.omp/agent/config.yml`.
Do not import the entire OMP config with `chezmoi add`; copy only the intended
portable settings into the defaults file. OMP UI changes to declared settings
are reset to the dotfiles values on the next apply.

The main session uses `openai-codex/gpt-6.1-sol` with an explicit
`defaultThinkingLevel: high`. Agent overrides select Sol `medium` for `scout`
and Astra `xhigh` for `reviewer` and `security-reviewer`. The generic `task` and
mechanical `sonic` agents keep their bundled `auto` and `medium` thinking
selectors. Model defaults are verified in fresh sessions; agent overrides are
resolved at the next spawn.

`dot_omp/private_agent/WATCHDOG.yml` deploys the user-wide advisor roster to
`~/.omp/agent/WATCHDOG.yml`: Advisor Astra uses
`openai-codex/gpt-6-astra:xhigh` and reviews final yields (`agent-end`), with the
default interval of 1 and asynchronous review (`syncBacklog: off`).
The advisor instructions focus on correctness and avoiding over-engineering:
findings need concrete evidence and a minimal fix, not speculative hardening,
future-proofing, or style-only changes. Edit the roster here, then run
`chezmoi diff ~/.omp/agent/WATCHDOG.yml` and
`chezmoi apply ~/.omp/agent/WATCHDOG.yml`.
Project rosters can override advisors with the same name.
Use `/advisor status` to inspect the runtime; `/advisor on` and `/advisor off`
only change the current session, not the saved enabled setting.

Install Herdr's OMP integration after installing or upgrading Herdr:

```bash
herdr integration install omp
herdr integration status
```

Herdr owns `~/.omp/agent/extensions/herdr-omp-agent-state.ts`, which is excluded
from chezmoi. Start a new OMP session inside Herdr to load the integration.
