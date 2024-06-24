return {
  { "nvim-focus/focus.nvim", version = "*", opts = {} },
  {
    "mrjones2014/smart-splits.nvim",
    --keys = {
    --  { "<C-W>r", require("smart-splits").start_resize_mode, desc = "Window resize mode" },
    --},
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        resize_mode = {
          silent = true,
        },
      })
    end,
    config = function()
      vim.keymap.set('n', '<C-W>r', require('smart-splits').start_resize_mode)
    end,
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
    "carbon-steel/detour.nvim",
    config = function ()
       vim.keymap.set('n', '<c-w><enter>', ":Detour<cr>")
       vim.keymap.set('n', '<c-w>.', ":DetourCurrentWindow<cr>")
   end
  },
  {
    "sindrets/winshift.nvim",
    opts = {},
    keys = {
      { "<C-W>R", "<Cmd>WinShift<CR>", desc = "Window shift mode" },
      { "<C-W>X", "<Cmd>WinShift swap<CR>", desc = "Window swap" },
      -- { "<C-M-H>", "<Cmd>WinShift left<CR>", desc = "Window swap left" },
      -- { "<C-S-H>", "<Cmd>WinShift left<CR>", desc = "Window swap left" },
      -- { "<C-M-J>", "<Cmd>WinShift down<CR>", desc = "Window swap below" },
      -- { "<C-M-K>", "<Cmd>WinShift up<CR>", desc = "Window swap above" },
      -- { "<C-M-L>", "<Cmd>WinShift right<CR>", desc = "Window swap right" },
    },
  },
}
