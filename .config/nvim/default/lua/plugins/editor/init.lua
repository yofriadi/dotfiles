return {
  { "sindrets/diffview.nvim" },
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<c-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to window left" },
      { "<c-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to window below" },
      { "<c-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to window above" },
      { "<c-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to window right" },
      { "<c-w>r", function() require("smart-splits").start_resize_mode() end, desc = "Resize mode"},
      { "<c-w>+", function() require("smart-splits").resize_up() end, mode = {"n", "i"}, desc = "Resize split up"},
      { "<c-w>-", function() require("smart-splits").resize_down() end, mode = {"n", "i"}, desc = "Resize split down"},
      { "<c-w><", function() require("smart-splits").resize_right() end, mode = {"n", "i"}, desc = "Resize split left"},
      { "<c-w>>", function() require("smart-splits").resize_left() end, mode = {"n", "i"}, desc = "Resize split right"},
    },
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
    },
  },
  {
    'echasnovski/mini.bufremove',
    version = '*',
    keys = {
      {
        "C",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
    }
  },
}
