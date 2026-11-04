# Sub-agent dispatch & verification protocol (adopted 1 Nov 2026, amended 2 Nov 2026; §3a fill-stage addendum 3 Nov 2026)

Process postmortem → protocol. The failure modes below recurred across the
31 Oct–2 Nov 2026 EaseApply sessions and are now doctrine; every rule names the
observed evidence that produced it. The amendment adds §§7–10 from the
F2W3 ten-attempt episode (a run that exhausted the full inline-fallback budget
and whose final passes produced broken partials narrated as complete).

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
disk across two checks. Those are prompt-shape problems, not time problems — see §3.

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
- **At the boundary** → *reasoning-is-done*: when a prior pass demonstrably solved the
  design (its trace is visible), explicitly forbid re-derivation and convert the prompt
  to "convert the completed design to disk in two writes". See §8.
- Any failure with `trip_count: 0` + a template reply ("I'll start by reading the task
  spec…") is a harness/profile defect, not a task-difficulty defect → change shape
  immediately, do not repeat the wording.

**Evidence:** nine F2W3 reinjections with progressively re-worded long briefs produced
zero files; the single-tool-call prompt wrote the file in one try. Meanwhile identical
long briefs on a different model profile succeeded — so the prompt shape, not the task,
was the variable.

## 3a. Fill-stage caps and the honest-FAIL floor (amended 3 Nov 2026)

**Problem observed (3 Nov, EquityScout critic wave):** skeleton-first works — but the
*fill* stage is its own death mode. Two critic runs wrote the skeleton on call 1, then
died at trips 12–37 while filling row-by-row with unbounded reads. Separately, a builder
run TIMED_OUT at the 1800s cap mid-fill with 549 insertions stranded on disk.

**Rule (applies to every rung of the §3 ladder that involves filling a skeleton):**
1. **Per-item call caps are part of the contract.** State them explicitly in the prompt:
   one table row or surface per tool call (never batch >2), ≤3 calls per test file, and a
   total budget ("~12 calls"). Unbounded "fill it all" is what kills the run.
2. **Open every reinject with the orchestrator's VERIFIED disk state** — files + counts +
   an explicit do-NOT-redo list ("34 files, 549 insertions on disk; do NOT re-read the
   spec or re-hook components"). The agent's own account of its progress is not evidence
   (§7); only the orchestrator's disk check is.
3. **Honest-FAIL floor:** the contract ends with "if you cannot finish within the budget,
   write `VERDICT: FAIL` with the reason and mark unfinished rows — an honest FAIL on
   disk beats a SUCCEEDED with nothing." A FAIL outcome is escalatable by the
   orchestrator; a missing file is a wasted run.
4. **`UNVERIFIED` is a legal verdict value for audit fills.** An agent filling from
   accumulated memory marks un-inspected rows `UNVERIFIED` + what would resolve them —
   never invented evidence. The orchestrator spot-checks claims afterward (§4).

**Evidence (3 Nov):** design-audit-final died twice at the fill stage (skeleton on disk,
0 rows filled); the two-call contract (fill-from-memory in one call → ≤2 spot reads →
verdict, honest-FAIL fallback) bounded it. gate-audit-code died without any file; the
skeleton-first staged brief wrote the skeleton on call 1. U20 builder: a 900K-token
read-only death became 549 disk insertions once the reinject opened with the verified
disk state and forbade re-derivation (§8).

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
- **Gate autofixes are not automatically correct:** `ruff --fix` (e.g. SIM117 combining
  nested `with` statements) can restructure the very semantics under test; evaluate each
  autofix against what the test asserts before accepting it.

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
Also account for daylight-shifted local clocks when computing "longest unit timeout +
5 min".

## 7. SUCCEEDED is a status, not evidence (the zero-output success loop)

**Rule:** a sub-agent report is a claim; the artifact delta is the evidence. Completion is
declared only when the orchestrator has measured the file(s) itself. A reply that says
"file is on disk (N bytes confirmed)" is a **claim to re-measure**, not a fact: across the
F2W3 loop, consecutive "SUCCEEDED" reports carried identical "confirmed on disk"
narration while the file did not exist, then later while it was a mid-construction
partial. At the fallback boundary the output is the **sloppiest**, not the most careful —
the final passes produced invented column shapes and placeholder `raise`s, all narrated
in the language of completion.

**Rule (canonical phrasing):** never let a unit's self-narration close a unit. `ls` +
`grep -c` the artifact, read the bodies (§4), and if the report and the disk disagree,
**the disk wins and the report is void** — including for commits! (a stub suite was once
committed on the strength of a narration, see §4 evidence).

**Evidence:** F2W3 attempts 5–9: `status: "succeeded"` + replies like "File 1 is on disk
(1931 bytes confirmed). Now the result file:" with `trip_count: 0`; disk held the
unchanged 1935-byte stub or a structurally broken 8 KB partial (generic
`(id, uid, value)` seed SQL matching none of the six real tables, a
`raise NotImplementedError` placeholder in the fixture, zero test functions) — while the
same session's other units on a different profile wrote complete files first try.

## 8. Reasoning is not writing (the deliberation trap)

**Rule:** a run can fully solve the design in reasoning and still emit nothing. Only file
deltas are observable progress; "the model worked it out" is not a state the orchestrator
can act on. Two corollaries:
- **When prior reasoning exists, forbid re-derivation.** The prompt becomes "the design is
  done; convert it to disk in N writes. Do not re-read, re-derive, or re-decide." A run
  that re-derives from scratch burns the whole budget on deliberation it already
  completed (observed: 8 wall-clock hours of correct design, zero writes).
- **Pre-decide every permission question.** An unanswered question — "is `# noqa: S608`
  allowed here?", "which exception class does RLS raise?", "compose identifiers with
  `sql.Identifier`?" — is not an intelligence problem, it is a permission problem, and it
  burns a whole budget. The orchestrator settles it in the brief with the codebase
  precedent cited ("`# noqa: S608` is permitted — precedent: tests/test_db_pg.py and
  conftest.py").

**Evidence:** the user-transcribed F2W3 trace contained a complete, correct design
(probe-role pattern, FK-aware seeding, exception classes, S608 handling) that never
reached a tool call. The final successful dispatch converted it by (a) forbidding
re-derivation and (b) pre-deciding the three permission questions — and it wrote the file
in the same budget where nine re-derivation prompts had failed.

## 9. Inline fallback at the boundary: author from source, not from the failed draft

**Rule:** when the 10-failure threshold is crossed and the orchestrator goes inline, the
artifact is authored from **verified source contracts** (migration files, existing
fixtures, the real implementation under test), never by repairing the failed run's draft.
The draft of a budget-exhausted run is structurally unreliable: it invents schemas to fit
its prose, leaves placeholder `raise`s, and omits the contracts it never read. Then
verify the inline artifact with the same anti-vacuous check (§4) — an inline author is
not immune to the stub failure mode either.

**Evidence:** the F2W3 partial was repaired to correct only by re-reading
`migrations/001/002/009/026` for the six tables' real column shapes, the F2-W2 probe-role
fixture in `tests/test_db_pg.py`, and `pg_tenant.py`'s re-entrancy guarantees (which
corrected an assumption the draft had introduced about exception paths mid-transaction).

## 10. Wave sequencing by ownership, with consumed files gating later waves

**Rule:** within a wave, units must be file-disjoint (existing doctrine). Across waves,
the organizer additionally checks **consumed edges**: when unit X in a later wave must
edit a file that unit Y in this wave also needs (e.g. `fit.py` for both the
empty-extraction propagation and the serve-stored-fit change), one of them is *sequenced*
into a later wave — never edited concurrently, and never silently omitted. The deferred
unit's spec carries the dependency as a `Depends:` line plus a handoff note in the
earlier unit's result file (e.g. "needs fit.py wiring: …").

**Evidence:** the 1 Nov fixwave initially had two units both editing `fit.py` (the
extraction-outcome propagation and the serve-stored-fit path). One was moved to wave 3
and the other ships an additive key with a documented handoff, so neither blocks.

---

**Cross-references:** `ORCHESTRATION.md` §B2 (timeouts, recovery) amended to point here;
the workspace overlay `AGENTS.md` "Failure protocol" line carries the 10-failure figure
and the max-time rule for machine-specific harness mapping; canonical-first per the repo
path rule; this file is mirrored byte-identical to
`Multi-agent-Workflow-Universal-IDE-Setup/knowledge/`.

**UNIT_LEDGER (2026-11-02):** complements §7 — where §7 says disk is the evidence for a
single unit's deliverable, the project's `tasks/UNIT_LEDGER.md` is the disk-based source
of truth for *which* units exist and are open/closed across the whole project. Read it
before dispatching any unit (skip ✅ CLOSED / 🔄 IN-FLIGHT); update at every closure. See
`ORCHESTRATION.md` §D.
