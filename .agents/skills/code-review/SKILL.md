---
name: code-review
description: Multi-axis review of a proposed code change, assessing correctness, readability, architecture, security, and performance, with the smallest concrete remediation and scope decisions escalated to the human.
disable-model-invocation: true
---

Judge the proposed changes against the objective and scope supplied by the launch prompt. Produce concise, evidence-based findings, concrete remediation (or, for a scope decision, the decision the human must make), explicit verification status, and one final verdict.

Approve a change that materially improves the codebase and meets its objective. Do not block it merely because you would have implemented it differently. Apply only the criteria relevant to the change; never manufacture checklist findings.

Use repository evidence, existing behavior, relevant tests, and project conventions to assess the changed implementation. When relevant tests exist, inspect them before judging the implementation and check whether behavior changes have behavioral regression coverage.

Evaluation criteria

- **Correctness:** Does the change meet the objective and contract? Check boundaries, empty, or invalid input, error paths, state consistency, concurrency, and regressions.
- **Readability and simplicity:** Are names, control flow, organization, comments, and abstractions clear and proportionate? Identify duplication, cleverness, dead artifacts, or complexity without a clear payoff.
- **Architecture:** Does the change follow project patterns, preserve dependency direction and module ownership, keep type/data boundaries explicit, and reduce rather than relocate complexity?
- **Security:** Are untrusted inputs and external data validated at boundaries? Check authorization, secrets, injection, output handling, and dependency trust where applicable.
- **Performance:** Check unbounded work or data, N+1 access, inappropriate synchronous work, hot-path allocations, missing pagination, and unnecessary UI updates where applicable.

Report only findings supported by a specific location and evidence. Put the impact first, then the smallest concrete fix. Use a one-line PR-comment style when practical: `path:line — impact/problem; required remediation.` Within each severity section, order findings by leverage: correctness and security first, then structural issues, then non-blocking polish.

Remediation principle (simplification first)

- An **out-of-scope remedy** expands the change's stated scope, supports a new workflow or capability, or adds machinery disproportionate to the objective.
- For structural issues, prefer the remedy that removes or simplifies rather than spreading the same complexity elsewhere — consolidate duplicate branches, delete an unnecessary layer, separate orchestration from business logic, move logic to its owning layer, reuse a canonical helper, make a boundary explicit, or extract a focused helper.
- Do not require speculative extensibility, defensive infrastructure, or peripheral hardening not demanded by the objective or repository evidence.
- If the only credible remedy is out of scope, report **Escalate:** rather than prescribing that remedy.

Use exactly one severity prefix per finding:

| Prefix | Meaning |
|---|---|
| **Escalate:** | Material issue whose only credible remedy is out of scope; the decision belongs to the human, not the implementer. |
| **Critical:** | Broken functionality, security vulnerability, data loss/corruption, unsafe behavior, or objective-blocking defect; must fix before merge; blocks approval. |
| **Required:** | Material pre-merge issue that is not Critical, such as missing behavior, material contract/architecture violation, or necessary regression coverage; must fix before merge. |
| **Optional:** | Worthwhile improvement that may be deferred without blocking the change. |
| **Nit:** | Minor style or polish issue that may be ignored. |
| **FYI:** | Informational context only; no action needed. |

For an **Escalate:** finding, state the decision required of the human, the options, and the scope consequence of each option instead of a remediation.

Severity precedence: when a finding's only credible remedy is out of scope, classify it **Escalate:** even when it also meets a Critical or Required condition, and write the prefix as **Escalate: (Critical-class)** whenever the underlying defect is unsafe, broken, security-sensitive, or data-loss-causing, so the urgency is not lost. Do not use **Escalate:** for an ordinary in-scope fix or a preferred alternative implementation; when it is genuinely ambiguous whether the remedy is out of scope, prefer **Required:** with the smallest in-scope fix.

Report what evidence exists; never infer a pass because no failure was observed:

Verification reporting

- **Tests:** `passed` or `failed` only when caller-provided evidence supports it; otherwise `not run by reviewer (read-only)`.
- **Build/type checks:** `passed` or `failed` only with supporting caller-provided evidence; otherwise `not run by reviewer (read-only)`.
- **Manual verification:** `completed` only when established through permitted read-only inspection; otherwise `not run by reviewer (read-only)`.
- **Static review:** `completed` or `not completed`.
- **Review limitations:** State anything material that could not be assessed.

Before deciding, classify every material failure to meet the objective as a finding: use **Critical:** for unsafe, broken, security-sensitive, or data-loss-causing failures, otherwise **Required:** — or **Escalate:** when the only credible remedy is out of scope.

Verdict (apply the first matching rule)

- **Escalate to human** — any unresolved **Escalate:** finding exists (scope decisions can invalidate pending corrections, so they are decided first).
- **Request changes** — the objective is not met or any unresolved Critical or Required finding remains.
- **Approve** — the objective is met and no unresolved Critical, Required, or Escalate findings remain.

If the objective or scope cannot be established, report the limitation and request the missing context; do not issue a normal approval verdict.

When a human resolves an **Escalate:** finding, the other findings remain outstanding: re-review the change against the human's decision rather than treating the verdict as final.

Report order

1. Verdict
2. Escalate
3. Critical
4. Required
5. Optional
6. Nit
7. FYI
8. Verification
9. Limitations

Write `None` for an empty findings section so its absence is explicit.
