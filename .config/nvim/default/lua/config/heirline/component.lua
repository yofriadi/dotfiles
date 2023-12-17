local M = {}
local hl = require("config.heirline.highlight")
local util = require("config.heirline.util")
local provider = require("config.heirline.provider")

function M.mode()
  local opts = {
    mode_text = false,
    paste = false,
    spell = false,
    surround = { separator = "left", color = hl.mode_bg },
    hl = hl.get_attributes("mode"),
    update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
    },
  }
  if not opts["mode_text"] then opts.str = { str = " " } end
  return M.builder(util.setup_providers(opts, { "mode_text", "str", "paste", "spell" }))
end

function M.builder(opts)
  opts = vim.tbl_deep_extend("force", { padding = { left = 0, right = 0 } }, opts)
  local children = {}
  if opts.padding.left > 0 then -- add left padding
    table.insert(children, { provider = util.pad_string(" ", { left = opts.padding.left - 1 }) })
  end
  for key, entry in pairs(opts) do
    if
      type(key) == "number"
      and type(entry) == "table"
      and provider[entry.provider]
      and (entry.opts == nil or type(entry.opts) == "table")
    then
      entry.provider = provider[entry.provider](entry.opts)
    end
    children[key] = entry
  end
  if opts.padding.right > 0 then -- add right padding
    table.insert(children, { provider = util.pad_string(" ", { right = opts.padding.right - 1 }) })
  end
  return opts.surround
      and util.surround(opts.surround.separator, opts.surround.color, children, opts.surround.condition)
    or children
end

return M
