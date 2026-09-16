---
name: write-pi-session
description: Reconstruct a Pi agent session JSONL file from a conversation that ran without session recording (e.g. started with --no-session, an unrecorded harness, or a lost transcript). Use when the user says a conversation is "unrecorded", asks to write/create/backfill a session file, or wants a JSONL transcript written into ~/.pi/agent/sessions/ after the fact.
disable-model-invocation: true
---

# Write Pi Session

Reconstruct a Pi session JSONL (`~/.pi/agent/sessions/…`) from an unrecorded
conversation so it becomes inspectable, resumable (`pi --session <file>`), and
exportable (`pi --export`) like any native session.

## When to use

- The conversation ran under a harness/extension that never wrote a session
  file (`--no-session`, custom RPC driver, lost transcript).
- The user asks to "record this conversation" after the fact.
- A transcript exists in another form (chat log, markdown) and must be
  imported into Pi's session store.

## Session format (version 3)

Every entry is one JSON object per line. The first line is the session header:

```json
{"type":"session","version":3,"id":"<uuid4>","timestamp":"<ISO-8601 ms>","cwd":"<absolute path>"}
```

Entries form a **linear chain**: each entry's `parentId` is the previous
entry's `id`. Ids are 8-hex-char strings; generate with `uuid4().hex[:8]`.
Timestamps are ISO-8601 with milliseconds (`2026-09-03T16:25:00.000Z`); message
`timestamp` fields (epoch ms) accompany the ISO string.

### Entry types

| Type | Shape |
|---|---|
| `session` | Header (first line). No `parentId`. |
| `model_change` | `{type, id, parentId, timestamp, provider, modelId}` — `parentId: null` is legitimate for the first entry after the header. |
| `thinking_level_change` | `{type, id, parentId, timestamp, thinkingLevel}` |
| `message` (user) | `message.content` = text blocks `{"type":"text","text":…}` |
| `message` (assistant) | `content` = thinking / text / `toolCall` blocks; `stopReason: "toolUse"` when the turn ended on calls, else `"stop"`; include `api`, `provider`, `model`, `usage` (zeros acceptable) |
| `message` (role `toolResult`) | **One message per tool call**, keyed by `toolCallId`/`toolName` inside `message`, not at top level; `content` = text blocks; `isError` boolean; follows its assistant message in call order |

Minimal `usage` block on assistant messages (zeros acceptable — honest, not
fabricated):

```json
{"input":0,"output":0,"cacheRead":0,"cacheWrite":0,"totalTokens":0,
 "cost":{"input":0,"output":0,"cacheRead":0,"cacheWrite":0,"total":0}}
```

### toolCall block

```json
{"type":"toolCall","id":"toolu_<24hex>","name":"bash","arguments":{…}}
```

### toolResult message

```json
{"type":"message","id":"<8hex>","parentId":"<prev id>","timestamp":"<ISO ms>",
 "message":{"role":"toolResult","toolCallId":"toolu_…","toolName":"bash",
            "content":[{"type":"text","text":"<output>"}],"isError":false,
            "timestamp":<epoch ms>}}
```

## Steps

1. **Gather the conversation.** Take the real turns from the conversation
   under reconstruction. Each user turn, each assistant turn, each tool call
   and its result. If parts are unrecoverable (thinking blocks, usage),
   omit them rather than fabricate — mark provider/model `"unrecorded"` when
   the source ran on an unknown harness.

2. **Anchor timestamps.** Derive plausible timestamps from evidence: file
   mtimes of artifacts the conversation touched (`stat -f "%m %Sm %N"`),
   tool-result contents (command outputs sometimes carry clocks), or the
   session-start time the user gives. Spread entries across that window.

3. **Write a generator script** (Python recommended) that:
   - starts from the header (`version: 3`, uuid4 session id, real `cwd`),
   - appends `model_change` (`provider`/`modelId` known? use real values;
     otherwise `unrecorded`/`unrecorded-session`) and `thinking_level_change`,
   - for each turn: user message → assistant message (text + toolCall
     blocks) → one toolResult message **per call, in order** → (next turn),
   - maintains the `id`/`parentId` chain programmatically — never by hand.

4. **Validate before installing.** Run the bundled validator:
   ```bash
   python3 ~/.agents/skills/write-pi-session/scripts/validate_session.py <file>
   ```
   It checks: JSONL parses line-by-line; header first, `version: 3`; chain
   is linear (`parentId` of entry N+1 = `id` of entry N; `model_change` may
   legitimately have `parentId: null`); every toolCall id has exactly one
   matching toolResult; no extra toolResults; roles are user/assistant/
   toolResult only.

5. **Install with pi's naming convention.** Target directory:
   `~/.pi/agent/sessions/--<cwd path with / → ->--` …
   exact form: path with `/` replaced by `-`, wrapped in `--` … e.g.
   `/Users/ycm/Developer/oss/pi-babysit` →
   `--Users-ycm-Developer-oss-pi-babysit--`. Filename:
   `<session-start ISO with : and . → ->_<session-uuid>.jsonl`
   (e.g. `2026-09-03T16-25-00-000Z_d5621940-….jsonl`).

6. **Smoke-test with pi itself.**
   ```bash
   pi --export <file> /tmp/export.html
   ```
   If pi renders it, the format is accepted. Optionally `pi --session <file>`
   to confirm resumability.

## Rules

- **Never fabricate thinking blocks, signatures, or usage numbers.** Zeros
  and `"unrecorded"` are honest; plausible-looking fakes poison the record.
- **One toolResult per toolCall**, matching ids, in call order.
- **Linear chain only** — pi sessions are append-only transcripts, not trees.
- If the source conversation is partially recoverable, record what is real
  and note gaps in the final assistant text (e.g. "reconstructed from
  artifacts; thinking blocks unavailable").
- If a same-named file exists in the target directory, pick a distinct
  session id / filename — don't overwrite another session.
- Prefer regenerating over hand-editing: write the generator script, validate,
  install. The one run of this procedure validated with `pi --export`
  successfully.
