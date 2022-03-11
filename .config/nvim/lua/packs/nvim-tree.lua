local util = require("util")

util.keymaps("n", {
    noremap = true,
    silent = true,
}, {
    {"<C-n>", ":NvimTreeToggle<CR>"},
})

return function()
    vim.g.nvim_tree_add_trailing = 1
    vim.g.nvim_tree_quit_on_open = 1
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_show_icons = {
       git = 1,
       folders = 0,
       folder_arrows = 0,
       files = 1,
    }

    local tree_cb = require'nvim-tree.config'.nvim_tree_callback

    require"nvim-tree".setup {
        disable_netrw = 1,
        hide_dotfiles = 1,
        auto_close = 1,
        ignore = {".DS_Store", ".git", "node_modules"},
        follow = 1,
        hijack_cursor = 0,
	quit_on_open = 1,
	git_hl = 1,
	update_focused_file = {
            enable = true,
            update_cwd = false,
        },
        diagnostics = {
            enable = 0,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
	icons = {
	    git = {
                unstaged = "",
                staged = "",
                unmerged = "",
                renamed = "",
                untracked = "",
                ignored = "◌",
            },
	},
        view = {
            width = 35,
	    mappings = {
		list = {
		    { key = "s", cb = tree_cb("vsplit") },
		    { key = "S", cb = tree_cb("split") },
		}
	    },
        },
    }
end
