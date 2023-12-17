local M = {}
local env = require("config.heirline.env")

function M.buffer_matches(patterns, bufnr)
  for kind, pattern_list in pairs(patterns) do
    if env.buf_matchers[kind](pattern_list, bufnr) then return true end
  end
  return false
end

return M
