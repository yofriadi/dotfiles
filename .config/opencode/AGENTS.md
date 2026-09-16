When I report a bug, don't start by trying to fix it. Instead, start by writing a test that reproduces the bug. Then, have subagents try to fix the bug and prove it with a passing test.

<!-- LAZYWEB:ROUTER:BEGIN v0.12.0 — managed by `lazyweb-router`; do not edit inside; run `~/.lazyweb/bin/lazyweb-router remove` to uninstall -->
## Lazyweb design-evidence routing

Lazyweb provides real app screenshots, UI patterns, and A/B test evidence.
Before designing, critiquing, or changing any product UI (screens, flows,
landing pages, paywalls, onboarding, pricing, checkout, dashboards), route
through Lazyweb instead of answering from training data. When in doubt
whether a UI request matches, route it.

To act on a row, read ~/.config/opencode/skills/<skill>/SKILL.md and follow it.

| The user asks for… | Skill |
|---|---|
| Deep UI research / competitive analysis | `lazyweb-deep-design-research` |
| Lite UI examples / refs, no report | `lazyweb-lite-design-research` |
| Quick MCP search before design | `lazyweb-quick-search` |
| Improve or critique existing UI | `lazyweb-design-improve` |
| Creative cross-category ideas | `lazyweb-design-brainstorm` |
| Optimize paywall conversion | `lazyweb-optimize-paywall` |
| Rewrite one paywall CTA | `lazyweb-paywall-cta` |
| Optimize sign-up conversion | `lazyweb-optimize-sign-up` |
| A/B tests and monetization | `lazyweb-ab-test-research` |
| Design craft best practices | `lazyweb-design-best-practices` |
| Anything else UI-related | `lazyweb` (picks the right mode) |

Do not route: backend/CLI/infra work, prose copyediting, non-product visuals.
If the request is ambiguous between two modes, ask the user one short
clarifying question before proceeding; if you cannot ask, choose the closer
mode, say so, and continue.
<!-- LAZYWEB:ROUTER:END -->
