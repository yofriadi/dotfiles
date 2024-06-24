if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    keys = {
      { "<leader>gco", "<Cmd>GitConflictChooseOurs<CR>", desc = "Git conflict choose ours" },
      { "<leader>gct", "<Cmd>GitConflictChooseTheirs<CR>", desc = "Git conflict choose theirs" },
      { "<leader>gcn", "<Cmd>GitConflictNextConflict<CR>", desc = "Git conflict next conflict" },
      { "<leader>gcp", "<Cmd>GitConflictPrevConflict<CR>", desc = "Git conflict previous conflict" },
    },
  },
  {
    "Darazaki/indent-o-matic",
    opts = {
      -- Global settings (optional, used as fallback)
      max_lines = 2048,
      standard_widths = { 2, 4, 8 },

      -- Disable indent-o-matic for LISP files
      filetype_lisp = {
        max_lines = 0,
      },

      -- Only detect 4 spaces and tabs for Go files
      filetype_go = {
        standard_widths = { 4 },
      },

      -- Don't detect 8 spaces indentations inside files without a filetype
      filetype_ = {
        standard_widths = { 2, 4 },
      },
    },
  },
  { -- TODO: not working
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup {
        exclude_files = {
          neotree = true,
          dashboard = true,
        },
        chunk = {
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = "─",
          },
          style = "#806d9c",
        },
      }
    end,
  },
  {
    "Wansmer/treesj",
    keys = { { "gss", "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" } },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  {
    "NStefan002/visual-surround.nvim",
    config = true,
  },
}
