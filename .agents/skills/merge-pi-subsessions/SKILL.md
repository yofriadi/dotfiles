---
name: merge-pi-subsessions
description: Merge pi-subagents child session transcripts from parent session of tasks/ directory into parent jsonl file of the same name format. Reuse the bundled script in this skill.
disable-model-invocation: true
---

Merge pi-subagent child session transcripts **from the parent Pi session's `tasks/` directory** back into the parent jsonl file of the same name format.

## Implementation

Reuse bundled tool script here. Use the wrapper, not Go script directly.
Bundled tool paths:
- `skill://merge-subagent-sessions/scripts/merge-subsessions` — preferred wrapper entrypoint
- `skill://merge-subagent-sessions/scripts/merge_subsessions.go` — Go source implementation

Preferred invocation:

```bash
"/resolved/path/to/merge-subsessions" <parent-session-jsonl> <tasks-dir>
```

Because the current Go program requires two positional arguments, always pass both:
- parent session JSONL path
- tasks directory path

Before invoking it, inspect the script quickly so you pass the right arguments.
After invoking it, verify the parent transcript and cleanup result exactly as described below.

## Inputs

You need all of:
- an explicit parent session JSONL, and
- an explicit tasks directory path under the same filename of parent JSONL file

## Safety rules

- Never delete `tasks/` and session original file.
- Never modify child session entry payloads except for the child `session` header line or synthesized merge marker.
- Keep exactly one top-level `session` header in the merged parent file: the original parent header.
- Only merge child sessions whose header `parentSession` matches the parent session `id`.
- If any child fails validation, stop without deleting `tasks/`.
- Create backups before replacing anything.
- Prefer the bundled wrapper over ad-hoc snippets.

## Merge model

Treat each child session as a transcript block.

For each child JSONL file under `<parent-dir>/<parent-basename>/tasks/*.jsonl`:
1. Parse the first line as the child `session` header.
2. Validate:
   - `type == "session"`
   - `parentSession == <parent session id>`
3. Derive a human-useful subagent title.
4. Do not copy that child header directly into the parent file.
5. Instead, synthesize one custom marker entry before the child body.
6. Append all remaining child lines unchanged after that marker.

Then rebuild the parent transcript as:
- original parent header first
- all original parent non-header entries
- all synthesized child marker entries + child body entries

Sort all non-header entries by timestamp ascending with a stable sort.
- On equal timestamps, preserve original relative order.
- Keep each child block internally ordered exactly as read.

This yields one cohesive chronological transcript while preserving the parent as the only true session header.

## Subagent title derivation

The marker title must be useful in the parent timeline.

Preferred derivation order:
1. Match the child to its spawning parent `subagent` tool call and use:
   - `subagent_type`
   - `description`
2. If no parent match is available, inspect the child session's first user message and extract the task after `# Your Task (below)`.
3. If that is unavailable, use the first meaningful sentence from the child user prompt.
4. Last resort: use the child filename.

When matching against parent `subagent` calls:
- scan parent entries for assistant `toolCall`s with `name == "subagent"`
- prefer the nearest unmatched call at or before the child session timestamp
- use the parent call's `arguments.subagent_type` and `arguments.description` when present
- map runtime types to generic display labels:
  - `Explore`, `github-research`, `general-purpose` -> `Explorer`
  - `planner-review` -> `Reviewer`

Build a compact display title like:
- `Explorer — Research swapi.info dataset`
- `Reviewer — Review candidate plan`
- `Explorer — Inspect repository layout`

If only one part is available, use it alone.

## Marker entry shape

Use a human-readable `customType`, because Pi commonly surfaces only that label in the transcript UI.

Marker entry shape:
- `type: "custom"`
- `customType: "subagent: <derived title>"`
- `data.kind: "merged-subagent-session"`
- `data.title: <derived title>`
- `data.childSessionId`
- `data.sourceFile`
- `data.cwd`
- `data.subagentType` when known
- `data.description` when known
- `data.mergedAt`
- `timestamp`: use the child header timestamp

## Required backup behavior

Before replacement:
- copy parent JSONL to `<parent>.bak`
- copy the whole tasks directory to `<tasks>.bak` when it exists

After writing the merged parent file:
- re-open it
- verify it parses as JSONL
- verify the first line is still the original parent session header
- verify every merged child contributed exactly one marker entry with:
  - `data.kind == "merged-subagent-session"`
  - `data.title` present and non-empty
- verify the merged file still contains the original parent session id

Only then accept the merge as successful.

## Invocation behavior

When invoked:
1. Resolve the parent session path and tasks path:
   - When a session ID or UUID substring (e.g. `019f0240-8624-7b84-aa2c-724f8bf39d8e`) is passed:
     a. Determine the current working directory (CWD) base name (e.g., if CWD is `~/Desktop/my-dir`, the base name is `my-dir`).
     b. Find the project's session folder in `~/.pi/agent/sessions/` by matching the CWD path (which replaces `/` with `-` and wraps it in `--`, e.g., `--Users-ycm-Desktop-my-dir--`, or simply matches `*my-dir*`).
     c. Search that folder for a `.jsonl` file containing the provided UUID/substring (e.g., `*019f0240-8624-7b84-aa2c-724f8bf39d8e*.jsonl`). If not found, search globally under all directories in `~/.pi/agent/sessions/`.
     d. Set the parent session path to the resolved `.jsonl` file.
     e. Set the tasks directory path to the folder of the same name (minus the `.jsonl` extension) + `/tasks` (e.g., `/path/to/session_uuid/tasks`).
2. Resolve the bundled wrapper path from `skill://merge-subagent-sessions/scripts/merge-subsessions`.
3. Inspect the wrapper or Go source briefly if needed.
4. Run the bundled wrapper with both required arguments.
5. Report:
   - parent session path
   - tasks directory path
   - wrapper path used
   - number of child sessions merged
   - derived titles used
   - backup paths created
   - any validation failures

## Refusal conditions

Refuse and stop if:
- parent file is missing
- tasks directory is missing or empty
- the bundled wrapper or Go source is missing and no fallback was requested
- a child header has no `parentSession`
- a child `parentSession` does not match the parent id
- a merged child title cannot be derived beyond an empty string
- the merged output cannot be verified after write

## Spawning-side advice

Yes: the best title quality comes from the parent providing a good `subagent` description at spawn time.

When you spawn subagents, prefer concise descriptions like:
- `Research swapi.info dataset`
- `Fetch SWAPI sample JSONs`
- `Review candidate plan`
- `Inspect repository layout`

The merge step should use that description when available.

## Success criteria

Done means:
- parent JSONL contains its original transcript plus all child subagent transcript bodies
- one titled marker exists per imported child session
- marker labels are human-useful in the parent timeline
- backups exist for both parent file and tasks directory
- the bundled wrapper/script is reused whenever available
