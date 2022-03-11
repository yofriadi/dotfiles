-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/yofriadi/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/yofriadi/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/yofriadi/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/yofriadi/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/yofriadi/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    after = { "cmp_luasnip" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    after_files = { "/Users/yofriadi/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30galaxyline.themes.eviline\frequire\0" },
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/NTBBloodbath/galaxyline.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n�\4\0\0\4\0\16\0\0246\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0009\0\3\0\18\2\0\0009\0\4\0'\3\5\0B\0\3\0016\0\6\0'\2\a\0B\0\2\0029\0\b\0005\2\t\0005\3\n\0=\3\v\0025\3\f\0=\3\r\0025\3\14\0=\3\15\2B\0\2\1K\0\1\0\20buftype_exclude\1\3\0\0\rterminal\vnofile\21filetype_exclude\1\6\0\0\vpacker\thelp\rNvimTree\20TelescopePrompt\21TelescopeResults\21context_patterns\1\f\0\0\nclass\rfunction\vmethod\nblock\17list_literal\rselector\b^if\v^table\17if_statement\nwhile\bfor\1\0\a\25space_char_blankline\6 \21show_end_of_line\2\31show_current_context_start\2\25show_current_context\2#show_trailing_blankline_indent\2\28show_first_indent_level\2\tchar\b▏\nsetup\21indent_blankline\frequireJeol:↴,tab:▏·,trail:•,extends:→,precedes:←,nbsp:_,space:⋅\vappend\14listchars\tlist\bopt\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim",
    url = "https://github.com/folke/lsp-colors.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\5\16hide_cursor\2\25cursor_scrolls_alone\2\22respect_scrolloff\1\24use_local_scrolloff\1\rstop_eof\2\1\t\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\azt\azz\azb\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nlsp-settings.nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nlsp-settings.nvim",
    url = "https://github.com/tamago324/nlsp-settings.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-base16"] = {
    config = { "\27LJ\2\n�\2\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\16\vbase08\f#B48EAD\vbase00\f#2E3440\vbase09\f#81A1C1\vbase07\f#8FBCBB\vbase0A\f#5E81AC\vbase06\f#ECEFF4\vbase0B\f#A3BE8C\vbase05\f#E5E9F0\vbase0C\f#D08770\vbase04\f#D8DEE9\vbase0D\f#EBCB8B\vbase03\f#4C566A\vbase0E\f#88C0D0\vbase02\f#434C5E\vbase0F\f#D08770\vbase01\f#3B4252\nsetup\23base16-colorscheme\frequire\0" },
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-base16",
    url = "https://github.com/yofriadi/nvim-base16"
  },
  ["nvim-bufdel"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\tquit\1\tnext\ncycle\nsetup\vbufdel\frequire\0" },
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-bufdel",
    url = "https://github.com/ojroques/nvim-bufdel"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n�\6\0\0\v\0\"\00096\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0006\0\a\0'\2\b\0B\0\2\0029\0\t\0006\1\a\0'\3\n\0B\1\2\0029\1\v\0015\3\f\0005\4\r\0=\4\14\0035\4\15\0=\4\16\0035\4\17\0005\5\18\0=\5\19\4=\4\20\0035\4\22\0005\5\21\0=\5\23\4=\4\19\0035\4\24\0005\5\30\0004\6\3\0005\a\25\0\18\b\0\0'\n\26\0B\b\2\2=\b\27\a>\a\1\0065\a\28\0\18\b\0\0'\n\29\0B\b\2\2=\b\27\a>\a\2\6=\6\31\5=\5 \4=\4!\3B\1\2\1K\0\1\0\tview\rmappings\tlist\1\0\0\nsplit\1\0\1\bkey\6S\acb\vvsplit\1\0\1\bkey\6s\1\0\1\nwidth\3#\bgit\1\0\0\1\0\6\runstaged\b\14untracked\b\frenamed\b\fignored\b◌\runmerged\b\vstaged\b\16diagnostics\nicons\1\0\4\fwarning\b\nerror\b\thint\b\tinfo\b\1\0\1\venable\3\0\24update_focused_file\1\0\2\venable\2\15update_cwd\1\vignore\1\4\0\0\14.DS_Store\t.git\17node_modules\1\0\a\15auto_close\3\1\18hide_dotfiles\3\1\18disable_netrw\3\1\vgit_hl\3\1\17quit_on_open\3\1\18hijack_cursor\3\0\vfollow\3\1\nsetup\14nvim-tree\23nvim_tree_callback\21nvim-tree.config\frequire\1\0\4\ffolders\3\0\nfiles\3\1\bgit\3\1\18folder_arrows\3\0\25nvim_tree_show_icons\29nvim_tree_indent_markers\27nvim_tree_quit_on_open\27nvim_tree_add_trailing\6g\bvim\0" },
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n�\3\0\0\5\0\16\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0005\4\a\0=\4\b\3=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\0025\3\14\0=\3\15\2B\0\2\1K\0\1\0\vindent\1\0\1\venable\2\26incremental_selection\fkeymaps\1\0\4\22scope_incremental\bgrc\21node_incremental\bgrn\21node_decremental\bgrm\19init_selection\bgnn\1\0\1\venable\2\14highlight\fdisable\1\2\0\0\nlatex\1\0\1\venable\2\21ensure_installed\1\0\0\1\v\0\0\thttp\ago\ngomod\15javascript\15typescript\15dockerfile\blua\tjson\tyaml\tdart\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/opt/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n�\f\0\0\n\0E\0a6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0026\3\0\0'\5\4\0B\3\2\0029\3\5\0035\5>\0005\6\a\0005\a\6\0=\a\b\0065\a\n\0005\b\t\0=\b\v\a5\b\f\0=\b\r\a=\a\14\0064\a\0\0=\a\15\0064\a\0\0=\a\16\0065\a\17\0=\a\18\0065\a\19\0=\a\20\0065\a\21\0=\a\22\0065\a\26\0005\b\24\0005\t\23\0=\t\25\b=\b\27\a5\b\28\0=\b\29\a=\a\30\0065\a \0009\b\31\2=\b!\a9\b\"\2=\b#\a9\b$\2=\b%\a9\b&\2=\b'\a9\b(\2=\b)\a9\b*\0029\t+\2 \b\t\b=\b,\a9\b-\0029\t.\2 \b\t\b=\b/\a=\a0\0065\a1\0009\b\31\2=\b!\a9\b\"\2=\b#\a9\b*\0029\t+\2 \b\t\b=\b,\a=\a2\0069\a3\0009\a4\a=\a5\0069\a6\0009\a4\a=\a7\0069\a8\0009\a4\a=\a9\0069\a:\1=\a;\0069\a<\1=\a=\6=\6?\0055\6A\0005\a@\0=\aB\6=\6C\5B\3\2\0016\3\0\0'\5\4\0B\3\2\0029\3D\3'\5B\0B\3\2\1K\0\1\0\19load_extension\15extensions\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\rdefaults\1\0\0\19generic_sorter\29get_generic_fuzzy_sorter\16file_sorter\19get_fuzzy_file\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\6n\1\0\0\6i\t<CR>\vcenter\19select_default\n<C-q>\16open_qflist\25smart_send_to_qflist\n<C-k>\23cycle_history_prev\n<C-j>\23cycle_history_next\n<C-c>\nclose\n<C-p>\28move_selection_previous\n<C-n>\1\0\0\24move_selection_next\fpickers\14live_grep\1\0\1\19only_sort_text\2\15find_files\1\0\0\17find_command\1\0\0\1\5\0\0\afd\16--type=file\r--hidden\17--smart-case\fset_env\1\0\1\14COLORTERM\14truecolor\17path_display\1\0\1\fshorten\3\5\16borderchars\1\t\0\0\b─\b│\b─\b│\b╭\b╮\b╯\b╰\vborder\25file_ignore_patterns\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\2\19preview_cutoff\3x\nwidth\4\0����\3\1\0\1\vmirror\1\22vimgrep_arguments\1\0\t\18prompt_prefix\6 \20layout_strategy\rvertical\21sorting_strategy\14ascending\23selection_strategy\nreset\17initial_mode\vinsert\17entry_prefix\6 \20selection_caret\6 \rwinblend\3\0\19color_devicons\2\1\t\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\r--hidden\nsetup\14telescope\22telescope.actions\22telescope.sorters\25telescope.previewers\frequire\0" },
    loaded = true,
    path = "/Users/yofriadi/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-base16
time([[Config for nvim-base16]], true)
try_loadstring("\27LJ\2\n�\2\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\16\vbase08\f#B48EAD\vbase00\f#2E3440\vbase09\f#81A1C1\vbase07\f#8FBCBB\vbase0A\f#5E81AC\vbase06\f#ECEFF4\vbase0B\f#A3BE8C\vbase05\f#E5E9F0\vbase0C\f#D08770\vbase04\f#D8DEE9\vbase0D\f#EBCB8B\vbase03\f#4C566A\vbase0E\f#88C0D0\vbase02\f#434C5E\vbase0F\f#D08770\vbase01\f#3B4252\nsetup\23base16-colorscheme\frequire\0", "config", "nvim-base16")
time([[Config for nvim-base16]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30galaxyline.themes.eviline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\5\16hide_cursor\2\25cursor_scrolls_alone\2\22respect_scrolloff\1\24use_local_scrolloff\1\rstop_eof\2\1\t\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\azt\azz\azb\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n�\f\0\0\n\0E\0a6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0026\3\0\0'\5\4\0B\3\2\0029\3\5\0035\5>\0005\6\a\0005\a\6\0=\a\b\0065\a\n\0005\b\t\0=\b\v\a5\b\f\0=\b\r\a=\a\14\0064\a\0\0=\a\15\0064\a\0\0=\a\16\0065\a\17\0=\a\18\0065\a\19\0=\a\20\0065\a\21\0=\a\22\0065\a\26\0005\b\24\0005\t\23\0=\t\25\b=\b\27\a5\b\28\0=\b\29\a=\a\30\0065\a \0009\b\31\2=\b!\a9\b\"\2=\b#\a9\b$\2=\b%\a9\b&\2=\b'\a9\b(\2=\b)\a9\b*\0029\t+\2 \b\t\b=\b,\a9\b-\0029\t.\2 \b\t\b=\b/\a=\a0\0065\a1\0009\b\31\2=\b!\a9\b\"\2=\b#\a9\b*\0029\t+\2 \b\t\b=\b,\a=\a2\0069\a3\0009\a4\a=\a5\0069\a6\0009\a4\a=\a7\0069\a8\0009\a4\a=\a9\0069\a:\1=\a;\0069\a<\1=\a=\6=\6?\0055\6A\0005\a@\0=\aB\6=\6C\5B\3\2\0016\3\0\0'\5\4\0B\3\2\0029\3D\3'\5B\0B\3\2\1K\0\1\0\19load_extension\15extensions\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\rdefaults\1\0\0\19generic_sorter\29get_generic_fuzzy_sorter\16file_sorter\19get_fuzzy_file\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\6n\1\0\0\6i\t<CR>\vcenter\19select_default\n<C-q>\16open_qflist\25smart_send_to_qflist\n<C-k>\23cycle_history_prev\n<C-j>\23cycle_history_next\n<C-c>\nclose\n<C-p>\28move_selection_previous\n<C-n>\1\0\0\24move_selection_next\fpickers\14live_grep\1\0\1\19only_sort_text\2\15find_files\1\0\0\17find_command\1\0\0\1\5\0\0\afd\16--type=file\r--hidden\17--smart-case\fset_env\1\0\1\14COLORTERM\14truecolor\17path_display\1\0\1\fshorten\3\5\16borderchars\1\t\0\0\b─\b│\b─\b│\b╭\b╮\b╯\b╰\vborder\25file_ignore_patterns\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\2\19preview_cutoff\3x\nwidth\4\0����\3\1\0\1\vmirror\1\22vimgrep_arguments\1\0\t\18prompt_prefix\6 \20layout_strategy\rvertical\21sorting_strategy\14ascending\23selection_strategy\nreset\17initial_mode\vinsert\17entry_prefix\6 \20selection_caret\6 \rwinblend\3\0\19color_devicons\2\1\t\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\r--hidden\nsetup\14telescope\22telescope.actions\22telescope.sorters\25telescope.previewers\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n�\6\0\0\v\0\"\00096\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0006\0\a\0'\2\b\0B\0\2\0029\0\t\0006\1\a\0'\3\n\0B\1\2\0029\1\v\0015\3\f\0005\4\r\0=\4\14\0035\4\15\0=\4\16\0035\4\17\0005\5\18\0=\5\19\4=\4\20\0035\4\22\0005\5\21\0=\5\23\4=\4\19\0035\4\24\0005\5\30\0004\6\3\0005\a\25\0\18\b\0\0'\n\26\0B\b\2\2=\b\27\a>\a\1\0065\a\28\0\18\b\0\0'\n\29\0B\b\2\2=\b\27\a>\a\2\6=\6\31\5=\5 \4=\4!\3B\1\2\1K\0\1\0\tview\rmappings\tlist\1\0\0\nsplit\1\0\1\bkey\6S\acb\vvsplit\1\0\1\bkey\6s\1\0\1\nwidth\3#\bgit\1\0\0\1\0\6\runstaged\b\14untracked\b\frenamed\b\fignored\b◌\runmerged\b\vstaged\b\16diagnostics\nicons\1\0\4\fwarning\b\nerror\b\thint\b\tinfo\b\1\0\1\venable\3\0\24update_focused_file\1\0\2\venable\2\15update_cwd\1\vignore\1\4\0\0\14.DS_Store\t.git\17node_modules\1\0\a\15auto_close\3\1\18hide_dotfiles\3\1\18disable_netrw\3\1\vgit_hl\3\1\17quit_on_open\3\1\18hijack_cursor\3\0\vfollow\3\1\nsetup\14nvim-tree\23nvim_tree_callback\21nvim-tree.config\frequire\1\0\4\ffolders\3\0\nfiles\3\1\bgit\3\1\18folder_arrows\3\0\25nvim_tree_show_icons\29nvim_tree_indent_markers\27nvim_tree_quit_on_open\27nvim_tree_add_trailing\6g\bvim\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-bufdel
time([[Config for nvim-bufdel]], true)
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\tquit\1\tnext\ncycle\nsetup\vbufdel\frequire\0", "config", "nvim-bufdel")
time([[Config for nvim-bufdel]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd LuaSnip ]]
vim.cmd [[ packadd cmp_luasnip ]]
time([[Sequenced loading]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufRead * ++once lua require("packer.load")({'nvim-treesitter', 'indent-blankline.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
