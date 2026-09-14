# Code-Quality Gates v4 — the quality floor for ALL agent code work
Adopted: 2026-09-14 (user-approved, unanimous decision). Scope: ENTIRE workspace
— every project, current and future (platform/EaseApply, ai-job-search, Compose
apps when active, any new repo). Source of authority for builder/critic/planner
prompts (roster v4) and wave gating (ORCHESTRATION §B2). Full proposal +
adoption rationale: /workspace/multiagent/proposals/20260914-code-quality-plan.md.

## The 7 gates (builder floor; critic tags issues by gate number)

1. **SINGLE RESPONSIBILITY** — every function does exactly one thing. 'and' test:
   can't describe it without "and" → split (calculateAndSaveInvoice →
   calculateInvoice + saveInvoice). Line counts are signals, never quotas:
   linter size warnings are to justify, not laws (Google C++ guide: "no hard
   limit" even at 40 lines).
2. **FLAT LOGIC** — guard clauses + early returns, nesting ≤3 levels. Exit on
   error states first; never wrap the happy path in deep indents (Fowler,
   Replace Nested Conditional with Guard Clauses).
3. **ARITY** — ≤3 parameters; more → group into a config object / data class /
   props object (Clean Code). (Python signatures: ≤4 — DI params get a slot;
   ruff PLR0913 enforces.)
4. **ERROR HANDLING** — explicit success/failure path at every I/O boundary
   (network, DB, file, subprocess). NO silent catch-all swallowing. It is the
   #2 documented AI-code smell (63 of 364; arXiv 2601.16839).
5. **NO HARD-CODED CONFIG, NO DUPLICATION** — URLs, paths, ports, keys,
   secrets, magic numbers used 2+ places → config/env/token layer (ruff `S`
   ruleset + grep catch these; security smell class in arXiv 2601.16839).
   Second occurrence of a ≥5-line block → shared helper (GitClear: duplication
   is the dominant AI churn smell).
6. **TESTABILITY & LAYERING** — inject external dependencies (DB client, HTTP
   handler, clock, logger); never construct them inside business logic. Keep
   business logic separate from storage / UI / network layers (SOLID-DIP).
7. **STYLE AUTHORITY** — follow the repo's formatter/linter config exactly.
   Where none exists: PEP 8 + ruff format (Python), Google TS/JS style
   (TypeScript/JS), official Kotlin style (Compose). Naming follows the file's
   existing convention (research: AI code drifts into non-standard naming).
   Prefer deleting/simplifying over adding when the spec allows — negative LOC
   is real productivity.

## Process rules that make the gates real

- **VERIFY-BEFORE-WRITE (builder)**: run the repo's QA command on every touched
  area BEFORE the final artifact+## Result write. Lint clean (warnings fixed
  or justified), tests green. A green run you did not personally trigger =
  FAIL(unverified).
- **SELF-CERTIFICATION (builder)**: closing paragraph includes one gate line —
  which gates pass clean, which are justified (with justification).
- **QUALITY GATES (critic)**: runs the QA command itself (not the builder's
  word for it); flags gate violations as warn (blocker only if spec says so).
- **QUALITY section (planner)**: every spec carries the 7 gates as done
  criteria; N/A gates named explicitly. Behavior-changing specs name their
  tests and extend EXISTING test files (TDD-lite / Spec-Driven Development).
- **WAVE QUALITY GATING (orchestrator, ORCHESTRATION §B2)**: unit is
  session-verified only when ## Result filled + files on disk + QA clean for
  touched paths + targeted tests green.
- **Debt ledger** (justified warnings): platform repo docs/quality-ledger.md —
  one line per accepted warning. Visible debt ≠ invisible churn.

## Machine thresholds (all WARN level — signals, not laws)

| Signal | Frontend (eslint) | Backend (ruff) |
|---|---|---|
| Lines per function | max-lines-per-function 50 (skipBlank/Comments) | — |
| Lines per file | max-lines 300 | — |
| Complexity | complexity 10 | C90 max-complexity 10 |
| Nesting depth | max-depth 3 | — |
| Params | max-params 3 | PLR0913 max-args 4 |
| Line length | prettier printWidth 100 (owns it; E501-style rules off) | ruff format, line-length 100 (E501 ignored) |
| Unused vars | @typescript-eslint/no-unused-vars warn (argsIgnorePattern ^_) | F401/F841 (fixable) |
| Security smells | — | `S` flake8-bandit (S101 ignored in tests) |

## QA commands (the exact thing to run)

- Frontend: `npm run qa` (= eslint . && prettier --check src && tsc -b && vitest run)
- Backend: `uv run ruff check . && uv run pytest -q` (uv policy: UV_CACHE_DIR=.uv-cache in backend dir)
- Compose/other repos: no toolchain yet — gates 1-7 + self-certification apply
  by prompt; Kotlin style per gate 7 when that repo is active.

## Quick reference: monolithic vs maintainable (from the adopted guide)

| Aspect | Anti-pattern | Best practice |
|---|---|---|
| Function length | 60–100+ lines, multiple tasks | ≤50 (warn), one task |
| Indentation | 4+ layers | ≤3, guard clauses |
| Params | 5+ loose args | 0–2; group into config |
| Error handling | generic catch-all or none | explicit, isolated |
| Testability | hardcoded deps | injected, mockable |

## Citations
Google Style Guides (C++: >40 lines "think about breaking up", "no hard limit";
pyguide → pylint); PEP 8 (79/72 char reference); Clean Code / Robert C. Martin
(one thing, ≤3 args, ideal 4 / max 60 lines); SOLID (SRP, DIP); Martin Fowler
Refactoring Catalog (guard clauses; intention vs implementation); Softensity
Clean Code Cheat Sheet; Machine Intelligence Laboratory Python Style Guide
(~30 lines, "not a hard rule"); automata/aicodeguide (Spec-Driven Development,
TDD, layer separation for AI agents); Google Cloud code review style guide
(maintainability, consistency). Community corpus: dev.to Five Lines of Code
(+29 comments); r/learnprogramming 30-line thread (95 comments; 'and' test);
SE/SO function/file-length threads (133404, 9447, 374262, 621682, 4411413,
436085). Research: arXiv 2601.16839 (364 AI-code smells; 61% of agentic PRs
merged with minimal review); GitClear 150M-LOC churn study; Uplevel 2024
survey (96% concerned; 67% debug MORE with AI); arXiv 2512.05239 (SLR of bugs
in AI-generated code, naming/consistency drift). Not adopted: hard line laws
(5/20/30/40), 79-char as review argument, 20-line targets, error-level day one.
