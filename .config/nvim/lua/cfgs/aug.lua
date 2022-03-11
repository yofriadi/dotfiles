local util = require("util")

return function()
    vim.api.nvim_exec([[
        " au BufEnter * set fo-=c fo-=r fo-=o                 " stop annoying auto commenting on new lines
        au FileType help wincmd L                           " open help in vertical split

        " lang indentation
        autocmd FileType go setlocal ts=8 sw=8
        autocmd FileType json setlocal ts=2 sw=2
        autocmd FileType javascript setlocal ts=2 sw=2
        autocmd FileType typescript setlocal ts=2 sw=2
        autocmd FileType lua setlocal ts=4 sw=4
        autocmd FileType sql setlocal ts=4 sw=4
        autocmd FileType dart setlocal ts=2 sw=2
        autocmd FileType typescriptreact setlocal ts=2 sw=2

        " WSL yank support
        let clip = '/mnt/c/Windows/System32/clip.exe'
        if executable(clip)
          augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(clip, @0) | endif
          augroup END
        endif
    ]], false)

    util.augroups({
        --[[ packer = {
            {"BufWritePost","*.lua","lua require('pack').auto_compile()"};
        }, ]]
        buf = {
            -- Reload vim config automatically
            {"BufWritePost", [[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]]},
            -- Reload Vim script automatically if setlocal autoread
            {"BufWritePost,FileWritePost", "*.vim", [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]]},
            {"BufWritePre", "/tmp/*", "setlocal noundofile"},
            {"BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile"},
            {"BufWritePre", "MERGE_MSG", "setlocal noundofile"},
            {"BufWritePre", "*.tmp", "setlocal noundofile"},
            {"BufWritePre", "*.bak", "setlocal noundofile"},
            {"BufWritePre", "*.tsx", "lua vim.api.nvim_command('Format')"},
            -- {"BufWritePre", "*.go", "lua require('langs.go').golines_format()"},
            {"BufWritePost", "*.lua", "FormatWrite"},
            -- stop annoying auto commenting on new lines
            {"BufEnter", "*", "set fo-=c fo-=r fo-=o"},
            {"TextYankPost", "*", "if v:event.operator ==# 'y' | call system(clip, @0) | endif"},
        },
        win = {
            -- Highlight current line only on focused window
            {"WinEnter,BufEnter,InsertLeave", "*", [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]]},
            {"WinLeave,BufLeave,InsertEnter", "*", [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]]}, -- Equalize window dimensions when resizing vim window
            {"VimResized", "*", [[tabdo wincmd =]]}, -- Force write shada on leaving nvim
            {"VimLeave", "*", [[if has('nvim') | wshada! | else | wviminfo! | endif]]},
            -- Check if file changed when its window is focus, more eager than 'autoread'
            {"FocusGained", "* checktime"},
        },
        -- ft = {
        -- {'FileType', '*', 'lua require("M.global.filetypes").init()'}
        -- {"FileType", "dashboard", "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2"};
        -- {"BufNewFile,BufRead","*.toml"," setf toml"},
        -- },
        general = {
            {"TextYankPost", "*", "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})"},
            {"BufWinEnter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
            {"BufRead", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
            {"BufNewFile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
            -- {'BufWinEnter', '*.ex', 'set filetype=elixir'},
            -- {'BufWinEnter', '*.exs', 'set filetype=elixir'},
            -- {'BufNewFile', '*.ex', 'set filetype=elixir'},
            -- {'BufNewFile', '*.exs', 'set filetype=elixir'},
            -- {'BufWinEnter', '*.graphql', 'set filetype=graphql'}
        },
        -- yank = {
        --   {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})]]}
        -- },
        --[[ lsp = {
            {'FileType', '*', 'lua require("M.global.filetypes").init()'}
        },
        dashboard = {
            {
                'FileType', 'dashboard',
                'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= '
            },
            {
                'FileType', 'dashboard',
                'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2'
            }
        } ]]
    })
end
