---
description: Run tandem plan review using plan-reviewer-1 and plan-reviewer-2
---

Tandem-review the plan with `plan-reviewer-1` and `plan-reviewer-2` $@

**Workflow**:

1. Spawn both reviewers in the same turn, async (the default), with the exact same task — then end your turn; synthesize once both results steer back:
   - The task carries scope only: the target change ID or `openspec/changes/<topic>` path. Each reviewer has its own prompt and skills; do not instruct them how to review.
   - Never retry a failed spawn; let the user resume it manually. Spawning a fresh round after fixes (step 2) is a re-review, not a retry.

2. Synthesize: compare what each model caught and missed; verify findings against repository evidence and discard unsupported claims. Fix all remaining issues, then re-spawn both reviewers; repeat (re-review, fix) until no `blocker` findings remain, then raise any unsupported claims and leftover `warning`/`nitpick` findings for the user to decide on — do not loop on those. A reviewer verdict of Request changes with zero blockers is expected in this state: it signals outstanding warnings, not a new fix round.
