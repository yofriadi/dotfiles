---
description: Run tandem code review using code-reviewer-1 and code-reviewer-2
---

Tandem-review the code changes with `code-reviewer-1` and `code-reviewer-2` $@

**Workflow**:

1. Spawn both reviewers in the same turn, async (the default), with the exact same task — then end your turn; synthesize once both results steer back:
   - The task carries scope only: which changes to review (diff range, staged changes, commit, or branch). Each reviewer has its own prompt and skills; do not instruct them how to review.
   - Never retry a failed spawn; let the user resume it manually. Spawning a fresh round after fixes (step 2) is a re-review, not a retry.

2. Synthesize: compare what each model caught and missed; verify findings against the diff/code and discard unsupported claims. Fix all remaining issues, then re-spawn both reviewers; repeat (re-review, fix) until no `Critical` or `Required` findings remain, then raise any unsupported claims and leftover `Optional`/`Nit` findings for the user to decide on (report `FYI` items for context; they need no decision) — do not loop on those.
