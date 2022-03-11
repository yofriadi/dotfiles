local util = require("util")

util.opt_global({
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()"
})

return function()
    -- vim.api.nvim_command("set foldmethod=expr")
    -- vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

    --[[ rest.nvim
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
    parser_configs.http = {
      install_info = {
        url = "https://github.com/NTBBloodbath/tree-sitter-http",
        files = { "src/parser.c" },
        branch = "main",
      },
    } ]]--

    require("nvim-treesitter.configs").setup(
        {
            ensure_installed = {
                "http",
                "go",
                "gomod",
                "javascript",
                "typescript",
                "dockerfile",
                "lua",
                "json",
                "yaml",
                "dart",
            },
            highlight = {
                enable = true,
		disable = { "latex" },
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
