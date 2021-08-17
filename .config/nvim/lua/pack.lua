require("packer").startup(function(use)
    use {"wbthomason/packer.nvim", opt = true}

    use {
        "yofriadi/nvim-base16",
        config = function()
            local colorscheme = require("base16-colorscheme")
            colorscheme.setup({
                base00 = "#2E3440",
                base01 = "#3B4252",
                base02 = "#434C5E",
                base03 = "#4C566A",
                base04 = "#D8DEE9",
                base05 = "#E5E9F0",
                base06 = "#ECEFF4",
                base07 = "#8FBCBB",
                base08 = "#B48EAD",
                base09 = "#81A1C1",
                base0A = "#5E81AC",
                base0B = "#A3BE8C",
                base0C = "#D08770",
                base0D = "#EBCB8B",
                base0E = "#88C0D0",
                base0F = "#D08770",
            })
        end,
    }

    use {
        "nvim-telescope/telescope.nvim",
        -- cmd = "Telescope",
        config = require("packs/nvim-telescope"),
        requires = {
            {"nvim-lua/popup.nvim"},
            {"nvim-lua/plenary.nvim"},
            -- {"nvim-telescope/telescope-fzy-native.nvim", opt = true},
            -- {"nvim-telescope/telescope-project.nvim", opt = true},
            -- {'nvim-telescope/telescope-frecency.nvim', requires = {'tami5/sql.nvim'}, opt = true},
        },
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = "BufRead",
        after = "telescope.nvim",
        config = require("packs/nvim-treesitter"),
    }

    use {"kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons", config = require("packs/nvim-tree")}

    use "ojroques/nvim-bufdel"

    use {"lukas-reineke/indent-blankline.nvim", event = "BufRead", branch = "lua", config = require("packs/indent-blankline")}

    use {"glepnir/galaxyline.nvim", branch = "main", config = require("packs/galaxyline-nvim"), requires = "kyazdani42/nvim-web-devicons"}

    use {"windwp/nvim-autopairs", config = require("packs/nvim-autopairs")}

    use {"hrsh7th/vim-vsnip", event = "InsertCharPre", config = require("packs/snippets")}

    use {"onsails/lspkind-nvim", event = "InsertEnter", config = function() require("lspkind").init() end}

    use {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup {mappings = {"<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "zt", "zz", "zb"}, easing = true, hide_cursor = false}
        end,
    }

    use {"hrsh7th/nvim-compe", event = "InsertEnter", config = require("packs/nvim-compe")}

    use {"glepnir/lspsaga.nvim", cmd = "Lspsaga"}

    use {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        config = require("packs/nvim-lspconfig"),
        requires = {"kabouzeid/nvim-lspinstall"},
    }

    use {
        "folke/lsp-trouble.nvim",
        event = "BufRead",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                height = 12,
                use_lsp_diagnostic_signs = true,
                action_keys = {refresh = "r", toggle_mode = "m", toggle_preview = "P", close_folds = "zc", open_folds = "zo", toggle_fold = "zt"},
            }
        end,
    }

    use {
        "simrat39/symbols-outline.nvim",
        event = "BufRead",
        config = function() require("symbols-outline").setup {highlight_hovered_item = true, show_guides = true} end,
    }

    use {
        "phaazon/hop.nvim",
        as = "hop",
        cmd = {"HopWord"},
        config = function()
            require"hop".setup {keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5}
            -- vim.api.nvim_set_keymap('n', '$', "<cmd>lua require'hop'.hint_words()<cr>", {noremap = true})
        end,
    }

    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim", config = function() require("todo-comments").setup {} end}

    use {"sindrets/diffview.nvim", config = require("packs/diffview"), requires = "kyazdani42/nvim-web-devicons"}

    use "romgrk/nvim-treesitter-context"

    use {"mhartington/formatter.nvim", config = require("packs/formatter")}

    use {"hkupty/nvimux", config = require("packs/nvimux")}

    use {"NTBBloodbath/rest.nvim", requires = {"nvim-lua/plenary.nvim"}}

    use "troydm/zoomwintab.vim"

    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    --[[ use {
        "crispgm/nvim-go",
        config = function() require("go").setup{} end,
        ft = {"go"},
        requires = {
            {"nvim-lua/popup.nvim", opt = true},
            {"nvim-lua/plenary.nvim", opt = true},
        },
        -- requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"},
    } ]]--

    --[[ use {
		"lewis6991/gitsigns.nvim",
		requires = {"nvim-lua/plenary.nvim"},
		event = {"BufRead", "BufNewFile"},
		config = require("packs/gitsigns"),
	} ]]

    --[[

    use {"rmagatti/auto-session", config = function() require("auto-session").setup {auto_session_root_dir = vim.fn.stdpath("data") .. "/session/auto/"} end}

    use {
        "crispgm/nvim-go",
        ft = "go",
        config = function() require("go").setup {} end,
        requires = {
            {"nvim-lua/plenary.nvim", opt = true},
            {"nvim-lua/popup.nvim", opt = true},
        },
    }

	use {"mfussenegger/nvim-dap", opt = true}

	use {"winston0410/range-highlight.nvim", config = function() require("range-highlight").setup {} end}

	use {"npxbr/glow.nvim", opt = true, branch = "main", run = ":GlowInstall"}

    use {
        'norcalli/snippets.nvim',
        event = 'InsertCharPre',
        config = require('packs/snippets'),
    }

	use {"terrortylor/nvim-comment", config = function() require("nvim_comment").setup() end}

    use {
        'glepnir/dashboard-nvim',
        config = require('packs/dashboard-nvim'),
    }

    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require"colorizer".setup({"*"}, {
                RGB = true,
                RRGGBB = true,
                RRGGBBAA = true,
                rgb_fn = true,
                hsl_fn = true,
                css = true,
                css_fn = true,
            })
        end,
    }

	use {
      'kristijanhusak/vim-dadbod-ui',
      cmd = {'DBUIToggle', 'DBUIAddConnection', 'DBUI', 'DBUIFindBuffer', 'DBUIRenameBuffer'},
      requires = {
          {'tpope/vim-dadbod', opt = true},
          {'kristijanhusak/vim-dadbod-completion', opt = true}
      },
      config = require('packs/vim-dadbod'),
    }

	use {
        'TimUntersberger/neogit',
        event = {'BufRead', 'BufNewFile'},
        config = function() require('neogit').setup {} end,
        requires = {'nvim-lua/plenary.nvim', opt = true},
    }

	use {
      'nvim-telescope/telescope-frecency.nvim',
      requires = {'tami5/sql.nvim'},
      config = function()
        require('telescope').load_extension('frecency')
      end
    }

    use {
      "kdav5758/TrueZen.nvim",
      config = function()
        require("true-zen").setup {
          left = {
            shown_relativenumber = true,
            shown_signcolumn = "yes:2"
          },
          integrations = {integration_tmux = true}
        }
      end
    }

    use {
      "sunjon/shade.nvim",
      config = function()
        require("shade").setup({
          overlay_opacity = 50,
          opacity_step = 1,
        })
      end
    } ]]

    -- use {
    --     'akinsho/nvim-toggleterm.lua',
    --     config = function()
    --         local large_screen = vim.o.columns > 200
    --         require("toggleterm").setup({
    --             size = large_screen and vim.o.columns * 0.4 or 15,
    --             open_mapping = [[<c-\>]],
    --             shade_filetypes = {"none"},
    --             direction = large_screen and "vertical" or "horizontal",
    --             float_opts = {
    --                 border = "curved"
    --             }
    --         })
    --     end
    -- }
end)
