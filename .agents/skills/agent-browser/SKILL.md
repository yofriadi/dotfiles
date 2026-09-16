---
name: agent-browser
description: Browse websites, read live docs, click and fill pages, extract browser content, take screenshots, and automate real web workflows.
---

- For agent_browser docs/commands on failure, inspect github.com/fitchmultz/pi-agent-browser-native (docs/COMMAND_REFERENCE.md, docs/TOOL_CONTRACT.md). Do not load full docs wholesale.
- Use exactly one mode per call: args, script, semanticAction, job, qa, sourceLookup, networkSourceLookup, or electron. stdin is for batch/eval/auth only (electron rejects it); never pass --json.
- Loop: open → snapshot -i → act on @refs → re-snapshot after changes. Batch same-snapshot form fills. Require explicit confirmation before irreversible actions (purchases, deletions, prod mutations, account/security changes).
- Use sessionMode=fresh for launch flags (never pass --session-mode in args). Use configured profiles; run profiles/doctor on failure. Request user-assisted headed login if MFA/auth is required.
- Save artifacts to exact requested paths; verify artifactVerification/artifacts before claiming success. Close keeps files; record stop requires ffmpeg; waited:timeout does not prove state completion.
- When details.nextActions exists, use its exact payload. In dense snapshots, use targeted selectors if controls are omitted. Verify scroll with a re-snapshot or screenshot.
- Quick getters: read <url>, get title/url, get text/html/value/count <selector>, get attr <selector> <name>. Batch 3+ getters; heed visibility warnings.
