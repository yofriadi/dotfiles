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
      { "nvim-notify" },
    },
  },
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
  },
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
  { -- TODO: check how to show next line if fold only show 1 char
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "statuscol.nvim",
    },
    event = "BufReadPost",
    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      return {
        fold_virt_text_handler = handler,
        provider_selector = function() return { "treesitter", "indent" } end,
        preview = {
          mappings = {
            scrollB = "<C-b>",
            scrollF = "<C-f>",
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            switch = "<C-w>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      }
    end,
    keys = function()
      local ufo = require "ufo"
      return {
        { "zR", ufo.openAllFolds, desc = "Fold open all" },
        { "zM", ufo.closeAllFolds, desc = "Fold close all" },
        { "zr", ufo.openFoldsExceptKinds, desc = "Fold less" },
        { "zm", ufo.closeFoldsWith, desc = "Fold more" },
        { "K", ufo.peekFoldedLinesUnderCursor, desc = "Fold peek" },
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
