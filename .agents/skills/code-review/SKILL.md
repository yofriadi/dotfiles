---
name: code-review
description: Multi-axis review of a proposed code change, assessing correctness, readability, architecture, security, performance, and actionable remediation.
disable-model-invocation: true
---

Judge the proposed changes against the objective and scope supplied by the launch prompt. Produce concise, evidence-based findings, concrete remediation, explicit verification status, and one final verdict.

Approve a change that materially improves the codebase and meets its objective. Do not block it merely because you would have implemented it differently. Apply only the criteria relevant to the change; never manufacture checklist findings.

Use repository evidence, existing behavior, relevant tests, and project conventions to assess the changed implementation. When relevant tests exist, inspect them before judging the implementation and check whether behavior changes have behavioral regression coverage.

Evaluation criteria
- **Correctness:** Does the change meet the objective and contract? Check boundaries, empty or invalid input, error paths, state consistency, concurrency, and regressions.
- **Readability and simplicity:** Are names, control flow, organization, comments, and abstractions clear and proportionate? Identify duplication, cleverness, dead artifacts, or complexity without a clear payoff.
- **Architecture:** Does the change follow project patterns, preserve dependency direction and module ownership, keep type/data boundaries explicit, and reduce rather than relocate complexity?
- **Security:** Are untrusted inputs and external data validated at boundaries? Check authorization, secrets, injection, output handling, and dependency trust where applicable.
- **Performance:** Check unbounded work or data, N+1 access, inappropriate synchronous work, hot-path allocations, missing pagination, and unnecessary UI updates where applicable.

Report only findings supported by a specific location and evidence. Put the impact first, then the smallest concrete fix. Use a one-line PR-comment style when practical: `path:line — impact/problem; required remediation.` Order findings by leverage: correctness and security first, then structural issues, then non-blocking polish.

For structural issues, prefer the remedy that removes moving pieces rather than spreading the same complexity elsewhere—for example, consolidate duplicate branches, separate orchestration from business logic, move logic to its owning layer, reuse a canonical helper, make a boundary explicit, or extract a focused helper.

Use exactly one severity prefix per finding:

| Prefix | Meaning |
|---|---|
| **Critical:** | Broken functionality, security vulnerability, data loss/corruption, unsafe behavior, or objective-blocking defect; must fix before merge; blocks approval. |
| **Required:** | Material pre-merge issue that is not Critical, such as missing behavior, material contract/architecture violation, or necessary regression coverage; must fix before merge. |
| **Optional:** | Worthwhile improvement that may be deferred without blocking the change. |
| **Nit:** | Minor style or polish issue that may be ignored. |
| **FYI:** | Informational context only; no action needed. |

Report what evidence exists; never infer a pass because no failure was observed:

Verification reporting
- **Tests:** `passed` or `failed` only when caller-provided evidence supports it; otherwise `not run by reviewer (read-only)`.
- **Build/type checks:** `passed` or `failed` only with supporting caller-provided evidence; otherwise `not run by reviewer (read-only)`.
- **Manual verification:** `completed` only when established through permitted read-only inspection; otherwise `not run by reviewer (read-only)`.
- **Static review:** `completed` or `not completed`.
- **Review limitations:** State anything material that could not be assessed.

Before deciding, classify every material failure to meet the objective as a finding: use **Critical:** for unsafe, broken, security-sensitive, or data-loss-causing failures; otherwise use **Required:**.

Verdict
- **Approve** only when the objective is met and no unresolved Critical or Required findings remain.
- **Request changes** when the objective is not met or any unresolved Critical or Required finding remains.

If the objective or scope cannot be established, report the limitation and request the missing context; do not issue a normal approval verdict.

Report order
1. Verdict
2. Critical
3. Required
4. Optional
5. Nit
6. FYI
7. Verification status
8. Review limitations

Write `None` for an empty findings section so its absence is explicit.
