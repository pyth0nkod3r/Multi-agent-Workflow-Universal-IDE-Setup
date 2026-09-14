# RikkaHub-compatible Codex environment
# RikkaHub-Compatible Agent Environment for VS Code

This is a portable, repository-free counterpart to the mobile RikkaHub environment. It contains no handover credentials and does not clone or modify any project repository. The shared VS Code workspace adapters are installed beside this folder in `.agents/`, `.vscode/mcp.json`, `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md`.
A universal, portable, project-independent configuration that replicates the mobile **RikkaHub Agent** environment across all VS Code agent harnesses: **Antigravity**, **Claude Code**, **GitHub Copilot / VS Code Agent Host**, **Codex**, and **Kilo Code**.

## What is included
---

- `AGENTS.md`: durable, project-independent working rules.
- `skills/`: Codex skill packages for orchestration, design workflow, and the `uv` Python policy.
- `agents/`: six reusable role prompts: planner, researcher, builder, critic, designer, and merger.
- `mcp/config.toml`: safe Codex MCP configuration. You.com is ready; Google Stitch and Penpot require fresh user-owned credentials.
- `tools/bootstrap.ps1`: an opt-in installer for `uv`, Firecrawl CLI, and Pencil CLI.
## 🚀 One-Command Replication on Any Laptop

## Harness coverage
On any machine with VS Code and Git:

- **Antigravity** automatically discovers the `.agents/rules`, `.agents/skills`, `.agents/agents`, and `.agents/mcp_config.json` adapters.
- **VS Code Agent Host/Copilot** reads `.vscode/mcp.json`; use **MCP: List Servers** to approve and start the servers.
- **Claude Code** reads the workspace `CLAUDE.md`; its global skill copies are installed separately.
- **Codex** uses its global skills and MCP configuration, installed separately.
- **Kilo Code and other agents** can follow the root `AGENTS.md` and the neutral source files in this directory.
```powershell
# 1. Clone into your coding root or workspace
git clone https://github.com/pyth0nkod3r/rikkahub-codex-environment.git

## Install into Codex
# 2. Run the one-shot setup script
powershell -ExecutionPolicy Bypass -File .\rikkahub-codex-environment\tools\setup.ps1
```

1. Copy `AGENTS.md` to the parent workspace where you want these rules to apply, or reference it from a workspace-specific `AGENTS.md`.
2. Copy each directory in `skills/` to `C:\Users\ZION\.codex\skills\`.
3. Merge the entries from `mcp/config.toml` into `C:\Users\ZION\.codex\config.toml`; do not replace the existing file.
4. Set `GOOGLE_STITCH_API_KEY` only after you obtain a new valid key. Add the Penpot URL only after generating a new token; query-string MCP tokens are intentionally not stored here.
5. In a new Codex chat, ask for `rikkahub-orchestration` when a task warrants the six-role workflow.
This single command:
1. Verifies/installs **`uv`** (ensuring the Python policy is active).
2. Verifies Node.js & installs optional CLI tooling (`firecrawl-cli`, `@pen.dev/cli`).
3. Deploys the **6 multi-agent roster roles** to Claude Code (`~/.claude/agents/`), Kilo Code (`.kilo/agents/`), and Antigravity (`.agents/agents/`).
4. Syncs the core skills (`rikkahub-orchestration`, `ai-design-workflow`, `uv-default`) to Codex and workspace harnesses.
5. Sets up universal MCP server configurations (`Youdotcom` active, `googleStitch` ready for key).
6. Links the **Universal Orchestrator** contract so **any active agent automatically orchestrates multi-agent tasks**.

## Intentional exclusions
---

All project repositories, Android-only tools, scheduled jobs, device automation, old handover secrets, and project-specific policies are excluded. Rotate the Firecrawl, Pencil, Stitch, and Penpot credentials exposed in the handover before any future use.
## 🏛️ Architecture & Components

```
rikkahub-codex-environment/
├── AGENTS.md                  # Durable workspace policies (uv, orchestration, design)
├── ORCHESTRATOR.md            # Universal Orchestrator multi-agent protocol
├── agents/                    # Canonical 6-role roster prompts
│   ├── planner.md
│   ├── researcher.md
│   ├── builder.md
│   ├── critic.md
│   ├── designer.md
│   └── merger.md
├── skills/                    # Universal skill packages
│   ├── rikkahub-orchestration/
│   ├── ai-design-workflow/
│   └── uv-default/
├── mcp/
│   ├── config.toml            # Codex MCP server definitions
│   └── mcp.json               # Generic MCP endpoint definitions
└── tools/
    ├── setup.ps1              # One-shot universal setup script
    └── bootstrap.ps1          # Standalone CLI package installer
```

---

## 🤖 Universal Orchestrator Protocol

Switching between agents during a project does not break orchestration:
- **Disk-Anchored State**: Run plans live under `tasks/<runid>/` and results under `runs/<runid>/`.
- **RESULT-LAST**: Sub-agents conclude with a validated `## Result` block.
- **SUCCEEDED ≠ Done**: Orchestrator inspects disk changes rather than relying on status reports.
- **Blind Critic Gate**: Independent verification against acceptance criteria; maximum 3 revision loops.
- **Zero Fluff**: No agent-to-agent chatter; coordination occurs strictly through artifacts on disk.

---

## 🔒 Security & Credentials

This repository contains **zero secrets or credentials**.
- **You.com MCP**: Ready out of the box (unauthenticated streamable HTTP).
- **Google Stitch**: Provide `GOOGLE_STITCH_API_KEY` via your system environment variables.
- **Penpot**: Connect on-demand from your active Penpot browser session.
- **Firecrawl**: Export `FIRECRAWL_API_KEY` in your environment profile.
