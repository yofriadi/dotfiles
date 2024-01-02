return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  config = function()
    require("conform").setup {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "goimports-reviser", "gofmt", "gofumpt", "golines" },
        md = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
      },
    }
  end,
}
