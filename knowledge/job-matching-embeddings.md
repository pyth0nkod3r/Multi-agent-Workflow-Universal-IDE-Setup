# Knowledge: Job matching / embeddings / structured-output research (EaseApply)

Durable filter (not archive) — full doc: /workspace/platform/docs/RESEARCH-job-matching-embeddings.md (7 Oct 2026, run 20261007 research wave).

## What already exists (verified in code 7 Oct — do NOT re-recommend)
- REM deterministic scoring (scoring.py: LLM extracts, weights deterministic), LLM judge = generate_json w/ provider chain + breaker + json_object + pydantic + semantic_validator + repair/retry.
- Embeddings ARE wired: ingress._embed_ingested → job_embeddings (migration 015, HNSW cosine, 768-dim) → rank.py 3-stage (score → 0.7/0.3 cosine blend → LLM cross-encoder top-10, fail-soft).
- Default embedding model = nomic-embed-text-v1.5 (English-only per HF tags; ArguAna map@10 38.96 on its own card) via LLM provider /embeddings — verify live.
- Full-text: 005 tsvector + 020 tsvector/pg_trgm. Also: grounding.py provenance critic, bias_harness.py, esco.py flat ESCO vocab.

## Durable findings (all URLs fetched 7 Oct)
- Nomic→better-model swap is the #1 quality lever: jina-embeddings-v2-base-de (768-dim = ZERO migration, DE/EN, Apache-2.0, 8k ctx, arXiv:2402.17016) beats "new dim" alternative multilingual-e5-large-instruct (1024-dim → new migration + re-embed; MMTEB best public model, ICLR-2025 paper arXiv:2502.13595; covers de/ga/ha/sw).
- MTEB lesson: no model dominates all tasks (arXiv:2210.07316) — eval on a small held-out (profile, job, outcome) set BEFORE swapping models.
- pgvector+HNSW stays the right serving shape at EaseApply scale (README-verified; exact scan is sub-ms at <10⁵ rows; `vector` type caps 2000 dims — 4096-dim models need `halfvec`).
- Structured output: schema descriptions are a 2nd instruction channel; reasoning-field-before-verdict = +15-24pts; prompt/schema drift = -5..-45pts (arXiv:2608.08254). Constrained decoding ≠ semantic validity — keep validator (arXiv:2501.10868 JSONSchemaBench).
- Skills: distinctive-skills-per-sector from the jobs corpus (arXiv:2109.02554) = cheap ETL upgrade for REM relations + gap-bridge explanations.
- Deferred: LTR/two-tower fine-tune + GNN layer need outcome/click data (JRS review arXiv:2111.13576 says click-data availability gates method choice); BGE-M3 hybrid sparse+dense (arXiv:2402.03276, MIT) = later infra unit; Jina v3+ CC-BY-NC = SKIP for commercial.

## Top-5 queue (copy of the doc's ranking)
1 eval-substrate + DE-priority embedding swap · 2 schema-as-instruction-surface audit (reasoning-before-verdict) · 3 distinctive-skills-per-sector ETL · 4 richer embedding inputs (full job/profile text) · 5 BGE-M3 hybrid retrieval (deferred infra).
