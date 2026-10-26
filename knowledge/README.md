# knowledge/ — index

Durable, reusable findings written by `researcher` agents. One topic per file.
Later runs reference files here instead of re-researching.

| File | Topic | Written |
|---|---|---|
| design-tokens.md | Design tokens, DESIGN.md format, design-to-code model (obimadu blog distill + tool facts); pipeline = ai-design-workflow skill | 2026-09-11 |
| code-quality.md | Quality gates v4 (builder floor, critic tags, planner QUALITY section, QA commands, thresholds) — user-adopted 2026-09-14; rationale: ../proposals/20260914-code-quality-plan.md. Now 14 gates: 8 zero-day audit, 9 SEC, 10 git-provenance, 11-14 cache/idempotency/unicode/versioning (adopted 2026-10-26) | 2026-09-14 |
| design-resources.md | Design tooling/resource links (companion to design-tokens) | 2026-09 |
| security-resources.md | Security research/tooling links; checklists in security-checklists/ | 2026-09 |
| security-checklists/ | Per-area critic checklists (api, auth, business-logic, code-review, mobile-apk-release, frontend-security) — see code-quality.md | 2026-09 |
| academic-bias-detection.md | Bias/fingerprinting detection research (anti-evasion gap source) | 2026-10 |
| academic-job-matching.md | Academic job-matching landscape findings | 2026-10 |
| applykit-careerops-llm.md | ApplyKit/CareerOps LLM integration patterns intel | 2026-10 |
| llm-integration-kotlin-agents.md | LLM integration patterns for Kotlin agents | 2026-10 |
| llm-providers.md | LLM provider registry (models, limits, pricing notes) | 2026-10 |
| tidal-memory-verdict.md | Tidal-memory evaluation verdict | 2026-10 |
| wa-bot-landscape.md | WhatsApp bot landscape research (runs/wa-bot-research) | 2026-10 |
| google-jobs-portal.md | Google Jobs portal scraping facts | — |
| testgorilla-upskill.md | TestGorilla upskill notes | — |
| research-doctrine.md | Research pipeline doctrine v1.0 (scoping → no-anchoring dispatch → escalation ladder → per-claim ADOPT/VERIFY/REJECT → artifacts → absorption) + academic/non-academic source maps — user-adopted 2026-10-24 | 2026-10-24 |
| security-adoptions.md | Security standing doctrine v1.0: gate 8 zero-day audit, gate 9 SEC (critic-as-security-agent), knowledge base + checklists inventory, offensive-material rule, CI trio (gitleaks/trivy/dependabot), secrets discipline, agent-surface hardening | 2026-10-24 |
| git-github-adoptions.md | Git & GitHub standing doctrine v1.0: repo conventions (private-default, gh CLI, AGENTS.md, path rule), GIT-HYGIENE write protocol (no blind pull, fetch→drift→re-read→commit→push→verify), [run <id>] marker hook, parallel-session playbook, destructive-op rules, doctrine sync flow | 2026-10-24 |
| docs-precision-postmortems.md | Doc precision rules (trigger→timing→actor→consequence; banned vague words; kill phantom mechanisms) + mandatory 7-section postmortem template ("a new engineer could verify the fix from the document alone") — adopted 2026-10-26 | 2026-10-26 |
| rikkahub-desktop-windows-setup.md | Harness setup variant for RikkaHub Agent Desktop on Windows: doctrine repos + workspace overlay, search keys (.secrets/providers.env, SERPER not SerpAPI), MCP = streamable_http/sse only → supergateway bridge for stdio servers (Repomix worked example: port 8809, app-API registration, disk verification), tool remap table, CI-trio replication | 2026-10-24 |
