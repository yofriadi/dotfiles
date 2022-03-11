local util = require("util")

util.keymaps("n", {
    noremap = true,
    silent = true,
}, {
    {"<leader>ff", ":Telescope find_files<CR>"},
    {"<leader>fg", ":Telescope live_grep<CR>"},
    {"<leader>fb", ":Telescope buffers show_all_buffers=true<CR>"},
    {"<leader>fp", ":Telescope project<CR>"},
    {"<leader>fc", ":Telescope commands<CR>"},
    -- {"<leader>fa", "<cmd>lua require('packs.nvim-telescope').code_actions()<CR>"}
})

--[[ function code_actions()
  local opts = {
    winblend = 15,
    layout_config = {
      prompt_position = "top",
      width = 80,
      height = 12,
    },
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    previewer = false,
    shorten_path = false,
  }

  local builtin = require "telescope.builtin"
  local themes = require "telescope.themes"
  builtin.lsp_code_actions(themes.get_dropdown(opts))
end ]]--

return function()
    local previewers = require "telescope.previewers"
    local sorters = require "telescope.sorters"
    local actions = require "telescope.actions"

    require("telescope").setup {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
		"--hidden",
            },
            prompt_prefix = " ",
            selection_caret = " ",
            entry_prefix = " ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
                horizontal = { mirror = false },
                vertical = { mirror = false },
                width = 0.75,
                preview_cutoff = 120,
            },
            file_ignore_patterns = {},
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            -- use_less = true,
	    path_display = { shorten = 5 },
	    set_env = { ["COLORTERM"] = "truecolor" },
	    pickers = {
              find_files = {
                find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
              },
              live_grep = {
                --@usage don't include the filename in the search results
                only_sort_text = true,
              },
            },
	    i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<CR>"] = actions.select_default + actions.center,
            },
            n = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
	    file_previewer = previewers.vim_buffer_cat.new,
            grep_previewer = previewers.vim_buffer_vimgrep.new,
            qflist_previewer = previewers.vim_buffer_qflist.new,
            file_sorter = sorters.get_fuzzy_file,
            generic_sorter = sorters.get_generic_fuzzy_sorter,
        },
        extensions = {
            fzf = {
		fuzzy = true,
		override_generic_sorter = true,
		override_file_sorter = true,
		case_mode = "smart_case",
            }
        }
    }

    require('telescope').load_extension('fzf')
end
