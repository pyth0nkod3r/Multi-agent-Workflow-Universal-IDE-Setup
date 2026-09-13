---
name: uv-default
description: Use uv as the default Python project and script workflow.
---

# uv-first Python policy

Use `uv init` for a Python project, `uv add` for dependencies, and `uv run` to execute Python or project commands. For standalone scripts, initialize and manage script dependencies through `uv`. Do not use bare `pip` or bare `python` unless explicitly required by the user or an existing tool's documented interface.

