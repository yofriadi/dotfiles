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
local package_path_str = "/home/yofriadi/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/yofriadi/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/yofriadi/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/yofriadi/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/yofriadi/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
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
  ["diffview.nvim"] = {
    config = { "\27LJ\1\2Ç\4\0\0\a\0\30\0G4\0\0\0%\1\1\0>\0\2\0027\0\2\0004\1\0\0%\2\3\0>\1\2\0027\1\4\0013\2\5\0003\3\6\0:\3\a\0023\3\17\0003\4\t\0\16\5\0\0%\6\b\0>\5\2\2:\5\n\4\16\5\0\0%\6\v\0>\5\2\2:\5\f\4\16\5\0\0%\6\r\0>\5\2\2:\5\14\4\16\5\0\0%\6\15\0>\5\2\2:\5\16\4:\4\18\0033\4\20\0\16\5\0\0%\6\19\0>\5\2\2:\5\21\4\16\5\0\0%\6\22\0>\5\2\2:\5\23\4\16\5\0\0%\6\24\0>\5\2\2:\5\25\4\16\5\0\0%\6\24\0>\5\2\2:\5\26\4\16\5\0\0%\6\27\0>\5\2\2:\5\28\4\16\5\0\0%\6\b\0>\5\2\2:\5\n\4\16\5\0\0%\6\v\0>\5\2\2:\5\f\4\16\5\0\0%\6\r\0>\5\2\2:\5\14\4\16\5\0\0%\6\15\0>\5\2\2:\5\16\4:\4\a\3:\3\29\2>\1\2\1G\0\1\0\17key_bindings\6R\18refresh_files\6o\t<cr>\17select_entry\6k\15prev_entry\6j\1\0\0\15next_entry\tview\1\0\0\14<leader>b\17toggle_files\14<leader>e\16focus_files\f<s-tab>\22select_prev_entry\n<tab>\1\0\0\22select_next_entry\15file_panel\1\0\2\nwidth\3\30\14use_icons\2\1\0\1\18diff_binaries\1\nsetup\rdiffview\22diffview_callback\20diffview.config\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/diffview.nvim"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\1\2Š\1\0\0\4\0\6\0\n3\0\0\0003\1\1\0004\2\2\0007\2\3\0027\2\4\2'\3\0\0>\2\2\2;\2\2\1:\1\5\0H\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\4\0\0\21--stdin-filepath\0\19--single-quote\1\0\2\nstdin\2\bexe\rprettier–\1\0\0\2\0\3\0\0043\0\0\0003\1\1\0:\1\2\0H\0\2\0\targs\1\5\0\0\23--column-limit=160\29--extra-sep-at-table-end#--single-quote-to-double-quote\22--chop-down-table\1\0\2\nstdin\2\bexe\15lua-formati\0\0\4\0\5\1\n3\0\0\0002\1\3\0004\2\1\0007\2\2\0027\2\3\2'\3\0\0>\2\2\0<\2\0\0:\1\4\0H\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\0\2\nstdin\2\bexe\vgo fmt\3€€À™\4 \1\1\0\5\0\f\0\0214\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\5\0002\3\3\0001\4\4\0;\4\1\3:\3\6\0022\3\3\0001\4\a\0;\4\1\3:\3\b\0022\3\3\0001\4\t\0;\4\1\3:\3\n\2:\2\v\1>\0\2\1G\0\1\0\rfiletype\ago\0\blua\0\15javascript\1\0\0\0\1\0\1\flogging\1\nsetup\14formatter\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\1\2é\3\0\0\6\1\28\00083\0\0\0003\1\2\0+\2\0\0007\2\1\2:\2\3\1+\2\0\0007\2\4\2:\2\5\1+\2\0\0007\2\4\2:\2\6\1+\2\0\0007\2\4\2:\2\a\1+\2\0\0007\2\4\2:\2\b\1+\2\0\0007\2\4\2:\2\t\1+\2\0\0007\2\4\2:\2\n\1+\2\0\0007\2\v\2:\2\f\1+\2\0\0007\2\v\2:\2\r\1+\2\0\0007\2\14\2:\2\15\1+\2\0\0007\2\16\2:\2\17\1+\2\0\0007\2\18\2:\2\19\1+\2\0\0007\2\18\2:\2\20\0014\2\21\0007\2\22\0027\2\23\2>\2\1\0024\3\21\0007\3\24\0037\3\25\3%\4\26\0006\5\2\1$\4\5\4>\3\2\0016\3\2\0%\4\27\0$\3\4\3H\3\2\0\1À\f î˜«   \27hi GalaxyViMode guifg=\17nvim_command\bapi\tmode\afn\bvim\6t\6!\rdarkblue\6r\fmagenta\6c\tblue\6R\6i\bred\6\19\6S\6s\6\22\6V\6v\vorange\6n\1\0\0\ngreen\1\0\r\6S\vS-LINE\6!\rEXTERNAL\6\22\fV-BLOCK\6r\vPROMPT\6V\vV-LINE\6s\vSELECT\6t\rTERMINAL\6c\fCOMMAND\6v\vVISUAL\6R\fREPLACE\6n\vNORMAL\6\19\fS-BLOCK\6i\vINSERT\21\0\0\1\0\1\0\2%\0\0\0H\0\2\0\n îœ¥ T\0\0\2\0\4\0\v3\0\0\0004\1\1\0007\1\2\0017\1\3\0016\1\1\0\15\0\1\0T\2\2€)\1\1\0H\1\2\0)\1\2\0H\1\2\0\rfiletype\abo\bvim\1\0\2\6 \2\14dashboard\2^\0\0\4\0\6\0\n%\0\0\0004\1\1\0007\1\2\0017\1\3\1'\2\0\0%\3\4\0>\1\3\2%\2\5\0$\0\2\0H\0\2\0\6 \ftabstop\24nvim_buf_get_option\bapi\bvim\rSpaces: \17\0\0\1\0\1\0\2%\0\0\0H\0\2\0\6 ï\22\1\0\t\0o\0Ê\0024\0\0\0%\1\1\0>\0\2\0023\1\3\0:\1\2\0003\1\4\0004\2\0\0%\3\5\0>\2\2\0027\3\6\0003\4\a\0:\4\2\0007\4\b\0033\5\16\0003\6\n\0001\a\t\0:\a\v\0063\a\14\0007\b\f\1;\b\1\a7\b\r\1;\b\2\a:\a\15\6:\6\17\5;\5\1\0047\4\b\0033\5\22\0003\6\18\0007\a\19\2:\a\20\0062\a\3\0007\b\21\1;\b\1\a7\b\r\1;\b\2\a:\a\15\6:\6\23\5;\5\2\0047\4\b\0033\5\29\0003\6\25\0003\a\24\0:\a\v\0067\a\19\2:\a\20\0063\a\26\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b\21\1;\b\1\a7\b\r\1;\b\2\a:\a\15\6:\6\30\5;\5\3\0047\4\b\0033\5$\0003\6 \0001\a\31\0:\a\v\0067\a!\2:\a\20\0063\a\"\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6%\5;\5\4\0047\4\b\0033\5)\0003\6&\0007\a!\2:\a\20\0063\a'\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6*\5;\5\5\0047\4\b\0033\5.\0003\6+\0007\a,\2:\a\20\0062\a\3\0007\b-\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6/\5;\5\6\0047\4\b\0033\0051\0003\0060\0007\a,\2:\a\20\0062\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\0062\5;\5\a\0047\4\b\0033\0054\0003\0063\0007\a,\2:\a\20\0062\a\3\0007\b\f\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\0065\5;\5\b\0047\0046\0033\0059\0003\0067\0002\a\3\0007\b8\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6:\5;\5\1\0047\0046\0033\5<\0003\6;\0002\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6=\5;\5\2\0047\0046\0033\5?\0003\6>\0002\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6@\5;\5\3\0047\0046\0033\5C\0003\6A\0002\a\3\0007\bB\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6D\5;\5\4\0047\0046\0033\5H\0003\6E\0001\aF\0:\a\20\0062\a\3\0007\bG\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6I\5;\5\5\0047\0046\0033\5L\0003\6J\0003\aK\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6M\5;\5\6\0047\0046\0033\5P\0003\6N\0003\aO\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6Q\5;\5\a\0047\0046\0033\5U\0003\6S\0001\aR\0:\a\v\0067\a,\2:\a\20\0063\aT\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6V\5;\5\b\0047\0046\0033\5Y\0003\6W\0007\a,\2:\a\20\0063\aX\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6Z\5;\5\t\0047\0046\0033\5]\0003\6[\0007\a,\2:\a\20\0063\a\\\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6^\5;\5\n\0047\0046\0033\5b\0003\6`\0001\a_\0:\a\v\0063\aa\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6c\5;\5\v\0047\4d\0033\5g\0003\6e\0003\af\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6Z\5;\5\1\0047\4d\0033\5i\0003\6h\0007\a\19\2:\a\20\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6j\5;\5\2\0047\4k\0033\5m\0003\6l\0002\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6n\5;\5\1\0040\0\0€G\0\1\0\15BufferIcon\1\0\0\1\0\1\rprovider\15BufferIcon\21short_line_right\14SFileName\1\0\0\1\0\1\rprovider\14SFileName\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\17FileTypeName\20short_line_left\nSpace\1\0\0\1\2\0\0\tNONE\1\0\1\14separator\6 \0\15FileEncode\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\15FileEncode\15BufferType\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\17FileTypeName\fTabstop\1\0\0\1\2\0\0\tNONE\1\0\1\14separator\6 \0\fPerCent\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\16LinePercent\rLineInfo\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\a  \rprovider\15LineColumn\18ShowLspClient\1\0\0\vpurple\0\1\0\2\ticon\v ï‚…  \rprovider\17GetLspClient\19DiagnosticInfo\1\0\0\tblue\1\0\2\ticon\n ïš \rprovider\19DiagnosticInfo\19DiagnosticHint\1\0\0\1\0\2\ticon\n ïª \rprovider\19DiagnosticHint\19DiagnosticWarn\1\0\0\1\0\2\ticon\n ï± \rprovider\19DiagnosticWarn\20DiagnosticError\1\0\0\14error_red\1\0\2\ticon\n ï— \rprovider\20DiagnosticError\nright\15DiffRemove\1\0\0\1\0\2\ticon\v  ï‘˜ \rprovider\15DiffRemove\17DiffModified\1\0\0\1\0\2\ticon\v  ï‘™ \rprovider\17DiffModified\fDiffAdd\1\0\0\ngreen\18hide_in_width\1\0\2\ticon\v  ï‘— \rprovider\fDiffAdd\14GitBranch\1\0\0\tgrey\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\14GitBranch\fGitIcon\1\0\0\vorange\1\2\0\0\tNONE\24check_git_workspace\1\0\0\0\rFileName\1\0\0\24separator_highlight\abg\1\2\0\0\tNONE\1\0\1\14separator\6 \1\2\0\0\rFileName\rFileIcon\1\0\0\fmagenta\14condition\21buffer_not_empty\1\0\1\rprovider\rFileIcon\vViMode\1\0\0\14highlight\1\4\0\0\0\0\tbold\fline_bg\bred\rprovider\1\0\0\0\tleft\1\5\0\0\rNvimTree\nvista\tdbui\vpacker\fsection\25galaxyline.condition\1\0\16\tblue\f#83a598\afg\f#E7BC74\14error_red\f#F24949\vyellow\f#E6B673\rdarkblue\f#458588\abg\f#4C566A\fmagenta\f#ea6962\fline_bg\f#4C566A\vorange\f#F2994B\tcyan\f#39A291\rfg_green\f#458588\tgray\f#E7BC74\bred\f#F24949\ngreen\f#689d6a\vpurple\f#008080\blbg\f#4C566A\1\5\0\0\rNvimTree\nvista\tdbui\vpacker\20short_line_list\15galaxyline\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  hop = {
    commands = { "HopWord" },
    config = { "\27LJ\1\2j\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\2\18term_seq_bias\4\0€€€ÿ\3\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/hop"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\1\2Ô\a\0\0\2\0\20\00094\0\0\0007\0\1\0)\1\2\0:\1\2\0004\0\0\0007\0\1\0%\1\4\0:\1\3\0004\0\0\0007\0\1\0)\1\2\0:\1\5\0004\0\0\0007\0\1\0)\1\2\0:\1\6\0004\0\0\0007\0\1\0003\1\b\0:\1\a\0004\0\0\0007\0\1\0)\1\1\0:\1\t\0004\0\0\0007\0\1\0)\1\2\0:\1\n\0004\0\0\0007\0\1\0'\1\b\0:\1\v\0004\0\0\0007\0\1\0)\1\2\0:\1\t\0004\0\0\0007\0\1\0)\1\2\0:\1\f\0004\0\0\0007\0\1\0)\1\2\0:\1\r\0004\0\0\0007\0\1\0003\1\15\0:\1\14\0004\0\0\0007\0\1\0003\1\17\0:\1\16\0004\0\0\0007\0\18\0%\1\19\0>\0\2\1G\0\1\0001autocmd CursorMoved * IndentBlanklineRefresh\bcmd\1\f\0\0\nclass\rfunction\vmethod\nblock\17list_literal\rselector\b^if\v^table\17if_statement\nwhile\bfor&indent_blankline_context_patterns\1\22\0\0\rstartify\14dashboard\16dotooagenda\blog\rfugitive\14gitcommit\vpacker\fvimwiki\rmarkdown\tjson\btxt\nvista\thelp\ftodoist\rNvimTree\rpeekaboo\bgit\20TelescopePrompt\rundotree\24flutterToolsOutline\5&indent_blankline_filetype_exclude!indent_blankline_strict_tabs&indent_blankline_show_end_of_line\"indent_blankline_indent_level*indent_blankline_show_current_context4indent_blankline_show_trailing_blankline_indent\1\3\0\0\rterminal\vnofile%indent_blankline_buftype_exclude$indent_blankline_use_treesitter-indent_blankline_show_first_indent_level\bâ–\26indent_blankline_char\29indent_blankline_enabled\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "\27LJ\1\2Ë\1\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\4\0:\2\5\1>\0\2\1G\0\1\0\16action_keys\1\0\6\15open_folds\azo\16toggle_fold\azt\16close_folds\azc\19toggle_preview\6P\frefresh\6r\16toggle_mode\6m\1\0\2\vheight\3\f\29use_lsp_diagnostic_signs\2\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\1\0024\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tinit\flspkind\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    commands = { "Lspsaga" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/lspsaga.nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\1\2\1\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\rmappings\1\0\2\veasing\2\16hide_cursor\1\1\t\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\azt\azz\azb\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\1\2Š\1\0\3\t\0\a\0\0193\3\0\0\15\0\2\0T\4\a€4\4\1\0007\4\2\4%\5\3\0\16\6\3\0\16\a\2\0>\4\4\2\16\3\4\0004\4\1\0007\4\4\0047\4\5\4%\5\6\0\16\6\0\0\16\a\1\0\16\b\3\0>\4\5\1G\0\1\0\6i\20nvim_set_keymap\bapi\nforce\15tbl_extend\bvim\1\0\1\fnoremap\0019\0\0\2\0\4\0\0064\0\0\0007\0\1\0007\0\2\0%\1\3\0>\0\2\1G\0\1\0\t<cr>\18compe#confirm\afn\bvim\2\1\0\3\1\f\2'4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0\27€4\0\0\0007\0\1\0007\0\3\0>\0\1\0027\0\4\0\b\0\1\0T\0\t€4\0\0\0007\0\1\0007\0\5\0>\0\1\1+\0\0\0007\0\6\0%\1\a\0000\0\17€T\0\15€4\0\0\0007\0\b\0001\1\t\0'\2\20\0>\0\3\1+\0\0\0007\0\6\0%\1\n\0000\0\0€@\0\2\0T\0\4€+\0\0\0007\0\v\0000\0\0€@\0\1\0G\0\1\0@\0\2\0\0À\26check_break_line_char\n<c-n>\0\rdefer_fn\5\besc\18compe#confirm\rselected\18complete_info\15pumvisible\afn\bvim\0şÿÿÿ\31²\2\0\0\5\1\f\2+4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0!€4\0\0\0007\0\1\0007\0\3\0>\0\1\0027\0\4\0\b\0\1\0T\0\t€4\0\0\0007\0\1\0007\0\5\0>\0\1\1+\0\0\0007\0\6\0%\1\a\0@\0\2\0T\0\20€4\0\0\0007\0\b\0007\0\t\0'\1\0\0)\2\1\0)\3\1\0002\4\0\0>\0\5\0014\0\0\0007\0\1\0007\0\5\0>\0\1\1+\0\0\0007\0\6\0%\1\n\0@\0\2\0T\0\3€+\0\0\0007\0\v\0@\0\1\0G\0\1\0\0À\26check_break_line_char\n<c-n>\31nvim_select_popupmenu_item\bapi\5\besc\18compe#confirm\rselected\18complete_info\15pumvisible\afn\bvim\0şÿÿÿ\31\2\0\0\6\1\f\1'4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0\5€+\0\0\0007\0\3\0%\1\4\0@\0\2\0T\0\27€4\0\0\0007\0\1\0007\0\5\0'\1\1\0>\0\2\2\b\0\0\0T\0\16€4\0\0\0007\0\1\0007\0\6\0004\1\a\0007\1\b\1%\2\t\0'\3€\0'\4ı\0'\5S\0>\1\5\0=\0\0\1+\0\0\0007\0\3\0%\1\n\0@\0\2\0T\0\4€+\0\0\0007\0\3\0%\1\v\0@\0\2\0G\0\1\0\0À\n<Tab>\5!%c%c%c(vsnip-expand-or-jump)\vformat\vstring\rfeedkeys\20vsnip#available\n<C-n>\besc\15pumvisible\afn\bvim\0‡\2\0\0\6\1\f\1'4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0\5€+\0\0\0007\0\3\0%\1\4\0@\0\2\0T\0\27€4\0\0\0007\0\1\0007\0\5\0'\1ÿÿ>\0\2\2\b\0\0\0T\0\16€4\0\0\0007\0\1\0007\0\6\0004\1\a\0007\1\b\1%\2\t\0'\3€\0'\4ı\0'\5S\0>\1\5\0=\0\0\1+\0\0\0007\0\3\0%\1\n\0@\0\2\0T\0\4€+\0\0\0007\0\3\0%\1\v\0@\0\2\0G\0\1\0\0À\n<C-h>\5\28%c%c%c(vsnip-jump-prev)\vformat\vstring\rfeedkeys\19vsnip#jumpable\n<C-p>\besc\15pumvisible\afn\bvim\0½\4\1\0\a\0\"\00094\0\0\0007\0\1\0007\0\2\0\14\0\0\0T\0\4€4\0\3\0007\0\4\0%\1\5\0>\0\2\0014\0\6\0%\1\a\0>\0\2\0027\0\b\0>\0\1\0014\0\6\0%\1\a\0>\0\2\0021\1\t\0004\2\n\0002\3\0\0:\3\v\0024\2\3\0007\2\f\2%\3\14\0:\3\r\0024\2\v\0001\3\16\0:\3\15\0024\2\v\0001\3\17\0:\3\15\0024\2\v\0001\3\19\0:\3\18\0024\2\v\0001\3\21\0:\3\20\0024\2\3\0007\2\22\0027\2\23\2%\3\24\0%\4\25\0%\5\26\0003\6\27\0>\2\5\1\16\2\1\0%\3\28\0%\4\29\0003\5\30\0>\2\4\1\16\2\1\0%\3\31\0%\4 \0003\5!\0>\2\4\0010\0\0€G\0\1\0\1\0\2\texpr\2\fnoremap\2\25v:lua.MUtils.s_tab()\f<S-Tab>\1\0\2\texpr\2\fnoremap\2\23v:lua.MUtils.tab()\n<Tab>\1\0\2\texpr\2\fnoremap\2&v:lua.MUtils.completion_confirm()\t<CR>\6i\20nvim_set_keymap\bapi\0\ns_tab\0\btab\0\0\23completion_confirm\5\27completion_confirm_key\6g\vMUtils\a_G\0\nsetup\19nvim-autopairs\frequire\28packadd nvim-treesitter\bcmd\bvim\vloaded\20nvim-treesitter\19packer_plugins\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-base16"] = {
    config = { "\27LJ\1\2·\2\0\0\3\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\1\2\0003\2\3\0>\1\2\1G\0\1\0\1\0\16\vbase07\f#8FBCBB\vbase08\f#B48EAD\vbase04\f#D8DEE9\vbase0A\f#5E81AC\vbase05\f#E5E9F0\vbase0F\f#D08770\vbase02\f#434C5E\vbase09\f#81A1C1\vbase03\f#4C566A\vbase0D\f#EBCB8B\vbase00\f#2E3440\vbase0E\f#88C0D0\vbase01\f#3B4252\vbase0B\f#A3BE8C\vbase06\f#ECEFF4\vbase0C\f#D08770\nsetup\23base16-colorscheme\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-base16"
  },
  ["nvim-bufdel"] = {
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-bufdel"
  },
  ["nvim-compe"] = {
    after_files = { "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\1\2F\0\1\6\0\3\0\b4\1\0\0007\1\1\0017\1\2\1\16\2\0\0)\3\2\0)\4\2\0)\5\2\0@\1\5\0\27nvim_replace_termcodes\bapi\bvim£\1\0\0\5\0\b\2\0304\0\0\0007\0\1\0007\0\2\0%\1\3\0>\0\2\2\21\0\0\0\b\0\1\0T\1\16€4\1\0\0007\1\1\0017\1\4\1%\2\3\0>\1\2\2\16\2\1\0007\1\5\1\16\3\0\0\16\4\0\0>\1\4\2\16\2\1\0007\1\6\1%\3\a\0>\1\3\2\15\0\1\0T\2\3€)\1\2\0H\1\2\0T\1\2€)\1\1\0H\1\2\0G\0\1\0\a%s\nmatch\bsub\fgetline\6.\bcol\afn\bvim\2\0ı\1\0\0\3\2\n\1#4\0\0\0007\0\1\0007\0\2\0>\0\1\2\t\0\0\0T\0\4€+\0\0\0%\1\3\0@\0\2\0T\0\24€4\0\0\0007\0\1\0007\0\4\0%\1\5\0003\2\6\0>\0\3\2\t\0\0\0T\0\4€+\0\0\0%\1\a\0@\0\2\0T\0\f€+\0\1\0>\0\1\2\15\0\0\0T\1\4€+\0\0\0%\1\b\0@\0\2\0T\0\4€4\0\0\0007\0\1\0007\0\t\0@\0\1\0G\0\1\0\0À\1À\19compe#complete\n<Tab>!<Plug>(vsnip-expand-or-jump)\1\2\0\0\3\1\20vsnip#available\tcall\n<C-n>\15pumvisible\afn\bvim\2È\1\0\0\3\1\t\1\0264\0\0\0007\0\1\0007\0\2\0>\0\1\2\t\0\0\0T\0\4€+\0\0\0%\1\3\0@\0\2\0T\0\15€4\0\0\0007\0\1\0007\0\4\0%\1\5\0003\2\6\0>\0\3\2\t\0\0\0T\0\4€+\0\0\0%\1\a\0@\0\2\0T\0\3€+\0\0\0%\1\b\0@\0\2\0G\0\1\0\0À\f<S-Tab>\28<Plug>(vsnip-jump-prev)\1\2\0\0\3ÿÿÿÿ\15\19vsnip#jumpable\tcall\n<C-p>\15pumvisible\afn\bvim\2Ë\n\1\0\a\0@\0r4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\4\0%\1\5\0>\0\2\0027\0\6\0003\1\a\0003\2\t\0003\3\b\0:\3\n\0023\3\v\0:\3\f\0023\3\r\0:\3\14\0023\3\15\0:\3\16\0023\3\17\0:\3\18\0023\3\19\0:\3\20\0023\3\21\0:\3\22\0023\3\23\0:\3\24\0023\3\25\0003\4\26\0:\4\27\3:\3\28\2:\2\29\1>\0\2\0011\0\30\0001\1\31\0004\2 \0001\3\"\0:\3!\0024\2 \0001\3$\0:\3#\0024\2\0\0007\2%\0027\2&\2%\3'\0%\4(\0%\5)\0003\6*\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3+\0%\4(\0%\5)\0003\6,\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3'\0%\4-\0%\5.\0003\6/\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3+\0%\4-\0%\5.\0003\0060\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3'\0%\0041\0%\0052\0003\0063\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3'\0%\0044\0%\0055\0003\0066\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3'\0%\0047\0%\0058\0003\0069\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3'\0%\4:\0%\5;\0003\6<\0>\2\5\0014\2\0\0007\2%\0027\2&\2%\3'\0%\4=\0%\5>\0003\6?\0>\2\5\0010\0\0€G\0\1\0\1\0\3\texpr\2\vsilent\2\fnoremap\2\"compe#scroll({ 'delta': -4 })\n<C-d>\1\0\3\texpr\2\vsilent\2\fnoremap\2\"compe#scroll({ 'delta': +4 })\n<C-f>\1\0\3\texpr\2\vsilent\2\fnoremap\2\25compe#close('<C-e>')\n<C-e>\1\0\3\texpr\2\vsilent\2\fnoremap\2\26compe#confirm('<CR>')\t<CR>\1\0\3\texpr\2\vsilent\2\fnoremap\2\21compe#complete()\15<C-Space> \1\0\1\texpr\2\1\0\1\texpr\2\27v:lua.s_tab_complete()\f<S-Tab>\1\0\1\texpr\2\6s\1\0\1\texpr\2\25v:lua.tab_complete()\n<Tab>\6i\20nvim_set_keymap\bapi\0\19s_tab_complete\0\17tab_complete\a_G\0\0\vsource\nemoji\14filetypes\1\2\0\0\rmarkdown\1\0\1\tkind\n ï²ƒ \nvsnip\1\0\1\tkind\n ï— \ttags\1\0\1\tkind\n ï€« \nspell\1\0\1\tkind\n ï‘ˆ \rnvim_lua\1\0\1\tkind\n ï†² \rnvim_lsp\1\0\1\tkind\n ï†² \tcalc\1\0\1\tkind\n ï‡¬ \vbuffer\1\0\1\tkind\n ï \tpath\1\0\0\1\0\1\tkind\n ï›— \1\0\f\17autocomplete\2\19source_timeout\3È\1\fenabled\2\ndebug\1\14preselect\venable\19max_abbr_width\3d\21incomplete_delay\3\3\19max_menu_width\3d\19max_kind_width\3d\15min_length\3\1\18throttle_time\3P\18documentation\2\nsetup\ncompe\frequire\21menuone,noselect\16completeopt\6o\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2€\2\0\2\n\0\f\0&4\2\0\0007\2\1\0027\2\2\2%\3\3\0\16\4\0\0$\3\4\3>\2\2\0014\2\0\0007\2\1\0027\2\2\2%\3\4\0>\2\2\0014\2\5\0\16\3\1\0>\2\2\4T\5\14€4\a\6\0007\a\a\a4\b\0\0007\b\b\b3\t\t\0;\6\2\t>\b\2\2%\t\n\0>\a\3\0024\b\0\0007\b\1\b7\b\2\b\16\t\a\0>\b\2\1A\5\3\3N\5ğ4\2\0\0007\2\1\0027\2\2\2%\3\v\0>\2\2\1G\0\1\0\16augroup END\6 \1\2\0\0\fautocmd\16tbl_flatten\vconcat\ntable\vipairs\rautocmd!\raugroup \17nvim_command\bapi\bvimÆ\1\0\0\a\1\t\0\0202\0\0\0004\1\0\0007\1\1\0017\1\2\1%\2\3\0>\1\2\0024\2\4\0007\2\5\2\16\3\0\0003\4\6\0%\5\a\0\16\6\1\0$\5\6\5;\5\2\4>\2\3\1+\2\0\0%\3\b\0\16\4\0\0>\2\3\1G\0\1\0\2À\20lsp_before_save\a*.\1\4\0\0\16BufWritePre\0.lua vim.lsp.buf.formatting_sync(nil,1000)\vinsert\ntable\b%:e\vexpand\afn\bvimÎ\2\0\1\b\0\16\0)3\1\1\0003\2\0\0:\2\2\0014\2\3\0007\2\4\0023\3\6\0003\4\5\0;\1\1\4:\4\a\3>\2\2\0014\2\3\0007\2\b\0027\2\t\0027\2\n\2>\2\1\2:\1\a\0024\3\3\0007\3\b\0037\3\v\3'\4\0\0%\5\f\0\16\6\2\0\16\a\0\0>\3\5\2\14\0\3\0T\4\1€G\0\1\0008\4\1\0037\3\r\4\14\0\3\0T\4\1€G\0\1\0008\4\1\0037\4\14\0044\5\3\0007\5\b\0057\5\t\0057\5\15\5\16\6\4\0>\5\2\1G\0\1\0\25apply_workspace_edit\tedit\vresult\28textDocument/codeAction\21buf_request_sync\22make_range_params\tutil\blsp\fcontext\1\0\0\1\4\0\0\0\6t\2\rvalidate\bvim\vsource\1\0\0\1\0\1\20organizeImports\2k\0\0\2\0\6\0\r4\0\0\0007\0\1\0007\0\2\0004\1\0\0007\1\1\0017\1\3\1>\1\1\0=\0\0\0014\0\0\0007\0\4\0%\1\5\0>\0\2\1G\0\1\0\tedit\bcmd\23get_active_clients\16stop_client\blsp\bvimR\0\0\4\0\5\0\v4\0\0\0007\0\1\0007\0\2\0>\0\1\0024\1\0\0007\1\3\1%\2\4\0\16\3\0\0$\2\3\2>\1\2\1G\0\1\0\nedit \bcmd\17get_log_path\blsp\bvim±\1\0\2\6\2\6\0\0147\2\0\0007\2\1\2\15\0\2\0T\3\3€+\2\0\0007\2\2\2>\2\1\1+\2\1\0007\2\3\2\16\3\1\0%\4\4\0%\5\5\0>\2\4\1G\0\1\0\1À\0À\27v:lua.vim.lsp.omnifunc\romnifunc\24nvim_buf_set_option\20lsp_before_save\24document_formatting\26resolved_capabilitiesO\0\1\3\1\2\0\a7\1\0\0)\2\1\0:\2\1\1+\1\0\0\16\2\0\0>\1\2\1G\0\1\0\5À\24document_formatting\26resolved_capabilities•\f\1\0\16\0O\0\0014\0\0\0007\0\1\0002\1\0\0001\2\2\0001\3\4\0:\3\3\0011\3\6\0:\3\5\0014\3\a\0007\3\b\0037\3\t\3\14\0\3\0T\3\4€4\3\0\0007\3\n\3%\4\v\0>\3\2\0014\3\f\0%\4\r\0>\3\2\0027\4\14\0033\5\15\0>\4\2\0014\4\0\0007\4\16\0047\4\17\0047\4\18\4>\4\1\0027\5\19\0047\5\20\0057\5\21\5)\6\2\0:\6\22\0054\5\23\0001\6\25\0:\6\24\0054\5\23\0001\6\27\0:\6\26\0054\5\0\0007\5\n\5%\6\28\0>\5\2\0014\5\0\0007\5\n\5%\6\29\0>\5\2\0014\5\0\0007\5\16\0057\5\30\0054\6\0\0007\6\16\0067\6 \0064\a\0\0007\a\16\a7\a!\a7\a\"\a3\b#\0003\t$\0:\t%\b>\6\3\2:\6\31\0051\5&\0004\6\f\0%\a'\0>\6\2\0027\a(\0067\a)\a3\b+\0003\t*\0:\t\n\b:\5,\b:\4-\b3\t.\0:\t/\b>\a\2\0017\a0\0067\a)\a3\b7\0003\t5\0004\n1\0007\n2\n%\v3\0>\n\2\2%\v4\0$\n\v\n;\n\1\t4\n1\0007\n2\n%\v3\0>\n\2\2%\v6\0$\n\v\n;\n\3\t:\t\n\b3\tF\0003\n;\0003\v8\0003\f9\0:\f:\v:\v<\n3\v=\0:\v>\n3\vC\0004\f\0\0007\f?\f2\r\0\b4\14\0\0007\14@\0147\14A\14%\15B\0>\14\2\2)\15\2\0009\15\14\r2\14\0\0>\f\3\2:\fD\v:\vE\n:\nG\t:\tH\b>\a\2\0017\aI\0067\a)\a3\bK\0001\tJ\0:\t,\b>\a\2\0013\aL\0004\bM\0\16\t\a\0>\b\2\4T\v\5€6\r\f\0067\r)\r3\14N\0:\5,\14>\r\2\1A\v\3\3N\vù0\0\0€G\0\1\0\1\0\0\vipairs\1\2\0\0\rdockerls\1\0\0\0\rtsserver\rsettings\bLua\1\0\0\14workspace\flibrary\1\0\0\20$VIMRUNTIME/lua\vexpand\afn\16list_extend\fruntime\1\0\1\fversion\vLuaJIT\16diagnostics\1\0\0\fglobals\1\3\0\0\bvim\19packer_plugins\1\0\1\venable\2\1\0\0\"/lua-language-server/main.lua\1\3\0\0\0\a-E7/lua-language-server/bin/Linux/lua-language-server\tHOME\vgetenv\aos\16sumneko_lua\17init_options\1\0\2\23completeUnimported\2\20usePlaceholders\2\17capabilities\14on_attach\1\0\0\1\3\0\0\ngopls\18--remote=auto\nsetup\ngopls\14lspconfig\0\nsigns\1\0\2\rpriority\3\20\venable\2\1\0\3\14underline\2\17virtual_text\2\21update_in_insert\1\27on_publish_diagnostics\15diagnostic\twith$textDocument/publishDiagnostics\rhandlers9command! -nargs=0 LspRestart call v:lua.reload_lsp()7command! -nargs=0 LspLog call v:lua.open_lsp_log()\0\17open_lsp_log\0\15reload_lsp\a_G\19snippetSupport\19completionItem\15completion\17textDocument\29make_client_capabilities\rprotocol\blsp\1\0\1\21code_action_icon\tğŸ’¡\18init_lsp_saga\flspsaga\frequire\25packadd lspsaga.nvim\bcmd\vloaded\17lspsaga.nvim\19packer_plugins\0\29go_organize_imports_sync\0\20lsp_before_save\0\bapi\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\1\0023\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0\20NvimTreeRefresh\bcmd\bvim¹\19\1\0\6\0`\0‡\0024\0\0\0007\0\1\0'\1\1\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\3\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0004\0\0\0007\0\1\0003\1\6\0:\1\5\0004\0\0\0007\0\1\0'\1\1\0:\1\a\0004\0\0\0007\0\1\0'\1\0\0:\1\b\0004\0\0\0007\0\1\0'\1\1\0:\1\t\0004\0\0\0007\0\1\0'\1\1\0:\1\n\0004\0\0\0007\0\1\0'\1#\0:\1\v\0004\0\0\0007\0\1\0'\1\0\0:\1\f\0004\0\0\0007\0\1\0003\1\14\0:\1\r\0004\0\0\0007\0\1\0003\1\16\0003\2\17\0:\2\18\0013\2\19\0:\2\20\0013\2\21\0:\2\22\1:\1\15\0004\0\0\0007\0\1\0003\1\24\0:\1\23\0004\0\25\0%\1\26\0>\0\2\0027\0\27\0004\1\0\0007\1\1\0012\2 \0003\3\29\0003\4\28\0:\4\30\3\16\4\0\0%\5\31\0>\4\2\2:\4 \3;\3\1\0023\3\"\0003\4!\0:\4\30\3\16\4\0\0%\5#\0>\4\2\2:\4 \3;\3\2\0023\3$\0\16\4\0\0%\5%\0>\4\2\2:\4 \3;\3\3\0023\3&\0\16\4\0\0%\5'\0>\4\2\2:\4 \3;\3\4\0023\3(\0\16\4\0\0%\5)\0>\4\2\2:\4 \3;\3\5\0023\3*\0\16\4\0\0%\5+\0>\4\2\2:\4 \3;\3\6\0023\3,\0\16\4\0\0%\5-\0>\4\2\2:\4 \3;\3\a\0023\3.\0\16\4\0\0%\5/\0>\4\2\2:\4 \3;\3\b\0023\0030\0\16\4\0\0%\0051\0>\4\2\2:\4 \3;\3\t\0023\0032\0\16\4\0\0%\0051\0>\4\2\2:\4 \3;\3\n\0023\0033\0\16\4\0\0%\0054\0>\4\2\2:\4 \3;\3\v\0023\0035\0\16\4\0\0%\0056\0>\4\2\2:\4 \3;\3\f\0023\0037\0\16\4\0\0%\0058\0>\4\2\2:\4 \3;\3\r\0023\0039\0\16\4\0\0%\5:\0>\4\2\2:\4 \3;\3\14\0023\3;\0\16\4\0\0%\5<\0>\4\2\2:\4 \3;\3\15\0023\3=\0\16\4\0\0%\5>\0>\4\2\2:\4 \3;\3\16\0023\3?\0\16\4\0\0%\5@\0>\4\2\2:\4 \3;\3\17\0023\3A\0\16\4\0\0%\5B\0>\4\2\2:\4 \3;\3\18\0023\3C\0\16\4\0\0%\5D\0>\4\2\2:\4 \3;\3\19\0023\3E\0\16\4\0\0%\5F\0>\4\2\2:\4 \3;\3\20\0023\3G\0\16\4\0\0%\5H\0>\4\2\2:\4 \3;\3\21\0023\3I\0\16\4\0\0%\5J\0>\4\2\2:\4 \3;\3\22\0023\3K\0\16\4\0\0%\5L\0>\4\2\2:\4 \3;\3\23\0023\3M\0\16\4\0\0%\5N\0>\4\2\2:\4 \3;\3\24\0023\3O\0\16\4\0\0%\5P\0>\4\2\2:\4 \3;\3\25\0023\3Q\0\16\4\0\0%\5R\0>\4\2\2:\4 \3;\3\26\0023\3S\0\16\4\0\0%\5T\0>\4\2\2:\4 \3;\3\27\0023\3U\0\16\4\0\0%\5V\0>\4\2\2:\4 \3;\3\28\0023\3W\0\16\4\0\0%\5X\0>\4\2\2:\4 \3;\3\29\0023\3Y\0\16\4\0\0%\5Z\0>\4\2\2:\4 \3;\3\30\0023\3[\0\16\4\0\0%\5\\\0>\4\2\2:\4 \3;\3\31\2:\2\r\0014\1\25\0%\2]\0>\1\2\0027\1^\0011\2_\0>\1\2\1G\0\1\0\0\23on_nvim_tree_ready\21nvim-tree.events\16toggle_help\1\0\1\bkey\ag?\nclose\1\0\1\bkey\6q\vdir_up\1\0\1\bkey\6-\18next_git_item\1\0\1\bkey\a]c\18prev_git_item\1\0\1\bkey\a[c\23copy_absolute_path\1\0\1\bkey\agy\14copy_path\1\0\1\bkey\6Y\14copy_name\1\0\1\bkey\6y\npaste\1\0\1\bkey\6p\tcopy\1\0\1\bkey\6c\bcut\1\0\1\bkey\6x\16full_rename\1\0\1\bkey\n<C-r>\vrename\1\0\1\bkey\6r\vremove\1\0\1\bkey\6d\vcreate\1\0\1\bkey\6a\frefresh\1\0\1\bkey\6R\20toggle_dotfiles\1\0\1\bkey\6H\19toggle_ignored\1\0\1\bkey\6I\17last_sibling\1\0\1\bkey\6J\18first_sibling\1\0\1\bkey\6K\fpreview\1\0\1\bkey\n<Tab>\1\0\1\bkey\v<S-CR>\15close_node\1\0\1\bkey\t<BS>\16parent_node\1\0\1\bkey\6P\17next_sibling\1\0\1\bkey\6>\17prev_sibling\1\0\1\bkey\6<\vtabnew\1\0\1\bkey\n<C-t>\nsplit\1\0\1\bkey\n<C-x>\vvsplit\1\0\1\bkey\n<C-v>\acd\1\0\0\1\3\0\0\19<2-RightMouse>\n<C-]>\acb\tedit\bkey\1\0\0\1\4\0\0\t<CR>\6o\18<2-LeftMouse>\23nvim_tree_callback\21nvim-tree.config\frequire\1\0\4\ffolders\3\1\nfiles\3\1\bgit\3\1\18folder_arrows\3\0\25nvim_tree_show_icons\blsp\1\0\4\tinfo\bïš\thint\bïª\nerror\bï—\fwarning\bï±\bgit\1\0\6\runstaged\bï‘„\fignored\bâ—Œ\14untracked\bï—\runmerged\bîœ§\frenamed\bï‘¿\vstaged\bï‡\vfolder\1\0\6\fdefault\bï”\15empty_open\bï¸\topen\bï¸\nempty\bï”\fsymlink\bï’‚\17symlink_open\bï’‚\1\0\2\fdefault\tï…œ \fsymlink\tï’ \20nvim_tree_icons\1\0\2\6S5:lua require'nvim-tree'.on_keypress('split')<CR>\6s6:lua require'nvim-tree'.on_keypress('vsplit')<CR>\23nvim_tree_bindings\28nvim_tree_hijack_cursor\20nvim_tree_width\27nvim_tree_quit_on_open\30nvim_tree_lsp_diagnostics\21nvim_tree_follow\27nvim_tree_add_trailing\1\4\0\0\14.DS_Store\t.git\17node_modules\21nvim_tree_ignore\25nvim_tree_auto_close\28nvim_tree_hide_dotfiles\28nvim_tree_disable_netrw\6g\bvim\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\2à\3\0\0\4\0\19\0\0274\0\0\0007\0\1\0007\0\2\0%\1\3\0>\0\2\0014\0\0\0007\0\1\0007\0\2\0%\1\4\0>\0\2\0014\0\5\0%\1\6\0>\0\2\0027\0\a\0003\1\t\0003\2\b\0:\2\n\0013\2\v\0:\2\f\0013\2\r\0003\3\14\0:\3\15\2:\2\16\0013\2\17\0:\2\18\1>\0\2\1G\0\1\0\vindent\1\0\1\venable\2\26incremental_selection\fkeymaps\1\0\4\19init_selection\bgnn\22scope_incremental\bgrc\21node_incremental\bgrn\21node_decremental\bgrm\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\ago\ngomod\15javascript\15typescript\15dockerfile\blua\tjson\tyaml\nsetup\28nvim-treesitter.configs\frequire,set foldexpr=nvim_treesitter#foldexpr()\24set foldmethod=expr\17nvim_command\bapi\bvim\0" },
    load_after = {},
    loaded = false,
    needs_bufread = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  nvimux = {
    config = { "\27LJ\1\2\3\0\0\5\0\f\0\0224\0\0\0%\1\1\0>\0\2\0027\1\2\0007\1\3\0013\2\4\0>\1\2\0017\1\5\0007\1\6\0012\2\3\0003\3\a\0003\4\b\0;\4\3\3;\3\1\0023\3\t\0003\4\n\0;\4\3\3;\3\2\2>\1\2\0017\1\v\0>\1\1\1G\0\1\0\14bootstrap\1\5\0\0\6n\6v\6i\6t\1\3\0\0\6v\25:NvimuxVerticalSplit\1\5\0\0\6n\6v\6i\6t\1\3\0\0\6s\27:NvimuxHorizontalSplit\rbind_all\rbindings\1\0\b\22new_window_buffer\vsingle\vprefix\n<M-a>\fnew_tab\tterm\20quickterm_scope\6t\24quickterm_direction\rbotright\19quickterm_size\a80\15new_window\tterm\26quickterm_orientation\rvertical\fset_all\vconfig\vnvimux\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/nvimux"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["symbols-outline.nvim"] = {
    config = { "\27LJ\1\2i\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\2\27highlight_hovered_item\2\16show_guides\2\nsetup\20symbols-outline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim"
  },
  ["telescope.nvim"] = {
    after = { "nvim-treesitter" },
    loaded = true,
    only_config = true
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\1\2?\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/start/todo-comments.nvim"
  },
  ["vim-vsnip"] = {
    config = { "\27LJ\1\2m\0\0\3\0\a\0\n4\0\0\0007\0\1\0004\1\3\0007\1\4\1%\2\5\0>\1\2\2%\2\6\0$\1\2\1:\1\2\0G\0\1\0\27/.config/nvim/snippets\tHOME\vgetenv\aos\22vsnip_snippet_dir\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/yofriadi/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: formatter.nvim
time([[Config for formatter.nvim]], true)
try_loadstring("\27LJ\1\2Š\1\0\0\4\0\6\0\n3\0\0\0003\1\1\0004\2\2\0007\2\3\0027\2\4\2'\3\0\0>\2\2\2;\2\2\1:\1\5\0H\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\4\0\0\21--stdin-filepath\0\19--single-quote\1\0\2\nstdin\2\bexe\rprettier–\1\0\0\2\0\3\0\0043\0\0\0003\1\1\0:\1\2\0H\0\2\0\targs\1\5\0\0\23--column-limit=160\29--extra-sep-at-table-end#--single-quote-to-double-quote\22--chop-down-table\1\0\2\nstdin\2\bexe\15lua-formati\0\0\4\0\5\1\n3\0\0\0002\1\3\0004\2\1\0007\2\2\0027\2\3\2'\3\0\0>\2\2\0<\2\0\0:\1\4\0H\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\0\2\nstdin\2\bexe\vgo fmt\3€€À™\4 \1\1\0\5\0\f\0\0214\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\5\0002\3\3\0001\4\4\0;\4\1\3:\3\6\0022\3\3\0001\4\a\0;\4\1\3:\3\b\0022\3\3\0001\4\t\0;\4\1\3:\3\n\2:\2\v\1>\0\2\1G\0\1\0\rfiletype\ago\0\blua\0\15javascript\1\0\0\0\1\0\1\flogging\1\nsetup\14formatter\frequire\0", "config", "formatter.nvim")
time([[Config for formatter.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring('\27LJ\1\2ô\a\0\0\5\0#\0<4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1!\0003\2\4\0003\3\3\0:\3\5\0023\3\a\0003\4\6\0:\4\b\0033\4\t\0:\4\n\3:\3\v\0024\3\0\0%\4\f\0>\3\2\0027\3\r\3:\3\14\0022\3\0\0:\3\15\0024\3\0\0%\4\f\0>\3\2\0027\3\16\3:\3\17\0022\3\0\0:\3\18\0023\3\19\0:\3\20\0022\3\0\0:\3\21\0023\3\22\0:\3\23\0024\3\0\0%\4\24\0>\3\2\0027\3\25\0037\3\26\3:\3\27\0024\3\0\0%\4\24\0>\3\2\0027\3\28\0037\3\26\3:\3\29\0024\3\0\0%\4\24\0>\3\2\0027\3\30\0037\3\26\3:\3\31\0024\3\0\0%\4\24\0>\3\2\0027\3 \3:\3 \2:\2"\1>\0\2\1G\0\1\0\rdefaults\1\0\0\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\17path_display\16borderchars\1\t\0\0\bâ”€\bâ”‚\bâ”€\bâ”‚\bâ•­\bâ•®\bâ•¯\bâ•°\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\16file_sorter\17get_fzy_file\22telescope.sorters\18layout_config\rvertical\1\0\1\vmirror\1\15horizontal\1\0\2\nwidth\4\0€€ ÿ\3\19preview_cutoff\3x\1\0\1\vmirror\1\22vimgrep_arguments\1\0\n\20layout_strategy\rvertical\ruse_less\2\23selection_strategy\nreset\17entry_prefix\6 \21sorting_strategy\14ascending\18prompt_prefix\6 \17initial_mode\vinsert\rwinblend\3\0\19color_devicons\2\20selection_caret\6 \1\b\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\nsetup\14telescope\frequire\0', "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\1\0023\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0\20NvimTreeRefresh\bcmd\bvim¹\19\1\0\6\0`\0‡\0024\0\0\0007\0\1\0'\1\1\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\3\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0004\0\0\0007\0\1\0003\1\6\0:\1\5\0004\0\0\0007\0\1\0'\1\1\0:\1\a\0004\0\0\0007\0\1\0'\1\0\0:\1\b\0004\0\0\0007\0\1\0'\1\1\0:\1\t\0004\0\0\0007\0\1\0'\1\1\0:\1\n\0004\0\0\0007\0\1\0'\1#\0:\1\v\0004\0\0\0007\0\1\0'\1\0\0:\1\f\0004\0\0\0007\0\1\0003\1\14\0:\1\r\0004\0\0\0007\0\1\0003\1\16\0003\2\17\0:\2\18\0013\2\19\0:\2\20\0013\2\21\0:\2\22\1:\1\15\0004\0\0\0007\0\1\0003\1\24\0:\1\23\0004\0\25\0%\1\26\0>\0\2\0027\0\27\0004\1\0\0007\1\1\0012\2 \0003\3\29\0003\4\28\0:\4\30\3\16\4\0\0%\5\31\0>\4\2\2:\4 \3;\3\1\0023\3\"\0003\4!\0:\4\30\3\16\4\0\0%\5#\0>\4\2\2:\4 \3;\3\2\0023\3$\0\16\4\0\0%\5%\0>\4\2\2:\4 \3;\3\3\0023\3&\0\16\4\0\0%\5'\0>\4\2\2:\4 \3;\3\4\0023\3(\0\16\4\0\0%\5)\0>\4\2\2:\4 \3;\3\5\0023\3*\0\16\4\0\0%\5+\0>\4\2\2:\4 \3;\3\6\0023\3,\0\16\4\0\0%\5-\0>\4\2\2:\4 \3;\3\a\0023\3.\0\16\4\0\0%\5/\0>\4\2\2:\4 \3;\3\b\0023\0030\0\16\4\0\0%\0051\0>\4\2\2:\4 \3;\3\t\0023\0032\0\16\4\0\0%\0051\0>\4\2\2:\4 \3;\3\n\0023\0033\0\16\4\0\0%\0054\0>\4\2\2:\4 \3;\3\v\0023\0035\0\16\4\0\0%\0056\0>\4\2\2:\4 \3;\3\f\0023\0037\0\16\4\0\0%\0058\0>\4\2\2:\4 \3;\3\r\0023\0039\0\16\4\0\0%\5:\0>\4\2\2:\4 \3;\3\14\0023\3;\0\16\4\0\0%\5<\0>\4\2\2:\4 \3;\3\15\0023\3=\0\16\4\0\0%\5>\0>\4\2\2:\4 \3;\3\16\0023\3?\0\16\4\0\0%\5@\0>\4\2\2:\4 \3;\3\17\0023\3A\0\16\4\0\0%\5B\0>\4\2\2:\4 \3;\3\18\0023\3C\0\16\4\0\0%\5D\0>\4\2\2:\4 \3;\3\19\0023\3E\0\16\4\0\0%\5F\0>\4\2\2:\4 \3;\3\20\0023\3G\0\16\4\0\0%\5H\0>\4\2\2:\4 \3;\3\21\0023\3I\0\16\4\0\0%\5J\0>\4\2\2:\4 \3;\3\22\0023\3K\0\16\4\0\0%\5L\0>\4\2\2:\4 \3;\3\23\0023\3M\0\16\4\0\0%\5N\0>\4\2\2:\4 \3;\3\24\0023\3O\0\16\4\0\0%\5P\0>\4\2\2:\4 \3;\3\25\0023\3Q\0\16\4\0\0%\5R\0>\4\2\2:\4 \3;\3\26\0023\3S\0\16\4\0\0%\5T\0>\4\2\2:\4 \3;\3\27\0023\3U\0\16\4\0\0%\5V\0>\4\2\2:\4 \3;\3\28\0023\3W\0\16\4\0\0%\5X\0>\4\2\2:\4 \3;\3\29\0023\3Y\0\16\4\0\0%\5Z\0>\4\2\2:\4 \3;\3\30\0023\3[\0\16\4\0\0%\5\\\0>\4\2\2:\4 \3;\3\31\2:\2\r\0014\1\25\0%\2]\0>\1\2\0027\1^\0011\2_\0>\1\2\1G\0\1\0\0\23on_nvim_tree_ready\21nvim-tree.events\16toggle_help\1\0\1\bkey\ag?\nclose\1\0\1\bkey\6q\vdir_up\1\0\1\bkey\6-\18next_git_item\1\0\1\bkey\a]c\18prev_git_item\1\0\1\bkey\a[c\23copy_absolute_path\1\0\1\bkey\agy\14copy_path\1\0\1\bkey\6Y\14copy_name\1\0\1\bkey\6y\npaste\1\0\1\bkey\6p\tcopy\1\0\1\bkey\6c\bcut\1\0\1\bkey\6x\16full_rename\1\0\1\bkey\n<C-r>\vrename\1\0\1\bkey\6r\vremove\1\0\1\bkey\6d\vcreate\1\0\1\bkey\6a\frefresh\1\0\1\bkey\6R\20toggle_dotfiles\1\0\1\bkey\6H\19toggle_ignored\1\0\1\bkey\6I\17last_sibling\1\0\1\bkey\6J\18first_sibling\1\0\1\bkey\6K\fpreview\1\0\1\bkey\n<Tab>\1\0\1\bkey\v<S-CR>\15close_node\1\0\1\bkey\t<BS>\16parent_node\1\0\1\bkey\6P\17next_sibling\1\0\1\bkey\6>\17prev_sibling\1\0\1\bkey\6<\vtabnew\1\0\1\bkey\n<C-t>\nsplit\1\0\1\bkey\n<C-x>\vvsplit\1\0\1\bkey\n<C-v>\acd\1\0\0\1\3\0\0\19<2-RightMouse>\n<C-]>\acb\tedit\bkey\1\0\0\1\4\0\0\t<CR>\6o\18<2-LeftMouse>\23nvim_tree_callback\21nvim-tree.config\frequire\1\0\4\ffolders\3\1\nfiles\3\1\bgit\3\1\18folder_arrows\3\0\25nvim_tree_show_icons\blsp\1\0\4\tinfo\bïš\thint\bïª\nerror\bï—\fwarning\bï±\bgit\1\0\6\runstaged\bï‘„\fignored\bâ—Œ\14untracked\bï—\runmerged\bîœ§\frenamed\bï‘¿\vstaged\bï‡\vfolder\1\0\6\fdefault\bï”\15empty_open\bï¸\topen\bï¸\nempty\bï”\fsymlink\bï’‚\17symlink_open\bï’‚\1\0\2\fdefault\tï…œ \fsymlink\tï’ \20nvim_tree_icons\1\0\2\6S5:lua require'nvim-tree'.on_keypress('split')<CR>\6s6:lua require'nvim-tree'.on_keypress('vsplit')<CR>\23nvim_tree_bindings\28nvim_tree_hijack_cursor\20nvim_tree_width\27nvim_tree_quit_on_open\30nvim_tree_lsp_diagnostics\21nvim_tree_follow\27nvim_tree_add_trailing\1\4\0\0\14.DS_Store\t.git\17node_modules\21nvim_tree_ignore\25nvim_tree_auto_close\28nvim_tree_hide_dotfiles\28nvim_tree_disable_netrw\6g\bvim\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\1\2\1\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\rmappings\1\0\2\veasing\2\16hide_cursor\1\1\t\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\azt\azz\azb\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: nvimux
time([[Config for nvimux]], true)
try_loadstring("\27LJ\1\2\3\0\0\5\0\f\0\0224\0\0\0%\1\1\0>\0\2\0027\1\2\0007\1\3\0013\2\4\0>\1\2\0017\1\5\0007\1\6\0012\2\3\0003\3\a\0003\4\b\0;\4\3\3;\3\1\0023\3\t\0003\4\n\0;\4\3\3;\3\2\2>\1\2\0017\1\v\0>\1\1\1G\0\1\0\14bootstrap\1\5\0\0\6n\6v\6i\6t\1\3\0\0\6v\25:NvimuxVerticalSplit\1\5\0\0\6n\6v\6i\6t\1\3\0\0\6s\27:NvimuxHorizontalSplit\rbind_all\rbindings\1\0\b\22new_window_buffer\vsingle\vprefix\n<M-a>\fnew_tab\tterm\20quickterm_scope\6t\24quickterm_direction\rbotright\19quickterm_size\a80\15new_window\tterm\26quickterm_orientation\rvertical\fset_all\vconfig\vnvimux\frequire\0", "config", "nvimux")
time([[Config for nvimux]], false)
-- Config for: diffview.nvim
time([[Config for diffview.nvim]], true)
try_loadstring("\27LJ\1\2Ç\4\0\0\a\0\30\0G4\0\0\0%\1\1\0>\0\2\0027\0\2\0004\1\0\0%\2\3\0>\1\2\0027\1\4\0013\2\5\0003\3\6\0:\3\a\0023\3\17\0003\4\t\0\16\5\0\0%\6\b\0>\5\2\2:\5\n\4\16\5\0\0%\6\v\0>\5\2\2:\5\f\4\16\5\0\0%\6\r\0>\5\2\2:\5\14\4\16\5\0\0%\6\15\0>\5\2\2:\5\16\4:\4\18\0033\4\20\0\16\5\0\0%\6\19\0>\5\2\2:\5\21\4\16\5\0\0%\6\22\0>\5\2\2:\5\23\4\16\5\0\0%\6\24\0>\5\2\2:\5\25\4\16\5\0\0%\6\24\0>\5\2\2:\5\26\4\16\5\0\0%\6\27\0>\5\2\2:\5\28\4\16\5\0\0%\6\b\0>\5\2\2:\5\n\4\16\5\0\0%\6\v\0>\5\2\2:\5\f\4\16\5\0\0%\6\r\0>\5\2\2:\5\14\4\16\5\0\0%\6\15\0>\5\2\2:\5\16\4:\4\a\3:\3\29\2>\1\2\1G\0\1\0\17key_bindings\6R\18refresh_files\6o\t<cr>\17select_entry\6k\15prev_entry\6j\1\0\0\15next_entry\tview\1\0\0\14<leader>b\17toggle_files\14<leader>e\16focus_files\f<s-tab>\22select_prev_entry\n<tab>\1\0\0\22select_next_entry\15file_panel\1\0\2\nwidth\3\30\14use_icons\2\1\0\1\18diff_binaries\1\nsetup\rdiffview\22diffview_callback\20diffview.config\frequire\0", "config", "diffview.nvim")
time([[Config for diffview.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\1\2?\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\1\2é\3\0\0\6\1\28\00083\0\0\0003\1\2\0+\2\0\0007\2\1\2:\2\3\1+\2\0\0007\2\4\2:\2\5\1+\2\0\0007\2\4\2:\2\6\1+\2\0\0007\2\4\2:\2\a\1+\2\0\0007\2\4\2:\2\b\1+\2\0\0007\2\4\2:\2\t\1+\2\0\0007\2\4\2:\2\n\1+\2\0\0007\2\v\2:\2\f\1+\2\0\0007\2\v\2:\2\r\1+\2\0\0007\2\14\2:\2\15\1+\2\0\0007\2\16\2:\2\17\1+\2\0\0007\2\18\2:\2\19\1+\2\0\0007\2\18\2:\2\20\0014\2\21\0007\2\22\0027\2\23\2>\2\1\0024\3\21\0007\3\24\0037\3\25\3%\4\26\0006\5\2\1$\4\5\4>\3\2\0016\3\2\0%\4\27\0$\3\4\3H\3\2\0\1À\f î˜«   \27hi GalaxyViMode guifg=\17nvim_command\bapi\tmode\afn\bvim\6t\6!\rdarkblue\6r\fmagenta\6c\tblue\6R\6i\bred\6\19\6S\6s\6\22\6V\6v\vorange\6n\1\0\0\ngreen\1\0\r\6S\vS-LINE\6!\rEXTERNAL\6\22\fV-BLOCK\6r\vPROMPT\6V\vV-LINE\6s\vSELECT\6t\rTERMINAL\6c\fCOMMAND\6v\vVISUAL\6R\fREPLACE\6n\vNORMAL\6\19\fS-BLOCK\6i\vINSERT\21\0\0\1\0\1\0\2%\0\0\0H\0\2\0\n îœ¥ T\0\0\2\0\4\0\v3\0\0\0004\1\1\0007\1\2\0017\1\3\0016\1\1\0\15\0\1\0T\2\2€)\1\1\0H\1\2\0)\1\2\0H\1\2\0\rfiletype\abo\bvim\1\0\2\6 \2\14dashboard\2^\0\0\4\0\6\0\n%\0\0\0004\1\1\0007\1\2\0017\1\3\1'\2\0\0%\3\4\0>\1\3\2%\2\5\0$\0\2\0H\0\2\0\6 \ftabstop\24nvim_buf_get_option\bapi\bvim\rSpaces: \17\0\0\1\0\1\0\2%\0\0\0H\0\2\0\6 ï\22\1\0\t\0o\0Ê\0024\0\0\0%\1\1\0>\0\2\0023\1\3\0:\1\2\0003\1\4\0004\2\0\0%\3\5\0>\2\2\0027\3\6\0003\4\a\0:\4\2\0007\4\b\0033\5\16\0003\6\n\0001\a\t\0:\a\v\0063\a\14\0007\b\f\1;\b\1\a7\b\r\1;\b\2\a:\a\15\6:\6\17\5;\5\1\0047\4\b\0033\5\22\0003\6\18\0007\a\19\2:\a\20\0062\a\3\0007\b\21\1;\b\1\a7\b\r\1;\b\2\a:\a\15\6:\6\23\5;\5\2\0047\4\b\0033\5\29\0003\6\25\0003\a\24\0:\a\v\0067\a\19\2:\a\20\0063\a\26\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b\21\1;\b\1\a7\b\r\1;\b\2\a:\a\15\6:\6\30\5;\5\3\0047\4\b\0033\5$\0003\6 \0001\a\31\0:\a\v\0067\a!\2:\a\20\0063\a\"\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6%\5;\5\4\0047\4\b\0033\5)\0003\6&\0007\a!\2:\a\20\0063\a'\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6*\5;\5\5\0047\4\b\0033\5.\0003\6+\0007\a,\2:\a\20\0062\a\3\0007\b-\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6/\5;\5\6\0047\4\b\0033\0051\0003\0060\0007\a,\2:\a\20\0062\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\0062\5;\5\a\0047\4\b\0033\0054\0003\0063\0007\a,\2:\a\20\0062\a\3\0007\b\f\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\0065\5;\5\b\0047\0046\0033\0059\0003\0067\0002\a\3\0007\b8\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6:\5;\5\1\0047\0046\0033\5<\0003\6;\0002\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6=\5;\5\2\0047\0046\0033\5?\0003\6>\0002\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6@\5;\5\3\0047\0046\0033\5C\0003\6A\0002\a\3\0007\bB\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6D\5;\5\4\0047\0046\0033\5H\0003\6E\0001\aF\0:\a\20\0062\a\3\0007\bG\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6I\5;\5\5\0047\0046\0033\5L\0003\6J\0003\aK\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6M\5;\5\6\0047\0046\0033\5P\0003\6N\0003\aO\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6Q\5;\5\a\0047\0046\0033\5U\0003\6S\0001\aR\0:\a\v\0067\a,\2:\a\20\0063\aT\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6V\5;\5\b\0047\0046\0033\5Y\0003\6W\0007\a,\2:\a\20\0063\aX\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6Z\5;\5\t\0047\0046\0033\5]\0003\6[\0007\a,\2:\a\20\0063\a\\\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6^\5;\5\n\0047\0046\0033\5b\0003\6`\0001\a_\0:\a\v\0063\aa\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b#\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6c\5;\5\v\0047\4d\0033\5g\0003\6e\0003\af\0007\b\27\1;\b\2\a:\a\28\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6Z\5;\5\1\0047\4d\0033\5i\0003\6h\0007\a\19\2:\a\20\0062\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6j\5;\5\2\0047\4k\0033\5m\0003\6l\0002\a\3\0007\b(\1;\b\1\a7\b\27\1;\b\2\a:\a\15\6:\6n\5;\5\1\0040\0\0€G\0\1\0\15BufferIcon\1\0\0\1\0\1\rprovider\15BufferIcon\21short_line_right\14SFileName\1\0\0\1\0\1\rprovider\14SFileName\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\17FileTypeName\20short_line_left\nSpace\1\0\0\1\2\0\0\tNONE\1\0\1\14separator\6 \0\15FileEncode\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\15FileEncode\15BufferType\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\17FileTypeName\fTabstop\1\0\0\1\2\0\0\tNONE\1\0\1\14separator\6 \0\fPerCent\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\16LinePercent\rLineInfo\1\0\0\1\2\0\0\tNONE\1\0\2\14separator\a  \rprovider\15LineColumn\18ShowLspClient\1\0\0\vpurple\0\1\0\2\ticon\v ï‚…  \rprovider\17GetLspClient\19DiagnosticInfo\1\0\0\tblue\1\0\2\ticon\n ïš \rprovider\19DiagnosticInfo\19DiagnosticHint\1\0\0\1\0\2\ticon\n ïª \rprovider\19DiagnosticHint\19DiagnosticWarn\1\0\0\1\0\2\ticon\n ï± \rprovider\19DiagnosticWarn\20DiagnosticError\1\0\0\14error_red\1\0\2\ticon\n ï— \rprovider\20DiagnosticError\nright\15DiffRemove\1\0\0\1\0\2\ticon\v  ï‘˜ \rprovider\15DiffRemove\17DiffModified\1\0\0\1\0\2\ticon\v  ï‘™ \rprovider\17DiffModified\fDiffAdd\1\0\0\ngreen\18hide_in_width\1\0\2\ticon\v  ï‘— \rprovider\fDiffAdd\14GitBranch\1\0\0\tgrey\1\2\0\0\tNONE\1\0\2\14separator\6 \rprovider\14GitBranch\fGitIcon\1\0\0\vorange\1\2\0\0\tNONE\24check_git_workspace\1\0\0\0\rFileName\1\0\0\24separator_highlight\abg\1\2\0\0\tNONE\1\0\1\14separator\6 \1\2\0\0\rFileName\rFileIcon\1\0\0\fmagenta\14condition\21buffer_not_empty\1\0\1\rprovider\rFileIcon\vViMode\1\0\0\14highlight\1\4\0\0\0\0\tbold\fline_bg\bred\rprovider\1\0\0\0\tleft\1\5\0\0\rNvimTree\nvista\tdbui\vpacker\fsection\25galaxyline.condition\1\0\16\tblue\f#83a598\afg\f#E7BC74\14error_red\f#F24949\vyellow\f#E6B673\rdarkblue\f#458588\abg\f#4C566A\fmagenta\f#ea6962\fline_bg\f#4C566A\vorange\f#F2994B\tcyan\f#39A291\rfg_green\f#458588\tgray\f#E7BC74\bred\f#F24949\ngreen\f#689d6a\vpurple\f#008080\blbg\f#4C566A\1\5\0\0\rNvimTree\nvista\tdbui\vpacker\20short_line_list\15galaxyline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\1\2Š\1\0\3\t\0\a\0\0193\3\0\0\15\0\2\0T\4\a€4\4\1\0007\4\2\4%\5\3\0\16\6\3\0\16\a\2\0>\4\4\2\16\3\4\0004\4\1\0007\4\4\0047\4\5\4%\5\6\0\16\6\0\0\16\a\1\0\16\b\3\0>\4\5\1G\0\1\0\6i\20nvim_set_keymap\bapi\nforce\15tbl_extend\bvim\1\0\1\fnoremap\0019\0\0\2\0\4\0\0064\0\0\0007\0\1\0007\0\2\0%\1\3\0>\0\2\1G\0\1\0\t<cr>\18compe#confirm\afn\bvim\2\1\0\3\1\f\2'4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0\27€4\0\0\0007\0\1\0007\0\3\0>\0\1\0027\0\4\0\b\0\1\0T\0\t€4\0\0\0007\0\1\0007\0\5\0>\0\1\1+\0\0\0007\0\6\0%\1\a\0000\0\17€T\0\15€4\0\0\0007\0\b\0001\1\t\0'\2\20\0>\0\3\1+\0\0\0007\0\6\0%\1\n\0000\0\0€@\0\2\0T\0\4€+\0\0\0007\0\v\0000\0\0€@\0\1\0G\0\1\0@\0\2\0\0À\26check_break_line_char\n<c-n>\0\rdefer_fn\5\besc\18compe#confirm\rselected\18complete_info\15pumvisible\afn\bvim\0şÿÿÿ\31²\2\0\0\5\1\f\2+4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0!€4\0\0\0007\0\1\0007\0\3\0>\0\1\0027\0\4\0\b\0\1\0T\0\t€4\0\0\0007\0\1\0007\0\5\0>\0\1\1+\0\0\0007\0\6\0%\1\a\0@\0\2\0T\0\20€4\0\0\0007\0\b\0007\0\t\0'\1\0\0)\2\1\0)\3\1\0002\4\0\0>\0\5\0014\0\0\0007\0\1\0007\0\5\0>\0\1\1+\0\0\0007\0\6\0%\1\n\0@\0\2\0T\0\3€+\0\0\0007\0\v\0@\0\1\0G\0\1\0\0À\26check_break_line_char\n<c-n>\31nvim_select_popupmenu_item\bapi\5\besc\18compe#confirm\rselected\18complete_info\15pumvisible\afn\bvim\0şÿÿÿ\31\2\0\0\6\1\f\1'4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0\5€+\0\0\0007\0\3\0%\1\4\0@\0\2\0T\0\27€4\0\0\0007\0\1\0007\0\5\0'\1\1\0>\0\2\2\b\0\0\0T\0\16€4\0\0\0007\0\1\0007\0\6\0004\1\a\0007\1\b\1%\2\t\0'\3€\0'\4ı\0'\5S\0>\1\5\0=\0\0\1+\0\0\0007\0\3\0%\1\n\0@\0\2\0T\0\4€+\0\0\0007\0\3\0%\1\v\0@\0\2\0G\0\1\0\0À\n<Tab>\5!%c%c%c(vsnip-expand-or-jump)\vformat\vstring\rfeedkeys\20vsnip#available\n<C-n>\besc\15pumvisible\afn\bvim\0‡\2\0\0\6\1\f\1'4\0\0\0007\0\1\0007\0\2\0>\0\1\2\b\0\0\0T\0\5€+\0\0\0007\0\3\0%\1\4\0@\0\2\0T\0\27€4\0\0\0007\0\1\0007\0\5\0'\1ÿÿ>\0\2\2\b\0\0\0T\0\16€4\0\0\0007\0\1\0007\0\6\0004\1\a\0007\1\b\1%\2\t\0'\3€\0'\4ı\0'\5S\0>\1\5\0=\0\0\1+\0\0\0007\0\3\0%\1\n\0@\0\2\0T\0\4€+\0\0\0007\0\3\0%\1\v\0@\0\2\0G\0\1\0\0À\n<C-h>\5\28%c%c%c(vsnip-jump-prev)\vformat\vstring\rfeedkeys\19vsnip#jumpable\n<C-p>\besc\15pumvisible\afn\bvim\0½\4\1\0\a\0\"\00094\0\0\0007\0\1\0007\0\2\0\14\0\0\0T\0\4€4\0\3\0007\0\4\0%\1\5\0>\0\2\0014\0\6\0%\1\a\0>\0\2\0027\0\b\0>\0\1\0014\0\6\0%\1\a\0>\0\2\0021\1\t\0004\2\n\0002\3\0\0:\3\v\0024\2\3\0007\2\f\2%\3\14\0:\3\r\0024\2\v\0001\3\16\0:\3\15\0024\2\v\0001\3\17\0:\3\15\0024\2\v\0001\3\19\0:\3\18\0024\2\v\0001\3\21\0:\3\20\0024\2\3\0007\2\22\0027\2\23\2%\3\24\0%\4\25\0%\5\26\0003\6\27\0>\2\5\1\16\2\1\0%\3\28\0%\4\29\0003\5\30\0>\2\4\1\16\2\1\0%\3\31\0%\4 \0003\5!\0>\2\4\0010\0\0€G\0\1\0\1\0\2\texpr\2\fnoremap\2\25v:lua.MUtils.s_tab()\f<S-Tab>\1\0\2\texpr\2\fnoremap\2\23v:lua.MUtils.tab()\n<Tab>\1\0\2\texpr\2\fnoremap\2&v:lua.MUtils.completion_confirm()\t<CR>\6i\20nvim_set_keymap\bapi\0\ns_tab\0\btab\0\0\23completion_confirm\5\27completion_confirm_key\6g\vMUtils\a_G\0\nsetup\19nvim-autopairs\frequire\28packadd nvim-treesitter\bcmd\bvim\vloaded\20nvim-treesitter\19packer_plugins\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-base16
time([[Config for nvim-base16]], true)
try_loadstring("\27LJ\1\2·\2\0\0\3\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\1\2\0003\2\3\0>\1\2\1G\0\1\0\1\0\16\vbase07\f#8FBCBB\vbase08\f#B48EAD\vbase04\f#D8DEE9\vbase0A\f#5E81AC\vbase05\f#E5E9F0\vbase0F\f#D08770\vbase02\f#434C5E\vbase09\f#81A1C1\vbase03\f#4C566A\vbase0D\f#EBCB8B\vbase00\f#2E3440\vbase0E\f#88C0D0\vbase01\f#3B4252\vbase0B\f#A3BE8C\vbase06\f#ECEFF4\vbase0C\f#D08770\nsetup\23base16-colorscheme\frequire\0", "config", "nvim-base16")
time([[Config for nvim-base16]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file HopWord lua require("packer.load")({'hop'}, { cmd = "HopWord", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Lspsaga lua require("packer.load")({'lspsaga.nvim'}, { cmd = "Lspsaga", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'nvim-lspconfig'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'vim-vsnip'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe', 'lspkind-nvim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'nvim-treesitter', 'symbols-outline.nvim', 'indent-blankline.nvim', 'lsp-trouble.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
