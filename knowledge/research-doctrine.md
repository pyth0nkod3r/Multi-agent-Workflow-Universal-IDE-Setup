# RESEARCH DOCTRINE — Product & Academic Research Pipeline

**Version:** 1.0 · **Adopted:** 24 Oct 2026 · **Status:** canonical cross-project knowledge

Product research is a defined pipeline, not ad-hoc chat work. It is the process that
produces `RESEARCH-*.md` docs in a platform repo. Every research task follows the same
six stages, the same verification discipline, and ends in a committed artifact — never
a chat note.

> **Tool naming note.** The toolchain below names concrete tools (Firecrawl, Repomix,
> you-search, web_fetch). On any harness, map each to the native equivalent: hosted
> Firecrawl MCP **or** the `firecrawl` CLI; Repomix MCP **or** `npx repomix`; any
> ranked-search provider (You.com / SerpAPI / Jina search) for snippets. The *rules*
> are the doctrine; the tools are interchangeable.

---

## 1. SCOPING

- Define **the question and the decision it serves** (competitive intel, academic
  backing for a feature, feasibility of an API, anti-ban research…).
- **Fix the output home BEFORE starting:**
  - Product research → project repo `docs/RESEARCH-<topic>.md`
  - Cross-project knowledge → `knowledge/<topic>.md` (this repo)
- Never assume a project home — it comes from the task.

## 2. DISPATCH

- Research goes through a **researcher sub-agent dispatch**, never chat-inline.
- Long runs run in the background (background runs survive the orchestrator turn).
- Task text must be **self-contained** (the sub-agent sees none of the chat): goal,
  *verified facts only*, explicit output path, constraints.
- **NO ANCHORING:** never embed own draft conclusions in the task. The researcher
  works independently; merge/override happens afterward, orchestrator holds the final
  decision.
- Model choice matters: task-following models only (loose models leak identity and
  ignore constraints).
- Failure protocol: on death/timeout, **REINJECT the same run** (resume from its
  conversation/disk state) — never a fresh dispatch for the same task. Go inline only
  after FIVE failures of the same unit.
- After dispatch: **STOP POLLING.** Wait for the completion/timeout notification; then
  diff-check disk against acceptance criteria.

## 3. SOURCE GATHERING — escalation ladder

Always use the narrowest tool that fits:

| Step | Tool | When |
|---|---|---|
| 1 | Ranked web search (you-search / SerpAPI / Jina search) | No URL yet — snippets first (cheapest) |
| 2 | `firecrawl_scrape` | Have a URL, need full clean content (incl. JS-rendered pages, PDFs) |
| 3 | `web_fetch` / `web_extract` (or plain HTTP GET) | One known static page — cheapest fallback |
| 4 | `firecrawl_map` + scrape | Big site, need the right subpage |
| 5 | `firecrawl_crawl` | Bulk-extract a whole section (e.g. all `/docs/`) |
| 6 | `firecrawl_monitor` | Ongoing change detection → alerts (pricing pages, changelogs) |
| 7 | scrape + `interact` | Clicks, forms, login, pagination, infinite scroll |
| 8 | `firecrawl_agent` | Multi-page structured extraction → JSON (competitor pricing tiers etc.) |

**Specialized indexes:**

- `firecrawl_research_search_papers` — semantic paper index (arXiv, PubMed, bioRxiv,
  medRxiv). **THE paper search.** Supporting tools: `read_paper`, `inspect_paper`,
  `related_papers`.
- `firecrawl_developer_search` — library/API/error questions from issues, merged PRs,
  READMEs, docs.
- `firecrawl_gov_search` — US federal/state/local statutes, regulations, cases.
- **Repomix** (`pack_remote_repository` / `pack_codebase` + `grep_repomix_output`) —
  codebase recon; pack the repo, then grep-first.

**⚠️ GOTCHA:** `categories:["research"]` on generic web search is a **WEBSITE FILTER
ONLY** — never the paper index. Paper searches MUST use the dedicated research index
(or arXiv / PubMed / Semantic Scholar APIs directly).

**LABOR DIVISION:**

| Question type | Tool |
|---|---|
| How does this repo work / where is X code? | Repomix |
| What does this website/product/paper say? | Firecrawl |
| Ranked snippets, just URLs | Ranked search (then scrape best hits) |
| One known static page | web_fetch / web_extract |
| What changed on this page since last week? | firecrawl_monitor |

## 4. VERIFICATION DISCIPLINE (the load-bearing part)

- **Primary over secondary** — every decision-driving claim gets live-verified
  (HTTP 200 checks, real endpoint responses, docs/PDFs read directly).
- **Cross-validation** — numbers checked across ≥2 independent sources.
- **Per-claim verdicts** — every claim recorded as **ADOPT / VERIFY / REJECT** with
  confidence levels, in the doc, not just asserted.
- **Written retractions** — wrong verdicts get corrected IN WRITING, never silently.
- **Unverifiable → UNVERIFIED / CONTINGENCY marker** with the reason (e.g. "free-tier
  limits unknown until signup") — never silently asserted, never omitted.
- **Contradicted → REJECT with evidence** recorded in the doc.
- **Known limits get recorded** — unreachable domains, no-API constraints; verification
  routes through mirrors.
- Academic discipline: abstracts read, not just titles.

## 5. ARTIFACTS & PERSISTENCE

- The researcher writes to the named path on disk. **Research is never chat-only.**
- Scraped content lands in artifact files cited by the RESEARCH doc (verification
  trail). Convention: a `.firecrawl/` working dir, kept out of git; **reuse before
  refetch** — check for existing data first.
- Adoption candidates flow into `docs/RESEARCH-QUEUE.md`; decisions into
  `DECISIONS.md` as D-numbers; run ledger in `RUN.md`.
- Commit with `[run <id>]` markers, orchestrator-only commits, push, verify remote
  HEAD moved.

## 6. QA & ABSORPTION

- **Disk verification before "done"** — SUCCEEDED ≠ done; read the actual file.
- Critic pass on substantive docs.
- Research is only **finished when its adoptables are absorbed** into the
  plan/ROADMAP/build queue. "Add it to plan" always triggers a disk capture, never a
  chat note.

---

## SOURCE MAPS

### Academic (8 platforms)

| Platform | Use | Access |
|---|---|---|
| arXiv (cs.CL/cs.AI/cs.IR) | NLP, embeddings, matching, IR, LLM structured output | research paper index + direct |
| PubMed / PMC | Behavioral / human-factors literature | research paper index + direct |
| bioRxiv / medRxiv | Adjacent preprints | research paper index |
| Semantic Scholar | Cross-domain discovery, citation context | direct / search |
| Google Scholar | Citation counts, canonical paper behind a claim | scraped carefully (no API) |
| Papers With Code | Implementation-ready methods | direct |
| ACM Digital Library | HCI / recsys venue papers | direct |
| OpenAlex / DBLP | Structured metadata, sweep-completeness checks | API/direct |

### Non-academic (in trust order)

1. **Primary vendor documentation** — official API/platform docs read directly.
   Outranks everything else for product decisions.
2. **Official / institutional primary sources** — exchange daily-official-list PDFs,
   central bank policy pages, national statistics portals.
3. **Competitor direct observation** — live product teardowns (landing pages, pricing,
   feature flows).
4. **Competitor code** — GitHub repos packed via repomix; issues/PRs/READMEs.
5. **News & RSS** — market/news flow.
6. **Market & community signal** — Trustpilot reviews, platform self-reported metrics,
   GitHub stars/activity.
7. **User-supplied material = claims to verify, NOT truth** — each gets its own
   verification doc.
8. **General web search** — for questions without a known URL.
9. **Design references** — component catalogs, brand DESIGN.md trees — competitor
   design DNA and design-system fuel.

---

## CREDENTIALS

Search-service API keys (Firecrawl, Jina, SerpAPI) live in a protected env file
outside git (e.g. `~/.search-keys.env`, chmod 600) or in the harness's secure
config. Usage patterns:

- **Jina Reader:** `https://r.jina.ai/<url>` with `Authorization: Bearer $JINA_API_KEY`.
- **SerpAPI:** `https://serpapi.com/search.json?engine=google&q=...&api_key=$SERPAPI_KEY`.
- **Firecrawl:** key in the MCP auth header (hosted) or `FIRECRAWL_API_KEY` env (CLI).

**Never commit keys to any repo. Never paste keys into agent chat when a file route
exists.**
