return function()
    require("formatter").setup({
        logging = false,
        filetype = {
            javascript = {
                function()
                    return {
                        exe = "prettier",
                        args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
                        stdin = true,
                    }
                end,
            },
            lua = {
                function()
                    return {
                        exe = "lua-format",
                        args = {
                            "--column-limit=160",
                            "--extra-sep-at-table-end",
                            "--single-quote-to-double-quote",
                            "--chop-down-table",
                        },
                        stdin = true,
                    }
                end,
            },
            go = {
                function()
                    return {
                        exe = "go fmt",
                        args = {vim.api.nvim_buf_get_name(0)},
                        stdin = true,
                    }
                end,
            }
        },
    })
end
