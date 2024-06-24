---@type LazySpec
return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    keys = {
      { "<Leader>gco", "<Cmd>GitConflictChooseOurs<CR>", desc = "Git conflict choose ours" },
      { "<Leader>gct", "<Cmd>GitConflictChooseTheirs<CR>", desc = "Git conflict choose theirs" },
      { "<Leader>gcn", "<Cmd>GitConflictNextConflict<CR>", desc = "Git conflict next conflict" },
      { "<Leader>gcp", "<Cmd>GitConflictPrevConflict<CR>", desc = "Git conflict previous conflict" },
    },
  },
  {
    "Darazaki/indent-o-matic",
    opts = {
      filetype_go = {
        standard_widths = { 4 },
      },
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup {
        exclude_files = {
          neotree = true,
          dashboard = true,
        },
        chunk = {
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = "─",
          },
          style = "#806d9c",
        },
        line_num = {
          style = "#806d9c",
        },
        blank = {
          enable = true,
          chars = {
            " ",
          },
          style = {
            { bg = "#434437" },
            { bg = "#2f4440" },
            { bg = "#433054" },
            { bg = "#284251" },
          },
        },
      }
    end,
  },
  --[[ {
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
  }, ]]
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
