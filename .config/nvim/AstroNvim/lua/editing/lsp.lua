local SEVERITY = {
  NONE = 0,
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  HINT = 4,
  ALL = 10,
}

vim.api.nvim_create_user_command("SetMinDiagnosticsSeverity", function(ctx)
  local severity = SEVERITY[ctx.args]

  require("ds_omega.layers.Lsp.handlers.filter_diagnostics_by_severity.utils").set_minimum_diagnostics_severity(
    severity
  )
end, {
  nargs = 1,
  complete = function() return vim.tbl_keys(SEVERITY) end,
})

local function filter_diagnostics_by_severity(diagnostics, severity)
  local filtered_diagnostics = {}

  for _, diagnostic in ipairs(diagnostics) do
    -- The most severe is 1, the least - 4, so even though we are filtering for
    -- minimum severity, the comparison is negated.
    if diagnostic.severity <= severity then
      -- preprend?
      table.insert(filtered_diagnostics, 1, diagnostic)
    end
  end

  return filtered_diagnostics
end

local original_handler = vim.diagnostic.handlers.virtual_text
local ns = vim.api.nvim_create_namespace "my_diagnostics"

---
---@param severity (1 | 2 | 3 | 4 | 10) # One of vim.diagnostic.severity.
---@example
----- Show only errors.
--set_diagnostics_severity(vim.diagnostic.severity.ERROR)
----- Show only errors and warnings.
--set_diagnostics_severity(vim.diagnostic.severity.WARN)
local function set_diagnostics_severity(severity)
  --[[
  vim.diagnostic.*() invokes all handlers, virtual_text is one of them.

  1. Use original handlers' to hide **all** diagnostics.
  2. Override handlers' show and hide to show_new and hide_new.
  3. Use show handlers with now overriden show_new.

    Next time we use this function, handlers have hide_new
  so step 1 will invoke hide only diagnostics from our namespace.
  --]]

  local bufnr = vim.api.nvim_get_current_buf()

  -- Hide original lsp diagnostics.
  vim.diagnostic.hide(nil, bufnr)

  vim.diagnostic.handlers.virtual_text = {
    show = function(_, bufnr, _, opts)
      local diagnostics = vim.diagnostic.get(bufnr)
      local filtered_diagnostics = filter_diagnostics_by_severity(diagnostics, severity)

      original_handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,

    hide = function(_, bufnr) original_handler.hide(ns, bufnr) end,
  }

  local diagnostics = vim.diagnostic.get(bufnr)

  if #diagnostics == 0 then return end

  local filtered_diagnostics = filter_diagnostics_by_severity(diagnostics, severity)
  vim.diagnostic.show(ns, bufnr, filtered_diagnostics)
end

---@type LazySpec
return {
  "m-demare/hlargs.nvim",
  "zeioth/garbage-day.nvim",
  "artemave/workspace-diagnostics.nvim",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    keys = {
      {
        "<Leader>tdv",
        function() vim.diagnostic.config { virtual_text = not require("lsp_lines").toggle() } end,
        desc = "Toggle virtual diagnostic lines",
      },
      {
        "<Leader>tde",
        function() set_diagnostics_severity(1) end,
        desc = "Set minimum diagnostics severity level to ERROR",
      },
      {
        "<Leader>tdw",
        function() set_diagnostics_severity(2) end,
        desc = "Set minimum diagnostics severity level to WARN",
      },
      {
        "<Leader>tdi",
        function() set_diagnostics_severity(3) end,
        desc = "Set minimum diagnostics severity level to INFO",
      },
      {
        "<Leader>tdh",
        function() set_diagnostics_severity(4) end,
        desc = "Set minimum diagnostics severity level to HINT",
      },
      {
        "<Leader>tda",
        function() set_diagnostics_severity(10) end,
        desc = "Set minimum diagnostics severity level to ALL",
      },
    },
    config = function()
      local lsp_lines = require "lsp_lines"
      -- Disable the plugin in Lazy.nvim
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lazy",
        callback = function()
          local previous = not lsp_lines.toggle()
          if not previous then lsp_lines.toggle() end
        end,
      })

      lsp_lines.setup()
    end,
  },
  {
    "Jxstxs/conceal.nvim",
    dependencies = { "nvim-treesitter" },
    config = function()
      local conceal = require "conceal"
      conceal.setup {
        ["c"] = { enabled = false },
        ["python"] = { enabled = false },
        ["lua"] = {
          enabled = true,
          keywords = {
            ["local"] = { conceal = "~" },
            ["return"] = { conceal = "󱞱" },
            ["function"] = { conceal = "󰊕" },
            ["if"] = { conceal = "?" },
            ["else"] = { conceal = "!" },
            ["elseif"] = { conceal = "¿" },
            ["for"] = { conceal = "" },
            ["then"] = { conceal = "↙" },
            ["and"] = { conceal = "󰣡" },
            ["end"] = { conceal = "" },
            ["require"] = { conceal = "" },
            ["do"] = { conceal = "󱞭" },
            ["vim.cmd"] = { conceal = "" },
            --[""] = { conceal = "" },
          },
        },
      }
      conceal.generate_conceals()
    end,
  },
}
