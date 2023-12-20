return {
	n = {
		--e = { desc = get_icon("Window", 1, true) .. "Editor" }, -- not working
		["<Leader>e"] = false,
		["<Leader><Leader>"] = { "<C-^>", desc = "switch between current and last file opened" },
		[";"] = { ":", desc = "Faster command key" },
		X = "S",
		L = {
			function()
				require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
			end,
			desc = "Next buffer",
		},
		H = {
			function()
				require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
			end,
			desc = "Previous buffer",
		},

		-- Window
		["<C-W>c"] = { "<C-W>c", desc = "Close window", noremap = false },
		["<C-W>d"] = { "<C-W>c", desc = "Close window", noremap = false }, -- convenient key
		["<C-W>_"] = { "<C-W>s", desc = "Split window below", noremap = false },
		["<C-W>|"] = { "<C-W>v", desc = "Split window right", noremap = false },
		["<C-W>S"] = { "<C-W>v", desc = "Split window right", noremap = false }, -- convenient key

		-- Tab
		["<Leader><Tab><Tab>"] = { "<Cmd>tabnew<CR>", desc = "New tab" },
		["<Leader><Tab>c"] = { "<Cmd>tabclose<Cr>", desc = "Close tab" },
		["<Leader><Tab>d"] = { "<Cmd>tabclose<Cr>", desc = "Close tab" }, -- convenient key
		["<Leader><Tab>]"] = { "<Cmd>tabnext<Cr>", desc = "Next tab" },
		["<Leader><Tab>l"] = { "<Cmd>tabnext<Cr>", desc = "Next tab" },
		["<Leader><Tab>["] = { "<Cmd>tabprevious<Cr>", desc = "Previous tab" },
		["<Leader><Tab>h"] = { "<Cmd>tabprevious<Cr>", desc = "Previous tab" },
		["<Leader><Tab>F"] = { "<Cmd>tabfirst<Cr>", desc = "First tab" },
		["<Leader><Tab>L"] = { "<Cmd>tablast<Cr>", desc = "Last tab" },
		["<Leader><Tab>a"] = { "<Cmd>tabfirst<Cr>", desc = "First tab" }, -- convenient key
		["<Leader><Tab>z"] = { "<Cmd>tablast<Cr>", desc = "Last tab" }, -- convenient key

		-- Buffer
		["<Leader>bn"] = { "<Cmd>tabnew<CR>", desc = "New tab" },
		["<Leader>bd"] = {
			function()
				require("astronvim.utils.buffer").close(vim.bufnr, true)
			end,
			desc = "Close current buffer",
		},
		["<Leader>bD"] = {
			function()
				require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
					require("astronvim.utils.buffer").close(bufnr)
				end)
			end,
			desc = "Pick to close buffer",
		},

		-- Terminal ToggleTerm
		["<Leader>etf"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "ToggleTerm float" },
		["<Leader>eth"] = { "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", desc = "ToggleTerm horizontal split" },
		["<Leader>etv"] = { "<Cmd>ToggleTerm size=80 direction=vertical<CR>", desc = "ToggleTerm vertical split" },
		["<leader>et<Tab>"] = { "<cmd>ToggleTerm direction=tab<cr>", desc = "ToggleTerm tab" },
	},
	v = {
		X = "S",
		["<"] = { "<gv", desc = "Better left indenting" },
		[">"] = { ">gv", desc = "Better right indenting" },
	},
	t = {
		jk = [[<C-\><C-n>]],
		["<Esc><Esc>"] = [[<C-\><C-n>]],
		["<C-h>"] = [[<C-\><C-n><C-w>h]],
		["<C-j>"] = [[<C-\><C-n><C-w>j]],
		["<C-k>"] = [[<C-\><C-n><C-w>k]],
		["<C-l>"] = [[<C-\><C-n><C-w>l]],
	},
}
