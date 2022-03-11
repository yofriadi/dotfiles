vim.opt.completeopt = "menu,menuone,noselect"

return function()
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    cmp.setup {
        snippet = {
           expand = function(args)
              require("luasnip").lsp_expand(args.body)
           end,
        },
        formatting = {
	    format = lspkind.cmp_format(),
            --[[ fields = { "kind", "abbr", "menu" },
            kind_icons = {
	        Text = "",
	        Method = "",
	        Function = "",
	        Constructor = "",
	        Field = "ﰠ",
	        Variable = "",
	        Class = "ﴯ",
	        Interface = "",
	        Module = "",
	        Property = "ﰠ",
	        Unit = "塞",
	        Value = "",
	        Enum = "",
	        Keyword = "",
	        Snippet = "",
	        Color = "",
	        File = "",
	        Reference = "",
	        Folder = "",
	        EnumMember = "",
	        Constant = "",
	        Struct = "פּ",
	        Event = "",
	        Operator = "",
	        TypeParameter = "",
            },
            source_names = {
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            },
            duplicates = {
                buffer = 1,
                path = 1,
                nvim_lsp = 0,
                luasnip = 1,
            },
            duplicates_default = 0,
            format = function(entry, vim_item)
                vim_item.kind = lvim.builtin.cmp.formatting.kind_icons[vim_item.kind]
                vim_item.menu = lvim.builtin.cmp.formatting.source_names[entry.source.name]
                vim_item.dup = lvim.builtin.cmp.formatting.duplicates[entry.source.name]
                  or lvim.builtin.cmp.formatting.duplicates_default
                return vim_item
            end, ]]--
        },
        mapping = {
           -- ["<C-p>"] = cmp.mapping.select_prev_item(),
           -- ["<C-n>"] = cmp.mapping.select_next_item(),
           ["<C-d>"] = cmp.mapping.scroll_docs(-4),
           ["<C-f>"] = cmp.mapping.scroll_docs(4),
           ["<C-Space>"] = cmp.mapping.complete(),
	   ["<C-e>"] = cmp.mapping({
	       i = cmp.mapping.abort(),
	       c = cmp.mapping.close(),
           }),
           ["<CR>"] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
           },
           ["<Tab>"] = function(fallback)
              if cmp.visible() then
                 cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                 vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
              else
                 fallback()
              end
           end,
           ["<S-Tab>"] = function(fallback)
              if cmp.visible() then
                 cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                 vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
              else
                 fallback()
              end
           end,
        },
        sources = {
           { name = "nvim_lsp" },
           { name = "nvim_lua" },
           { name = "luasnip" },
           { name = "buffer" },
           { name = "path" },
        },
    }
end
