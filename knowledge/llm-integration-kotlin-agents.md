# LLM-integration patterns from open-source agent apps (knowledge filter)

Source run: tasks/20260921-0741-llm-research/out-01.md (code-verified, both repos cloned at 21 Sept 2026:
ExTV/rikkahub-agent @51cb7e1, AAswordman/Operit @dbf7191). Full 24-pattern catalog with snippets + verdicts
lives there — this file is the pointer layer only.

## Durable takeaways (transferable to EaseApply services/llm.py, Phase A-D)

1. **Retry = classification, not count.** Retryable 4xx = {408,409,425,429}; a 429 whose body contains
   "resource exhausted" = account block, never retry; context-length errors are deterministic → fail fast,
   never replay; after any meaningful output streamed, never replay. Walk the exception *cause chain*
   (up to ~8) to find status codes. (rikkahub GenerationLoop.kt + Operit LlmRetryPolicy, exp 1s→16s ×5.)
2. **Unknown ≠ 0 in usage accounting.** llm_usage: nullable cached-input + cost_usd; a missing provider
   component is *unknown*, not zero; track which requests have unknown cost; log a row per *attempt*,
   success AND failure, with is_test flag (Operit ProviderUsageSnapshot/TokenTrackingAIService).
3. **One canonical request, per-provider adapters.** Structured output is a request field; each provider
   gets a build_body adapter (response_format vs text.format vs Gemini schema allowlist). Force
   `require_parameters` (OpenRouter) when structured output is requested so mismatched providers can't
   silently drop it. (Operit DeepseekResponsesPayloadAdapter; rikkahub OpenRouterRouting/Request.kt.)
4. **Redact at the log boundary, structurally.** Key-name regex over JSON values at any depth
   (password/secret/token/apikey/private_key) + URL path/query + all header values omitted.
   (rikkahub Json.kt redactSecrets; Operit HttpLogSanitizer.)
5. **Error-detail extraction = first-of [error, detail, message, description], recursive, status-carrying.**
   (rikkahub ErrorParser.parseErrorDetail.)
6. **Key pool for cost-spreading (later):** round-robin + persisted index + DB availability states
   (UNTESTED/AVAILABLE/UNAVAILABLE) + background health-tester + suppress 429 notices when pool>1.
   (Operit ApiKeyProvider/ApiKeyPoolAvailabilityTester; rikkahub KeyRoulette is the LRU variant.)
7. **Per-provider rate caps (later):** sliding-window RPM + concurrency semaphore, registered per model-key,
   rebuilt on limit change. (Operit SlidingWindowRateLimiter/registries.)

## Anti-patterns seen (avoid)
- Duplicated retry classification per provider (Operit copy-pastes handleRetryableError into OpenAI/Claude/
  Gemini) — centralize one policy.
- BYOK plaintext key storage — client-only concern; server uses env/secret-manager + rotation.
- Linear micro-backoff (750ms→4s) is UI-tuned — wrong shape for server workloads; use exponential + jitter.

## Repro
Shallow-clone both repos (rikkahub ~231M; Operit ~428M with --filter=blob:none) to /tmp; LLM layers:
rikkahub `ai/src/main/java/me/rerere/ai/` + `app/.../data/ai/GenerationLoop.kt`;
Operit `app/src/main/java/com/ai/assistance/operit/api/chat/llmprovider/` + `data/stats/`.
