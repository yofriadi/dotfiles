local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazyrepo,
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

vim.api.nvim_set_keymap("n", "<C-S-A>", ':echo "Ctrl+Shift+A pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-B>", ':echo "Ctrl+Shift+B pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-C>", ':echo "Ctrl+Shift+C pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-D>", ':echo "Ctrl+Shift+D pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-E>", ':echo "Ctrl+Shift+E pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-F>", ':echo "Ctrl+Shift+F pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-G>", ':echo "Ctrl+Shift+G pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-H>", ':echo "Ctrl+Shift+H pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-I>", ':echo "Ctrl+Shift+I pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-J>", ':echo "Ctrl+Shift+J pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-K>", ':echo "Ctrl+Shift+K pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-L>", ':echo "Ctrl+Shift+L pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-M>", ':echo "Ctrl+Shift+M pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-N>", ':echo "Ctrl+Shift+N pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-O>", ':echo "Ctrl+Shift+O pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-P>", ':echo "Ctrl+Shift+P pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Q>", ':echo "Ctrl+Shift+Q pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-R>", ':echo "Ctrl+Shift+R pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-S>", ':echo "Ctrl+Shift+S pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-T>", ':echo "Ctrl+Shift+T pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-U>", ':echo "Ctrl+Shift+U pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-V>", ':echo "Ctrl+Shift+V pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-W>", ':echo "Ctrl+Shift+W pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-X>", ':echo "Ctrl+Shift+X pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Y>", ':echo "Ctrl+Shift+Y pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Z>", ':echo "Ctrl+Shift+Z pressed"<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-A-A>", ':echo "Ctrl+Alt+A pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-B>", ':echo "Ctrl+Alt+B pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-C>", ':echo "Ctrl+Alt+C pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-D>", ':echo "Ctrl+Alt+D pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-E>", ':echo "Ctrl+Alt+E pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-F>", ':echo "Ctrl+Alt+F pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-G>", ':echo "Ctrl+Alt+G pressed"<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<C-A-H>", ':echo "Ctrl+Alt+H pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-I>", ':echo "Ctrl+Alt+I pressed"<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<C-A-J>", ':echo "Ctrl+Alt+J pressed"<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<C-A-K>", ':echo "Ctrl+Alt+K pressed"<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<C-A-L>", ':echo "Ctrl+Alt+L pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-M>", ':echo "Ctrl+Alt+M pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-N>", ':echo "Ctrl+Alt+N pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-O>", ':echo "Ctrl+Alt+O pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-P>", ':echo "Ctrl+Alt+P pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-Q>", ':echo "Ctrl+Alt+Q pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-R>", ':echo "Ctrl+Alt+R pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-S>", ':echo "Ctrl+Alt+S pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-T>", ':echo "Ctrl+Alt+T pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-U>", ':echo "Ctrl+Alt+U pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-V>", ':echo "Ctrl+Alt+V pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-W>", ':echo "Ctrl+Alt+W pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-X>", ':echo "Ctrl+Alt+X pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-Y>", ':echo "Ctrl+Alt+Y pressed"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-Z>", ':echo "Ctrl+Alt+Z pressed"<CR>', { noremap = true, silent = true })

require("lazy").setup {
  spec = {
    { import = "editing" },
    { import = "editor" },
    { import = "ui" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight" } },
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
}
