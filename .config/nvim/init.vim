""" GENERAL
syntax on
filetype plugin indent on

" https://neovim.io/doc/user/quickref.html
" some settings may be on by default
set number
set autoread
set ruler
set ignorecase
set smartcase
set incsearch
set lazyredraw
set showmatch
set nowritebackup
set noswapfile
set expandtab
set shiftwidth=2
set smartindent
set cursorline
set wildmenu
set relativenumber
set linebreak
set splitright
set splitbelow
set hidden " coc.nvim, lsp-nvim
set completeopt=longest,menuone,preview
set scrolloff=3
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set undodir=~/.config/nvim/undodir
set undofile
set clipboard+=unnamedplus
set foldmethod=indent
set foldlevel=99
"set nobackup " coc.nvim
"set nowritebackup " coc.nvim
"set updatetime=300 " coc.nvim
"set shortmess+=c " coc.nvim
"set signcolumn=yes " coc.nvim

""" MAPPINGS
" Leader is space
let mapleader=" "

" move vertically by visual line with j,k
nnoremap j gj
nnoremap k gk

" Use tab in normal mode for next buffer
nmap <Tab> :bn<CR>

" Use shift tab in normal mode for previous buffer
nmap <S-Tab> :bp<CR>

" Remove highlight
nmap <leader>n :noh<CR>

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif

" Let 'tl' toggle between this and the last accessed tab
" let g:lasttab = 1
" nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
" au TabLeave * let g:lasttab = tabpagenr()

""" SCRIPTS
" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" fix jsx end-tag gets different color
hi link xmlEndTag xmlTag

" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.md,*.js,*.py,*.sh,*.yml :call CleanExtraSpaces()
endif

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Automatic reloading .vimrc
"augroup autosourcing
"    autocmd!
"    autocmd! bufwritepost *.vim source %
"augroup end

" Switch between the last two files
nnoremap <leader><leader> <c-^>
set autowrite

" Golang start

" file type indentation for golang
au FileType go set noexpandtab shiftwidth=8 softtabstop=8 tabstop=8

" syntax highlighting
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" go to definition
au FileType go nmap <F12> <Plug>(go-def)

" Golang end

" sync open file with NERDTree
" " Check if NERDTree is open or active
"function! IsNERDTreeOpen()        
"  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
"endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
"function! SyncTree()
"  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
"    NERDTreeFind
"    wincmd p
"  endif
"endfunction

" Highlight currently open buffer in NERDTree
"autocmd BufEnter * call SyncTree()

" Lsp-nvim
"nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" COC.nvim
" Auto-format code and add missing imports
"autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" COC.nvim use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

"augroup mygroup
"  autocmd!
" Setup formatexpr specified filetype(s).
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
"nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <C-d> <Plug>(coc-range-select)
"xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Sudo saves the file 
" command W w !sudo tee % > /dev/null

""" PLUGINS
call plug#begin('~/.local/share/nvim/plugged')

" General
Plug 'tpope/vim-sensible'

" Theming
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File listing
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}

" Auto completion
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deol.nvim'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
 
" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Typescript
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'

" Buffer
Plug 'jlanzarotta/bufexplorer'
Plug 'schickling/vim-bufonly'
Plug 'wesQ3/vim-windowswap'

" Version control
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim', {'on': 'GV'}

" Uncategorized
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
Plug 'tpope/vim-obsession'
Plug 'RRethy/vim-illuminate'
Plug 'mileszs/ack.vim'
Plug 'edkolev/tmuxline.vim'
"Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'rhysd/conflict-marker.vim'
Plug 'rhysd/clever-f.vim'

call plug#end()

" Buffer explorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>

" Deoplete.
let g:deoplete#enable_at_startup = 1

" Theme
colorscheme nord

" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeGitStatusWithFlags = 1
map <leader><Tab> :NERDTreeToggle<CR>

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:tmuxline_preset = 'nightly_fox'

let g:airline#extensions#ale#enabled = 1
" Yankstack
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-n> <Plug>yankstack_substitute_newer_paste

" Vim-illuminate
let g:Illuminate_ftblacklist = ['nerdtree']
let g:Illuminate_delay = 0

" Vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Ale
let g:ale_fixers = {
    \ 'go': ['gopls'],
    \ 'javascript': ['prettier', 'eslint']
    \ }
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
"let g:ale_fix_on_save = 1
"map <leader>x :ALEFix<cr>

" FuzzySearch
map <leader>f :FZF<cr>

" ack.vim | ag & ack integration
"let g:ackprg = 'ag --vimgrep'

" Deol
tnoremap <ESC>   <C-\><C-n>
map <leader>d :Deol<cr>

" Tagbar
"nmap <leader><S-Tab> :TagbarToggle<CR>

" UltiSnips
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" COC
" let g:coc_global_extensions = [
"   \ 'coc-snippets',
"   \ 'coc-pairs',
"   \ 'coc-tsserver',
"   \ 'coc-eslint', 
"   \ 'coc-prettier', 
"   \ 'coc-json', 
"   \ ]

" Lsp-nvim
let g:LanguageClient_serverCommands = {
    \ 'go': ['gopls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ }

" Reserved
"Plug 'morhetz/gruvbox'
"Plug 'majutsushi/tagbar'
"Plug 'honza/vim-snippets'
"Plug 'cdata/vim-tagged-template'
"Plug 'terryma/vim-multiple-cursors'
"Plug 'junegunn/rainbow_parentheses.vim'
"Plug 'ervandew/supertab'
"Plug 'SirVer/ultisnips'
"Plug 'rhysd/npm-debug-log.vim'
