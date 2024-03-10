local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.code" },
    { import = "plugins.editing" },
    { import = "plugins.editor" },
    -- { import = "plugins.dap" },
    -- { import = "plugins.lang" },
    -- { import = "plugins.test" },
  },
  defaults = {
    lazy = false, -- will have all plugins not lazy-loaded by default.
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "tokyonight", "dayfox" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("current-theme")
--require("ollama")
