-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = {
      "bash",
      "c",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "vim",
      "vimdoc",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "diff",
      "html",
      "javascript",
      "typescript",
      "tsx",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
      "regex",
      "toml",
      "yaml",
      "rust",
      "dockerfile",
      "http",
      "xml",
      "graphql",
    }
  end,
}
