return {
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<c-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to window left" },
      { "<c-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to window below" },
      { "<c-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to window above" },
      { "<c-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to window right" },
      { "<c-w>r", function() require("smart-splits").start_resize_mode() end, desc = "Resize mode" },
      { "<c-w>+", function() require("smart-splits").resize_up() end, mode = { "n", "i" }, desc = "Resize split up" },
      {
        "<c-w>-",
        function() require("smart-splits").resize_down() end,
        mode = { "n", "i" },
        desc = "Resize split down",
      },
      {
        "<c-w><",
        function() require("smart-splits").resize_right() end,
        mode = { "n", "i" },
        desc = "Resize split left",
      },
      {
        "<c-w>>",
        function() require("smart-splits").resize_left() end,
        mode = { "n", "i" },
        desc = "Resize split right",
      },
    },
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
    },
  },
  {
    "Pocco81/true-zen.nvim",
    opts = function(_, opts)
      local utils = require "utils"

      local old_on_open, old_on_close = opts.on_open, opts.on_close
      opts.on_open = function()
        utils.conditional_func(old_on_open, true)
        vim.cmd.SatelliteDisable()
      end
      opts.on_close = function()
        utils.conditional_func(old_on_close, true)
        vim.cmd.SatelliteEnable()
      end

      return {
        integrations = {
          tmux = os.getenv "TMUX" ~= nil, -- hide tmux status bar in (minimalist, ataraxis)
          twilight = utils.is_available "twilight.nvim", -- enable twilight (ataraxis)
        },
      }
    end,
    keys = {
      {
        "<Leader>zf",
        function() require("true-zen").focus() end,
        desc = "Focus (True Zen)",
      },
      --[[ { -- BUG:
        "<Leader>zm",
        function() require("true-zen").minimalist() end,
        desc = "Minimalist (True Zen)",
      },
      { -- BUG:
        "<Leader>za",
        function() require("true-zen").ataraxis() end,
        desc = "Ataraxis (True Zen)",
      }, ]]
      { -- BUG: Fix error
        "<Leader>zn",
        function()
          local truezen = require "true-zen"
          local first = 0
          local last = vim.api.nvim_buf_line_count(0)
          truezen.narrow(first, last)
        end,
        desc = "Narrow (True Zen)",
      },
      { -- BUG: Fix error
        "<Leader>zn",
        desc = "Narrow (True Zen)",
        mode = { "v" },
        function()
          local truezen = require "true-zen"
          local first = vim.fn.line "v"
          local last = vim.fn.line "."
          truezen.narrow(first, last)
        end,
      },
    },
  },
}
