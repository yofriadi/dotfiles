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
--vim.api.nvim_set_keymap("", "<Space>", "<nop>", { noremap = true, silent = true })

local cmd = vim.cmd
local toggle = require "utils.toggle"
return {
  {
    mode = "n",
    ["<CR>"] = { act = ":", silent = false },
    ["<S-CR>"] = { act = "@:", silent = false },
    --["<C-CR>"] = { act = "@:", silent = false },
    ["<A-CR>"] = { act = "@:", silent = false },
    ["<C-S-CR>"] = { act = "@:", silent = false },

    --["<S-Space>"] = { act = "@:", silent = false },
    --["<C-Space>"] = { act = "@:", silent = false },
    --["<A-Space>"] = { act = "@:", silent = false },
    --["<C-S-Space>"] = { act = "@:", silent = false },

    X = { act = "<C-a>" },
    d = { act = '"_d', desc = "Better delete" },
    x = { act = '"_x', desc = "Better delete" },
    ["<Esc>"] = {
      act = "<Cmd>noh<CR><Cmd>Noice dismiss<CR><Esc>",
      desc = "Escape and clear hlsearch and Dismiss notification",
    },
    ["<C-q>"] = { act = "<Cmd>qa!<CR>", desc = "Force quit" },
    ["<C-s>"] = { act = "<Cmd>w<CR>", desc = "Save file" },
  },
  {
    mode = "i",
    ["<C-h>"] = { act = "<C-w>" }, -- delete word backward
  },
  {
    mode = "v",
    d = { act = '"_d', desc = "Better delete" },
    p = { act = '"_dP', desc = "Better paste" },
    ["<Tab>"] = { act = ">gv", desc = "Better right indenting" },
    ["<S-Tab>"] = { act = "<gv", desc = "Better left indenting" },
  },
  {
    mode = "x",
    p = { act = '"_dP', desc = "Better paste" },
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
    ["<Leader>tcl"] = {
      act = function()
        local cl = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
        toggle.option("conceallevel", false, { 0, cl })
      end,
      desc = "Toggle conceal level",
    },
    --[[ ["<Leader>tcc"] = {
      act = function()
        local cc = vim.o.concealcursor ~= "" and vim.o.concealcursor or "n"
        toggle.option("concealcursor", false, { "", cc })
      end,
      desc = "Toggle conceal cursor",
    }, ]]
    ["<leader>th"] = { act = function() vim.lsp.inlay_hint(0, nil) end, desc = "Toggle Inlay Hints" },
  },

  { -- Buffer
    mode = { "n" },
    ["<Leader><leader>"] = { act = "<Cmd>e #<CR>", desc = "Switch to alternate buffer" },
    ["<S-H>"] = { act = cmd.bprevious, desc = "To previous buffer" },
    ["<S-L>"] = { act = cmd.bnext, desc = "To next buffer" },
    ["<Leader><BS>"] = {
      act = function()
        local id = vim.api.nvim_create_augroup("startup", {
          clear = false,
        })
        local persistbuffer = function(bufnr)
          bufnr = bufnr or vim.api.nvim_get_current_buf()
          vim.fn.setbufvar(bufnr, "bufpersist", 1)
        end
        vim.api.nvim_create_autocmd({ "BufRead" }, {
          group = id,
          pattern = { "*" },
          callback = function()
            vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
              buffer = 0,
              once = true,
              callback = function() persistbuffer() end,
            })
          end,
        })
        local curbufnr = vim.api.nvim_get_current_buf()
        local buflist = vim.api.nvim_list_bufs()
        for _, bufnr in ipairs(buflist) do
          if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
            vim.cmd("bd " .. tostring(bufnr))
          end
        end
      end,
      desc = "Close unused buffers",
    },
  },

  --[[ { -- Window
    mode = { "n" },
    ["_"] = { act = cmd.vsplit, desc = "Split window below" },
    ["|"] = { act = cmd.split, desc = "Split window right" },
  }, ]]

  { -- Tab
    mode = { "n" },
    ["<Tab><Tab>"] = { act = cmd.tabnew, desc = "New tab" },
    ["<Tab><BS>"] = { act = cmd.tabclose, desc = "Close tab" },
    ["<Tab>l"] = { act = cmd.tabnext, desc = "Next tab" },
    ["<Tab>h"] = { act = cmd.tabprevious, desc = "Previous tab" },
    ["<Tab>a"] = { act = cmd.tabfirst, desc = "First tab" },
    ["<Tab>z"] = { act = cmd.tablast, desc = "Last tab" },
  },
}
