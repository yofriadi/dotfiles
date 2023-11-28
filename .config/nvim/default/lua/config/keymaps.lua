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

local toggle = require("utils.toggle")

return {
  -- TODO: Noice cmdline does not show immediately
  -- [";"] = { act = ":", noremap = true, desc = "Faster command key", },
  {
    mode = {"n", "x"},
    ["j"] = { act = "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Better move up" },
    ["k"] = { act = "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Better move down" },
  },
  {
    mode = {"n", "i"},
    ["<Esc>"] = { act = "<Cmd>noh<CR><Esc>", desc = "Escape and clear hlsearch" },
  },
  {
    mode = {"n", "i", "x", "s"},
    ["<C-S>"] = { act = "<cmd>w<cr><esc>", desc = "Save file"},
  },
  {
    mode = {"v"},
    ["<"] = { act = "<gv", desc = "Better left indenting" },
    [">"] = { act = ">gv", desc = "Better right indenting" },
  },

  { -- Option toggle
    mode = {"n"},
    ["<Leader>ts"] = { act = function() toggle.option("spell") end, desc = "Toggle spelling" },
    ["<Leader>tw"] = { act = function() toggle.option("wrap") end, desc = "Toggle word wrap" },
    ["<Leader>tc"] = {
      act = function()
        local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
        toggle.option("conceallevel", false, {0, conceallevel})
      end,
      desc = "Toggle conceal"
    },
    ["<leader>th"] = { act = function() vim.lsp.inlay_hint(0, nil) end, desc = "Toggle Inlay Hints" },
  },

  { -- Buffer
    mode = {"n"},
    ["<Leader><leader>"] = { act = "<Cmd>e #<Cr>", desc = "Switch to alternate buffer", },
    ["<S-H>"] = { act = "<Cmd>bprevious<Cr>", desc = "To previous buffer", },
    ["<S-L>"] = { act = "<Cmd>bnext<Cr>", desc = "To next buffer", },
    -- ["[b"] = { act = "<Cmd>bprevious<Cr>", desc = "To previous buffer", },
    -- ["]b"] = { act = "<Cmd>bnext<Cr>", desc = "To next buffer", },
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
    mode = {"n"},
    ["<C-W>c"] = { act = "<C-W>c", desc = "Close window", noremap = false },
    ["<C-W>d"] = { act = "<C-W>c", desc = "Close window", noremap = false }, -- convenient key
    ["<C-W>_"] = { act = "<C-W>s", desc = "Split window below", noremap = false },
    ["<C-W>|"] = { act = "<C-W>v", desc = "Split window right", noremap = false },
    ["<C-W>S"] = { act = "<C-W>v", desc = "Split window right", noremap = false }, -- convenient key
  },

  { -- Tab
    mode = {"n"},
    ["<Leader><Tab><Tab>"] = { act = "<Cmd>tabnew<CR>", desc = "New tab", },
    ["<Leader><Tab>c"] = { act = "<Cmd>tabclose<Cr>", desc = "Close tab", },
    ["<Leader><Tab>d"] = { act = "<Cmd>tabclose<Cr>", desc = "Close tab", }, -- convenient key
    ["<Leader><Tab>]"] = { act = "<Cmd>tabnext<Cr>", desc = "Next tab", },
    ["<Leader><Tab>l"] = { act = "<Cmd>tabnext<Cr>", desc = "Next tab", },
    ["<Leader><Tab>["] = { act = "<Cmd>tabprevious<Cr>", desc = "Previous tab", },
    ["<Leader><Tab>h"] = { act = "<Cmd>tabprevious<Cr>", desc = "Previous tab", },
    ["<Leader><Tab>F"] = { act = "<Cmd>tabfirst<Cr>", desc = "First tab", },
    ["<Leader><Tab>L"] = { act = "<Cmd>tablast<Cr>", desc = "Last tab", },
    ["<Leader><Tab>a"] = { act = "<Cmd>tabfirst<Cr>", desc = "First tab", }, -- convenient key
    ["<Leader><Tab>z"] = { act = "<Cmd>tablast<Cr>", desc = "Last tab", }, -- convenient key
  },
}
