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
        float = true,
        signs = true,
      },
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = { enable = false, url = "" },
            },
          },
        },
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
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            --{ "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        --[[ obsidian_ls = {
          default_config = {
            root_dir = function()
              return vim.fn.getcwd()
            end,
            filetypes = { "markdown" },
            cmd = { "{path}" }, -- replace {path} with the path to the --release build.
            -- {path} will be {where ever you cloned from}/obsidian-ls/target/release/markdown-oxide
          },
          --on_attach = on_attach, -- do this only if you have an on_attach function already
        }, ]]
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        marksman = {},
      },
      server_setup = {
        gopls = function()
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          local on_attach = function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end

          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local buffer = args.buf ---@type number
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              on_attach(client, buffer)
            end,
          })
        end,
      },
    },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "b0o/SchemaStore.nvim",
          "hrsh7th/cmp-nvim-lsp",
        },
        cmd = { "LspInstall", "LspUninstall", "LspInfo" },
        keys = {
          { "<Leader>lI", "<Cmd>LspInfo<CR>", desc = "LSP information" },
        },
      },
    },
    keys = function()
      local lsp = vim.lsp
      return {
        { "<Leader>lR", lsp.buf.rename, desc = "Rename current symbol" },
        { "K", lsp.buf.hover, desc = "LSP hover symbol details" },
        { "gd", lsp.buf.definition, desc = "LSP go to definition" },
        { "gD", lsp.buf.declaration, desc = "LSP go to declaration" },
        { "gi", lsp.buf.implementation, desc = "LSP go to implementation" },
        { "gt", lsp.buf.type_definition, desc = "LSP go to type definition" },
        { "[d", vim.diagnostic.goto_prev, desc = "LSP previous diagnostic" },
        { "]d", vim.diagnostic.goto_next, desc = "LSP next diagnostic" },
        { "<Leader>ld", vim.diagnostic.open_float, desc = "LSP hover diagnostics" },
        { "<Leader>la", lsp.buf.code_action, desc = "LSP code action" },
        {
          "<Leader>lA",
          function()
            lsp.buf.code_action({
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end,
          desc = "LSP source action",
        },
        { "<Leader>ll", lsp.codelens.refresh, desc = "LSP CodeLens refresh" },
        { "<Leader>lL", lsp.codelens.run, desc = "LSP CodeLens run" },
        { "<leader>lh", lsp.buf.signature_help, desc = "Signature help" },
      }
    end,
    config = function(_, opts)
      local signs = { Error = "", Warn = "", Info = "", Hint = "󰌵" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config(opts.diagnostics)

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.tbl_deep_extend("force", {
            textDocument = {
              foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
            },
          }, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities()),
        }, opts.servers[server])

        if opts.server_setup[server] then
          if opts.server_setup[server](server, server_opts) then
            return
          end
        elseif opts.server_setup["*"] then
          if opts.server_setup["*"](server, server_opts) then
            return
          end
        end

        require("lspconfig")[server].setup(server_opts)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          ensure_installed[#ensure_installed + 1] = server
        end
      end
      require("mason-lspconfig").setup({ ensure_installed = ensure_installed, handlers = { setup } })
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
          --local formatting = require("null-ls").builtins.formatting
          --local diagnostics = require("null-ls").builtins.diagnostics
          local completion = require("null-ls").builtins.completion
          --local code_actions = require("null-ls").builtins.code_actions

          require("null-ls").setup({
            sources = {
              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
              --formatting.stylua,
              --formatting.goimports,
              --formatting.gofumpt,

              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
              --diagnostics.golangci_lint,

              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/completion
              completion.spell,

              -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
              --code_actions.gomodifytags,
              --code_actions.impl,
            },
          })
        end,
      },
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          -- linter
          "selene", -- lua
          "golangci_lint",
          "staticcheck", -- golang
          "hadolint", -- docker
          "markdownlint", -- markdown
          "marksman", -- markdown

          -- formatter
          "stylua",
          "gofumpt",
          "goimports",
          "goimports-reviser",
          "golines",
          "gomodifytags",
          "impl", -- golang
          "prettierd",
        },
        automatic_installation = true,
        handlers = {},
      })
      require("null-ls").setup({
        sources = {
          -- Anything not supported by mason.
        },
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  { "folke/neodev.nvim", opts = {} },
  --'WhoIsSethDaniel/mason-tool-installer.nvim'
}
