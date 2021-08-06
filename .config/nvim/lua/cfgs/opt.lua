local util = require "util"

return function()
    util.opt_global({
        smartcase = true,
        cursorline = true,
        number = true,
        relativenumber = true,
        showmode = false,
        undofile = true,
        lazyredraw = true,
        splitbelow = true,
        splitright = true,
        shortmess = "flmnrxtToOF",
        clipboard = "unnamedplus",
        grepprg = "rg --vimgrep --no-heading --smart-case",
        showtabline = 0,
        termguicolors = true,
        shell = "zsh",
        showbreak = " ↳  ",
        switchbuf = "usetab",
        list = true,
        listchars = "eol:↴,tab:▏·,trail:•,extends:→,precedes:←,nbsp:_,space:⋅",
        diffopt = "internal,filler,closeoff,horizontal",
        fillchars = "eob: ,",
    })

    util.opt_local({breakindent = true, breakindentopt = "shift:2,min:20", expandtab = true, foldenable = true, foldlevel = 99, synmaxcol = 180})
end
