return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
    keys = function()
      local ls = require "luasnip"
      return {
        {
          "<Tab>",
          function() return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>" end,
          expr = true,
          silent = true,
          mode = "i",
        },
        { "<Tab>", function() ls.jump(1) end, mode = "s" },
        { "<S-Tab>", function() ls.jump(-1) end, mode = { "i", "s" } },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()
      local luasnip = require "luasnip"
      -- local lspkind = require("lspkind")

      local border_opts = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      return {
        -- TODO: setup when nvim-dap installed
        --[[ enabled = function()
          local dap_prompt = utils.is_available "cmp-dap" -- add interoperability with cmp-dap
            and vim.tbl_contains(
              { "dap-repl", "dapui_watches", "dapui_hover" },
              vim.api.nvim_get_option_value("filetype", { buf = 0 })
            )
          if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" and not dap_prompt then return false end
          return vim.g.cmp_enabled
        end, ]]
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        preselect = cmp.PreselectMode.None,
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = nil,
          --[[ format = lspkind.cmp_format(function()
            local spec = require("lazy.core.config").spec.plugins["lspkind.nvim"]
            local opts = {}
            if spec then opts = require("lazy.core.plugin").values(spec, "opts") end
            return opts
          end) ]]
        },
        experimental = {
          ghost_text = { hl_group = "CmpGhostText" },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
