-- Basic Neovim configuration bootstrap for the `nvim/n` profile.
-- Sets leader keys early so plugins can rely on them.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap folke/lazy.nvim when it is not yet installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from the `lua/plugins` directory.
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.editor" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "habamax" },
  },
  checker = {
    enabled = false,
  },
})
