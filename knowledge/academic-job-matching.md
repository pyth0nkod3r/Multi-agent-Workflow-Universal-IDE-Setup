# Knowledge: academic literature → EaseApply adoption candidates

Full doc: /workspace/platform/docs/RESEARCH-academic-job-matching.md (127L, 27 Sept 2026, researcher sub-agent run)
Index used: firecrawl-research-index (arXiv + PMC) + web_fetch venue checks.

## Peer-reviewed confirmations (load-bearing, verified via PMC citation metadata / arXiv abs pages)
- SKORE LLM skill extraction — MethodsX vol 16 (2026), DOI 10.1016/j.mex.2026.103907 (open-vocabulary LLM skill extraction beats lexicon methods).
- Algorithmic bias in HR recruitment (qualitative) — PLOS ONE 21(6), 2026, DOI 10.1371/journal.pone.0349400.
- Intersectional bias detection via multi-task adversarial learning — Sci Rep 16, 2026, DOI 10.1038/s41598-026-53457-9.
- conSultantBERT — RecSys-in-HR 2021 workshop, arXiv:2109.06501 (fine-tuned siamese SBERT on 270k+ consultant-labeled pairs; cross-lingual).

## Key preprints (adopt candidates, not claims)
- CareerBuilder two-stage fused-embedding+Faiss (arXiv:2107.00221) → our pattern: pgvector prefilter → LLM rerank.
- Skill taxonomy alignment: zero-shot LLM→ESCO (arXiv:2307.03539) + O*NET/JAAT LLM-as-Judge evals (arXiv:2510.01470).
- Span-extraction hallucination control: SRICL deterministic verifier (arXiv:2604.21525).
- Bias testing: LLM-synthesized paired resumes, 5 protected axes (arXiv:2608.26899); FAIRE score+rank methods (arXiv:2504.01420); embedding gender-leakage probe (arXiv:2607.20073, FairCVdb); AIBF per-decision audit (arXiv:2608.21537).
- LLM-guided genetic resume optimization (arXiv:2604.02539 Synapse) — later-stage candidate.

## Gotchas
- ACM + Semantic Scholar API block/429 from device network; use arXiv abs-page comments + PMC raw metadata (citation_journal_title) for venue verification.
- 26xx arXiv ids = 2026 preprints; treat venues as "preprint" unless verified.
- EEOC posture: keep scoring human-review-assisted, attribute-blind prompts, decision audit table.
