# Design Resources Library (verified 27 Sept 2026)

> Project-agnostic library of 29 design-resource sites, live-checked for the ai-design-workflow.
> Status legend: LIVE / MOVED (to where) / DEAD / UNVERIFIED.
> Phase tags: PHASE-1 (research/wireframe), PHASE-2 (direction briefs), PHASE-3 (Stitch + DESIGN.md), PHASE-4 (code: React+TS web / Android Compose), QA (critic checks).

## Summary table

| # | Name | URL | Status | Phase tags | License/cost |
|---|------|-----|--------|------------|--------------|
| 01 | Scrolltide | https://www.scrolltide.co | LIVE | P1 P2 | prompts; free browse |
| 02 | Minimal Gallery | https://minimal.gallery | LIVE | P1 P2 | free; premium templates |
| 03 | Kage | https://kage.design | LIVE | P2 P4 | free browse; design→build prompts |
| 04 | Refero Styles | https://styles.refero.design | LIVE | P3 | free DESIGN.md style library |
| 05 | AppShot Gallery | https://www.appshot.gallery | LIVE | P1 P4m | free inspiration |
| 06 | Component Gallery | https://component.gallery | LIVE | P2 P4 QA | free reference |
| 07 | Navbar Gallery | https://www.navbar.gallery | LIVE | P2 P4 QA | free inspiration |
| 08 | Footer Design | https://www.footer.design | LIVE | P2 QA | free inspiration |
| 09 | CTA Gallery | https://www.cta.gallery | LIVE | P2 P4 QA | free inspiration |
| 10 | 404s Design | https://www.404s.design | LIVE | P4 QA | free inspiration |
| 11 | DesignMD | https://designmd.ai | LIVE | P3 | 100s of FREE DESIGN.md files |
| 12 | VibePrompt | https://vibeprompts.dev | LIVE | P3 P4 | free prompts + Tailwind snippets |
| 13 | 21st.dev | https://21st.dev | LIVE | P4 P3 | 12k React/Tailwind components, one-command install |
| 14 | Kinetics | https://kinetics.colorion.co | LIVE | P4 | copy CSS/React, spring physics |
| 15 | Aceternity UI | https://ui.aceternity.com | LIVE | P4 P3 | 200+ copy-paste React/Tailwind/Motion |
| 16 | Magic UI | https://magicui.design | LIVE | P4 | (inferred: open source, copy-paste) |
| 17 | Motion Primitives | https://motion-primitives.com | LIVE | P4 QA | open-source React/Next/Tailwind UI kit |
| 18 | Anime.js | https://animejs.com | LIVE | P4 | MIT JS animation lib |
| 19 | shadcn/ui | https://ui.shadcn.com | LIVE | P4 P3 QA | copy-paste, per-component MIT-style |
| 20 | Uiverse | https://uiverse.io | LIVE | P4 QA | (inferred: community CSS snippets) |
| 21 | UIAble | https://uiable.com | LIVE | P4 | open source, Next.js |
| 22 | MapCN | https://www.mapcn.dev | LIVE | P4 | MapLibre+Tailwind+shadcn map components |
| 23 | MicroKit | https://microkit.co | LIVE | P4 QA | 49 MIT microinteractions, no install |
| 24 | Liquid Glass | https://glass.samasante.com | LIVE | P4 | (license unverified) DOM refract effect |
| 25 | Text Effects CSS | https://text-effects.colorion.co | LIVE | P4 P2 | 90 pure-CSS effects, free copy |
| 26 | Circle Loaders | https://circleloaders.dominikakissi.com | LIVE | P4 QA | 24 free standalone SVG/CSS spinners |
| 27 | Gradient Buttons | https://gradientbuttons.colorion.co | LIVE | P4 | free CSS snippets |
| 28 | Kitbitz | https://kitbitz.art | LIVE | P4 P1 | 2,000+ free illustrations (SVG/PNG/Figma) |
| 29 | 3D Icons | https://3dicons.co | LIVE | P4 P1 | 1,440+ free 3D icons, no attribution |

Legend: P1=PHASE-1, P2=PHASE-2, P3=PHASE-3, P4=PHASE-4 (web), P4m=PHASE-4 mobile, QA=critic checks.

## Per-resource details

### 01 Scrolltide (scrolltide.co)
- Canonical: https://www.scrolltide.co/ (apex 308 → www)
- Status: LIVE (curl 200 via www; web_fetch blocked by Cloudflare 1015 — content verified with browser-UA curl)
- Description: Cinematic website prompts & templates — ready-to-use AI prompts that produce cinematic web experiences.
- License/cost: prompt templates; site free to browse (inference: may have paid tier behind prompts — unverified).
- Phases: PHASE-1, PHASE-2
- Fit: prompt library feeding direction briefs; use for "cinematic/immersive" direction only, not default SaaS.

### 02 Minimal Gallery (minimal.gallery)
- Canonical: https://minimal.gallery
- Status: LIVE (curl 200)
- Description: Hand-picked web design inspiration, premium templates, and tools (minimal-design focus).
- License/cost: free inspiration; "premium templates" implies paid templates (cost unverified).
- Phases: PHASE-1, PHASE-2
- Fit: inspiration crawl for minimal/clean directions; screenshot-level reference for PHASE-2 briefs.

### 03 Kage (kage.design)
- Canonical: https://kage.design/
- Status: LIVE (curl 200)
- Description: "Design inspiration, ready to build" — browse interfaces from real products and turn any design into a prompt for Claude Code / Codex / Cursor.
- License/cost: free to browse (inference: prompt generation likely has credits/paywall — unverified).
- Phases: PHASE-2, PHASE-4
- Fit: strongest idea: convert a liked real-product UI into a build prompt → feeds PHASE-4 web/React or Compose units via sub-agent.

### 04 Refero Styles (styles.refero.design)
- Canonical: https://styles.refero.design/
- Status: LIVE (curl 200)
- Description: "Website Styles & DESIGN.md Library" — a library of DESIGN.md-format design styles for websites.
- License/cost: free library (inference: tied to Refero's paid product Refero.ai for full codegen — style library itself free).
- Phases: PHASE-3
- Fit: direct fuel for our DESIGN.md contract — pick a style, extract tokens, drop into Phase 3 Stitch/DESIGN.md step.

### 05 AppShot Gallery (appshot.gallery)
- Canonical: https://www.appshot.gallery/ (apex 301 → www)
- Status: LIVE (curl 200 via www)
- Description: App Store screenshot inspiration for ASO & mobile UI design.
- License/cost: free inspiration gallery (inference).
- Phases: PHASE-1, PHASE-4 (mobile)
- Fit: Android/Compose app-store asset + mobile UI pattern reference; complements web-only resources.

### 06 Component Gallery (component.gallery)
- Canonical: https://component.gallery/ (LIVE, curl 200; brand site by the same curator family as navbar/footer/cta galleries)
- Description: "An up-to-date repository of interface components based on examples from the world of design systems" — UI component reference across design systems.
- License/cost: free reference gallery (inference: screenshots/examples, not copy-paste code).
- Phases: PHASE-2, PHASE-4, QA
- Fit: critic reference vocabulary for component-level critiques (buttons, cards, forms); quick pattern lookup before PHASE-4 units.

### 07 Navbar Gallery (navbar.gallery)
- Canonical: https://www.navbar.gallery/ (apex 301 → www; LIVE)
- Description: Navbar / navigation bar design inspiration — curated collection of nav designs.
- License/cost: free inspiration (inference).
- Phases: PHASE-2, PHASE-4, QA
- Fit: specific-pattern inspiration when a direction brief includes a new navbar; critic checks for nav consistency.

### 08 Footer Design (footer.design)
- Canonical: https://www.footer.design/ (apex 301 → www; LIVE)
- Description: "The only footer gallery on earth" — curated footer design inspiration.
- License/cost: free inspiration (inference).
- Phases: PHASE-2, QA
- Fit: small-surface pattern reference; footer redesigns rarely need more than a crib sheet.

### 09 CTA Gallery (cta.gallery)
- Canonical: https://www.cta.gallery/ (apex 308 → www; LIVE)
- Description: "The best Call-to-Action inspiration" — curated CTA section designs for conversion.
- License/cost: free inspiration (inference).
- Phases: PHASE-2, PHASE-4, QA
- Fit: CTA section patterns directly affect conversion surfaces; critic use for CTA hierarchy/contrast checks.

### 10 404s Design (404s.design)
- Canonical: https://www.404s.design/ (apex 301 → www; LIVE)
- Description: "A curated gallery of creative error page designs" — 404/error page inspiration.
- License/cost: free inspiration (inference).
- Phases: PHASE-4, QA
- Fit: cheap win for error-page design units (web + optional Compose error states).

### 11 DesignMD (designmd.ai)
- Canonical: https://designmd.ai/
- Status: LIVE (curl 200)
- Description: "100s of free design systems your AI coding tools actually read" — community-made DESIGN.md files for Cursor / Claude Code.
- License/cost: explicitly FREE design systems.
- Phases: PHASE-3
- Fit: prime DESIGN.md fuel — pick a community DESIGN.md, adapt into our Phase 3 design contract; zero-cost token/brand source.

### 12 VibePrompt (vibeprompts.dev)
- Canonical: https://vibeprompts.dev/
- Status: LIVE (curl 200)
- Description: Curated UI layout prompts + ready-to-paste Tailwind CSS snippets for every page section (heroes, pricing, FAQ, dashboards).
- License/cost: free snippets (inference: likely pro tier — unverified).
- Phases: PHASE-3, PHASE-4
- Fit: Tailwind-adjacent = matches our web token stack; copy-paste section patterns as starting points for PHASE-4 units.

### 13 21st.dev
- Canonical: https://21st.dev/
- Status: LIVE (curl 200)
- Description: 12,000+ hand-crafted React + Tailwind CSS components, templates, and shadcn themes; live preview, one-command install (title: "for free").
- License/cost: free install command (copy-paste model, MIT-style per component — inference: check license per component).
- Phases: PHASE-4
- Fit: direct React+TS component source for Phase 4 web; shadcn theme variants feed PHASE-3 DESIGN.md.

### 14 Kinetics (kinetics.colorion.co)
- Canonical: https://kinetics.colorion.co/
- Status: LIVE (curl 200)
- Description: Spring-physics micro-interaction library for web apps — copy the CSS or React, tune the physics.
- License/cost: copy-paste (inference: free with attribution/credits — unverified).
- Phases: PHASE-4
- Fit: motion language for React web surfaces; Compose mobile would translate spring params to animateSpring (manual port).

### 15 Aceternity UI (ui.aceternity.com)
- Canonical: https://ui.aceternity.com/
- Status: LIVE (curl 200)
- Description: Popular copy-paste React/Tailwind UI component library (hero blocks, cards, CTAs, animations).
- License/cost: free copy-paste (per-component license — MIT-style; verify per component).
- Phases: PHASE-4, PHASE-3
- Fit: immediately usable in Phase 4 web; aesthetic reference for dark/gradient SaaS directions in PHASE-3.

### 16 Magic UI (magicui.design)
- Canonical: https://magicui.design/
- Status: UNVERIFIED (web_fetch 403 Cloudflare; curl connection 000 ×2 — site likely up but unreachable from this network; last seen as a known open-source component library)
- Description (inference, unverified live): open-source animated React/Next.js + Tailwind component library (the shadcn-ecosystem "magicui").
- License/cost: (inference) copy-paste, open source (MIT) — verify when reachable.
- Phases: PHASE-4
- Fit: same role as aceternity/motion-primitives — copy-paste animated components for Phase 4 web.

### 17 Motion Primitives (motion-primitives.com)
- Canonical: https://motion-primitives.com/
- Status: LIVE (curl 200)
- Description: "Open-source UI kit to make beautiful, animated interfaces, faster. Built for React, Next.js, and Tailwind CSS."
- License/cost: explicitly open source.
- Phases: PHASE-4
- Fit: drop-in animated components for React web; motion vocabulary for QA (animation consistency checks).

### 18 Anime.js (animejs.com)
- Canonical: https://animejs.com/
- Status: LIVE (curl 200)
- Description: "A fast, multipurpose and lightweight JavaScript animation library."
- License/cost: free, MIT (anime.js is MIT-licensed — well-established fact).
- Phases: PHASE-4
- Fit: general-purpose JS animation engine for web surfaces; NOT usable on Android Compose (port via Compose animations manually if a shared motion language matters).

### 19 shadcn/ui (ui.shadcn.com)
- Canonical: https://ui.shadcn.com/
- Status: LIVE (curl 200)
- Description: "Composable, accessible components with thoughtful defaults. Build your own component library with code you can customize, extend, and make your own."
- License/cost: copy-paste code, per-component MIT-style licenses (the de-facto standard).
- Phases: PHASE-4, PHASE-3, QA
- Fit: anchor of our React+TS stack — base component set for Phase 4 web; a11y defaults support QA checks; Compose apps translate its token model (radii/colors) into Compose material3 tokens.

### 20 Uiverse (uiverse.io)
- Canonical: https://uiverse.io/
- Status: UNVERIFIED (curl 403 Cloudflare WAF challenge; web_fetch blocked — site is a known live component gallery, status unconfirmed this run)
- Description (inference, unverified live): community gallery of CSS-only buttons, loaders, cards, etc.
- License/cost: community snippets, copy-paste (per-component license notes).
- Phases: PHASE-4, QA
- Fit: quick CSS/HTML snippet inspiration (buttons/loaders/cards) for web; Compose port is manual.

### 21 UIAble (uiable.com)
- Canonical: https://uiable.com/
- Status: LIVE (curl 200)
- Description: "Beautifully designed UI components you can customize, extend, and make your own. Open source and built for Next.js."
- License/cost: explicitly open source.
- Phases: PHASE-4
- Fit: copy-paste React/Next.js components; alternative complement to shadcn for richer visual components.

### 22 MapCN (mapcn.dev)
- Canonical: https://www.mapcn.dev/ (apex 307 → www; LIVE)
- Description: Beautifully designed, accessible, customizable map components — MapLibre GL + Tailwind, works with shadcn/ui.
- License/cost: copy-paste open source (inference: per-component license — unverified).
- Phases: PHASE-4
- Fit: ready-made map component for React web; NOT applicable to Compose (Android maps need a native map library).

### 23 MicroKit (microkit.co)
- Canonical: https://microkit.co/
- Status: LIVE (curl 200)
- Description: "49 free copy-paste microinteractions for React, CSS and Tailwind — animated buttons, hover effects, tabs and inputs. No package to install, MIT licensed."
- License/cost: explicitly MIT, no install.
- Phases: PHASE-4, QA
- Fit: zero-dependency microinteraction snippets for web; QA reference for hover/animation states.

### 24 Liquid Glass / glass.samasante.com
- Canonical: https://glass.samasante.com/
- Status: LIVE (curl 200)
- Description: "liquid-glass — refract the live DOM, in every browser" (inference: a CSS/WebGL liquid-glass refractive effect library).
- License/cost: (inference: open source — unverified; check repo license).
- Phases: PHASE-4
- Fit: niche effect for web "glassmorphism" directions; heavy/flashy — use sparingly, not a default.

### 25 Text Effects CSS (text-effects.colorion.co)
- Canonical: https://text-effects.colorion.co/
- Status: LIVE (curl 200)
- Description: 90 pure-CSS animated text effects (gradient, glitch, typewriter, neon, liquid fill) — click to copy CSS, no dependencies.
- License/cost: explicitly free to copy (attribution status unverified — check per effect).
- Phases: PHASE-4, PHASE-2
- Fit: instant CSS text-animation vocabulary for headings/hero copy in web Phase 4.

### 26 Circle Loaders (circleloaders.dominikakissi.com)
- Canonical: https://circleloaders.dominikakissi.com/
- Status: LIVE (curl 200)
- Description: 24 monochrome circular loading animations — standalone animated SVG spinners, pure CSS+SVG, no dependencies.
- License/cost: explicitly free standalone assets (attribution unverified).
- Phases: PHASE-4, QA
- Fit: drop-in SVG loaders for web loading states; ports to Compose as vector draw-anim loaders.

### 27 Gradient Buttons (gradientbuttons.colorion.co)
- Canonical: https://gradientbuttons.colorion.co/
- Status: LIVE (curl 200)
- Description: Hundreds of CSS gradient buttons — one-click copy to clipboard.
- License/cost: free snippets (attribution unverified).
- Phases: PHASE-4
- Fit: quick CTA button styling reference; pair with CTA Gallery (#09) for conversion surfaces.

### 28 Kitbitz (kitbitz.art)
- Canonical: https://kitbitz.art/
- Status: LIVE (curl 200)
- Description: 2,000+ free hand-drawn illustrations — SVG/PNG downloads, Figma kits/components, Figma plugin.
- License/cost: explicitly free.
- Phases: PHASE-4, PHASE-1
- Fit: illustration asset source for empty states, onboarding, marketing surfaces (web + Compose via SVG/PNG import).

### 29 3D Icons (3dicons.co)
- Canonical: https://3dicons.co/
- Status: LIVE (curl 200)
- Description: 1,440+ open-source premium 3D icons — completely free, no attribution, commercial use allowed.
- License/cost: explicitly free + no attribution (per site).
- Phases: PHASE-4, PHASE-1
- Fit: 3D icon assets for app icons, empty states, marketing (web SVG/PNG; Compose PNG import).

## Adoption notes — top 10 ranked by immediate value (React+TS web + Compose mobile)

1. **shadcn/ui (#19)** — the anchor. How we use it: Phase 4 web component base; its token model (colors/radii/typography CSS vars) is the direct template for our Tailwind-adjacent tokens; Compose apps mirror its token scale into material3. Critic references its a11y defaults in QA.
2. **DesignMD (#11)** — Phase 3 fuel. How we use it: pick a community DESIGN.md (or adapt one) as the design-system contract before Stitch generation; it's the exact artifact format our ai-design-workflow Phase 3 consumes.
3. **Refero Styles (#04)** — Phase 3 alternative fuel. How we use it: "Website Styles & DESIGN.md Library" — browse styles, extract tokens, drop into DESIGN.md; good for exploring directions before committing.
4. **Aceternity UI (#15)** — Phase 4 web. How we use it: copy-paste React/Tailwind/Motion components (cards, hero blocks, CTA animations) for visually rich surfaces; also a dark/gradient direction reference for Phase 2 briefs.
5. **Motion Primitives (#17)** — Phase 4 web. How we use it: open-source animated component kit (React/Next/Tailwind) — richer motion out of the box than aceternity; QA checks animation consistency against it.
6. **21st.dev (#13)** — Phase 4 web. How we use it: one-command install of 12,000+ React/Tailwind components + shadcn themes; fastest way to source a whole component family for a surface.
7. **Kinetics (#14)** — Phase 4 web motion. How we use it: spring-physics microinteractions, copy CSS/React; gives a consistent spring motion language (port params to Compose `animateSpring` for mobile parity).
8. **Kage (#03)** — Phase 2 → Phase 4 bridge. How we use it: find a real-product UI we like, generate a build prompt, feed that prompt to our Phase 4 sub-agent as a spec supplement.
9. **VibePrompt (#12)** — Phase 3/4. How we use it: per-section (hero/pricing/FAQ/dashboard) UI prompts + ready Tailwind snippets; fast section scaffolding when a DESIGN.md exists.
10. **Component Gallery (#06)** — QA vocabulary. How we use it: critic reference for component-level critiques (buttons, cards, forms); quick pattern lookup before writing a Phase 4 unit.

Runners-up: CTA Gallery (#09, conversion-surface reference + QA), Gradient Buttons (#27, pairs with CTA work), Text Effects (#25, hero headings), MicroKit (#23, zero-dep microinteractions), 3D Icons (#29) + Kitbitz (#28, asset sources for empty states/onboarding), Anime.js (#18, general JS animation fallback), Minimal Gallery (#02) + Scrolltide (#01, inspiration/prompt mining), AppShot (#05, mobile-only), MapCN (#22, maps-only), UIAble (#21), Magic UI (#16, unverified), Uiverse (#20, unverified), 404s (#10, error pages), Footer (#08, footers).

Integration tips:
- The .gallery/.design family (06-10) blocks datacenter fetchers (Cloudflare 1015) but is verified alive via browser-UA curl; a sub-agent fetching them must use curl with a browser UA or the on-device browser.
- Magic UI (#16) and Uiverse (#20) were unreachable from this network this run (Cloudflare WAF / connection 000) — treat as UNVERIFIED, re-check later.
- For Compose parity, the web-only copy-paste resources need manual port; the ones with portable value are token/model sources (shadcn, DESIGN.md libraries) and asset sources (Kitbitz, 3D Icons).

## Result

- Checked: 29 of 29.
- LIVE: 27 (scrolltide, minimal.gallery, kage.design, styles.refero.design, appshot.gallery, component.gallery, navbar.gallery, footer.design, cta.gallery, 404s.design, designmd.ai, vibeprompts.dev, 21st.dev, kinetics.colorion.co, ui.aceternity.com, motion-primitives.com, animejs.com, ui.shadcn.com, uiable.com, mapcn.dev, microkit.co, glass.samasante.com, text-effects.colorion.co, circleloaders.dominikakissi.com, gradientbuttons.colorion.co, kitbitz.art, 3dicons.co).
- DEAD: 0.
- UNVERIFIED: 2 (magicui.design — Cloudflare 403 + connection timeout ×2; uiverse.io — Cloudflare 403 WAF challenge).
- MOVED: 0 (several apex domains redirect to www: scrolltide, appshot, mapcn, navbar, footer, cta, 404s — canonical URLs use the www form; not counted as moved).
- Top 5 recommendations: shadcn/ui, DesignMD, Refero Styles, Aceternity UI, Motion Primitives (full top-10 with "how we use it" in Adoption notes above).

## Addendum (27 Sept 2026): designmd CLI integration
- `designmd` npm CLI installed globally in the workspace rootfs; DESIGNMD_API_KEY persisted in ~/.bashrc.
- LIVE-VERIFIED: `designmd search "fintech" --json` (MIT-licensed kits w/ preview colors + tags), `designmd tags`, `designmd download chef/crypto-blue -o ./DESIGN.md` → valid DESIGN.md (74 lines).
- Tool model: search/browse-tags free; get/download/upload/delete need the API key.
- MCP server (npx designmd-mcp) is stdio-only and mcp.designmd.ai does NOT resolve in DNS (000 from workspace too) — CLI is the sanctioned integration path.
- 21st.dev MCP (https://mcp.21st.dev/mcp, streamable_http) registered app-side but ERRORED "needs authorization" — requires a 21st.dev API key from the user; workspace resolves the host fine, device DNS was transiently flaky (retry succeeded).

## Addendum 2 (27 Sept 2026): 21st MCP connected & live-verified
- Registered: id bd5ceab0-6dfd-4837-aa3d-fd13e191a888, url https://21st.dev/api/mcp (streamable_http), header x-api-key (user-supplied key).
- ENDPOINT TRUTH (from 21st-dev/magic-mcp README): mcp.21st.dev is a marketing page serving HTML, not MCP; old Cloud Run endpoint (mcp-842306918693.us-west1.run.app) is dead/rotated; correct = https://21st.dev/api/mcp with x-api-key header (NOT Authorization Bearer).
- 34 tools synced. Auth verified live: search works, get_usage → Tier free, 2/2 daily component-code retrievals remaining, AI generation NOT enabled (use search + get_component, then adapt with own agent).
- Usage rules: `search` free metadata; `get_component` = PAID step (2/day free tier) — flagship-first; `get_theme` free full CSS tokens; templates = metadata only.
- Component install shape: npx shadcn@latest add "https://21st.dev/r/<user>/<slug>?api_key=$API_KEY_21ST".

## Addendum 3 (27 Sept 2026): re-verification + component-install wiring
- Magic UI (magicui.design) re-verified LIVE via 3rd fetch path ("UI library for Design Engineers"); Uiverse (uiverse.io) re-verified LIVE via device-network fetch ("The Largest Library of Open-Source UI elements" — free copy-paste CSS/Tailwind, open-source GitHub). Both had been UNVERIFIED (workspace fetcher blocked); final count 29/29 live-verified.
- Phase-4 component-install commands now wired into the ai-design-workflow skill:
  - shadcn: `npx shadcn@latest add <component-or-url>` (npx-runnable from workspace shell; no global install needed)
  - 21st: `npx shadcn@latest add "https://21st.dev/r/<user>/<slug>?api_key=$API_KEY_21ST"` (install command returned per search result); get_component for flagship pieces only (2/day free tier), search type:theme + get_theme for free CSS tokens.

## Addendum 4 (7 Oct 2026): two GitHub-based design resources
| # | Name | URL | Status | Phase tags | License |
|---|------|-----|--------|-----------|---------|
| 30 | Awesome Design | https://github.com/gztchan/awesome-design | LIVE (stale — last push 2024-07) | P1 P2 | no SPDX license field (custom); curated links only |
| 31 | Awesome Design MD | https://github.com/VoltAgent/awesome-design-md | LIVE (very active — push 2026-10-05) | P3 P4 | MIT |

### 31 Awesome Design MD (VoltAgent/awesome-design-md) — VERIFIED IN DEPTH
- 119.9k stars; ~100+ top-brand DESIGN.md analysis files under design-md/<brand>/DESIGN.md (+README.md per brand): airbnb, apple, airtable, binance, bmw, bugatti, etc.
- Sampled airbnb/DESIGN.md (545 lines): REAL token sets — colors (hex + usage), typography, shape/rounding, spacing — machine-readable, raw-downloadable: `curl -sS https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<brand>/DESIGN.md`.
- USE: Phase-3 DESIGN.md fuel alongside designmd.ai (designmd = community kits; VoltAgent = TOP-BRAND analysis). A designer picks the adjacent brand, we download its DESIGN.md as the scaffold, adapt tokens to the project's brand, and feed the result to Stitch create_design_system + the code surface. Also useful as critic reference: "does our spacing/type hierarchy hold up vs the brand we chose?"
- 30 (gztchan/awesome-design): general curated-links list, stale since 2024 — use only for P1 browsing; prefer the 29-site library + VoltAgent for fuel.

## Addendum 5 (16 Oct 2026): Hallmark — anti-AI-slop design skill (INSTALLED as a skill)
| # | Name | URL | Status | Phase tags | License |
|---|------|-----|--------|-----------|---------|
| 32 | Hallmark (Nutlope) | https://github.com/nutlope/hallmark | LIVE (push 2026-08-06) | P2 P3 P4 QA | MIT |

### 32 Hallmark — VERIFIED IN DEPTH, INSTALLED
- 30.2k★; "A design skill for Claude Code/Cursor/Codex that refuses to look AI-generated" (Together AI). Encodes anti-slop rules from Anthropic's frontend-design skill + 2026 "tactile rebellion" consensus.
- **Four verbs**: default (build new UI w/ macrostructure + 21 themes + 57 slop-test gates + pre-emit self-critique), `hallmark audit <target>` (score existing code vs anti-patterns → punch list, no edits), `hallmark redesign <target>` (keep copy/IA/brand, rebuild visual structure w/ different fingerprint), `hallmark study <screenshot|URL>` (extract design DNA → diagnosis → optional portable design.md; refuses pixel-clones + template-marketplace URLs).
- 21 macrostructures (bento-grid, long-document, marquee-hero, workbench, manifesto, specimen, catalogue…), 21 themes, ~60 component archetypes under references/ (heroes, footers, navs, features, testimonials), per-genre rulebooks (modern-minimal, editorial, atmospheric, playful).
- INSTALL STATE: SKILL.md (67.4KB, single-line frontmatter, native format) installed via skill_install_from_url + full references/ tree mirrored (107 files, 973K) at /skills/hallmark/. **ENABLED FLAG STUCK AT FALSE** despite install response auto_enabled:true — use_skill returns skill_not_enabled; needs the manual Settings > Assistants > Skills toggle (user action, same class as the 11 Sept neon skills). Re-test use_skill after the toggle.
- USE once enabled: (a) Phase-2/3 generation with slop-gates; (b) `hallmark audit` as a CRITIC input for the EaseApply landing polish; (c) `hallmark study` on competitor sites for direction briefs (own-brand attestation required for design.md emission); (d) `hallmark redesign` for the queued UI redesign.

## Addendum 6 (31 Oct 2026): oneshotprompts.com — 923-technique motion-design vocabulary (LIVE-VERIFIED, index loaded locally)
| # | Name | URL | Status | Phase tags | License/cost |
|---|------|-----|--------|------------|--------------|
| 33 | oneshotprompts | https://oneshotprompts.com | LIVE (31 Oct 2026: /techniques/ curl 200 @ 113KB; /llms.txt + 2 technique pages fetched; 923/923 parsed, all 10 kind counts reconcile) | P2 P3 P4 QA | Free; prompts written in the editor stay in the user's browser |

### 33 oneshotprompts — VERIFIED IN DEPTH
- WHAT: a free motion-design prompt editor + a vocabulary of **923 techniques** (term-id + name + one-sentence plain-English definition + aliases; 900 with a live example). Two axes: 8 GOALS (what you're making — App demo 103, Logo intro 30, Titles & text 57, Data & numbers 80, Social post 27, Scene changes 84, Backgrounds 51, Retro & glitch 50) × 10 KINDS (Principles & timing 101, Typography 112, Transitions 82, UI & interaction 121, Shape & vector 84, Particles & generative 122, Camera/3D & light 80, VFX & post 87, Broadcast & data 111, Sound & music 23).
- MACHINE PATH FOR THIS HARNESS (WebMCP is Chrome-only and NOT exposed to the in-app WebView — use plain text): `/llms.txt` (agent docs + the full spec-format reference), `/techniques/` (all 923 as server-rendered anchors — one curl gets the whole index), `/techniques/<id>/` (definition + "also called" aliases + plain-words triggers + related, per technique, one cheap fetch each).
- **LOCAL INDEX (the integration point)**: `knowledge/motion-techniques.json` in THIS repo (mirrored to the ide-setup package) = all 923 entries as goals + kind → subgroup → {id, name, live}, retrieved 31 Oct 2026, counts verified against the site. Grep-able by name/id — browse the vocabulary with zero re-fetches.
- SPEC FORMAT (from /llms.txt): plain prose with light markup — `## Scene (3s)` lines, `-`/`1.` steps, `[blanks]` for unknowns (never invent facts), `[your words]{term-id}` links the author's own phrasing to a technique's exact definition (e.g. `the card [pops in with a little bounce]{overshoot-bounce-in}`), settings on a link `{term-id|strength=subtle|speed=faster|when=1.5-3|on=the logo}`; piece-level settings (shape, length, style, look, sound, model) live outside the text.
- USE (project-agnostic — the skill carries the standing rule): the ai-design-workflow skill now has a MOTION layer (Phase M). For any project whose deliverables include motion (landing hero, page transitions, product-demo video, logo sting, social clip, onboarding), the designer produces a per-project **MOTION.md** (in the project repo, sibling of DESIGN.md): written in the oneshot format, every scene/surface cites technique ids with explicit duration + named easing + stagger. Medium-agnostic output: (a) VIDEO deliverables → map scenes/settings to 21st Video MCP ops (add_scene by job block, fit_length, transition, music); (b) WEB → CSS/React (Framer/CSS, MicroKit/Aceternity snippets as starting points); (c) COMPPOSE → manual port of the same named easings (animateSpring/animateFloat); (d) any finished prompt is paste-portable to Claude/ChatGPT/Codex + a video model.
- QA: motion-slop gates added to the critic checklist (in the skill) — no uniform default easing across all entrances; every entrance/exit names a technique id + duration + easing in MOTION.md; stagger scales with list length; ≤3 distinct motion patterns per screen; prefers-reduced-motion respected on web; ≤1 ambient loop per screen.
- STATUS of the site's newsletter ("Motion Cheat Sheet", weekly email) and the editor's WebMCP tools: not used by this harness; plain-text path is fully sufficient (verified).

## Addendum 7 (31 Oct 2026): skill-issue.in — usage-ranked agent-skill discovery index (LIVE-VERIFIED)
| # | Name | URL | Status | Phase tags | License/cost |
|---|------|-----|--------|------------|--------------|
| 34 | Skill Issue | https://skill-issue.in | LIVE (31 Oct 2026: main + 4 skill detail pages fetched, HTTP 200; 4 source repos verified on GitHub) | P2 P3 P4 M QA (discovery layer) | Free index over open-source SKILL.md repos |

### 34 Skill Issue — VERIFIED IN DEPTH
- WHAT: a ranked, curated library of agent skills (SKILL.md files) — "curated by what actually gets used". 9 categories (Design, Frontend, Backend, Motion Graphics, Game Dev, Finance, Research, Social Media, Automation Tools); each entry carries subcategory, usage stats (installs/stars + click count), open-source flag, and a copy-paste install command (`npx skills add <owner>/<repo> [--skill <name>]`).
- DIFFERENCE FROM RESOURCES #01–#33: those are design INPUTS (inspiration, tokens, components, motion vocabulary); #34 is the TOOLING/CAPABILITY layer — it indexes skills the agent can install. This library says what to build with; #34 says which capabilities to install first.
- LIVE-VERIFIED TOP ENTRIES FOR OUR STACK (31 Oct 2026 — repos + SKILL.md inspected):
  - ui-ux-pro-max (nextlevelbuilder/ui-ux-pro-max-skill, 143k★, pushed 31 Oct 2026): searchable local design intelligence — 79 styles, 192 palettes with reasoning profiles, 74 font pairings, 119 UX guidelines, 17 GSAP presets, 25 chart types, 22 stacks; bundled Python search CLI + references/; native SKILL.md. Install: `npx skills add nextlevelbuilder/ui-ux-pro-max-skill`.
  - remotion-best-practices (remotion-dev/skills — official, 5.9k★, pushed 26 Oct 2026): router over 12 official Remotion skills (create/markup/captions/maps/multimedia/render/saas/studio/interactivity/docs/upgrade). Install: `npx skills add remotion-dev/skills`.
  - web-design-guidelines (vercel-labs/agent-skills — 33.3k★, pushed 28 Oct 2026): UI code review against the live Vercel Web Interface Guidelines (100+ rules, fetched fresh per review), terse file:line findings. Same repo: react-best-practices (impact-ranked perf rules), react-view-transitions, composition-patterns. Install: `npx skills add vercel-labs/agent-skills --skill web-design-guidelines`.
  - frontend-design (anthropics/skills, 185.8k★): Anthropic's original anti-generic-UI skill — ALREADY SUPERSEDED by installed Hallmark (Hallmark encodes frontend-design's anti-slop rules + the 2026 tactile-rebellion consensus). Do NOT install alongside Hallmark (conflicting Phase-2/3 guidance).
  - taste-skill / taste-frontend (sergebulaev/x-skills): same territory — skip, Hallmark covers it.
- WORKFLOW PLACEMENT (project-agnostic standing rule, mirrored in the ai-design-workflow skill):
  - LAYER: skill/capability discovery — upstream of all phases. RULE: before writing a custom skill (skill-creator path) for a recurring need, check skill-issue.in for a usage-ranked existing skill; install only non-duplicating ones (duplication check vs the installed set; Hallmark covers design-taste).
  - PHASE-2/3 (Look + Contract): ui-ux-pro-max as a queryable design-intelligence DB when authoring direction briefs / DESIGN.md tokens (styles, palettes, font pairings, stack UX rules).
  - PHASE-M (Motion, video deliverables): remotion-best-practices as the ENGINEERING half of the motion layer — oneshotprompts (#33) is the vocabulary (what to do), remotion skills are the implementation doctrine (how, in Remotion — 21st Video's substrate).
  - QA (critic): web-design-guidelines as a critic INPUT — 100+ WIG rules, fetched live per review, file:line findings feed the critique card alongside token/vibrancy checks.
  - PHASE-4 (code, optional): react-best-practices as a builder-side supplement — belongs to quality-gate knowledge, not the design contract.
- INSTALL STATE (31 Oct 2026, user approved "all three"): ALL THREE INSTALLED + VERIFIED. (1) ui-ux-pro-max: DB-registered (skill_install_from_url, native) + /skills/ui-ux-pro-max/ materialized byte-complete vs upstream clone (SKILL.md + data/ 25 CSV/JSON catalogs incl. 747KB google-fonts + references/ + scripts/ dependency-free Python CLI; 3.7MB). CLI LIVE-TESTED: `python3 /skills/ui-ux-pro-max/scripts/search.py "fintech equity research dashboard dark" --design-system -p EquityScout` → full design-system output (pattern/style/colors/typography). (2) remotion-best-practices: DB-registered + /skills/remotion-best-practices/ = the repo's self-contained router bundle (SKILL.md + 11 reference subtrees incl. maps/techniques; 1.8MB, byte-complete). (3) web-design-guidelines: DB-registered + /skills/web-design-guidelines/SKILL.md (fetches live WIG rules per review; 7.5KB). KNOWN ENGINE BUG (same class as Hallmark 16 Oct): install responses claimed auto_enabled:true but the enabled flag STUCK AT FALSE — use_skill → skill_not_enabled. Fix = user toggles each in Settings → Assistants → Skills (ui-ux-pro-max, remotion-best-practices, web-design-guidelines). DB + files are ready regardless; the toggle only flips the per-assistant enabled set.
