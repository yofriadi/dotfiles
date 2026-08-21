---
description: Final plan review using plan-reviewer
---

Final-review the plan with `plan-reviewer` $@

**Workflow**:

1. Spawn `plan-reviewer`, async (the default), with the target scope: the change ID or `openspec/changes/<topic>` path — then end your turn; continue when the result steers back:
   - If a tandem review round just completed, append a one-paragraph summary of the findings that were raised and fixed, so the final gate can verify them.

2. Report the verdict:
   - No `blocker` findings: the plan is ready — run `/opsx-apply`.
   - Otherwise: fix the `blocker` findings, then re-spawn `plan-reviewer` for another pass. Repeat until no `blocker` findings remain, then raise leftover `warning`/`nitpick` findings for the user to decide on — do not loop on those. A verdict of Request changes with zero blockers is expected in this state: it signals outstanding warnings, not a new fix round.
