<#
.SYNOPSIS
    One-shot setup script to configure RikkaHub Multi-Agent Dev Environment across VS Code harnesses.
.DESCRIPTION
    Installs required tooling (uv, npm CLIs), configures VS Code MCP endpoints, seeds sub-agent roles
    for Antigravity, Claude Code, Kilo Code, and Codex, and establishes shared workspace policies.
#>

[CmdletBinding()]
param (
    [string]$TargetWorkspace = (Get-Item "$PSScriptRoot\..\..").FullName
)

$ErrorActionPreference = 'Stop'
Write-Host "=== Setting up RikkaHub Multi-Agent Environment on: $TargetWorkspace ===" -ForegroundColor Cyan

# 1. Verify Prerequisites
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Warning "Git is not installed or not in PATH. Please install Git."
}

# 2. Install / Verify uv (Python policy)
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "[1/6] Installing uv (astral-sh)..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id astral-sh.uv --exact --accept-package-agreements --accept-source-agreements
    } else {
        powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    }
} else {
    Write-Host "[1/6] uv is already installed: $(uv --version)" -ForegroundColor Green
}

# 3. Verify Node.js and Global Tools
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "[2/6] Node & npm detected. Checking global utilities..." -ForegroundColor Yellow
    # Optional tools
    try {
        npm install --global firecrawl-cli '@pen.dev/cli' --silent
        Write-Host "Installed/Updated firecrawl-cli and @pen.dev/cli." -ForegroundColor Green
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

$envAgentsDir = "$PSScriptRoot\..\agents"
$roles = @("planner", "researcher", "builder", "critic", "designer", "merger")

foreach ($r in $roles) {
    $src = Join-Path $envAgentsDir "$r.md"
    if (Test-Path $src) {
        $body = Get-Content -Raw $src
        $claudeContent = @"
---
name: $r
description: RikkaHub-compatible $r role for structured multi-agent work.
model: inherit
---

$body
"@
        Set-Content -Path (Join-Path $claudeAgentsDir "$r.md") -Value $claudeContent -Force
    }
}
Write-Host "[3/6] Claude Code sub-agent roster synced to $claudeAgentsDir." -ForegroundColor Green

# 5. Configure Codex Environment (~/.codex)
$codexSkillsDir = "$env:USERPROFILE\.codex\skills"
New-Item -ItemType Directory -Force -Path $codexSkillsDir | Out-Null
$srcSkills = "$PSScriptRoot\..\skills"
if (Test-Path $srcSkills) {
    Copy-Item -Recurse -Force "$srcSkills\*" $codexSkillsDir
    Write-Host "[4/6] Shared skills synced to Codex ($codexSkillsDir)." -ForegroundColor Green
}

# 6. Configure Workspace Adapters in TargetWorkspace (Antigravity, Kilo Code, VS Code, Copilot)
Write-Host "[5/6] Verifying workspace adapters in $TargetWorkspace..." -ForegroundColor Yellow

$dotAgents = Join-Path $TargetWorkspace ".agents"
$dotAgentsAgents = Join-Path $dotAgents "agents"
$dotAgentsRules = Join-Path $dotAgents "rules"
$dotAgentsSkills = Join-Path $dotAgents "skills"
$dotKilo = Join-Path $TargetWorkspace ".kilo\agents"
$dotVscode = Join-Path $TargetWorkspace ".vscode"

New-Item -ItemType Directory -Force -Path $dotAgentsAgents, $dotAgentsRules, $dotAgentsSkills, $dotKilo, $dotVscode | Out-Null

# Antigravity agents
foreach ($r in $roles) {
    $src = Join-Path $envAgentsDir "$r.md"
    if (Test-Path $src) {
        $body = Get-Content -Raw $src
        $antigravityContent = @"
---
name: $r
description: RikkaHub-compatible $r role for structured multi-agent work.
subagent: true
mainAgent: false
model: inherit
commandExecutionPolicy: sandbox
---

$body
"@
        Set-Content -Path (Join-Path $dotAgentsAgents "$r.md") -Value $antigravityContent -Force
    }
}

# Antigravity rules & skills & mcp
$ruleFile = Join-Path $dotAgentsRules "rikkahub-environment.md"
Set-Content -Path $ruleFile -Value @"
# RikkaHub-compatible environment

Read `rikkahub-codex-environment/AGENTS.md` and follow it as the common workspace policy. For multi-unit work, use the planner, researcher, builder, critic, designer, and merger definitions in `rikkahub-codex-environment/agents/`.
"@ -Force

if (Test-Path $srcSkills) {
    Copy-Item -Recurse -Force "$srcSkills\*" $dotAgentsSkills
}

$antigravityMcp = Join-Path $dotAgents "mcp_config.json"
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
    }
  }
}
"@ -Force

# Kilo Code agents
foreach ($r in $roles) {
    $src = Join-Path $envAgentsDir "$r.md"
    if (Test-Path $src) {
        $body = Get-Content -Raw $src
        $kiloContent = @"
---
mode: subagent
description: RikkaHub $r role.
options:
  displayName: $($r.Substring(0,1).ToUpper() + $r.Substring(1))
  id: $r
---

$body
"@
        Set-Content -Path (Join-Path $dotKilo "$r.md") -Value $kiloContent -Force
    }
}

# Ensure root AGENTS.md, CLAUDE.md, and .mcp.json exist
$rootAgentsSrc = "$PSScriptRoot\..\AGENTS.md"
if (Test-Path $rootAgentsSrc) {
    $rootAgentsTarget = Join-Path $TargetWorkspace "AGENTS.md"
    if (-not (Test-Path $rootAgentsTarget)) {
        Copy-Item -Force $rootAgentsSrc $rootAgentsTarget
    }
}

$rootClaudeTarget = Join-Path $TargetWorkspace "CLAUDE.md"
if (-not (Test-Path $rootClaudeTarget)) {
    Set-Content -Path $rootClaudeTarget -Value @"
# Shared development environment

Follow the durable, project-independent policy in `rikkahub-codex-environment/AGENTS.md`. Use the six role definitions in `rikkahub-codex-environment/agents/` for complex, parallel work. Do not apply project-specific product rules unless they are present in that project's own instructions.
"@ -Force
}

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
    }
  }
}
"@ -Force
}

Write-Host "[6/6] Environment setup successfully completed!" -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "Any agent harness (Antigravity, Claude Code, Copilot, Codex, Kilo) is now" -ForegroundColor Cyan
Write-Host "configured as the Universal Orchestrator with full sub-agent dispatching." -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor Cyan
