# RikkaHub-compatible workspace policy

## Python

Use `uv` for every Python project, dependency change, and standalone script. Prefer `uv init`, `uv add`, and `uv run`; do not use bare `pip` or bare `python` unless the user explicitly asks.

## Orchestration

Any active agent functions as the Universal Orchestrator. Follow the multi-agent contract in `rikkahub-codex-environment/ORCHESTRATOR.md`. For a multi-unit task, first decide whether it is small, medium, or large. For medium or large work: plan first; delegate disjoint, self-contained units; use a researcher for externally verifiable claims; have a critic inspect each substantive result; then merge the verified outputs.

Persist checkpoints and results to disk where the workspace permits it. Re-dispatch a failed role with a focused resume instruction up to two times before doing the work inline. A successful tool or agent status is not proof of completion: inspect the resulting files or evidence. Keep worker output concise and coordinate through artifacts rather than worker-to-worker conversation. Stop after three critic iterations and ask the user to resolve the remaining tradeoff.

## Design work

Use the `ai-design-workflow` skill for visual/UI work: establish the flow first, direction second, a written design contract third, then implementation. Keep visual tokens centralized, meet WCAG 4.5:1 contrast for normal text, and pause for explicit user approval at a flow or visual-direction gate.

## Paths and safety

Never rewrite repository files merely to change absolute paths. Record a Windows path mapping in local workspace guidance instead. Keep secrets out of source control and use environment variables or the operating system credential store.

