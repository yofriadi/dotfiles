return {
	-- Add the community repository of plugin specifications
	"AstroNvim/astrocommunity",
	-- example of importing a plugin, comment out to use it or add your own
	-- available plugins can be found at https://github.com/AstroNvim/astrocommunity

	--{ import = "astrocommunity.completion.copilot-lua-cmp", enabled = false },
	{ import = "astrocommunity.bars-and-lines.scope-nvim" },
	{ import = "astrocommunity.bars-and-lines.vim-illuminate" },
	--{ import = "astrocommunity.color.headlines-nvim" }, -- if using neorg
	{ import = "astrocommunity.color.modes-nvim" },
	{ import = "astrocommunity.color.tint-nvim" },
	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
	--{ import = "astrocommunity.colorscheme.oxocarbon-nvim", enabled = false },
	--{ import = "astrocommunity.colorscheme.catppuccin", enabled = false },
	{ import = "astrocommunity.editing-support.cutlass-nvim" },
	{ import = "astrocommunity.editing-support.mini-splitjoin" },
	{ import = "astrocommunity.editing-support.neogen" },
	{ import = "astrocommunity.editing-support.telescope-undo-nvim" },
	{ import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
	{ import = "astrocommunity.editing-support.treesj" },
	{ import = "astrocommunity.editing-support.true-zen-nvim" },
	{ import = "astrocommunity.editing-support.yanky-nvim" },
	{ import = "astrocommunity.git.diffview-nvim" },
	{ import = "astrocommunity.git.neogit" },
	{ import = "astrocommunity.indent.mini-indentscope" },
	{ import = "astrocommunity.lsp.garbage-day-nvim" },
	--{ import = "astrocommunity.lsp.lsp-inlayhints-nvim" }, -- not working
	--{ import = "astrocommunity.lsp.lsp-signature-nvim" }, -- conflict with Noice.nvim
	{ import = "astrocommunity.markdown-and-latex.glow-nvim" },
	{ import = "astrocommunity.motion.nvim-spider" },
	{ import = "astrocommunity.motion.mini-ai" },
	{ import = "astrocommunity.motion.flash-nvim" },
	--{ import = "astrocommunity.motion.mini-basics", enabled = false }, -- conflict with mapping C-z
	--{ import = "astrocommunity.motion.mini-bracketed" },
	{ import = "astrocommunity.motion.mini-move" },
	{ import = "astrocommunity.motion.mini-surround" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.full-dadbod" },
	{ import = "astrocommunity.pack.docker" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.programming-language-support.rest-nvim" },
	{ import = "astrocommunity.register.nvim-neoclip-lua" },
	--{ import = "astrocommunity.scrolling.cinnamon-nvim" },
	{ import = "astrocommunity.scrolling.neoscroll-nvim" },
	{ import = "astrocommunity.scrolling.satellite-nvim" },
	--{ import = "astrocommunity.scrolling.nvim-scrollbar" },
	{ import = "astrocommunity.search.nvim-hlslens" },
	{ import = "astrocommunity.split-and-window.minimap-vim" },
	{ import = "astrocommunity.syntax.hlargs-nvim" },
	--{ import = "astrocommunity.utility.neodim" },
	{ import = "astrocommunity.workflow.hardtime-nvim" },

	{ import = "astrocommunity.git.blame-nvim" },
	{
		"FabijanZulj/blame.nvim",
		keys = {
			{ "<Leader>gB", "<Cmd>ToggleBlame window<CR>", desc = "Git blame" },
		},
		config = function()
			require("blame").setup({ date_format = "%d/%m/%Y %H:%M" })
		end,
	},

	{ import = "astrocommunity.diagnostics.lsp_lines-nvim" },
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			local lsp_lines = require("lsp_lines")
			vim.api.nvim_create_autocmd("FileType", {
				desc = "Disable the plugin in Lazy buffer",
				pattern = "lazy",
				callback = function()
					local previous = not lsp_lines.toggle()
					if not previous then
						lsp_lines.toggle()
					end
				end,
			})

			lsp_lines.setup()
		end,
	},

	{ import = "astrocommunity.utility.noice-nvim" },
	{
		"folke/noice.nvim",
		keys = function()
			local noice = require("noice")
			local noice_lsp = require("noice.lsp")

			return {
				{
					"<Leader>en",
					function()
						noice.cmd("history")
					end,
					desc = "Noice History",
				},
				{
					"<Leader>un",
					function()
						noice.cmd("dismiss")
					end,
					desc = "Noice dismiss All",
				},
				{
					"<C-f>",
					function()
						if not noice_lsp.scroll(4) then
							return "<C-f>"
						end
					end,
					silent = true,
					expr = true,
					desc = "Scroll forward",
					mode = { "i", "n", "s" },
				},
				{
					"<C-b>",
					function()
						if not noice_lsp.scroll(-4) then
							return "<C-b>"
						end
					end,
					silent = true,
					expr = true,
					desc = "Scroll backward",
					mode = { "i", "n", "s" },
				},
			}
		end,
	},

	{ import = "astrocommunity.project.nvim-spectre" },
	{
		"nvim-pack/nvim-spectre",
		opts = function()
			return {
				mapping = {
					--send_to_qf = { map = "q" },
					replace_cmd = { map = "c" },
					show_option_menu = { map = "o" },
					run_current_replace = { map = "C" },
					run_replace = { map = "R" },
					change_view_mode = { map = "v" },
					resume_last_search = { map = "l" },
				},
			}
		end,
		keys = function()
			return {
				{
					"<Leader>eS",
					mode = "n",
					function()
						require("spectre").open()
					end,
					desc = "Search and replace",
				},
				{
					"<Leader>eS",
					mode = "x",
					function()
						require("spectre").open_visual({ select_word = true })
					end,
					desc = "Spectre (current word)",
				},
			}
		end,
	},

	{ import = "astrocommunity.diagnostics.trouble-nvim" },
	{
		"folke/trouble.nvim",
		keys = function()
			local trouble = require("trouble")

			return {
				{
					"<Leader>ex",
					"<Cmd>TroubleToggle document_diagnostics<CR>",
					desc = "Document Diagnostics (Trouble)",
				},
				{
					"<Leader>eX",
					"<Cmd>TroubleToggle workspace_diagnostics<CR>",
					desc = "Workspace Diagnostics (Trouble)",
				},
				{ "<Leader>eL", "<Cmd>TroubleToggle loclist<CR>",  desc = "Location List (Trouble)" },
				{ "<Leader>eQ", "<Cmd>TroubleToggle quickfix<CR>", desc = "Quickfix List (Trouble)" },
				{
					"[q",
					function()
						if trouble.is_open() then
							trouble.previous({ skip_groups = true, jump = true })
						else
							local ok, err = pcall(vim.cmd.cprev)
							if not ok then
								vim.notify(err, vim.log.levels.ERROR)
							end
						end
					end,
					desc = "Previous trouble/quickfix item",
				},
				{
					"]q",
					function()
						if trouble.is_open() then
							trouble.next({ skip_groups = true, jump = true })
						else
							local ok, err = pcall(vim.cmd.cnext)
							if not ok then
								vim.notify(err, vim.log.levels.ERROR)
							end
						end
					end,
					desc = "Next trouble/quickfix item",
				},
			}
		end,
	},

	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	{
		"folke/todo-comments.nvim",
		keys = function()
			local todo_comments = require("todo-comments")
			return {
				{
					"]t",
					function()
						todo_comments.jump_next()
					end,
					desc = "Next todo comment",
				},
				{
					"[t",
					function()
						require("todo-comments").jump_prev()
					end,
					desc = "Previous todo comment",
				},
				{ "<Leader>et", "<cmd>TodoTrouble<cr>",   desc = "Todo Trouble" },
				{ "<Leader>fT", "<cmd>TodoTelescope<cr>", desc = "Search todo" },
			}
		end,
	},

	-- { import = "astrocommunity.test.neotest", enabled = false },
	-- { import = "astrocommunity.test.nvim-coverage", enabled = false}
}
