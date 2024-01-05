return {
  { "cpea2506/relative-toggle.nvim" },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function() require("utils").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" }) end,
    opts = {
      input = { default_prompt = "➤ " },
      select = { backend = { "telescope", "builtin" } },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    keys = {
      { "<leader>en", function() require("noice").cmd "history" end, desc = "Noice History" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
    dependencies = {
      { "MunifTanjim/nui.nvim", lazy = true },
      {
        "rcarriga/nvim-notify",
        init = function() require("utils").load_plugin_with_func("nvim-notify", vim, "notify") end,
        opts = {
          timeout = 3000,
          max_height = function() return math.floor(vim.o.lines * 0.75) end,
          max_width = function() return math.floor(vim.o.columns * 0.75) end,
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
            if not vim.g.ui_notifications_enabled then vim.api.nvim_win_close(win, true) end
            if not package.loaded["nvim-treesitter"] then pcall(require, "nvim-treesitter") end
            vim.wo[win].conceallevel = 3
            local buf = vim.api.nvim_win_get_buf(win)
            if not pcall(vim.treesitter.start, buf, "markdown") then vim.bo[buf].syntax = "markdown" end
            vim.wo[win].spell = false
          end,
        },
        config = function()
          local notify = require "notify"
          notify.setup()
          vim.notify = notify
        end,
      },
    },
  },
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        keys = {
          {
            "<Leader>tf",
            function()
              if vim.wo.foldcolumn == "1" then
                vim.opt.foldcolumn = "0"
              else
                vim.opt.foldcolumn = "1"
              end
            end,
            desc = "Toggle fold status",
          },
        },
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { sign = { namespace = { "gitsigns" }, colwidth = 1, auto = true } },
              { text = { builtin.foldfunc, " " } },
              {
                text = { builtin.lnumfunc },
                condition = { builtin.not_empty, true, builtin.not_empty },
              },
              -- TODO: I want to to achieve todo, dap, diagnostic to be as one config
              -- so it only occupied 1 column if all have in 3 different lines
              -- but also shows all 3 if occured in one line
              {
                sign = {
                  name = { ".*" },
                  namespace = { "todo", "Dap*" },
                  colwidth = 2,
                  auto = true,
                },
              },
              {
                sign = {
                  namespace = { "diagnostic" },
                  colwidth = 2,
                  auto = true,
                },
              },
              { -- all other sign
                sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
                click = "v:lua.ScSa",
              },
              --{ text = { "%s" } }, show all sign in 1 column
            },
          }
        end,
      },
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function() return { "treesitter", "indent" } end,
    },
    init = function()
      vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end)
      vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end)
    end,
    keys = function()
      local ufo = require "ufo"
      return {
        { "zR", function() ufo.openAllFolds() end, desc = "Fold open all" },
        { "zM", function() ufo.closeAllFolds() end, desc = "Fold close all" },
        { "zr", function() ufo.openFoldsExceptKinds() end, desc = "Fold less" },
        { "zm", function() ufo.closeFoldsWith() end, desc = "Fold more" },
        { "zp", function() ufo.peekFoldedLinesUnderCursor() end, desc = "Fold peek" },
      }
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "UIEnter",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    keys = {
      { "<Leader>eS", function() require("dropbar.api").pick() end, desc = "Breadcrumbs" },
    },
    opts = {
      keymaps = {
        ["<BS>"] = "<C-w>q", -- TODO: not working
      },
    },
  },
  --[[ {
    "b0o/incline.nvim",
    event = "UIEnter",
    opts = {},
  }, ]]
}
