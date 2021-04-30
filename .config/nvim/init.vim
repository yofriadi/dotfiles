let s:settings_config_dir = expand('~/.config/nvim')
let s:settings_plug_path = expand(s:settings_config_dir . '/plug.vim')
let s:settings_plugin_dir = expand(s:settings_config_dir . '/plugins')
let s:settings_data_dir = expand(s:settings_config_dir . '/data')

if !filereadable(s:settings_plug_path)
  silent! exec 'silent !curl -fkLo "' . s:settings_plug_path . '" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endi
silent! exec 'source ' . s:settings_plug_path

let g:plug_shallow = 0
call plug#begin(s:settings_plugin_dir)
Plug 'arcticicestudio/nord-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
"Plug 'sebdah/vim-delve'

Plug 'caenrique/nvim-toggle-terminal'
Plug 'tyru/caw.vim'
Plug 'psliwka/vim-smoothie'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'troydm/zoomwintab.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'RRethy/vim-illuminate'
Plug 'jiangmiao/auto-pairs'
call plug#end()

"Plug 'easymotion/vim-easymotion'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'preservim/nerdcommenter'
"Plug 'christoomey/vim-tmux-navigator'
"Plug 'ervandew/supertab'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'prabirshrestha/asyncomplete-buffer.vim'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cursorline
set number
set expandtab
set smartcase
set breakindent
set relativenumber
set noshowmode
set undofile
set lazyredraw
set nobackup
set hidden
set splitright splitbelow
set nofoldenable
set wrapscan
set shortmess-=S
set foldmethod=indent
set undodir=/tmp
set textwidth=90
set tabstop=2
set synmaxcol=180
set shiftwidth=2
set clipboard=unnamedplus
set grepprg=rg\ --vimgrep  " use rg as default grepper
set showtabline=0  " vim-ctrlspace
set autowriteall " nvim-toggle-terminal

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" vim-ctrlspace
let g:CtrlSpaceDefaultMappingKey = "<C-space> "

"" vim-tmux-navigator
"nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
"nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
"nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
"nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
"let g:tmux_navigator_disable_when_zoomed = 1

"" vim-illuminate
let g:Illuminate_highlightUnderCursor = 0
let g:Illuminate_ftblacklist = ['nerdtree']

" coc-nvim
let g:coc_global_extensions = ['coc-json', 'coc-snippets', 'coc-tsserver', 'coc-go']

" vim-go
let g:go_doc_keywordprg_enabled = 0

" vim-delve
"let g:delve_backend = "native"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=" "

" Switch between the last two files
nnoremap <leader><leader> <c-^>
"set autowrite

colorscheme nord
hi NonText guifg=bg  " mask ~ on empty lines

" disable hl with 2 esc
noremap <silent><esc> <esc>:noh<CR><esc>

" move vertically by visual line with j,k
nnoremap j gj
nnoremap k gk

" disable hl with 2 esc
noremap <silent><esc> <esc>:noh<CR><esc>

" use a different register for delete and paste
nnoremap d "_d
vnoremap d "_d
vnoremap p "_dP
nnoremap x "_x

" Move a line of text using ALT/OPT+[jk]
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

map <C-n> :NERDTreeToggle<CR>

let g:SuperTabDefaultCompletionType = "<c-n>"

" coc-go
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>

" nvim-terminal-toggle
nnoremap <silent> <C-z> :ToggleTerminal<Enter>
tnoremap <silent> <C-z> <C-\><C-n>:ToggleTerminal<Enter>
tnoremap <Esc> <C-\><C-n>

" vim-go
"let g:go_rename_command = 'gopls'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMANDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufEnter * set fo-=c fo-=r fo-=o                 " stop annoying auto commenting on new lines
au FileType help wincmd L                           " open help in vertical split

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" lang indentation
autocmd FileType go setlocal ts=4 sw=4
autocmd FileType php setlocal ts=2 sw=2
autocmd FileType json setlocal ts=2 sw=2
autocmd FileType javascript setlocal ts=2 sw=2
autocmd FileType typescript setlocal ts=2 sw=2

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
  augroup END
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" use <Tab> and <S-Tab> to navigate completion lists
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" confirm completeion using enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

"Split teminal on right side
:set splitright
" send paragraph under cursor to terminal
function! Exec_on_term(cmd)
  if a:cmd=="normal"
    exec "normal mk\"vyip"
  else
    exec "normal gv\"vy"
  endif
  if !exists("g:last_terminal_chan_id")
    vs
    terminal
    let g:last_terminal_chan_id = b:terminal_job_id
    wincmd p
  endif

  if getreg('"v') =~ "^\n"
    call chansend(g:last_terminal_chan_id, expand("%:p")."\n")
  else
    call chansend(g:last_terminal_chan_id, @v)
  endif
  exec "normal `k"
endfunction

nnoremap <F6> :call Exec_on_term("normal")<CR>
vnoremap <F6> :<c-u>call Exec_on_term("visual")<CR>
