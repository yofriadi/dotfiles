set termguicolors  " Use true color
set guicursor=n:blinkon1  " Set blinking cursor
set shiftwidth=2  " 1 tab = 2 spaces
set tabstop=2  " Number of visual spaces per tab
set softtabstop=2  " Number of spaces in tab when editing
set expandtab  " Tabs are spaces
set smarttab  " Be smart when using tabs
set number  " Show line number
set showcmd  " Show command in bottom bar 
set cursorline  " Highlight current line
set wildmenu  " Visual autocomplete for command menu
set lazyredraw  " Redraw only when need to
set showmatch  " Highlight matching
set mat=2  " How many tenths of a second to blink when matching brackets
set hlsearch  " Highlight matches search
set foldenable  " Enable folding
set autoread  " Set to auto read when a file is changed from the outside
set so=2  " Set 3 lines to the cursor - when moving vertically using j/k
set ruler  " Always show current position
set mouse=""  " disable mouse/trackpad
set hid  " A buffer becomes hidden when it is abandoned
set ignorecase  " Ignore case when searching
set smartcase  " When searching try to be smart about cases 
set magic  " For regular expressions turn magic on
set background=dark
set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines
set whichwrap+=<,>,h,l  " cursor move beyond edges
" set noshowmode
" set noruler
" set laststatus=0
" set noshowcmd
set autoread  " refresh file if changed from outside
" syntax enable  " enable syntax processing
" set incsearch  " search as characters are entered

let mapleader=" "  " Leader is space
let s:hidden_all = 1

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off
set nobackup
set nowb
set noswapfile

" move vertically by visual line, no skipping fake line
nnoremap j gj
nnoremap k gk
nnoremap gV `[v`]

nmap <Tab> :bn<CR>
nmap <S-Tab> :bp<CR>

" persistence undo
" set undodir=~/.config/nvim/undodir
" set undofile

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Vim Plug
call plug#begin('~/.local/share/nvim/plugged')
" Plug 'tomasr/molokai'
Plug 'mhartington/oceanic-next'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'edkolev/tmuxline.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-obsession'
Plug 'RRethy/vim-illuminate'
Plug 'mileszs/ack.vim'
Plug 'Shougo/deol.nvim'

" Javascript language support
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'rhysd/npm-debug-log.vim'
Plug 'cdata/vim-tagged-template'
Plug 'leafgarland/typescript-vim'
call plug#end()

" Reserved for later
" Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" Plug 'terryma/vim-multiple-cursors'

" Use deoplete.
" let g:deoplete#enable_at_startup = 1

" Theme
colorscheme OceanicNext
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

" NERDTree
let NERDTreeShowHidden=1
map <leader>n :NERDTreeToggle<cr>

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

" fix jsx end-tag gets different color
hi link xmlEndTag xmlTag

" FuzzySearch
map <leader>f :FZF<cr>

" ack.vim | ag & ack integration
let g:ackprg = 'ag --vimgrep'

" Deol
tnoremap <ESC>   <C-\><C-n>
map <leader>d :Deol<cr>
