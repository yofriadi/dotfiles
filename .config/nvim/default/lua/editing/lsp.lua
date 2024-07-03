local SEVERITY = {
  NONE = 0,
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  HINT = 4,
  ALL = 5,
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
---@param severity (1 | 2 | 3 | 4 | 5) # One of vim.diagnostic.severity.
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

local formatting_enabled = function(client)
  local disabled = opts.formatting.disabled
  return client.supports_method "textDocument/formatting"
    and disabled ~= true
    and not vim.tbl_contains(disabled, client.name)
end

return {
  "m-demare/hlargs.nvim",
  "zeioth/garbage-day.nvim",
  -- "artemave/workspace-diagnostics.nvim",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "AstroNvim/astrolsp",
    lazy = true,
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        features = {
          autoformat = true,
          codelens = true,
          inlay_hints = false,
          semantic_tokens = true,
        },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        config = { lua_ls = { settings = { Lua = { workspace = { checkThirdParty = false } } } } },
        flags = {},
        formatting = { format_on_save = { enabled = true }, disabled = {} },
        handlers = {
          function(server, server_opts)
            require("lspconfig")[server].setup(server_opts)
          end,
        },
        lsp_handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", silent = true }),
          ["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = "rounded", silent = true }
          ),
        },
        servers = {},
        on_attach = nil,
        commands = {
          Format = {
            cond = function(client)
              local formatting_disabled = vim.tbl_get(require("astrolsp").config, "formatting", "disabled")
              return client.supports_method "textDocument/formatting"
                and formatting_disabled ~= true
                and not vim.tbl_contains(formatting_disabled, client.name)
            end,
            function() vim.lsp.buf.format(require("astrolsp").format_opts) end,
            desc = "Format file with LSP",
          },
        },
        autocmds = {
          lsp_codelens_refresh = {
            cond = "textDocument/codeLens",
            {
              event = { "InsertLeave", "BufEnter" },
              desc = "Refresh codelens (buffer)",
              callback = function(args)
                if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
              end,
            },
          },
          lsp_auto_format = {
            cond = formatting_enabled,
            {
              event = "BufWritePre",
              desc = "autoformat on save",
              callback = function(_, _, bufnr)
                local astrolsp = require "astrolsp"
                local autoformat = assert(astrolsp.config.formatting.format_on_save)
                local buffer_autoformat = vim.b[bufnr].autoformat
                if buffer_autoformat == nil then buffer_autoformat = autoformat.enabled end
                if buffer_autoformat and ((not autoformat.filter) or autoformat.filter(bufnr)) then
                  vim.lsp.buf.format(vim.tbl_deep_extend("force", astrolsp.format_opts, { bufnr = bufnr }))
                end
              end,
            },
          },
        },
        mappings = {
          n = {
            ["K"] = { vim.lsp.buf.hover, cond = "textDocument/hover", desc = "LSP hover symbol details" },
            ["gd"] = { vim.lsp.buf.definition, cond = "textDocument/definition", desc = "LSP definition of current symbol" },
            ["gD"] = { vim.lsp.buf.declaration, cond = "textDocument/declaration", desc = "LSP declaration of current symbol" },
            ["gI"] = { vim.lsp.buf.implementation, cond = "textDocument/implementation", desc = "LSP implementation of current symbol" },
            ["gy"] = { vim.lsp.buf.type_definition, cond = "textDocument/typeDefinition", desc = "LSP definition of current type" },
            ["<Leader>la"] = { vim.lsp.buf.code_action, cond = "testDocument/codeAction", desc = "LSP code action" },
            ["<Leader>ll"] = { vim.lsp.codelens.refresh, cond = "textDocument/codeLens", desc = "LSP CodeLens refresh" },
            ["<Leader>lL"] = { vim.lsp.codelens.run, cond = "textDocument/codeLens", desc = "LSP CodeLens run" },
            ["<Leader>lf"] = { function() vim.lsp.buf.format(require("astrolsp").format_opts) end, cond = formatting_enabled, desc = "LSP format buffer" },
            ["<Leader>lR"] = { vim.lsp.buf.references, cond = "textDocument/references", desc = "LSP search references" },
            ["<Leader>lr"] = { vim.lsp.buf.rename, cond = "textDocument/rename", desc = "LSP rename current symbol" },
            ["<Leader>lh"] = { vim.lsp.buf.signature_help, cond = "textDocument/signatureHelp", desc = "LSP signature help" },
            ["<Leader>lG"] = { vim.lsp.buf.workspace_symbol, cond = "workspace/symbol", desc = "LSP search workspace symbols" },
            ["<Leader>tf"] = { require("astrolsp.toggles").buffer_autoformat, cond = formatting_enabled, desc = "Toggle LSP buffer autoformatting" },
            ["<Leader>tF"] = { require("astrolsp.toggles").autoformat, cond = formatting_enabled, desc = "Toggle LSP autoformatting" },
            ["<Leader>tL"] = { require("astrolsp.toggles").codelens, cond = "textDocument/codeLens", desc = "Toggle LSP CodeLens" },
            ["<Leader>th"] = { require("astrolsp.toggles").buffer_inlay_hints, cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false, desc = "Toggle LSP buffer inlay hints" },
            ["<Leader>tH"] = { require("astrolsp.toggles").inlay_hints, cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false, desc = "Toggle LSP inlay hints" },
            ["<Leader>tY"] = { require("astrolsp.toggles").buffer_semantic_tokens, cond = function(client) return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens end, desc = "Toggle LSP buffer semantic highlight" },
            --[""] = { , cond = "", desc = "LSP " },
          },
          v = {
            ["<Leader>lf"] = { function() vim.lsp.buf.format(require("astrolsp").format_opts) end, cond = formatting_enabled, desc = "LSP format buffer" },
          },
          x = {
            ["<Leader>la"] = { vim.lsp.buf.code_action, cond = "testDocument/codeAction", desc = "LSP code action" },
          },
        },
      } --[[@as AstroLSPOpts]])
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>li"] =
            { "<Cmd>LspInfo<CR>", desc = "LSP information", cond = function() return vim.fn.exists ":LspInfo" > 0 end }
        end,
      },
      { "folke/neoconf.nvim", lazy = true, opts = {} },
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        cmd = { "LspInstall", "LspUninstall" },
        init = function(plugin) require("astrocore").on_load("mason.nvim", plugin.name) end,
        opts_extend = { "ensure_installed" },
        opts = {
          ensure_installed = {},
          handlers = { function(server) require("astrolsp").lsp_setup(server) end },
        },
      },
    },
    cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
      if require("lazy.core.config").spec.plugins["neoconf.nvim"] then table.insert(cmds, "Neoconf") end
      vim.list_extend(cmds, { "LspInfo", "LspLog", "LspStart" }) -- add normal `nvim-lspconfig` commands
    end,
    event = "User AstroFile",
    config = function()
      local setup_servers = function()
        vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
        require("astrocore").exec_buffer_autocmds("FileType", { group = "lspconfig" })

        require("astrocore").event "LspSetup"
      end
      local astrocore = require "astrocore"
      if astrocore.is_available "mason-lspconfig.nvim" then
        astrocore.on_load("mason-lspconfig.nvim", setup_servers)
      else
        setup_servers()
      end
    end
  },
  {
    "nvimtools/none-ls.nvim",
    main = "null-ls",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>lI"] = {
            "<Cmd>NullLsInfo<CR>",
            desc = "Null-ls information",
            cond = function() return vim.fn.exists ":NullLsInfo" > 0 end,
          }
        end,
      },
      {
        "jay-babu/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim" },
        cmd = { "NullLsInstall", "NullLsUninstall" },
        init = function(plugin) require("astrocore").on_load("mason.nvim", plugin.name) end,
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = {}, handlers = {} },
      },
    },
    event = "User AstroFile",
    opts = function() return { on_attach = require("astrolsp").on_attach } end,
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
        function() set_diagnostics_severity(5) end,
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
            --["not"] = { conceal = "" },
            ["if"] = { conceal = "?" },
            ["else"] = { conceal = "!" },
            ["elseif"] = { conceal = "¿" },
            ["for"] = { conceal = "" },
            ["then"] = { conceal = "↙" },
            ["or"] = { conceal = "|" },
            ["and"] = { conceal = "&" },
            ["end"] = { conceal = "" },
            ["require"] = { conceal = "" },
            ["do"] = { conceal = "󱞭" },
            ["vim.cmd"] = { conceal = "" },
          },
        },
      }
      conceal.generate_conceals()
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  { "dmmulroy/ts-error-translator.nvim", opts = {} },
  { "brenoprata10/nvim-highlight-colors", opts = {} },
}
