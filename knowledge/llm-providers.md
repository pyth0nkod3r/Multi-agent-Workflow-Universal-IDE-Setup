# LLM Provider Registry — free-model httpx targets (EaseApply Phase B)

Filter: summary + pointers only. Full research: `platform/tasks/20260921-1800-phase-b-routers/out-providers.md` (21 Sept 2026).

All targets are OpenAI-compatible `/v1/chat/completions` except Codex. No custom headers needed anywhere except Codex (`Authorization: Bearer <chatgpt token>` + `ChatGPT-Account-ID` from the id-token claim).

| provider | base_url | key env | free quota (community-tracked; console = truth) | verdict |
|---|---|---|---|---|
| groq | `https://api.groq.com/openai/v1` | GROQ_API_KEY | 30 RPM; 14,400 RPD (8B/scout/qwen3) vs 1,000 RPD (70B/gpt-oss); TPM per-model | READY, Wave-1 default |
| nvidia | `https://integrate.api.nvidia.com/v1` | NVIDIA_API_KEY (nvapi-) | ~40 RPM global; free key = prototyping ToS, prod needs AI Enterprise license | READY, Wave 1 |
| modelscope | `https://api-inference.modelscope.cn/v1` | MODELSCOPE_API_KEY (ms-) | 2,000 RPD total / 500 per model; CN-phone signup; CN latency + data jurisdiction | READY, Wave 2 |
| kiosapi | `https://router.kiosapi.com/v1/` | sk-kilo- Bearer | pay-as-you-go gateway; $0.00 model rows rotate (GLM-5.3, Qwen3.8, Kimi K3…) | READY, fallback-of-fallbacks |
| agnes | `https://apihub.agnes-ai.com/v1` | AGNES_API_KEY (free, no card) | limits UNPUBLISHED; smoke-test /v1/models before shipping defaults | READY-verify-first, Wave 3 |
| cline | `https://api.cline.bot/api/v1` | CLINE_API_KEY | API endpoint works; **free models are IDE/CLI-only** — API needs ClinePass/credits | paid-tier provider, Phase C+ |
| codex | `https://chatgpt.com/backend-api/codex` (Responses wire) | ChatGPT OAuth device/browser flow, auth.json, rotating refresh (~8-day) | per-account ChatGPT plan; one session per account | NEEDS-ADAPTER; per-user BYO only, NOT shared SaaS backend |

Pitfalls: model IDs carry vendor prefixes (modelscope `Qwen/…`, nvidia `meta/…`, cline `vendor/model`); Groq TPM binds before RPD for long prompts; set `max_tokens` deliberately; read `x-ratelimit-*` headers for budgeting.

Config shape decision (out-providers §4): provider registry dataclass in config.py, keys referenced by env NAME only (no secrets in code/DB), `LLM_BASE_URL`/`LLM_PROVIDER` Phase A envs keep top precedence; `llm_usage.provider` column (migration 007) already supports multi-provider with zero schema change.
