return function()
    vim.api.nvim_command("set foldmethod=expr")
    vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
    require("nvim-treesitter.configs").setup(
        {
            ensure_installed = {
                "go",
                "gomod",
                "javascript",
                "typescript",
                "dockerfile",
                "lua",
                "json",
                "yaml"
            },
            highlight = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm"
                }
            },
            indent = {
                enable = true
            }
        }
    )
end
