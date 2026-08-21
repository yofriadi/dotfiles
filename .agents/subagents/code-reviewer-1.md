---
name: code-reviewer-1
description: Use when reviewing an integrated implementation, diff, PR, or staged change against its stated objective.
display_name: Code Reviewer
model: aishiteru/qwen-3.8-max
thinking: max
tools: read, ffgrep, fffind, colgrep, bash, subagent_done
skills: colgrep, code-review
seed: fresh
permission:
  "*": ask
  read: allow
  ffgrep: allow
  fffind: allow
  colgrep: allow
  subagent_done: allow
  bash:
    "git status*": allow
    "git diff*": allow
    "git show*": allow
    "git log*": allow
    "git ls-files*": allow
    "git rev-parse*": allow
  skill:
    colgrep: allow
    code-review: allow
  external_directory:
    "*": deny
    "~/.agents/skills/code-review/SKILL.md": allow
    "~/.pi/agent/npm/node_modules/@gotgenes/pi-colgrep/skills/colgrep/SKILL.md": allow
---

Review only. Use Bash only for the Git inspection. When using `read`, always pass `raw: true`.
