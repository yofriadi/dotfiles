local M = {}
local env = require("config.heirline.env")

function M.buffer_matches(patterns, bufnr)
  for kind, pattern_list in pairs(patterns) do
    if env.buf_matchers[kind](pattern_list, bufnr) then return true end
  end
  return false
end

function M.has_filetype(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.bo[bufnr or 0].filetype and vim.bo[bufnr or 0].filetype ~= ""
end

function M.is_git_repo(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.b[bufnr or 0].gitsigns_head or vim.b[bufnr or 0].gitsigns_status_dict
end

function M.is_active() return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin) end

return M
