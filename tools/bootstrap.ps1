# Run manually in an elevated PowerShell only after reviewing package policies.
# This script deliberately does not configure credentials or edit Codex configuration.

$ErrorActionPreference = 'Stop'

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    winget install --id astral-sh.uv --exact --accept-package-agreements --accept-source-agreements
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw 'Node.js/npm is required. Install Node.js 20+ first, then run this script again.'
}

npm install --global firecrawl-cli
npm install --global '@pen.dev/cli'

uv --version
firecrawl --version
pen --version
