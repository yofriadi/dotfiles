local util = require("util")
-- local gitsigns = require("gitsigns")

local M = {}

-- LSP
local lspBuf = vim.lsp.buf
function M.add_to_workspace_folder() lspBuf.add_workspace_folder() end
function M.list_workspace_folders() lspBuf.list_workspace_folders() end
function M.remove_workspace_folder() lspBuf.remove_workspace_folder() end
function M.workspace_symbol() lspBuf.workspace_symbol() end
function M.references()
    lspBuf.references()
    lspBuf.clear_references()
end
function M.clear_references() lspBuf.clear_references() end
function M.code_action() lspBuf.code_action() end
function M.range_code_action() lspBuf.range_code_action() end
function M.declaration()
    lspBuf.declaration()
    lspBuf.clear_references()
end
--[[ function M.definition()
    lspBuf.definition()
    lspBuf.clear_references()
end ]]
-- function M.type_definition() lspBuf.type_definition() end
function M.document_highlight() lspBuf.document_highlight() end
function M.document_symbol() lspBuf.document_symbol() end
function M.implementation() lspBuf.implementation() end
function M.incoming_calls() lspBuf.incoming_calls() end
function M.outgoing_calls() lspBuf.outgoing_calls() end
-- function M.formatting() lspBuf.formatting() end
-- function M.range_formatting() lspBuf.range_formatting() end
-- function M.formatting_sync() lspBuf.formatting_sync() end
function M.hover() lspBuf.hover() end
function M.rename() lspBuf.rename() end
function M.signature_help() lspBuf.signature_help() end

-- Diagnostic
local lspDiagnostic = vim.lsp.diagnostic
function M.get_all() lspDiagnostic.get_all() end
function M.get_next() lspDiagnostic.get_next() end
function M.get_prev() lspDiagnostic.get_prev() end
-- function M.goto_next() lspDiagnostic.goto_next() end
-- function M.goto_prev() lspDiagnostic.goto_prev() end
function M.show_line_diagnostics() lspDiagnostic.show_line_diagnostics() end
function M.virtual_text_show() util.virtualtext_show() end
function M.virtual_text_hide() util.virtualtext_hide() end

-- GIT signs
--[[ function M.preview_hunk() gitsigns.preview_hunk() end
function M.next_hunk() gitsigns.next_hunk() end
function M.prev_hunk() gitsigns.prev_hunk() end
function M.stage_hunk() gitsigns.stage_hunk() end
function M.undo_stage_hunk() gitsigns.undo_stage_hunk() end
function M.reset_hunk() gitsigns.reset_hunk() end
function M.reset_buffer() gitsigns.reset_buffer() end
function M.blame_line() gitsigns.blame_line() end ]]--

-- Set path
function M.set_global_path() util.set_global_path() end
function M.set_window_path() util.set_window_path() end

return M
