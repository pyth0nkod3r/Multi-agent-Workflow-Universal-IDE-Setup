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
| Motion vocabulary | oneshotprompts (923 techniques) | Local index: `knowledge/motion-techniques.json` (multiagent repo; ide-setup mirror) | Free. 923 motion techniques (id + name + kind/subgroup), 10 kinds × 8 goals. Definitions on demand at `https://oneshotprompts.com/techniques/<id>/` (one cheap fetch). Format spec: `https://oneshotprompts.com/llms.txt`. WebMCP tools are Chrome-only — N/A in this harness; plain-text path is the sanctioned one. |
| Skill discovery | skill-issue.in (ranked agent-skill index) | https://skill-issue.in — 9 categories, usage-ranked, `npx skills add ...` install commands | Free index over open-source SKILL.md repos. STANDING RULE: before writing a custom skill for a recurring need, check here first; install only NON-duplicating skills (Hallmark already covers design-taste / frontend-design). Candidates: ui-ux-pro-max (P2/P3 design intelligence), remotion-best-practices (Phase M video — engineering half of the motion layer), web-design-guidelines (QA/critic input). |

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

### Phase M — MOTION SPEC (whenever a deliverable has motion — runs alongside Phases 2-4)
Trigger: ANY project whose surfaces include motion — landing hero, page/section transitions, product-demo video, logo sting, social clip, app onboarding, loaders, data animations. If the project is fully static, skip Phase M entirely.
1. Pick the GOAL (one of the 8: App demo, Logo intro, Titles & text, Data & numbers, Social post, Scene changes, Backgrounds, Retro & glitch) from `knowledge/motion-techniques.json`; that goal's count tells you how many candidate techniques exist.
2. Browse the index by kind/subgroup (grep by name or id — 923 entries, zero re-fetch). Shortlist technique ids per scene/surface. When a name alone isn't decisive, fetch its definition page `https://oneshotprompts.com/techniques/<id>/` (one fetch each — never bulk-fetch).
3. Write the per-project **MOTION.md** in the project repo (sibling of DESIGN.md, project state lives in the project repo — the skill stays project-agnostic). Use the oneshot text format (from /llms.txt): `## Scene (3s)` lines, `-` steps, `[blanks]` for anything unknown (NEVER invent facts about the product), `[your words]{term-id}` linking the author's phrasing to a technique definition, settings `{term-id|strength=|speed=|when=|on=}`. Whole-piece settings (shape/length/style/look/sound/model) written as a sentence under the text.
4. EVERY entrance/exit/transition in MOTION.md must carry: a technique id, an explicit duration (ms or s), a named easing (from the Principles & timing kind — never "default"/linear unless the id says so), and stagger where lists are involved.
5. Map to the delivery medium:
   - **Video (21st Video MCP)**: `## Scene` → `add_scene` (pick the block by job: titles / product-ui / cta / logos / data / gallery / testimonials); piece settings → project `size` + `fit_length`; oneshot transitions → `transition` op (fade/slide/wipe/zoom/diagonal-wipe); Sound & music kind → `music` / `audio` ops.
   - **Web (React/TS/CSS)**: technique → implementation (cubic-bezier ids → Tailwind/Framer `ease` values; MicroKit/Aceternity snippets as starting points, #23/#15 in design-resources.md).
   - **Compose (Android)**: port the SAME named easings manually (animateSpring / animateFloat / keyframe) — no library equivalent.
   - **AI video models**: the finished MOTION.md text IS the prompt (paste-portable to Claude/ChatGPT/Codex + video model) — that is what the oneshot format is for.
6. Human checkpoint: show the user the MOTION.md (or a 3-5 line digest) before building — same rule as the Phase 1 flow approval.

## Sub-agent integration

- planner: decompose a redesign into per-screen units in task specs; each spec MUST name the project's DESIGN.md as required context.
- researcher: competitor look intel / layout patterns before Phase 2 (written to /workspace/multiagent/knowledge/); verify tool facts before relying on them.
- builder (design-side): compose pen prompts, run stitch generation + polling, write DESIGN.md files.
- builder (code-side): implement DESIGN.md in the target codebase (theme files, components). For Phase M, implement MOTION.md: web (Framer/CSS), video (21st Video ops), Compose (manual easing port).
- critic: on every substantive design/code diff. Design critique card = template `/workspace/staging-ai-design/templates/qa-critique.template.md` (vibrancy, hierarchy, consistency, usability, token compliance; Verdict + N/10 + gaps).
- merger: when multiple screens/artifacts must combine into one coherent DESIGN.md or token set.

## QA gates (each phase must pass before the next)

1. Flow approved by user (Phase 1 → 2).
2. Design system committed as DESIGN.md + design-system asset created in Stitch (2 → 3).
3. Critic Verdict >= 8/10 on design diff; code diff shows zero hard-coded colors/spacing outside tokens (3 → 4).
4. Visual spot-check: exported PNG / screenshot shown to user before deploy (4 → done).
5. MOTION (only when Phase M ran): critic checks MOTION.md + implementation — (a) no uniform default easing across all entrances (each names a distinct technique id / cubic-bezier where intent differs); (b) every entrance/exit has explicit duration + named easing in MOTION.md; (c) stagger scales with list length (no fixed 50ms regardless of 3 vs 30 items); (d) ≤3 distinct motion patterns per screen; (e) `prefers-reduced-motion` respected on web (static fallback); (f) ≤1 ambient loop per screen. Verdict line added to the critique card.

## Gotchas

- pen + Stitch both hallucinate features; screen content from AI mockups is NEVER product truth - routes/labels come from the codebase and product docs.
- Stitch quota (~350/mo) is finite: flagship-first, batch related screens per project, prefer edit_screens/variants over regenerating from scratch.
- Penpot MCP is interactive-only: never call execute_code when the user hasn't connected a page; check the tool error first - it reports connection state.
- DESIGN.md is sRGB/hex only (spec alpha) - no oklch/P3.
- Verified design-resource library (33 sites, phase-tagged): knowledge/design-resources.md in the multiagent repo — consult it for inspiration (P1/P2), DESIGN.md fuel (P3: designmd.ai, styles.refero.design), and copy-paste component/motion sources (P4: shadcn, 21st.dev, aceternity, motion-primitives, anime.js) plus free assets (3dicons, kitbitz). #33 oneshotprompts = the MOTION vocabulary for Phase M (local index knowledge/motion-techniques.json, 923 techniques).
- DESIGN.md fuel (Phase 3, LIVE-VERIFIED): `designmd` CLI installed globally (npm; PATH via ~/.bashrc export, DESIGNMD_API_KEY set there too). Commands: `designmd search "fintech" --json`, `designmd tags`, `designmd get <user>/<slug> --json`, `designmd download <user>/<slug> -o ./DESIGN.md`, `designmd upload ./DESIGN.md --name "X" --tags a,b`. Verified end-to-end (search + download of chef/crypto-blue). Its MCP server (npx designmd-mcp) is stdio-only — drive via the CLI instead (zero context overhead).
- DESIGN.md fuel #2 (Phase 3, MIT): VoltAgent/awesome-design-md (github) — ~100+ top-brand DESIGN.md analyses (Airbnb, Apple, Binance…), raw-downloadable via curl from raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<brand>/DESIGN.md. Use for top-brand scaffolds; designmd.ai for community kits.
- Hallmark skill (INSTALLED 16 Oct 2026, MIT, github.com/nutlope/hallmark): anti-AI-slop design skill with 4 verbs — default build (21 macrostructures + 21 themes + 57 slop-test gates), `hallmark audit <target>` (punch-list, no edits — feed its output to the critic), `hallmark redesign <target>` (preserve copy/IA/brand), `hallmark study <screenshot|URL>` (extract design DNA → optional design.md; refuses pixel-clones, needs own-brand attestation). Use for Phase-2/3 generation, landing audits, and competitor DNA extraction.
- Motion vocabulary (LIVE-VERIFIED 31 Oct 2026): oneshotprompts.com — 923 motion-design techniques with term-ids + one-sentence definitions, 10 kinds × 8 goals. Its WebMCP agent tools are Chrome-only (NOT exposed to the in-app WebView) — do NOT rely on them; the sanctioned path is plain text: local index `knowledge/motion-techniques.json` (this repo + multiagent) for browse/search with zero fetches, plus one fetch per technique at `https://oneshotprompts.com/techniques/<id>/` when a definition is needed. Full spec-format reference: `https://oneshotprompts.com/llms.txt`. Feeds Phase M (MOTION.md per project).
- Skill discovery (LIVE-VERIFIED 31 Oct 2026): skill-issue.in — usage-ranked index of open-source agent skills (9 categories; install via `npx skills add <owner>/<repo>`; on this harness use skill_install_from_text with the raw GitHub SKILL.md). Check it BEFORE writing custom skills; duplication rule: Hallmark supersedes anthropics/skills `frontend-design` and the taste-skills — never install both. Phase hooks: ui-ux-pro-max → Phase 2/3 (queryable styles/palettes/font pairings/UX rules); remotion-best-practices (remotion-dev official) → Phase M video deliverables (the engineering half — oneshotprompts says WHAT to animate, remotion skills say HOW in code); web-design-guidelines (vercel-labs) → QA as a critic input (100+ WIG rules, live-fetched, file:line findings).
- Templates + this skill live in /workspace/staging-ai-design/; reference docs (blog.obimadu.pro analysis, Stitch/Penpot/pen notes) in that repo's docs/.
