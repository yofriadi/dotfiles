return {
  {
    "echasnovski/mini.bufremove",
    version = "*",
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
    },
  },
  {
    "rest-nvim/rest.nvim",
    ft = { "http", "json" },
    cmd = {
      "RestNvim",
      "RestNvimPreview",
      "RestNvimLast",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<Leader>r", "<Plug>RestNvim", desc = "Run request" },
    },
  },
}
