-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<Leader>e"] = false,
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bd"] = {
        function() require("astronvim.utils.buffer").close(vim.bufnr, true) end,
      desc = "Close current buffer",
    },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close buffer",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader><leader>"] = { "<c-^>", desc = "switch between current and last file opened" },
    d = { '"_d', desc = "use a different register for delete and paste" },
    x = { '"_x', desc = "use a different register for cut and paste" },
    X = "S",
    L = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
    H = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer" },
  },
  v = {
    d = { '"_d', desc = "use a different register for delete and paste" },
    p = { '"_dP', desc = "use a different register for delete and paste" },
    X = "S",
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
    jk = [[<C-\><C-n>]],
    ["<esc><esc>"] = [[<C-\><C-n>]],
    ["<C-h>"] = [[<C-\><C-n><C-W>h]],
    ["<C-j>"] = [[<C-\><C-n><C-W>j]],
    ["<C-k>"] = [[<C-\><C-n><C-W>k]],
    ["<C-l>"] = [[<C-\><C-n><C-W>l]],
  },
}
