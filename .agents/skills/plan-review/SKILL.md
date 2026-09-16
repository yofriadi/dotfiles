---
name: plan-review
description: Reviews a proposed implementation plan against its objective, constraints, non-goals, assumptions, and repository evidence, preferring the simplest in-scope correction and escalating scope decisions to the human.
disable-model-invocation: true
---

Stress-test proposed implementation plans adversarially before implementation without inducing scope creep or over-engineering. Treat the plan and its supporting planning materials as the source of truth for the objective, constraints, non-goals, assumptions, decisions, and verification contract.

Axes

- `objective` — what the plan must achieve.
- `constraints` — hard limits.
- `non-goals` — explicitly excluded work.
- `assumptions` — assumptions supporting the plan.
- `deferred` — open or deliberately deferred decisions.
- `findings` — relevant repository evidence discovered during exploration or review.

Review the complete proposed plan and the supporting planning materials. Establish the objective, hard constraints, non-goals, assumptions, decisions, deferred decisions, feasibility context, and verification contract before judging the plan.

Repository-grounded protocol

1. Identify the plan and all supporting materials needed to judge it before drawing conclusions.
2. Read the complete plan and relevant supporting materials before judging the plan.
3. Trace material paths, symbols, APIs, tests, dependencies, and conventions referenced by the plan to repository evidence.
4. Prefer repository-local evidence. Use external sources only when a material claim depends on versioned API behavior, dependency behavior, or another fact the repository cannot establish.
5. Distinguish confirmed repository facts from plan assumptions, unresolved questions, and reviewer inferences.
6. Report only issues that affect objective alignment, constraints, scope, execution, correctness, safety, or verification.
7. Cite the affected plan section, supporting material, or repository location for each material claim, and stop once all material findings are supported; do not survey unrelated code.

Rubric

- **Objective alignment** — the plan and its work items achieve the objective.
- **Constraint respect** — hard limits and selected APIs are respected.
- **Non-goal leakage** — excluded work does not re-enter.
- **Simplification over machinery** — prefer the simplest approach that still satisfies the objective, hard constraints, and verification contract. Raise removable machinery — a layer, abstraction, fallback, configuration path, or extension point the plan can drop without violating those — as a `warning` only when keeping it creates material risk or cost; otherwise a `nitpick`.
- **Assumption validity** — assumptions are visible and do not conceal blockers.
- **Deferred-decision safety** — deferred decisions are genuinely non-blocking or have a clear decision point and owner; they do not force the implementer to invent architecture.
- **Task concreteness** — another strong engineer can execute without guessing.
- **Feasibility and ordering** — prerequisites, dependencies, sequencing, affected interfaces, and repository capabilities make the plan executable.
- **Scope sizing** — the plan and its steps are sensibly bounded.
- **Internal consistency** — headings, paths, IDs, references, and terms agree across the plan and supporting materials.
- **Placeholder/contradiction check** — no unresolved placeholders or impossible promises remain.

Apply only relevant criteria. A clear plan may express an axis anywhere in the plan or supporting materials; it does not need a dedicated section for every axis.

Correction principle (simplification first)

- An **out-of-scope correction** expands the stated objective, changes a constraint or non-goal, supports a new workflow or capability, or adds machinery disproportionate to the objective.
- Prefer an in-scope simplification — narrowing supported inputs, removing an unnecessary step, clarifying a boundary, or dropping a brittle assumption — before proposing new machinery.
- Do not require speculative extensibility, peripheral edge-case handling, or defensive infrastructure not required by the objective, constraints, or verification contract.
- If the only credible correction is out of scope, report an `escalation` rather than inventing that solution.

Each finding must use exactly one severity, identify the affected plan section, work item, supporting material, or repository location, explain the impact, cite supporting evidence when applicable, and state the smallest concrete plan correction; for an `escalation`, state instead the decision required of the human, the options, and the scope consequence of each. Use a one-line format when practical: `plan section or work item — impact; smallest correction.` Do not manufacture findings for criteria that are irrelevant to the change.

Specialized severity

- **Escalation** — a material issue whose only credible correction is out of scope; that decision belongs to the human, not the implementer. Do not use it for an ordinary in-scope implementation choice or a preferred alternative design.
- **Blocker** — the plan cannot achieve the objective; a hard constraint or non-goal is violated; required planning material or necessary context is missing; the plan is materially contradictory, infeasible, or unsafe; the verification contract is impossible to satisfy under current repository constraints; or proceeding would create unacceptable risk.
- **Warning** — an important quality, clarity, feasibility, or verification issue within the existing scope that does not prevent proceeding.
- **Nitpick** — optional polish, or a non-blocking observation outside the current scope.

Severity precedence: when a finding's only credible correction is out of scope, classify it `escalation` even when it also meets a `blocker` condition, and write it as `escalation (blocker-class)` whenever the plan cannot achieve the objective as stated, so the urgency is not lost. When it is genuinely ambiguous whether the correction is out of scope, use `blocker` with the smallest in-scope correction.

Verdict (apply the first matching rule)

- **Escalate to human** — any unresolved `escalation` finding exists (scope decisions can invalidate pending corrections, so they are decided first).
- **Request changes** — the objective is not met, or any unresolved blocker or warning finding remains.
- **Approve** — the objective is met and no unresolved blocker, escalation, or warning findings remain.

Approve a plan that achieves the objective, respects constraints, and is executable. Do not block a plan merely because a different valid design would be preferable.

`Request changes` with zero blockers is a valid terminal state: it signals outstanding warnings for the human to decide on, not another fix round.

When a human resolves an `escalation`, the other findings remain outstanding: re-review the plan against the human's decision before re-judging it, rather than treating the verdict as final.

If the target plan cannot be established (no change named and multiple candidates exist), report the limitation and request the missing context; do not issue a normal approval verdict.

Report order

1. verdict
2. escalation
3. blocker
4. warning
5. nitpick
6. limitations

Write `None` for an empty findings section so its absence is explicit.
