# ORCHESTRATION — Run Protocol

The main chat assistant is the orchestrator. It never delegates orchestration
decisions; workers execute bounded tasks and report results.

## A. Standard run (large tasks)

1. **Triage** — print the triage block (CONTRACT.md Rule 0).
2. **Plan** — either plan directly or dispatch a `planner` sub-agent. The plan is
   task files: `tasks/<runid>/<NN>-<role>.md`. `<runid>` = `YYYYMMDD-HHMM-<slug>`.
   Each task file is SELF-CONTAINED: a sub-agent will read only that file.
3. **Fan out** — dispatch builders in parallel (one `subagent_dispatch` call per
   unit, issued in a single block). Each dispatch gets:
   - `task`: "Read /workspace/multiagent/tasks/<runid>/<file>.md, execute it
     exactly, write your output where the spec says, REPLACE the ## Result
     placeholder in the file with your actual result."
   - `agent`: the profile name for its role (builder / critic / researcher /
     planner / merger — see PROFILES.md). Do NOT pass `system_prompt`.
   - `tools`: only what the role needs
   - `label`: `<runid>:<role>-<NN>`
   - Concurrency: ≤3 parallel by default (raise only with user consent; global cap 16).
   - While dispatching, append one line per dispatch to `tasks/<runid>/RUN.md`:
     `timestamp · label · subagent id · status`. Retries get new lines. The run
     must be reconstructable from RUN.md alone (observability / audit trail).
   - Tournament units (CONTRACT Rule 2): dispatch 2–3 variant builders for the
     SAME unit, deliberately different approaches.
4. **Watchdog (mandatory, v3)** — immediately after the last dispatch of a
   wave, schedule a one-shot `llm` job (`schedule_job`, `schedule_type: once`,
   name `watchdog-<runid>-<wave>`) to fire at (longest unit's timeout_seconds)
   + 5 min, minimum +15 min. The prompt must be SELF-CONTAINED (the job runs
   in a fresh turn): run id, `tasks/<runid>/` paths, instruction to read
   RUN.md + every task file's `## Result` + CHECK OUTPUT FILES on disk
   (SUCCEEDED ≠ done), then:
   - dispatched-but-unfinished unit → DO NOT attempt `subagent_dispatch`:
     headless runs (cron / workflow) are hard-blocked by the no_recursion
     guard ("run the work inline instead" — verified live 20260907-1630-
     watchdog-test, ERR-20260907-002). Instead: append findings to RUN.md
     (which units are cut off, what's missing on disk) and post a short
     notification to the user, so the next interactive message triggers
     next-message recovery (§B2) — THAT path re-dispatches ONCE with resume
     wording: "partial work may exist at <output path>; read it, continue
     from the last checkpoint, never redo completed steps". Optionally
     schedule one more watchdog +15 min as a second reminder.
   - unit still actively working (fresh RUN.md timestamps) → do nothing,
     schedule one more watchdog check +15 min;
   - all units done (disk-verified) → append final status to RUN.md and stop;
   - a unit already re-dispatched once (by interactive recovery) and failed
     again → escalate to the user, do not loop.
   Record the job name in RUN.md. One-shot jobs self-expire — no cleanup.
5. **Collect** — read each task file's `## Result`. Blocked/failed units are
   re-dispatched once with the failure appended; second failure = escalate.
6. **Critique** — dispatch a `critic` blind: give it the spec paths + output paths,
   never builder identities or the run history. In tournament units the critic
   ranks the variants side by side and names a winner.
7. **Merge** — `merger` (or the orchestrator for small merges) combines into
   `runs/<runid>-final.md` and applies the critic's blockers first.
8. **Report** — to the user: what ran, what the critic said, where the output is.
   Restate actual verification performed. Before reporting, apply the self-rating
   gate (CONTRACT Rule 3): rate the merged result 1–10 against the goal; a "no"
   means fix it first, don't report yet.

## B. Medium tasks

Solo execution, but with one cold critic pass before reporting done — either a
sub-agent critic or a deliberate self-review against the spec, stated explicitly.

## B2. Sizing and checkpoints (v2 — anti-death rules)

Workers die when runs exceed budget or the parent turn ends; runs are
in-memory and NOT resumable. These rules make every run survivable:

- **Unit sizing**: one dispatch = ≤30 minutes of worker work INCLUDING
  verification. Large builds / suites are staged units chained with Depends
  (prepare → build → verify), never one monolithic unit.
- **Checkpoint-or-die**: workers must write partial output to disk after every
  step (builder/researcher/merger prompts v2 enforce this). Orchestrator-side:
  never hold plan or RUN.md updates in memory — write them immediately.
- **Background long commands**: any command expected over ~2 minutes runs
  detached (workspace_run_background / background:true) and is polled. A
  foreground wait on a build is the #1 cause of budget death (vite ~1m50s
  killed a turn; vitest+build in one turn killed another).
- **Timeout per dispatch**: always set `timeout_seconds` explicitly. Default
  300 is right for small units; 600–900 for build-heavy ones. Max 1800.
- **Early-stop**: if a worker nears ~60% of its budget it must stop, checkpoint,
  and hand off a status paragraph. The orchestrator treats a clean partial as
  a success and re-dispatches a continuation unit referencing the partial.
- **Recovery protocol (parent turn dies)**: on the next turn, read
  `tasks/<runid>/RUN.md` + the task files' `## Result` sections from disk,
  mark each unit done/partial/not-started, then re-dispatch only what's
  missing. Never re-plan from memory.
- **Next-message recovery (mandatory, v2)**: at the start of ANY user
  message, if any run directory under `tasks/` contains dispatch lines
  without a final status in RUN.md, or task files with unfilled `## Result`
  placeholders, scan it FIRST, re-dispatch partial units with resume
  wording, and report run status alongside the user's request. A user
  message is a free recovery trigger — never waste it. (Complements the
  §A watchdog, which fires on a timer; this fires on the user's next ping.)
  This is also THE re-dispatch path for §A watchdog escalations: the headless
  watchdog detects cut-offs and notifies (it cannot dispatch — no_recursion);
  recovery here does the actual re-dispatch.
- **Wave quality gating (v4, 2026-09-14)**: a unit is session-verified only
  when (a) ## Result filled, (b) output files on disk, (c) QA clean for
  touched paths, (d) targeted tests green. QA-clean means: no NEW lint
  findings on touched paths and zero ERRORS on touched paths (pre-existing
  errors on a touched file are fixed by the touching unit; pre-existing
  warnings are fixed or one-line-justified in the repo's quality ledger —
  e.g. platform/docs/quality-ledger.md). The orchestrator runs QA inline
  (seconds) as part of wave-gate verification; gates + commands:
  /workspace/multiagent/knowledge/code-quality.md. Rationale: 61% of
  agentic PRs are merged with minimal review (arXiv 2601.16839) — this
  check is the counter-gate.

## C. Failure design (from MindStudio, adapted)

- **Timeout**: `subagent_dispatch` has `timeout_seconds`; set per unit (default 600).
- **Bad output**: critic FAIL → one revision loop (max 3 total, Rule 4), revision
  task file includes the critic's issues verbatim.
- **Escalation dump**: when the iteration cap trips, write `tasks/<runid>/ESCALATION.md`
  BEFORE escalating — critic issues verbatim, best-attempt paths, what was tried.
  The human (or a future run) resumes from that file; nobody re-burns tokens
  rediscovering the failure.
- **Blocked dependency**: dependent task files carry `Depends: <NN>`; the
  orchestrator holds them until the dependency's `## Result: done` exists.
- **Partial completion**: task files are idempotent — a re-dispatch REPLACES the
  `## Result` section; nothing depends on in-place edits elsewhere.
- **Resume-by-default (v2)**: before re-dispatching a failed/partial unit, the
  orchestrator reads the spec's output area on disk and records in RUN.md what
  is already done. The re-dispatch task text states: "partial work exists at
  <path>; read it, verify against done criteria, continue from the last
  checkpoint — do not redo completed steps."
- **Statelessness**: never assume a worker remembers anything; every dispatch
  re-states the file paths and the format.
- **Scaffold before dispatch (hard ordering)**: `tasks/<runid>/` with RUN.md
  and all task files must exist on disk BEFORE any `subagent_dispatch` call.
  Run 20260906-b2 dispatched from session memory; when every run was cut by
  the turn budget, there was no spec or audit trail to recover from. RUN.md
  is the orchestrator's write-ahead log: write the dispatch line before
  dispatching, update the status after.

## D. State hygiene

- One run = one directory under `tasks/`. Never mutate a completed run's task files
  (append-only corrections in a `## Addendum`).
- `runs/` holds only merged artifacts a human might read.
- After the run: the orchestrator distils durable lessons into memory (memory_tool)
  or `~/learnings/`, and deletes nothing — task files are the audit trail.

## E. Smoke test (grigorev-style verification)

Run when the system is installed or after harness changes:

1. Create `tasks/smoke-<date>/` with three task files: `01-builder.md`,
   `02-builder.md`, `03-builder.md`. Each spec: compute one distinct arithmetic
   result (e.g. 17×23, 2^12−1, sum of primes <30) and write it to
   `tasks/smoke-<date>/out-<NN>.md` with the role name and result.
2. Dispatch the three builders in parallel (single block, `agent="builder"`).
   Also dispatch one 1-trip probe (`agent="builder"`, task = reply PROFILOK,
   timeout 90) to confirm profile resolution still works after app updates.
3. Verify all three output files exist with correct arithmetic (orchestrator
   recomputes).
4. Dispatch one `critic` over the three specs + outputs.
5. PASS → record `runs/smoke-<date>-PASS.md`. Any failure → fix the protocol, rerun.

## F. Knowledge & context layer (memory tiers, file-based)

Workers are stateless, so durable context lives in files — three tiers, per the
context-engineering model in the harmonization stack:

- **Project context** — conventions live where the project lives (e.g.
  `/workspace/ai-job-search/RIKKAHUB.md`). Task specs POINT at them, never copy them.
- **Task context** — the task spec itself (self-contained).
- **Collaborative context** — other agents' outputs. Cross-unit dependencies are
  expressed as file paths (`Depends: <NN>`); a dependent worker reads the upstream
  `## Result` straight off disk — no agent-to-agent messaging.

Durable research findings go to `/workspace/multiagent/knowledge/<topic>.md`,
written by researchers; later runs reference them instead of re-researching.
`knowledge/README.md` is the index. Entries stay SHORT — summary + pointers, not
dumps — and a task spec references only the 1–3 files relevant to it. The memory
layer is a filter, not an archive: fetching the few relevant facts beats carrying
the whole history.
