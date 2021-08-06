return function()
    -- if not packer_plugins["plenary.nvim"].loaded or not packer_plugins["popup.nvim"].loaded then
    --     vim.cmd [[packadd plenary.nvim]]
    --     vim.cmd [[packadd popup.nvim]]
    --     vim.cmd [[packadd telescope-project.nvim]]
    --     vim.cmd [[packadd telescope-fzy-native.nvim]]
    --     vim.cmd [[packadd telescope-frecency.nvim]]
    -- end

    require("telescope").setup {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case"
            },
            prompt_prefix = " ",
            selection_caret = " ",
            entry_prefix = " ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
                horizontal = {mirror = false},
                vertical = {mirror = false},
                width = 0.75,
                preview_cutoff = 120,
            },
            file_sorter = require "telescope.sorters".get_fzy_file,
            file_ignore_patterns = {},
            generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
            winblend = 0,
            border = {},
            borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
            color_devicons = true,
            use_less = true,
            path_display = {},
            set_env = {["COLORTERM"] = "truecolor"},
            file_previewer = require "telescope.previewers".vim_buffer_cat.new,
            grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
            qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
            buffer_previewer_maker = require "telescope.previewers".buffer_previewer_maker,
        },
        --[[ extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true,
            }
        } ]]--
    }

    -- require("telescope").load_extension("project")
    -- require("telescope").load_extension("fzy_native")
    -- require('telescope').load_extension('frecency')
end
