vim.opt.viewoptions:remove "curdir" -- disable saving current directory with views
vim.opt.shortmess:append { W = true, I = true, c = true, C = true } -- disable search count wrap and startup messages
vim.opt.backspace:append { "nostop" } -- don't stop backspace at insert
vim.opt.diffopt:append "linematch:60" -- enable linematch diff algorithm

vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })

local options = {
  opt = {
    breakindent = true, -- wrap indent to match  line start
    clipboard = "unnamedplus", -- connection to the system clipboard
    cmdheight = 0, -- hide command line unless needed
    completeopt = "menu,menuone,noselect", -- Options for insert mode completion
    copyindent = true, -- copy the previous indentation on autoindenting
    cursorline = true, -- highlight the text line of the cursor
    expandtab = true, -- enable the use of space in tab
    fileencoding = "utf-8", -- file content encoding for the buffer
    fillchars = {
      foldopen = "",
      foldclose = "",
      --fold = "⸱",
      --fold = " ",
      foldsep = " ",
      diff = "╱",
      eob = " ", -- disable `~` on nonexistent lines
    },
    foldenable = true, -- enable fold for nvim-ufo
    foldmethod = "expr",
    foldlevel = 99, -- set high foldlevel for nvim-ufo
    foldlevelstart = 99, -- start with all code unfolded
    foldcolumn = "1", -- show foldcolumn in nvim 0.9
    history = 100, -- number of commands to remember in a history table
    ignorecase = true, -- case insensitive searching
    infercase = true, -- infer cases in keyword completion
    laststatus = 3, -- global statusline
    linebreak = true, -- wrap lines at 'breakat'
    mouse = "", -- disable mouse support
    number = true, -- show numberline
    preserveindent = true, -- preserve indent structure as much as possible
    pumblend = 10, -- Popup blend
    pumheight = 10, -- height of the pop up menu
    relativenumber = true, -- show relative numberline
    shiftround = true, -- Round indent
    shiftwidth = 2, -- number of space inserted for indentation
    showmode = false, -- disable showing modes in command line
    showtabline = 2, -- always display tabline
    signcolumn = "yes", -- always show the sign column
    smartcase = true, -- case sensitive searching
    smartindent = true, -- Insert indents automatically
    splitbelow = true, -- splitting a new window below the current one
    splitright = true, -- splitting a new window at the right of the current one
    splitkeep = "screen",
    tabstop = 2, -- number of space in a tab
    termguicolors = true, -- enable 24-bit RGB color in the TUI
    timeoutlen = 300, -- shorten key timeout length a little bit for which-key
    undofile = true, -- enable persistent undo
    undolevels = 10000,
    updatetime = 200, -- length of time to wait before triggering the plugin
    virtualedit = "block", -- allow going past end of line in visual block mode
    wrap = false, -- disable wrapping of lines longer than the width of window
    writebackup = false, -- disable making a backup before overwriting a file
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
  g = {
    mapleader = " ", -- set leader key
    maplocalleader = " ", -- set default local leader key
    markdown_recommended_style = 0,
  },
}

for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end
