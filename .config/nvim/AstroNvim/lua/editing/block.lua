---@type LazySpec
return {
  {
    "Darazaki/indent-o-matic",
    opts = {
      filetype_go = {
        standard_widths = { 4 },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
      {
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        main = "rainbow-delimiters.setup",
      },
    },
    opts = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      vim.g.rainbow_delimiters = { highlight = highlight }
      opts.indent = { char = "▏", highlight = highlight }
      opts.scope = { char = "▍", highlight = highlight, show_start = false }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "Wansmer/treesj",
    keys = { { "gss", "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" } },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  {
    "NStefan002/visual-surround.nvim",
    config = true,
  },
}
