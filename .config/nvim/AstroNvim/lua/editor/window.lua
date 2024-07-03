return {
  { "nvim-focus/focus.nvim", version = "*", opts = {} },
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<C-W>r", require("smart-splits").start_resize_mode, desc = "Window resize mode" },
    },
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        resize_mode = {
          silent = true,
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    enabled = vim.fn.executable "git" == 1,
    keys = function()
      local function DiffviewToggle()
        local view = require("diffview.lib").get_current_view()
        if view then
          vim.cmd ":DiffviewClose"
        else
          vim.cmd ":DiffviewOpen"
        end
      end
      return {
        { "<Leader>gd", DiffviewToggle, desc = "Git diff" },
      }
    end,
  },
  { -- TODO: this conflicting interests with fugit
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "User AstroGitFile",
    keys = {
      { "<Leader>gn", "<Cmd>Neogit<CR>", desc = "Open Neogit Tab Page" },
      { "<Leader>gnc", "<Cmd>Neogit commit<CR>", desc = "Open Neogit Commit Page" },
      { "<Leader>gnc", ":Neogit cwd=", desc = "Open Neogit Override CWD" },
      { "<Leader>gnc", ":Neogit kind=", desc = "Open Neogit Override Kind" },
    },
    opts = function(_, opts)
      local utils = require "astrocore"
      local disable_builtin_notifications = utils.is_available "nvim-notify" or utils.is_available "noice.nvim"
      local ui_utils = require "astroui"
      local fold_signs = { ui_utils.get_icon "FoldClosed", ui_utils.get_icon "FoldOpened" }

      return utils.extend_tbl(opts, {
        disable_builtin_notifications = disable_builtin_notifications,
        telescope_sorter = function()
          if utils.is_available "telescope-fzf-native.nvim" then
            return require("telescope").extensions.fzf.native_fzf_sorter()
          end
        end,
        integrations = { telescope = utils.is_available "telescope.nvim" },
        signs = { section = fold_signs, item = fold_signs },
      })
    end,
  },
  { -- TODO: this conflicting interests with Neogit
    "SuperBo/fugit2.nvim",
    opts = {
      width = 70,
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Fugit2", "Fugit2Graph" },
    keys = {
      { "<leader>gf", "<Cmd>Fugit2<CR>" },
      { "<leader>gfg", "<Cmd>Fugit2Graph<CR>" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>etf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal float" },
    },
    opts = function(_, opts)
      opts.on_create = function()
        vim.opt.foldcolumn = "0"
        vim.opt.signcolumn = "no"
      end
      opts.on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<Cmd>close<CR>", { noremap = true, silent = true })
      end
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<Leader>eX", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble toggle diagnostics" },
      {
        "<Leader>ex",
        "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Trouble toggle buffer diagnostics",
      },
      { "<Leader>eS", "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble toggle symbols" },
      {
        "<Leader>el",
        "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "Trouble LSP definitions / references / ...",
      },
      { "<Leader>eL", "<Cmd>Trouble loclist toggle<CR>", desc = "Trouble location list" },
      { "<Leader>eQ", "<Cmd>Trouble qflist toggle<CR>", desc = "Trouble quickfix list" },
    },
  },
  {
    "carbon-steel/detour.nvim",
    keys = {
      { "<C-w><enter>", "<Cmd>Detour<CR>", desc = "Detour" },
      { "<C-w>.", "<Cmd>DetourCurrentWindow<CR>", desc = "Detour Current Window" },
    },
  },
  {
    "sindrets/winshift.nvim",
    opts = {},
    keys = {
      { "<C-W>R", "<Cmd>WinShift<CR>", desc = "Window shift mode" },
      { "<C-W>X", "<Cmd>WinShift swap<CR>", desc = "Window swap" },
      -- { "<C-A-H>", "<Cmd>WinShift left<CR>", desc = "Window swap left" },
      -- { "<C-A-H>", "<Cmd>WinShift left<CR>", desc = "Window swap left" },
      -- { "<C-A-J>", "<Cmd>WinShift down<CR>", desc = "Window swap below" },
      -- { "<C-A-K>", "<Cmd>WinShift up<CR>", desc = "Window swap above" },
      -- { "<C-A-L>", "<Cmd>WinShift right<CR>", desc = "Window swap right" },
    },
  },
  --[[ {
    "rest-nvim/rest.nvim",
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
      },
    },
    keys = {
      { "<localleader>rr", "<Cmd>Rest run<CR>", "Run request under the cursor" },
      { "<localleader>rl", "<Cmd>Rest run last<CR>", "Re-run latest request" },
    },
    ft = "http",
    config = function()
      require("rest-nvim").setup {
        result = {
          behavior = {
            formatters = {
              json = "jaq",
            },
          },
        },
      }

      local is_available = require("astrocore").is_available
      if is_available "telescope" then
        local telescope = require "telescope"
        telescope.load_extension "rest"
        telescope.extensions.rest.select_env() -- you can also use the `:Telescope rest select_env` command
      end
    end,
  }, ]]
}
