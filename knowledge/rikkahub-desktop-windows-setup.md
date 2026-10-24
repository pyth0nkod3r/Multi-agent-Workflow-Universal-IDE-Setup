# RikkaHub Agent Desktop (Windows PC) — Harness Setup Variant

**Version:** 1.0 · **Written:** 24 Oct 2026 · **Status:** verified live on the
D3V_001 Windows PC (every command below was executed and disk-verified in run
20261024-…-doctrine-adoptions + the repomix-bridge run)

Companion to `research-doctrine.md`, `security-adoptions.md`, and
`git-github-adoptions.md`. Those hold the **rules** (harness-neutral); this file
holds the **Windows install facts**. On another OS/harness, write a sibling
variant — never edit this one to fit a different machine.

---

## 1. Doctrine install (repos + overlay)

1. Clone both doctrine repos under the workspace root
   (`C:/Users/D3V_001/repos/`):
   - `Multi-agent-Workflow` — **canonical** (doctrine edits land here first)
   - `Multi-agent-Workflow-Universal-IDE-Setup` — **mirror** (deployment
     package; sync canonical → mirror, canonical wins on conflict)
2. Wire the gate-10 commit-msg hook on **every** clone:
   `git config core.hooksPath .githooks` (the `.githooks/commit-msg` file is
   committed in canonical; copy it into repos that lack it).
3. Create a **workspace overlay file** (`RESEARCH-DOCTRINE.md` at the workspace
   root): pointers to the canonical doctrine files + a tool-remap table +
   open-item tracker. It is a thin index, **never a third full copy** of any
   doctrine text (prevents three-way drift).
4. Sync discipline per GIT-HYGIENE: `git fetch` → `git log HEAD..origin/main`
   drift check → review diffs → `git merge --ff-only` — **never blind pull**.

## 2. Search services & keys

| Item | Windows fact |
|---|---|
| Key file | `C:/Users/D3V_001/repos/.secrets/providers.env` (git-ignored, one `export KEY=…` per line) |
| Keys | `FIRECRAWL_API_KEY`, `JINA_API_KEY`, `SERPER_API_KEY` |
| Naming | The Google-search key is **Serper** (`serper.dev`), NOT SerpAPI — doctrine appendix says "SerpAPI"; verify before use |
| App-side config | RikkaHub Desktop settings → search services: `jina`, `serper`, `firecrawl` entries each carry the key + resultSize; verify via the built-in test (all three `testPassed: true` on 2026-10-24, stored in `pc-data/state.json → settings.searchServices`) |
| Firecrawl CLI | `firecrawl login` (or env key); check credits with a cheap `firecrawl search` |
| Never | Keys never committed, never pasted into chat when a file route exists |

## 3. MCP landscape on Windows (the load-bearing constraint)

The RikkaHub desktop PC-server (`rikkahub-desktop/pc-server`) supports ONLY
`streamable_http` and `sse` MCP transports — `api/handlers/settings.ts`
coerces every other `type` to `streamable_http`, and **no stdio precedent
exists** in its settings schema. Consequence: any stdio-only MCP server
(repomix, playwright, etc.) must be bridged to HTTP before registration.

**Do not** hand-edit `pc-data/state.json` for MCP changes — register through
the app's local API (§4), which normalizes, persists, and syncs live state.

## 4. Repomix MCP install (worked example — template for any stdio server)

### 4.1 Bridge (stdio → streamable HTTP via supergateway)

```bash
npm i -g repomix supergateway   # global: the bridge must outlive any npx cache
```

Bridge script `C:/Users/D3V_001/repos/.bridge/repomix-bridge.cmd`:

```bat
@echo off
title repomix-mcp-bridge (8809)
supergateway --stdio "npx -y repomix --mcp" --outputTransport streamableHttp ^
  --port 8809 --host 127.0.0.1 --streamableHttpPath /mcp ^
  --healthEndpoint /health --logLevel none
```

Autostart: drop a launcher in the user's Startup folder
(`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\repomix-bridge-autostart.cmd`):

```bat
@echo off
start "" /min "C:\Users\D3V_001\repos\.bridge\repomix-bridge.cmd"
```

Smoke test before registering: `curl http://127.0.0.1:8809/health` → `ok`,
then a raw JSON-RPC `initialize` POST to `/mcp` must return
`serverInfo: repomix-mcp-server`.

### 4.2 Registration through the app API (3 calls, strict order)

Server: `http://127.0.0.1:17475/api` (port = `settings.preferredPort` or the
default 17475; JWT auth currently disabled — verify `webServerJwtEnabled` first;
if enabled, obtain a token before calling).

1. **Create/update** — `POST /api/settings/mcp-server/detail`
   `{"id":"repomix","type":"streamable_http","url":"http://127.0.0.1:8809/mcp","name":"repomix","commonOptions":{"enable":true,"name":"repomix","tools":[]}}`
2. **Attach to assistant** — `POST /api/settings/assistant/mcp`
   `{"assistantId":"<id>","mcpServerIds":["<existing ids…>","repomix"]}`
   (the full id list replaces the old one — read current `mcpServers` from
   state.json first and append)
3. **Sync tools** — `POST /api/settings/mcp-server/sync`
   `{"serverId":"repomix"}` (409 = server replaced mid-sync; re-run)

### 4.3 Disk verification (SUCCEEDED ≠ done)

Read `pc-data/state.json` and confirm: server entry exists with
`type: streamable_http`, `commonOptions.connected: true`,
`lastSyncError: ""`, expected tool list present, and the assistant's
`mcpServers` array contains the id. Expected repomix tool set (v1.18.1):
`pack_codebase`, `pack_remote_repository`, `read_repomix_output`,
`grep_repomix_output`, `attach_packed_output`, `generate_skill`.

Notes: new tools appear in a **new conversation** (session toolsets are
snapshotted); do **not** use `--sandbox` — it disables `pack_remote_repository`,
which the recon doctrine needs. Security doctrine: MCP configs are
secrets-bearing; every MCP install/change is per-call confirmed.

## 5. Tool remap (doctrine reference → Windows binding)

| Doctrine reference | Windows PC binding |
|---|---|
| Ranked web search | `mcp__you-search` / app search services (jina, serper, firecrawl) |
| `web_fetch` / `web_extract` | **not installed** → `you-contents` / `scrape_web` |
| Firecrawl tool suite | Firecrawl CLI + firecrawl skills |
| Paper index | CLI `firecrawl research …` (skill: firecrawl-research-index) |
| Developer / gov indexes | CLI `firecrawl developer` / `firecrawl gov` |
| Repomix MCP (Termux: supergateway on tmux) | supergateway bridge on port 8809 + Startup autostart (§4) |
| Keys in `~/.search-keys.env` | `repos/.secrets/providers.env` |
| Device secrets dir | `C:/Users/D3V_001/repos/.secrets/` |
| Local headless browser | **BROKEN** (CDP connect failure) → route interactive scraping through Firecrawl cloud `interact`/`agent` |
| Sub-agent profiles | orchestrator/builder/critic/researcher/planner/merger/merger via `subagent_dispatch` |

## 6. Git / GitHub on Windows

- Same GIT-HYGIENE protocol as doctrine — no platform deltas.
- `gh` CLI authenticated as `pyth0nkod3r`; SSH push from workspace key
  (transient push failures → retry, don't debug first failure).
- CI trio replication for new repos: copy reference files from
  `EaseApply/.github/workflows/security.yml` + `.github/dependabot.yml` +
  `docs/security/README.md` (byte-identical `cp`; verified on
  `b2b2c_research@733ee5e`).
- Windows deltas: LF→CRLF warnings are cosmetic (core.autocrlf); never `mv`
  project dirs (EPERM-lock risk applies to any OS per doctrine §1); use
  `git config core.hooksPath .githooks` per clone.

## 7. Setup verification checklist

- [ ] Both doctrine repos cloned, ff-synced, hook wired
- [ ] Overlay file exists at workspace root (pointers + remap only)
- [ ] `.secrets/providers.env` has FIRECRAWL/JINA/SERPER keys; app search tests pass
- [ ] Bridge alive: `curl http://127.0.0.1:8809/health` → ok
- [ ] state.json: repomix `connected: true`, 6 tools, attached to assistant
- [ ] New conversation sees `mcp__repomix__*` tools
- [ ] Test commit on a doctrine clone passes the gate-10 hook

## Changelog

- 2026-10-24 — v1.0: doctrine sync + overlay convention, search keys, Repomix
  bridge (supergateway 4.2.0, repomix 1.18.1), app-API registration, tool
  remap, CI-trio replication verified [run 20261024-1750-rikkahub-windows-setup]
