# Sub-agent dispatch & verification protocol (adopted 1 Nov 2026)

Process postmortem → protocol. Two failure modes recurred across the 31 Oct–1 Nov
EaseApply sessions and are now doctrine; every rule below names the observed evidence
that produced it.

## 1. Time limits: always the maximum

**Rule:** every `subagent_dispatch` / `subagent_reinject` sets `timeout_seconds` to the
tool maximum (1800 on the RikkaHub harness). Never shrink a cap "so failures iterate
faster".

**Evidence (F2W3, run 20261031-scoping-f2f3):** the orchestrator progressively shrank
caps 1800→1200→900 on a unit emitting nothing, treating silence as stuck. Nine attempts
produced zero disk output while the run was, in fact, still reasoning (the tenth attempt
at full budget wrote the file). A low cap converts in-progress reasoning into a TIMED_OUT
and burns a failure slot against the wrong budget. `ORCHESTRATION.md` §B2's old
"Default 300, 600–900 build-heavy, max 1800" guidance is superseded by this rule.

**Corollary:** silence is not a failure signal. The failure signals are (a) `trip_count: 0`
plus a boilerplate-only reply (the run never started tool work), or (b) no file delta on
disk across two checks. Those are prompt-shape problems, not time problems — see §2.

## 2. The 10-failure rule (inline fallback threshold)

**Rule:** inline fallback only after **10 sequential failures** of the SAME run
(`subagent_reinject` the same run id; never a fresh dispatch for a failed task). Applies
to every unit type: builder, planner, critic, investigator. No exceptions for "the file is
small", "I already have the content", or "it's just transcription" — those rationalizations
are exactly the case the rule exists for (observed: the orchestrator authored a section
inline at 2 failures of a planner run, against the then-prevailing 7-rule).

**Evidence:** the same F2W3 unit that failed 9 times wrote its file on attempt 9; had the
orchestrator gone inline at 2–3 failures (a tempting call, the remaining work was
mechanical transcription), the sub-agent budget that later closed four other units would
have been spent on orchestrator typing instead.

## 3. Prompt-shape ladder (change the contract, not the wording)

**Rule:** when a run fails twice, do not re-word the same prompt. Escalate the contract
shape, once per failure:
- **First failure** → next dispatch is *staged*: result-file skeleton written FIRST as the
  mandatory first tool call, then implement with per-step checkpoints appended.
- **Second failure** → *finish-only*: implementation is presumed on disk; the brief is
  gates + closure only, with a verification checklist replacing the full spec.
- **Third failure** → *single-tool-call*: one write, fully-specified content, nothing else
  permitted ("write this file, then stop"). Long prompts with inline code blocks and
  optional follow-on steps failed 9× where this succeeded on the first try.
- Any failure with `trip_count: 0` + a template reply ("I'll start by reading the task
  spec…") is a harness/profile defect, not a task-difficulty defect → change shape
  immediately, do not repeat the wording.

**Evidence:** nine F2W3 reinjections with progressively re-worded long briefs produced
zero files; the single-tool-call prompt wrote the file in one try. Meanwhile identical
long briefs on a different model profile succeeded — so the prompt shape, not the task,
was the variable.

## 4. Verification: read the bodies, not the gates

**Rule:** gate output is necessary, not sufficient. When a unit's deliverable is a test
suite, the orchestrator verifies the SUBSTANCE before committing:
- **Anti-vacuous-test check (mechanical, one command, mandatory before any test-suite
  commit):** count `^def test_` vs `^def test_.*assert` (or `assert ` occurrences) in the
  file. Fewer asserts than test functions = stub, whatever the gate says. Catch `...` and
  `pass` bodies explicitly. In pytest a `...` body is a vacuous PASS — an empty suite
  reports green the moment it stops being skipped.
- **Spec line-by-line:** tick the spec's done-criteria checkboxes from the artifact on
  disk, never from the unit's self-rating (F2W3 self-reported 7/10 with a false-green
  suite; the orchestrator's own close-out then repeated the error).
- **Collection vs skip vs pass:** under a capability-gated pin (e.g. sqlite-only mock
  mode), a suite must collect without error and skip cleanly — but "skips clean" is never
  "probes green". State the deferral in the result file in the unit's own words.

**Evidence:** F2W3's suite shipped as commit `ab9e726` (7 skipped, ruff clean) with all
seven probe bodies as `...` stubs. The suite would have flipped to "7 passed" against a
real PG schema while asserting nothing — the precise false green the module's own honesty
contract prohibits. Caught by a later spec audit, not by any gate.

## 5. Honest partial-commit messages

**Rule:** if a committed artifact is known-incomplete (deploy-gated, skip-gated, stub),
the commit message says what is complete and what is pending. A suite of stub probes is
not "test(db): isolation probe suite" — it is "scaffolding; bodies pending".

## 6. Watchdog arithmetic

**Rule:** derive `at_unix_ms` in the same command that prints the human-readable fire
time, and re-read `nextRunAt` from the created job to confirm it matches. Three mis-set
watchdogs fired 30–35 min late and one fired two days late during the 31 Oct session;
each was a silent tz/ms arithmetic error that the confirmation read would have caught.

---

**Cross-references:** `ORCHESTRATION.md` §B2 (timeouts, recovery) amended to point here;
the workspace overlay `AGENTS.md` "Failure protocol" line carries the 10-failure figure
for machine-specific harness mapping; canonical-first per the repo path rule.
