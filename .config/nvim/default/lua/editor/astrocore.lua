---@type LazySpec
-- Configuration documentation can be found with `:h astrocore`
return {
  "AstroNvim/astrocore",
  dependencies = { "AstroNvim/astroui" },
  lazy = false,
  priority = 10000,
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local get_icon = require("astroui").get_icon
    return require("astrocore").extend_tbl(opts, {
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files
        autopairs = true, -- enable autopairs at start
        cmp = true, -- enable completion at start
        diagnostics_mode = 3, -- enable diagnostics by default
        highlighturl = true, -- highlight URLs by default
        notifications = true, -- disable notifications
      },
      diagnostics = {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = get_icon "DiagnosticError",
            [vim.diagnostic.severity.HINT] = get_icon "DiagnosticHint",
            [vim.diagnostic.severity.WARN] = get_icon "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = get_icon "DiagnosticInfo",
          },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focused = false,
          style = "minimal",
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
        -- TODO: remove check when dropping support for neovim v0.10
        jump = vim.fn.has "nvim-0.11" == 1 and { float = true } or nil,
      },
      rooter = {
        enabled = true,
        detector = { "lsp", { ".git", "_darcs", ".hg", ".bzr", ".svn" }, { "lua", "MakeFile", "package.json" } },
        ignore = {
          servers = {},
          dirs = {},
        },
        autochdir = false,
        scope = "global",
        notify = false,
      },
      sessions = {
        autosave = { last = true, cwd = true },
        ignore = {
          dirs = {},
          filetypes = { "gitcommit", "gitrebase" },
          buftypes = {},
        },
      },
    } --[[@as AstroCoreOpts]])
  end,
}
