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

local cmd = vim.cmd
local toggle = require "utils.toggle"
return {
  {
    mode = "n",
    X = { act = "S" },
    d = { act = '"_d', desc = "Better delete" },
    x = { act = '"_x', desc = "Better delete" },
    ["<Esc>"] = { act = "<Cmd>noh<CR><Esc>", desc = "Escape and clear hlsearch" },
    ["<C-q>"] = { act = "<Cmd>qa!<CR>", desc = "Force quit" },
    ["<C-s>"] = { act = "<Cmd>w<CR>", desc = "Save file" },
  },
  {
    mode = "v",
    d = { act = '"_d', desc = "Better delete" },
    p = { act = '"_dP', desc = "Better paste" },
    ["<Tab>"] = { act = ">gv", desc = "Better right indenting" },
    ["<S-Tab>"] = { act = "<gv", desc = "Better left indenting" },
  },
  {
    mode = { "n", "x" },
    j = { act = "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Better move up" },
    k = { act = "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Better move down" },
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
    ["<S-H>"] = { act = cmd.bprevious, desc = "To previous buffer" },
    ["<S-L>"] = { act = cmd.bnext, desc = "To next buffer" },
  },

  { -- Window
    mode = { "n" },
    ["_"] = { act = cmd.vsplit, desc = "Split window below" },
    ["|"] = { act = cmd.split, desc = "Split window right" },
  },

  { -- Tab
    mode = { "n" },
    ["<Tab><Tab>"] = { act = cmd.tabnew, desc = "New tab" },
    ["<Tab>q"] = { act = cmd.tabclose, desc = "Close tab" },
    ["<Tab>l"] = { act = cmd.tabnext, desc = "Next tab" },
    ["<Tab>h"] = { act = cmd.tabprevious, desc = "Previous tab" },
    ["<Tab>a"] = { act = cmd.tabfirst, desc = "First tab" },
    ["<Tab>z"] = { act = cmd.tablast, desc = "Last tab" },
  },
}
