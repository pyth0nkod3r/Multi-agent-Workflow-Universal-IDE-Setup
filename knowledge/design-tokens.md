# Research notes — design tokens, DESIGN.md, and design-to-code
Source: blog.obimadu.pro/design-tokens-md-to-code (read 11 Sept 2026) + tool docs.

## Core model
- Token = named value carrying intent (color.primary, radius.md) — the reason, not
  just the result. One decision → --color-primary (CSS), theme.colors.primary
  (Tailwind), Color.primary (iOS).
- Hierarchy: components bind semantic tokens → semantic tokens point at primitives →
  change a primitive, everything downstream follows.
- Tokens alone say WHAT; DESIGN.md adds WHY + when/when-not (e.g. "primary only for
  main CTA"). That unexpressible-into-JSON part is the point of the prose.

## DESIGN.md format (open-sourced from Google Stitch, Apache 2.0, alpha)
- Repo root beside README/CLAUDE/AGENTS.md. Two layers: YAML front matter (tokens) +
  markdown prose.
- 8 sections, fixed order: Overview / Colors / Typography / Layout / Elevation &
  Depth / Shapes / Components / Do's and Don'ts.
- {colors.tertiary} reference syntax (W3C DTCG-inspired); change once, updates everywhere.
- sRGB hex only in alpha (no oklch/P3). CLI exports Tailwind v3/v4 + W3C DTCG.
- Known limitation (Atlassian production test): loads everything at once — ~92% more
  tokens than per-component MCP fetch, 2.7x run variance. It's a portable snapshot,
  not a pipeline replacement. Fine at our scale; keep prose lean.
- Catalogs exist (getdesign.md, Open Design, designmd.app, awesome-design-md) — adapt
  a close one instead of writing from zero when re-theming.

## Tool roles (the roadmap)
1. pen.dev (pencil.dev) — flow/wireframe FIRST, colors irrelevant. Also a design
   canvas in-IDE (.pen files git-tracked, starts local MCP server, variables map to
   CSS custom properties; pencil-atelier plugin extracts .pen → design.md).
2. Google Stitch — the LOOK + instant design system (generates design.md /
   component overview; ours is reachable + installed as MCP).
3. Penpot — the malleable surface; FIRST tool with native W3C design-tokens support
   (sets→themes, standard export); MCP drives the focused page.
4. DESIGN.md — the durable contract ALL of them + code agents read.

## Golden rules (beginner roadmap, adopted as policy)
- Never blank-canvas: AI generates, human curates.
- Borrow UI kits (Penpot libraries-templates marketplace), steal layouts from apps
  users already know, constraints: 1 primary + 1 accent + 2 neutrals.

## Fit to our stack
- Our agent + sub-agent profiles already read root markdown natively → DESIGN.md is
  the natural contract layer (CLAUDE.md = behavior, DESIGN.md = look).
- Stitch upload_design_md closes the loop: local DESIGN.md → Stitch design-system
  asset → consistent screen generation (designSystem param).
- Penpot = optional interactive polish, LAST (needs user-in-the-loop connection).
