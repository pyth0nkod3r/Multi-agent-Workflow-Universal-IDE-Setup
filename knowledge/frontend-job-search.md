# Frontend & Dashboard Job Search — Knowledge Summary

**Researched:** 2026-10-20 (run 20261020-1120-jobsearch)
**Full findings:** platform/docs/RESEARCH-frontend-job-search.md

## Bottom Line
- **Backend Search**: `GET /v1/jobs?q=` is live in `app/routers/jobs.py:251` and backed by GIN indexes on `search_vec` (migration 005) + English stemmed tsvector + `pg_trgm` (migration 020).
- **Critical Query Bug**: `app/pg_board.py:136-146` limits search matches with `LIMIT 100` inside `_board_view` sorted by URL/ID, truncating high-scoring jobs before relevance/match-score sort runs in outer SQL. Fix: remove inner `LIMIT 100` and apply hybrid ranking `(0.7 * match_score + 30.0 * ts_rank_cd)`.
- **UX Placement**: Keep the primary filter bar search on `/jobs` (already rendered in `Jobs.tsx:848`); add a lightweight QuickSearch hero bar on `/dashboard` that navigates to `/jobs?q=${query}`.
- **Frontend Sync Gap**: `Jobs.tsx` ignores `q` from `useSearchParams`. Fix: bind `search` state to `searchParams.get("q")` for deep-linking.
- **Larger Index (Google Jobs)**: Rejected. Contribution violates Google content policies for aggregators; consumption (SerpApi/scraping) violates ToS and is under active litigation (*Google v. SerpApi*).

## Pointers
- Query engine: `backend/app/pg_board.py` (`jobs_for`, `_board_view`).
- Router: `backend/app/routers/jobs.py` (`list_jobs`).
- Migrations: `005_search_columns_lifecycle.sql` and `020_job_search_index.sql`.
- Frontend: `frontend/src/pages/Jobs.tsx` (filter bar) and `frontend/src/pages/Dashboard.tsx`.
- Design specs: `docs/design/05-ia-menu-spec.md` and Stitch registry `docs/design/06-stitch-registry.md`.
