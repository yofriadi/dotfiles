return {
  {
    "niuiic/terminal.nvim",
    dependencies = "niuiic/core.nvim",
    keys = function()
      local terminal = require "terminal"
      local open = function(mode)
        if mode == "float" then
          local core = require "core"
          local size = core.win.proportional_size(0.8, 0.6)
          core.win.open_float(0, {
            enter = true,
            relative = "editor",
            width = size.width,
            height = size.height,
            row = size.row,
            col = size.col,
            style = "minimal",
            border = "rounded",
            title = "terminal",
            title_pos = "center",
          })
        else
          vim.cmd(mode)
        end

        terminal.open(0)
      end
      return {
        { "<Leader>etv", function() open "vsplit" end, desc = "Terminal open vertical" },
        { "<Leader>eth", function() open "20split" end, desc = "Terminal open horizontal" },
        { "<Leader>etf", function() open "float" end, desc = "Terminal open float" },
        { "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Terminal normal mode" },
        { "jk", "<C-\\><c-n>", mode = "t", desc = "Terminal normal mode" },
        { "<C-h>", "<C-\\><C-n><C-w>h", mode = "t", desc = "Move to left window in terminal mode" },
        { "<C-j>", "<C-\\><C-n><C-w>j", mode = "t", desc = "Move to below window in terminal mode" },
        { "<C-k>", "<C-\\><C-n><C-w>k", mode = "t", desc = "Move to above window in terminal mode" },
        { "<C-l>", "<C-\\><C-n><C-w>l", mode = "t", desc = "Move to right window in terminal mode" },
        { "<C-w>", "<C-\\><C-n><C-w>", mode = "t", desc = "Terminal window mode" },
      }
    end,
    config = function()
      local set_line_number = function(show_line_number)
        local options = { "number", "relativenumber" }
        for _, option in ipairs(options) do
          vim.api.nvim_set_option_value(option, show_line_number, {
            win = 0,
          })
        end
      end

      local terms = {}
      require("terminal").setup {
        on_term_opened = function(bufnr, pid)
          vim.api.nvim_set_option_value("filetype", "terminal", { buf = bufnr })
          set_line_number(false)

          terms[bufnr] = pid
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "", {
            callback = function()
              vim.loop.kill(terms[bufnr], "sigkill")
              table.remove(terms, bufnr)
              vim.api.nvim_buf_delete(bufnr, {
                force = true,
              })
            end,
          })
        end,
      }

      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*" },
        callback = function(args)
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
          if filetype == "terminal" then vim.cmd "startinsert" end
        end,
      })
    end,
  },
  --[[ {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>etf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
      { "<leader>etb", "<cmd>ToggleTerm direction=tab<cr>", desc = "ToggleTerm tab" },
      { "<leader>eth", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
      { "<leader>etv", "<cmd>ToggleTerm size=60 direction=vertical<cr>", desc = "ToggleTerm vertical" },
      { "<esc><esc>", "<c-\\><c-n>", mode = "t", desc = "Terminal normal mode" },
      { "jk", "<c-\\><c-n>", mode = "t", desc = "Terminal normal mode" },
      { "<c-h>", "<c-\\><c-n><c-w>h", mode = "t", desc = "Move to left window in terminal mode" },
      { "<c-j>", "<c-\\><c-n><c-w>j", mode = "t", desc = "Move to below window in terminal mode" },
      { "<c-k>", "<c-\\><c-n><c-w>k", mode = "t", desc = "Move to above window in terminal mode" },
      { "<c-l>", "<c-\\><c-n><c-w>l", mode = "t", desc = "Move to right window in terminal mode" },
      { "<c-w>", "<c-\\><c-n><c-w>", mode = "t", desc = "Terminal window mode" },
    },
    opts = {
      highlights = {
        Normal = { link = "Normal" },
        NormalNC = { link = "NormalNC" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
        StatusLine = { link = "StatusLine" },
        StatusLineNC = { link = "StatusLineNC" },
        WinBar = { link = "WinBar" },
        WinBarNC = { link = "WinBarNC" },
      },
      size = 10,
      float_opts = { border = "rounded" },
    },
  } ]]
}
