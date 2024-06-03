-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  { "cpea2506/relative-toggle.nvim" },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "vague2k/huez.nvim",
    import = "huez-manager.import",
    opts = {},
    --[[ config = function()
      require("huez").setup()
      vim.cmd("colorscheme " .. colorscheme)

      -- vim.keymap.set("n", "<leader>co", "<cmd>Huez<CR>", {})
    end, ]]
  },
}
