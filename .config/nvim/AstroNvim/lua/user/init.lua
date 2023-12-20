return {
	-- Configure AstroNvim updates
	updater = {
		remote = "origin",   -- remote to use
		channel = "stable",  -- "stable" or "nightly"
		version = "latest",  -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "nightly",  -- branch name (NIGHTLY ONLY)
		commit = nil,        -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil,   -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_quit = false,   -- automatically quit the current session after a successful update
		remotes = {          -- easily add new remotes to track
			--   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
			--   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
			--   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
		},
	},
	-- Set colorscheme to use
	colorscheme = "tokyonight",
	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = false,
		underline = true,
	},
	lsp = {
		-- customize lsp formatting options
		formatting = {
			-- control auto formatting on save
			format_on_save = {
				enabled = true, -- enable or disable format on save globally
				allow_filetypes = { -- enable format on save for specified filetypes only
					"go",
					"json",
					"yaml",
					"lua",
				},
				ignore_filetypes = { -- disable format on save for specified filetypes
					-- "python",
				},
			},
			disabled = { -- disable formatting capabilities for the listed language servers
				-- "sumneko_lua",
			},
			timeout_ms = 1000, -- default format timeout
			-- filter = function(client) -- fully override the default formatting function
			--   return true
			-- end
		},
		-- enable servers that you already have installed without mason
		servers = {
			-- "pyright"
		},
	},
	-- Configure require("lazy").setup() options
	lazy = {
		defaults = { lazy = true },
		performance = {
			rtp = {
				-- customize default disabled vim plugins
				disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
			},
		},
	},
	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- Set up custom filetypes
		-- vim.filetype.add {
		--   extension = {
		--     foo = "fooscript",
		--   },
		--   filename = {
		--     ["Foofile"] = "fooscript",
		--   },
		--   pattern = {
		--     ["~/%.config/foo/.*"] = "fooscript",
		--   },
		-- }

		local autocmd = vim.api.nvim_create_autocmd
		local augroup = vim.api.nvim_create_augroup

		autocmd({ "VimResized" }, {
			desc = "Resize splits if window got resized",
			group = augroup("resize_splits", { clear = true }),
			callback = function()
				local current_tab = vim.fn.tabpagenr()
				vim.cmd("tabdo wincmd =")
				vim.cmd("tabnext " .. current_tab)
			end,
		})

		-- possibly to replace with plugin
		autocmd("BufReadPost", {
			desc = "Go to last loc when opening a buffer",
			group = augroup("last_loc", { clear = true }),
			callback = function(event)
				local exclude = { "gitcommit" }
				local buf = event.buf
				if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
					return
				end
				vim.b[buf].lazyvim_last_loc = true
				local mark = vim.api.nvim_buf_get_mark(buf, '"')
				local lcount = vim.api.nvim_buf_line_count(buf)
				if mark[1] > 0 and mark[1] <= lcount then
					pcall(vim.api.nvim_win_set_cursor, 0, mark)
				end
			end,
		})

		autocmd("FileType", {
			desc = "Close some filetypes with <q>",
			group = augroup("close_with_q", { clear = true }),
			pattern = {
				"PlenaryTestPopup",
				"help",
				"lspinfo",
				"man",
				"notify",
				"qf",
				"query",
				"spectre_panel",
				"startuptime",
				"tsplayground",
				"neotest-output",
				"checkhealth",
				"neotest-summary",
				"neotest-output-panel",
				"quickfix",
				"nofile",
				"toggleterm",
				"spectre",
			},
			callback = function(event)
				vim.bo[event.buf].buflisted = false
				vim.keymap.set("n", "q", "<cmd>close<cr>", {
					buffer = event.buf,
					silent = true,
					nowait = true,
				})
			end,
		})

		autocmd("FileType", {
			desc = "Wrap and check for spell in text filetypes",
			group = augroup("wrap_spell", { clear = true }),
			pattern = { "gitcommit", "markdown", "text", "plaintext" },
			callback = function()
				vim.opt_local.wrap = true
				vim.opt_local.spell = true
			end,
		})

		autocmd({ "BufWritePre" }, {
			desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
			group = augroup("auto_create_dir", { clear = true }),
			callback = function(event)
				if event.match:match("^%w%w+://") then
					return
				end
				local file = vim.loop.fs_realpath(event.match) or event.match
				vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
			end,
		})

		autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
			desc = "URL Highlighting",
			group = augroup("highlighturl", { clear = true }),
			callback = function()
				for _, match in ipairs(vim.fn.getmatches()) do
					if match.group == "HighlightURL" then
						vim.fn.matchdelete(match.id)
					end
				end
				local utils = require("astronvim.utils")
				if vim.g.highlighturl_enabled then
					vim.fn.matchadd("HighlightURL", utils.url_matcher, 15)
				end
			end,
		})

		autocmd("FileType", {
			desc = "Unlist quickfix buffers",
			group = augroup("unlist_quickfix", { clear = true }),
			pattern = "qf",
			callback = function()
				vim.opt_local.buflisted = false
			end,
		})

		autocmd("BufEnter", {
			desc = "Quit if more than one window is open and only sidebar windows are list",
			group = augroup("auto_quit", { clear = true }),
			callback = function()
				local wins = vim.api.nvim_tabpage_list_wins(0)
				-- Both neo-tree and aerial will auto-quit if there is only a single window left
				if #wins <= 1 then
					return
				end
				local sidebar_fts = { aerial = true, ["neo-tree"] = true }
				for _, winid in ipairs(wins) do
					if vim.api.nvim_win_is_valid(winid) then
						local bufnr = vim.api.nvim_win_get_buf(winid)
						local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
						-- If any visible windows are not sidebars, early return
						if not sidebar_fts[filetype] then
							return
							-- If the visible window is a sidebar
						else
							-- only count filetypes once, so remove a found sidebar from the detection
							sidebar_fts[filetype] = nil
						end
					end
				end
				if #vim.api.nvim_list_tabpages() > 1 then
					vim.cmd.tabclose()
				else
					vim.cmd.qall()
				end
			end,
		})
	end,
}
