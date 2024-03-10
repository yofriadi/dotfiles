---@type LazySpec
return {
  {
    "Cassin01/wf.nvim",
    version = "*",
    --event = "VeryLazy",
    keys = function()
      local which_key = require "wf.builtin.which_key"
      local register = require "wf.builtin.register"
      local bookmark = require "wf.builtin.bookmark"
      local mark = require "wf.builtin.mark"
      return {
        {
          "<Leader>",
          which_key { text_insert_in_advance = "<Leader>" },
          desc = "which-key",
        },
        { "<C-W><CR>", register(), desc = "which-key register" },
        { "'", mark(), desc = "which-key mark" },
        {
          "<C-W>m",
          bookmark {
            nvim = "~/.config/nvim/default",
            AstroNvim = "~/.config/nvim/AstroNvim",
            zsh = "~/.config/zsh/.zshrc",
          },
          desc = "which-key bookmark",
        },
      }
    end,
    opts = {
      theme = "space",
    },
  },
}
