---
name: ai-design-workflow
description: AI-native design pipeline for this agent's projects - wires Pencil.dev wireframes, Google Stitch MCP, DESIGN.md design systems, and Penpot MCP into research-design-code-build-test-deploy, with sub-agent role mapping and QA gates. Use for any UI/UX design, redesign, wireframe, mockup, design-system, or brand-look task.
allowed-tools: subagent_dispatch workspace_read_file workspace_write_file workspace_edit_file workspace_shell mcp__66d9cf03_googleStitch__* mcp__2c16c92c_penpot__* termux_run_command show_image open_url web_fetch web_extract you-search you-contents
---

# AI Design Workflow

Design pipeline integrating this agent's installed AI-design toolset into the standard
research → design → code → build → test → deploy loop. Never design from a blank canvas:
flow first (pen), look second (Stitch), contract third (DESIGN.md), surfaces last (Penpot/code).

## Tools (all installed & working)

| Layer | Tool | Access | Notes |
|---|---|---|---|
| Flow/wireframe | pen CLI | `workspace_shell`: `pen --out X.pen --agent codex --model gpt-5.5 --prompt "..." --export X.png` | Headless, wired to ChatGPT OAuth (~valid to 21 Sept 2026; `pen codex-login` when expired; MUST unset PEN_AGENT_API_KEY when using --agent codex). Outputs .pen + PNG. |
| Look/mocks | Google Stitch | MCP `mcp__66d9cf03_googleStitch__*` | Slow (~2-5 min/generation) — do NOT retry on timeout; poll `get_screen` every 30s up to 10x. Quota ~350/mo. Supports DESIGN.md upload → design system asset. |
| Design surface | Penpot | MCP `mcp__2c16c92c_penpot__*` | ONLY acts on the user's currently-focused Penpot page; user must connect: File → MCP Server → Connect. Read `high_level_overview` once before any `execute_code`; persist intermediates on `storage`; verify with `export_shape`. |
| Contract | DESIGN.md | plain file in repo root (beside CLAUDE.md) | W3C-style tokens + prose. The single source of truth consumed by Stitch (upload_design_md), builders (code gen), and Penpot (token sets). |

## The pipeline (4 phases)

### Phase 1 — RESEARCH + FLOW (skip the blank canvas)
1. Product understanding from existing code/docs/pages (never assume - read routes, features, user roles).
2. `pen` generation for flow/wireframe: plain-English prompt = WHAT the app does, list of screens, user steps. Ignore colors at this stage entirely.
3. Human checkpoint: show exported PNG via `show_image`; user approves the FLOW (steps logical? buttons where expected?). Iterate with follow-up pen prompts - do not proceed on an unapproved flow.

### Phase 2 — LOOK + DESIGN SYSTEM
1. Direction brief: one primary + one accent + two neutrals max, one display font + one body font, explicit vibrancy rules (see Brief template). User picks from 2-4 offered directions - never unilaterally.
2. Stitch: `create_project` → `generate_screen_from_text` (flagship screen first) with the approved flow + direction in the prompt.
3. Extract system: stitch screen's generated design.md/component overview, OR write DESIGN.md from the direction directly.
4. `upload_design_md` + `create_design_system_from_design_md` → design system asset id; reuse via `designSystem` param for all further screens + `apply_design_system` to restyle existing ones. Generate variants (`generate_variants`) to offer the user a choice.

### Phase 3 — CONTRACT (DESIGN.md in the repo)
Write `<project>/DESIGN.md` (8 sections: Overview / Colors / Typography / Layout / Elevation & Depth / Shapes / Components / Do's and Don'ts). Requirements: reference syntax `{colors.primary}` for cross-links; hex/sRGB values; prose explains WHY + when-to-use, not just values. From template: `/workspace/staging-ai-design/templates/DESIGN.template.md`. Commit it with the repo - it is the durable artifact every later phase reads.

### Phase 4 — SURFACES (code + Penpot) — keyed by surface TYPE, never by project
- **Web codebases** (React/Vue/Svelte; Tailwind or plain CSS): builders receive the project's DESIGN.md as named context in their spec; generate/replace theme tokens (CSS custom properties, Tailwind config) and component styles to match. Critic gate: diff vs DESIGN.md, no hard-coded hex, all components tokenized.
- **Android codebases** (Jetpack Compose): translate DESIGN.md → `MaterialTheme`/custom `Colors`/`Typography` in a `ui/theme` package; do NOT bring web CSS semantics to Compose.
- **Component installs (web, default-first)**: shadcn `npx shadcn@latest add <component-or-url>` (npx-runnable from workspace shell; no global install needed). 21st MCP: `search type:component` → `get_component` for flagship pieces ONLY (2/day free tier — flagship-first, like Stitch quota); `search type:theme` + `get_theme` (free) for CSS tokens feeding DESIGN.md/theme files; 21st install shape = `npx shadcn@latest add "https://21st.dev/r/<user>/<slug>?api_key=$API_KEY_21ST"`. Free copy-paste alternates: magicui.design, uiverse.io.
- **Penpot** (optional polish/presentation): user opens file + connects MCP; then execute_code builds layouts from the same tokens (W3C token sets), export_shape for visual QA.

## Sub-agent integration

- planner: decompose a redesign into per-screen units in task specs; each spec MUST name the project's DESIGN.md as required context.
- researcher: competitor look intel / layout patterns before Phase 2 (written to /workspace/multiagent/knowledge/); verify tool facts before relying on them.
- builder (design-side): compose pen prompts, run stitch generation + polling, write DESIGN.md files.
- builder (code-side): implement DESIGN.md in the target codebase (theme files, components).
- critic: on every substantive design/code diff. Design critique card = template `/workspace/staging-ai-design/templates/qa-critique.template.md` (vibrancy, hierarchy, consistency, usability, token compliance; Verdict + N/10 + gaps).
- merger: when multiple screens/artifacts must combine into one coherent DESIGN.md or token set.

## QA gates (each phase must pass before the next)

1. Flow approved by user (Phase 1 → 2).
2. Design system committed as DESIGN.md + design-system asset created in Stitch (2 → 3).
3. Critic Verdict >= 8/10 on design diff; code diff shows zero hard-coded colors/spacing outside tokens (3 → 4).
4. Visual spot-check: exported PNG / screenshot shown to user before deploy (4 → done).

## Gotchas

- pen + Stitch both hallucinate features; screen content from AI mockups is NEVER product truth - routes/labels come from the codebase and product docs.
- Stitch quota (~350/mo) is finite: flagship-first, batch related screens per project, prefer edit_screens/variants over regenerating from scratch.
- Penpot MCP is interactive-only: never call execute_code when the user hasn't connected a page; check the tool error first - it reports connection state.
- DESIGN.md is sRGB/hex only (spec alpha) - no oklch/P3.
- Verified design-resource library (29 sites, phase-tagged): knowledge/design-resources.md in the multiagent repo — consult it for inspiration (P1/P2), DESIGN.md fuel (P3: designmd.ai, styles.refero.design), and copy-paste component/motion sources (P4: shadcn, 21st.dev, aceternity, motion-primitives, anime.js) plus free assets (3dicons, kitbitz).
- DESIGN.md fuel (Phase 3, LIVE-VERIFIED): `designmd` CLI installed globally (npm; PATH via ~/.bashrc export, DESIGNMD_API_KEY set there too). Commands: `designmd search "fintech" --json`, `designmd tags`, `designmd get <user>/<slug> --json`, `designmd download <user>/<slug> -o ./DESIGN.md`, `designmd upload ./DESIGN.md --name "X" --tags a,b`. Verified end-to-end (search + download of chef/crypto-blue). Its MCP server (npx designmd-mcp) is stdio-only — drive via the CLI instead (zero context overhead).
- DESIGN.md fuel #2 (Phase 3, MIT): VoltAgent/awesome-design-md (github) — ~100+ top-brand DESIGN.md analyses (Airbnb, Apple, Binance…), raw-downloadable via curl from raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<brand>/DESIGN.md. Use for top-brand scaffolds; designmd.ai for community kits.
- Templates + this skill live in /workspace/staging-ai-design/; reference docs (blog.obimadu.pro analysis, Stitch/Penpot/pen notes) in that repo's docs/.
