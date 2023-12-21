-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Keys
--   Control = <C- >
--   Alt = <A- >

-- vim.keymap.set()

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", ";", ":", { noremap = true })

local toggle = require "utils.toggle"

return {
  -- TODO: Noice cmdline does not show immediately
  -- [";"] = { act = ":", noremap = true, desc = "Faster command key", },
  {
    mode = { "n", "x" },
    ["j"] = { act = "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Better move up" },
    ["k"] = { act = "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Better move down" },
  },
  {
    mode = { "n", "i" },
    ["<Esc>"] = { act = "<Cmd>noh<CR><Esc>", desc = "Escape and clear hlsearch" },
  },
  {
    mode = { "n", "i", "x", "s" },
    ["<C-S>"] = { act = "<cmd>w<cr><esc>", desc = "Save file" },
  },
  {
    mode = { "v" },
    ["<"] = { act = "<gv", desc = "Better left indenting" },
    [">"] = { act = ">gv", desc = "Better right indenting" },
  },

  { -- Option toggle
    mode = { "n" },
    ["<Leader>ts"] = { act = function() toggle.option "spell" end, desc = "Toggle spelling" },
    ["<Leader>tw"] = { act = function() toggle.option "wrap" end, desc = "Toggle word wrap" },
    ["<Leader>tc"] = {
      act = function()
        local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
        toggle.option("conceallevel", false, { 0, conceallevel })
      end,
      desc = "Toggle conceal",
    },
    ["<leader>th"] = { act = function() vim.lsp.inlay_hint(0, nil) end, desc = "Toggle Inlay Hints" },
  },

  { -- Buffer
    mode = { "n" },
    ["<Leader><leader>"] = { act = "<Cmd>e #<CR>", desc = "Switch to alternate buffer" },
    ["<S-H>"] = { act = "<Cmd>bprevious<CR>", desc = "To previous buffer" },
    ["<S-L>"] = { act = "<Cmd>bnext<CR>", desc = "To next buffer" },
    -- ["[b"] = { act = "<Cmd>bprevious<CR>", desc = "To previous buffer", },
    -- ["]b"] = { act = "<Cmd>bnext<CR>", desc = "To next buffer", },
    ["<b"] = {
      act = function() require("utils.buffer").move(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Move buffer to the left",
    },
    [">b"] = {
      act = function() require("utils.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Move buffer to the left",
    },
  },

  { -- Window
    mode = { "n" },
    ["<C-W>c"] = { act = "<C-W>c", desc = "Close window", noremap = false },
    ["<C-W>d"] = { act = "<C-W>c", desc = "Close window", noremap = false }, -- convenient key
    ["<C-W>_"] = { act = "<C-W>s", desc = "Split window below", noremap = false },
    ["<C-W>|"] = { act = "<C-W>v", desc = "Split window right", noremap = false },
    ["<C-W>S"] = { act = "<C-W>v", desc = "Split window right", noremap = false }, -- convenient key
  },

  { -- Tab
    mode = { "n" },
    ["<Tab><Tab>"] = { act = "<Cmd>tabnew<CR>", desc = "New tab" },
    ["<Tab>c"] = { act = "<Cmd>tabclose<CR>", desc = "Close tab" },
    --["<Tab>d"] = { act = "<Cmd>tabclose<CR>", desc = "Close tab" },
    ["<Tab>]"] = { act = "<Cmd>tabnext<CR>", desc = "Next tab" },
    ["<Tab>l"] = { act = "<Cmd>tabnext<CR>", desc = "Next tab" },
    ["<Tab>["] = { act = "<Cmd>tabprevious<CR>", desc = "Previous tab" },
    ["<Tab>h"] = { act = "<Cmd>tabprevious<CR>", desc = "Previous tab" },
    ["<Tab>a"] = { act = "<Cmd>tabfirst<CR>", desc = "First tab" },
    ["<Tab>z"] = { act = "<Cmd>tablast<CR>", desc = "Last tab" },
    --["<Tab>F"] = { act = "<Cmd>tabfirst<CR>", desc = "First tab" },
    --["<Tab>L"] = { act = "<Cmd>tablast<CR>", desc = "Last tab" },
  },
}
