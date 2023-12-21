return {
	{
		"TobinPalmer/Tip.nvim",
		event = "VimEnter",
		init = function()
			require("tip").setup({
				seconds = 2,
				title = "Tip!",
				url = "https://vtip.43z.one",
			})
		end,
	},
	{
		"cpea2506/relative-toggle.nvim",
		config = function()
			require("relative-toggle").setup({
				pattern = "*",
				events = {
					on = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" },
					off = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" },
				},
			})
		end,
	},
	--[[ {
		"FabianWirth/search.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	}, ]]
	--[[ {
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "goimports-reviser", "gofmt", "gofumpt", "golines" },
				},
			})
		end,
	}, ]]
}
