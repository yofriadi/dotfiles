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
      colorscheme = "dayfox",
    },
  },
  --[[ {
    "vague2k/huez.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      local colorscheme = require("huez.api").get_colorscheme()
      vim.cmd("colorscheme " .. colorscheme)

      -- vim.keymap.set("n", "<leader>co", "<cmd>Huez<CR>", {})
    end,
  }, ]]
}
