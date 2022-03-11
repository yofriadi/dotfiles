return function()
    vim.opt.list = true
    vim.opt.listchars:append("eol:↴,tab:▏·,trail:•,extends:→,precedes:←,nbsp:_,space:⋅")

    require("indent_blankline").setup {
        char = "▏",
        show_first_indent_level = true,
        show_trailing_blankline_indent = true,
        show_current_context = true,
	show_current_context_start = true,
	show_end_of_line = true,
	space_char_blankline = " ",
        context_patterns = {
            "class",
            "function",
            "method",
            "block",
            "list_literal",
            "selector",
            "^if",
            "^table",
            "if_statement",
            "while",
            "for",
        },
        filetype_exclude = {
            -- "startify",
            -- "dashboard",
            -- "fugitive",
            -- "gitcommit",
            "packer",
            -- "markdown",
            -- "json",
            -- "txt",
            "help",
            "NvimTree",
            "TelescopePrompt",
	    "TelescopeResults",
            -- "undotree",
            -- "flutterToolsOutline",
        },
        buftype_exclude = {
            "terminal",
            "nofile",
        },
    }
end
