local M = {}
local env = require("config.heirline.env")

function M.mode_bg() return env.modes[vim.fn.mode()][2] end

function M.get_attributes(name, include_bg)
  local hl = env.attributes[name] or {}
  hl.fg = name .. "_fg"
  if include_bg then hl.bg = name .. "_bg" end
  return hl
end

return M
