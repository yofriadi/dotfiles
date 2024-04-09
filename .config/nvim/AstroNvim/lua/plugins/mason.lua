---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        -- add more arguments for adding more language servers
        "gopls",
        "jsonls",
        "yamlls",
        "marksman",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      opts.ensure_installed = {
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
      }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    dependencies = {
      "jbyuki/one-small-step-for-vimkind",
    },
    opts = function(_, opts)
      opts.ensure_installed = {
        "delve",
      }
    end,
  },
}
