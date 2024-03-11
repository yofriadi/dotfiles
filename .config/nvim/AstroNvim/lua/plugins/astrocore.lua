if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell

        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized

    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        -- L = {
        --   function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        --   desc = "Next buffer",
        -- },

        -- H = {
        --   function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,

        --   desc = "Previous buffer",
        -- },

        -- mappings seen under group name "Buffer"

        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

        -- DISABLE BUILT-IN BELOW
        --f = false, -- keymap group

        -- general
        --["<F7>"] = false,
        --["[t"] = false,
        --["]t"] = false,
        --["[b"] = false,
        --["]b"] = false,
        --["<Leader>q"] = false,
        --["<Leader>Q"] = false,
        --["<Leader>w"] = false,
        --["<Leader>n"] = false,
        --["<Leader>c"] = false,
        --["<Leader>/"] = false,

        -- toggles
        --["<Leader>ua"] = false, -- autopairs
        --["<Leader>uA"] = false,
        --["<Leader>ub"] = false,
        --["<Leader>ud"] = false,
        --["<Leader>ug"] = false,
        --["<Leader>u>"] = false,
        --["<Leader>ui"] = false,
        --["<Leader>ul"] = false,
        --["<Leader>un"] = false,
        --["<Leader>uN"] = false,
        --["<Leader>up"] = false,
        --["<Leader>us"] = false,
        --["<Leader>uS"] = false,
        --["<Leader>ut"] = false,
        --["<Leader>uu"] = false,
        --["<Leader>uw"] = false,
        --["<Leader>uy"] = false,

        -- Neotree
        --["<Leader>o"] = false,

        -- debugger
        --["<F5>"] = false,
        --["<F6>"] = false,
        --["<F9>"] = false,
        --["<F10>"] = false,
        --["<F11>"] = false,
        --["<C-F5>"] = false,
        --["<S-F5>"] = false,
        --["<S-F11>"] = false,

        -- ToggleTerm
        --["<C-'>"] = false,
        --["<Leader>tf"] = false,
        --["<Leader>th"] = false,
        --["<Leader>tv"] = false,
        --["<Leader>tl"] = false,  -- duplicated by toggles
        --["<Leader>tn"] = false,  -- duplicated by toggles
        --["<Leader>tp"] = false,  -- duplicated by toggles
        --["<Leader>tt"] = false,  -- duplicated by toggles

        -- Telescope
        --["<Leader>f'"] = false,
        --["<Leader>fb"] = false,
        --["<Leader>fc"] = false, -- quite nice actually
        --["<Leader>fC"] = false,
        --["<Leader>ff"] = false,
        --["<Leader>fF"] = false,
        --["<Leader>fh"] = false,
        --["<Leader>fk"] = false,
        --["<Leader>fm"] = false,
        --["<Leader>fn"] = false,
        --["<Leader>fo"] = false,
        --["<Leader>fr"] = false,
        --["<Leader>ft"] = false,
        --["<Leader>fw"] = false,
        --["<Leader>fW"] = false,

        -- Git
        --["<Leader>gb"] = false,
        --["<Leader>gc"] = false,
        --["<Leader>gC"] = false,
        --["<Leader>gt"] = false,

        -- LSP
        --["gy"] = false,
        --["gl"] = false,
        --["<Leader>lD"] = false,
        --["<Leader>lf"] = false,
        --["<Leader>lS"] = false,
        --["<Leader>lG"] = false,
        --["<Leader>lR"] = false,

        -- smart-splits
        --["<C-Up>"] = false,
        --["<C-Down>"] = false,
        --["<C-Left>"] = false,
        --["<C-Right>"] = false,
      },
      x = {
        -- DISABLE BUILT-IN BELOW
        --["<C-'>"] = false,
      },
      t = {
        -- DISABLE BUILT-IN BELOW
        --["<C-'>"] = false,
      },
    },
  },
}
