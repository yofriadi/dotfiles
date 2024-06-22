return {
  {
    "Cassin01/wf.nvim",
    version = "*",
    keys = function()
      local which_key = require "wf.builtin.which_key"
      return {
        {
          "<Leader>",
          which_key { text_insert_in_advance = "<Leader>" },
          desc = "which-key",
        },
      }
    end,
    opts = {
      theme = "space",
    },
  },
}
