-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.showbreak = "↪ "
opt.listchars = "tab:→.,eol:¬,nbsp:.,space:.,multispace:..,trail:•,extends:›,precedes:‹"
opt.foldmethod = "indent"
opt.foldlevel = 9
opt.wrap = true
