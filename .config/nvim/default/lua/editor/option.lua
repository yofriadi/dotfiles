return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local options = {
      opt = { -- vim.opt.<key>
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
        wrap = false,
        autowrite = true,
        clipboard = vim.env.SSH_TTY and "" or "unnamedplus", -- only set clipboard if not in ssh, to make sure the OSC 52 integration works automatically. Sync with system clipboard.
        completeopt = { "menu", "menuone", "noselect" },
        conceallevel = 2, -- Hide * markup for bold and italic, but not markers with substitutions.
        confirm = true, -- Confirm to save changes before exiting modified buffer
        cursorline = true,
        expandtab = true, -- Use spaces instead of tabs
        fillchars = {
          fold = "⸱",
          foldsep = " ",
          foldopen = "",
          foldclose = "",
          diff = "╱",
          eob = " ", -- disable `~` on nonexistent lines
        },
        foldmethod = "expr",
        foldtext = "",
        foldlevel = 99, -- set high foldlevel for nvim-ufo
        foldlevelstart = 99, -- start with all code unfolded
        foldcolumn = "1", -- show foldcolumn
        foldexpr = "v:lua.require'util'.ui.foldexpr()",
        formatexpr = "v:lua.require'util'.format.formatexpr()",
        formatoptions = "jcroqlnt", -- tcqj
        grepformat = "%f:%l:%c:%m",
        grepprg = "rg --vimgrep",
        ignorecase = true,
        inccommand = "nosplit", -- preview incremental substitute
        laststatus = 3, -- global statusline
        linebreak = true, -- wrap lines at 'breakat'
        list = true, -- Show some invisible characters (tabs...
        listchars = "tab:→.,eol:¬,nbsp:.,space:.,multispace:..,trail:•,extends:›,precedes:‹",
        showbreak = "↪ ",
        mouse = "", -- disable mouse support
        pumblend = 10, -- Popup blend
        pumheight = 10, -- height of the pop up menu
        scrolloff = 4, -- Lines of context
        sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
        shiftround = true, -- Round indent
        shiftwidth = 0, -- number of space inserted for indentation; when zero the 'tabstop' value will be used
        shortmess = vim.tbl_deep_extend("force", vim.opt.shortmess:get(), { W = true, I = true, c = true, C = true }), -- disable search count wrap and startup messages
        showmode = false, -- disable showing modes in command line
        sidescrolloff = 8, -- Columns of context
        smartcase = true, -- case sensitive searching
        smartindent = true, -- Insert indents automatically
        spelllang = { "en" },
        spelloptions = vim.tbl_deep_extend("force", vim.opt.spelloptions:get(), { "noplainbuffer" }),
        splitbelow = true, -- splitting a new window below the current one
        splitright = true, -- splitting a new window at the right of the current one
        splitkeep = "screen",
        tabstop = 2, -- number of space in a tab
        termguicolors = true, -- enable 24-bit RGB color in the TUI
        undofile = true, -- enable persistent undo
        undolevels = 10000,
        updatetime = 200, -- length of time to wait before triggering the plugin
        virtualedit = "block", -- allow going past end of line in visual block mode
        wildmode = "longest:full,full", -- Command-line completion mode
        winminwidth = 5, -- Minimum window width
        smoothscroll = true,
        backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" }), -- don't stop backspace at insert
        breakindent = true, -- wrap indent to match line start
        cmdheight = 0,
        copyindent = true, -- copy the previous indentation on autoindenting
        diffopt = vim.list_extend(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" }), -- enable linematch diff algorithm
        infercase = true, -- infer cases in keyword completion
        preserveindent = true, -- preserve indent structure as much as possible
        showtabline = 2, -- always display tabline
        viewoptions = vim.tbl_filter(function(val) return val ~= "curdir" end, vim.opt.viewoptions:get()),
        writebackup = false, -- disable making a backup before overwriting a file
        --timeoutlen = 400,           -- shorten key timeout length a little bit for which-key
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        --mapleader = " ",
        --maplocalleader = ",",
        markdown_recommended_style = 0, -- Fix markdown indentation settings
      },
    }

    -- initialize buffer list
    if not vim.t.bufs then vim.t.bufs = vim.api.nvim_list_bufs() end

    local in_wsl = os.getenv "Arch" ~= nil or os.getenv "NixOS" ~= nil
    if in_wsl then
      options.g.clipboard = {
        name = "wsl clipboard",
        copy = { ["+"] = { "clip.exe" }, ["*"] = { "clip.exe" } },
        paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
        cache_enabled = true,
      }
    end

    return require("astrocore").extend_tbl(opts, { options = options })
  end,
}
