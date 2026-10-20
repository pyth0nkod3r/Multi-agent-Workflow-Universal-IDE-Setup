# LLM Model Catalog & Multi-Provider Contracts (EaseApply Knowledge)

Canonical reference for EaseApply LLM provider model listing, availability signals, and catalog contracts (verified 12 Oct 2026).

## Key Contracts & Specifications

- **Provider Base URLs & Auth:**
  - **Groq:** `https://api.groq.com/openai/v1` | `Authorization: Bearer $GROQ_API_KEY`
  - **Nvidia NIM:** `https://integrate.api.nvidia.com/v1` | `Authorization: Bearer $NVIDIA_API_KEY` (nvapi-)
  - **ModelScope:** `https://api-inference.modelscope.cn/v1` | `Authorization: Bearer $MODELSCOPE_API_KEY` (ms-)
  - **Kiosapi:** `https://kiosapi.com/v1` (Note: `router.kiosapi.com` DNS fails) | `Authorization: Bearer $KIOSAPI_API_KEY` (sk-kilo-)
- **`GET /models` Listing Semantics:**
  - **Nvidia NIM & ModelScope:** Publicly queryable without API keys (HTTP 200). Return OpenAI-compatible `data[].id`.
  - **Groq & Kiosapi:** Strictly require Bearer keys (HTTP 401 if unauthenticated). Cannot be listed in zero-key environments.
  - **Raw Model Contamination:** Live endpoints return non-chat models (Groq: Whisper STT, Prompt Guard; Nvidia: embeddings `embed-qa-4`, clip `nvclip`; ModelScope: image-editing). Raw IDs cannot be bound to chat completions without filtering.
- **Model Availability & Offline Error Signatures:**
  - **Groq Decommissioned:** HTTP 400 with `error.code == "model_decommissioned"` and `message` detailing replacement.
  - **Nvidia Decommissioned / EOL:** HTTP 410 Gone with RFC 7807 problem details (`status: 410`, `title: "Gone"`, `detail: "The model '...' has reached its end of life..."`).
  - **Model Not Found / Inaccessible:** HTTP 404 (`model_not_found` on Groq, 404 text on Nvidia NIM).
  - **Rate Limits:** HTTP 429 with `retry-after` and `x-ratelimit-*` headers across all providers.
- **Failover & Circuit Breaker Invariants:**
  - **Immediate Chain Advance:** HTTP 400 (`model_decommissioned`), HTTP 410 (`Gone`), and HTTP 404 (`model_not_found`) must immediately advance the fallback chain (`failover_eligible=True`) without retrying the dead model.
  - **Breaker Isolation:** A decommissioned model must NOT trip the provider-level circuit breaker (`llm_breaker`), because other models at the same provider remain healthy.
  - **Context Length Exceeded:** Always aborts the entire chain (`failover_eligible=False`).
- **Catalog Architecture Recommendation:**
  - Curated in-memory/code catalog (`CURATED_CATALOG`) provides clean chat-tested model options in the admin UI without external network delays or requiring pre-provisioned API keys.
  - Admin UI allows filtering by provider and selecting models per slot (`primary`, `fallback-0`, etc.).
  - Database overrides in `llm_runtime_config` must be resolved for both `primary` and all `fallback-N` slots in `resolve_runtime_settings()`.

Pointers: Full research document with verified API probes, error shapes, and implementation schemas in `/workspace/platform/docs/RESEARCH-llm-model-catalog.md`.
