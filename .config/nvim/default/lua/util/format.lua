local is_available = require("astrocore").is_available

local M = {}

function M.formatexpr()
  if is_available("conform.nvim") then
    return require("conform").formatexpr()
  end
  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

return M
