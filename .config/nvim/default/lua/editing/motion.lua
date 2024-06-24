if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  {
    "echasnovski/mini.move",
    version = "*",
    event = "BufRead",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = function()
      local flash = require "flash"
      return {
        { "s", mode = { "n", "x", "o" }, flash.jump, desc = "Flash" },
        { "S", mode = { "n", "o", "x" }, flash.treesitter, desc = "Flash Treesitter" },
        { "r", mode = "o", flash.remote, desc = "Flash Remote" },
        { "R", mode = { "o", "x" }, flash.treesitter_search, desc = "Flash Treesitter Search" },
        { "<c-s>", mode = { "c" }, flash.toggle, desc = "Flash Toggle Search" },
      }
    end,
  },
  {
    "chrisgrieser/nvim-spider",
    keys = function()
      local motion = require("spider").motion
      local mode = { "n", "x", "o" }
      return {
        { "w", function() motion "w" end, mode = mode, desc = "Next word" },
        { "e", function() motion "e" end, mode = mode, desc = "Next end of word" },
        { "b", function() motion "b" end, mode = mode, desc = "Previous word" },
        { "ge", function() motion "ge" end, mode = mode, desc = "Previous end of word" },
      }
    end,
    config = function()
      require("spider").setup {
        skipInsignificantPunctuation = false,
      }
    end,
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
}
