local M = {}
M.cache = {}
M.spec = { "lsp", { ".git", "lua" }, "cwd" }
M.detectors = {}

function M.detectors.cwd() return { vim.loop.cwd() } end

function M.get_clients(opts)
  local ret = {} ---@type lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client lsp.Client
      ret = vim.tbl_filter(function(client) return client.supports_method(opts.method, { bufnr = opts.bufnr }) end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.bufpath(buf) return M.realpath(vim.api.nvim_buf_get_name(assert(buf))) end

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then return {} end
  local roots = {} ---@type string[]
  for _, client in pairs(M.get_clients { bufnr = buf }) do
    -- only check workspace folders, since we're not interested in clients
    -- running in single file mode
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
  end
  return vim.tbl_filter(function(path)
    path = M.norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.loop.cwd()
  local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.loop.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then home = home:sub(1, -2) end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

function M.realpath(path)
  if path == "" or path == nil then return nil end
  path = vim.loop.fs_realpath(path) or path
  return M.norm(path)
end

function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf) return M.detectors.pattern(buf, spec) end
end

function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {}
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then roots[#roots + 1] = pp end
    end
    table.sort(roots, function(a, b) return #a > #b end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then break end
    end
  end
  return ret
end

function M.cwd() return M.realpath(vim.loop.cwd()) or "" end

function M.is_win() return vim.loop.os_uname().sysname:find "Windows" ~= nil end

function M.get(opts)
  local buf = vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect { all = false }
    ret = roots[1] and roots[1].paths[1] or vim.loop.cwd()
    M.cache[buf] = ret
  end
  if opts and opts.normalize then return ret end
  return M.is_win() and ret:gsub("/", "\\") or ret
end

function M.fg(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

function M.root_dir(opts)
  opts = vim.tbl_extend("force", {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = "󱉭 ",
    color = M.fg "Special",
  }, opts or {})

  local function get()
    local cwd = M.cwd()
    local root = M.get { normalize = true }
    local name = vim.fs.basename(root)

    if root == cwd then
      return opts.cwd and name
    elseif root:find(cwd, 1, true) == 1 then
      return opts.subdirectory and name
    elseif cwd:find(root, 1, true) == 1 then
      return opts.parent and name
    else
      return opts.other and name
    end
  end

  return {
    function() return (opts.icon and opts.icon .. " ") .. get() end,
    cond = function() return type(get()) == "string" end,
    color = opts.color,
  }
end

function M.pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "Constant",
  }, opts or {})

  return function(self)
    local path = vim.fn.expand "%:p" --[[@as string]]

    if path == "" then return "" end
    local root = M.get { normalize = true }
    local cwd = M.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")
    if #parts > 3 then parts = { parts[1], "…", parts[#parts - 1], parts[#parts] } end

    if opts.modified_hl and vim.bo.modified then parts[#parts] = M.format(self, parts[#parts], opts.modified_hl) end

    return table.concat(parts, sep)
  end
end

return {
  --[[ {
    "MunifTanjim/nougat.nvim",
    config = function()
      local nougat = require "nougat"
      local core = require "nougat.core"
      local Bar = require "nougat.bar"
      local Item = require "nougat.item"
      local sep = require "nougat.separator"

      local nut = {
        buf = {
          diagnostic_count = require("nougat.nut.buf.diagnostic_count").create,
          filename = require("nougat.nut.buf.filename").create,
          filetype = require("nougat.nut.buf.filetype").create,
        },
        git = {
          branch = require("nougat.nut.git.branch").create,
          status = require "nougat.nut.git.status",
        },
        tab = {
          tablist = {
            tabs = require("nougat.nut.tab.tablist").create,
            close = require("nougat.nut.tab.tablist.close").create,
            icon = require("nougat.nut.tab.tablist.icon").create,
            label = require("nougat.nut.tab.tablist.label").create,
            modified = require("nougat.nut.tab.tablist.modified").create,
          },
        },
        mode = require("nougat.nut.mode").create,
        spacer = require("nougat.nut.spacer").create,
        truncation_point = require("nougat.nut.truncation_point").create,
      }

      ---@type nougat.color
      local color = require("nougat.color").get()

      local mode = nut.mode {
        sep_left = sep.left_half_circle_solid(true),
        sep_right = sep.right_half_circle_solid(true),
      }

      local filename = (function()
        local item = Item {
          prepare = function(_, ctx)
            local bufnr, data = ctx.bufnr, ctx.ctx
            data.readonly = vim.api.nvim_buf_get_option(bufnr, "readonly")
            data.modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable")
            data.modified = vim.api.nvim_buf_get_option(bufnr, "modified")
          end,
          sep_left = sep.left_half_circle_solid(true),
          content = {
            Item {
              hl = { bg = color.bg4, fg = color.fg },
              hidden = function(_, ctx) return not ctx.ctx.readonly end,
              suffix = " ",
              content = "RO",
            },
            Item {
              hl = { bg = color.bg4, fg = color.fg },
              hidden = function(_, ctx) return ctx.ctx.modifiable end,
              content = "",
              suffix = " ",
            },
            nut.buf.filename {
              hl = { bg = color.fg, fg = color.bg },
              prefix = function(_, ctx)
                local data = ctx.ctx
                if data.readonly or not data.modifiable then return " " end
                return ""
              end,
              suffix = function(_, ctx)
                local data = ctx.ctx
                if data.modified then return " " end
                return ""
              end,
            },
            Item {
              hl = { bg = color.bg4, fg = color.fg },
              hidden = function(_, ctx) return not ctx.ctx.modified end,
              prefix = " ",
              content = "+",
            },
          },
          sep_right = sep.right_half_circle_solid(true),
        }

        return item
      end)()

      local ruler = (function()
        local scroll_hl = {
          [true] = { bg = color.bg3 },
          [false] = { bg = color.bg4 },
        }

        local item = Item {
          content = {
            Item {
              hl = { bg = color.bg4 },
              sep_left = sep.left_half_circle_solid(true),
              content = core.group({
                core.code "l",
                ":",
                core.code "c",
              }, { align = "left", min_width = 8 }),
              suffix = " ",
            },
            Item {
              hl = function(_, ctx) return scroll_hl[ctx.is_focused] end,
              prefix = " ",
              content = core.code "P",
              sep_right = sep.right_half_circle_solid(true),
            },
          },
        }

        return item
      end)()

      -- renders space only when item is rendered
      ---@param item NougatItem
      local function paired_space(item)
        return Item {
          content = sep.space().content,
          hidden = item,
        }
      end

      local stl = Bar "statusline"
      stl:add_item(mode)
      stl:add_item(sep.space())
      stl:add_item(nut.git.branch {
        hl = { bg = color.magenta, fg = color.bg },
        sep_left = sep.left_half_circle_solid(true),
        prefix = " ",
        sep_right = sep.right_half_circle_solid(true),
      })
      stl:add_item(sep.space())
      local gitstatus = stl:add_item(nut.git.status.create {
        hl = { fg = color.bg },
        sep_left = sep.left_half_circle_solid(true),
        content = {
          nut.git.status.count("added", {
            hl = { bg = color.green },
            prefix = "+",
            suffix = function(_, ctx) return (ctx.gitstatus.changed > 0 or ctx.gitstatus.removed > 0) and " " or "" end,
          }),
          nut.git.status.count("changed", {
            hl = { bg = color.blue },
            prefix = function(_, ctx) return ctx.gitstatus.added > 0 and " ~" or "~" end,
            suffix = function(_, ctx) return ctx.gitstatus.removed > 0 and " " or "" end,
          }),
          nut.git.status.count("removed", {
            hl = { bg = color.red },
            prefix = function(_, ctx) return (ctx.gitstatus.added > 0 or ctx.gitstatus.changed > 0) and " -" or "-" end,
          }),
        },
        sep_right = sep.right_half_circle_solid(true),
      })
      stl:add_item(paired_space(gitstatus))
      stl:add_item(filename)
      stl:add_item(sep.space())
      stl:add_item(nut.spacer())
      stl:add_item(nut.truncation_point())
      stl:add_item(nut.buf.filetype {
        hl = { bg = color.blue, fg = color.bg },
        sep_left = sep.left_half_circle_solid(true),
        sep_right = sep.right_half_circle_solid(true),
      })
      stl:add_item(sep.space())
      local diagnostic_count = stl:add_item(nut.buf.diagnostic_count {
        hl = { bg = color.bg4 },
        sep_left = sep.left_half_circle_solid(true),
        sep_right = sep.right_half_circle_solid(true),
        config = {
          error = { prefix = " " },
          warn = { prefix = " " },
          info = { prefix = " " },
          hint = { prefix = "󰌶 " },
        },
      })
      stl:add_item(paired_space(diagnostic_count))
      stl:add_item(ruler)
      stl:add_item(sep.space())

      local stl_inactive = Bar "statusline"
      stl_inactive:add_item(mode)
      stl_inactive:add_item(sep.space())
      stl_inactive:add_item(filename)
      stl_inactive:add_item(sep.space())
      stl_inactive:add_item(nut.spacer())
      stl_inactive:add_item(ruler)
      stl_inactive:add_item(sep.space())

      nougat.set_statusline(function(ctx) return ctx.is_focused and stl or stl_inactive end)

      local tal = Bar "tabline"

      tal:add_item(nut.tab.tablist.tabs {
        active_tab = {
          hl = { bg = color.bg, fg = color.blue },
          prefix = " ",
          suffix = " ",
          content = {
            nut.tab.tablist.icon { suffix = " " },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = " ", config = { text = "●" } },
            nut.tab.tablist.close { prefix = " ", config = { text = "󰅖" } },
          },
          sep_left = sep.left_half_circle_solid { bg = "bg", fg = color.bg },
          sep_right = sep.right_half_circle_solid { bg = "bg", fg = color.bg },
        },
        inactive_tab = {
          hl = { bg = color.bg2, fg = color.fg2 },
          prefix = " ",
          suffix = " ",
          content = {
            nut.tab.tablist.icon { suffix = " " },
            nut.tab.tablist.label {},
            nut.tab.tablist.modified { prefix = " ", config = { text = "●" } },
            nut.tab.tablist.close { prefix = " ", config = { text = "󰅖" } },
          },
          sep_left = sep.left_half_circle_solid { bg = "bg", fg = color.bg2 },
          sep_right = sep.right_half_circle_solid { bg = "bg", fg = color.bg2 },
        },
      })

      nougat.set_tabline(tal)
    end,
  }, ]]
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require "lualine_require"
      lualine_require.require = require
      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "starter" } },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                return table.concat(vim.tbl_map(function(word) return word:sub(1, 1) end, vim.split(mode, " ")))
              end,
            },
          },
          lualine_b = { "branch" },
          lualine_c = {
            M.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { M.pretty_path() },
          },
          lualine_x = {},
          lualine_y = {
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = M.fg "Statement",
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = M.fg "Constant",
            },
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = M.fg "Debug",
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = M.fg "Special",
            },
            {
              "diff",
              symbols = {
                added = "󰐗 ",
                modified = "󰻂 ",
                removed = "󰅙 ",
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
}
