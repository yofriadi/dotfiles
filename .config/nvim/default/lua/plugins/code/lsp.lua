local M = {}
M.signs = {
  { name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError" },
  { name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticSignWarn" },
  { name = "DiagnosticSignHint", text = "󰌵", texthl = "DiagnosticSignHint" },
  { name = "DiagnosticSignInfo", text = "󰋼", texthl = "DiagnosticSignInfo" },
  { name = "DapStopped", text = "󰁕", texthl = "DiagnosticWarn" },
  { name = "DapBreakpoint", text = "", texthl = "DiagnosticInfo" },
  { name = "DapBreakpointRejected", text = "", texthl = "DiagnosticError" },
  { name = "DapBreakpointCondition", text = "", texthl = "DiagnosticInfo" },
  { name = "DapLogPoint", text = ".>", texthl = "DiagnosticInfo" },
}
M.servers = {
  jsonls = {},
  yamlls = {},
  lua_ls = {
    -- keys = {}, -- for specific lsp servers
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT"
        },
        diagnostics = {
          globals = { "vim" }
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
}
M.on_attach = function ()
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = 'LSP actions',
    callback = function()
      -- Below is keyamps for supported client that have lsp textDocument method that not checked, like
      -- local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- client.supports_method("textDocument/inlayHint")
      -- list of method: codeAction, codeLens, declaration
      --textDocument/formatting not setup here

      local ck = require("caskey")
      ck.setup({
        {
          mode = "n",
          ["K"] = { act = function() vim.lsp.buf.hover() end, desc = "LSP hover symbol details" },
          ["gd"] = { act = function() vim.lsp.buf.definition() end, desc = "LSP definition of current symbol" },
          ["gD"] = { act= function() vim.lsp.buf.type_definition() end, desc = "Definition of current type" },
          --["gD"] = { act = function() vim.lsp.buf.declaration() end, desc = "LSP declaration of current symbol" },
          ["gr"] = { act = function() vim.lsp.buf.references() end, desc = "LSP references of current symbol" },
          ["[d"] = { act = function() vim.diagnostic.goto_prev() end, desc = "LSP previous diagnostic" },
          ["]d"] = { act = function() vim.diagnostic.goto_next() end, desc = "LSP next diagnostic" },
          ["<Leader>ld"] = { act = function() vim.diagnostic.open_float() end, desc = "LSP hover diagnostics" },
          ["<Leader>la"] = { act = function() vim.lsp.buf.code_action() end, desc = "LSP code action" },
          ["<Leader>lA"] = { -- NOTE: check if this any work
            act = function()
              vim.lsp.buf.code_action({
                context = {
                  only = { "source" },
                  diagnostics = {},
                },
              })
            end,
            desc = "LSP source action",
          },
          -- NOTE: check if code lens below any work
          ["<Leader>ll"] = { act = function() vim.lsp.codelens.refresh() end, desc = "LSP CodeLens refresh" },
          ["<Leader>lL"] = { act = function() vim.lsp.codelens.run() end, desc = "LSP CodeLens run" },
          ["<Leader>lR"] = { act = function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },
          ["<leader>lh"] = { act = function() vim.lsp.buf.signature_help() end, desc = "Signature help" },
        },
        {
          mode = "v",
          ["<Leader>la"] = {
            act = function() vim.lsp.buf.code_action() end,
            desc = "LSP code action",
            mode = "v",
          }
        }
      })

      --[[ local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if client.supports_method("textDocument/inlayHint") then
        inlay_hint(buffer, true)
      end ]]

      local utils = require("utils")

      if utils.is_available("telescope.nvim") then
        local tsb = require("telescope.builtin")
        ck.setup({
          mode = "n",
          ["<Leader>lr"] = {
            act = function() tsb.lsp_references({ jump_type = "never" }) end,
            desc = "LSP Search references of current symbol",
          },
          ["<Leader>lD"] = {
            act = function() tsb.lsp_definitions({ jump_type = "never", reuse_win = true }) end,
            desc = "Definition of current symbol",
          },
          ["<Leader>li"] = {
            act = function() tsb.lsp_implementations({ reuse_win = true }) end,
            desc = "Implementation of current symbol",
          },
          ["<Leader>sd"] = {
            act = function () tsb.diagnostics({ bufnr = 0 }) end,
            desc = "Search document diagnostics",
          },
          ["<Leader>sD"] = {
            act = function () tsb.diagnostics() end,
            desc = "Search workspace diagnostics",
          },
          --[[ ["<leader>lq"] = { act = function () vim.lsp.buf.workspace_symbol() end, desc = "Search symbols" },
          ["<leader>lQ"] = {
            act = function()
              vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" },
                function(query)
                  if query then
                    if query == "" then query = vim.fn.expand "<cword>" end
                    tsb.lsp_workspace_symbols({ query = query, prompt_title = ("Find word (%s)"):format(query) })
                  end
                end
              )
            end,
            desc = "Search symbols",
          }, ]]
        })
      end

      if utils.is_available("mason-lspconfig.nvim") then
          ck.setup({ ["<Leader>lI"] = { act = "<Cmd>LspInfo<CR>", desc = "LSP information" } })
      end

      if utils.is_available("null-ls.nvim") then
          ck.setup({ ["<Leader>lN"] = { act = "<Cmd>NullLsInfo<CR>", desc = "Null-ls information" } })
      end
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "b0o/SchemaStore.nvim",
          "hrsh7th/cmp-nvim-lsp"
        },
        config = function ()
          local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
              capabilities = vim.tbl_deep_extend(
                "force",
                {
                  textDocument = {
                    foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
                  }
                },
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
              ),
            }, M.servers[server])

            if server == "jsonls" then
              server_opts.settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true }
                }
              }
            end

            if server == "yamlls" then
              server_opts.settings = {
                yaml = {
                  schemaStore = { enable = false, url = "" },
                  schemas = require("schemastore").yaml.schemas(),
                }
              }
            end

            require("lspconfig")[server].setup(server_opts)
          end

          local ensure_installed = {}
          for server, server_opts in pairs(M.servers) do
            if server_opts then
              ensure_installed[#ensure_installed + 1] = server
            end
          end
          require("mason-lspconfig").setup({ ensure_installed = ensure_installed, handlers = { setup } })
        end
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
        signs = { active = M.signs },
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
    config = function (_, opts)
      vim.diagnostic.config(opts.diagnostics)
      M.on_attach()
    end
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          -- linter
          "luacheck",
          "golangci_lint",
          "staticcheck",

          -- formatter
          "stylua",
          "gofumpt",
          "goimports",
          "goimports-reviser",
          "golines",
          "gomodifytags",
        },
        automatic_installation = false,
        handlers = {},
      })
      require("null-ls").setup({
          sources = {
              -- Anything not supported by mason.
          }
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll",
    },
    build = ":MasonUpdate",
    config = function ()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_uninstalled = "✗",
            package_pending = "⟳",
          },
        },
      })

      local notif = require("utils.notif")
      local cmd = vim.api.nvim_create_user_command
      cmd("MasonUpdate", function(options)
        --require("astronvim.utils.mason").update(options.fargs)
        local pkg_names = options.fargs
        if type(pkg_names) == "string" then pkg_names = { pkg_names } end
        local auto_install = true
        local registry_avail, registry = pcall(require, "mason-registry")
        if not registry_avail then
          vim.api.nvim_err_writeln "Unable to access mason registry"
          return
        end

        registry.update(vim.schedule_wrap(function(success, updated_registries)
          if success then
            local count = #updated_registries
            if vim.tbl_count(pkg_names) == 0 then
              notif.notify(("Successfully updated %d %s."):format(count, count == 1 and "registry" or "registries"),
                { title = "Mason"})
            end
            for _, pkg_name in ipairs(pkg_names) do
              local pkg_avail, pkg = pcall(registry.get_package, pkg_name)
              if not pkg_avail then
                notif.notify(("`%s` is not available"):format(pkg_name), { title = "Mason", level = vim.log.levels.ERROR })
              else
                if not pkg:is_installed() then
                  if auto_install then
                    notif.notify(("Installing `%s`"):format(pkg.name))
                    pkg:install()
                  else
                    notif.notify(("`%s` not installed"):format(pkg.name), { title = "Mason", level = vim.log.levels.WARN })
                  end
                else
                  pkg:check_new_version(function(update_available, version)
                    if update_available then
                      notif.notify(("Updating `%s` to %s"):format(pkg.name, version.latest_version), { title = "Mason" })
                      pkg:install():on("closed", function() notif.notify(("Updated %s"):format(pkg.name), { title = "Mason" }) end)
                    else
                      notif.notify(("No updates available for `%s`"):format(pkg.name), { title = "Mason" })
                    end
                  end)
                end
              end
            end
          else
            notif.notify(("Failed to update registries: %s"):format(updated_registries), { title = "Mason", level = vim.log.levels.ERROR })
          end
        end))
      end, {
        nargs = "*",
        desc = "Update Mason Package",
        complete = function(arg_lead)
          local _ = require("mason-core.functional")
          return _.sort_by(_.identity, _.filter(_.starts_with(arg_lead), require("mason-registry").get_installed_package_names())
          )
        end,
      })

      cmd(
        "MasonUpdateAll",
        function()
          local registry_avail, registry = pcall(require, "mason-registry")
          if not registry_avail then
            vim.api.nvim_err_writeln("Unable to access mason registry")
            return
          end

          notif.notify("Checking for package updates...", { title = "Mason" })
          registry.update(vim.schedule_wrap(function(success, updated_registries)
            if success then
              local installed_pkgs = registry.get_installed_packages()
              local running = #installed_pkgs
              local no_pkgs = running == 0

              if no_pkgs then
                notif.notify("No updates available", { title = "Mason" })
              else
                local updated = false
                for _, pkg in ipairs(installed_pkgs) do
                  pkg:check_new_version(function(update_available, version)
                    if update_available then
                      updated = true
                      notif.notify(("Updating `%s` to %s"):format(pkg.name, version.latest_version))
                      pkg:install():on("closed", function()
                        running = running - 1
                        if running == 0 then
                          notif.notify "Update Complete"
                        end
                      end)
                    else
                      running = running - 1
                      if running == 0 then
                        if updated then
                          notif.notify("Update Complete", { title = "Mason" })
                        else
                          notif.notify("No updates available", { title = "Mason" })
                        end
                      end
                    end
                  end)
                end
              end
            else
              notif.notify(("Failed to update registries: %s"):format(updated_registries),
                { title = "Mason", level = vim.log.levels.ERROR })
            end
          end))
        end,
        { desc = "Update Mason Packages" }
      )
    end
  },
}
