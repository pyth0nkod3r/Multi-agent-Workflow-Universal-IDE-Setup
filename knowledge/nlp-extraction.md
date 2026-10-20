# Knowledge — NLP extraction from unstructured text (feeds P7)

Full research doc: `/workspace/platform/docs/RESEARCH-nlp-extraction.md` (7 Oct 2026). Filtered durable findings:

**P7 = the LLM extraction stage** between TG/WA capture listeners (raw_ingress) and the jobs ETL. Today the reshape is a truncation (text[:80] title, empty skills, env-default market); P7 replaces it on the live `llm_service` schema-render seam. httpx-only; no new inference.

## What's already live (don't re-recommend)
- exact-URL dedup (`ingress.ingest`, jobs.id=sha256(url)), `raw_ingress` store, `judge_sample` (LLM-as-judge, 600-char desc cap for Groq 8k TPM), flat ~45-term `SKILL_VOCAB` + ETL gate (review<0.34), `esco.py` flat label vocab (migration 014), `derive_market` keyword hints, semantic-validator/repair + `json_object` constrained decoding, schema-as-instruction seam (wave 4a), `grounding.wrap_untrusted` two-channel anti-fabrication, `job_embeddings` (jina v2-base-de 768d, HNSW, 6,822 rows, batch-embedded on ingest).

## Durable adoption queue (top-5, re-ranked vs above)
1. **3-tier capture dedup funnel** — exact-URL (live) + MinHash/LSH over n-gram shingles of URL-less capture text (arXiv:2107.06499 recipe; MinHash>SimHash per arXiv:1407.4416; IHUBERT arXiv:2606.20089 funnel shape) + semantic cosine ~0.90 via live `job_embeddings`. Kills "same ad forwarded to N chats = N rows" (synthetic `tg://msg/...` ids collide on text not URL). One `capture_dedup` table + hook in `ingest()`. NEW.
2. **Taxonomy-anchored skill linking** — LLM proposes free-form skills from messy text, then retrieve→rerank-link to a controlled ESCO+O*NET catalog (pattern: arXiv:2601.22885 Turkish-ESCO LLM linking; weak-supervision ESCO arXiv:2209.08071; catalog sources free: onetcenter.org 31.0 RDF/JSON + esco.ec.europa.eu; interop via W3C SKOS arXiv-free spec). Upgrades flat vocab; kills "unknown skill" false-positives.
3. **P7 prompt: red-team test suite + nullable-evidence + `truncated` flag schema.** `grounding.wrap_untrusted` already does two-channel separation (StruQ shape, arXiv:2402.06363 / SecAlign arXiv:2410.05451); missing piece = ~10 adversarial capture payloads as a P7 test-file suite + per-field `evidence` string + `truncated` bool for the ETL review gate.
4. **P7 eval substrate + dynamic few-shot demos** — annotate ~50–100 `raw_ingress` rows (DE/EN + mixed + a few adversarial) as the quality bar; reuse as embedding-retrieved near-example few-shot pool (IDS arXiv:2310.09881 / MarginSel arXiv:2506.06699). One annotation → 4 consumers (eval, demos, injection seed, judge_sample calibration).
5. **fastText LID.176 advisory pre-stage** (model live: dl.fbaipublicfiles.com/.../lid.176.bin, 200-fetched; repo archived 2024) — language-aware market routing + tell the extractor which language to emit in; `derive_market` already covers the common case, so ADOPT-LATER.

## Key gotchas / rules
- LLM extraction IS the UGC normalizer — do NOT build a separate noisy-text normalization model; normalize inside the prompt (salary "80k"→80000 is a prompt instruction). Deterministic pre-clean (Gopher/C4-style regex heuristics, per the verified Mangosteen pipeline arXiv:2507.14664) is the only cheap pre-stage worth it.
- Truncation: `TgMessage.text` capped at 20000 chars (router) — schema `truncated` flag + looser validation for mixed-language rows (subword CS breaks token-level LID, arXiv:1904.01989; small CS models win only on their own language pairs — MuRIL arXiv:2103.10730 evidence points to strong general multilingual models).
- Prompt-injection = a real attack surface on untrusted group text: the test suite (queue #3) is the cheap control; no self-hosted fine-tunes (httpx-only).
- "LLMs4EO" dataset does NOT exist on arXiv (API 0 hits — don't cite). Gopher paper arXiv id unverified this run — reference its filters only via the verified Mangosteen pipeline.
- Dedup thresholds (MinHash ~0.85, cosine ~0.90) are env-tunable constants; tune against the admin dedup hit/miss rate.
- Every P7 backend piece gets an admin UI surface (dedup clusters, extraction review queue, catalog import status) per the standing "backend→UI pairing" rule.
