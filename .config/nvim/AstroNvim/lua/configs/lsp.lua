-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        diagnostics = {
          virtual_text = true,
          underline = true,
        },
      })
    end,
  },
  {
    "AstroNvim/astrolsp",
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        features = { -- Configuration table of features provided by AstroLSP
          autoformat = true, -- enable or disable auto formatting on start
          codelens = true, -- enable/disable codelens refresh on start
          inlay_hints = true, -- enable/disable inlay hints on start
          semantic_tokens = true, -- enable/disable semantic token highlighting
        },
        formatting = { -- customize lsp formatting options
          format_on_save = { -- control auto formatting on save
            enabled = true, -- enable or disable format on save globally
            allow_filetypes = { -- enable format on save for specified filetypes only
              -- "go",
            },
            ignore_filetypes = { -- disable format on save for specified filetypes
              -- "python",
            },
          },
          disabled = { -- disable formatting capabilities for the listed language servers
            -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
            -- "lua_ls",
          },
          timeout_ms = 1000, -- default format timeout
          -- filter = function(client) -- fully override the default formatting function
          --   return true
          -- end
        },
        -- enable servers that you already have installed without mason
        servers = {
          -- "pyright"
        },
        -- customize language server configuration options passed to `lspconfig`
        ---@diagnostic disable: missing-fields
        config = {
          -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
        },
        -- customize how language servers are attached
        handlers = {
          -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
          -- function(server, opts) require("lspconfig")[server].setup(opts) end

          -- the key is the server that is being setup with `lspconfig`
          -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
          -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
        },
        -- A custom `on_attach` function to be run after the default `on_attach` function
        -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
        on_attach = function(client, bufnr)
          -- this would disable semanticTokensProvider for all clients
          -- client.server_capabilities.semanticTokensProvider = nil
        end,
      })
    end,
  },
}
