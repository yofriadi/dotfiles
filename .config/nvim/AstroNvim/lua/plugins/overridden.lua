---@type LazySpec
return {
  {
    "max397574/better-escape.nvim",
    opts = {
      mapping = { "jk" },
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     if not opts.sources then opts.sources = {} end
  --     opts.sources.name = "supermaven"
  --     --[[ opts.formatting = {
  --       format = lspkind.cmp_format({
  --         mode = "symbol",
  --         max_width = 50,
  --         symbol_map = { Supermaven = "" }
  --       })
  --     } ]]
  --   end,
  -- },
  -- {
  --   "onsails/lspkind.nvim",
  --   opts = function(_, opts)
  --     if not opts.symbol_map then opts.symbol_map = {} end
  --     opts.symbol_map.Supermaven = ""
  --   end,
  -- },
}
