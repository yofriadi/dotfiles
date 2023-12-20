local utils = require("astronvim.utils")
local is_available = utils.is_available

return {
	-- customize alpha options
	{
		"goolord/alpha-nvim",
		opts = function(_, opts)
			-- customize the dashboard header
			opts.section.header.val = {
				" █████  ███████ ████████ ██████   ██████",
				"██   ██ ██         ██    ██   ██ ██    ██",
				"███████ ███████    ██    ██████  ██    ██",
				"██   ██      ██    ██    ██   ██ ██    ██",
				"██   ██ ███████    ██    ██   ██  ██████",
				" ",
				"    ███    ██ ██    ██ ██ ███    ███",
				"    ████   ██ ██    ██ ██ ████  ████",
				"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
				"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
				"    ██   ████   ████   ██ ██      ██",
			}
			return opts
		end,
	},
	-- You can disable default plugins as follows:
	-- { "max397574/better-escape.nvim", enabled = false },
	--
	-- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
	-- {
	--   "L3MON4D3/LuaSnip",
	--   config = function(plugin, opts)
	--     require "plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
	--     -- add more custom luasnip configuration such as filetype extend or custom snippets
	--     local luasnip = require "luasnip"
	--     luasnip.filetype_extend("javascript", { "javascriptreact" })
	--   end,
	-- },
	-- {
	--   "windwp/nvim-autopairs",
	--   config = function(plugin, opts)
	--     require "plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
	--     -- add more custom autopairs configuration such as custom rules
	--     local npairs = require "nvim-autopairs"
	--     local Rule = require "nvim-autopairs.rule"
	--     local cond = require "nvim-autopairs.conds"
	--     npairs.add_rules(
	--       {
	--         Rule("$", "$", { "tex", "latex" })
	--           -- don't add a pair if the next character is %
	--           :with_pair(cond.not_after_regex "%%")
	--           -- don't add a pair if  the previous character is xxx
	--           :with_pair(
	--             cond.not_before_regex("xxx", 3)
	--           )
	--           -- don't move right when repeat character
	--           :with_move(cond.none())
	--           -- don't delete if the next character is xx
	--           :with_del(cond.not_after_regex "xx")
	--           -- disable adding a newline when you press <cr>
	--           :with_cr(cond.none()),
	--       },
	--       -- disable for .vim files, but it work for another filetypes
	--       Rule("a", "a", "-vim")
	--     )
	--   end,
	-- },
	-- By adding to the which-key config and using our helper function you can add more which-key registered bindings
	-- {
	--   "folke/which-key.nvim",
	--   config = function(plugin, opts)
	--     require "plugins.configs.which-key"(plugin, opts) -- include the default astronvim config that calls the setup call
	--     -- Add bindings which show up as group name
	--     local wk = require "which-key"
	--     wk.register({
	--       b = { name = "Buffer" },
	--     }, { mode = "n", prefix = "<leader>" })
	--   end,
	-- },
	{ "stevearc/aerial.nvim", enabled = false },
	{
		"mrjones2014/smart-splits.nvim",
		keys = function()
			if is_available("smart-splits.nvim") ~= true then
				return {}
			end

			return {
				{
					"<C-W>r",
					function()
						require("smart-splits").start_resize_mode()
					end,
					desc = "Resize mode",
				},
			}
		end,
	},
	{
		"echasnovski/mini.bufremove",
		keys = function()
			if is_available("mini.bufremove") ~= true then
				return {}
			end

			return {
				{
					"C",
					function()
						local bd = require("mini.bufremove").delete
						if vim.bo.modified then
							local choice =
								vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
							if choice == 1 then -- Yes
								vim.cmd.write()
								bd(0)
							elseif choice == 2 then -- No
								bd(0, true)
							end
						else
							bd(0)
						end
					end,
					desc = "Delete Buffer",
				},
			}
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = function()
			if is_available("telescope.nvim") ~= true then
				return {}
			end

			local tsb = require("telescope.builtin")
			return {
				{
					"<Leader>f?",
					function()
						tsb.live_grep({ hidden = true, no_ignore = true })
					end,
					desc = "Search all words",
				},
				{
					"<Leader>fv",
					function()
						tsb.vim_options()
					end,
					desc = "Search Vim options",
				},
				{
					"<Leader>fs",
					function()
						tsb.lsp_document_symbols()
					end,
					desc = "Search document symbol",
				},
				{
					"<Leader>fS",
					function()
						tsb.lsp_dynamic_workspace_symbols()
					end,
					desc = "Search workspace symbol",
				},
			}
		end,
	},
}
