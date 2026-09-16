---
name: codebuddy-quota
description: Check CodeBuddy credit quota via the billing meter API. Use when the user wants to know how many CodeBuddy credits they have left, their quota usage, or their package/resource status.
allowed-tools: Bash(curl, jq)
metadata:
  version: "1.0"
disable-model-invocation: true
---

# CodeBuddy Quota Check

Query the Tencent CodeBuddy billing meter API and summarize the user's remaining credits across all their resource accounts (packages).

## Prerequisite

The `CODEBUDDY_API_KEY` environment variable must be set. If it is unset, tell the user and stop — do not guess or substitute a key.

## Steps

### 1. Call the billing API

Run exactly this request (the headers mimic the CodeBuddy CLI; they are required):

```bash
curl -sS \
    -X POST 'https://copilot.tencent.com/v2/billing/meter/get-user-resource' \
    -H "Authorization: Bearer $CODEBUDDY_API_KEY" \
    -H 'Content-Type: application/json' \
    -H 'User-Agent: CLI/2.108.1 CodeBuddy/2.108.1' \
    -H 'X-Product: SaaS' \
    -H 'X-IDE-Type: CLI' \
    -H 'X-IDE-Name: CLI' \
    -H 'x-requested-with: XMLHttpRequest' \
    -H 'x-codebuddy-request: 1' \
    --data '{}'
```

Success looks like `"code": 0, "msg": "OK"`. If `code` is non-zero (e.g. auth failure), report the `msg` back to the user.

### 2. Parse the response

The payload nests under `data.Response.Data`. A compact view per account:

```bash
curl -sS ... | jq '.data.Response.Data | {
  totalAccounts: .TotalCount,
  totalCapacity: .TotalDosage,
  accounts: [.Accounts[] | {
    accountId: .AccountId,
    package: .PackageName,
    size: .CapacitySize,
    remaining: .CapacityRemain,
    cycleRemaining: .CycleCapacityRemain,
    cycleUsed: (.CycleCapacityUsed // 0),
    cycle: (.CycleStartTime + " → " + .CycleEndTime),
    status: .Status
  }]
}'
```

Prefer the precise fields when exactness matters: `CapacityRemainPrecise`, `CycleCapacityRemainPrecise`, `CycleCapacityUsedPrecise` (the plain integer fields are floored).

### 3. Interpret the fields

| Field | Meaning |
|---|---|
| `CapacitySize` / `CapacityRemain` / `CapacityUsed` | Lifetime size / remaining / used for the resource |
| `CycleCapacitySize` / `CycleCapacityRemain` / `CycleCapacityUsed` | Size / remaining / used **in the current billing cycle** — the number that actually matters for monthly-reset packages (e.g. the trial resets on the 1st of each month) |
| `CycleStartTime` / `CycleEndTime` | Current cycle window (calendar month for trials, rolling month for bonus packs) |
| `PackageName` | e.g. "CodeBuddy Personal Trial" (trial), "CodeBuddy Personal Bonus Pack" (bonus/gift pack) — the API returns these names in Chinese; translate them when reporting |
| `Status` | 0 = active/usable |
| `BindRecords[].BindObjectId` | The bound account/workspace |

### 4. Summarize for the user

Report in a concise table: one row per account with package, size, remaining, cycle window. Always call out:

- **Total remaining capacity** (sum of `CapacityRemain` across accounts).
- **The trial account's monthly usage** (`CycleCapacityUsed` vs `CycleCapacitySize`) — it is the only package that resets and the only one that typically shows consumption.
- **Expiry** — when each cycle ends (`CycleEndTime`), so the user knows what they lose and when.

## Notes

- A response with many accounts is normal: each bonus/gift grant creates its own resource account. Don't collapse them unless the user asks.
- `DeductionEndTime` is the far-future validity end of the purchase; `CycleEndTime` is the operative expiry.
- If the user's key has no resources, `TotalCount` will be 0 — say so plainly rather than inventing numbers.
