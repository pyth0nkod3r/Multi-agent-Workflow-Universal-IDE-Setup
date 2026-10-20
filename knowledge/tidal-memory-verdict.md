# tidal-memory — verdict for EaseApply (21 Sept 2026)

Repo: github.com/0xblewalker/tidal-memory (AGPL-3.0-only, v0.3.0, preview-grade, zero-dep Python lib + SQLite/FTS5, single author, 17★). Self-declared "preview".
FULL ANALYSIS: /workspace/platform/tasks/20260921-0741-llm-research/out-02.md §1–2.

**Verdict: INSPIRATION (skip the library; steal 2 concepts).** Why not a dependency: AGPL network clause vs closed-source SaaS; SQLite only (EaseApply=Postgres); preview maturity; design goal = open-ended chat-companion memory, EaseApply = structured-doc generation.

Two stealable mechanisms (reimplement in Postgres ~200 lines, don't vendor):
1. Importance-gated stable context — repo `store.py::stable_context()`: inject only layer=core OR semantic importance>=9 facts, bounded 6 items/1200 chars, separate from fuzzy recents. → EaseApply Expand evidence scoring: rank evidence facts by importance+recency, cap the "stable facts" block in CV/cover prompts at a fixed budget.
2. Supersede-with-archive — repo `store.py::supersede()`: valid_from/valid_to + merged_into, archive-not-destroy. → mutable profile facts (job/skill changes) keep history so prompts can say "past" vs "current".
(Less relevant now: impression-ladder decay `store.py::impression_ladder`+`engine.py::rollup` — only if session-memory/bot-listener surface ships.)
