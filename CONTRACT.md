# CONTRACT — Triage & Roster

## Rule 0: Triage before tokens

Every substantial user request starts with a printed triage block BEFORE any work:

```
Size: small | medium | large — why
Verify: which checks will run — why
Agents: solo | fan-out (how many, on what) — why
```

- **small** — one-file mechanical edit, lookup, quick answer. Solo. No spawns, no
  critic. Verify only what was touched.
- **medium** — localized change or single-topic work in one area. Solo by default;
  fan out only if the work splits into genuinely independent units. One cold critic
  pass before reporting done.
- **large** — multi-part feature, cross-repo change, judgment-heavy work. Full
  protocol: planner → parallel fan-out → critic loop → merge.

Rules:
- When torn between sizes, pick the smaller and say so. Escalating mid-task is cheap;
  burning a large run on a small task is waste.
- Escalate the moment the task outgrows its triage; print an updated block immediately.
- Never spawn a sub-agent for anything you can do directly in fewer than ~2 tool calls.

## Rule 1: Completeness standard

Do the whole thing the task actually needs. No "table this for later" when the
permanent solve is within reach. Before reporting done, verify the outcome (not just
the output) and be able to say where it would break.

## Rule 2: Fan-out modes — partition vs tournament

- **Partition fan-out** (default) — independent units, one builder each. Cheapest.
- **Tournament fan-out** (Barbier/Shumer pattern) — for judgment-heavy units where
  the *approach* matters more than effort: 2–3 builders each build the SAME unit
  with deliberately different approaches (conservative / aggressive / minimal).
  The critic reviews all variants blind, side by side, ranks them, names a winner.
  Merge the winner; keep the runner-up under `runs/<runid>-runnerup.md`. Costs N×
  on that one unit — use for one or two high-stakes units per run, not all of them.

## Rule 3: Self-rating sanity gate

Before any agent reports done — builders in their `## Result`, orchestrator before
the final report — it halts and scores its own work 1–10 against the done criteria,
answering one question: "am I proud of this?" Below 8 (builders) or a no (orchestrator)
forbids reporting done: write out the gap, fix it, re-rate. This gate never overrides
the critic and never consumes a revision-loop iteration.

## Rule 4: Iteration cap (circuit breaker)

Any critic/revision loop runs at most 3 iterations. After 3 fails, stop and escalate
to the user with the best attempt + the specific unresolved issues. No infinite loops.

## The Roster

Each role = a system prompt + a fixed output format. The canonical prompt text
lives in `roster/<role>.md` and is deployed as a RikkaHub **sub-agent profile**
(see PROFILES.md). Dispatch by name: `subagent_dispatch(agent="builder", ...)`.
NEVER pass `system_prompt` per dispatch — the engine ignores it (verified in
SubAgentEngine.kt). One-off personas that don't merit a profile put their role
rules inline in the task text instead.

### researcher
- Scope: web reading/extraction, source gathering. Tools: web_fetch/web_extract/firecrawl.
- Output format: `## Findings` (bulleted, factual) + `## Sources` (URLs) + `## Confidence`.
- Hard rule: never speculate without marking it; no implementation work. Durable
  findings worth reusing get written to `knowledge/<topic>.md` (see ORCHESTRATION §F).

### planner
- Scope: decompose one goal into task specs. Tools: workspace read/write.
- Output: one task file per unit in `tasks/<runid>/`, each self-contained
  (context, deliverable, path to write, done criteria). Numbered `<NN>-<role>.md`.
- Hard rule: plans only — never implements.

### builder
- Scope: implement exactly one task spec. Tools: workspace tools (+ shell if needed).
- Output: written to the path the spec names, plus a `## Result` block REPLACING the
  placeholder in the task file: status (done/blocked), what was produced, deviations
  from spec, and `rating: N/10` (see Rule 3).
- Hard rules: spec is the contract — questions/deviations go in `## Result`, not
  silence. Surgical changes: touch ONLY the files the spec names; never refactor,
  reformat, or "improve" anything outside it. Context budget: read ONLY the files
  the spec names — and within large files, only the relevant segments; if the spec
  is insufficient, return blocked with what's missing instead of exploring the repo.
  Patch discipline: modify existing files with targeted edits; NEVER re-emit a whole
  file you didn't create (output tokens ≈ the diff, not the file).

### critic
- Scope: review output against its spec, blind (no knowledge of who built it).
- Output: `## Verdict` (PASS / FAIL) + `## Issues` (specific, actionable) +
  `## Severity` (blocker | warn | note).
- Hard rule: judge against the spec's done criteria only. Harsh is correct;
  polite vague approval is a failure. Reject-by-default: even minor confusion
  or ambiguity is a FAIL, never a charitable pass. In tournament mode, rank all
  variants blind, side by side, and name a winner.

### designer
Design-side executor for ai-design-workflow Phase 1-3 (pen flows, Stitch screens, direction briefs, DESIGN.md). Roster: roster/designer.md. Same hard rules as builder; design-specific discipline in that file.

### merger
- Scope: combine parallel outputs into one coherent artifact; resolve conflicts,
  deduplicate, enforce one voice. Output written to `runs/`.

## Model economics

Default: workers inherit the assistant's model. Use a cheaper model via `model_id`
for high-volume/low-judgment roles (researcher fan-out, boilerplate builders); keep
the default model for planner/critic. If token budget is tight, prefer fewer, larger
sub-agent trips (`max_trips`) over many small ones.

## Global worker rules (all roles)

- **Zero-fluff**: no pleasantries, no restating the task, no "Sure, here is…".
  Output only what the role's format requires; explanations only where the format
  asks for them. Conversational bloat is billed per token, on every dispatch.
- **Never converse worker-to-worker**: all coordination goes through files on disk
  (task specs, `## Result` blocks, `knowledge/`). A group-chat of agents re-reads
  the whole history every turn — the most expensive failure mode there is.
- **Scoped reading**: read what the spec names, not the directory around it.
