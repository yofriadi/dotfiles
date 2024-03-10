-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      options = {
        opt = { -- vim.opt.<key>
          cursorline = false, -- highlight the text line of the cursor
          fillchars = {
            --fold = "⸱",
            foldsep = " ",
            foldopen = "",
            foldclose = "",
            diff = "╱",
            eob = " ", -- disable `~` on nonexistent lines
          },
          --foldmethod = "expr",
          --foldlevelstart = 99, -- start with all code unfolded
          mouse = "", -- disable mouse support
          pumblend = 10, -- Popup blend
          shiftround = true, -- Round indent
          --smartindent = true, -- Insert indents automatically
          splitkeep = "screen",
          undofile = true, -- enable persistent undo
          undolevels = 10000,
          updatetime = 200, -- length of time to wait before triggering the plugin
          smoothscroll = true,
          autowrite = true, -- Enable auto write
          confirm = true,
          formatoptions = "jcroqlnt", -- tcqj
          grepformat = "%f:%l:%c:%m",
          grepprg = "rg --vimgrep",
          inccommand = "nosplit", -- preview incremental substitute
          showbreak = "↪ ",
          list = true, -- Show some invisible characters (tabs...
          listchars = "tab:→.,eol:¬,nbsp:.,space:.,multispace:..,trail:•,extends:›,precedes:‹",
          scrolloff = 4, -- Lines of context
          sidescrolloff = 8, -- Columns of context
          sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
          spelllang = { "en" },
          wildmode = "longest:full,full", -- Command-line completion mode
          winminwidth = 5, -- Minimum window width
        },
        g = { -- vim.g.<key>
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },
    })
  end,
}
