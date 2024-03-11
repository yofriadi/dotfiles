---@type LazySpec
return {
  {
    "Cassin01/wf.nvim",
    version = "*",
    keys = function()
      local which_key = require "wf.builtin.which_key"
      return {
        {
          "<Leader>",
          which_key { text_insert_in_advance = "<Leader>" },
          desc = "which-key",
        },
      }
    end,
    opts = {
      theme = "space",
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufRead",
    config = function() require("hlslens").setup() end,
  },
  {
    "backdround/improved-search.nvim",
    event = "BufRead",
    keys = function()
      local search = require "improved-search"
      return {
        { "n", search.stable_next, mode = { "n", "x", "o" }, desc = "search stable next" },
        { "N", search.stable_previous, mode = { "n", "x", "o" }, desc = "search stable previous" },
        { "!", search.current_word, desc = "search stable current word" },
        { "!", search.in_place, mode = "x", desc = "search stable in place" },
        { "*", search.forward, mode = "x", desc = "search forward" },
        { "#", search.backward, mode = "x", desc = "search backward" },
      }
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    --module = "ssr",
    --[[ keys = {
      { "<leader>er", require("ssr").open, mode = { "n", "x" }, desc = "Search and replace" },
    }, ]]
    config = function()
      local ssr = require "ssr"
      ssr.setup {
        keymaps = {
          close = "<Esc>",
        },
      }
      vim.keymap.set({ "n", "x" }, "<leader>sr", ssr.open)
    end,
    -- Calling setup is optional.
    --[[ config = function()
      require("ssr").setup {
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      }
    end, ]]
  },
}
