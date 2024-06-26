return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local lazy = require "lazy"
    local astrocore_buffer = require "astrocore.buffer"
    local astrocore_toggles = require "astrocore.toggles"
    local is_available = require("astrocore").is_available
    opts.mappings = {
      n = {
        ["<Esc>"] = {
          function()
            vim.cmd "noh"
            if is_available "noice.nvim" then vim.cmd "Noice dismiss" end
            if is_available "nvim-notify" then require("notify").dismiss { pending = true, silent = true } end
          end,
        },
        ["<C-s>"] = { "<Cmd>w<CR>", desc = "Save File" },
        --["<C-q>"] = { "<Cmd>confirm q<CR>", desc = "Quit" },

        -- split
        ["|"] = { "<Cmd>vsplit<CR>", desc = "Split vertical" },
        ["\\"] = { "<Cmd>split<CR>", desc = "Split horizontal" },

        -- cursor
        j = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Cursor move down" },
        k = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Cursor move up" },
        ["<C-h>"] = { "<C-w>h", desc = "Cursor move to left split" },
        ["<C-j>"] = { "<C-w>j", desc = "Cursor move to below split" },
        ["<C-k>"] = { "<C-w>k", desc = "Cursor move to above split" },
        ["<C-l>"] = { "<C-w>l", desc = "Cursor move to right split" },

        -- buffer
        H = {
          function() astrocore_buffer.nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
          desc = "Buffer to left",
        },
        L = {
          function() astrocore_buffer.nav(vim.v.count > 0 and vim.v.count or 1) end,
          desc = "Buffer to right",
        },
        [">b"] = {
          function() astrocore_buffer.move(vim.v.count1) end,
          desc = "Buffer move right",
        },
        ["<b"] = {
          function() astrocore_buffer.move(-vim.v.count1) end,
          desc = "Buffer move left",
        },
        ["<M-BS>"] = { astrocore_buffer.close, desc = "Buffer close current" },
        --["<Leader><Leader>"] = { "<Cmd>e #<CR>", desc = "Switch to alternate buffer" },
        ["<Leader>bn"] = { "<Cmd>enew<CR>", desc = "Buffer New" },
        ["<Leader>bC"] = {
          function() astrocore_buffer.close_all(true) end,
          desc = "Buffer close all except current",
        },
        ["<Leader>bh"] = { astrocore_buffer.close_left, desc = "Buffer close all to the left" },
        ["<Leader>bl"] = { astrocore_buffer.close_right, desc = "Buffer close all to the right" },
        ["<Leader>bse"] = {
          function() astrocore_buffer.sort "extension" end,
          desc = "Buffer sort by extension",
        },
        ["<Leader>bsr"] = {
          function() astrocore_buffer.sort "unique_path" end,
          desc = "Buffer sort by relative path",
        },
        ["<Leader>bsp"] = {
          function() astrocore_buffer.sort "full_path" end,
          desc = "Buffer sort by full path",
        },
        ["<Leader>bsi"] = {
          function() astrocore_buffer.sort "bufnr" end,
          desc = "Buffer sort by buffer number",
        },
        ["<Leader>bsm"] = {
          function() astrocore_buffer.sort "modified" end,
          desc = "Buffer sort by modification",
        },

        -- tab
        ["<Tab><Tab>"] = { vim.cmd.tabnew, desc = "Tab new" },
        ["<Tab><BS>"] = { vim.cmd.tabclose, desc = "Tab close" },
        ["<Tab>l"] = { vim.cmd.tabnext, desc = "Tab next" },
        ["<Tab>h"] = { vim.cmd.tabprevious, desc = "Tab previous" },
        ["<Tab>a"] = { vim.cmd.tabfirst, desc = "tab first" },
        ["<Tab>z"] = { vim.cmd.tablast, desc = "Tab last" },

        -- toggles
        ["<Leader>tA"] = { astrocore_toggles.autochdir, desc = "Toggle rooter autochdir" },
        ["<Leader>tb"] = { astrocore_toggles.background, desc = "Toggle background" },
        ["<Leader>td"] = { astrocore_toggles.diagnostics, desc = "Toggle diagnostics" },
        ["<Leader>tg"] = { astrocore_toggles.signcolumn, desc = "Toggle signcolumn" },
        ["<Leader>t>"] = { astrocore_toggles.foldcolumn, desc = "Toggle foldcolumn" },
        ["<Leader>ti"] = { astrocore_toggles.indent, desc = "Change indent setting" },
        ["<Leader>tl"] = { astrocore_toggles.statusline, desc = "Toggle statusline" },
        ["<Leader>tn"] = { astrocore_toggles.number, desc = "Change line numbering" },
        ["<Leader>tN"] = { astrocore_toggles.notifications, desc = "Toggle Notifications" },
        ["<Leader>tp"] = { astrocore_toggles.paste, desc = "Toggle paste mode" },
        ["<Leader>ts"] = { astrocore_toggles.spell, desc = "Toggle spellcheck" },
        ["<Leader>tS"] = { astrocore_toggles.conceal, desc = "Toggle conceal" },
        ["<Leader>tt"] = { astrocore_toggles.tabline, desc = "Toggle tabline" },
        ["<Leader>tu"] = { astrocore_toggles.url_match, desc = "Toggle URL highlight" },
        ["<Leader>tw"] = { astrocore_toggles.wrap, desc = "Toggle wrap" },
        ["<Leader>ty"] = { astrocore_toggles.buffer_syntax, desc = "Toggle syntax highlight" },

        -- lsp
        ["[d"] = { vim.diagnostic.goto_prev, desc = "LSP diagnostic previous" },
        ["]d"] = { vim.diagnostic.goto_next, desc = "LSP diagnostic next" },

        -- plugin
        ["<Leader>pi"] = { lazy.install, desc = "Plugins Install" },
        ["<Leader>ps"] = { lazy.home, desc = "Plugins Status" },
        ["<Leader>pS"] = { lazy.sync, desc = "Plugins Sync" },
        ["<Leader>pu"] = { lazy.check, desc = "Plugins Check Updates" },
        ["<Leader>pU"] = { lazy.update, desc = "Plugins Update" },
        ["<Leader>pa"] = { require("astrocore").update_packages, desc = "Plugins Update Lazy and Mason" },
      },
      i = {
        ["<C-s>"] = { "<Esc><Cmd>w<CR>", desc = "Save file" },
        ["<C-h>"] = { "<C-w>" }, -- delete word to the left
      },
      v = {
        ["<Tab>"] = { ">gv", desc = "Stay in right indenting" },
        ["<S-Tab>"] = { "<gv", desc = "Stay in left indenting" },
      },
      x = {
        j = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" },
        k = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" },

        ["<C-s>"] = { "<Esc><Cmd>w<CR>", desc = "Save file" },
      },
      t = {
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
        ["<C-h>"] = { "<Cmd>wincmd h<CR>", desc = "Terminal left window navigation" },
        ["<C-j>"] = { "<Cmd>wincmd j<CR>", desc = "Terminal below window navigation" },
        ["<C-k>"] = { "<Cmd>wincmd k<CR>", desc = "Terminal above window navigation" },
        ["<C-l>"] = { "<Cmd>wincmd l<CR>", desc = "Terminal right window navigation" },
      },
    }

    if is_available "nvim-autopairs" then
      opts.mappings.n["<Leader>ta"] = { astrocore_toggles.autopairs, desc = "Toggle autopairs" }
    end

    if is_available "nvim-cmp" then
      opts.mappings.n["<Leader>tc"] = { astrocore_toggles.cmp, desc = "Toggle autocompletion" }
    end

    if is_available "indent-blankline.nvim" then
      opts.mappings.n["<Leader>t|"] = { "<Cmd>IBLToggle<CR>", desc = "Toggle indent guides" }
    end

    if is_available "mason.nvim" then
      opts.mappings.n["<Leader>pm"] = { require("mason.ui").open, desc = "Mason Installer" }
      opts.mappings.n["<Leader>pM"] = { require("astrocore.mason").update_all, desc = "Mason Update" }
    end

    if is_available "nvim-colorizer.lua" then
      opts.mappings.n["<Leader>tC"] = { "<Cmd>ColorizerToggle<CR>", desc = "Toggle colorizer" }
    end
  end,
}
