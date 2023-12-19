local M = {}
local env = require("config.heirline.env")

function M.mode_bg() return env.modes[vim.fn.mode()][2] end

function M.get_attributes(name, include_bg)
  local hl = env.attributes[name] or {}
  hl.fg = name .. "_fg"
  if include_bg then hl.bg = name .. "_bg" end
  return hl
end

function M.file_icon(name)
  local hl_enabled = env.icon_highlights.file_icon[name]
  return function(self)
    if hl_enabled == true or (type(hl_enabled) == "function" and hl_enabled(self)) then
      return M.filetype_color(self)
    end
  end
end

function M.filetype_color(self)
  local devicons_avail, devicons = pcall(require, "nvim-web-devicons")
  if not devicons_avail then return {} end
  local _, color = devicons.get_icon_color(
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"),
    nil,
    { default = true }
  )
  return { fg = color }
end

return M
