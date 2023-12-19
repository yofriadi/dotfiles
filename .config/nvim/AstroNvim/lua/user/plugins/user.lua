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
	{
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
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		keys = {
			{
				"<Leader>uD",
				function()
					vim.diagnostic.config({ virtual_text = not require("lsp_lines").toggle() })
				end,
				desc = "Toggle virtual diagnostic lines",
			},
		},
		config = function()
			local lsp_lines = require("lsp_lines")
			-- Disable the plugin in Lazy.nvim
			vim.api.nvim_create_autocmd("FileType", {
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
	--[[ {
    "echasnovski/mini.move",
    version = false,
    config = function(_, opts) require("mini.move").setup(opts) end,
    keys = {
      { "¬", mode = { "n", "v" } },
      { "˚", mode = { "n", "v" } },
      { "∆", mode = { "n", "v" } },
      { "˙", mode = { "n", "v" } },
    },
    opts = {
      mappings = {
        -- Visual mode
        left = "˙",
        right = "¬",
        down = "∆",
        up = "˚",

        -- Normal mode
        line_left = "˙",
        line_right = "¬",
        line_down = "∆",
        line_up = "˚",
      },
      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  }, ]]
}
