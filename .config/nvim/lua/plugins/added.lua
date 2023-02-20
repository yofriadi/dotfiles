return {
  "David-Kunz/markid",
  "akinsho/git-conflict.nvim",
  "anuvyklack/pretty-fold.nvim",
  "romgrk/nvim-treesitter-context",
  {
    "anuvyklack/fold-preview.nvim",
    dependencies = "anuvyklack/keymap-amend.nvim",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "ethanholz/nvim-lastplace",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    },
  },
  {
    "fedepujol/move.nvim",
    keys = {
      {
        "∆",
        function()
          require("move").MoveLine(1)
        end,
        silent = true,
        noremap = true,
      },
      {
        "˚",
        function()
          require("move").MoveLine(-1)
        end,
        silent = true,
        noremap = true,
      },
      {
        "∆",
        function()
          require("move").MoveBlock(1, 0, 0)
        end,
        mode = "v",
        silent = true,
        noremap = true,
      },
      {
        "˚",
        function()
          require("move").MoveBlock(-1, 0, 0)
        end,
        mode = "v",
        silent = true,
        noremap = true,
      },
      {
        "¬",
        function()
          require("move").MoveHChar(1)
        end,
        silent = true,
        noremap = true,
      },
      {
        "˙",
        function()
          require("move").MoveHChar(-1)
        end,
        silent = true,
        noremap = true,
      },
      {
        "¬",
        function()
          require("move").MoveHBlock(1)
        end,
        mode = "v",
        silent = true,
        noremap = true,
      },
      {
        "˙",
        function()
          require("move").MoveHBlock(-1)
        end,
        mode = "v",
        silent = true,
        noremap = true,
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    opts = {
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = {
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
      },
      hide_cursor = false, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = nil, -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
      performance_mode = false, -- Disable "Performance Mode" on all buffers.
    },
  },

  -- "kevinhwang91/nvim-hlslens",
}
