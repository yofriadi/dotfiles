set termguicolors  " use true color
set guicursor=n:blinkon1  " set blinking cursor
" syntax enable  " enable syntax processing
set shiftwidth=2  " 1 tab = 2 spaces
set tabstop=2  " number of visual spaces per tab
set softtabstop=2  " number of spaces in tab when editing
set expandtab  " tabs are spaces
set smarttab  " Be smart when using tabs
set number  " show line number
set showcmd  " show command in bottom bar 
set cursorline  " highlight current line
set wildmenu  " visual autocomplete for command menu
set lazyredraw  " redraw only when need to
set showmatch  " highlight matching
set mat=2  " How many tenths of a second to blink when matching brackets
" set incsearch  " search as characters are entered
set hlsearch  " highlight matches search
set foldenable  " enable folding
set autoread  " Set to auto read when a file is changed from the outside
set so=2  " Set 3 lines to the cursor - when moving vertically using j/k
set ruler  " Always show current position
set mouse=""  " disable mouse/trackpad
set hid  " A buffer becomes hidden when it is abandoned
set ignorecase  " Ignore case when searching
set smartcase  " When searching try to be smart about cases 
set magic  " For regular expressions turn magic on
set background=dark  "set background to dark
set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines
set autoread  " refresh file if changed from outside

let mapleader=" "  " leader is space

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" move vertically by visual line, no skipping fake line
nnoremap j gj
nnoremap k gk
nnoremap gV `[v`]

" persistence undo
set undodir=~/.config/nvim/undodir
set undofile

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Specify a directory for Vim plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Make sure you use single quotes

Plug 'tomasr/molokai'
Plug 'tpope/vim-sensible'
"Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'edkolev/tmuxline.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'junegunn/gv.vim', {'on': 'GV'}
" Plug 'terryma/vim-multiple-cursors'

" Javascript language support
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'rhysd/npm-debug-log.vim'
Plug 'cdata/vim-tagged-template'

" On-demand loading
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}

" Initialize plugin system
call plug#end()

colorscheme molokai

" NERDTree
let NERDTreeShowHidden=1
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

" Use deoplete.
"let g:deoplete#enable_at_startup = 1

" q
" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dark'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_preset = 'nightly_fox'
let g:airline_left_sep=''
let g:airline_right_sep=''

" Yankstack
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-n> <Plug>yankstack_substitute_newer_paste
