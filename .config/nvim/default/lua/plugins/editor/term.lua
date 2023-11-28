return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
    { "<leader>tb", "<cmd>ToggleTerm direction=tab<cr>", desc = "ToggleTerm tab" },
    { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
    { "<leader>tv", "<cmd>ToggleTerm size=60 direction=vertical<cr>", desc = "ToggleTerm vertical" },
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
}
