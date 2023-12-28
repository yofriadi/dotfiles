return {
  "zeioth/garbage-day.nvim",
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
        --signs = { active = M.signs },
        float = {
          focused = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
    },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "b0o/SchemaStore.nvim",
          "hrsh7th/cmp-nvim-lsp",
        },
        cmd = { "LspInstall", "LspUninstall" },
        keys = {
          {
            "<Leader>lI",
            "<Cmd>LspInfo<CR>",
            desc = "LSP information",
          },
        },
        opts = {
          servers = {
            jsonls = {},
            yamlls = {},
            lua_ls = {
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                  },
                  completion = {
                    callSnippet = "Replace",
                  },
                },
              },
            },
            gopls = {},
            dockerls = {},
            docker_compose_language_service = {},
            marksman = {},
          },
        },
        config = function(_, opts)
          local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
              capabilities = vim.tbl_deep_extend("force", {
                textDocument = {
                  foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
                },
              }, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities()),
            }, opts.servers[server])

            if server == "jsonls" then
              server_opts.settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              }
            end

            if server == "yamlls" then
              server_opts.settings = {
                yaml = {
                  schemaStore = { enable = false, url = "" },
                  schemas = require("schemastore").yaml.schemas(),
                },
              }
            end

            require("lspconfig")[server].setup(server_opts)
          end

          local ensure_installed = {}
          for server, server_opts in pairs(opts.servers) do
            if server_opts then ensure_installed[#ensure_installed + 1] = server end
          end
          require("mason-lspconfig").setup { ensure_installed = ensure_installed, handlers = { setup } }
        end,
      },
    },
    config = function(_, opts) vim.diagnostic.config(opts.diagnostics) end,
    keys = function()
      local lsp = vim.lsp
      return {
        { "<Leader>lR", lsp.buf.rename, desc = "Rename current symbol" },
        { "K", lsp.buf.hover, desc = "LSP hover symbol details" },
        { "gd", lsp.buf.definition, desc = "LSP definition of current symbol" },
        { "gD", lsp.buf.type_definition, desc = "Definition of current type" },
        --{"gD", lsp.buf.declaration, desc = "LSP declaration of current symbol" },
        { "gr", lsp.buf.references, desc = "LSP references of current symbol" },
        { "[d", vim.diagnostic.goto_prev, desc = "LSP previous diagnostic" },
        { "]d", vim.diagnostic.goto_next, desc = "LSP next diagnostic" },
        { "<Leader>ld", vim.diagnostic.open_float, desc = "LSP hover diagnostics" },
        { "<Leader>la", lsp.buf.code_action, desc = "LSP code action" },
        {
          "<Leader>lA",
          function()
            lsp.buf.code_action {
              context = {
                only = { "source" },
                diagnostics = {},
              },
            }
          end,
          desc = "LSP source action",
        },
        -- NOTE: check if code lens below any work
        { "<Leader>ll", lsp.codelens.refresh, desc = "LSP CodeLens refresh" },
        { "<Leader>lL", lsp.codelens.run, desc = "LSP CodeLens run" },
        { "<Leader>lR", lsp.buf.rename, desc = "Rename current symbol" },
        { "<leader>lh", lsp.buf.signature_help, desc = "Signature help" },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      {
        "nvimtools/none-ls.nvim",
        keys = {
          { "<Leader>lN", "<Cmd>NullLsInfo<CR>", desc = "Null-ls information" },
        },
        config = function()
          local null_ls = require "null-ls"
          null_ls.setup {
            sources = {
              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
              --null_ls.builtins.formatting.stylua,

              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
              --null_ls.builtins.diagnostics.golangci_lint,

              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/completion
              null_ls.builtins.completion.spell,

              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
              --null_ls.builtins.code_actions.gomodifytags,
              null_ls.builtins.code_actions.impl,
            },
          }
        end,
      },
    },
    config = function()
      require("mason-null-ls").setup {
        ensure_installed = {
          -- linter
          "luacheck",
          "golangci_lint",
          "staticcheck", -- golang
          "hadolint", -- docker

          -- formatter
          "stylua",
          "gofumpt",
          "goimports",
          "goimports-reviser",
          "golines",
          "gomodifytags",
          "prettierd",
        },
        automatic_installation = false,
        handlers = {},
      }
      require("null-ls").setup {
        sources = {
          -- Anything not supported by mason.
        },
      }
    end,
  },
}
