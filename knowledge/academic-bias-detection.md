# Knowledge — Academic backing for EaseApply (bias detection + anti-ban + structured-output LLMs)

Full doc: /workspace/platform/docs/RESEARCH-academic-bias-detection.md (114 lines, 27 Sept 2026, 55 papers across 5 domains).
Method: firecrawl research index (arXiv+PubMed) — security venues (USENIX/NDSS/CCS) surfaced mostly as arXiv measurement studies; no new CCS/NDSS PDFs pulled.

## Load-bearing facts (verified via index abstracts; venue = arXiv preprint unless noted)
- Syntactic JSON validity ≠ semantic validity even under constrained decoding → keep semantic validation + retry (JSONSchemaBench arXiv:2501.10868; reason-before-verdict arXiv:2502.14905; schema-key wording is an instruction channel arXiv:2604.14862).
- Inconsistent cross-layer fingerprints are the top bot-evasion failure (FP-Inconsistent arXiv:2406.07647: 20 "undetectable" bot services vs DataDome+BotD honey site); JA4 TLS fingerprinting beats behavioral mimicry (arXiv:2602.09606); LLM web agents are detectable via multi-layer TLS+HTTP+behavioral fingerprints (arXiv:2606.30119, 2605.01247, 2606.20910) → keep Baileys + direct HTTP as sanctioned path; fingerprint-CONSISTENT + pacing.
- PII-redacted resumes still carry demographic proxies (hobbies/club markers; arXiv:2603.05189, 100×4100 variants, 18 LLMs) → scrub proxies in resume handling.
- Per-decision counterfactual auditing (AIBF arXiv:2608.21537) + LLM-synthesized resume counterfactual harness (arXiv:2608.26899) = automatable bias test without real applicants; ties to EU AI Act Annex III + EEOC adverse impact (arXiv:2609.18106).
- CV-tailoring hallucination class: invented tech/years, cross-domain contamination, structural mutation (Grounded Optimization arXiv:2607.01457); provenance tagging grounded-vs-synthesized lines (arXiv:2605.05257).
- Self-consistency (sample k CoT paths, majority) = cheap accuracy + confidence signal (arXiv:2203.11171, ICLR 2023); Auto-CoT from labeled outcomes (arXiv:2302.12822) fits EaseApply's outcome labels.
- Board search recipe: TF-IDF recall → Sentence-BERT → cross-encoder re-rank → explanation (arXiv:2605.27656); LinkedIn SOTA = LLM relevance judge + small distilled SLM (arXiv:2602.07309).
- Video-assessment vendors (HireVue class): only verbal behaviors predict cognitive ability; paraverbal/nonverbal add no validity (PMID:39325374, 38270989).
- Adversarial debiasing of embeddings (arXiv:2209.09592 GAN on 12M postings) is relevant only once a learned ranker exists.

## Competition intel
- LinkedIn = strongest public academic output (1905.01989, 2202.07300, 2402.06859 LiRank, 2402.13435, 2602.07309, 2605.16479; external audit 2511.10752).
- ZipRecruiter/Indeed team-authored peer-reviewed work: NOT found in the index (UNKNOWN — likely blogs/KDD workshops, not arXiv/PubMed).
- Auto-apply competitor class: ResumeFlow (2402.06221), career-vault tailoring (2605.05257), MLAR (2507.10472), multi-agent screening (2504.02870), genetic resume optimization (Synapse 2604.02539).

## Standing
Adoption candidates (in build-queue order): semantic JSON validation loop → anti-ban consistency policy → CV guardrails+provenance → counterfactual bias harness → cross-encoder re-rank. See doc "## Result".
