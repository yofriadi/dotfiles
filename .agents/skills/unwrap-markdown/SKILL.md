---
name: unwrap-markdown
description: Keep markdown table cells wrapped and aligned, but unwrap all paragraphs and list items to take the full width.
disable-model-invocation: true
---

# Unwrap Markdown Paragraphs

Use this skill when asked to unwrap markdown paragraphs, make text lines take full width, or format a markdown file so that paragraphs and list items are continuous single lines while tables remain wrapped and aligned.

## Approach

Do not use external scripts to format the document. Instead, directly read the markdown file, process its structure, and overwrite/update it directly.

### Formatting Rules

1. **Read the Document**: Load the target markdown file using `read`.
2. **Paragraphs & List Items**:
   - Join multi-line wrapped text within a paragraph into a single continuous line (replacing internal line breaks with single spaces).
   - Join multi-line list items (`-`, `*`, `+`, `1.`, etc.) into a single line per item, preserving bullet symbols and indentation.
   - Keep blank lines between paragraphs and list blocks intact.
3. **Tables**:
   - Keep table cell content wrapping and line breaks intact.
   - For Unicode box-drawing tables (`┌`, `├`, `└`, `│`) or Markdown tables (`|`), adjust padding/alignment so vertical borders align cleanly.
4. **Headings, Code & Other Elements**:
   - Preserve headings (`#`), separators (`---`, `───`), code blocks (```), blockquotes (`>`), and HTML tags.
5. **Update Document**: Write the formatted output back to the target file.
