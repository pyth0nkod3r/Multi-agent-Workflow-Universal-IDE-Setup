# Dependency & Database Policy

**Scope:** All current and future projects (portfolio-wide standing directive).
**Recorded:** 3 Nov 2026 (user-approved, "as-is").
**Authority:** Standing directive; applies at planning, building, and code-review
(code-quality) gates. One topic per file, like the other docs here.

## The one-liner

> Prefer built-in / standard-library modules over external and third-party
> packages, and use Postgres as the universal database — replacing external
> cache, queue, search, vector, and pub/sub software — whenever the target
> host and scale justify it; otherwise fall back to built-in SQLite. Keep the
> external-dependency footprint minimal and document any deliberate exception.

## Rules

1. **Stdlib-first.** Before adding any dependency, check whether a built-in
   module (or a small stdlib implementation) covers the need:
   - `sqlite3` — database
   - `json` / `csv` / `re` / `html` / `difflib` — parse / match
   - `threading` / `collections.deque` / `time` — in-process cache & rate-limit
   - `hashlib` / `secrets` — crypto
   - `asyncio` — async
2. **httpx-only for HTTP / LLM / embeddings.** No vendor SDKs, no
   LiteLLM-class abstraction layers — call OpenAI-compatible endpoints
   directly over `httpx`.
3. **Postgres as the universal DB — whenever possible.** On a real DB host
   (Neon / Render PG / a VPS), absorb sidecars into Postgres:
   - `JSONB` → MongoDB
   - `tsvector` + GIN + `pg_trgm` → Elasticsearch / Meilisearch (search + typo-tolerant dedup)
   - `pgvector` (HNSW) → Pinecone / Qdrant (vectors)
   - `SKIP LOCKED` queue on a `*_runs` table → Celery / Redis / RQ
   - `pg_cron` (or a ~10-line in-process timer) → external scheduler services

   Do **not** add Redis / Celery / Elasticsearch / Pinecone / a separate
   message broker.
4. **SQLite fallback.** No Postgres host, or single-user / zero-ops scale →
   use built-in `sqlite3` (WAL). It is stdlib, not an external service.
5. **Minimize & document.** Every non-stdlib dependency must be justified in
   the project's plan / decision doc; prefer reusing already-present deps
   (FastAPI, httpx, psycopg, React) over new ones; record deliberate
   exceptions with a one-line reason in the register below.

## Decision ladder

```
need → is a stdlib module enough?             → use it
       is a real DB host available & worth it? → Postgres (universal DB)
       single-user / zero-ops / no host?       → built-in sqlite3 (WAL)
```

## Relationship to other policies

- **`uv` policy = HOW to manage dependencies** (never bare `pip`/`python`;
  use `uv`). **This policy = WHETHER to add dependencies.** They stack; this
  one sits upstream of the `uv` one.
- **Gate 14 (version/contract discipline, knowledge/code-quality.md)** still
  applies on top: external deps this policy admits are exactly pinned and
  changelog-gated. This policy decides *whether*; gate 14 governs *how held*.
- **INFRA MODULAR (EaseApply)** stays compatible: Postgres-as-universal is
  the default choice, modularity keeps the interface swappable.
- **Env-pin tests** setting `DATABASE_URL=sqlite:///./fake.invalid` are a
  formalized case of rule 4 (SQLite fallback), not an accident.
- **No Docker** policy unchanged; this policy neither requires nor forbids
  containerization.
- **Generalizes** the EaseApply-local "Postgres for everything"
  (unify-on-Postgres thesis) and "avoid 3rd-party software / httpx-only"
  rules into a portfolio-wide default, with a stdlib / SQLite escape hatch.

## Per-project applications (as of 3 Nov 2026)

| Project     | DB                                      | External-dep stance              |
|-------------|-----------------------------------------|----------------------------------|
| EaseApply   | Postgres / Neon (universal DB)          | minimal (httpx-only, stdlib)    |
| EquityScout | SQLite v1 (`sqlite3`, stdlib) + PG path| normal (pandas, pdfplumber, Pydantic) |
| FabricFocus | local SQLite                            | normal (Compose / Android)      |

## Exception register

_Projects log deliberate departures here, one line each (date · project · dep ·
reason):_

- (none yet)
