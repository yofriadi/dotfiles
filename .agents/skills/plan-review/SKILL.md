---
name: plan-review
description: Reviews a proposed implementation plan against its objective, constraints, non-goals, assumptions, and repository evidence.
disable-model-invocation: true
---

Stress-test proposed implementation plans adversarially before implementation. Treat the plan and its supporting planning materials as the source of truth for the objective, constraints, non-goals, assumptions, decisions, and verification contract.

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
- **Assumption validity** — assumptions are visible and do not conceal blockers.
- **Deferred-decision safety** — deferred decisions are genuinely non-blocking or have a clear decision point and owner; they do not force the implementer to invent architecture.
- **Task concreteness** — another strong engineer can execute without guessing.
- **Feasibility and ordering** — prerequisites, dependencies, sequencing, affected interfaces, and repository capabilities make the plan executable.
- **Scope sizing** — the plan and its steps are sensibly bounded.
- **Internal consistency** — headings, paths, IDs, references, and terms agree across the plan and supporting materials.
- **Placeholder/contradiction check** — no unresolved placeholders or impossible promises remain.

Apply only relevant criteria. A clear plan may express an axis anywhere in the plan or supporting materials; it does not need a dedicated section for every axis.

Each finding must use exactly one severity, identify the affected plan section, work item, supporting material, or repository location, explain the impact, cite supporting evidence when applicable, and state the smallest concrete plan correction. Use a one-line format when practical: `plan section or work item — impact; smallest correction.` Do not manufacture findings for criteria that are irrelevant to the change.

Specialized severity
- **blocker** — the objective cannot be achieved; a hard constraint or non-goal is violated; required planning material or necessary context is missing; the plan is materially contradictory, infeasible, or unsafe; the verification contract is impossible to satisfy under current repository constraints; or proceeding would create unacceptable risk.
- **warning** — an important quality, clarity, feasibility, or verification issue that does not prevent proceeding.
- **nitpick** — optional polish.

Verdict
- **Approve** only when the objective is met and no unresolved blocker or warning findings remain.
- **Request changes** when the objective is not met or any unresolved blocker or warning finding remains.

Approve a plan that achieves the objective, respects constraints, and is executable. Do not block a plan merely because a different valid design would be preferable.

If the target plan cannot be established (no change named and multiple candidates exist), report the limitation and request the missing context; do not issue a normal approval verdict.

Report order
1. Verdict
2. blocker
3. warning
4. nitpick
5. Review limitations

Write `None` for an empty findings section so its absence is explicit.
