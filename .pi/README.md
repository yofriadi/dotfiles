# ~/.pi backup

Portable [pi](https://github.com/earendil-works/pi-coding-agent) agent config,
symlinked into `~/.pi/agent/` via [dotter](../.dotter/global.toml).

## What's backed up (tracked)

- `settings.json` — core pi config (compaction, models, packages, sounds, …)
- `keybindings.json`, `models.json`, `claude-code-style.json`, `hashline.json`,
  `pi-caffeinate.json`, `pi-fff.json`, `pi-handoff-config.json`,
  `pi-mcporter-bridge.json`
- `SYSTEM.md`, `generate-system-prompt.js`
- `context-prune/settings.json`
- `extensions/*.ts`, `extensions/pi-permission-system/config.json`
- `sounds/*.mp3`

## What's NOT backed up (kept local, gitignored)

- **Secrets:** `auth.json`, `pi-accounts.json` — re-authenticate on the new machine.
- **Machine state:** `trust.json`, `models-store.json`, `*.bak`, `sessions/`,
  logs, `npm/`, `git/`, `ayu/`, `fff/`, cache-optimizer stats, skill overrides.

## Setup on a new machine

1. Clone this repo and run `dotter deploy` (creates the symlinks above,
   plus `~/.agents`).
2. Re-authenticate pi providers (`auth.json` is intentionally not synced).
3. Export the API keys referenced in `models.json` (`$AISHITERU_API_KEY`,
   `$INFERHUB_API_KEY`, …) in your shell env.
4. Keep the same relative layout for local packages: `settings.json` →
   `packages` uses `../../Developer/oss/pi-extensions/...`, which resolves
   against `~/.pi/agent/`. Clone `pi-extensions` to `~/Developer/oss/pi-extensions`.

## Notes

- Sound paths in `settings.json` use `~/...` (expanded by pi-event-sounds);
  do not change them back to absolute `/Users/...` paths.
- `models.json` uses `$ENV_VAR` placeholders — no raw keys are stored.
