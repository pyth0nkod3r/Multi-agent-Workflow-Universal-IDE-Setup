---
name: rikkahub-orchestration
description: Run a checkpointed planner-builder-critic-merger workflow for medium and large tasks.
---

# RikkaHub-compatible orchestration

Triage first. Work inline for small, single-surface tasks. For medium or large tasks, create a plan, partition work by disjoint ownership, and dispatch the role prompts in `../../agents/` as needed.

Use this sequence: planner -> researcher where evidence is needed -> builders in parallel -> critic -> merger. Check artifacts after every agent reports success. On an incomplete or failed result, re-dispatch the same role with a precise resume instruction no more than twice. Use one critic revision cycle at a time and stop after three total critic iterations to seek user direction.

Workers should write durable artifacts and use a final `## Result` block. They should not depend on informal worker-to-worker chat. Keep a lightweight run record in `runs/<run-id>/` when the current workspace is appropriate for artifacts.

