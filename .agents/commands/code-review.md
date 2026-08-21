---
description: Final code review using code-reviewer
---

Final-review the code changes with `code-reviewer` $@

**Workflow**:

1. Spawn `code-reviewer`, async (the default), with the scope: which changes to review (diff range, staged changes, commit, or branch) — then end your turn; continue when the result steers back:
   - If a tandem review round just completed, append a one-paragraph summary of the findings that were raised and fixed, so the final gate can verify them.

2. Report the verdict:
   - No `Critical` or `Required` findings: ready — run `/opsx-archive`.
   - Otherwise: fix them, then re-spawn `code-reviewer` for another pass. Repeat until no `Critical` or `Required` findings remain, then raise leftover `Optional`/`Nit` findings for the user to decide on (report `FYI` items for context; they need no decision) — do not loop on those.
