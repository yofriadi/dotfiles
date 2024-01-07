return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = function()
      local trouble = require "trouble"
      return {
        { "<BS>", "<Cmd>close<CR>" },
        { "<Leader>ex", "<Cmd>TroubleToggle document_diagnostics<CR>", desc = "Document Diagnostics (Trouble)" },
        { "<Leader>eX", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace Diagnostics (Trouble)" },
        { "<Leader>eL", "<Cmd>TroubleToggle loclist<CR>", desc = "Location List (Trouble)" },
        { "<Leader>eQ", "<Cmd>TroubleToggle quickfix<CR>", desc = "Quickfix List (Trouble)" },
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
          desc = "Previous trouble/quickfix item",
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
          desc = "Next trouble/quickfix item",
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<Leader>et", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
      { "<Leader>st", "<cmd>TodoTelescope<cr>", desc = "Search todo" },
    },
  },
}
