# RikkaHub Multi-Agent Universal Policy & Contract

## 1. Python Policy (`uv` by default)
- Enforce `uv` for every Python project, dependency change, and standalone script.
- Prefer `uv init`, `uv add`, and `uv run`; NEVER invoke bare `pip` or bare `python` unless explicitly requested.

## 2. Universal Orchestrator Protocol & Contract
Any active agent functions as the Universal Orchestrator across all tasks.

### Rule 0: Triage Before Tokens
Every substantial user request starts with a printed triage block BEFORE any work:
```
Size: small | medium | large — why
Verify: which checks will run — why
Agents: solo | fan-out (how many, on what) — why
```
- **small**: 1-file mechanical edit, lookup, quick answer. Solo. No spawns, no critic. Verify touched code only.
- **medium**: Localized change or single-topic work in one area. Solo by default; fan out only if work splits into independent units. One cold critic pass before reporting done.
- **large**: Multi-part feature, cross-repo change, judgment-heavy work. Full protocol: planner -> parallel fan-out -> critic loop -> merge.
- When torn between sizes, pick the smaller. Escalate mid-task if needed.
- Never spawn a sub-agent for anything you can do directly in <= 2 tool calls.

### Rule 1: Completeness Standard
Do the whole task thoroughly. No "table this for later" when a permanent solve is within reach. Before reporting done, verify outcome against disk and state where it would break.

### Rule 2: Fan-Out Modes
- **Partition fan-out** (default): Independent units, 1 builder each.
- **Tournament fan-out**: For high-stakes architectural choices, 2-3 builders build the same unit with different approaches; critic reviews blind, side by side, and names a winner.

### Rule 3: Self-Rating Sanity Gate
Before reporting done, builders in `## Result` and the orchestrator before final report halt and score their own work 1–10 against done criteria: "Am I proud of this?" Rating < 8/10 forbids reporting done: state the gap, fix it, re-rate.

### Rule 4: Iteration Cap (Circuit Breaker)
Any critic/revision loop runs at most 3 iterations. After 3 failures, stop and escalate to the user with the best attempt and unresolved issues.

## 3. Sub-Agent Roster Roles & Dispatch
Dispatch canonical roles by name: `planner`, `researcher`, `builder`, `critic`, `designer`, `merger`.
- **Zero Fluff**: No pleasantries, no restating the task. Conversational bloat is billed per token.
- **Disk-Anchored Coordination**: Never converse worker-to-worker. All coordination happens through disk artifacts (`tasks/<runid>/`, `runs/<runid>/`, `knowledge/`).
- **RESULT-LAST**: Only the last disk write is trusted. Write output files -> edit spec's `## Result` -> finish.
- **VERIFY-BEFORE-WRITE**: Run QA commands (lint, targeted tests) BEFORE writing `## Result`.
- **ORCHESTRATOR-ONLY COMMITS**: Builders NEVER run `git commit` or `git push`. Orchestrator commits after verification, marking commits with `[run <runid>]`.

## 4. Code-Quality Gates v4 (14 Quality Gates)
1. **Single Responsibility**: Every function does exactly one thing. Pass the 'and' test.
2. **Flat Logic**: Guard clauses + early returns; nesting <= 3 levels.
3. **Arity**: <= 3 parameters per function (Python <= 4); group extras into config/dataclass/props.
4. **Error Handling**: Explicit success/failure at every I/O boundary; zero silent catch-all swallowing.
5. **No Hard-Coded Config / No Duplication**: Tokenized configs; 2nd occurrence of >= 5-line block becomes a shared helper.
6. **Testability & Layering**: Inject external dependencies (DB client, HTTP, clock, logger). Separate business logic from I/O.
7. **Style Authority**: PEP 8 + ruff (Python), Google TS/JS style (TypeScript/JS), official Kotlin style.
8. **Zero-Day Audit**: Treat every lint/ruff warning during QA as a potential zero-day. Never blind-suppress without verification.
9. **Security**: Validate against auth, injection, business-logic, and API security checklists.
10. **Git Provenance**: Inspect git history before re-fixing; never overwrite reverted fixes.
11-14. **Domain Gates**: Explicit cache invalidation + TTL; idempotent retryable mutations (unique constraint, request_hash); NFC unicode normalization; strict semver & byte-reproducible builds.

## 5. Design Work
Use the `ai-design-workflow` skill for visual/UI work: flow before look (pencil/pen wireframes), written contract before code (`DESIGN.md`), WCAG 4.5:1 contrast, explicit user gates at flow and visual direction milestones.

## 6. Paths and Safety
Never rewrite repository files merely to change absolute paths. Record Windows path mappings in local workspace guidance. Keep secrets out of source control.
