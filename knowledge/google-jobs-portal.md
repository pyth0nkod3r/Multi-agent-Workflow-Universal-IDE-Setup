# Google Jobs as a market portal — knowledge summary

**Researched:** 2026-09-07 (run 20260907-1930-rank-expand-wiring, UNIT C)
**Full findings:** platform/docs/RESEARCH-google-jobs-portal.md

## Bottom line
Do NOT add Google Jobs as a portal. No sanctioned consumption path exists:
- **Indexing path** (schema.org JobPosting + Indexing API) = contribution only; requires being the authorized poster — our aggregation model disqualifies us.
- **SerpApi-class** = works technically (city via `location`, country via `gl`, radius `lrad` advisory-only, 10/page) but violates Google ToS, and **Google sued SerpApi (Dec 2025; core claims dismissed Jul 2026; refiled Aug 2026; pending)**. Cost $25+/mo, no PAYG.
- **Direct scrape** = robots.txt `Disallow: /search` (all agents) + consent wall + JS-only rendering + IP-geo locking. Verified live.

## Location granularity answer (the KEY question)
Only via SerpApi-class: country `gl` (solid), city `location` (solid), coordinates `uule`, radius `lrad` (advisory — "does not strictly limit"). Chips city filter deprecated by Google. Market-level (country) filtering — what MARKET_PORTALS encodes — is achievable, but is better covered by per-market API portals already in the registry.

## Pointers
- Portal registry shape: platform backend/app/db_pg.py GLOBAL_PORTALS / MARKET_PORTALS; scrape run in routers/jobs.py (mock; websearch fallback tier).
- Portal draft (opt-in, disabled by default, source "api") in the full doc if user accepts ToS risk; robots-check bypass caveat documented there.
