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
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = function()
      local trouble = require "trouble"
      return {
        { "<BS>", "<Cmd>close<CR>" },
        { "<Leader>ex", "<Cmd>TroubleToggle document_diagnostics<CR>", desc = "Trouble document diagnostics" },
        { "<Leader>eX", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Trouble workspace diagnostics" },
        { "<Leader>eL", "<Cmd>TroubleToggle loclist<CR>", desc = "Trouble location list" },
        { "<Leader>eQ", "<Cmd>TroubleToggle quickfix<CR>", desc = "Trouble quickfix list" },
        {
          "[q",
          function()
            if trouble.is_open() then
              trouble.previous { skip_groups = true, jump = true }
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then vim.notify(err, vim.log.levels.ERROR) end
            end
          end,
          desc = "Trouble previous trouble/quickfix item",
        },
        {
          "]q",
          function()
            if trouble.is_open() then
              trouble.next { skip_groups = true, jump = true }
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then vim.notify(err, vim.log.levels.ERROR) end
            end
          end,
          desc = "Trouble next trouble/quickfix item",
        },
      }
    end,
  },
  {
    "carbon-steel/detour.nvim",
    config = function()
      --vim.keymap.set("n", "<C-w><enter>", ":Detour<cr>") -- not working
      vim.keymap.set("n", "<C-w>.", ":DetourCurrentWindow<cr>")
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "*",
        callback = function(event)
          local filetype = vim.bo[event.buf].filetype
          local file_path = event.match

          if file_path:match "/doc/" ~= nil then
            -- Only run if the filetype is a help file
            if filetype == "help" or filetype == "markdown" then
              -- Get the newly opened help window
              -- and attempt to open a Detour() float
              local help_win = vim.api.nvim_get_current_win()
              local ok = require("detour").Detour()

              -- If we successfully create a float of the help file
              -- Close the split
              if ok then vim.api.nvim_win_close(help_win, false) end
            end
          end
        end,
      })
    end,
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
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        config = function() require("luarocks").setup {} end,
      },
    },
    ft = "http",
    config = function() require("rest-nvim").setup() end,
  },
}
