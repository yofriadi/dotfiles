---@type LazySpec
return {
  {
    "rubiin/fortune.nvim",
    version = "*",
    config = function() require("fortune").setup { max_width = 60 } end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
                        ▄ ▄               
              ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄       
              █ ▄ █▄█ ▄▄▄ █ █▄█ █ █       
           ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █       
         ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄    
         █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄  
       ▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █  
       █▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █  
           █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█      
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
          tabline = true,
          winbar = true,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            {
              action = "ene | startinsert",
              desc = " New file",
              icon = " ",
              key = "n",
            },
            {
              --action = require("search").open,
              desc = " Search",
              icon = " ",
              key = "s",
            },
            {
              action = "ToggleTerm direction=float",
              desc = " Terminal",
              icon = " ",
              key = "t",
            },
            {
              --action = require("dbee").open,
              desc = " Database",
              icon = " ",
              key = "d",
            },
            {
              action = "Lazy",
              desc = " Lazy",
              icon = "󰒲 ",
              key = "l",
            },
            {
              action = "Mason",
              desc = " Mason",
              icon = " ",
              key = "m",
            },
            {
              action = "q",
              desc = " Quit",
              icon = " ",
              key = "q",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            local startup =
              { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            local fortune = require("fortune").get_fortune()
            return vim.list_extend(startup, fortune)
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function() require("lazy").show() end,
        })
      end

      return opts
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = function(_, opts)
      local utils = require "astrocore"
      return utils.extend_tbl(opts, {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = utils.is_available "inc-rename.nvim", -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        notify = {
          enabled = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(
          opts.ensure_installed,
          { "bash", "markdown", "markdown_inline", "regex", "vim" }
        )
      end
    end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local noice_opts = require("astrocore").plugin_opts "noice.nvim"
      -- disable the necessary handlers in AstroLSP
      if not opts.lsp_handlers then opts.lsp_handlers = {} end
      if vim.tbl_get(noice_opts, "lsp", "hover", "enabled") ~= false then
        opts.lsp_handlers["textDocument/hover"] = false
      end
      if vim.tbl_get(noice_opts, "lsp", "signature", "enabled") ~= false then
        opts.lsp_handlers["textDocument/signatureHelp"] = false
      end
    end,
  },
  {
    "heirline.nvim",
    optional = true,
    opts = function(_, opts)
      local noice_opts = require("astrocore").plugin_opts "noice.nvim"
      if vim.tbl_get(noice_opts, "lsp", "progress", "enabled") ~= false then -- check if lsp progress is enabled
        opts.statusline[9] = require("astroui.status").component.lsp { lsp_progress = false }
      end
    end,
  },
}
