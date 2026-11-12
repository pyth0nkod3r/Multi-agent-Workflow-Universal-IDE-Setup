<#
.SYNOPSIS
    One-shot setup script to configure Multi-Agent Dev Environment across VS Code harnesses.
.DESCRIPTION
    Installs required tooling (uv, npm CLIs), configures Antigravity / VS Code MCP endpoints, seeds
    sub-agent roles for Antigravity, Claude Code, Kilo Code, and Codex, and establishes shared workspace policies.
#>

[CmdletBinding()]
param (
    [string]$TargetWorkspace = ""
)

$ErrorActionPreference = 'Stop'

$setupRepoRoot = (Get-Item "$PSScriptRoot\..").FullName
$envRepoName = (Get-Item "$PSScriptRoot\..").Name

if ([string]::IsNullOrWhiteSpace($TargetWorkspace)) {
    if ($PWD.Path -eq $setupRepoRoot) {
        $TargetWorkspace = (Get-Item "$PSScriptRoot\..\..").FullName
    } else {
        $TargetWorkspace = $PWD.Path
    }
}

Write-Host "=== Setting up Multi-Agent Environment ===" -ForegroundColor Cyan
Write-Host "  Setup Repository : $setupRepoRoot" -ForegroundColor Gray
Write-Host "  Target Workspace : $TargetWorkspace" -ForegroundColor Gray

function Get-CleanBody([string]$text) {
    if ($text -match '(?s)^---\r?\n.*?\r?\n---\r?\n*(.*)$') {
        return $matches[1]
    }
    return $text
}

# 1. Verify Prerequisites
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Warning "Git is not installed or not in PATH. Please install Git."
} else {
    Write-Host "[1/6] Git detected: $(git --version)" -ForegroundColor Green
}

# 2. Install / Verify uv (Python policy)
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "[2/6] Installing uv (astral-sh)..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id astral-sh.uv --exact --accept-package-agreements --accept-source-agreements
    } else {
        powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    }
} else {
    Write-Host "[2/6] uv is verified: $(uv --version)" -ForegroundColor Green
}

# 3. Verify Node.js and Global Tools
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "[3/6] Checking global CLI utilities (firecrawl-cli, @pen.dev/cli)..." -ForegroundColor Yellow
    try {
        if (-not (Get-Command firecrawl -ErrorAction SilentlyContinue) -or -not (Get-Command pen -ErrorAction SilentlyContinue)) {
            npm install --global firecrawl-cli '@pen.dev/cli' --silent
        }
        Write-Host "  Global CLI tools verified." -ForegroundColor Green
    } catch {
        Write-Warning "Could not install optional global npm tools. You may install them manually."
    }
} else {
    Write-Warning "Node.js/npm not found. Please install Node.js 20+ to enable Firecrawl & Pen CLI."
}

# 4. Configure Claude Code Global Environment (~/.claude)
$claudeAgentsDir = "$env:USERPROFILE\.claude\agents"
$claudeSkillsDir = "$env:USERPROFILE\.claude\skills"
New-Item -ItemType Directory -Force -Path $claudeAgentsDir, $claudeSkillsDir | Out-Null

$envAgentsDir = "$setupRepoRoot\agents"
$roles = @("planner", "researcher", "builder", "critic", "designer", "merger")

foreach ($r in $roles) {
    $src = Join-Path $envAgentsDir "$r.md"
    if (Test-Path $src) {
        $raw = Get-Content -Raw $src
        $cleanBody = Get-CleanBody $raw
        $claudeTarget = Join-Path $claudeAgentsDir "$r.md"
        $claudeModel = "inherit"
        if (Test-Path $claudeTarget) {
            $existing = Get-Content -Raw $claudeTarget
            if ($existing -match '(?m)^model:\s*(.+)$') {
                $claudeModel = $matches[1].Trim()
            }
        }
        $claudeContent = @"
---
name: $r
description: RikkaHub-compatible $r role for structured multi-agent work.
model: $claudeModel
---

$cleanBody
"@
        Set-Content -Path $claudeTarget -Value $claudeContent -Force
    }
}

$srcSkills = "$setupRepoRoot\skills"
if (Test-Path $srcSkills) {
    Copy-Item -Recurse -Force "$srcSkills\*" $claudeSkillsDir
}
Write-Host "[4/6] Claude Code sub-agent roster & skills synced to ~/.claude." -ForegroundColor Green

# 5. Configure Codex Environment (~/.codex)
$codexSkillsDir = "$env:USERPROFILE\.codex\skills"
New-Item -ItemType Directory -Force -Path $codexSkillsDir | Out-Null
if (Test-Path $srcSkills) {
    Copy-Item -Recurse -Force "$srcSkills\*" $codexSkillsDir
    Write-Host "  Shared skills synced to Codex ($codexSkillsDir)." -ForegroundColor Green
}

# 6. Global Antigravity configuration (~/.gemini/config)
$globalGeminiConfig = "$env:USERPROFILE\.gemini\config"
if (Test-Path $globalGeminiConfig) {
    $globalSkillsJson = Join-Path $globalGeminiConfig "skills.json"
    $skillsPath = (Join-Path $setupRepoRoot "skills").Replace('\', '/')
    $skillsConfigContent = @"
{
  "entries": [
    {
      "path": "$skillsPath"
    }
  ]
}
"@
    Set-Content -Path $globalSkillsJson -Value $skillsConfigContent -Force

    $globalPluginsJson = Join-Path $globalGeminiConfig "plugins.json"
    $pluginPath = $setupRepoRoot.Replace('\', '/')
    $pluginsConfigContent = @"
{
  "entries": [
    {
      "path": "$pluginPath"
    }
  ]
}
"@
    Set-Content -Path $globalPluginsJson -Value $pluginsConfigContent -Force

    Write-Host "  Antigravity global plugin & skills registered in ~/.gemini/config." -ForegroundColor Green
}

# 7. Configure Target Workspace (Antigravity, Kilo Code, VS Code, Copilot)
Write-Host "[5/6] Configuring workspace adapters in: $TargetWorkspace..." -ForegroundColor Yellow

$dotAgents = Join-Path $TargetWorkspace ".agents"
$dotAgentsAgents = Join-Path $dotAgents "agents"
$dotAgentsRules = Join-Path $dotAgents "rules"
$dotAgentsSkills = Join-Path $dotAgents "skills"
$dotKilo = Join-Path $TargetWorkspace ".kilo\agents"
$dotVscode = Join-Path $TargetWorkspace ".vscode"
$tasksDir = Join-Path $TargetWorkspace "tasks"
$runsDir = Join-Path $TargetWorkspace "runs"

New-Item -ItemType Directory -Force -Path $dotAgentsAgents, $dotAgentsRules, $dotAgentsSkills, $dotKilo, $dotVscode, $tasksDir, $runsDir | Out-Null

# Antigravity agents in workspace
foreach ($r in $roles) {
    $src = Join-Path $envAgentsDir "$r.md"
    if (Test-Path $src) {
        $raw = Get-Content -Raw $src
        $cleanBody = Get-CleanBody $raw
        $antigravityTarget = Join-Path $dotAgentsAgents "$r.md"
        $antigravityModel = "inherit"
        if (Test-Path $antigravityTarget) {
            $existing = Get-Content -Raw $antigravityTarget
            if ($existing -match '(?m)^model:\s*(.+)$') {
                $antigravityModel = $matches[1].Trim()
            }
        }
        $antigravityContent = @"
---
name: $r
description: RikkaHub-compatible $r role for structured multi-agent work.
subagent: true
mainAgent: false
model: $antigravityModel
commandExecutionPolicy: sandbox
tools: [read_file, edit_file, write_file, run_command, manage_task, search_web]
---

$cleanBody
"@
        Set-Content -Path $antigravityTarget -Value $antigravityContent -Force
    }
}

# Antigravity rules & skills in workspace
$ruleFile = Join-Path $dotAgentsRules "rikkahub-environment.md"
Set-Content -Path $ruleFile -Value @"
# RikkaHub-compatible environment

Read AGENTS.md, CONTRACT.md, and ORCHESTRATION.md as the common workspace policy.
For multi-unit work, dispatch the planner, researcher, builder, critic, designer, and merger definitions.
"@ -Force

if (Test-Path $srcSkills) {
    Copy-Item -Recurse -Force "$srcSkills\*" $dotAgentsSkills
}

$antigravityMcp = Join-Path $dotAgents "mcp_config.json"
if (-not (Test-Path $antigravityMcp)) {
    Set-Content -Path $antigravityMcp -Value @"
{
  "mcpServers": {
    "youdotcom": {
      "serverUrl": "https://api.you.com/mcp"
    },
    "googleStitch": {
      "serverUrl": "https://stitch.googleapis.com/mcp",
      "disabled": true,
      "headers": {
        "X-Goog-Api-Key": "REPLACE_WITH_A_FRESH_KEY"
      }
    },
    "21stdev": {
      "serverUrl": "https://21st.dev/api/mcp",
      "disabled": true,
      "headers": {
        "x-api-key": "REPLACE_WITH_21ST_KEY"
      }
    },
    "penpot": {
      "serverUrl": "https://design.penpot.app/mcp/stream?userToken=PASTE_FRESH_TOKEN_FROM_PENPOT",
      "disabled": true
    }
  }
}
"@ -Force
}

# Kilo Code agents
foreach ($r in $roles) {
    $src = Join-Path $envAgentsDir "$r.md"
    if (Test-Path $src) {
        $raw = Get-Content -Raw $src
        $cleanBody = Get-CleanBody $raw
        $kiloContent = @"
---
mode: subagent
description: RikkaHub $r role.
options:
  displayName: $($r.Substring(0,1).ToUpper() + $r.Substring(1))
  id: $r
---

$cleanBody
"@
        Set-Content -Path (Join-Path $dotKilo "$r.md") -Value $kiloContent -Force
    }
}

# Sync root protocol docs (CONTRACT.md, ORCHESTRATION.md, ORCHESTRATOR.md)
$docsToSync = @("CONTRACT.md", "ORCHESTRATION.md", "ORCHESTRATOR.md")
foreach ($doc in $docsToSync) {
    $srcDoc = Join-Path $setupRepoRoot $doc
    if (Test-Path $srcDoc) {
        $targetDoc = Join-Path $TargetWorkspace $doc
        Copy-Item -Force $srcDoc $targetDoc
    }
}

# Safely handle AGENTS.md: NEVER clobber existing instructions
$targetAgentsMd = Join-Path $TargetWorkspace "AGENTS.md"
$srcAgentsMd = Join-Path $setupRepoRoot "AGENTS.md"
if (Test-Path $targetAgentsMd) {
    $existingAgentsContent = Get-Content -Raw $targetAgentsMd
    if ($existingAgentsContent -notmatch 'Universal Orchestrator|RikkaHub-compatible') {
        $policyAppend = @'


## Multi-Agent Universal Orchestrator Protocol
Any active agent functions as the Universal Orchestrator.
- Triage before tokens: small (solo), medium (solo + cold critic pass), large (full protocol: planner -> fan-out -> critic -> merger).
- Follow CONTRACT.md, ORCHESTRATION.md, and Code-Quality Gates v4 in knowledge/code-quality.md.
- Follow Python policy: enforce `uv` (`uv init`, `uv add`, `uv run`).
- Follow UI/Design policy: use `ai-design-workflow` skill for visual/UI tasks.
- Keep commits orchestrator-only and tagged with `[run <runid>]`.
'@
        Add-Content -Path $targetAgentsMd -Value $policyAppend
        Write-Host "  Appended Multi-Agent protocol to existing AGENTS.md." -ForegroundColor Green
    } else {
        Write-Host "  Existing AGENTS.md already contains Multi-Agent protocol." -ForegroundColor Green
    }
} else {
    Copy-Item -Force $srcAgentsMd $targetAgentsMd
    Write-Host "  Copied AGENTS.md to target workspace." -ForegroundColor Green
}

# Sync knowledge base
$srcKnowledge = Join-Path $setupRepoRoot "knowledge"
if (Test-Path $srcKnowledge) {
    $targetKnowledge = Join-Path $TargetWorkspace "knowledge"
    New-Item -ItemType Directory -Force -Path $targetKnowledge | Out-Null
    Copy-Item -Recurse -Force "$srcKnowledge\*" $targetKnowledge
    Write-Host "  Knowledge tree synced to $targetKnowledge." -ForegroundColor Green
}

# Sync .mcp.json if not present
$rootMcpTarget = Join-Path $TargetWorkspace ".mcp.json"
if (-not (Test-Path $rootMcpTarget)) {
    Set-Content -Path $rootMcpTarget -Value @"
{
  "mcpServers": {
    "youdotcom": {
      "type": "http",
      "url": "https://api.you.com/mcp"
    },
    "googleStitch": {
      "type": "http",
      "url": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "`${GOOGLE_STITCH_API_KEY}"
      }
    },
    "21stdev": {
      "type": "http",
      "url": "https://21st.dev/api/mcp",
      "headers": {
        "x-api-key": "`${TWENTYFIRST_API_KEY}"
      }
    },
    "penpot": {
      "type": "http",
      "url": "https://design.penpot.app/mcp/stream?userToken=PASTE_FRESH_TOKEN_FROM_PENPOT"
    }
  }
}
"@ -Force
}

Write-Host "[6/6] Environment setup successfully completed!" -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "Multi-Agent Workflow is configured globally and for target workspace." -ForegroundColor Cyan
Write-Host "Harnesses: Antigravity IDE, Claude Code, GitHub Copilot, Codex, Kilo Code." -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor Cyan
