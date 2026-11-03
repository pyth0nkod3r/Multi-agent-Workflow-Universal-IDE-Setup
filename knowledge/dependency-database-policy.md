# Dependency & Database Policy

**Status:** user-adopted standing directive (2026-11-03). Applies to ALL current and future projects. Scope: dependency selection and database/infrastructure architecture.

## Policy (verbatim)

> Prefer built-in / standard-library modules over external and third-party packages, and use Postgres as the universal database — replacing external cache, queue, search, vector, and pub/sub software — whenever the target host and scale justify it; otherwise fall back to built-in SQLite. Keep the external-dependency footprint minimal and document any deliberate exception.

## Operating rules

1. **stdlib-first.** Before adding any external package, builders must check whether the standard library covers the need (e.g. `sqlite3`, `json`, `logging`, `dataclasses`, `urllib`, `asyncio`, `hashlib`, `secrets`, `zoneinfo`). A package that duplicates stdlib capability is rejected at review, not refactored later.
2. **Postgres as universal database.** Where host scale justifies it, Postgres replaces dedicated single-purpose infrastructure:
   - cache → `UNLOGGED` tables / materialized views / `LISTEN`-`NOTIFY` (in place of Redis/Memcached)
   - queue → `SELECT ... FOR UPDATE SKIP LOCKED` job tables (in place of RabbitMQ/Celery broker)
   - search → full-text search (`tsvector`/`tsquery`, trigram) (in place of Elasticsearch/Meilisearch)
   - vector → `pgvector` (in place of a dedicated vector DB)
   - pub/sub → `LISTEN`/`NOTIFY` (in place of NATS/Redis pub-sub)
3. **SQLite fallback.** When the target host and scale do not justify Postgres (single-process tools, CLIs, local dev, tests), use built-in `sqlite3` instead. No in-memory or file-based third-party database.
4. **Minimal footprint.** Every external dependency in a manifest must be load-bearing. Unused or speculative dependencies are removed, not tolerated.
5. **Documented exceptions.** Any deliberate external dependency (or any non-Postgres/SQLite datastore) is recorded in the project's `DEPENDENCY-EXCEPTIONS.md` (or equivalent docs section) with: what it is, why stdlib/Postgres/SQLite cannot cover it, and the date adopted. Silent exceptions are review failures.

## Interaction with existing doctrine

- **Gate 14 (version/contract discipline, knowledge/code-quality.md)** still applies: external deps that pass this policy are exactly pinned and changelog-gated. This policy decides *whether* to admit a dependency; gate 14 governs *how* it is held.
- **INFRA MODULAR (EaseApply standing directives)** remains compatible: Postgres-as-universal is the default choice, modularity keeps the interface swappable.
- **Env-pin tests** that set `DATABASE_URL=sqlite:///./fake.invalid` are a formalized case of rule 3, not an accident.
- **No Docker** policy unchanged; this policy neither requires nor forbids containerization.

## Audit posture

Existing projects are audited against this policy to *document exceptions*, not to rip out working dependencies immediately. Each exception entry states the replacement cost and whether migration is planned.
