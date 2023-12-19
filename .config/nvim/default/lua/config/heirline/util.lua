local M = {}
local env = require("config.heirline.env")
local provider = require("config.heirline.provider")

function M.builder(opts)
  opts = vim.tbl_deep_extend("force", { padding = { left = 0, right = 0 } }, opts)
  local children = {}
  if opts.padding.left > 0 then
    table.insert(children, { provider = M.pad_string(" ", { left = opts.padding.left - 1 }) })
  end
  if opts.padding.right > 0 then
    table.insert(children, { provider = M.pad_string(" ", { right = opts.padding.right - 1 }) })
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
  return opts.surround
      and M.surround(opts.surround.separator, opts.surround.color, children, opts.surround.condition)
    or children
end

function M.build_provider(opts, prov, _)
  return opts
    and {
      provider = prov,
      opts = opts,
      condition = opts.condition,
      on_click = opts.on_click,
      update = opts.update,
      hl = opts.hl,
    }
    or false
end

function M.setup_providers(opts, providers, setup)
  setup = setup or M.build_provider
  for i, prov in ipairs(providers) do
    opts[i] = setup(opts[prov], prov, i)
  end
  return opts
end

function M.pad_string(str, padding)
  padding = padding or {}
  return str and str ~= "" and string.rep(" ", padding.left or 0) .. str .. string.rep(" ", padding.right or 0) or ""
end

function M.surround(separator, color, component, condition)
  local function surround_color(self)
    local colors = type(color) == "function" and color(self) or color
    return type(colors) == "string" and { main = colors } or colors
  end

  separator = type(separator) == "string" and env.separators[separator] or separator
  local surrounded = { condition = condition }
  if separator[1] ~= "" then
    table.insert(surrounded, {
      provider = separator[1],
      hl = function(self)
        local s_color = surround_color(self)
        if s_color then return { fg = s_color.main, bg = s_color.left } end
      end,
    })
  end
  table.insert(surrounded, {
    hl = function(self)
      local s_color = surround_color(self)
      if s_color then return { bg = s_color.main } end
    end,
    vim.tbl_deep_extend("force", component, {}),
  })
  if separator[2] ~= "" then
    table.insert(surrounded, {
      provider = separator[2],
      hl = function(self)
        local s_color = surround_color(self)
        if s_color then return { fg = s_color.main, bg = s_color.right } end
      end,
    })
  end
  return surrounded
end

return M
