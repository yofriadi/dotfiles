return {
  {
    "echasnovski/mini.move",
    version = "*",
    event = "BufRead",
    config = function() require("mini.move").setup() end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    keys = function()
      local flash = require "flash"
      return {
        { "s", mode = { "n", "x", "o" }, function() flash.jump() end, desc = "Flash" },
        { "S", mode = { "n", "o", "x" }, function() flash.treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() flash.remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() flash.treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() flash.toggle() end, desc = "Toggle Flash Search" },
      }
    end,
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "x", "o" }, desc = "Next word" },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "x", "o" }, desc = "Next end of word" },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "x", "o" }, desc = "Previous word" },
      { "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "x", "o" }, desc = "Previous end of word" },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts) require("mini.ai").setup(opts) end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  --[[ {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    config = function()
      require("cinnamon").setup {
        -- KEYMAPS:
        default_keymaps = true, -- Create default keymaps.
        extra_keymaps = true, -- Create extra keymaps.
        extended_keymaps = true, -- Create extended keymaps.
        override_keymaps = false, -- The plugin keymaps will override any existing keymaps.

        -- OPTIONS:
        always_scroll = false, -- Scroll the cursor even when the window hasn't scrolled.
        centered = true, -- Keep cursor centered in window when using window scrolling.
        disabled = false, -- Disables the plugin.
        default_delay = 7, -- The default delay (in ms) between each line when scrolling.
        hide_cursor = false, -- Hide the cursor while scrolling. Requires enabling termguicolors!
        horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
        max_length = -1, -- Maximum length (in ms) of a command. The line delay will be
        -- re-calculated. Setting to -1 will disable this option.
        scroll_limit = 150, -- Max number of lines moved before scrolling is skipped. Setting
        -- to -1 will disable this option.
      }
    end,
  }, ]]
}
