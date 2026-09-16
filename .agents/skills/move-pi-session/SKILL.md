---
name: move-pi-session
description: Move specific Pi sessions or all sessions under ~/.pi/agent/sessions/ when a project folder has been moved or renamed.
disable-model-invocation: true
---

# Move Pi Session

Use this skill when a project folder is moved or renamed, to ensure that the Pi session history (specific transcripts and JSONL files, or all files) remains associated with the project's new location.

## Pi Session Folder Structure

Pi stores session transcripts in `~/.pi/agent/sessions/`. The directories are named using the absolute path of the project, where `/` is replaced by `-` and the entire string is wrapped in `--`.

* **Example Project Path:** `/Users/ycm/Developer/oss/opi`
* **Corresponding Pi Session Directory:** `~/.pi/agent/sessions/--Users-ycm-Developer-oss-opi--`

## Signature and Arguments

This skill accepts two invocation patterns:

1. **3 Arguments:** `<session>` `<old-path>` `<new-path>`
2. **2 Arguments:** `<session>` `<new-path>` (where `<old-path>` is inferred from the current working directory of the invocation)

### Argument Specifications

* **`<session>`**: 
  * Use `"all"` or `"*"` to move all session files and directories associated with the project.
  * Use a specific session ID, UUID, or filename prefix (e.g., `019f76a3-8224-7efd-987f-86a34dfe95fd`) to move only that specific session's JSONL file and its companion directory.
* **`<old-path>`**: The absolute or relative path to the old project directory. In the 2-argument pattern, this is inferred as the current working directory (`pwd`) of invocation.
* **`<new-path>`**: The absolute or relative path to the new project directory.

## Steps to Resolve and Move Sessions

### 1. Resolve Project Paths
* Convert `<new-path>` to an absolute path.
* Resolve `<old-path>` to an absolute path:
  * For 3-argument invocation: convert `<old-path>` to an absolute path.
  * For 2-argument invocation: use the absolute path of the current directory (`pwd`).

### 2. Calculate Session Folder Names
* **Old Session Folder Name:** Replace all forward slashes `/` in resolved `<old-path>` with dashes `-` (omit the leading `/`), and wrap with `--` at the start and end.
* **New Session Folder Name:** Apply the same mapping to resolved `<new-path>`.
  * E.g., `/Users/ycm/Developer/oss/opi` ➜ `--Users-ycm-Developer-oss-opi--`

### 3. Verify and Prepare Paths
* Verify the old session folder exists:
  ```bash
  ls -la ~/.pi/agent/sessions/<old-session-folder-name>
  ```
* Ensure the new session folder exists (create if missing):
  ```bash
  mkdir -p ~/.pi/agent/sessions/<new-session-folder-name>
  ```

### 4. Move the Session Files

#### Case A: Moving `"all"` or `"*"` sessions
Move all files and directories from the old folder to the new folder, and clean up the empty old folder:
```bash
mv ~/.pi/agent/sessions/<old-session-folder-name>/* ~/.pi/agent/sessions/<new-session-folder-name>/
rmdir ~/.pi/agent/sessions/<old-session-folder-name>
```

#### Case B: Moving a specific `<session>` ID
Move the session's `.jsonl` file and its companion directory (if it exists):
```bash
# Move the JSONL file
mv ~/.pi/agent/sessions/<old-session-folder-name>/*<session>*.jsonl ~/.pi/agent/sessions/<new-session-folder-name>/

# Move the companion directory if it exists
[ -d ~/.pi/agent/sessions/<old-session-folder-name>/*<session>* ] && mv ~/.pi/agent/sessions/<old-session-folder-name>/*<session>*/ ~/.pi/agent/sessions/<new-session-folder-name>/
```

### 5. Verify Success
Verify the moved session files exist under the new session directory:
```bash
ls -la ~/.pi/agent/sessions/<new-session-folder-name>/
```

### 6. Update System Prompt Current Directory
* Update the system prompt's current directory (CWD) to `<new-path>` to ensure that all subsequent tool executions, directory checks, and environment states resolve to the new project location.
