-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
  augroup _filetype
    autocmd!
    autocmd FileType go setlocal ts=4 sw=4
    autocmd FileType sql setlocal ts=4 sw=4
    autocmd FileType lua setlocal ts=2 sw=2
    autocmd FileType json setlocal ts=2 sw=2
    autocmd FileType dart setlocal ts=2 sw=2
    autocmd FileType javascript setlocal ts=2 sw=2
    autocmd FileType typescript setlocal ts=2 sw=2
    autocmd FileType typescriptreact setlocal ts=2 sw=2
  augroup end
]])
