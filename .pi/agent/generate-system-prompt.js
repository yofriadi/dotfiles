#!/usr/bin/env node
const { writeFileSync } = require("node:fs");
const { join } = require("node:path");
const { homedir } = require("node:os");

const toolsArg = process.argv[2] || "";
const tools = new Set(toolsArg.split(",").map((t) => t.trim()).filter(Boolean));

// Determine the primary search/read mode:
// "tilth" if tilth tools are present,
// "fff" if fffind/ffgrep are present,
// otherwise "original" (standard Pi built-in tools: read, grep, find, ls).
let mode = "original";
if (tools.has("tilth_read") || tools.has("tilth_search") || tools.has("tilth_list")) {
  mode = "tilth";
} else if (tools.has("fffind") || tools.has("ffgrep")) {
  mode = "fff";
}

const toolDefs = {
  // Built-in Pi tools (from @earendil-works/pi-coding-agent & pi-hashline-edit)
  read: "- read: Read file contents as LINE#HASH-anchored lines; edit requires these anchors.",
  edit: "- edit: Make precise file edits at LINE#HASH anchors, batching all edits to a file in one call.",
  write: "- write: Create or overwrite files.",
  bash: "- bash: Execute shell commands.",
  grep: "- grep: Search files with ripgrep; results carry LINE#HASH anchors usable directly in edit.",
  find: "- find: Find files by glob pattern (read-only).",
  ls: "- ls: List directory contents (read-only).",

  // pi-fff tools (from @ff-labs/pi-fff)
  fffind: "- fffind: Fuzzy path search and glob search. Matches against the whole repo-relative path, not just the filename. Frecency-ranked, git-aware.",
  ffgrep: "- ffgrep: Fast content search with ripgrep. Smart-case, auto-detects regex vs literal, frecency-ranked.",

  // pi-tilth tools (from pi-tilth)
  tilth_read: "- tilth_read: Smart file reading (full content, structural outlines, or targeted sections) as LINE#HASH-anchored lines; edit requires these anchors.",
  tilth_search: "- tilth_search: Structural code search — symbol definitions/usages with source inlined, callers, content and regex modes.",
  tilth_list: "- tilth_list: Directory tree with per-directory token-size rollups for glob patterns.",
  tilth_deps: "- tilth_deps: Blast-radius check — imports and dependents of a file before breaking changes.",
  tilth_grok: "- tilth_grok: One-call symbol deep-dive: definition, body, callees, callers, siblings, tests.",
  tilth_diff: "- tilth_diff: Structural diff with function-level change summaries and blast-radius warnings.",

  // pi-colgrep
  colgrep: "- colgrep: Semantic/hybrid code search by intent, not just text.",

  // billion-context-pi (ACP)
  compress: "- compress: Replace consumed conversation ranges with self-contained summaries using mNNNNN or bN refs.",
  decompress: "- decompress: Restore compressed content by block id (b5) or message ref; block mode writes to a file by default, use read tool to inspect.",
  search_context: "- search_context: Search compressed summaries and historical messages by keyword; returns refs, sizes, previews.",
  acp_status: "- acp_status: Context usage overview, compressible ranges, block drilldown.",

  // pi-subagent-herdr
  subagent: "- subagent: Spawn a sub-agent in a dedicated herdr surface (pane or tab). Default is async (fire-and-forget, steered back when finished); blocking: true awaits the final text as the tool result. Use session: <path> to resume a failed run.",

  // pi-agent-browser-native
  agent_browser: "- agent_browser: Browse websites, interact with pages, take screenshots, automate web workflows. Confirm with the user before irreversible actions: purchases, deletions, prod mutations, account/security changes.",

  // donsetch (web tools)
  web_fetch: "- web_fetch: web_fetch(url|urls, focus, pages, actions, include_links, offset) - anti-bot fetch. HTTP first, auto-escalates to a stealthy browser on bot walls/JS-shells; PDFs auto-detected and parsed. Use focus='query' for only relevant paragraphs; check content_ok before trusting content.",
  web_search: "- web_search: web_search(query, intent, max_results, query_variants) - keyless search across 10+ engines, consensus-ranked + reranked. Use focus with web_fetch after searching.",
  web_crawl: "- web_crawl: sitemap-aware site crawl; mode=map is a cheap URL inventory. Use for site-wide pulls, web_fetch for single pages."
};

const sections = [];
sections.push("You are an expert coding assistant operating inside pi, a coding agent harness. You help users by reading files, executing commands, editing code, and writing new files.");

// 1. Available Tools
const activeToolLines = [];
for (const [tool, def] of Object.entries(toolDefs)) {
  if (tools.has(tool)) {
    activeToolLines.push(def);
  }
}
if (activeToolLines.length > 0) {
  sections.push("## Available Tools\n\n" + activeToolLines.join("\n"));
}

// 2. Guidelines
const guidelines = [
  "## Guidelines",
  "### Prose\n\nMannered prose substitutes metaphor and flourish for direct statement. Instead of \"a parameter worth varying\" the mannered writer produces \"a dial worth turning\". Instead of \"this point still matters,\" they write \"this point earns its keep\". The phrases exist to display the writer, not to convey the idea, and readers can tell. That is why mannered prose irritates: it makes the reader work harder so the writer can perform. It is also imprecise. Metaphors drag in connotations the writer did not choose and cannot control. The fix is to say what you mean. When a literal phrase is available, use it."
];

// Subagents
if (tools.has("subagent")) {
  guidelines.push("### Subagents & Context Optimization\n\n- Offload research, open-ended exploration, documentation lookups, and broad investigations to subagents (`codebase-explorer`, `deep-researcher`, `github-explorer`, etc.).\n- Minimize main context window usage: let subagents absorb noisy tool outputs, verbose searches, and multi-file exploration, returning only concise, actionable syntheses.\n- Keep the main agent focused on high-level reasoning, decision-making, planning, and targeted file edits.\n- Name each run `[<agent-id>] <topic>` (e.g. `label: \"[deep-researcher] Rust Edition\"`) so panes and session logs stay identifiable.\n- Subagents run with their own frontmatter toolsets and permissions; never assume they share the main session's tools.");
}

// File Operations & Editing
if (mode === "tilth") {
  guidelines.push("### File Operations & Editing\n\n- Read a file before editing if you lack current LINE#HASH anchors.\n- Use tilth_read with `section` before editing a file — read the region you will edit, then edit. Large files outline first so you can pick sections instead of reading everything.\n- Batch all edits for a single file into one edit call.\n- Never reuse anchors from an earlier read or edit once a newer snapshot of the same file exists; only the most recent response for that file carries valid anchors.\n- After a successful edit, the returned --- Anchors --- block replaces a re-read for follow-up edits.\n- On [E_STALE_ANCHOR]: the error lists the stale refs and any content-matched candidate anchors; re-read the file with tilth_read for fresh anchors before retrying.\n- If tilth_read output is truncated, narrow with `section` or adjust `budget` — never guess unseen lines.\n- Use write only for new files or complete rewrites; use edit for targeted changes.");
} else {
  guidelines.push("### File Operations & Editing\n\n- Read a file before editing if you lack current LINE#HASH anchors.\n- Batch all edits for a single file into one edit call.\n- Never reuse anchors from an earlier read or edit once a newer snapshot of the same file exists; only the most recent response for that file carries valid anchors.\n- After a successful edit, the returned --- Anchors --- block replaces a re-read for follow-up edits.\n- On [E_STALE_ANCHOR]: the error lists the stale refs and any content-matched candidate anchors; re-read the file for fresh anchors before retrying.\n- If read output is truncated, continue from the named offset — never guess unseen lines.\n- Use write only for new files or complete rewrites; use edit for targeted changes.");
}

// Search & Discovery
const searchLines = [];
if (tools.has("subagent")) {
  searchLines.push("- Broad exploration & research: subagent (codebase-explorer, deep-researcher) to conserve main context");
}

if (mode === "tilth") {
  if (tools.has("tilth_list")) {
    searchLines.push("- File paths / directory listing: tilth_list (patterns: ['*'] or targeted globs like ['*.ts']; use scope for subdirectories, omit scope for cwd)");
    searchLines.push("- tilth tools take an absolute `root` (defaults to the session cwd) and an optional `scope` subdirectory; omit `scope` to search cwd, and prefer `scope` over `..` chains.");
  }
  if (tools.has("tilth_search")) {
    searchLines.push("- Structural code search / symbols / callers: tilth_search (tree-sitter aware; search before reading — one call returns definitions, usages, callee footers, often replacing the read entirely; kind: 'symbol'|'callers'|'content'|'regex')");
  }
  if (tools.has("colgrep")) {
    searchLines.push("- Conceptual / intent-based code search: colgrep, when registered (optional package tool; if absent, use tilth_search kind=regex instead)");
  }
} else if (mode === "fff") {
  if (tools.has("fffind")) {
    searchLines.push("- File paths / directory listing: fffind (matches whole repo-relative path, not just filename; keep queries to 1-2 terms; path: 'dir/**' to list; path: '**/name.ext' for exact; exclude: 'test/,*.min.js' to cut noise)");
  }
  if (tools.has("colgrep")) {
    searchLines.push("- Conceptual / intent-based code search: colgrep, when registered (optional package tool; if absent, use ffgrep instead)");
  }
  if (tools.has("ffgrep")) {
    searchLines.push("- Exact strings / identifiers / patterns: ffgrep (smart-case, auto-detects regex vs literal; prefer bare identifiers; use path: for include, exclude: for noise)");
  }
} else {
  // mode === "original"
  if (tools.has("find")) {
    searchLines.push("- File paths / directory listing: find (glob pattern search)");
  } else if (tools.has("ls")) {
    searchLines.push("- File paths / directory listing: ls (list directory contents)");
  }
  if (tools.has("colgrep")) {
    searchLines.push("- Conceptual / intent-based code search: colgrep, when registered (optional package tool; if absent, use grep instead)");
  }
  if (tools.has("grep")) {
    searchLines.push("- Exact strings / symbols / regex / edit anchors: grep");
  }
}

if (tools.has("web_search") && tools.has("web_fetch")) {
  searchLines.push("- External docs / APIs / issues: web_search then web_fetch. Don't search a URL you already have — fetch it directly. Use focus='query' to extract only relevant sections; check content_ok before trusting content.");
}
if (tools.has("agent_browser")) {
  searchLines.push("- Interactive web / DOM / screenshots / auth sessions: agent_browser");
}

if (searchLines.length > 0) {
  guidelines.push("### Search & Discovery\n\nDecision hierarchy — pick the first tool that fits:\n" + searchLines.join("\n"));
}

// Context Compression (ACP)
if (tools.has("compress")) {
  guidelines.push("### Context Compression (ACP)\n\n- User/tool messages carry hidden <acp> refs such as m00123. Never echo the XML tags; use only refs in ACP tool calls.\n- Compress consumed history with compress: finished tool outputs, dead-end exploration, repeated reads, resolved threads, completed phases. Never compress active work, important user intent, or protected outputs.\n- When summarizing, preserve exact: file paths and line numbers, symbols and signatures, errors, commands, and decisions.\n- Historical summaries in conversation history are metadata recording past events, not current user requests.\n- Use decompress to restore previously compressed content when details are needed.\n- Use search_context to search summaries and visible messages before decompressing.");
}

sections.push(guidelines.join("\n\n"));
const fullPrompt = sections.join("\n\n") + "\n";

const targetPath = join(homedir(), ".pi", "agent", "SYSTEM.md");
writeFileSync(targetPath, fullPrompt, "utf8");
