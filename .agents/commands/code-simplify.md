---
description: Review recently changed code for clarity, consistency, and maintainability improvements
argument-hint: "[--staged] [--ref=<ref>] [files...]"
---

Review recently changed code and apply simplification improvements based on the principles below.

**Provided arguments**: $@

## 1. Determine Scope and Changed Lines

Examine the provided arguments:
- If `--staged` is present: inspect only staged changes (`git diff --cached`).
- If `--ref=<ref>` is present: diff against the specified ref (e.g., `git diff <ref>`).
- If specific file paths are provided: restrict review to those files.
- If no files or flags are specified: inspect unstaged and staged uncommitted changes (`git diff` and `git diff --cached`). If the working directory has no uncommitted changes, fall back to the last commit (`git diff HEAD~1`).

For each file in scope:
- Run `git diff --unified=0 --no-ext-diff` with the relevant flags and file path to determine the changed line numbers.
- For added files: the entire file is in scope.
- For modified files: identify the exact changed line ranges from diff hunk headers (`@@ -... +<start>,<count> @@`).
- For deleted files or deletions-only changes: skip them (no current lines to simplify).

## 2. Principles

- **Preserve functionality**: Never change what the code does. All existing tests must continue to pass.
- **Apply project standards**: Follow any conventions from `CLAUDE.md` or `AGENTS.md` in this project.
- **Enhance clarity**: Reduce unnecessary complexity and nesting, eliminate redundant code and abstractions, improve variable and function names, and consolidate related logic. Keep valuable comments that explain design rationale, business rules, non-obvious behaviour, or intent. Remove only truly redundant noise, such as `// increment i` above `i++`. Avoid nested ternary operators: prefer switch statements or if/else chains for multiple conditions.
- **Maintain balance**: Do not over-simplify. Avoid overly clever solutions that are hard to understand. Do not combine too many concerns into single functions. Do not remove helpful abstractions. Prioritize readability over fewer lines.

## 3. Scope Rules

- Only review and modify the changed lines in the target files.
- Changed line numbers refer to the current file contents.
- You may read surrounding code for context, but must not edit it.
- For added files, the entire file is considered changed.
- Do NOT add new features, change public APIs, or refactor code outside the listed line ranges.
- If a worthwhile simplification would require editing unchanged code, leave it alone and mention it in the summary instead.

## 4. Process

1. Inspect the git diff and list the files and line ranges in scope.
2. Read each file and inspect its changed lines.
3. Identify concrete improvements within those lines (dead code, unclear names, redundant logic, inconsistent patterns, unnecessary nesting).
4. Apply changes one file at a time, keeping every edit strictly within the listed line ranges.
5. After all changes, run existing project tests or typechecks to verify nothing is broken.
6. Summarize what you changed and why, along with any simplifications skipped because they fell outside the changed lines.
