# Multi-Agent Workflow — Universal IDE Setup

A universal, portable, project-independent configuration that replicates the **Multi-Agent Workflow** across all VS Code agent harnesses: **Antigravity**, **Claude Code**, **GitHub Copilot / VS Code Agent Host**, **Codex**, and **Kilo Code**.

---

## 🚀 One-Command Setup on Any Laptop

On any machine with VS Code and Git:

```powershell
# 1. Clone into your coding root or workspace
git clone https://github.com/pyth0nkod3r/Multi-agent-Workflow-Universal-IDE-Setup.git

# 2. Run the one-shot setup script
powershell -ExecutionPolicy Bypass -File .\Multi-agent-Workflow-Universal-IDE-Setup\tools\setup.ps1
```

Or run directly in one line:
```powershell
git clone https://github.com/pyth0nkod3r/Multi-agent-Workflow-Universal-IDE-Setup.git; powershell -ExecutionPolicy Bypass -File .\Multi-agent-Workflow-Universal-IDE-Setup\tools\setup.ps1
```

### What This Single Command Automatically Executes:
1. **Python Tooling (`uv`)**: Verifies/installs Astral's `uv` package manager (`uv`-by-default policy).
2. **Global CLI Utilities**: Installs/updates `firecrawl-cli` and `@pen.dev/cli` globally via npm.
3. **Multi-Agent Roster (v4 Code-Quality Gates)**: Deploys all 6 canonical roster roles (`planner`, `researcher`, `builder`, `critic`, `designer`, `merger`) to Claude Code (`~/.claude/agents/`), Antigravity (`.agents/agents/`), Kilo Code (`.kilo/agents/`), and Codex (`~/.codex/`).
4. **Shared Skills & Knowledge**: Syncs core skills (`rikkahub-orchestration`, `ai-design-workflow`, `uv-default`) and knowledge modules (`code-quality.md`).
5. **Universal MCP Server Configurations**: Sets up `Youdotcom` (active) and `googleStitch` (ready for key).
6. **Universal Orchestrator Contract**: Links `AGENTS.md`, `CONTRACT.md`, and `ORCHESTRATION.md` so **whatever agent you talk to automatically acts as the Orchestrator**.

---

## 🛡️ Code-Quality Gates v4 (7 Quality Floor Gates)

All sub-agents operate under the v4 Code-Quality Gates:
1. **Single Responsibility**: Every function does exactly one thing.
2. **Flat Logic**: Guard clauses + early returns; nesting $\le$ 3 levels.
3. **Arity**: $\le$ 3 parameters (Python $\le$ 4).
4. **Error Handling**: Explicit path at every I/O boundary; zero silent swallowing.
5. **No Hard-Coded Config / No Duplication**: Tokenized configs, shared helpers for repeated blocks.
6. **Testability & Layering**: Inject external dependencies (SOLID-DIP).
7. **Style Authority**: Strict formatter/linter rules (PEP 8, ruff, Google TS/JS style).

---

## 🏛️ Architecture & Directory Layout

```
Multi-agent-Workflow-Universal-IDE-Setup/
├── AGENTS.md                  # Durable workspace policies (uv, quality gates, design)
├── CONTRACT.md                # Multi-agent triage contract & roster rules
├── ORCHESTRATION.md            # Wave quality gating & recovery protocol
├── README.md                  # Setup & architecture guide
├── agents/                    # Canonical 6-role roster prompts (v4 quality floor)
│   ├── builder.md
│   ├── critic.md
│   ├── designer.md
│   ├── merger.md
│   ├── planner.md
│   └── researcher.md
├── knowledge/                 # Workspace knowledge modules
│   ├── code-quality.md        # Code-Quality Gates v4 reference
│   ├── design-tokens.md       # Design system token references
│   └── google-jobs-portal.md
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
- **VERIFY-BEFORE-WRITE**: Builders run QA commands before writing final `## Result` blocks.
- **SUCCEEDED ≠ Done**: Orchestrator inspects actual disk changes rather than relying on status reports.
- **Blind Critic Gate**: Independent verification against acceptance criteria; maximum 3 revision loops.
- **Zero Fluff**: No agent-to-agent chatter; coordination occurs strictly through artifacts on disk.
