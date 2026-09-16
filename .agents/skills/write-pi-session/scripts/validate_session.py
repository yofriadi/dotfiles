#!/usr/bin/env python3
"""Validate a Pi agent session JSONL file (format version 3).

Checks:
- every line parses as JSON
- first entry is a `session` header with version 3
- id/parentId chain is linear (model_change may carry parentId: null)
- every toolCall id has exactly one toolResult message; no orphans
- message roles are only user / assistant / toolResult
- toolResult messages carry toolCallId/toolName inside `message`

Exit 0 = valid; anything else = invalid (reasons printed).
"""

import json
import sys

HEX8 = 16**8


def fail(msg):
    print(f"INVALID: {msg}")
    sys.exit(1)


def main(path):
    try:
        with open(path) as fh:
            lines = [ln for ln in (l.strip() for l in fh) if ln]
    except OSError as e:
        fail(f"cannot read {path}: {e}")

    entries = []
    for n, ln in enumerate(lines, 1):
        try:
            entries.append(json.loads(ln))
        except json.JSONDecodeError as e:
            fail(f"line {n} is not valid JSON: {e}")

    if not entries:
        fail("empty file")
    if entries[0].get("type") != "session":
        fail("first entry is not a session header")
    if entries[0].get("version") != 3:
        fail(f"header version is {entries[0].get('version')!r}, expected 3")

    ids = [e.get("id") for e in entries]
    if len(set(ids)) != len(ids):
        dupes = {i for i in ids if ids.count(i) > 1}
        fail(f"duplicate ids: {sorted(dupes)[:5]}")

    # linear chain: entry N+1's parentId == entry N's id.
    # exceptions: header has no parentId; the entry right after the header
    # (model_change) may legitimately carry parentId: null.
    for n in range(1, len(entries)):
        e = entries[n]
        if n == 1 and e.get("parentId") is None:
            continue
        if e.get("parentId") != ids[n - 1]:
            fail(
                f"chain break at line {n + 1}: parentId="
                f"{e.get('parentId')!r} but previous id={ids[n - 1]!r}"
            )

    call_ids = []
    roles = set()
    result_ids = []
    for e in entries:
        if e.get("type") != "message":
            continue
        m = e.get("message", {})
        role = m.get("role")
        roles.add(role)
        if role == "assistant":
            for c in m.get("content", []):
                if isinstance(c, dict) and c.get("type") == "toolCall":
                    cid = c.get("id")
                    if not cid:
                        fail(f"toolCall without id in entry {e.get('id')}")
                    call_ids.append(cid)
        elif role == "toolResult":
            tcid = m.get("toolCallId")
            tname = m.get("toolName")
            if not tcid or not tname:
                fail(
                    f"toolResult missing toolCallId/toolName inside message "
                    f"(entry {e.get('id')})"
                )
            result_ids.append(tcid)
        elif role == "user":
            pass
        else:
            fail(f"unexpected message role {role!r}")

    missing = [c for c in call_ids if call_ids.count(c) != 1]
    if missing:
        fail(f"duplicate toolCall ids: {sorted(set(missing))[:5]}")
    unmatched = [c for c in call_ids if c not in result_ids]
    if unmatched:
        fail(f"toolCalls without matching toolResult: {unmatched[:5]}")
    orphans = [r for r in result_ids if r not in call_ids]
    if orphans:
        fail(f"toolResults without matching toolCall: {orphans[:5]}")

    n_user = sum(1 for e in entries if e.get("type") == "message"
                 and e["message"].get("role") == "user")
    n_asst = sum(1 for e in entries if e.get("type") == "message"
                 and e["message"].get("role") == "assistant")
    print(f"VALID: {len(entries)} entries, {n_user} user, {n_asst} assistant, "
          f"{len(call_ids)} toolCalls all matched")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <session.jsonl>", file=sys.stderr)
        sys.exit(2)
    main(sys.argv[1])
