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
	--{ import = "astrocommunity.diagnostics.lsp_lines-nvim" }, -- virtual text still show up
	{ import = "astrocommunity.diagnostics.trouble-nvim" },
	{ import = "astrocommunity.editing-support.cutlass-nvim" },
	{ import = "astrocommunity.editing-support.mini-splitjoin" },
	{ import = "astrocommunity.editing-support.neogen" },
	{ import = "astrocommunity.editing-support.telescope-undo-nvim" },
	{ import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	{ import = "astrocommunity.editing-support.treesj" },
	{ import = "astrocommunity.editing-support.true-zen-nvim" },
	{ import = "astrocommunity.editing-support.yanky-nvim" },
	{ import = "astrocommunity.git.diffview-nvim" },
	{ import = "astrocommunity.indent.mini-indentscope" },
	{ import = "astrocommunity.scrolling.neoscroll-nvim" },
	{ import = "astrocommunity.motion.nvim-spider" },
	{ import = "astrocommunity.motion.mini-ai" },
	{ import = "astrocommunity.motion.flash-nvim" },
	--{ import = "astrocommunity.motion.mini-basics", enabled = false }, -- conflict with mapping C-z
	--{ import = "astrocommunity.motion.mini-bracketed" },
	{ import = "astrocommunity.motion.mini-move" },
	{ import = "astrocommunity.motion.mini-surround" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.project.nvim-spectre" },
	{ import = "astrocommunity.syntax.hlargs-nvim" },
	{ import = "astrocommunity.utility.neodim" },
	{ import = "astrocommunity.utility.noice-nvim" },
	-- { import = "astrocommunity.test.neotest", enabled = false },
	-- { import = "astrocommunity.test.nvim-coverage", enabled = false}
}
