return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "shellcheck",
        "shfmt",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {},
        ["golangci-lint-langserver"] = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "json",
        "yaml",
        "lua",
        "go",
        "gomod",
        "javascript",
        "typescript",
      },
      markid = { enable = true },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  -- added
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
