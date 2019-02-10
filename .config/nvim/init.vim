""" GENERAL
syntax on
filetype plugin indent on

" https://neovim.io/doc/user/quickref.html
" some setting may be on by default
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
set hidden
set completeopt=longest,menuone,preview
set scrolloff=3
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set undodir=~/.config/nvim/undodir
set undofile

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

" This turns off Vim’s crazy default regex characters and makes searches use normal regexes
nnoremap / /\v
vnoremap / /\v

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
augroup autosourcing
    autocmd!
    autocmd! bufwritepost *.vim source %
augroup end

" Switch between the last two files
nnoremap <leader><leader> <c-^>
set autowrite

" Sudo saves the file 
" command W w !sudo tee % > /dev/null

""" PLUGINS
call plug#begin('~/.local/share/nvim/plugged')

" General
Plug 'tpope/vim-sensible'
Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Theming
Plug 'mhartington/oceanic-next'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File listing
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}

" Auto completion
Plug 'Shougo/deol.nvim'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'ervandew/supertab'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'rhysd/npm-debug-log.vim'
Plug 'cdata/vim-tagged-template'

" Buffer
Plug 'jlanzarotta/bufexplorer'
Plug 'schickling/vim-bufonly'
Plug 'wesQ3/vim-windowswap'

" Uncategorized
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'tpope/vim-obsession'
Plug 'RRethy/vim-illuminate'
Plug 'mileszs/ack.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'majutsushi/tagbar'

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
colorscheme OceanicNext
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

" NERDTree
let NERDTreeShowHidden=1
map <leader><Tab> :NERDTreeToggle<CR>

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='oceanicnext'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_preset = 'nightly_fox'
let g:airline_left_sep=''
let g:airline_right_sep=''

" Yankstack
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-n> <Plug>yankstack_substitute_newer_paste

" vim-illuminate
let g:Illuminate_ftblacklist = ['nerdtree']
let g:Illuminate_delay = 0

" ale auto fix
let g:alefixers = {'javascript': ['prettier', 'eslint']}
let g:ale_fix_on_save = 1

" FuzzySearch
map <leader>f :FZF<cr>

" ack.vim | ag & ack integration
let g:ackprg = 'ag --vimgrep'

" Deol
tnoremap <ESC>   <C-\><C-n>
map <leader>d :Deol<cr>

" Tagbar
nmap <leader><S-Tab> :TagbarToggle<CR>

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" Reserved
" Plug 'tomasr/molokai'
" Plug 'leafgarland/typescript-vim'
" Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'terryma/vim-multiple-cursors'
