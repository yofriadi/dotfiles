---
name: github-grep
description: Search for literal code patterns, library usage, and syntax implementations across public GitHub repositories using grep.app via mcporter.
disable-model-invocation: true
---

## Tool Call Syntax

Query grep.app through the unified mcporter tool call CLI:

```bash
  mcporter call 'grep.searchGitHub(query: "query_string", language: ["Language"], repo: "org/repo", path: "path/filter", useRegexp: false)'
```

## Parameter Reference

- query (string, REQUIRED): Literal code pattern, string, or regular expression to search (e.g., "useState(", "async function").
- language (array of strings, OPTIONAL): Filter by programming language (e.g., ["TypeScript"], ["Python"]).
- repo (string, OPTIONAL): Scope the search to a specific repository or organization (e.g., "facebook/react").
- path (string, OPTIONAL): Filter results by file path pattern (e.g., "/route.ts", "src/").
- useRegexp (boolean, OPTIONAL): Treat the query string as a regular expression. Defaults to false.

## Usage Examples

- Look up how a function is used across the ecosystem:
  ```bash
    mcporter call 'grep.searchGitHub(query: "getServerSession")'
  ```
- Find React Error Boundary usage in TypeScript/TSX:
  ```bash
    mcporter call 'grep.searchGitHub(query: "ErrorBoundary", language: ["TSX"])'
  ```
- Search for regex matches within a specific repository:
  ```bash
    mcporter call 'grep.searchGitHub(query: "(?s)try {.*await", repo: "vercel/ai", useRegexp: true)'
  ```
