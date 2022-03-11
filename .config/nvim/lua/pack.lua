require("packer").startup(function(use)
    -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
    use "antoinemadec/FixCursorHold.nvim"

    use { "wbthomason/packer.nvim", opt = true }

    use {
        "yofriadi/nvim-base16",
        config = function()
            require("base16-colorscheme").setup({
                base00 = "#2E3440", base01 = "#3B4252", base02 = "#434C5E", base03 = "#4C566A",
                base04 = "#D8DEE9", base05 = "#E5E9F0", base06 = "#ECEFF4", base07 = "#8FBCBB",
                base08 = "#B48EAD", base09 = "#81A1C1", base0A = "#5E81AC", base0B = "#A3BE8C",
                base0C = "#D08770", base0D = "#EBCB8B", base0E = "#88C0D0", base0F = "#D08770",
            })
        end,
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = "BufRead",
        config = require("packs/nvim-treesitter"),
    }

    use {
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        config = require("packs/nvim-tree"),
    }

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
	    { "nvim-lua/plenary.nvim" },
	    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
	},
	config = require("packs/nvim-telescope"),
    }

    use {
      "NTBBloodbath/galaxyline.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
      config = function()
        require("galaxyline.themes.eviline")
      end,
    }

    use "folke/lsp-colors.nvim"

    use "tamago324/nlsp-settings.nvim"

    use "jose-elias-alvarez/null-ls.nvim"

    use {
        "neovim/nvim-lspconfig",
        requires = "williamboman/nvim-lsp-installer",
	config = require("packs/nvim-lspconfig"),
        --[[ setup = function()
           require("util").packer_lazy_load "nvim-lspconfig"
           -- reload the current file so lsp actually starts for it
           vim.defer_fn(function()
              vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
           end, 0)
        end, ]]--
        -- config = override_req("lspconfig", "plugins.configs.lspconfig"),
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
	    {"onsails/lspkind-nvim"},
	},
	config = require("packs/nvim-cmp"),
    }

    use { "L3MON4D3/LuaSnip", after = "nvim-cmp" }

    use { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" }

    -- use { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" }

    -- use { "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" }

    -- use { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" }

    -- use { "hrsh7th/cmp-path", after = "cmp-buffer" }

    --[[ use {
        "windwp/nvim-autopairs",
	after = "nvim-cmp",
        -- config = require("packs/nvim-autopairs"),
	config = function()
	    require('nvim-autopairs').setup({
		local cmp = require "cmp"
   		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	    })
	end,
    } ]]--

    use {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = require("packs/indent-blankline"),
    }

    use {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({
                mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "zt", "zz", "zb" },
		        hide_cursor = true,
                stop_eof = true,
                use_local_scrolloff = false,
                respect_scrolloff = false,
                cursor_scrolls_alone = true,
                easing_function = nil,
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    }

    use {
        "ojroques/nvim-bufdel",
        config = function()
            require('bufdel').setup({
                next = 'cycle',
                quit = false,
            })
        end,
    }
end)
