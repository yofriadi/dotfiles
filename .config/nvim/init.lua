local fn, cmd = vim.fn, vim.cmd

-- Bootstrap Packer.nvim if it is not installed
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.api.nvim_command 'packadd packer.nvim'
end
cmd 'autocmd BufWritePost plugins.lua PackerCompile'

local leader_map = function()
	vim.g.mapleader = ' '
	vim.api.nvim_set_keymap('n', ' ', '', {noremap = true})
	vim.api.nvim_set_keymap('x', ' ', '', {noremap = true})
end
leader_map()

-- require('cfg')
require('pack')
