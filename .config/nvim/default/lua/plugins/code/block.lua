return {
  {
    "lukas-reineke/indent-blankline.nvim",
    branch = "current-indent",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function(_, opts)
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
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
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
      vim.tbl_deep_extend("force", opts, {
        current_indent = { highlight = highlight },
        scope = { highlight = highlight },
      })
      require("ibl").setup {
        indent = { char = " " },
        current_indent = { char = "▏", enabled = true, show_start = false, highlight = highlight },
        scope = { char = "▎", highlight = highlight },
        exclude = {
          buftypes = {
            "nofile",
            "prompt",
            "quickfix",
            "terminal",
          },
          filetypes = {
            "dashboard",
            "help",
            "lazy",
            "mason",
            "neo-tree",
            "notify",
            "startify",
            "toggleterm",
            "Trouble",
          },
        },
      }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    main = "rainbow-delimiters.setup",
  },
  {
    "Wansmer/treesj",
    keys = { { "gs", "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" } },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  --"danymat/neogen",
}
