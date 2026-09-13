# RikkaHub-Compatible Agent Environment for VS Code

A universal, portable, project-independent configuration that replicates the mobile **RikkaHub Agent** environment across all VS Code agent harnesses: **Antigravity**, **Claude Code**, **GitHub Copilot / VS Code Agent Host**, **Codex**, and **Kilo Code**.

---

## 🚀 One-Command Replication on Any Laptop

On any machine with VS Code and Git:

```powershell
# 1. Clone into your coding root or workspace
git clone https://github.com/pyth0nkod3r/rikkahub-codex-environment.git

# 2. Run the one-shot setup script
powershell -ExecutionPolicy Bypass -File .\rikkahub-codex-environment\tools\setup.ps1
```

This single command:
1. Verifies/installs **`uv`** (ensuring the Python policy is active).
2. Verifies Node.js & installs optional CLI tooling (`firecrawl-cli`, `@pen.dev/cli`).
3. Deploys the **6 multi-agent roster roles** to Claude Code (`~/.claude/agents/`), Kilo Code (`.kilo/agents/`), and Antigravity (`.agents/agents/`).
4. Syncs the core skills (`rikkahub-orchestration`, `ai-design-workflow`, `uv-default`) to Codex and workspace harnesses.
5. Sets up universal MCP server configurations (`Youdotcom` active, `googleStitch` ready for key).
6. Links the **Universal Orchestrator** contract so **any active agent automatically orchestrates multi-agent tasks**.

---

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
