---
name: subagent-herdr
description: Spawn a subagent in a herdr surface (pane or tab). Use when need to offload research, open-ended exploration, documentation lookups, and broad investigations to subagents.
disable-model-invocation: true
---

- Async (default): returns immediately; the result is steered back when the child finishes. `blocking: true` awaits the final text as the tool result (no steer).
- Label convention: [<agent-id>] <topic> for the session/pane name, e.g. subagent({ agent: "deep-researcher", label: "[deep-researcher] Rust Edition", task: "…" }).
- Subagents run with their own toolsets and permissions (defined in their frontmatter) — do not assume they share the main session's tools.
